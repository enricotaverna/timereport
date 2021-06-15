<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DettaglioOreNonCaricate.aspx.cs" Inherits="report_checkInput_DettaglioOreNonCaricate" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Dettagli Ore" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <table class="TabellaLista">
                        <tr>
                            <th>Mese</th>
                        </tr>
                        <tr class="GV_row">
                            <td><%= Request.QueryString["mese"] %>/<%= Request.QueryString["anno"] %></td>
                        </tr>
                    </table>

                    <br />

                    <table class="TabellaLista">
                        <tr>
                            <th colspan="2">Dettagli persona
                            </th>
                        </tr>
                        <tr class="GV_row">
                            <td>Nome:</td>
                            <td>
                                <asp:Label ID="lblNome" runat="server" Text=""></asp:Label></td>
                        </tr>
                        <tr class="GV_row_alt">
                            <td>Società:</td>
                            <td>
                                <asp:Label ID="lblSocieta" runat="server" Text=""></asp:Label></td>
                        </tr>
                        <tr class="GV_row">
                            <td>Indirizzo e-mail:</td>
                            <td>
                                <asp:HyperLink ID="lblMail" runat="server"></asp:HyperLink></td>
                        </tr>
                        <tr class="GV_row_alt">
                            <td>Ore lavorative:</td>
                            <td>
                                <asp:Label ID="lblOre" runat="server" Text=""></asp:Label></td>
                        </tr>
                    </table>

                    <br />

                    <!-- *** GRID ***  -->
                    <asp:GridView ID="GVDettaglioOre" runat="server" CssClass="GridView" GridLines="None">
                        <HeaderStyle CssClass="GV_header" />
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <AlternatingRowStyle CssClass="GV_row_alt" />
                    </asp:GridView>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" OnClientClick="JavaScript:window.history.back(1);return false;" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>

</html>
