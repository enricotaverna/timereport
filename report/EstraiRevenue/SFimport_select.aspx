<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SFimport_select.aspx.cs" Trace="false" Inherits="SFimport_select" %>

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
        <asp:Literal runat="server" Text="Import Sales Force" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">Import Sales Force</div>

                    <!--  *** VERSIONE *** -->
                    <br />

                    <div class="input nobottomborder">
                        <div class="inputtext">File</div>
                        <asp:FileUpload ID="FileUpload" runat="server" class="jfilestyle" data-text="seleziona" data-inputSize="160px" accept=".xlsx"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-error-message="Specificare un nome file" />
                    </div>

                    <!--  *** Tipo controllo *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Tipo controllo</div>
                            <asp:DropDownList ID="DDLImport" runat="server"
                                AppendDataBoundItems="True">
                                <asp:ListItem Value="0">tutti i progetti esportati</asp:ListItem>
                                <asp:ListItem Value="1">progetti con carichi nel mese corrente</asp:ListItem>
                                <asp:ListItem Value="2">progetti con carichi nel mese precedente</asp:ListItem>
                            </asp:DropDownList>
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">File di esempio</div>
                        <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank" NavigateUrl="/timereport/report/EstraiRevenue/template/sf-template.xlsx" CssClass="link-primary">template excel</asp:HyperLink>
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

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(function () {
            // reset cursore e finestra modale
            UnMaskScreen();
        });

        $('#BtExec').click(function (e) {

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            MaskScreen(true);
        });

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

    </script>

</body>
</html>

