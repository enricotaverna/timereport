<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Caricatore_list.aspx.cs" Trace="false" Inherits="SFimport_select" %>

<!-- 

    - per parametrare un nuovo caricatore aggiungere struttura dati su array projectParams
    - aggiungere condizione sullo switch in base al parametro type passato alla pagina (es. PROJECT, FLC, BILLRATE)
    - aggiornare chiamata AJAX in WS_Caricatore.asmx per caricamento tabella e salvataggio dati
    
-->

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

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
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Import Sales Force</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="NOME_FORM" runat="server" cssclass="StandardForm">

            <div class="row justify-content-center">

                <div class="StandardForm col-11">

                    <div ID="TBImport"> </div>

                    <div class="buttons">
                        <div id="resultMsg" style="display: inline-block; width: 350px"></div>
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" CommandName="Exec" />
<%--                        <asp:Button ID="BTRefresh" runat="server" Text="<%$ appSettings: REFRESH_TXT %>" CssClass="orangebutton" />--%>
                        <asp:Button ID="BTDownload" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/m_gestione/Caricatori/Caricatore_select.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                    </div>

                </div>
                <!--End div-->
            </div>
            <!--End LastRow-->

        </form>

    </div>
    <!-- END MainWindow -->

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

    <!-- *** JAVASCRIPT *** -->
    <script>

        // definizione delle tabella dati
        // title, sorter, headerfilter, width, frozen, visible,  
        var projectParams = [
            //["ProcessingStatus", "string", "input", 40, true, false],
            ["ProjectCode", "string", "input", 100, true, true],
            ["Name", "string", "input", 90, true, true],
            ["ClientManager", "string", "input", 90, '', true],
            ["ClientManager_id", "string", "input", 90, '', false],
            ["AccountManager", "string", "input", 90, '', true],
            ["AccountManager_id", "string", "input", 90, '', false],
            ["CodiceCliente", "string", "input", 120, '', true],
            ["CopiaConsulentiDa", "string", "input", 120, '', true],
            ["CopiaConsulentiDa_id", "string", "input", 120, '', false],
            ["ProjectType", "string", "input", 80, '', true],
            ["ProjectType_id", "string", "input", 80, '', false],
            ["LOB", "string", "input", 80, '', true],
            ["LOB_id", "string", "input", 80, '', false],
            ["Channels", "string", "input", 80, '', true],
            ["Channels_id", "string", "input", 80, '', false],
            ["Company", "string", "input", 80, '', true],
            ["Company_id", "string", "input", 80, '', false],
            ["TipoContratto", "string", "input", 80, '', true],
            ["TipoContratto_id", "string", "input", 80, '', false],
            ["RevenueBudget", "number", "input", 80, '', true],
            ["MargineProposta", "number", "input", 80, '', true],
            ["DataInizio", "string", "input", 80, '', true],
            ["DataFine", "string", "input", 80, '', true],
            ["DataFine", "string", "input", 80, '', true],
            ["BloccoCaricoSpese", "string", "input", 20, '', true],
            ["ActivityOn", "string", "input", 20, '', true],
            ["ProcessingMessage", "string", "input", 800, '', true],
        ];

        var FLCParams = [
            //["ProcessingStatus", "string", "input", 40, true, false],
            ["Consulente", "string", "input", 160, '', true],
            ["Persons_id", "string", "input", 90, '', false],
            ["CostRate", "number", "input", 80, '', true],
            ["DataDa", "string", "input", 80, '', true],
            ["DataA", "string", "input", 80, '', true],
            ["Comment", "string", "input", 160, '', true],
            ["ProcessingMessage", "string", "input", 800, '', true],
        ];

        var BillRateParams = [
            //["ProcessingStatus", "string", "input", 40, true, false],
            ["Consulente", "string", "input", 160, '', true],
            ["Persons_id", "string", "input", 90, '', false],
            ["ProjectCode", "string", "input", 160, '', true],
            ["Projects_id", "string", "input", 90, '', false],
            ["CostRate", "number", "input", 80, '', true],
            ["DataDa", "string", "input", 80, '', true],
            ["DataA", "string", "input", 80, '', true],
            ["Comment", "string", "input", 160, '', true],
            ["ProcessingMessage", "string", "input", 800, '', true],
        ];

        // crea tabella colonne con prima colonna con lo stato
        var dataTable = [{
            title: 'ProcessingStatus', field: 'ProcessingStatus', sorter: 'string', headerFilter: 'input', width: 40, frozen: true, formatter: function (cell, formatterParams, onRendered) {
                //cell - the cell component
                //formatterParams - parameters set for the column
                //onRendered - function to call when the formatter has been rendered
                if ( cell.getValue() != "OK") 
                    cell.getElement().style.backgroundColor = "#cd5c5c"; // red
                else 
                    cell.getElement().style.backgroundColor = "#9acd32"; // green

                return cell.getValue(); //return the contents of the cell;
            }
        }];

        var arrayParams;

        var type = '<%= Request.QueryString["type"] %>';
        switch (type) {

            case 'PROJECT':
                arrayParams = projectParams;   
                break;

            case 'FLC':
                arrayParams = FLCParams;
                break;

            case 'BILLRATE':
                arrayParams = BillRateParams;
                break;

            // ** aggiungere CASE per nuovo caricatore */
        }

        for (i = 0; i < arrayParams.length; i++) {
            let obj = {};
            obj.title = arrayParams[i][0];
            obj.field = arrayParams[i][0];
            obj.sorter = arrayParams[i][1];
            obj.headerFilter = arrayParams[i][2];
            obj.width = arrayParams[i][3];
            obj.frozen = arrayParams[i][4];
            obj.visible = arrayParams[i][5];

            dataTable.push( obj ); 
        };

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(document).ready(function () {
            UnMaskScreen(); // reset cursore e finestra modale
        });

        //$('#BTRefresh').click(function (e) {
        //    // maschera lo schermo
        //    // NB: deve essere definito un elemento <div id="mask"></div> nel corpo del HTML
        //    e.preventDefault(); //Cancel the link behavior
        //    importTable.selectRow(importTable.getRows().filter(row => row.getData().ProcessingStatus == 'A000'));
        //    // MaskScreen(true);
        //});

        //trigger download of data.xlsx file
        $("#BTDownload").click(function (e) {

            e.preventDefault(); //Cancel the link behavior
            importTable.download("xlsx", "upload-check.xlsx", { sheetName: "dati" });

        });

        // Aggiorna
        $("#BtExec").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            // maschera lo schermo
            MaskScreen(true);

            // var selectedData = importTable.getSelectedData(); // array con le rige selezionate
            var selectedData = importTable.getData().filter(row => row.ProcessingStatus == 'OK');
            var dataToPost = []; // array vuoto

            if (selectedData.length == 0) {
                UnMaskScreen();
                ShowPopup("Nessuna riga da caricare");
                return;
            }

            // aggiunge gli elementi
            for (i = 0; i < selectedData.length; i++) {               
                dataToPost.push(JSON.stringify(selectedData[i]));
            }

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_Caricatore.asmx/UpdateTable",
                data: JSON.stringify({ type: '<%= Request.QueryString["type"] %>', arr: dataToPost }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    UnMaskScreen();
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == true) {
                        ShowPopup(selectedData.length + " record(s) caricati con successo.", "/timereport/m_gestione/Caricatori/Caricatore_select.aspx");
                        $('#BtExec').hide();                        
                    }
                    else
                        ShowPopup("Errore in aggiornamento tabella");

                },

                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    ShowPopup("Errore in aggiornamento tabella");
                    return false;
                }

            }); // ajax

        });  // tasto crea record

        var importTable = new Tabulator("#TBImport", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            ajaxURL: "/timereport/webservices/WS_Caricatore.asmx/GetDataTable", //ajax URL
            ajaxParams: { type: '<%= Request.QueryString["type"] %>' }, //passa il tipo di estrazione
            ajaxConfig: "POST", //ajax HTTP request type
            ajaxContentType: "json", // send parameters to the server as a JSON encoded string
            layout: "fitColumns", //fit columns to width of table (optional)
            ajaxResponse: function (url, params, response) {
                return JSON.parse(response.d); //return the d property of a response json object
            },
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            dataLoaded: function (data) {
                $("#resultMsg").html(data.length + ' record(s) caricati di cui ' + data.filter((row) => { return row.ProcessingStatus != 'OK' }).length + ' in errore.');
            },
            //selectable: true,
            //selectableCheck: function (row) {
            //    //row - row component
            //    return row.getData().ProcessingStatus == "A000";
            //},
            columns: dataTable,
        }); // Tabella principale

    </script>

</body>

</html>

