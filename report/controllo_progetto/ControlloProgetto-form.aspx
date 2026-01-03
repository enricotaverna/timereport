<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlloProgetto-form.aspx.cs" Inherits="m_gestione_Project_Projects_lookup_form" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Tabulator  -->
<script type="text/javascript" src="https://unpkg.com/tabulator-tables@6.3.0/dist/js/tabulator.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="https://unpkg.com/tabulator-tables@6.3.0/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<style>
/* Add border only to table and its cells */
.table-border-only {
    border: 1px solid grey;
}

/* forzatura stile per form economics  */
.nobottomborder {
    margin: 0px 30px 5px 10px;
}

/* Stile Tabulator per Economics - sovrascrive stili globali */
#EconomicsTable.tabulator {
    border: 1px solid grey;
    font-size: 14px;
    font-family: OpenSans-Regular, Arial, sans-serif;
    border-radius: 0 !important;
}

#EconomicsTable .tabulator-header {
    background-color: #212529 !important;
    color: white !important;
    font-weight: 600;
    border-radius: 0 !important;
    border: none !important;
}

#EconomicsTable .tabulator-col {
    background: #212529 !important;
    border-left: 1px solid grey !important;
    border-right: none !important;
    border-top: none !important;
    border-bottom: 1px solid grey !important;
    border-radius: 0 !important;
}

#EconomicsTable .tabulator-row {
    min-height: 31px;
    border-bottom: 1px solid grey !important;
    background: white !important;
}

#EconomicsTable .tabulator-row:hover {
    background-color: rgba(0,0,0,.075) !important;
}

#EconomicsTable .tabulator-cell {
    padding: 0.3rem;
    border: none !important;
}

/* Altezza fissa per tab pages */
.tab-content .tab-pane {
    min-height: 460px;
    height: 460px;
    overflow-y: auto;
}
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="MainForm" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" runat="server" class="StandardForm col-7" style="max-width: 58.333333%; overflow: hidden;">

                    <asp:FormView ID="FVProgetto" runat="server" DataKeyNames="Projects_Id"
                        DataSourceID="projects" OnItemUpdated="FVProgetto_ItemUpdated"
                        DefaultMode="Edit" Width="100%">

                        <EditItemTemplate>

                            <div id="tabs">

                                <!-- *** MULTI TAB BOOTSTRAP *** -->
                                <ul class="nav nav-tabs" id="mainTabs" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link active" id="tab-progetto" data-bs-toggle="tab" href="#tabs-1" role="tab" aria-controls="tabs-1" aria-selected="true">Progetto</a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link" id="tab-economics" data-bs-toggle="tab" href="#tabs-2" role="tab" aria-controls="tabs-2" aria-selected="false">Economics</a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link" id="tab-risorse" data-bs-toggle="tab" href="#tabs-3" role="tab" aria-controls="tabs-3" aria-selected="false">Risorse</a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link" id="tab-actuals" data-bs-toggle="tab" href="#tabs-4" role="tab" aria-controls="tabs-4" aria-selected="false">Actuals</a>
                                    </li>
                                </ul>
                                <div class="tab-content" id="mainTabsContent">
                                    <div class="tab-pane fade show active" id="tabs-1" role="tabpanel" aria-labelledby="tab-progetto">

                                        <asp:HiddenField runat="server" ID="TBProjects_id" Value='<%# Bind("Projects_id") %>' />

                                        <br />


                                        <!-- *** NOME PROGETTO ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Progetto: </div>
                                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("ProjectName") %>'
                                                Columns="50" MaxLength="50" class="ASPInputcontent"
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" Enabled="False" />
                                        </div>
  

                                        <!-- *** CODICE CLIENTE ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Cliente:</div>
                                            <asp:DropDownList ID="DDLCliente" runat="server" DataSourceID="cliente" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true"
                                                DataTextField="Nome1" DataValueField="CodiceCliente" AppendDataBoundItems="True"
                                                SelectedValue='<%# Bind("CodiceCliente") %>' Enabled="False">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                        </div>

                                        <!-- *** CODICE MANAGER ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Manager:</div>
                                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="manager"
                                                DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True"
                                                SelectedValue='<%# Bind("ClientManager_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" Enabled="False">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                        </div>

                                        <!-- *** CODICE ACCOUNT ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Account:</div>
                                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="account"
                                                DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True"
                                                SelectedValue='<%# Bind("AccountManager_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" Enabled="False">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                        </div>

                                        <!-- *** TIPO CONTRATTO ***  -->
                                        <div class="input ">
                                            <div class="inputtext">Contratto: </div>
                                            <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="TipoContratto" DataTextField="Descrizione"
                                                DataValueField="TipoContratto_id"
                                                SelectedValue='<%# Bind("TipoContratto_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" Enabled="False">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>

                                            <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' Enabled="False" />
                                            <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="Label3" runat="server" Text="No Overtime"></asp:Label>
                                        </div>

                                        <br />
                                        
                                        <!-- *** IMPORTO REVENUE ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Revenue: </div>
                                            <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%#  Bind("RevenueBudget", "{0:#,####}") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                            <label>€</label>
                                        </div>

                                        <!-- *** IMPORTO SPESE ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Spese: </div>
                                            <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%#  Bind("SpeseBudget", "{0:#,####}") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                            <label>€</label>
                                            <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                            <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="incluse"></asp:Label>
                                        </div>

                                        <!-- *** MARGINE TARGET ***  -->
                                        <div class="input nobottomborder">
                                            <div class="inputtext">Margine: </div>
                                            <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                            <label>%</label>
                                        </div>

                                        <!-- *** DATA INIZIO  ***  -->
                                        <div class="input nobottomborder">
                                            <asp:Label ID="Label8" CssClass="inputtext" runat="server" Text="Durata da"></asp:Label>
                                            <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" Enabled="False" />

                                            <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                            <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoA" runat="server" Width="100px" Text='<%# Bind("DataFine", "{0:d}") %>' 
                                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                        </div>

                                    </div>
                                    <!-- *** TAB 1 ***  -->

                                    <!-- *** TAB 2 ***  -->
                                    <!-- *** Economics ***  -->

                                    <div class="tab-pane fade" id="tabs-2" role="tabpanel" aria-labelledby="tab-economics" style="font-size: 14px; font-family: OpenSans-Regular;">

                                    <br />

                                    <!-- *** TABELLA ECONOMICS CALCOLATA ***  -->
                                    <table id="ProjectEconomicsCalculated" class="table table-sm table-hover table-border-only" style="border-collapse:collapse;width:95%; margin: 0 auto 20px auto;">
                                        <thead class="table-dark">
                                            <tr>
                                                <th scope="col">Indicatore</th>
                                                <th scope="col">Budget</th>
                                                <th scope="col">Actual</th>
                                                <th scope="col">EAC</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Revenue</th>
                                                <td><asp:Label ID="lbRevenueBDG" runat="server" /></td>
                                                <td><asp:Label ID="lbRevenueACT" runat="server" /></td>
                                                <td><asp:Label ID="lbRevenueEAC" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Costi</th>
                                                <td><asp:Label ID="lbCostiBDG" runat="server" /></td>
                                                <td><asp:Label ID="lbCostiACT" runat="server" /></td>
                                                <td><asp:Label ID="lbCostiEAC" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Spese</th>
                                                <td><asp:Label ID="lbSpeseBDG" runat="server" /></td>
                                                <td><asp:Label ID="lbSpeseACT" runat="server" /></td>
                                                <td><asp:Label ID="lbSpeseEAC" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Margine</th>
                                                <td><asp:Label ID="lbMargineBDG" runat="server" /></td>
                                                <td><asp:Label ID="lbMargineACT" runat="server" /></td>
                                                <td><asp:Label ID="lbMargineEAC" runat="server" /></td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Writeup</th>
                                                <td></td>
                                                <td><asp:Label ID="lbWriteUpACT" runat="server" /></td>
                                                <td><asp:Label ID="lbWriteUpEAC" runat="server" /></td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <br />

                                    <!-- *** TABELLA ECONOMICS MENSILE ***  -->
                                    <div style="width:95%; margin: 0 auto 10px auto; display: flex; align-items: center;">
                                        <div style="max-width:730px;" id="EconomicsTable"></div>
                                    </div>
                                    <br />
                                    <br />

                                    <!-- *** MESI COPERTURA ***  -->
                                    <div style="width:95%; margin: 0 auto 10px auto; display: flex; align-items: center;">
                                        <span style="margin-right: 10px;">Copertura:</span>
                                        <asp:TextBox ID="TBMesiCopertura" runat="server" Enabled="False" style="width: 80px; margin-right: 5px;" />
                                        <span>mesi</span>
                                    </div>
                                 

                                </div>

                                <!-- *** TAB 2 ***  -->
                                

                                <!-- *** TAB 3 ***  -->

                                <div class="tab-pane fade" id="tabs-3" role="tabpanel" aria-labelledby="tab-risorse" style="font-size: 14px; font-family: OpenSans-Regular;">
                                    <br />
                                    <asp:GridView ID="GVConsulenti" runat="server" OnRowDataBound="GVConsulenti_RowDataBound" AllowPaging="False" class="table table-sm table-hover table-border-only" style="width:95%; margin: 0 auto 20px auto;" HeaderStyle-CssClass="table-dark">
                                    </asp:GridView>
                                </div>

                                <!-- *** TAB 3 ***  -->

                                <div class="tab-pane fade" id="tabs-4" role="tabpanel" aria-labelledby="tab-actuals" style="font-size: 14px; font-family: OpenSans-Regular; max-width: 766px; overflow-x: auto;">

                                    <div style="margin: 0 auto; width: 70%;">
                                        <canvas style="max-width: 480px; max-height: 250px;" id="myChart"></canvas>
                                    </div>

                                <br />

                                    <asp:GridView ID="GVGGActuals" runat="server" OnRowDataBound="GVGGActuals_RowDataBound" AllowPaging="False" class="table table-sm table-hover table-border-only" style="width:95%; margin: 0 auto 20px auto;" HeaderStyle-CssClass="table-dark"  >
                                    </asp:GridView>
                                </div>


                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="btn_save" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="btn1" runat="server" CausesValidation="True" CommandName="download" OnClick="Download_ore_costi" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" />
                                <asp:Button ID="btn2" runat="server" CausesValidation="True" CommandName="download" OnClick="Download_GGActuals" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" />
                                <asp:Button ID="btn_calc" runat="server" CausesValidation="False" CssClass="orangebutton" Text="<%$ appSettings: CALC_COST %>" Style="width: 120px" OnClick="btn_calc_Click" />
                                <asp:Button ID="btn_SaveEconomics" runat="server" CausesValidation="False" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClientClick="SaveEconomicsData(); return false;" />
                                <asp:Button ID="btnAnnulla" runat="server" CausesValidation="False" PostBackUrl="/timereport/report/controllo_progetto/ControlloProgetto-list.aspx" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                            </div>

                        </EditItemTemplate>

                    </asp:FormView>

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
    <asp:SqlDataSource ID="projects" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT ProjectCode + ' ' + Name as ProjectName, * FROM [Projects] WHERE ([ProjectCode] = @ProjectCode)"
        UpdateCommand="UPDATE Projects SET RevenueBudget = @RevenueBudget, SpeseBudget = @SpeseBudget, SpeseForfait = @SpeseForfait, MargineProposta=@MargineProposta/100, DataFine=@DataFine, DataInizio=@DataInizio, NoOvertime = @NoOvertime, LastModificationDate = @LastModificationDate, LastModifiedBy = @LastModifiedBy  WHERE (Projects_Id = @Projects_Id)"
        OnUpdating="DSprojects_Update">
        <SelectParameters>
            <asp:QueryStringParameter Name="ProjectCode" QueryStringField="ProjectCode"
                Type="String" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Projects_Id" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="RevenueBudget" Type="Decimal" />
            <asp:Parameter Name="SpeseBudget" Type="Decimal" />
            <asp:Parameter Name="MargineProposta" Type="Decimal" />
            <asp:Parameter Name="DataFine" Type="DateTime" />
            <asp:Parameter Name="DataInizio" Type="DateTime" />
            <asp:Parameter Name="SpeseForfait" Type="Boolean" />
            <asp:Parameter Name="NoOvertime" />
            <asp:Parameter Name="LastModifiedBy" />
            <asp:Parameter Name="LastModificationDate" />
        </UpdateParameters>

    </asp:SqlDataSource>
    <asp:SqlDataSource ID="cliente" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [Nome1], [CodiceCliente] FROM [Customers] ORDER BY [Nome1]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="manager" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="account" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TipoContratto" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [Descrizione], [TipoContratto_id] FROM [TipoContratto]"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** attiva validazione campi form
        $('#MainForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // *** messaggio di default
        Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
        });

        // validazione campo revenue in caso il progetto sia FORFAIT
        window.Parsley.addValidator("requiredIf", {
            validateString: function (value, requirement) {

                value = value.toString().replace(',', '.');

                // se inserito deve essere un numero
                if (isNaN(value) && !!value) {
                    window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                    return false;
                }

                if (jQuery("#FVProgetto_DDLTipoContratto option:selected").val() == "<%= ConfigurationManager.AppSettings["CONTRATTO_FORFAIT"] %>") {

                    // se FIXED verifica obbligatorietà
                    if (!value && requirement != "percent") {
                        window.Parsley.addMessage('it', 'requiredIf', "Verificare i campi obbligatori");
                        return false;
                    }

                    // se number verifica tipo
                    if (requirement == "number")
                        if (!isNaN(value)) //  compilato e numerico
                            return true;
                        else {
                            window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                            return false;
                        }
                }

                return true;
            },
            priority: 33
        })

        // *** GRAFICO ACTUALS ***
        function DrawChart() {
            var ctx = document.getElementById('myChart');
            if (!ctx) return;

            var labels = <%=Session["columnNamesJson"] ?? "[]" %>;
            var data = <%=Session["columnSumsJson"] ?? "[]" %>;

            if (!labels || !data || labels.length === 0) return;

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'mandays',
                        data: data,
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }

        $(function () {

            // grafico
            DrawChart();

            // Gestione bottoni con Bootstrap Tabs
            function showTabButtons(tabIndex) {
                $("#FVProgetto_btn1").hide();
                $("#FVProgetto_btn2").hide();
                $("#FVProgetto_btn_save").hide();
                $("#FVProgetto_btn_calc").hide();
                $("#FVProgetto_btn_SaveEconomics").hide();
                if (tabIndex === 1) {
                    $("#FVProgetto_btn_save").show();
                } else if (tabIndex === 2) {
                    $("#FVProgetto_btn_SaveEconomics").show();
                    // Recupera Projects_id dall'hidden field nel FormView
                    currentProjectId = parseInt($("#FVProgetto_TBProjects_id").val());
                    if (isNaN(currentProjectId) || currentProjectId === 0) {
                        ShowPopup("Impossibile recuperare l'ID del progetto");
                        return;
                    }
                    loadEconomicsTable();
                } else if (tabIndex === 3) {
                    $("#FVProgetto_btn1").show();
                    $("#FVProgetto_btn_calc").show();
                } else if (tabIndex === 4) {
                    $("#FVProgetto_btn2").show();
                }
            }
            // Bootstrap tab event
            $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
                var target = $(e.target).attr('href');
                if (target === "#tabs-1") showTabButtons(1);
                else if (target === "#tabs-2") showTabButtons(2);
                else if (target === "#tabs-3") showTabButtons(3);
                else if (target === "#tabs-4") showTabButtons(4);
            });
            // Mostra bottoni tab iniziale
            showTabButtons(1);
            UnMaskScreen();
            $(':checkbox').addClass('css-checkbox');
            $('#FVProgetto_TBAttivoA').datepicker($.datepicker.regional['it']);
            var percentDecimal = $('#FVProgetto_TBMargine').val().toString().replace(',', '.');
            if (percentDecimal != "") {
                var percentCent = Math.round(parseFloat(percentDecimal) * 10000) / 100;
                percentCent = percentCent.toString().replace('.', ',');
                $('#FVProgetto_TBMargine').val(percentCent);
            }
            $('#FVProgetto_btn_calc').click(function () { MaskScreen(true); });
            $('#FVProgetto_btnAnnulla').click(function () { MaskScreen(true); });
        });

        // *** TABULATOR ECONOMICS ***
        var mustSaveEconomics = false;
        var economicsTable = null;
        var currentProjectId = 0;
        var canEditMargine = <%= Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL").ToString().ToLower() %>;
        
        // Recupera la data di cutoff dalla sessione
        var cutoffDate = new Date('<%= CurrentSession.dCutoffDate.ToString("yyyy-MM-dd") %>');
        var cutoffAnnoMese = cutoffDate.getFullYear() + "-" + ("0" + (cutoffDate.getMonth() + 1)).slice(-2);

        function loadEconomicsTable() {
            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_ControlloProgetto.asmx/GetEconomicsData",
                data: JSON.stringify({ projects_id: currentProjectId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = JSON.parse(response.d);
                    if (!data || data.length === 0) {
                        ShowPopup("Nessun dato disponibile");
                        return;
                    }
                    initializeEconomicsTable(data);
                },
                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup("Errore nel caricamento dati Economics");
                }
            });
        }

        function initializeEconomicsTable(data) {
            // Distruggi tabella esistente se presente
            if (economicsTable) {
                economicsTable.destroy();
                economicsTable = null;
            }

            var monthNames = ["Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"];
            
            // Calcola il mese successivo al cutoff (unico mese editabile)
            var cutoffDateCalc = new Date(cutoffAnnoMese + '-01');
            cutoffDateCalc.setMonth(cutoffDateCalc.getMonth() + 1);
            var nextMonthAfterCutoff = cutoffDateCalc.getFullYear() + '-' + ('0' + (cutoffDateCalc.getMonth() + 1)).slice(-2);

            // Filtra solo mesi fino al successivo del cutoff (incluso)
            var filteredData = data.filter(function(item) {
                return item.AnnoMese <= nextMonthAfterCutoff;
            });

            // Costruisci colonne dinamiche
            var columns = [
                { title: "Tipo", field: "rowType", frozen: true, width: 100, headerSort: false }
            ];

            filteredData.forEach(function (item) {
                var annoMese = item.AnnoMese;
                var parts = annoMese.split('-');
                var monthIndex = parseInt(parts[1]) - 1;
                var isEditable = annoMese === nextMonthAfterCutoff;

                columns.push({
                    title: monthNames[monthIndex],
                    field: annoMese,
                    editor: "number",
                    editorParams: { min: 0, step: 0.01 },
                    editable: function(cell) {
                        if (!isEditable) return false;
                        var rowType = cell.getRow().getData().rowType;
                        return rowType === "ETC" || (rowType === "Margine" && canEditMargine);
                    },
                    width: 80,
                    minWidth: 80,
                    headerSort: false,
                    cellEdited: function (cell) { mustSaveEconomics = true; },
                    formatter: function(cell) {
                        var value = cell.getValue();
                        var rowType = cell.getRow().getData().rowType;
                        
                        // Stile cella
                        var cellElement = cell.getElement();
                        if (!isEditable || (rowType === "Margine" && !canEditMargine)) {
                            cellElement.style.backgroundColor = "#e0e0e0";
                            cellElement.style.color = "#666666";
                        } else {
                            cellElement.style.backgroundColor = "#ffffff";
                            cellElement.style.color = "#000000";
                        }
                        
                        if (value === null || value === undefined || value === "") return "";
                        
                        var numValue = parseFloat(value);
                        if (isNaN(numValue)) return value;
                        
                        // Formattazione
                        if (rowType === "ETC") {
                            var decimals = (numValue % 1 === 0) ? 0 : 2;
                            return numValue.toLocaleString('it-IT', { 
                                minimumFractionDigits: decimals, 
                                maximumFractionDigits: decimals 
                            });
                        }
                        
                        if (rowType === "Margine") {
                            return numValue.toLocaleString('it-IT', { 
                                minimumFractionDigits: 2, 
                                maximumFractionDigits: 2 
                            }) + " %";
                        }
                        
                        return value;
                    }
                });
            });

            // Costruisci righe dati
            var etcRow = { rowType: "ETC" };
            var margineRow = { rowType: "Margine" };

            filteredData.forEach(function (item) {
                etcRow[item.AnnoMese] = item.ETC;
                margineRow[item.AnnoMese] = item.Margine;
            });

            economicsTable = new Tabulator("#EconomicsTable", {
                data: [etcRow, margineRow],
                layout: "fitDataTable",
                columns: columns,
                responsiveLayout: false,
                headerSort: false,
                movableColumns: false
            });
        }

        function SaveEconomicsData() {

            if (!mustSaveEconomics) {
                ShowPopup("Nessuna modifica da salvare");
                return;
            }

            if (!economicsTable) {
                ShowPopup("Tabella non inizializzata");
                return;
            }

            var dataToPost = [];
            var tableData = economicsTable.getData();

            tableData.forEach(function (row) {
                var rowType = row.rowType;

                for (var key in row) {
                    if (key !== "rowType" && row.hasOwnProperty(key)) {
                        var record = {
                            Projects_id: currentProjectId,
                            AnnoMese: key,
                            ETC: rowType === "ETC" ? row[key] : null,
                            Margine: rowType === "Margine" ? row[key] : null
                        };
                        dataToPost.push(JSON.stringify(record));
                    }
                }
            });

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_ControlloProgetto.asmx/SaveEconomicsData",
                data: JSON.stringify({ economicsTable: dataToPost }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d.Success) {
                        ShowPopup(response.d.Message);
                        mustSaveEconomics = false;
                        loadEconomicsTable();
                    } else {
                        ShowPopup("Errore: " + response.d.Message);
                    }
                },
                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup("Errore server in salvataggio tabella");
                }
            });
        }

    </script>

</body>

</html>
