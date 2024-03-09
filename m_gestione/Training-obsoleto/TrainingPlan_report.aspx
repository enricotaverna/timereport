<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrainingPlan_report.aspx.cs" Trace="false" Inherits="report_ControlloProgettoSelect" %>

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
        <asp:Literal runat="server" Text="Piano Training" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="RVFOrm" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">Training Plan Report</div>

                    <br />
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Anno"></asp:Label>
                        <label id="lbDDLAttivita" class="dropdown">
                            <!-- per stile CSS -->
                            <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True">
                                <asp:ListItem Value="0">--tutti gli anni--</asp:ListItem>
                            </asp:DropDownList>
                        </label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Manager"></asp:Label>
                        <label id="lbDDLManager" class="dropdown">
                            <!-- per stile CSS -->
                            <asp:DropDownList ID="DDLManager" runat="server" AppendDataBoundItems="True" DataSourceID="DSManager" DataTextField="Name" DataValueField="Persons_id">
                                <asp:ListItem Value="0">--tutti i manager --</asp:ListItem>
                            </asp:DropDownList>
                        </label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Consulente"></asp:Label>
                        <label id="lbDDLPersons" class="dropdown">
                            <!-- per stile CSS -->
                            <asp:DropDownList ID="DDLPersons" runat="server" AppendDataBoundItems="True" DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id">
                                <asp:ListItem Value="0">--tutte le persone --</asp:ListItem>
                            </asp:DropDownList>
                        </label>
                    </div>

                    <br />

                    <div class="buttons">
                        <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                        <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton" CommandName="report" OnClick="sottometti_Click" />
                        <asp:Button ID="CancelButton" runat="server" formnovalidate="" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DSmanager" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) and ( UserLevel_ID = '4' OR UserLevel_ID = '5' ) and Company_id = '1'   ORDER BY Name"></asp:SqlDataSource>

    <asp:SqlDataSource ID="DSPersons" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) and Company_id = '1' ORDER BY Name"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>



</html>

