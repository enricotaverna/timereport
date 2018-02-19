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

    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(
                    function () {
                        displayAlert();
                    });