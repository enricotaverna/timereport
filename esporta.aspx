<%@ Page Language="C#" AutoEventWireup="true" CodeFile="esporta.aspx.cs" Inherits="Esporta" %>

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
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<!-- ** stili per sumo dropdonw ** --> 
<style>
    .custom-checkboxradio-label {
        padding: .5em 1em !important;
        border-radius: 6px !important;
        box-shadow: none !important;
    }

    .input {
        line-height: 45px !important;
    }

    .SumoSelect {
        width: 280px;
    }

    .StandardForm input {
     margin: 4px; /* per formattazione export spese */
}

</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Esporta" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
        <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="form1" runat="server">

            <div class="row justify-content-center">

                <!--**** Riquadro navigazione ***-->
                <div class="form-group row justify-content-center">
                    <div class="col-9 RoundedBox" style="height: 100px">

                        <div class="row">
                            <div class="col-5">
                                <div class="btn-group" role="group">
                                    <asp:Button ID="btPrjAttivi" CommandName="btPrjAttivi" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="<%$ Resources: Attivi %>" />
                                    <asp:Button ID="btPrjAll" CommandName="btPrjAll" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="<%$ Resources: Tutti %>" />
                                </div>
                                <div runat="server" id="btChargeable" class="btn-group ms-2" role="group">
                                    <asp:Button ID="btCharge" CommandName="btCharge" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="Chargeable" />
                                    <asp:Button ID="btChargeAll" CommandName="btChargeAll" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="Tutti" />
                                </div>
                            </div>
                            <div class="col-1">
                                <div class="btn-group" role="group">
                                    <asp:Button ID="btPerAttivi" CommandName="btPerAttivi" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="Attive" />
                                    <asp:Button ID="btPerAll" CommandName="btPerAll" runat="server" type="button" OnCommand="BottoniToggle" CausesValidation="False" Text="Tutte" />
                                </div>
                            </div>
                            <div class="col-3">
                            </div>
                        </div>
                        <!-- End row -->

                        <div class="row mt-2">
                            <!-- margine per separare le righe -->

                            <div class="col-5">
                                <div style="position: absolute">
                                    <!-- aggiunto per evitare il troncamento della dropdonwlist -->

                                    <span>
                                        <asp:ListBox ID="CBLProgetti" runat="server" SelectionMode="Multiple" DataSourceID="DSProgetti" DataTextField="txtcodes"
                                            DataValueField="Projects_id"  data-placeholder="<%$ Resources:selprogetti%>" ></asp:ListBox> 
                                    </span>

                                </div>
                            </div>
                            <div class="col-4">
                                <div style="position: absolute">
                                    <!-- aggiunto per evitare il troncamento della dropdonwlist -->

                                    <span>
                                        <asp:ListBox ID="CBLPersone" runat="server" SelectionMode="Multiple" DataSourceID="DSPersone" DataTextField="name" Style="text-align: left"
                                            DataValueField="Persons_id" data-placeholder="<%$ Resources:selpersone%>" meta:resourcekey="CBLPersoneResource1" ></asp:ListBox>
                                    </span>

                                </div>
                            </div>
                        </div>

                    </div>
                    <!-- Fine Row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">

                <div id="FormWrap" class="StandardForm col-9">

                    <div class="formtitle">Report</div>

                    <div class="input nobottomborder" id="DivCliente" runat="server">
                        <div class="inputtext">
                            <asp:Literal runat="server" Text="<%$ Resources:cliente%>" />
                        </div>

                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLClienti" runat="server" DataSourceID="Clienti"
                            DataTextField="coddes" DataValueField="CodiceCliente"
                            AppendDataBoundItems="True" meta:resourcekey="DDLClientiResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource1" />
                        </asp:DropDownList>

                    </div>

                    <div class="input nobottomborder" id="DivManager" runat="server">
                        <div class="inputtext">Mngr o Account</div>

                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="Manager"
                            DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True" meta:resourcekey="DDLManagerResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource2" />
                        </asp:DropDownList>
                    </div>

                    <div class="input nobottomborder" id="DivSocieta" runat="server">
                        <div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:societa%>" /></div>
                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLsocieta" runat="server" DataSourceID="societa"
                            DataTextField="Name" DataValueField="Company_id"
                            AppendDataBoundItems="True" meta:resourcekey="DDLsocietaResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource3" />
                        </asp:DropDownList>
                    </div>

                    <div class="input" style="display: flex;align-items: center;">
                        <div class="inputtext">
                            <asp:Literal runat="server" Text="<%$ Resources:rangedate%>" />
                        </div>

                        <span style="position: relative; float: left">
                            <asp:DropDownList runat="server" ID="DDLFromMonth" Width="170px"></asp:DropDownList>
                        </span>

                        <span style="position: relative; left: 10px; float: left; width: 100px">
                            <asp:DropDownList runat="server" ID="DDLFromYear" Width="100px"></asp:DropDownList>
                        </span>

                        <span style="position: relative; left: 70px; float: left; width: 170px">
                            <asp:DropDownList runat="server" ID="DDLToMonth" Width="170px"></asp:DropDownList>
                        </span>

                        <span style="position: relative; left: 80px; float: left; width: 100px">
                            <asp:DropDownList runat="server" ID="DDLToYear" Width="100px"></asp:DropDownList>
                        </span>

                    </div>

                    <div class="input nobottomborder mt-3 mb-4" style="overflow:hidden">
                        <div class="inputtext">
                            <asp:Literal runat="server" />
                        </div>

                        <span class="Inputcontent" 
                            style="position: relative; padding-top: 15px; border: 1px solid #C7C7C7; border-radius: 6px; margin-top: 10px; float: left; line-height: 24px">
                            <span style="position: absolute; top: -10px; left: 5px; background-color: white; font-size: 10pt"><i class="fas fa-download" style="font-size: 1.2em;"></i>&nbspExport&nbsp</span>


                            <asp:RadioButtonList ID="RBTipoExport" runat="server" meta:resourcekey="RBTipoReportResource1" RepeatColumns="1" Width="220px" >
                                <asp:ListItem Value="1" Text="<%$ Resources:exportore%>"></asp:ListItem>
                                <asp:ListItem Value="2" Text="<%$ Resources:exportspese%>"></asp:ListItem>
                            </asp:RadioButtonList>
                        </span>
                        <span class="Inputcontent"
                            style="position: relative; padding-top: 15px; border: 1px solid #C7C7C7; border-radius: 6px; margin-top: 10px; margin-left: 20px; float: left; line-height: 24px">
                            <span style="position: absolute; top: -10px; left: 5px; background-color: white; font-size: 10pt"><i class="fas fa-chart-bar" style="font-size: 1.2em;"></i>&nbspReport&nbsp</span>

                            <asp:RadioButtonList ID="RBTipoReport" runat="server" meta:resourcekey="RBTipoReportResource1" RepeatColumns="2" Width="380px">
                                <asp:ListItem Value="3" Text="<%$ Resources:orepermese%>"></asp:ListItem>
                                <asp:ListItem Value="4" Text="<%$ Resources:spesepermese%>"></asp:ListItem>
                                <asp:ListItem Value="5" Text="<%$ Resources:dettaglioore%>"></asp:ListItem>
                                <asp:ListItem Value="6" Text="<%$ Resources:dettagliospese%>"></asp:ListItem>
                            </asp:RadioButtonList>
                        </span>

                    </div>

                    <div class="buttons">
                        <asp:Button ID="BTexec" runat="server" Text="<%$ Resources:timereport,EXEC_TXT%>" CssClass="orangebutton" PostBackUrl="/timereport/esporta.aspx" OnClick="Sottometti_Click" CausesValidation="False" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" formnovalidate />
                    </div>

                </div>
                <%-- END FormWrap  --%>
            </div>
            <!-- END Row  -->

        </form>

    </div>
    <!-- END MainWindow -->

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
    <asp:SqlDataSource ID="DSProgetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="***"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSPersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="*"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Clienti" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [CodiceCliente], ([CodiceCliente] + ' ' + [Nome1]) as coddes FROM [Customers] WHERE ([FlagAttivo] = @FlagAttivo) ORDER BY [CodiceCliente]">
        <SelectParameters>
            <asp:Parameter DefaultValue="1" Name="FlagAttivo" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="societa" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [Company_id], [Name] FROM [Company] ORDER BY [Name]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="Manager" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="1" Name="Active" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(window).bind("pageshow", function (event) {
            if (event.originalEvent.persisted) {
                window.location.reload()
            }
        });

        $(function () {

            // reset cursore e finestra modale
            //document.body.style.cursor = 'default';
            //$('#mask').css({ 'width': 0, 'height': 0 });

            // imposta css della listbox
            $('#CBLProgetti').SumoSelect({ placeholder: '<%= GetLocalResourceObject("Progetti").ToString()  %> ', search: true, searchText: '<%= GetLocalResourceObject("Codice_progetto").ToString()  %> ' });
            $('#CBLPersone').SumoSelect({ placeholder: 'Persone', search: true, searchText: 'Codice progetto' });
            $('#DDLClienti').SumoSelect({ placeholder: 'Selezionare un valore', search: true});
            $('#DDLManager').SumoSelect({ placeholder: 'Selezionare un valore', search: true });
            $('#DDLsocieta').SumoSelect({ placeholder: 'Selezionare un valore', search: true });

            // cancella selezione dei radiobutton in caso sia stato selezionato l'altro gruppo
            $("#RBTipoExport").on('change', function () {
                $("input[name=RBTipoReport]").prop('checked', false);
            })

            $("#RBTipoReport").on('change', function () {
                $("input[name=RBTipoExport]").prop('checked', false);
            })

            $("#BTexec").click(function () {

                if ($("input[name='RBTipoExport']:checked").val() == 1 || $("input[name='RBTipoExport']:checked").val() == 2)
                    return;

                MaskScreen(true);

            });


        });

    </script>

</body>

</html>
