<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportRevenue.aspx.cs" Trace="false" Inherits="report_esportaAttivita" %>

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
    <title><asp:Literal runat="server" Text="Calcola Revenue" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server" data-parsley-validate>

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">Report</div>

                    <!--  *** MANAGER *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Mngr o Accnt</div>
                            <asp:DropDownList ID="DDLManager" runat="server" DataTextField="Name" DataValueField="Persons_id"
                                AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="DS_Persone" OnDataBound="DDLManager_DataBound">
                                <asp:ListItem Value="0">-- tutti i manager --</asp:ListItem>
                            </asp:DropDownList>
                    </div>

                    <!--  *** CLIENTE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Cliente</div>
                            <asp:DropDownList ID="DDLCliente" runat="server" DataTextField="NomeEsteso" DataValueField="Nome1"
                                AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="DS_CLienti"  >
                                <asp:ListItem Value="0">-- tutti i clienti --</asp:ListItem>
                            </asp:DropDownList>
                    </div>

                    <!--  *** PROGETTO *** -->
                    <div class="input ">
                        <div class="inputtext">Progetto</div>
                            <asp:DropDownList ID="DDLProgetto" runat="server" DataTextField="NomeProgetto" DataValueField="Projects_id"
                                AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="DS_Progetti"  >
                                <asp:ListItem Value="0">-- tutti i progetti --</asp:ListItem>
                            </asp:DropDownList>
                    </div>

                    <!--  *** VERSIONE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Versione</div>
                            <asp:DropDownList ID="DDLRevenueVersion" runat="server" DataTextField="RevenueVersionDescription" DataValueField="RevenueVersionCode"
                                DataSourceID="DS_RevenueVersion" Style="width: 150px">
                            </asp:DropDownList>
                    </div>

                    <!--  *** PERIODO *** -->
                    <div class="input">
                        <div class="inputtext">Periodo</div>
                            <asp:DropDownList Style="width: 150px" runat="server" ID="DDLPeriodo"></asp:DropDownList>
                    </div>

                    <!--  *** TIPO ESTRAZIONE *** -->
                    <div class="input nobottomborder tight">
                        <div class="inputtext">Estrazione</div>
                        <asp:RadioButtonList ID="RBTipoEstrazione" runat="server" RepeatColumns="1">
                            <asp:ListItem Value="1">Mese selezionato</asp:ListItem>
                            <asp:ListItem Selected="True" Value="2">Year to date</asp:ListItem>
                        </asp:RadioButtonList>  
                    </div>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton" CommandName="Exec" OnClick="sottometti_Click" />
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_Progetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_id, ProjectCode + ' ' + Name as 'NomeProgetto' FROM Projects WHERE Active = 1 ORDER BY ProjectCode"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_CLienti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT CodiceCliente, CodiceCliente + ' - ' + Nome1 as NomeEsteso, Nome1 FROM Customers ORDER BY CodiceCliente"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_RevenueVersion" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode + ' ' + RevenueVersionDescription as RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        window.onunload = function () { }; // forza refresh quando si torna sulla pagina con back (problema firefox)

        $(function () {
            UnMaskScreen();
            // reset cursore e finestra modale
            document.body.style.cursor = 'default';
        });

        $("#RBTipoReport").click(function () {

            var selValue = $('input[name=RBTipoReport]:checked').val();

            if (selValue != 2) {
                $('#lbDDLToMonth').hide();
                $('#lbDDLToYear').hide();
            }
            else {
                $('#lbDDLToMonth').show();
                $('#lbDDLToYear').show();
            }

        });

        // al click del bottone disabilita lo schermo e cambia il cursore in wait
        $('#BtExec').click(function () {

            //Get the screen height and width
            var maskHeight = $(document).height();
            var maskWidth = $(window).width();

            //Set heigth and width to mask to fill up the whole screen
            $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

            //transition effect		
            //$('#mask').fadeIn(200);
            $('#mask').fadeTo("fast", 0.5);


            document.body.style.cursor = 'wait';

        });

    </script>

</body>
</html>

