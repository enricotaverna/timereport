var DataTree = function(table){
	this.table = table;
	this.indent = 10;
	this.field = "";
	this.collapseEl = null;
	this.expandEl = null;
	this.branchEl = null;
	this.elementField = false;

	this.startOpen = function(){};

	this.displayIndex = 0;
};

DataTree.prototype.initialize = function(){
	var dummyEl = null,
	options = this.table.options;

	this.field = options.dataTreeChildField;
	this.indent = options.dataTreeChildIndent;
	this.elementField = options.dataTreeElementColumn;

	if(options.dataTreeBranchElement){

		if(options.dataTreeBranchElement === true){
			this.branchEl = document.createElement("div");
			this.branchEl.classList.add("tabulator-data-tree-branch");
		}else{
			if(typeof options.dataTreeBranchElement === "string"){
				dummyEl = document.createElement("div");
				dummyEl.innerHTML = options.dataTreeBranchElement;
				this.branchEl = dummyEl.firstChild;
			}else{
				this.branchEl = options.dataTreeBranchElement;
			}
		}
	}

	if(options.dataTreeCollapseElement){
		if(typeof options.dataTreeCollapseElement === "string"){
			dummyEl = document.createElement("div");
			dummyEl.innerHTML = options.dataTreeCollapseElement;
			this.collapseEl = dummyEl.firstChild;
		}else{
			this.collapseEl = options.dataTreeCollapseElement;
		}
	}else{
		this.collapseEl = document.createElement("div");
		this.collapseEl.classList.add("tabulator-data-tree-control");
		this.collapseEl.innerHTML = "<div class='tabulator-data-tree-control-collapse'></div>";
	}

	if(options.dataTreeExpandElement){
		if(typeof options.dataTreeExpandElement === "string"){
			dummyEl = document.createElement("div");
			dummyEl.innerHTML = options.dataTreeExpandElement;
			this.expandEl = dummyEl.firstChild;
		}else{
			this.expandEl = options.dataTreeExpandElement;
		}
	}else{
		this.expandEl = document.createElement("div");
		this.expandEl.classList.add("tabulator-data-tree-control");
		this.expandEl.innerHTML = "<div class='tabulator-data-tree-control-expand'></div>";
	}


	switch(typeof options.dataTreeStartExpanded){
		case "boolean":
		this.startOpen = function(row, index){
			return options.dataTreeStartExpanded;
		};
		break;

		case "function":
		this.startOpen = options.dataTreeStartExpanded;
		break;

		default:
		this.startOpen = function(row, index){
			return options.dataTreeStartExpanded[index];
		};
		break;
	}
};

DataTree.prototype.initializeRow = function(row){

	var children = typeof row.getData()[this.field] !== "undefined";

	row.modules.dataTree = {
		index:0,
		open:children ? this.startOpen(row.getComponent(), 0) : false,
		controlEl:false,
		branchEl:false,
		parent:false,
		children:children,
	};
};


DataTree.prototype.layoutRow = function(row){
	var cell = this.elementField ? row.getCell(this.elementField) : row.getCells()[0],
	el = cell.getElement(),
	config = row.modules.dataTree;

	el.style.paddingLeft = parseInt(window.getComputedStyle(el, null).getPropertyValue('padding-left')) + (config.index * this.indent) + "px";

	if(config.branchEl){
		config.branchEl.parentNode.removeChild(config.branchEl);
	}

	this.generateControlElement(row, el);

	if(config.index && this.branchEl){
		config.branchEl = this.branchEl.cloneNode(true);
		el.insertBefore(config.branchEl, el.firstChild);
		el.style.paddingLeft = (parseInt(el.style.paddingLeft) + ((config.branchEl.offsetWidth + config.branchEl.style.marginRight) * (config.index - 1))) + "px";
	}
};

DataTree.prototype.generateControlElement = function(row, el){
	var config = row.modules.dataTree,
	el = el || row.getCells()[0].getElement(),
	oldControl = config.controlEl;

	if(config.children !== false){

		if(config.open){
			config.controlEl = this.collapseEl.cloneNode(true);
			config.controlEl.addEventListener("click", (e) => {
				e.stopPropagation();
				this.collapseRow(row);
			});
		}else{
			config.controlEl = this.expandEl.cloneNode(true);
			config.controlEl.addEventListener("click", (e) => {
				e.stopPropagation();
				this.expandRow(row);
			});
		}

		config.controlEl.addEventListener("mousedown", (e) => {
			e.stopPropagation();
		});

		if(oldControl && oldControl.parentNode === el){
			oldControl.parentNode.replaceChild(config.controlEl,oldControl);
		}else{
			el.insertBefore(config.controlEl, el.firstChild);
		}
	}
};

DataTree.prototype.setDisplayIndex = function (index) {
	this.displayIndex = index;
};

DataTree.prototype.getDisplayIndex = function () {
	return this.displayIndex;
};

DataTree.prototype.getRows = function(rows){
	var output = [];

	rows.forEach((row, i) => {
		var config, children;

		output.push(row);

		if(row instanceof Row){

			config = row.modules.dataTree.children;

			if(!config.index && config.children !== false){
				children = this.getChildren(row);

				children.forEach((child) => {
					output.push(child);
				});
			}
		}
	});

	return output;
};


DataTree.prototype.getChildren = function(row){
	var config = row.modules.dataTree,
	children = [],
	output = [];

	if(config.children !== false && config.open){
		if(!Array.isArray(config.children)){
			config.children = this.generateChildren(row);
		}

		if(this.table.modExists("filter")){
			children = this.table.modules.filter.filter(config.children);
		}else{
			children = config.children;
		}

		if(this.table.modExists("sort")){
			this.table.modules.sort.sort(children);
		}

		children.forEach((child) => {
			output.push(child);

			var subChildren = this.getChildren(child);

			subChildren.forEach((sub) => {
				output.push(sub);
			});
		});
	}

	return output;
};


DataTree.prototype.generateChildren = function(row){
	var children = [];

	row.getData()[this.field].forEach((childData) => {
		var childRow = new Row(childData || {}, this.table.rowManager);
		childRow.modules.dataTree.index = row.modules.dataTree.index + 1;
		childRow.modules.dataTree.parent = row;
		childRow.modules.dataTree.open = this.startOpen(row, childRow.modules.dataTree.index);
		children.push(childRow);
	});

	return children;
};



DataTree.prototype.expandRow = function(row, silent){
	var config = row.modules.dataTree;

	if(config.children !== false){
		config.open = true;

		row.reinitialize();

		this.table.rowManager.refreshActiveData("tree", false, true);

		this.table.options.dataTreeRowExpanded(row.getComponent(), row.modules.dataTree.index);
	}
};

DataTree.prototype.collapseRow = function(row){
	var config = row.modules.dataTree;

	if(config.children !== false){
		config.open = false;

		row.reinitialize();

		this.table.rowManager.refreshActiveData("tree", false, true);

		this.table.options.dataTreeRowCollapsed(row.getComponent(), row.modules.dataTree.index);
	}
};

DataTree.prototype.toggleRow = function(row){
	var config = row.modules.dataTree;

	if(config.children !== false){
		if(config.open){
			this.collapseRow(row);
		}else{
			this.expandRow(row);
		}
	}
};

DataTree.prototype.getTreeParent = function(row){
	return row.modules.dataTree.parent ? row.modules.dataTree.parent.getComponent() : false;
};

DataTree.prototype.getTreeChildren = function(row){
	var config = row.modules.dataTree,
	output = [];

	if(config.children){

		if(!Array.isArray(config.children)){
			config.children = this.generateChildren(row);
		}

		config.children.forEach((childRow) => {
			if(childRow instanceof Row){
				output.push(childRow.getComponent());
			}
		});
	}

	return output;
};


DataTree.prototype.checkForRestyle = function(cell){
	if(!cell.row.cells.indexOf(cell)){
		if(cell.row.modules.dataTree.children !== false){
			cell.row.reinitialize();
		}
	}
};

DataTree.prototype.getChildField = function(){
	return this.field;
};

Tabulator.prototype.registerModule("dataTree", DataTree);