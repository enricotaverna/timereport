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
    function ShowPopup(message) {
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
        var winW = 960;

        //Set the popup window to center
        $(ModalForm).css('top', 40);
        $(ModalForm).css('left', winW / 2 - $(ModalForm).width() / 2);

        //transition effect
        $(ModalForm).fadeIn(1);

        // reset validations
        $('#FVForm').parsley().reset();

} 

// Maschera lo schermo con una effetto Fade
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

}
