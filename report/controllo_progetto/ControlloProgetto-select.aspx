<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlloProgetto-select.aspx.cs" Trace="false" Inherits="report_ControlloProgettoSelect" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Controllo progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server" data-parsley-validate>

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="Controllo Progetto" />
                    </div>

                    <div style="margin-top: 30px"></div>

                    <!--  *** PROGETTO *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Progetto</div>
                            <asp:DropDownList ID="DDLProgetti" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLProgetti_SelectedIndexChanged">
                            </asp:DropDownList>
                       </div>

                    <!--  *** MANAGER *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Responsabile</div>
                            <asp:DropDownList ID="DDLManager" runat="server" DataTextField="Name" DataValueField="Persons_id" data-parsley-errors-container="#valMsg" data-parsley-required="true"
                                AppendDataBoundItems="True" AutoPostBack="True" OnDataBound="DDLManager_DataBound" DataSourceID="DS_Persone" data-parsley-required-message="Specificare un valore per Responsabile" >
                                <asp:ListItem Value="">-- Manager o Account --</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    <br />

                    <!--  **** DATA REPORT ** -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Data Report:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBDataReport" runat="server" MaxLength="10" Rows="12" Columns="10"  Enabled="False" />
                    </div>

                    <!--  **** DATA REPORT ** 
                        
                       // forzato default calcolo Tipo 0

                       <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Metodo calcolo"></asp:Label>--                        
                        <asp:RadioButtonList ID="RBTipoCalcolo" runat="server"> 
                            <asp:ListItem Value="0" Selected="True">Budget Totale</asp:ListItem>
                            <asp:ListItem Value="1">Budget Netto ABAP</asp:ListItem>
                        </asp:RadioButtonList>--%>

                    </div> -->

                    <div class="buttons">
                        <div id="valMsg" class="parsley-single-error"></div>
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
    
    <!-- *** Selezione tutti quelli che sono account o manager di un progetto CHARGEABLE *** -->
    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON ( Persons.Persons_id = Projects.ClientManager_id OR  Persons.Persons_id = Projects.AccountManager_id ) WHERE (Persons.Active = @Active AND Projects.ProjectType_id = '1')  ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $('.SumoDLL').SumoSelect({ search: true });
        $('#DDLProgetti').SumoSelect({ placeholder: 'Progetti', search: true, searchText: 'Codice progetto' });
        $('#DDLManager').SumoSelect({ placeholder: 'Director', search: true, searchText: 'Director' });

        //$(function () {
        //    // datepicker
        //    $("#TBDataReport").datepicker($.datepicker.regional['it']);
        //});

        // *** Esclude i controlli nascosti *** 
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        // Quando il form è valido
        $('#FVForm').parsley().on('form:success', function () {
            MaskScreen(true);
        });

    </script>

</body>

</html>

