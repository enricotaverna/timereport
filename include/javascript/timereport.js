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
            $("#dialog").html(message);
            $("#dialog").dialog({
                title: "Messaggio",
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
    function openDialogForm(mode) { 

    //Get the screen height and width
    var maskHeight = $(document).height();
    var maskWidth = $(window).width();

    //Set heigth and width to mask to fill up the whole screen
    $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

    //transition effect		
    $('#mask').fadeIn(1);
    $('#mask').fadeTo("fast", 0.6);

    //Get the window height and width
    var winH = $(window).height();
    var winW = $(window).width();

    //Set the popup window to center
    //Set the popup window to center
    $('#dialog').css('top', 40);
    $('#dialog').css('left', winW / 2 - $('#dialog').width() / 2);

    //transition effect
    $('#dialog').fadeIn(1);

    // reset validations
    $('#FVForm').parsley().reset();

    }     
