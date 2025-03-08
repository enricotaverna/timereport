<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ricevute_select.aspx.cs" Trace="false" Inherits="report_ricevute_select" EnableViewState="True" %>

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
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Report Ricevute" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server" data-parsley-validate>

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">Report Ricevute</div>

                    <!--  *** PROGETTO *** -->
                    <div class="input nobottomborder absolute">
                            <!-- aggiunto per evitare il troncamento della dropdonwlist -->
                            <div class="inputtext">Progetto</div>
                            <asp:DropDownList ID="DDLProject" runat="server" CssClass="SumoDLL"
                                AppendDataBoundItems="True" AutoPostBack="false" DataSourceID="SqlDSProjects" DataTextField="ProjectName" DataValueField="Projects_id">
                                <asp:ListItem Value="" Text="--- Tutti i progetti ---" />
                            </asp:DropDownList>
                    </div>

                    <!-- per tenere formattazione dopo ila div absolute-->

                    <!--  *** SOCIETA *** -->
                    <div class="input nobottomborder">
                            <!-- aggiunto per evitare il troncamento della dropdonwlist -->
                            <div class="inputtext">Società</div>
                            <asp:DropDownList ID="DDLSocieta" runat="server" CssClass="SumoDLL"
                                AppendDataBoundItems="True" AutoPostBack="false" DataSourceID="SQLDSSocieta" DataTextField="Name" DataValueField="Company_id">
                                <asp:ListItem Value="" Text="--- Tutte le società ---" />
                            </asp:DropDownList>
                    </div>

                    <!-- per tenere formattazione dopo ila div absolute-->

                    <!--  *** TIPO SPESA *** -->
                    <div class="input nobottomborder">
                            <!-- aggiunto per evitare il troncamento della dropdonwlist -->
                            <div class="inputtext">Tipo Spesa</div>
                            <asp:DropDownList ID="DDLTipoSpesa" runat="server" CssClass="SumoDLL"
                                AppendDataBoundItems="True" AutoPostBack="false" DataSourceID="SQLDSTipoSpesa" DataTextField="NomeSpesa" DataValueField="ExpenseType_Id">
                                <asp:ListItem Value="" Text="--- Tutte le spese ---" />
                            </asp:DropDownList>
                    </div>

                    <!-- per tenere formattazione dopo ila div absolute-->

                    <!--  *** FLAG FATTURA *** -->
                    <div class="input">
                        <div class="inputtext">Flag fattura</div>
                        <asp:DropDownList ID="DDLInvoiceFlag" runat="server" AutoPostBack="false"
                            AppendDataBoundItems="True">
                            <asp:ListItem Value="" Text="--- Tutti ---" />
                            <asp:ListItem Value="true" Text="Si" />
                            <asp:ListItem Value="false" Text="No" />
                        </asp:DropDownList>
                    </div>

                    <!--  *** ANNO *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Anno</div>
                        <asp:DropDownList ID="DDLAnni" runat="server"
                            AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLAnni_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <!--  *** MESE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Mese</div>
                        <asp:DropDownList ID="DDLMesi" runat="server"
                            AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLMesi_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>

                    <!--  *** PERSONA *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Persona</div>
                        <asp:DropDownList ID="DDLPersone" runat="server" 
                            AppendDataBoundItems="True" AutoPostBack="True">
                        </asp:DropDownList>
                    </div>

                    <div class="buttons">
                        <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton" CommandName="report" OnClick="sottometti_Click" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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
    <asp:SqlDataSource ID="SqlDSProjects" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ProjectCode + ' ' + Name as ProjectName, Projects_id FROM Projects ORDER BY ProjectName"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLDSSocieta" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Name, Company_id FROM Company ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLDSPersona" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT [Persons_id], [Name] FROM [Persons] WHERE ([Active] = 1) ORDER BY [Name]"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="SQLDSTipoSpesa" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ExpenseType_Id, ExpenseCode + ' ' + Name AS NomeSpesa FROM ExpenseType ORDER BY ExpenseCode"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $('.SumoDLL').SumoSelect({ search: true });

    </script>

</body>

</html>

