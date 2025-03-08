<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CTMPreinvoice-select.aspx.cs" Trace="false" Inherits="report_ricevute_select" EnableViewState="True" %>

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
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Fatturazione clienti" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server" data-parsley-validate>

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-5">

                    <div class="formtitle">Selezione Consuntivi</div>

                    <!-- *** DATE ***  -->
                    <div class="input">
                        <asp:Label ID="Label8" CssClass="inputtext" runat="server" Text="Estrazione da"></asp:Label>
                        <asp:TextBox runat="server" CssClass="ASPInputcontent" ID="TBDataDa" runat="server" MaxLength="10" Rows="8" Width="100px"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />

                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                        <asp:TextBox runat="server" CssClass="ASPInputcontent" ID="TBDataA" runat="server" Width="100px"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                    </div>

                    <!--  *** CLIENTE *** -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Cliente</div>
                        <asp:DropDownList ID="DDLCliente" runat="server" CssClass="SUMOselect"
                            AppendDataBoundItems="True" AutoPostBack="true" Visible="false">
                            <asp:ListItem Value="" Text="--- Tutti i clienti ---" />
                        </asp:DropDownList>
                    </div>

                    <!-- per tenere formattazione dopo ila div absolute-->

                    <!--  *** PROGETTO *** -->
                    <div class="input absolute nobottomborder">
                        <div class="inputtext">Progetto</div>
                        <asp:ListBox ID="LBProgetti" runat="server" SelectionMode="Multiple" Visible="false" CssClass="SUMOselect" AppendDataBoundItems="True" DataTextField="projectname" DataValueField="Projects_id"></asp:ListBox>
                    </div>

                    <!--  *** WBS *** -->
                    <div class="input nobottomborder absolute">
                        <div class="inputtext">Dettaglio WBS</div>
                        <asp:CheckBox ID="CBWBS" runat="server" />
                        <asp:Label runat="server" AssociatedControlID="CBWBS"></asp:Label>
                    </div>
                    <br />
                    <!-- per tenere formattazione dopo ila div absolute-->

                    <div class="buttons">
                        <div id="valMsg" class="parsley-single-error"></div>
                        <asp:Button ID="btnReport" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton" CommandName="report" OnClick="report_Click" />
                        <%--OnClick="sottometti_Click"--%>
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="document.location.href='/timereport/report/CTMBilling/CTMpreinvoice-list.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                        <span style="display: none">
                            <asp:Button ID="btnSubmit" runat="server" Text="per postback condizionato da javascript nella pagina" CommandName="sss" /></span>
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

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
        UnMaskScreen(); // reset cursore e finestra modale

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=reset], [disabled]"
        });

        $('.SUMOselect').SumoSelect({ search: true });
        $('#LBProgetti').SumoSelect({ placeholder: 'Progetti', search: true, searchText: 'Codice progetto' });
        $('.SumoSelect').css('width', '270px');

        // datepicker
        $("#TBDataDa").datepicker($.datepicker.regional['it']);
        $("#TBDataA").datepicker($.datepicker.regional['it']);

        // eventi
        $("#TBDataDa").change(function () {

            // se entrambi compilati faccio un postback
            if ($("#TBDataDa").val() && $("#TBDataA").val()) {
                MaskScreen(true); // cursore e finestra modale
                $("#btnSubmit").click();
            }

        });

        $("#DDLCliente").change(function (e) {
            MaskScreen(true); // cursore e finestra modale
        });

        $("#TBDataA").change(function () {

            // se entrambi compilati faccio un postback
            if ($("#TBDataDa").val() && $("#TBDataA").val()) {
                MaskScreen(true); // cursore e finestra modale
                $("#btnSubmit").click();
            }
        });

        $("#btnReport").click(function (e) {
            MaskScreen(true); // cursore e finestra modale
        });

    </script>

</body>

</html>

