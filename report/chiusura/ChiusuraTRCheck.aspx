<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChiusuraTRCheck.aspx.cs" Inherits="report_chiusura_ChiusuraTRCheck" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Chiusura Timereport" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="FVMain" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
                    </div>

                    <div class="row mt-3 p-2">
                        <div class="col-1">
                            <asp:Image ID="CheckOreImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckOreImgResource1" Width="25px" />
                        </div>
                        <div class="col-6">
                            <asp:Label ID="CheckOre" runat="server" Text="Ore Caricate" meta:resourcekey="CheckOreResource1"></asp:Label>
                        </div>
                        <div class="col-3">
                            <div class="progress">
                                <div class="progress-bar" id="divbar" runat="server" role="progressbar" style="width: 10%"></div>
                            </div>
                        </div>
                        <div class="col-1">
                            <asp:Label ID="CheckOrePerc" runat="server" meta:resourcekey="CheckOrePercResource1"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->

                    <div class="row p-2">
                        <div class="col-1">
                            <asp:Image ID="CheckTicketAssentiImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckTicketImgResource1" Width="25px" />
                        </div>
                        <div class="col-9">
                            <asp:Label ID="CheckTicketAssenti" runat="server" Text="Check Ticket" meta:resourcekey="CheckTicketResource1"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->

                    <div class="row p-2">
                        <div class="col-1">
                                <asp:Image ID="CheckTicketHomeOfficeImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckTicketImgResource1" Width="25px" />
                        </div>
                        <div class="col-9">
                                <asp:Label ID="CheckTicketHomeOffice" runat="server" Text="Check Ticket" meta:resourcekey="CheckTicketResource1"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->

                    <div class="row p-2">
                        <div class="col-1">
                                <asp:Image ID="CheckSpeseImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckSpeseImgResource1" Width="25px" />
                        </div>
                        <div class="col-9">
                                <asp:Label ID="CheckSpese" runat="server" Text="Check Spese" meta:resourcekey="CheckSpeseResource1"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->

                    <div class="row p-2">
                        <div class="col-1">
                                <asp:Image ID="CheckAssenzeImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckSpeseImgResource1" Width="25px" />
                        </div>
                        <div class="col-9">
                                <asp:Label ID="CheckAssenze" runat="server" Text="" meta:resourcekey="CheckAssenze"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->

                    <!-- End Row -->
                    <div class="row p-2">
                        <div class="col-1">
                            <asp:Image ID="CheckOreMancantiImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckSpeseImgResource1" Width="25px" />
                        </div>
                        <div class="col-9">
                            <asp:Label ID="CheckOreMancanti" runat="server" Text="" meta:resourcekey="CheckOreMancanti"></asp:Label>
                        </div>
                    </div>
                    <!-- End Row -->
   
                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="Chiudi TR" meta:resourcekey="InsertButtonResource1" OnClick="InsertButton_Click" OnClientClick="return CheckIsRepeat();" />
                        <asp:Button ID="btStampaRicevute" runat="server" CommandName="Insert" CssClass="orangebutton" Text="Ricevute" meta:resourcekey="btStampaRicevuteResource1" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="CancelButtonResource1" />
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

    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        var submit = 0;
        function CheckIsRepeat() {
            if (++submit > 1) {
                return false;
            }
        }

    </script>

</body>

</html>
