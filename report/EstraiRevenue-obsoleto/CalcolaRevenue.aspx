<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CalcolaRevenue.aspx.cs" Trace="false" Inherits="report_esportaAttivita" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Calcola Revenue" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-5 StandardForm">

                    <div class="formtitle">Calcolo Revenue</div>

                    <!--  *** VERSIONE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Versione</div>
                        <asp:DropDownList ID="DDLRevenueVersion" runat="server" DataTextField="RevenueVersionDescription" DataValueField="RevenueVersionCode"
                            data-parsley-errors-container="#valMsg" data-parsley-checkversion="true"
                            DataSourceID="DS_RevenueVersion" Style="width: 150px">
                        </asp:DropDownList>
                    </div>

                    <!--  *** ALLA DATA *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Dalla data</div>
                        <asp:DropDownList Style="width: 150px" runat="server" ID="DDLFromMonth"></asp:DropDownList>
                        &nbsp;          
            <asp:DropDownList Style="width: 100px" runat="server" ID="DDLFromYear"></asp:DropDownList>
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Azione</div>
                        <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1">
                            <asp:ListItem Selected="True" Value="1">Calcola Revenue Mese</asp:ListItem>
                            <asp:ListItem Value="2">Cancella Revenue Mese</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                    <div class="buttons">
                        <div id="valMsg" class="parsley-single-error"></div>
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton" CommandName="Exec" OnClick="sottometti_Click" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(function () {

            // reset cursore e finestra modale
            UnMaskScreen();
        });

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // *** Custom Validator Parsley *** 
        window.Parsley.addValidator('checkversion', function (value, requirement) {

            // controllo che non esista una versione 00 nel mese di calcolo
            var response;
            var dataAjax = "{ RevenueVersionCode: '" + $("#DDLRevenueVersion").val() + "', " +
                " Anno: '" + $("#DDLFromYear").val() + "', " +
                " Mese: '" + $("#DDLFromMonth").val() + "' }";

            if ($("#RBTipoReport_1").prop("checked")) // se cancella va sempre bene
                return true;

            $.ajax({
                url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/CheckVersion", // nome del Web Service
                data: dataAjax,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false, // validazione sincrona
                success: function (data) {
                    response = data.d; // false esiste già versione
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(thrownError);
                }
            });
            return response;
        }, 32)
            .addMessage('it', 'checkversion', 'Esiste già un versione 00 sul mese');

        // al click del bottone disabilita lo schermo e cambia il cursore in wait
        $('#BtExec').click(function (e) {

            //Cancel the link behavior
            //e.preventDefault();

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            // NB: deve essere definito un elemento <div id="mask"></div> nel corpo del HTML
            MaskScreen(true);

        });

    </script>

    <asp:SqlDataSource ID="DS_RevenueVersion" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode + ' ' + RevenueVersionDescription as RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode"></asp:SqlDataSource>

</body>
</html>

