<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ForcedAccounts.aspx.cs" Inherits="m_gestione_ForzaUtenti_imposta_valori_utenti" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<%--<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">--%>
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<!-- Tabulator  -->
<script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>
<%--<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>--%>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<!-- Download excel da Tabulator -->
<link href="https://use.fontawesome.com/releases/v6.7.2/css/all.css" rel="stylesheet">
<!-- gestione formati data per tabulator -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/luxon@2.3.1/build/global/luxon.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Autorizza Ore e Spese" /></title>
    <style>
        /* Forza l'altezza a zero per la classe tabulator-header nell'elemento SelectableProjectsTable */
        #SelectableProjectsTable .tabulator-col-title {
            height: 0;
        }
    </style>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <!-- lo stile è cambiato per consentire l'adattamento  -->
        <form name="form1" runat="server" style="overflow-y: visible">

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-9">

                    <div id="tabs" style="display: none">

                        <ul>
                            <li><a href="#tabs-1">Progetti</a></li>
                            <li><a href="#tabs-2">Spese</a></li>
                        </ul>

                        <div id="tabs-1" style="height: 450px; width: 100%; margin-left: 10px">

                            <!-- *** spazio bianco nel form ***  -->
                            <p style="margin-bottom: 20px"></p>

                            <div class="col-12">

                                <div class="d-flex align-items-center">
                                    <label for="LBProgetti">Progetto: </label>
                                    <asp:DropDownList ID="LBProgetti" runat="server" DataSourceID="DSProgetti" Style="width: 250px; margin: 0px 20px 0px 20px"
                                        DataTextField="ProjectName" DataValueField="Projects_Id" Rows="30" AppendDataBoundItems="True">
                                        <asp:ListItem Text="-- Selezionare un progetto --" Value="" />
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="LBPersone" runat="server" DataSourceID="DSPersone" Style="width: 200px; margin: 0px 20px 0px 20px"
                                        DataTextField="Name" DataValueField="Persons_Id" Rows="30" AppendDataBoundItems="True">
                                        <asp:ListItem Text="-- Selezionare un nome --" Value="" />
                                    </asp:DropDownList>

                                    <button id="BTaddProject" class="orangebutton" style="float: none; margin-top: 0px" type="button">Aggiungi</button>
                                </div>

                                <div style="border: 1px solid; border-color: #C7C7C7; margin-top: 20px; width: 98%" id="ForcedAccountsTable"></div>

                            </div>

                        </div>
                        <%--tabs-1--%>

                        <div id="tabs-2" style="height: 450px; width: 100%">

                            <!-- *** spazio bianco nel form ***  -->
                            <p style="margin-bottom: 20px"></p>

                            <div class="col-12">

                                <div class="d-flex align-items-center">
                                    <label for="LBSpese">Spesa: </label>
                                    <asp:DropDownList ID="LBSpese" runat="server" DataSourceID="DSExpenseType" Style="width: 250px; margin: 0px 20px 0px 20px"
                                        DataTextField="ExpenseTypeName" DataValueField="ExpenseType_Id" Rows="30" AppendDataBoundItems="True">
                                        <asp:ListItem Text="-- Selezionare una spesa --" Value="" />
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="LBPersone2" runat="server" DataSourceID="DSPersone" Style="width: 200px; margin: 0px 20px 0px 20px"
                                        DataTextField="Name" DataValueField="Persons_Id" Rows="30" AppendDataBoundItems="True">
                                        <asp:ListItem Text="-- Selezionare un nome --" Value="" />
                                    </asp:DropDownList>

                                    <button id="BTaddExpense" class="orangebutton" style="float: none; margin-top: 0px" type="button">Aggiungi</button>
                                </div>

                                <div style="border: 1px solid; border-color: #C7C7C7; margin-top: 20px; width: 98%" id="ForcedExpensesTable"></div>

                            </div>

                            <%--                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                --%>
                        </div>
                        <%--tabs-2--%>

                        <!-- *** BOTTONI ***  -->
                        <div class="buttons">
                            <asp:Button ID="BTSave" runat="server" CausesValidation="True" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                            <asp:Button ID="BTDownload" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" />
                            <asp:Button ID="BTCancel" runat="server" CausesValidation="False" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" />
                        </div>

                    </div>

                </div>
                <!-- FormWrap -->
            </div>
            <!-- LastRow -->
        </form>
        <!-- Form  -->
    </div>
    <!-- container -->

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DSProgetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ProjectCode + ' ' + left(Name,20) AS ProjectName, Projects_Id FROM Projects WHERE (Active = 1) ORDER BY ProjectName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSPersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSExpenseType" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ExpenseCode + ' ' + left(Name,20) AS ExpenseTypeName, ExpenseType_Id FROM ExpenseType WHERE (Active = 1) ORDER BY ExpenseTypeName"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $("#tabs").tabs(); // abilitate tab view
        $("#tabs").show();

        var mustSave = false;

        $('#LBProgetti, #LBPersone, #LBSpese, #LBPersone2').SumoSelect({ search: true });

        $('#LBPersone').change(function () {
            var selectedValue = $(this).val();
            $('#LBPersone2')[0].sumo.selectItem(selectedValue);
        });

        $('#LBPersone2').change(function () {
            var selectedValue = $(this).val();
            $('#LBPersone')[0].sumo.selectItem(selectedValue);
        });

        $('#BTCancel').click(function (e) {
            e.preventDefault();

            if (mustSave)
                ConfirmDialog("Salvataggio", "Ci sono modifiche non salvate, vuoi uscire?", "Esci",
                    (result) => { result && ( window.location.href = "/timereport/m_gestione/ForzaUtenti/selection-utenti.aspx" ) });
            else
                window.location.href = "/timereport/m_gestione/ForzaUtenti/selection-utenti.aspx";
        });

        // ** TABULATOR **

        /** Tabella Progetti forzati */
        var ForcedAccountsTable = new Tabulator("#ForcedAccountsTable", {
            maxHeight: "350px",
            layout: "fitColumns", 
            ajaxURL: "/timereport/webservices/WS_ForcedAccounts.asmx/GetForcedProjects", 
            ajaxParams: { persons_id: '<%= sPersonaSelezionata %>' }, 
            ajaxConfig: "POST", 
            ajaxContentType: "json", 
            ajaxResponse: function (url, params, response) {
                return JSON.parse(response.d); 
            },
            columns: [
                { title: "ForcedAccounts_id", field: "ForcedAccounts_id", visible: false },
                { title: "Persons_id", field: "Persons_id", visible: false },
                { title: "Projects_id", field: "Projects_id", visible: false },
                { title: "RecordToUpdate", field: "RecordToUpdate", visible: false },
                { title: "CreationDate", field: "CreationDate", visible: false },
                { title: "CreatedBy", field: "CreatedBy", visible: false },
                { title: "LastModificationDate", field: "LastModificationDate", visible: false },
                { title: "LastModifiedBy", field: "LastModifiedBy", visible: false },
                { title: "Project Name", width: 300, field: "ProjectName", sorter: "string", headerFilter: true },
                { title: "Consulente", width: 200, field: "PersonName", sorter: "string", headerFilter: true },
                { title: "Da", field: "DataDa", editor: "date", editorParams: { format: "dd/MM/yyyy" }, headerFilter: false, cellEdited: function (cell) { CellEdited(cell); } },
                { title: "A", field: "DataA", editor: "date", editorParams: { format: "dd/MM/yyyy" }, headerFilter: false, cellEdited: function (cell) { CellEdited(cell); } },
                { title: "Budget", field: "DaysBudget", sorter: "string", editor: "number", editorParams: { min: 0, max: 100, step: 1, }, headerFilter: false, cellEdited: function (cell) { CellEdited(cell); } },
                { title: "Actual", field: "DaysActual", sorter: "string", headerFilter: false },
                { formatter: trashIcon, width: 40, cellClick: function (e, cell) { DeletePrjRow(e, cell); } },
                {
                    formatter: infoIcon, width: 40, tooltip: function (e, cell) {
                        var creationDate = cell.getRow().getData().CreationDate != null ?  cell.getRow().getData().CreationDate.toString() : '';
                        var lastModification = cell.getRow().getData().LastModificationDate != null ? " - Updated by: " + cell.getRow().getData().LastModifiedBy  + " on " + cell.getRow().getData().LastModificationDate.toString() : '' ;
                        return "Created by: " + cell.getRow().getData().CreatedBy + " on " + creationDate + lastModification;
                    }
                }
            ],
        }); // Tabella SelectableProjectsTable

        // ** EVENTI TRIGGER **

        // cancellazione riga
        function DeletePrjRow(e, cell) { 

            var ForcedAccounts_id = cell.getRow().getData().ForcedAccounts_id;
            mustSave = true;

            if ( ForcedAccounts_id == 0)
                cell.getRow().delete()  // riga ancora non salvata
            else {
                cell.getRow().getData().RecordToUpdate = 'D';
                ForcedAccountsTable.addFilter("ForcedAccounts_id", "!=", ForcedAccounts_id);
            }              
        };

        // accendo flag di aggiornamento su rige modificate
        function CellEdited(cell) { 
            mustSave = true;
            var row = cell.getRow();
            //row - row component
            if (row.getData().RecordToUpdate != 'I')
                row.getData().RecordToUpdate = 'U';
        };

        // quando viene premuto il bottone BTaddProject aggiunge una riga alla tabella ForcedAccountsTable
        $("#BTaddProject").click(function () {
            var Project_id = $("#LBProgetti").val();
            var Person_id = $("#LBPersone").val();

            mustSave = true;

            if (isNullOrEmpty(Project_id) | isNullOrEmpty(Person_id)) {
                ShowPopup("Selezionare progetto e consulente");
                return;
            }

            var ProjectName = $("#LBProgetti option:selected").text();
            var Consulente = $("#LBPersone option:selected").text();

            var row = { ForcedAccounts_id: 0, Persons_id: Person_id, PersonName: Consulente, Projects_id: Project_id, ProjectName: ProjectName, DataDa: null, DataA: null, DaysBudget: null, DaysACT: null, RecordToUpdate: 'I' };
            var tableData = ForcedAccountsTable.getData();

            // controlla che il progetto non esista già nella lista
            for (var i = 0; i < tableData.length; i++) {
                var record = tableData[i];
                if (record["Projects_id"] == Project_id && record["Persons_id"] == Person_id) {
                    ShowPopup("Progetto già presente nella lista");
                    return;
                }
            }
            ForcedAccountsTable.addData(row, true);
            // pulisce input
            $("#SelectableProjects").val("");
        });

        // quando viene premuto il bottone BTSave salva i dati della tabella ForcedAccountsTable
        $("#BTSave").click(function (e) {

            e.preventDefault();

            if ($("#tabs").tabs("option", "active") == 0) {
                // salvataggio ore

                var dataToPost = []; // array vuoto
                ForcedAccountsTable.clearFilter(); // rimuove i filtri per avere anche i record cancellati in tabella
                var tableData = ForcedAccountsTable.getData();

                for (var i = 0; i < tableData.length; i++) {
                    var record = tableData[i];

                    if ( isNullOrEmpty(record["RecordToUpdate"]) )
                        continue;

                    // validazione dati inseriti
                    if (
                         isNullOrZero(record["DaysBudget"]) & ( !isNullOrEmpty(record["DataDa"]) | !isNullOrEmpty(record["DataA"]) ) |
                        !isNullOrZero(record["DaysBudget"]) & (  isNullOrEmpty(record["DataDa"]) |  isNullOrEmpty(record["DataA"]) )
                       ) {
                        ShowPopup("Controllare dati tabella, completare dati di budget giornate per progetto " + record["ProjectName"] + " e consulente " + record["PersonName"]);
                        return;
                    }

                    dataToPost.push(JSON.stringify(record));
                }

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WS_ForcedAccounts.asmx/SaveProjectsTable",
                    data: JSON.stringify({ ForcedAccountsTable: dataToPost }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true) {
                            ShowPopup("Salvataggio avvenuto");
                            ForcedAccountsTable.setData(); // reload
                            mustSave = false;
                        } else
                            ShowPopup("Errore in salvataggio tabella");
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore server in salvataggio tabella");
                        return false;
                    }

                });
            }
            else {
                // salvataggio spese

                var dataToPost = []; // array vuoto
                ForcedExpensesTable.clearFilter(); // rimuove i filtri per avere anche i record cancellati in tabella
                var tableData = ForcedExpensesTable.getData();

                // inserisce solo i valori da aggiornare
                for (var i = 0; i < tableData.length; i++) {
                    var record = tableData[i];
                    if (isNullOrEmpty(record["RecordToUpdate"]))
                        continue;                   
                    dataToPost.push(JSON.stringify(record));
                }

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WS_ForcedAccounts.asmx/SaveExpensesTable",
                    data: JSON.stringify({ExpensesTable : dataToPost }), 
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true) {
                            ShowPopup("Salvataggio avvenuto");
                            ForcedExpensesTable.setData(); // reload
                            mustSave = false;
                        } else
                            ShowPopup("Errore in salvataggio tabella");
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore server in salvataggio tabella");
                        return false;
                    }
                });
            }
        });

        /** Tabella Spese forzate */
        var ForcedExpensesTable = new Tabulator("#ForcedExpensesTable", {           
            maxHeight: "350px",
            layout: "fitColumns", 
            ajaxURL: "/timereport/webservices/WS_ForcedAccounts.asmx/GetForcedExpenses", 
            ajaxParams: { persons_id: '<%= sPersonaSelezionata %>' }, 
            ajaxConfig: "POST",
            ajaxContentType: "json", 
            ajaxResponse: function (url, params, response) {
                return JSON.parse(response.d); 
            },
            columns: [
                { title: "ForcedExpensesPers_id", field: "ForcedExpensesPers_id", sorter: "number", visible: false },
                { title: "Persons_id", field: "Persons_id", sorter: "number", visible: false },
                { title: "ExpenseType_id", field: "ExpenseType_id", sorter: "number", visible: false },
                { title: "RecordToUpdate", field: "RecordToUpdate", visible: false },
                { title: "CreationDate", field: "CreationDate", visible: false },
                { title: "CreatedBy", field: "CreatedBy", visible: false },
                { title: "Spesa", field: "ExpenseTypeName", sorter: "string", headerFilter: true },
                { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: true },
                { formatter: trashIcon, width: 40, cellClick: function (e, cell) { DeleteExpRow(e, cell); } },
                {
                    formatter: infoIcon, width: 40, tooltip: function (e, cell) {
                        var creationDate = cell.getRow().getData().CreationDate != null ? "Created by " + cell.getRow().getData().CreatedBy + " on " + cell.getRow().getData().CreationDate.toString() : '';
                    return  creationDate;
                    }
                }
            ],
        }); 

        // ** EVENTI TRIGGER **

        // cancellazione riga
        function DeleteExpRow(e, cell) {

            mustSave = true;
            var ForcedExpensesPers_id = cell.getRow().getData().ForcedExpensesPers_id;

            if (ForcedExpensesPers_id == 0)
                cell.getRow().delete()  // riga ancora non salvata
            else {
                cell.getRow().getData().RecordToUpdate = 'D';
                ForcedExpensesTable.addFilter("ForcedExpensesPers_id", "!=", ForcedExpensesPers_id);
            }
        };

        // quando viene premuto il bottone BTaddProject aggiunge una riga alla tabella ForcedAccountsTable
        $("#BTaddExpense").click(function () {

            mustSave = true;

            var Expense_id = $("#LBSpese").val();
            var Person_id = $("#LBPersone2").val();

            if (isNullOrEmpty(Expense_id) | isNullOrEmpty(Person_id) ) {
                ShowPopup("Selezionare spesa e consulente");
                return;
            }

            var Spesa = $("#LBSpese option:selected").text();
            var Consulente = $("#LBPersone2 option:selected").text();

            var row = { ForcedExpensesPers_id: 0, Persons_id: Person_id, ExpenseType_id: Expense_id, ExpenseTypeName: Spesa, PersonName: Consulente, RecordToUpdate: 'I' };
            var tableData = ForcedExpensesTable.getData();

            // controlla che il progetto non esista già nella lista
            for (var i = 0; i < tableData.length; i++) {
                var record = tableData[i];
                if (record["ExpenseType_id"] == Expense_id && record["Persons_id"] == Person_id) {
                    ShowPopup("Spesa già presente nella lista");
                    return;
                }
            }
            ForcedExpensesTable.addData(row, true);

        });

        // trigger download of data.xlsx file
        $("#BTDownload").click(function () {
            ForcedAccountsTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
            ForcedExpensesTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
        });

    </script>

</body>

</html>
