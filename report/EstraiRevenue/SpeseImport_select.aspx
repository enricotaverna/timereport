<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SpeseImport_select.aspx.cs" Trace="false" Inherits="SFimport_select" %>

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
<script src="/timereport/include/jquery/fileupload/jquery-filestyle.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />
<link href="/timereport/include/jquery/fileupload/jquery-filestyle.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Import Spese" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">Import Revenue Spese</div>

                    <!--  *** FILE  *** -->
                    <br />

                    <div class="input nobottomborder">
                        <div class="inputtext">File (.xls)</div>
                        <asp:FileUpload ID="FileUpload" runat="server" class="jfilestyle" data-text="seleziona" data-inputSize="160px" accept=".xlsx"
                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="" data-parsley-obbligofile="true"  />
                    </div>

                    <div class="input nobottomborder">

                        <!-- *** Checkboc Storno ***  -->
                        <div class="inputtext"></div>
                        <asp:CheckBox ID="CBSkipFirstRow" runat="server" Checked="True" />
                        <asp:Label AssociatedControlID="CBSkipFirstRow" runat="server" Text="intestazioni su prima riga"></asp:Label>
                    </div>

                    <!--  *** PERIODO / VERSIONE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Periodo</div>

                        <label class="dropdown" style="margin-right: 35px">
                            <asp:DropDownList ID="DDLAnnoMese" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                DataTextField="AnnoMeseDesc" DataValueField="AnnoMese" Style="width: 120px">
                            </asp:DropDownList>
                        </label>

                            <asp:DropDownList ID="DDLRevenueVersion" runat="server" AutoPostBack="True"
                                DataSourceID="DSRevenueVersion" DataTextField="RevenueVersionDescription" DataValueField="RevenueVersionCode" Style="width: 120px">
                            </asp:DropDownList>

                    </div>

                    <!--  *** AZIONE *** -->
                    <div class="input">
                        <div class="inputtext">Azione</div>
                        <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1" data-parsley-obbligofile="true" data-parsley-mandatory>
                            <asp:ListItem Selected="True" Value="1">Upload</asp:ListItem>
                            <asp:ListItem Value="2">Cancella Revenue Spese</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">File di esempio</div>
                        <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank" NavigateUrl="/timereport/report/EstraiRevenue/template/revenue-spese-template.xlsx" CssClass="link-primary">template excel</asp:HyperLink>
                    </div>

                    <br />

                    <div class="buttons">
                        <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                        <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton" CommandName="Exec" OnClick="Sottometti_Click" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/menu.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
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

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource runat="server" ID="DSRevenueVersion"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode+ ' ' + RevenueVersionDescription AS RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(document).ready(function () {
            UnMaskScreen(); // reset cursore e finestra modale

            $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET
        })

        // BOTTONE CANCELLA
        $('#BtExec').click(function (e) {

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            MaskScreen(true);

            if ($("#RBTipoReport_1").prop('checked')) { // cancellazione record
                $.ajax({

                    type: "POST",
                    url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/DeleteRevenueProgetti",
                    data: "{ AnnoMese: '" + $("#DDLAnnoMese").val() + "', RevenueVersionCode:'" + $("#DDLRevenueVersion").val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true)
                            ShowPopup("Cancellazione completata");
                        else
                            ShowPopup("Errore in aggiornamento");

                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore in aggiornamento");
                        return false;
                    }

                }); // ajax

                e.preventDefault(); // evita postback
                UnMaskScreen();
            }

        });

        // *** controllo che non esista lo stesso codice utente *** //
        window.Parsley.addValidator('obbligofile', function (value, requirement) {
            if ($("#RBTipoReport_0").prop('checked') && $("#FileUpload").val() == "")
                return false
            else
                return true;
            return 0;
        }, 32)
            .addMessage('it', 'obbligofile', 'Selezionare un file');

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

    </script>

</body>

</html>

