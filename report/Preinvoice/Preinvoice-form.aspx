<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Preinvoice-form.aspx.cs" Inherits="Preinvoice_form" %>

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
        <asp:Literal runat="server" Text="Prefattura" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-5 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="Prefattura" />
                        <asp:Label ID="LBPreinvoiceNum" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Periodo"></asp:Label>
                        <asp:Label ID="LBPeriodo" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Società"></asp:Label>
                        <asp:Label ID="LBCompany" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Director(s)"></asp:Label>
                        <asp:Label ID="LBDirector" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Giorni"></asp:Label>
                        <asp:Label ID="LBDays" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Importo fees"></asp:Label>
                        <asp:Label ID="LBTotalRates" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Importo spese"></asp:Label>
                        <asp:Label ID="LBTotalExpenses" runat="server"></asp:Label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Importo totale"></asp:Label>
                        <asp:Label ID="LBTotalAmount" runat="server"></asp:Label>
                    </div>

                    <!-- *** TB Comment ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota"></asp:Label>
                        <asp:TextBox ID="TBDescription" runat="server" Rows="2" CssClass="textarea" TextMode="MultiLine" Columns="50" />
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Allegati"></asp:Label>
                        <asp:LinkButton ID="LinkButton1" runat="server" NavigateUrl="#" CssClass="link-primary" OnClick="Download_Preinvoice">Prefattura</asp:LinkButton>
                        <span>&nbsp &nbsp </span>
                        <asp:LinkButton ID="LinkButton2" runat="server" NavigateUrl="#" CssClass="link-primary" OnClick="Download_AllRatesQuery">Consuntivi Ore</asp:LinkButton>
                        <span>&nbsp &nbsp </span>
                        <asp:LinkButton ID="LinkButton3" runat="server" NavigateUrl="#" CssClass="link-primary" OnClick="Download_AllExpenseQuery">Consuntivi Spese</asp:LinkButton>
                    </div>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <div id="valMsg" class="col parsely-single-error"></div>
                        <asp:Button ID="BTSave" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings:    CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" formnovalidate />
                    </div>

                    <!-- *** campi nascosti usati da Javascript ***  -->
                    <asp:TextBox ID="TBcompanyId" CssClass="toHide" runat="server"  />
                    <asp:TextBox ID="TBPreinvoiceNumber" CssClass="toHide" runat="server"  />
                    <asp:TextBox ID="TBDataDa" CssClass="toHide" runat="server"  />
                    <asp:TextBox ID="TBDataA" CssClass="toHide" runat="server"  />

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

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
        UnMaskScreen(); // cursore e finestra modale

        // se non seleziona record o FLC mancanti
        const disableButtons = () => {
            $("#LinkButton1").hide();
            $("#LinkButton2").hide();
            $("#LinkButton3").hide();
            $("#BTSave").hide();
        }

        $("document").ready(() => {

            // nasconde i campi che hanno passato i valori dal server per fare la chiamata ajax
            $(".toHide").hide();
            $("#BTSave").hide();

            if ($("#TBPreinvoiceNumber").val() == 'nr') // in creazione, serve controllo FLC
                CheckFLC();              
        }
        );

        function CheckFLC() {

            // controllo FLC
            var values = "{'company_id': '" + $("#TBcompanyId").val() + "', 'dataDa' : '" + $("#TBDataDa").val() + "', 'dataA' : '" + $("#TBDataA").val() + "'  }";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/RP_Preinvoice.asmx/CheckFLC",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == "") {

                        if ($("#LBTotalAmount").text() == '0,00 €') {
                            ShowPopup("Non è stato selezionato nessun record!");
                            disableButtons();
                            return;
                        }
                        $("#BTSave").show();
                    }
                    else {
                        ShowPopup("<b>Controllare FLC per : </b><br>" + msg.d);
                        disableButtons();
                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax
        };

    </script>

</body>

</html>




