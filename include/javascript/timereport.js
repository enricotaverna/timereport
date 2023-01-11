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

// ** NB: deve essere aggiunto un DIV dialog nel corpo HTML
function ShowPopup(message, url) {
    $(function () {

        // se non c'è la div mask la aggiunge
        if (document.getElementById("dialog") == null)
            $("body").append("<div id='dialog'></div>");

        $("#dialog").html(message);
        $("#dialog").dialog({
            title: "Messaggio",
            classes: {
                "ui-dialog": "dialogMessage"
            },
            buttons: {
                Close: function () {
                    $(this).dialog('close');
                    if (url != undefined)
                        window.location.href = url;
                }
            },
            modal: true
        });
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
function MaskScreen(wait) {

    // se non c'è la div mask la aggiunge
    if (document.getElementById("mask") == null)
        $("body").append("<div id='mask'></div>");

    //Get the screen height and width
    var maskHeight = $(document).height();
    var maskWidth = $(window).width();

    //Set heigth and width to mask to fill up the whole screen
    $("#mask").css({ 'width': maskWidth, 'height': maskHeight });

    //transition effect		
    //$('#mask').fadeIn(200);
    $("#mask").fadeTo("fast", 0.5);

    if (wait)
        document.body.style.cursor = 'wait';

}

// Riporta lo schermo alla normalità//
function UnMaskScreen() {

    //Get the screen height and width
    var maskHeight = $(document).height();
    var maskWidth = $(window).width();

    //Set heigth and width to mask to fill up the whole screen
    $("#mask").css({ 'width': 0, 'height': 0 });

    //transition effect		
    $("#mask").fadeTo("fast", 0);

    document.body.style.cursor = 'default';

    //// Crea un evento del mouse "fake"
    //let event = new MouseEvent('mousemove', {
    //    'view': window,
    //    'bubbles': true,
    //    'cancelable': true
    //});

    //// Simula l'evento del mouse
    //document.body.dispatchEvent(event);

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

function InitPage ( Bkgcolor, BkgImg ) {
    //$('.MainWindowBackground').css("background-color", "<%=CurrentSession.BackgroundColor%>");
    if ( Bkgcolor != "")
        $('.MainWindowBackground').css("background-color", Bkgcolor);

    if (BkgImg != "") {
        $('.MainWindowBackground').css("background-image", BkgImg);
        $('.MainWindowBackground').css("background-size", "cover");
    }
}




