<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Straordinari-select.aspx.cs" Inherits="straordinari_select" %>

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
        <asp:Literal runat="server" Text="Straordinari" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-3">

                    <div class="formtitle">

                        <table>
                            <tr>
                                <td>
                                   <asp:HyperLink ID="btPrev" Style="text-align: center" runat="server"><i style='font-size:x-large;color:#343a40' class='fas fa-arrow-circle-left'></i></asp:HyperLink></td>
                                <td style="text-align: center; width: 100%">
                                    <asp:Label ID="AnnoCorrente" runat="server"></asp:Label></td>
                                <td>
                                    <asp:HyperLink ID="btNext" Style="text-align: center" runat="server"><i style='font-size:x-large;color:#343a40' class='fas fa-arrow-circle-right'></i></asp:HyperLink></td>
                            </tr>

                        </table>

                    </div>

                     <!-- *** SELEZIONE PER MESI ***  -->
                    <br />
                    <div class="d-flex flex-wrap justify-content-center" runat="server" id="ListaMesi">
                    </div>

                    <br />

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                    </div>

                </div>
                <%-- END FormWrap  --%>
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- END Contrainer --!>

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
