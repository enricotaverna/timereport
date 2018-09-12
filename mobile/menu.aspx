<%@ Page Title="" Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Configuration" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        Utilities.CheckAutMobile(MyConstants.AUTH_EXTERNAL); 
    } 
       
</script>

<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" >
    <title>Form spese</title>

    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
<%--    <meta name="apple-mobile-web-app-capable" content="yes" />--%>
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <!-- style sheets -->
    <link rel="stylesheet" href="/timereport/include/jquery/jquery.mobile-1.1.1.min.css" />
    <link rel="stylesheet" href="./css/TimereportMobilev2.css" />
    <!-- jquery mobile -->
    <script src="/timereport/include/jquery/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="./js/customscript.js"></script> 
    <script src="/timereport/include/jquery/jquery.mobile-1.1.1.min.js"></script>
    <!-- jquery mobile FINE -->

    <!-- bottone back su sottomenu -->
    <script>
        $(document).bind("mobileinit", function () {
            $.mobile.page.prototype.options.addBackBtn = true;
        });
    </script>
    <script src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>
    <script type="text/javascript" src="./js/jquery.validate.js"></script>
    <script type="text/javascript" src="./js/additional-methods.js"></script>
    <!-- jquery mobile FINE -->
    
    <!-- jquery Resize immagine prima upload -->
    <script src="./js/resize/exif.js"></script>
    <script src="./js/resize/binaryajax.js"></script>
    <script src="./js/resize/canvasResize.js"></script>
    <!-- jquery Resize immagine prima upload FINE -->

    <script>
    <!-- elimina barra -->   
    var iWebkit; if (!iWebkit) { iWebkit = window.onload = function () { function fullscreen() { var a = document.getElementsByTagName("a"); for (var i = 0; i < a.length; i++) { if (a[i].className.match("noeffect")) { } else { a[i].onclick = function () { window.location = this.getAttribute("href"); return false } } } } function hideURLbar() { window.scrollTo(0, 0.9) } iWebkit.init = function () { fullscreen(); hideURLbar() }; iWebkit.init() } }
    </script>

     <script type="text/javascript" language="javascript">

         $(document).ready(function () {
              
             //          **** popola dropdown TIPO ORE ****  NON PIU' USATO, TIPO ORE DEFAULTATO A 1
             //$.ajax({
             //    type: "POST",
             //    url: "aggiornav2.asmx/GetTipoOreList",
             //    contentType: "application/json; charset=utf-8",
             //    dataType: "json",
             //    data: "",
             //    success: function (response) {
             //        var ddl1 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0
             //        for (var i = 0; i < ddl1.length; i++) {
             //            var selectOption = $(document.createElement('option'));
             //            $('#ore_TipoOre_Id').append(selectOption.val(ddl1[i].TipoOreId).html(ddl1[i].TipoOreName));
             //        }
             //        $("#ore_TipoOre_Id").val( $("#ore_TipoOre_Id option:first-child").val() ); // default
             //    },
             //    error: function (xhr, textStatus, errorThrown) {
             //        alert(xhr.responseText);
             //    }
             //});

             //            *** popola dropdown PROGETTI ***
             $.ajax({
                 type: "POST",
                 url: "aggiornav2.asmx/GetProjectsList",
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 data: "{'Person_id': '" + <%=Session["persons_id"] %> + "'}",
<%--                 data: "{'Person_id': '" + <%= Request.QueryString["id"] %> + "'}",--%>
                success: function (response) {
                    var ddl1 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0
                    for (var i = 0; i < ddl1.length; i++) {
                        var selectOption = $(document.createElement('option'));
                        var ore_selectOption = $(document.createElement('option'));
                        $('#Projects_Id').append(selectOption.val(ddl1[i].ProjectId).html(ddl1[i].ProjectName));
                        $('#ore_Projects_Id').append(ore_selectOption.val(ddl1[i].ProjectId).html(ddl1[i].ProjectName));
                    }
                    $("#Projects_Id").val($("#Projects_Id option:first-child").val()); // default
                    $("#ore_Projects_Id").val($("#ore_Projects_Id option:first-child").val()); // default
                    populateActivity();
                },
                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }
              });

                $('#ore_Projects_Id').change(function () {
                    populateActivity();
                });


                //             *** popola dropdown ATTIVITA ***
                function populateActivity() {

                    $('#ore_Activity_Id').empty();
                    $('#ore_Activity_Id').val('');

                    // popola dropdown attività
                    $.ajax({
                        type: "POST",
                        url: "aggiornav2.asmx/GetActivityList",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: "{'Projects_id': '" + $('#ore_Projects_Id').val() + "'}",
                        success: function (response) {
                            var ddl3 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0

                            if (ddl3.length > 0)
                                for (var i = 0; i < ddl3.length; i++) {
                                    var selectOption = $(document.createElement('option'));
                                    $('#ore_Activity_Id').append(selectOption.val(ddl3[i].ActivityId).html(ddl3[i].ActivityName));
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

                // popola spese   
                $.ajax({
                    type: "POST",
                    url: "aggiornav2.asmx/GetSpeseList",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{'Person_id': '" + <%=Session["persons_id"] %> + "'}",
                    // data: "{'Person_id': '" + <%= Request.QueryString["id"] %> + "'}",
                success: function (response) {
                    var ddl2 = (response.d == undefined) ? response : response.d; // compatibilità ASP.NET 2.0
                    for (var i = 0; i < ddl2.length; i++) {
                        var selectOption = $(document.createElement('option'));
                        $('#Spese_Id').append(selectOption.val(ddl2[i].SpeseId).html(ddl2[i].SpeseName));
                    }
                    $("#Spese_Id").val($("#Spese_Id option:first-child").val()); // default
                },
                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }
             });

             // validatore custom per testo campo note su scheda spese
             // $.validator.addMethod("NomeValidatore", funzione, "messaggio di errore"
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
                                                    if ($('#comment').val().trim().length == 0)
                                                    {
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
             // $.validator.addMethod("NomeValidatore", funzione, "messaggio di errore"
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
             // $.validator.addMethod("NomeValidatore", funzione, "messaggio di errore"
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
                                                    ErrMsg = "Carico spese non ammesso";
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


                // spese validate
                $("#SpeseForm").validate({
                    ignore: ".ignore",
                    rules: {
                        Tbdate: { required: true, date: false },
                        TbExpenseAmount: { required: true, number: true },
                        //fileToUpload: { required: false, extension: "gif|jpg|png|jpeg"  }
                        comment: { CampoNoteObbligatorio: true } ,  // validatore custom obbligatorietà campo note
                        Projects_Id: { BloccoCaricoSpese: true }
                    },
                    messages: {
                        Tbdate: { required: "Inserire un valore!" },
                        TbExpenseAmount: { required: "Inserire un valore!", number: "Campo numerico!" }
                         
                        //fileToUpload: { extension: "Selezionare un formato file valido" }
                    },
                    submitHandler: function () {
                        SpeseSubmit();
                        return false;
                    }
                })

                // ore validate
                $("#OreForm").validate({
                    rules: {
                        TbdateForHours: { required: true, date: false },
                        TbHours: { required: true, number: true },
                        ore_comment: { CampoNoteObbligatorioFormOre: true },  // validatore custom obbligatorietà campo note
                    },
                    messages: {
                        TbdateForHours: { required: "Inserire un valore!" },
                        TbHours: { required: "Inserire un valore!", number: "Campo numerico!" },
                    },
                    submitHandler: function () {
                        OreAjaxSubmit();
                        return false;
                    }
                })

            }); // document ready

         // init
         var strFileName = "";
         var strFileData = "";

        //  carica tumbnail
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

        // inizializza i campi
        function init_spese() {

            // pulisce campo preview
            // genera preview  
            $('#imagePreview').empty();
            document.getElementById('imagePreview').innerHTML = ['<img src="" title="" width="30"/>'];

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

        //          ***** SALVA SPESE *****
        function SpeseSubmit() {

            var values = "{'Tbdate': '" + $('#Tbdate').val() + "'" +
                                  ", 'TbExpenseAmount': '" + $('#TbExpenseAmount').val() + "'" +
                                  ", 'Person_id': '" + <%=Session["persons_id"] %> + "'" +
                                  //", 'Person_id': '" + <%= Request.QueryString["id"] %> + "'" +
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

                    } // SpeseSubmit

                    function SpeseSucceeded(msg) {

                        // pulisci campi modulo
                        init_spese();

                        //$.mobile.hidePageLoadingMsg();

                        // chiamata con successo analizza risposta
                        if (msg == "true" || msg.d == "true") {

                            $.mobile.showPageLoadingMsg("a", "Aggiornamento Effettuato", true);
                            setTimeout(function () { $.mobile.hidePageLoadingMsg() }, 600);

                            //$('#toptitle').html('Aggiornamento Effettuato');
                            //$("#toptitle").fadeOut(1000, function () {
                            //    $(this).text("Inserisci Spese")
                            //}).fadeIn();
                        }
                        else {
                            alert('Errore in aggiornamento: ' + msg); // errore
                        }
                    }

                    //            function AjaxFailed(result) {
                    //                $.mobile.hidePageLoadingMsg();
                    //                alert(result.status + ' >> ' + result.responseText);
                    ////            } 

             function OreAjaxSubmit() {

                        var Activity;

                        if ($('#ore_Activity_Id  ').val() == null)
                            Activity = "0";
                        else
                            Activity = $('#ore_Activity_Id  ').val();

                        // tipo ora sempre defaultato a 1
                        var values = "{'TbdateForHours': '" + $('#ore_TbdateForHours').val() + "'" +
                                      ", 'TbHours': '" + $('#ore_TbHours').val() + "'" +
                                       ", 'Person_id': '" + <%=Session["persons_id"]%> + "'" +
                                    // ", 'Person_id': '" + <%= Request.QueryString["id"] %> + "'" +
                               " , 'Projects_Id': '" + $('#ore_Projects_Id').val() + "'" +
                               " , 'Activity_Id': '" + Activity + "'" +
                               " , 'HourType_Id': '1'" +
                               " , 'comment': '" + $('#ore_comment').val() + "'" +
                               " , 'CancelFlag': '" + $('#ore_CancelFlag').is(':checked') + "'" +
                               "}";

                 $.mobile.showPageLoadingMsg("a", "Aggiornamento", true);

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

             function OreAjaxSucceeded(msg) {
                 // pulisci campi modulo
                 $('#ore_TbHours').val("");
                 $('#ore_comment').val("");
                 $('#ore_CancelFlag').attr('checked', false);
                 $('#ore_CancelFlag').checkboxradio("refresh");

                 $.mobile.hidePageLoadingMsg();

                 // chiamata con successo analizza risposta
                 if (msg == "true" || msg.d == "true") {
                     $('#ore_toptitle').html('Aggiornamento Effettuato');
                     $("#ore_toptitle").fadeOut(1000, function () {
                         $(this).text("Inserisci Ore")
                     }).fadeIn();
                 }
                 else {
                     alert('Errore in aggiornamento: ' + msg); // errore
                 }
             }

        </script>

</head>
    
<body>
    <div data-role="page" data-dom-cache="true" id="mainmenu">
        <div data-role="header" data-position="fixed">
            <a href='./login.aspx' class='ui-btn-left' data-icon='back'  rel="external">Logoff</a>
            <h1>Menu</h1>
        </div>
        <!-- /header -->
        <div data-role="content">
            <ul data-role="listview" data-inset="true">
                <li><a href="#FormSpesePage">
                    <img src="/timereport/images/mobile/money.png" / >
                    <h3>Spese</h3>
                    <p>Inserisci spese</p>  
                </a></li>
                <li><a href="#FormOrePage"   > 
                    <img src="/timereport/images/mobile/clock_128.png" />
                    <h3>Ore</h3>
                    <p>Inserisci ore
                    </p>
                </a></li>
                <li><a href="index.html">
                    <img src="/timereport/images/mobile/report_check.png" />
                    <h3>Report</h3><p> Ore e spese per mese corrente e precedente</p></a>
                    <ul  data-role="listview" data-inset="true">
                        	<li><a href="list-spese.aspx?id=<%= Session["persons_id"] %>"><img src="/timereport/images/mobile/money.png" /><h3>Report Spese</h3><p>Report spese mese corrente e precedente</p></a></li>
							<li><a href="list-ore.aspx?id=<%= Session["persons_id"] %>"><img src="/timereport/images/mobile/clock_128.png" /><h3>Report Ore</h3><p>Report ore mese corrente e precedente</p></a></li>                
<%--							<li><a href="list-spese.aspx?id=<%= Request.QueryString["id"] %>"><img src="/timereport/images/mobile/money.png" /><h3>Report Spese</h3><p>Report spese mese corrente e precedente</p></a></li>
							<li><a href="list-ore.aspx?id=<%= Request.QueryString["id"] %>"><img src="/timereport/images/mobile/clock_128.png" /><h3>Report Ore</h3><p>Report ore mese corrente e precedente</p></a></li>                --%>
                    </ul>
                </li>
            </ul>
        </div>
        <!--/content-primary -->
 
    </div>
    <!-- /page "menu" -->

    <!-- Start of second page -->
    <div data-role="page" id="FormSpesePage">

        <form id="SpeseForm" method="post" name="SpeseForm">
        
        <div data-role="header">
            <a href="#mainmenu" class='ui-btn-left' data-icon='arrow-l'>Back</a>
            <h1 id="toptitle">
                Inserisci spese</h1>
        </div> <!-- /header -->
        
        <div data-role="content">

            <div class="ui-grid-a"> <!-- Data e importo spesa -->
	      
                <!-- controllo nascosto con nome utente -->
                <input id="UserName" type="hidden" value='<%=Session["UserName"]%>'/>

                <div class="ui-block-a"> 
                    <input name="Tbdate" id="Tbdate" type="date" value='<%=DateTime.Today.ToString("yyyy-MM-dd") %>' placeholder="Inserisci data">
                </div>
	      
                <div class="ui-block-b">
                    <input type="number" name="TbExpenseAmount" ID="TbExpenseAmount" placeholder="Importo spesa" >
                </div>
          
            </div> <!-- /grid-a -->
        
                                  
            <br />
            
            <select name="Projects_Id" id="Projects_Id"> <!-- riempito da query --> </select>

            <select id="Spese_Id"> <!-- riempito da query --> </select>

            <br />  

            <textarea id="comment" name="comment" Rows="2" TextMode="MultiLine" placeholder="inserisci un commento se necessario"></textarea>
             
            <fieldset data-role="controlgroup"  data-type="horizontal">
           	    <input type="checkbox" name="CreditCardPayed" id="CreditCardPayed" class="custom" /><label for="CreditCardPayed">CCred</label> 
                <input type="checkbox" name="CompanyPayed" id="CompanyPayed" class="custom" /><label for="CompanyPayed">Bonif.</label>                   
                <input type="checkbox" name="InvoiceFlag" id="InvoiceFlag" class="custom" /><label for="InvoiceFlag">Fatt</label>                               
                <input type="checkbox" name="CancelFlag" id="CancelFlag" class="custom" /><label for="CancelFlag">Storno</label>               
            </fieldset>

            <br />

            <div class="ui-grid-a"> <!-- Bottoni Form -->                  
	        
                      <div class="ui-block-a">
                        <span class="fileinput-button" data-role="button" data-theme="b" >
                        <span>Carica foto</span>
<%--                        <input type="file" name="fileToUpload" id="fileToUpload" accept="image/jpeg,image/gif,image/png"  capture="camera"/> --%>
                            <input type="file" name="fileToUpload" id="fileToUpload" accept="image/*"/> 
                        </span>
                     </div>

	                <div class="ui-block-b" style="text-align:center">
                        <span class="width=30" id="imagePreview"></span>
                    </div>
             </div> <!-- /grid-a -->     

            <div class="ui-grid-a"> <!-- Bottoni Form -->                  
	                <div class="ui-block-a">
        		        <input type="submit" id="SpeseSubmit" value="Salva" data-role="button" data-theme="b" />
                     </div>

	                <div class="ui-block-b">
                	    <input type="button" name="cancel" value="Annulla" data-role="button" onclick="init_spese();window.location = '#mainmenu'" data-theme="b" />
                    </div>
             </div> <!-- /grid-a -->     
        
        </div> <!--/content-primary -->
        
        </form>
     
     </div> <!-- /page #2 form spese -->
	
     <!-- Start of third page -->
     <div data-role="page" id="FormOrePage">

        <form id="OreForm" method="post" name="OreForm">
        
        <div data-role="header">
            <a href="#mainmenu" class='ui-btn-left' data-icon='arrow-l'>Back</a>
            <h1 id="ore_toptitle">
                Inserisci ore</h1>
        </div> <!-- /header -->
        
        <div data-role="content">

            <div class="ui-grid-a">
	            <div class="ui-block-a"> 
                   <input name="TbdateForHours" id="ore_TbdateForHours" type="date" value='<%=DateTime.Today.ToString("yyyy-MM-dd") %>' placeholder="Inserisci data">
                </div>
	            <div class="ui-block-b">
                    <input type="number" name="TbHours" id="ore_TbHours" placeholder="Ore" />
                </div>
            </div><!-- /grid-a -->
            
             <br />
            
            <select id="ore_Projects_Id" name="ore_Projects_Id"> <!-- riempito da query --> </select>

            <div id="DDLActivity">
                <select id="ore_Activity_Id"> <!-- riempito da query --> </select>
            </div >

<%--            <select id="ore_TipoOre_Id"> <!-- riempito da query --> </select>--%>
            
            <br />  
             
            <textarea id="ore_comment" name="ore_comment" Rows="2" TextMode="MultiLine" placeholder="inserisci un commento se necessario"></textarea>
            
            <fieldset data-role="controlgroup"  data-type="horizontal">
              	<input type="checkbox" name="CancelFlag" id="ore_CancelFlag" class="custom" /><label for="ore_CancelFlag">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Storno&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>               
            </fieldset>

            <br />    

            <div class="ui-grid-a"> <!-- Bottoni Form -->
	            <div class="ui-block-a">
        		    <input type="submit" id="ore_Submit" value="Salva" data-role="button" data-theme="b" />
                </div>
	             <div class="ui-block-b">
                    <input type="button" id="ore_Cancel" value="Annulla" data-role="button" onclick="window.location = '#mainmenu'" data-theme="b" />
                </div>
             </div> <!-- /grid-a -->   

        </div> <!--/content-primary -->
        
        </form>

     </div> <!-- /page FormOrePage -->

</body>

</html>
