<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cv_list.aspx.cs" Inherits="m_gestione_Cv_list" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>
<script src="/timereport/include/javascript/moment/moment.min.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<!-- Download excel da Tabulator -->
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title><asp:Literal runat="server" Text="Curricula" /></title>
</head>

<body>
    
    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <div class="row justify-content-center">

                <div class="StandardForm col-9">
  
        <div id="CVListTable"></div>
            
    <div class="buttons">           
<%--        <a href='https://www.aeonvis.it/timereport/m_gestione/Curricula/IstruzioniCV.html' target="_blank" style="color: #0000FF; text-decoration: underline">Esempi di compilazione</a> --%>
        <span id="Wordlink"></span>
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

                </div>
                <!--End div-->

            </div>
            <!--End LastRow-->
    
    <div id="ModalWindow"> <!--  FINESTRA DIALOG -->
    </div> <!--  FINESTRA DIALOG -->

        </form>
    </div>
    <!-- *** END Container *** -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div    

    <div id="mask"></div>  <!-- Mask to cover the whole screen -->

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // ** VALIDAZIONI **

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // ***  VALIDAZIONI PARSLEY ***

        // ** INTERFACCIA **

        // ** EVENTI TRIGGER **

        $('#mask').click(function () {
            $(this).hide();
            $('.window').hide();
        }); // chiude form modale

        $("#IdBottone").click(function (e) {

            // Cancel the link behavior
            e.preventDefault();

            // Trigger form validation    
            if (!$('#FVForm').parsley().validate())
                return;

            // Lancia la procedura
            // submitAggiornaRecord("APPR");

            // chiude finestra modale
            $('#mask').hide();
            $('.window').hide();

        });

        // Chiude finestra modale
        $("#btnCancelModale").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();
            $('#FVForm').parsley().reset();

            $('#mask').hide();
            $('.window').hide();

        }); // bottone chiude su form modale

        // ** TABULATOR **

        var editIcon = function (cell, formatterParams, onRendered) { //plain text value
            return "<i class='fa fa-address-card'></i>";
        };  // icona edit

        var downloadIcon = function (cell, formatterParams, onRendered) { //plain text value
            return "<i class='fa fa-cloud-download-alt'></i>";
        };  // icona edit

        var CVListTable = new Tabulator("#CVListTable", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/HR_Curriculum.asmx/GetCVList", //ajax URL
            // ajaxParams: { persons_id: xxxx },  
            ajaxConfig: "POST", //ajax HTTP request type
            ajaxContentType: "json", // send parameters to the server as a JSON encoded string
            layout: "fitColumns", //fit columns to width of table (optional)
            initialSort: [{ column: "Name", dir: "asc" }],
            ajaxResponse: function (url, params, response) {
                //url - the URL of the request
                //params - the parameters passed with the request
                //response - the JSON object returned in the body of the response.

                // concatena nome e cognome    
                var resArray = JSON.parse(response.d);
                for (var i = 0; i < resArray.length; i++)
                    resArray[i].Name = resArray[i].Surname + " " + resArray[i].Name;
                return resArray; //return the d property of a response json object
            },
            columns: [
                { title: "RagicId", field: "RagicId", sorter: "number", visible: false },
                { title: "Consulente", field: "Name", sorter: "string", width: 160, headerFilter: true },
                { title: "Livello", field: "Level", sorter: "string", width: 160, headerFilter: true },
                { title: "Manager", field: "ManagerName", sorter: "string", width: 160, headerFilter: true },
                {
                    title: "Stato", field: "CVStatus", sorter: "string", headerFilter: "select",
                    headerFilterParams: { values: { "01": "01 - Active", "02": "02 - Adm review", "03": "03 - Manager review", "99": "99 - Obsolete", "": "All Status" } }
                },
                { title: "Lang", field: "Language", sorter: "string", width: 60, headerFilter: true },
                { title: "Agg.", field: "LastUpdated", sorter: "string", headerFilter: true, formatter: "datetime", formatterParams: { inputFormat: "YYYY-MM-DD", outputFormat: "DD/MM/YYYY", } },
                { title: "Autore", field: "AuthorLastUpdate", sorter: "string", headerFilter: true },
                { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { OpenRagic(cell.getRow().getData()) } },
                { formatter: downloadIcon, width: 40, align: "center", cellClick: function (e, cell) { T_CreaCV(cell.getRow().getData(), cell.getRow()) } },
            ],
        }); // Tabella principale

        ////// ** FUNZIONI **

        function OpenRagic(dati) {
            var url = "https://eu2.ragic.com/aeonvis/ragichr/1/" + dati._ragicId;
            window.open(url, '_blank');
            return;
        }

        function T_CreaCV(dati, riga) {
            // AJAX call
            $.ajax({

                type: "POST",
                url: "/timereport/webservices/HR_Curriculum.asmx/CreateCV",
                data: "{ 'RagicId': '" + dati._ragicId + "', 'Language': '" + dati.Language + "'  }",
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    // chiude dialogo
                    if (msg.d.Result) {
                        // crea link
                        var html = "<a id='clicklink' href='<%=ConfigurationManager.AppSettings["FolderPath"]%>" + msg.d.Filename + "'></a >"; // link vuoto che viene cliccato subito dopo
                        $('#Wordlink').empty();
                        $('#Wordlink').append(html);
                        $('#clicklink')[0].click();
                        //alert("CV generato con successo");
                    }
                    else
                        alert("Errore in generazione CV");
                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax

        }  // Crea CV, chiamata da Tabulator

    </script>
        
</body>

</html>
