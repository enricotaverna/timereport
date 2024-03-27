<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SFimport_list.aspx.cs" Trace="false" Inherits="SFimport_select" %>

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

                    <!--  *** VERSIONE *** -->
                    <asp:Table ID="TBSFImport" runat="server">
                        <asp:TableHeaderRow ID="TableHeaderRow1" runat="server">
                            <asp:TableHeaderCell>C</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProcessingStatus</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProjectCode</asp:TableHeaderCell>
                            <asp:TableHeaderCell>TRProjectsId</asp:TableHeaderCell>
                            <asp:TableHeaderCell>OpportunityId</asp:TableHeaderCell>
                            <asp:TableHeaderCell>OpportunityName</asp:TableHeaderCell>

                            <asp:TableHeaderCell>SFEngagementType</asp:TableHeaderCell>
                            <asp:TableHeaderCell>TREngagementType</asp:TableHeaderCell>

                            <asp:TableHeaderCell>SFAmount</asp:TableHeaderCell>
                            <asp:TableHeaderCell>TRAmount</asp:TableHeaderCell>

                            <asp:TableHeaderCell>SFExpectedMargin</asp:TableHeaderCell>
                            <asp:TableHeaderCell>TRExpectedMargin</asp:TableHeaderCell>

                            <asp:TableHeaderCell>SFExpectedFulfillmentDate</asp:TableHeaderCell>
                            <asp:TableHeaderCell>TRExpectedFulfillmentDate</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProcessingMessage</asp:TableHeaderCell>

                        </asp:TableHeaderRow>

                    </asp:Table>

                    <div class="buttons">
                        <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" CommandName="Exec" />
                        <asp:Button ID="BTRefresh" runat="server" Text="<%$ appSettings: REFRESH_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="BTDownload" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/report/EstraiRevenue/SFimport_select.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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
        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(function () {
            // reset cursore e finestra modale
            UnMaskScreen();
        });

        $('#BTRefresh').click(function (e) {
            // maschera lo schermo
            // NB: deve essere definito un elemento <div id="mask"></div> nel corpo del HTML
            MaskScreen(true);
        });

        //trigger download of data.xlsx file
        $("#BTDownload").click(function (e) {

            e.preventDefault(); //Cancel the link behavior
            SFImportTable.download("xlsx", "SF-upload-check.xlsx", { sheetName: "dati" });

        });

        // Aggiorna
        $("#BtExec").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            var selectedData = SFImportTable.getSelectedData(); // array con le rige selezionate
            var dataToPost = []; // array vuoto

            if (selectedData.length == 0) {
                ShowPopup("Selezionare almeno una riga");
                return;
            }

            // aggiunge gli elementi
            for (i = 0; i < selectedData.length; i++) {
                dataToPost.push("{ trprojectsid:'" + selectedData[i].trprojectsid + "', sfengagementtype:'" + selectedData[i].sfengagementtype +
                    "', sfamount:'" + selectedData[i].sfamount + "',  sfexpectedmargin:'" + selectedData[i].sfexpectedmargin + "', sfexpectedfulfillmentdate:'" + selectedData[i].sfexpectedfulfillmentdate + "'}");
            }

            $.ajax({

                type: "POST",
                url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateProjects",
                data: JSON.stringify({ arr: dataToPost }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == true)
                        ShowPopup("Aggiornato completato");
                    else
                        ShowPopup("Errore in aggiornamento progetti");

                },

                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup("Errore in aggiornamento progetti");
                    return false;
                }

            }); // ajax


        });  // tasto crea record

        var SFImportTable = new Tabulator("#TBSFImport", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            selectable: true,
            selectableCheck: function (row) {
                //row - row component
                return row.getData().processingstatus == "A000";
            },
            //layout: "fitColumns",
            columns: [
                { title: "ProcessingStatus", sorter: "string", headerFilter: "input", formatterParams: { allowTruthy: true }, width: 40, frozen: true, },
                { title: "ProjectCode", sorter: "string", headerFilter: "input", width: 100, frozen: true, },
                { title: "OpportunityName", sorter: "string", headerFilter: "input", width: 90, frozen: true, },
                { title: "OpportunityId", sorter: "string", headerFilter: "input", width: 90 },
                { title: "TRProjectsId", visible: false },
                { title: "SFEngagementType", sorter: "string", headerFilter: "input", width: 80 },
                { title: "TREngagementType", sorter: "string", headerFilter: "input", width: 80 },
                { title: "SFAmount", sorter: "string", headerFilter: "input", width: 80 },
                { title: "TRAmount", sorter: "string", headerFilter: "input", width: 80 },
                { title: "SFExpectedMargin", sorter: "string", headerFilter: "input", width: 90 },
                { title: "TRExpectedMargin", sorter: "string", headerFilter: "input", width: 90 },
                { title: "SFExpectedFulfillmentDate", sorter: "string", headerFilter: "input", width: 90 },
                { title: "TRExpectedFulfillmentDate", sorter: "string", headerFilter: "input", width: 90 },
                { title: "ProcessingMessage", sorter: "string", headerFilter: "input" },
                //{ title: "C", formatter: "tickCross", formatterParams: { allowEmpty: true }, width: 30, frozen: true, }, // , responsive: 1, cellClick: function (e, cell) { var a = cell.getValue(); if (a == "") cell.setValue("1"); else if(a == "1") cell.setValue("")} },
            ],
        }); // Tabella principale

    </script>

</body>

</html>

