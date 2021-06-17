// bottone back su sottomenu
$(document).bind("mobileinit", function () {
    $.mobile.page.prototype.options.addBackBtn = true;
});

// Elimina barra
var iWebkit; if (!iWebkit) { iWebkit = window.onload = function () { function fullscreen() { var a = document.getElementsByTagName("a"); for (var i = 0; i < a.length; i++) { if (a[i].className.match("noeffect")) { } else { a[i].onclick = function () { window.location = this.getAttribute("href"); return false } } } } function hideURLbar() { window.scrollTo(0, 0.9) } iWebkit.init = function () { fullscreen(); hideURLbar() }; iWebkit.init() } }

$(document).ready(function () {

    //#region *** INIT ***
    $('#DDLActivity').hide(); // si usa DDL perchè select non si riescono a nascondere in Jquery
    $('#DDLLocation').hide(); // DDL Location
    $('#TBLocation').hide(); // testo libero location

    // recupera valore persons_id da variabile di sessione
    var persons_id = document.getElementById('persons_id').innerHTML;

    //#endregion

    //#region *** POPOLA PROGETTI ***
    $.ajax({
        type: "POST",
        url: "aggiornav2.asmx/GetProjectsList",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: "{'Person_id': '" + persons_id + "'}",
        success: function (response) {

            $("#ore_Projects_Id").selectmenu();
            $("#Projects_Id").selectmenu();

            // valori di default
            //var selectOption = $(document.createElement('option'));
            //$('#Projects_Id').append(selectOption.val("0").html("--- selezionare un progetto ---"));
            //$('#ore_Projects_Id').append(selectOption.val("0").html("--- selezionare un progetto ---"));
            //$("#ore_Projects_Id").val(0);
            //$("#Projects_Id").val(0);

            var ddl1 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0
            for (var i = 0; i < ddl1.length; i++) {
                var selectOption = $(document.createElement('option'));
                var ore_selectOption = $(document.createElement('option'));
                $('#Projects_Id').append(selectOption.val(ddl1[i].ProjectId).html(ddl1[i].ProjectName));
                $('#ore_Projects_Id').append(ore_selectOption.val(ddl1[i].ProjectId).html(ddl1[i].ProjectName));
            }

            // render del controllo
            $("#ore_Projects_Id").selectmenu('refresh', true);
            $("#Projects_Id").selectmenu('refresh', true);

            PopulateLocation($('#ore_Projects_Id').val());
            PopulateActivity($('#ore_Projects_Id').val());

        },
        error: function (xhr, textStatus, errorThrown) {
            alert(xhr.responseText);
        }
    });
    //#endregion

    //#region *** POPOLA SPESE ***
    $.ajax({
        type: "POST",
        url: "aggiornav2.asmx/GetSpeseList",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: "{'Person_id': '" + persons_id + "'}",
        // data: "{'Person_id': '" + <%= Request.QueryString["id"] %> + "'}",
        success: function (response) {
            var ddl2 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0
            for (var i = 0; i < ddl2.length; i++) {
                var selectOption = $(document.createElement('option'));
                $('#Spese_Id').append(selectOption.val(ddl2[i].SpeseId).html(ddl2[i].SpeseName));
            }
                    $("#Spese_Id").val($("#Spese_Id option:first-child").val()).selectmenu().selectmenu('refresh', true); // default
        },
        error: function (xhr, textStatus, errorThrown) {
            alert(xhr.responseText);
        }
    });
    //#endregion

    function PopulateLocation(Projects_id) {

        $('#ore_Location_Id').empty();
        $('#ore_Location_Id').val('');

        // popola dropdown attività
        $.ajax({
            type: "POST",
            url: "aggiornav2.asmx/GetLocationList",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: "{'Projects_id': '" + Projects_id + "'}",
            success: function (response) {
                var ddl3 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                if (ddl3.length > 0) {
                    for (var i = 0; i < ddl3.length; i++) {
                        var selectOption = $(document.createElement('option'));
                        $('#ore_Location_Id').append(selectOption.val(ddl3[i].LocationKey).html(ddl3[i].LocationDescription));
                        // imposta attribbuto custom
                        $('#ore_Location_Id').eq(i).attr("data-LocationType", ddl3[i].LocationType)
                    }
                            $('#ore_Location_Id').append(selectOption.val("T:99999").html("--- testo libero ---"));
                    $("#ore_Location_Id").val($("#ore_Location_Id option:first-child").val()).selectmenu().selectmenu('refresh', true); // default
                    $('#DDLLocation').show();
                }
                else
                    $('#DDLLocation').hide();
            },
            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }
        });

        $('#DDLLocation').hide();
    }

    function PopulateActivity(Projects_id) {

        $('#ore_Activity_Id').empty();
        $('#ore_Activity_Id').val('');

        // popola dropdown attività
        $.ajax({
            type: "POST",
            url: "aggiornav2.asmx/GetActivityList",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: "{'Projects_id': '" + Projects_id + "'}",
            success: function (response) {
                var ddl3 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                if (ddl3.length > 0) {
                    for (var i = 0; i < ddl3.length; i++) {
                        var selectOption = $(document.createElement('option'));
                        $('#ore_Activity_Id').append(selectOption.val(ddl3[i].ActivityId).html(ddl3[i].ActivityName));
                    }
                            $("#ore_Activity_Id").val($("#ore_Activity_Id option:first-child").val()).selectmenu().selectmenu('refresh', true); // default
                    $('#DDLActivity').show();
                }
                else
                    $('#DDLActivity').hide();
            },
            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }
        });

        $('#DDLActivity').hide();
    }

    //#region *** VALIDAZIONI ***
    var ErrMsg = "";
    $.validator.addMethod(
        // nome validatore
        "CampoNoteObbligatorio",

        // logica di validazione
        function (value, element) {

            var ret;

            $.ajax({
                type: "POST",
                url: "aggiornav2.asmx/GetTipoSpesaPerValidatore",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, // necessario per aspettare l'esito della chiamata
                data: "{'ExpenseType_id': '" + $('#Spese_Id').val() + "'}",
                success: function (response) {

                    var TipoSpesa = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                    // se campo note è obbligatorio lo verifica
                    if (TipoSpesa.TestoObbligatorio)
                        if ($('#comment').val().trim().length == 0) {
                            // errore
                            ret = false; // obbligatorio e NON valorizzato
                            ErrMsg = TipoSpesa.MessaggioDiErrore;
                        }
                        else
                            ret = true; // obbligatorio e valorizzato
                    else
                        ret = true; // non obbligatorio

                },
                error: function (xhr, textStatus, errorThrown) {
                    ret = true; // ERRORE
                }
            })

            return ret;
        },

        // messaggio di ritorno
        function () { return ErrMsg });

    // validatore custom per testo campo note su scheda progetti
    var ErrMsg = "";
    $.validator.addMethod(
        // nome validatore
        "CampoNoteObbligatorioFormOre",

        // logica di validazione
        function (value, element) {

            var ret;

            $.ajax({
                type: "POST",
                url: "aggiornav2.asmx/ValidatoreCommentiProgetto",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, // necessario per aspettare l'esito della chiamata
                data: "{'Projects_Id': '" + $('#ore_Projects_Id').val() + "'}",
                success: function (response) {

                    var Progetto = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                    // se campo note è obbligatorio lo verifica
                    if (Progetto.TestoObbligatorio)
                        if ($('#ore_comment').val().trim().length == 0) {
                            // errore
                            ret = false; // obbligatorio e NON valorizzato
                            ErrMsg = Progetto.MessaggioDiErrore;
                        }
                        else
                            ret = true; // obbligatorio e valorizzato
                    else
                        ret = true; // non obbligatorio

                },
                error: function (xhr, textStatus, errorThrown) {
                    ret = true; // ERRORE
                }
            })

            return ret;
        },

        // messaggio di ritorno
        function () { return ErrMsg });

    // validatore custom per blocco carico spese
    var ErrMsg = "";
    $.validator.addMethod(
        // nome validatore
        "BloccoCaricoSpese",

        // logica di validazione
        function (value, element) {

            var ret;

            $.ajax({
                type: "POST",
                url: "aggiornav2.asmx/BloccoCaricoSpeseValidatore",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false, // necessario per aspettare l'esito della chiamata
                data: "{'Projects_Id': '" + $('#Projects_Id').val() + "'}",
                success: function (response) {

                    var VerificaBloccoSpese = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                    // se campo note è obbligatorio lo verifica
                    if (VerificaBloccoSpese.BloccoCaricoSpese) {
                        // errore
                        ret = false; // obbligatorio e NON valorizzato
                        ErrMsg = "no carico spese";
                    }
                    else
                        ret = true; // obbligatorio e NON valorizzato
                },
                error: function (xhr, textStatus, errorThrown) {
                    ret = true; // ERRORE
                }
            })

            return ret;
        },

        // messaggio di ritorno
        function () { return ErrMsg });

    $.validator.addMethod("numberRegex", function (value, element) {

        return /^[0-9,]+$/i.test(value);

    }, "campo deve essere numerico");

    // *** spese validate ***
    var speseValidator = $("#SpeseForm").validate({
        ignore: ".ignore",
        rules: {
            Tbdate: { required: true, date: false },
            TbExpenseAmount: { required: true, numberRegex: true },
            //fileToUpload: {required: false, extension: "gif|jpg|png|jpeg"  }
            comment: { CampoNoteObbligatorio: true },  // validatore custom obbligatorietà campo note
            Projects_Id: { BloccoCaricoSpese: true }
        },
        messages: {
            Tbdate: { required: "Inserire un valore!" },
            TbExpenseAmount: { required: "Inserire un valore!", numberRegex: "Campo numerico!" }
            //fileToUpload: {extension: "Selezionare un formato file valido" }
        },
        submitHandler: function () {
            SpeseSubmit();
            ResetHeaderPage("spese");
            return false;
        },
        errorPlacement: function (error, element) {
            $('#speseToptitle').text('');
            error.appendTo($('#speseToptitle')); // sulla barra del titolo
        },
        groups: {
            gruppo: "Tbdate TbExpenseAmount comment Projects_Id"
        },
        // Called when the element is invalid:
        highlight: function (element) {
            $(element).addClass('backgroundError');
            $("div[data-role='header']").addClass('backgroundError'); // colora barra
        },
        // Called when the element is valid:
        unhighlight: function (element) {
            $(element).removeClass('backgroundError');
        }
    })

    // *** ore validate ***
    var oreValidator = $("#OreForm").validate({
        rules: {
            TbdateForHours: { required: true, date: false },
            TbHours: { required: true, number: true },
            ore_comment: { CampoNoteObbligatorioFormOre: true },  // validatore custom obbligatorietà campo note
            TBLocation: { CheckLocation: true }
        },
        messages: {
            TbdateForHours: { required: "Inserire un valore!" },
            TbHours: { required: "Inserire un valore!", number: "Campo numerico!" },
            TBLocation: { CheckLocation: "Inserire un valore!" },
        },
        submitHandler: function () {
            OreAjaxSubmit();
            ResetHeaderPage("ore");
            return false;
        },
        errorPlacement: function (error, element) {
            $('#oreToptitle').text('');
            error.appendTo($('#oreToptitle')); // sulla barra del titolo
        },
        groups: {
            gruppo: "TbdateForHours TbHours ore_comment TBLocation"
        },
        // Called when the element is invalid:
        highlight: function (element) {
            $(element).addClass('backgroundError');
            $("div[data-role='header']").addClass('backgroundError'); // colora barra
        },
        // Called when the element is valid:
        unhighlight: function (element) {
            $(element).removeClass('backgroundError');
        }
    })

    //#endregion

    //#region *** EVENTI ***

    // Cambio progetto
    $('#ore_Projects_Id').change(function () {

        if ($('#ore_Projects_Id').val() != "0") {
            PopulateActivity($('#ore_Projects_Id').val());
            PopulateLocation($('#ore_Projects_Id').val());
        }
    });

    // Cambio location DDL
    $('#ore_Location_Id').change(function () {

        if ($('#ore_Location_Id').val() == "T:99999") {
            $('#DDLLocation').hide();
            $('#TBLocation').show();
            $("#ore_Location_Id").val($("#ore_Location_Id option:first-child").val()).selectmenu('refresh', true); // default
        }
    });

    // Cambio location testo
    $('#TBLocation').change(function () {

        if ($('#TBLocation').val() == "") {
            $('#DDLLocation').show();
            $('#TBLocation').hide();
        }
    });

    // al click su bottone annulla o freccia sulla barra top resetta il form
    $("#speseCancel, #speseForm > div[data-role='header']").click(function () {
        ResetHeaderPage("spese");
        init_spese();
        window.location = '#mainmenu'
    });

    // al click su bottone annulla o freccia sulla barra top resetta il form
    $("#oreCancel, #oreForm > div[data-role='header']").click(function () {
        ResetHeaderPage("ore");
        init_ore();
        window.location = '#mainmenu'
    });

    //#endregion

    function SpeseSubmit() {

        var values = "{'Tbdate': '" + $('#Tbdate').val() + "'" +
            ", 'TbExpenseAmount': '" + $('#TbExpenseAmount').val() + "'" +
            ", 'Person_id': '" + persons_id + "'" +
            ", 'UserName': '" + $('#UserName').val() + "'" +
            " , 'Projects_Id': '" + $('#Projects_Id').val() + "'" +
            " , 'ExpenseType_Id': '" + $('#Spese_Id').val() + "'" +
            " , 'comment': '" + $('#comment').val() + "'" +
            " , 'CreditCardPayed': '" + $('#CreditCardPayed').is(':checked') + "'" +
            " , 'CompanyPayed': '" + $('#CompanyPayed').is(':checked') + "'" +
            " , 'CancelFlag': '" + $('#CancelFlag').is(':checked') + "'" +
            " , 'InvoiceFlag': '" + $('#InvoiceFlag').is(':checked') + "'" +
            " , 'strFileName': '" + strFileName + "'" +
            " , 'strFileData': '" + strFileData + "'" +
            "}";

        $.mobile.showPageLoadingMsg("a", "Caricamento... ", true);

        $.ajax({

            xhr: function () {
                var xhr = new window.XMLHttpRequest();

                xhr.upload.addEventListener("progress", function (evt) {
                    if (evt.lengthComputable) {
                        var percentComplete = evt.loaded / evt.total;
                        percentComplete = parseInt(percentComplete * 100);
                        $.mobile.showPageLoadingMsg("a", "Caricamento... " + percentComplete + " %", true);

                        if (percentComplete === 100) {

                        }

                    }
                }, false);

                return xhr;
            },

            type: "POST",
            url: "aggiornav2.asmx/salvaspese",
            data: values,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                SpeseSucceeded(msg);
            },
            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }
        }); // ajax

    }

    function OreAjaxSubmit() {

        var Activity;
        var LocationKey;
        var LocationDescription;
        var LocationType;

        if ($('#ore_Activity_Id  ').val() == null)
            Activity = "0";
        else
            Activity = $('#ore_Activity_Id  ').val();

        // imposta tipo location in base al controllo valorizzato
        LocationKey = $('#ore_Location_Id').is(':hidden') ? "99999" : $('#ore_Location_Id').val();
        LocationDescription = $('#ore_Location_Id').is(':hidden') ? $('#TBLocation').val() : $('#ore_Location_Id option:selected').text();
        LocationType = $('#ore_Location_Id').is(':hidden') ? "T" : $('#ore_Location_Id').attr("data-LocationType")

        // tipo ora sempre defaultato a 1
        var values = "{'TbdateForHours': '" + $('#ore_TbdateForHours').val() + "'" +
            ", 'TbHours': '" + $('#ore_TbHours').val() + "'" +
            ", 'Person_id': '" + persons_id + "'" +
            " , 'Projects_Id': '" + $('#ore_Projects_Id').val() + "'" +
            " , 'Activity_Id': '" + Activity + "'" +
            " , 'HourType_Id': '1'" +
            " , 'comment': '" + $('#ore_comment').val() + "'" +
            " , 'CancelFlag': '" + $('#ore_CancelFlag').is(':checked') + "'" +
            " , 'LocationKey': '" + LocationKey + "'" +
            " , 'LocationType': '" + LocationType + "'" +
            " , 'LocationDescription': '" + LocationDescription + "'" +
            "}";

        $.mobile.showPageLoadingMsg("c", "Aggiornamento", true);

        $.ajax({
            type: "POST",
            url: "aggiornav2.asmx/salvaore",
            data: values,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                OreAjaxSucceeded(msg);
            },
            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }
        }); // ajax
    }

}); // document ready

// ** init
var strFileName = "";
var strFileData = "";

//  *** carica tumbnail ***
$(document).on('change', '#fileToUpload', function () {

    // recupera controllo
    file = document.getElementById('fileToUpload').files[0];

    canvasResize(file, {
        width: 1200,
        height: 1200,
        crop: false,
        quality: 80,
        // funzione viene richiamata quando l'immagine è caricata
        callback: function (data, width, height) {
            //$(img).attr('src', data);
            document.getElementById('imagePreview').innerHTML = ['<img src="', data, '" title="', File.name, '" width="30"/>'].join('');

            // pulisce la stringa che rappresenta l'immagine
            strFileData = data.split("base64,")[1];
            strFileName = file.name;
        }
    });

    if (file == undefined) {
        file = "";
        file.name = "";
    }

});

//#region *** FUNZIONI  ***
function ResetHeaderPage(sForm) {

    if (sForm == "ore") 
        $('#oreToptitle').text('Inserisci spese');
     else 
        $('#speseToptitle').text('Inserisci spese');

    $('.backgroundError').removeClass('backgroundError');    

}

function SpeseSucceeded(msg) {

    // pulisci campi modulo
    init_spese();

    //$.mobile.hidePageLoadingMsg();

    // chiamata con successo analizza risposta
    if (msg == "true" || msg.d == "true") {

        $.mobile.showPageLoadingMsg("a", "Aggiornamento Effettuato", true);
        setTimeout(function () { $.mobile.hidePageLoadingMsg() }, 600);
    }
    else {
        alert('Errore in aggiornamento: ' + msg); // errore
    }
}

function OreAjaxSucceeded(msg) {

    init_ore();

    $.mobile.hidePageLoadingMsg();

    // chiamata con successo analizza risposta
    if (msg == "true" || msg.d == "true") {
        $('#oreToptitle').html('Aggiornamento Effettuato');
        $("#oreToptitle").fadeOut(1000, function () {
            $(this).text("Inserisci Ore")
        }).fadeIn();
    }
    else {
        alert('Errore in aggiornamento: ' + msg); // errore
    }
}

// *** inizializza i campi ***
function init_spese() {

    // pulisce campo preview
    // genera preview  
    $('#imagePreview').empty();
    document.getElementById('imagePreview').innerHTML = ['<img src="" title="" width="30" />'];

    $('#TbExpenseAmount').val("");
    $('#comment').val("");
    $('#CreditCardPayed').attr('checked', false);
    $('#CompanyPayed').attr('checked', false);
    $('#CancelFlag').attr('checked', false);
    $('#InvoiceFlag').attr('checked', false);
    $('#CreditCardPayed').checkboxradio("refresh");
    $('#CompanyPayed').checkboxradio("refresh");
    $('#CancelFlag').checkboxradio("refresh");
    $('#InvoiceFlag').checkboxradio("refresh");
    $('#fileToUpload').val("");
    strFileName = "";
    strFileData = "";
};

// *** inizializza i campi ***
function init_ore() {

    // pulisci campi modulo
    $('#ore_TbHours').val("");
    $('#ore_comment').val("");
    $('#ore_CancelFlag').attr('checked', false);
    $('#ore_CancelFlag').checkboxradio("refresh");

};
//#endregion



