//         
// ***
// *** gestione validation summary su validator custom *** //
// ***
var displayAlert = function () {
    if (typeof Page_Validators == 'undefined') return;

    var groups = [];
    for (i = 0; i < Page_Validators.length; i++)
        if (!Page_Validators[i].isvalid) {
            if (!groups[Page_Validators[i].validationGroup]) {
                ValidationSummaryOnSubmit(Page_Validators[i].validationGroup);
                groups[Page_Validators[i].validationGroup] = true;
            }
        }
};

// forza il trigger di un link sul client per avviare il download di un file
function triggeFileExport(filename) {

    // se non c'è la div mask la aggiunge
    if (document.getElementById("exportLink") == null)
        $("body").append("<a id = 'exportLink' href = '/public/" + filename + "' ></a> ");

    $('#exportLink')[0].click();
}

// dialogo con richiesta scelta utente
function ConfirmDialog(title, message, testoTasto, callback) {

    // se non c'è la div mask la aggiunge
    if (document.getElementById("dialog-confirm") == null) {
        var stringToAppend = "<div id='dialog-confirm' title='" + title + "'>" +
            "<p>" + message + "</p></div>";

        $("body").append(stringToAppend);
    }

    $('#dialog-confirm').dialog({
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: [
            {
                text: testoTasto,
                "class": 'orangebutton',
                click: function () {
                    UnMaskScreen();
                    $(this).dialog("close");
                    if (typeof callback === "function") 
                        callback(true);                    
                }
            },
            {
                text: "Annulla",
                "class": 'greybutton',
                /*"class": 'cancelButtonClass',*/
                click: function () {                    
                    $(this).dialog("close");
                    if (typeof callback === "function")
                        callback(false);     
                }
            }
        ],
        open: function () {
             $('.ui-widget-overlay').addClass('custom-overlay');
        },          
        close: function () {
            $(this).dialog("close");
        }
    });
}

// ** NB: deve essere aggiunto un DIV dialog nel corpo HTML
function ShowPopup(message, url, titleBox) {

        if (titleBox == null)
            titleBox = "Messaggio";

        // se non c'è la div mask la aggiunge
        if (document.getElementById("dialog") == null)
            $("body").append("<div id='dialog'></div>");

        $("#dialog").html(message);

        $("#dialog").dialog({
            title: titleBox,
            //classes: {
            //    "ui-dialog": "dialogMessage"
            //},
            modal: true,
            buttons:
            {
                Close: function () {
                    $(this).dialog('close');
;
                    if (url != undefined && url != '' )
                        window.location.href = url;
                }
            },
            open: function () {
                $('.ui-widget-overlay').addClass('custom-overlay');
            },          
        });
};

//custom formatter definition
var trashIcon = function (cell, formatterParams, onRendered) { //plain text value
    return "<i class='fa fa-trash'></i>";
};

//custom formatter definition
var editIcon = function (cell, formatterParams, onRendered) { //plain text value
    return "<i class='fa fa-edit'></i>";
};

// Apre Form Modale
function openDialogForm(ModalForm) {

    MaskScreen(false);

    //Get the window height and width
    //var winW = 960;
    var winW = $(window).width();

    //Set the popup window to center
    $(ModalForm).css('top', 40);
    $(ModalForm).css('left', winW / 2 - $(ModalForm).width() / 2);

    //transition effect
    $(ModalForm).fadeIn(1);

    // reset validations
    $('#FVForm').parsley().reset();

}

// Maschera lo schermo con una effetto Fade
// wait true -> cursone di attesa
function MaskScreen(wait=true) {

    // se non c'è la div mask la aggiunge
    if (document.getElementById("mask") == null) {
        $("body").append("<div id='mask'></div>");
    }

    // Mostra la maschera e lo spinner
    $("#mask").show();

    // se non c'è la div spinner la aggiunge
    if (wait) {
        if (document.getElementById("spinner") == null ) 
            $("body").append("<div id='spinner'><div class='spinner'></div></div>");
        $("#spinner").show();
    }

}

// Riporta lo schermo alla normalità//
function UnMaskScreen() {

    // Nasconde la maschera e lo spinner
    $("#mask").hide();
    $("#spinner").hide();

    document.body.style.cursor = 'default';

}

// Blocca postkback a seguito con pressione INVIO
function stopPostbackWithEnter() {
    document.addEventListener("keydown", function (event) {
        // Verifica se il tasto premuto è "Enter"
        if (event.key === "Enter") {
            let activeElement = document.activeElement;

            // Se l'elemento attualmente in focus è un TextBox, impedisci il postback
            if (activeElement.tagName === "INPUT" && activeElement.type === "text") {
                event.preventDefault(); // Impedisce il postback
            }
        }
    });

}

// include Html Menu
function includeHTML() {
    var z, i, elmnt, file, xhttp;
    /* Loop through a collection of all HTML elements: */
    z = document.getElementsByTagName("*");
    for (i = 0; i < z.length; i++) {
        elmnt = z[i];
        /*search for elements with a certain atrribute:*/
        file = elmnt.getAttribute("include-html");
        if (file) {
            /* Make an HTTP request using the attribute value as the file name: */
            xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4) {
                    if (this.status == 200) { elmnt.innerHTML = this.responseText; }
                    if (this.status == 404) { elmnt.innerHTML = "Page not found."; }
                    /* Remove the attribute, and call this function once more: */
                    elmnt.removeAttribute("include-html");
                    includeHTML();
                }
            }
            xhttp.open("GET", file, true);
            xhttp.send();
            /* Exit the function: */
            return;
        }
    }
}

function InitPage(Bkgcolor, BkgImg) {
    //$('.MainWindowBackground').css("background-color", "<%=CurrentSession.BackgroundColor%>");
    if (Bkgcolor != "")
        $('.MainWindowBackground').css("background-color", Bkgcolor);

    if (BkgImg != "") {
        $('.MainWindowBackground').css("background-image", BkgImg);
        $('.MainWindowBackground').css("background-size", "cover");
    }
}

function downloadExcel(jsonRawData, sheetName, fileName) {

    var jsonResp = $.parseJSON(jsonRawData);

    /* generate worksheet and workbook */
    const worksheet = XLSX.utils.json_to_sheet(jsonResp);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, sheetName);

    // export del file con SheetJS
    XLSX.writeFile(workbook, fileName);

}

function isNullOrEmpty(value) {
    return value === null || value === undefined || value.trim() === "";
}

function isNullOrZero(value) {
    return value === null || value === 0;
}

// verifica che codice progetto non esista già
function CheckCodiceUnico(value, requirement) {

    var response = false;
    var dataAjax = "{ sKey: 'ProjectCode', " +
        " sValkey: '" + value + "', " +
        " sTable: 'Projects'  }";

    $.ajax({
        url: "/timereport/webservices/WStimereport.asmx/CheckExistence",
        data: dataAjax,
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        type: 'post',
        async: false,
        success: function (data) {
            if (data.d == true) // esiste, quindi errore
                response = false;
            else
                response = true;
        },
        error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status);
            alert(thrownError);
        }
    });
    return response;
}
