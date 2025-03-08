<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AWSClient.aspx.cs" Inherits="m_utilita_AWSClient_AWSClient" %>

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

<style>
    .inputtext, .ASPInputcontent {
        Width: 220px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Avvio istanza AWS" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="NOME_FORM" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-6 StandardForm">



                    <div class="formtitle">Avvio ambiente Demo</div>

                    <div class="input nobottomborder">
                        <asp:Literal runat="server" Text="L'istanza AWS in questo momento è in stato:" />
                    </div>

                    <div class="input nobottomborder" style="font-size: xx-large; text-align: center;">
                        <asp:Label ID="lbStato" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label ID="lbStartupMessage" runat="server">Dopo l'avvio aspettare qualche minuto prima di provare il logon a SAP.<br /></asp:Label>
                        Lo shutdown della macchina è schedulato automaticamente per le ore 18:00</>
                    </div>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" style="width:150px" Text="<%$ appSettings: START_TXT %>" OnClick="InsertButton_Click" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" formnovalidate />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- *** End container *** -->

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
    <script type="text/javascript">

        $(function () {

            // include di snippet html per menu and background color mgt
            includeHTML();
            InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

            // *** attiva validazione campi form
            $('#formLeaveRequest').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
            });

        });
    </script>

</body>

</html>
