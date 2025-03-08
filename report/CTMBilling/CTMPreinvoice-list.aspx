<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CTMPreinvoice-list.aspx.cs" Inherits="m_preinvoice_preinvoicelist" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

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
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<!-- Download excel da Tabulator -->
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Check Input" /></title>
</head>

<body>
    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <div class="row justify-content-center">

                <div class="StandardForm col-10">

                    <div id="ListTable"></div>

                    <!-- *** campi nascosti usati da Javascript ***  -->
                    <asp:TextBox ID="TBUserName" CssClass="toHide" runat="server"  />
                    <asp:TextBox ID="TBUserLevel" CssClass="toHide" runat="server"  />

                    <div class="buttons">
                        <asp:Button ID="btn_create" runat="server" Text="<%$ appSettings: CREATE_CONSUNTIVO %>" CssClass="orangebutton" Width="120px" OnClick="btn_create_Click"/>
                        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->
            </div>
            <!--End LastRow-->

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
    </div>

    <div id="mask"></div>
    <!-- Mask to cover the whole screen -->

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
        UnMaskScreen();
      
        $("document").ready(() => {

            // nasconde i campi che hanno passato i valori dal server per fare la chiamata ajax
            $(".toHide").hide();

            // nasconde la DIV con il testo visuaizzato nel dialog box di conferma
            $("#dialog-confirm").hide();

        });

        // *** attiva validazione campi form
        //$('#formPersone').parsley({
        //    excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        //});

        // ** INTERFACCIA **

        // ** EVENTI TRIGGER **
        //trigger download of data.xlsx file
        $("#btn_download").click(function () {
            ListTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
        });

        // ** TABULATOR **

        var editIcon = function (cell, formatterParams, onRendered) { //plain text value
            var data = cell.getRow().getData();

            //if (data.DirectorsName.includes($('#TBUserName').val()) || $('#TBUserLevel').val() == '5' )
            //    return "<i class='fa fa-address-card'></i>";
            //else
            //    return "";
            return "<i class='fa fa-address-card'></i>";

        };  // icona edit

        var trashIcon = function (cell, formatterParams, onRendered) { //plain text value
            var data = cell.getRow().getData();

            if (data.DirectorsName.includes($('#TBUserName').val()) || $('#TBUserLevel').val() == '5')
                return "<i class='fa fa-trash'></i>";
            else { 
                return "";
            }   

        };  // icona edit

        var ListTable = new Tabulator("#ListTable", {
            //initialHeaderFilter: [{ field: "ApprovalStatus", value: 'REQU' } ], //valore iniziare dello stato per filtrare
            paginationSize: 16, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/RP_Preinvoice.asmx/GetPreinvoiceList", //ajax URL
            ajaxParams: { 'tipoFattura': 'CLI' },
            ajaxConfig: "POST", //ajax HTTP request type
            ajaxContentType: "json", // send parameters to the server as a JSON encoded string
            layout: "fitColumns", //fit columns to width of table (optional)
            ajaxResponse: function (url, params, response) {
                //url - the URL of the request
                //params - the parameters passed with the request
                //response - the JSON object returned in the body of the response.
                return JSON.parse(response.d); //return the d property of a response json object
            },
            columns: [
                { title: "Numero", field: "PreinvoiceNum", sorter: "number", headerFilter: true },
                { title: "Data", field: "DocumentDate", sorter: "string", headerFilter: true },
                { title: "Cliente", field: "CustomerName", sorter: "string", headerFilter: true },
                { title: "Da", field: "DataDa", sorter: "string", headerFilter: true },
                { title: "A", field: "DataA", sorter: "string", headerFilter: true },
                { title: "Director(s)", field: "DirectorsName", sorter: "string", headerFilter: true },
                { title: "Giorni", field: "NumberOfDays", width: 80, sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, headerFilter: false },
                { title: "Fee", field: "TotalRates", width: 80, sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, headerFilter: false },
                { title: "Spese", field: "TotalExpenses", width: 80, sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, headerFilter: false },
                { title: "Importo", field: "TotalAmount", width: 80, sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, headerFilter: false },
                { title: "Descrizione", field: "TMDescription", width: 150, sorter: "string", headerFilter: false },
                { formatter: trashIcon, width: 20, headerSort: false, align: "center", cellClick: function (e, cell) { confermaCancellazione(cell.getRow().getData(), cell.getRow()) } },
                { formatter: editIcon, width: 20, headerSort: false, align: "center", cellClick: function (e, cell) { OpenPreinvoiceForm(cell.getRow().getData()) } }
            ],
        }); // Tabella principale

        // ** FUNZIONI **
        function OpenPreinvoiceForm(dati) {
            var url = "/timereport/report/CTMBilling/CTMPreinvoice-form.aspx?Preinvoice_id=" + dati.Preinvoice_id;
            window.open(url, '_self');
            return;
        }

        function confermaCancellazione(dati, riga) {

            // cancella solo se proprietario del record o amministratore
            if (dati.DirectorsName.includes($('#TBUserName').val()) || $('#TBUserLevel').val() == '5')
            { 
                // Valore tasto e funzione da eseguire se confermato
                ConfirmDialog("Conferma la cancellazione","Vuoi cancellare la prefattura?","Cancella", (confirm) => confirm && (cancellaRecord(dati, riga)));
            }
        }

        function cancellaRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'PreInvoiceNum': '" + dati.PreinvoiceNum + "' , 'TipoFattura' : 'CLI'    } ";
            MaskScreen(true);

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/RP_Preinvoice.asmx/DeletePreinvoice",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    UnMaskScreen();
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == true) {
                        ShowPopup("La prefattura è stata cancellata");
                        riga.delete();
                    } else
                        ShowPopup("Impossibile cancellare il record");

                },

                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    ShowPopup(xhr.responseText);
                    return false;
                }

            }); // ajax

        } // cancella record, chiamata da Tabulator

    </script>

</body>

</html>
