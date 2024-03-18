<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PresenzeSpese.aspx.cs" Inherits="report_PresenzeSpese" EnableEventValidation="false" %>

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
    <title><asp:Literal runat="server" Text="Check chiusure" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-3 StandardForm">

                    <div class="formtitle">

                        <table>
                            <tr>
                                <td>
                                    <asp:HyperLink ID="btPrev" runat="server"><i style='font-size:x-large;color:#343a40' class='fas fa-arrow-circle-left'></i></asp:HyperLink></td>
                                <td style="text-align: center; width:100%">
                                    <asp:Label ID="AnnoCorrente" runat="server"></asp:Label></td>
                                <td>
                                    <asp:HyperLink ID="btNext" runat="server"><i style='font-size:x-large;color:#343a40' class='fas fa-arrow-circle-right'></i></asp:HyperLink></td>
                            </tr>

                        </table>

                    </div>

                     <!-- *** SELEZIONE PER MESI ***  -->
                    <br />
                    <div class="d-flex flex-wrap justify-content-center" runat="server">  
                        <asp:Button ID="M1" runat="server" Text="Gennaio" CssClass="bottone-mese"  OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M2" runat="server" Text="Febbraio" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M3" runat="server" Text="Marzo" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M4" runat="server" Text="Aprile" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M5" runat="server" Text="Maggio" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M6" runat="server" Text="Giugno" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M7" runat="server" Text="Luglio" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M8" runat="server" Text="Agosto" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M9" runat="server" Text="Settembre" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M10" runat="server" Text="Ottobre" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M11" runat="server" Text="Novembre" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="M12" runat="server" Text="Dicembre" CssClass="bottone-mese" OnClick="Sottometti_Click" CausesValidation="False" />                        
                    </div>
                    <br />

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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

        function estrai() {
            alert('aaaa');
        }

    </script>

</body>
</html>
