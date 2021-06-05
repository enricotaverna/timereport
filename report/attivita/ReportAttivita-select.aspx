<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportAttivita-select.aspx.cs" Trace="false" Inherits="report_esportaAttivita" %>

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
        <asp:Literal runat="server" Text="Report Attività" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server" data-parsley-validate>

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">Report</div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Progetto</div>
                            <asp:DropDownList ID="DDLProgetti" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True"
                                OnSelectedIndexChanged="DDLProgetti_SelectedIndexChanged">
                                <asp:ListItem Value="" Text="Selezionare un valore" />
                            </asp:DropDownList>
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Fasi</div>
                            <asp:DropDownList ID="DDLFasi" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True"
                                OnSelectedIndexChanged="DDLFasi_SelectedIndexChanged">
                                <asp:ListItem Value="" Text="Selezionare un valore" />
                            </asp:DropDownList>
                    </div>

                    <div class="input ">
                        <div class="inputtext">Attività</div>
                            <asp:DropDownList ID="DDLAttivita" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True">
                                <asp:ListItem Value="" Text="Selezionare un valore" />
                            </asp:DropDownList>
                    </div>

                    <!-- *** Valore & storno***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Dalla data</div>
                            <asp:DropDownList Style="width: 150px" runat="server" ID="DDLFromMonth"></asp:DropDownList>

                            <asp:DropDownList Style="width: 100px" runat="server" ID="DDLFromYear"></asp:DropDownList>
                    </div>

                    <div class="input">
                        <div class="inputtext">Alla data</div>
                            <asp:DropDownList Style="width: 150px" runat="server" ID="DDLToMonth"></asp:DropDownList>

                            <asp:DropDownList Style="width: 100px" runat="server" ID="DDLToYear"></asp:DropDownList>
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Estrazione</div>
                        <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1">
                            <asp:ListItem Selected="True" Value="1">Totali attività</asp:ListItem>
                            <asp:ListItem Value="2">Dettaglio Persone</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                    <div class="buttons">
                        <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton" CommandName="report" OnClick="sottometti_Click" />
                        <asp:Button ID="download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" OnClick="sottometti_Click" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/menu.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                    </div>

                </div>
                <!-- FormWrap -->

            </div>
            <!-- LastRow -->

        </form>
        <!-- Form  -->
    </div>
    <!-- container -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.CutoffDate %></div>
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

