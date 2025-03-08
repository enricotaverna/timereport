<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SpeseImport_list.aspx.cs" Trace="false" Inherits="SFimport_select" %>

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
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css">

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Import Spese</title>
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
                    <asp:Table ID="TBImport" runat="server">
                        <asp:TableHeaderRow ID="TableHeaderRow1" runat="server">
                            <asp:TableHeaderCell>C</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProcessingStatus</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProjectCode</asp:TableHeaderCell>
                            <asp:TableHeaderCell>ProjectName</asp:TableHeaderCell>
                            <asp:TableHeaderCell>ProjectsId</asp:TableHeaderCell>


                            <asp:TableHeaderCell>AnnoMese</asp:TableHeaderCell>
                            <asp:TableHeaderCell>RevenueVersionCode</asp:TableHeaderCell>

                            <asp:TableHeaderCell>RevenueSpese</asp:TableHeaderCell>

                            <asp:TableHeaderCell>ProcessingMessage</asp:TableHeaderCell>

                        </asp:TableHeaderRow>

                    </asp:Table>

                    <div class="buttons">
                        <div id="valMsg" class="parsley-single-error"></div>
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EDIT_TXT %>" CssClass="orangebutton" CommandName="Exec" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/report/EstraiRevenue/SpeseImport_select.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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

        // Aggiorna
        $("#BtExec").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();
            MaskScreen(true); // cursore e finestra modale

            var selectedData = SFImportTable.getData(); // array con le rige selezionate
            var dataToPost = [];

            for (i = 0; i < selectedData.length; i++) {

                if (selectedData[i].projectsid != '')
                    dataToPost.push("{ ProjectsId:'" + selectedData[i].projectsid + "', AnnoMese:'" + selectedData[i].annomese +
                        "', RevenueVersionCode:'" + selectedData[i].revenueversioncode +
                        "', ProjectCode:'" + selectedData[i].projectcode +
                        "', ProjectName:'" + selectedData[i].projectname +
                        "',  RevenueSpese:'" + selectedData[i].revenuespese + "'}");
            }

            $.ajax({

                type: "POST",
                url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateRevenueProgetti",
                data: JSON.stringify({ arr: dataToPost }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 

                    UnMaskScreen(); // reset cursore e finestra modale

                    if (msg.d == true)
                        ShowPopup("Aggiornato completato");
                    else
                        ShowPopup("Errore in aggiornamento");

                },

                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup("Errore in aggiornamento");
                    return false;
                }

            }); // ajax


        });  // tasto crea record

        var SFImportTable = new Tabulator("#TBImport", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            layout: "fitColumns",
            columns: [
                { title: "C", formatter: "tickCross", formatterParams: { allowEmpty: true }, width: 30 }, // , responsive: 1, cellClick: function (e, cell) { var a = cell.getValue(); if (a == "") cell.setValue("1"); else if(a == "1") cell.setValue("")} },
                { title: "ProcessingStatus", sorter: "string", headerFilter: "input", formatterParams: { allowTruthy: true }, width: 40 },
                { title: "ProjectCode", sorter: "string", headerFilter: "input", width: 100 },
                { title: "ProjectName", sorter: "string", headerFilter: "input" },
                { title: "ProjectsId", visible: false },

                { title: "AnnoMese", sorter: "string", headerFilter: "input", width: 100, align: "center", },
                { title: "RevenueVersionCode", visible: false },

                { title: "RevenueSpese", sorter: "string", align: "right", width: 80 },
                { title: "ProcessingMessage", sorter: "string", headerFilter: "input" },
            ],
        }); // Tabella principale

    </script>

</body>

</html>

