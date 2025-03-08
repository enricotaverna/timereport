<%@ Page Language="C#" AutoEventWireup="true" CodeFile="selection-utenti.aspx.cs" Inherits="m_gestione_ForzaUtenti_selection_utenti" %>

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
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Forza Spese e Ore" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-5 StandardForm">

                    <!-- *** TITOLO FORM ***  -->
                    <div class="formtitle">Selezionare</div>

                    <div style="margin-top: 30px"></div>

                    <!-- *** SELECT ***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Consulente </div>
                        <asp:DropDownList ID="DDLConsultantTo" runat="server" DataTextField="Name" DataValueField="Persons_id"
                            AppendDataBoundItems="True" AutoPostBack="False" DataSourceID="DSPersone" Style="width: 250px">
                            <asp:ListItem Text="-- Tutti i consulenti --" Value="" />
                        </asp:DropDownList>
                    </div>

                    <div style="margin-top: 30px"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_submit" runat="server" class="orangebutton" Text="<%$ appSettings: EXEC_TXT %>" OnClick="Submit_Click" />
                        <asp:Button ID="btn_copy" runat="server" class="orangebutton" Text="<%$ appSettings: COPY_TXT %>" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->

            <%--DIALOG--%>
            <div id="ModalWindow">
                <div id="dialog" class="window">
                    <div id="FormWrap1" class="StandardForm">
                        <div class="formtitle">Copia autorizzazioni da</div>

                        <div style="margin-top: 30px"></div>

                        <div class="input nobottomborder" style="height: 60px">
                            <div class="inputtext">Consulente </div>
                            <asp:DropDownList ID="DDLConsultantFrom" runat="server" DataTextField="Name" DataValueField="Persons_id"
                                AppendDataBoundItems="True" AutoPostBack="False" DataSourceID="DSPersone" Style="width: 250px">
                            </asp:DropDownList>
                        </div>

                        <div class="buttons">
                            <div id="valMsg" class="parsley-single-error"></div>
                            <button id="btnSalvaModale" class="orangebutton">Salva</button>
                            <button id="btnCancelModale" class="greybutton">Annulla</button>
                        </div>
                    </div>
                </div>
            </div>
            <%--DIALOG--%>
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
    <asp:SqlDataSource runat="server" ID="DSPersone" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** attiva validazione campi form
        $('#FVMain').parsley();

        $('#DDLConsultantTo, #DDLConsultantFrom').SumoSelect({ search: true });

        $("#btn_copy").on("click", function (e) {
            //Cancel the link behavior
            e.preventDefault();

            if ($('#DDLConsultantTo').val() == "") {
                ShowPopup("Selezionare consulente");
                return false;
            }

            //initValue();  // inizializza campi
            openDialogForm("#dialog", "#FVMain", "#btnCancelModale")

        });

        // Controlla se ci sono le condizioni per copiare le autorizzazioni
        $("#btnSalvaModale").on("click", function (e) {

            e.preventDefault();
            ConsultantFrom = $('#DDLConsultantFrom').val();
            ConsultantTo = $('#DDLConsultantTo').val();

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_ForcedAccounts.asmx/CheckBeforeCopy",
                data: JSON.stringify({ ConsultantFrom: ConsultantFrom, ConsultantTo: ConsultantTo }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d.Success == true) {
                        CopiaAutorizzazioni(ConsultantFrom, ConsultantTo);
                    } else {

                        $('#mask').hide();
                        $('.window').hide();

                        if (!msg.d.deleteConfirm) // errore generico
                            ShowPopup(msg.d.Message);
                        else  // esistono già record, chiede conferma per sovrascrivere
                            ConfirmDialog("Conferma Copia", msg.d.Message, "Copia", (confirm) => { confirm && CopiaAutorizzazioni(ConsultantFrom, ConsultantTo) });
                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    $('#mask').hide();
                    $('.window').hide();
                    ShowPopup("Errore server in salvataggio tabella");
                    return false;
                }
            });
        });

        // Chiama la funzione per copiare le autorizzazioni
        function CopiaAutorizzazioni(ConsultantFrom, ConsultantTo) {

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_ForcedAccounts.asmx/CopyForcedRecords",
                data: JSON.stringify({ ConsultantFrom: ConsultantFrom, ConsultantTo: ConsultantTo }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d.Success == true) {
                        $('#mask').hide();
                        $('.window').hide();
                        e.preventDefault();
                        ShowPopup("Copia autorizzazioni avvenuta");
                    } else {
                        $('#mask').hide();
                        $('.window').hide();
                        ShowPopup(msg.d.Message);
                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    $('#mask').hide();
                    $('.window').hide();
                    ShowPopup("Errore server in salvataggio tabella");
                    return false;
                }
            });
        }

    </script>

</body>

</html>


