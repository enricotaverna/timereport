<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlloProgetto-form.aspx.cs" Inherits="m_gestione_Project_Projects_lookup_form" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<style>
/* Remove default table border */
    .table-borderless, .table-borderless th, .table-borderless td {
      border: none;
    }
    
/* Add border only to table and its cells */
    .table-border-only  {
      border: 1px solid grey; /* Adjust border style and color as needed */
    }

/* forzatura stile per form economics  */
    .nobottomborder {
            margin: 0px 30px 5px 10px;
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


    <style>

    </style>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="MainForm" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" runat="server" class="StandardForm col-7">

                    <asp:FormView ID="FVProgetto" runat="server" DataKeyNames="Projects_Id"
                        DataSourceID="projects" OnItemUpdated="FVProgetto_ItemUpdated"
                        DefaultMode="Edit" Width="100%">

                        <EditItemTemplate>

                            <div id="tabs" style="height: 500px">

                                <ul>
                                    <li><a href="#tabs-1">Progetto</a></li>
                                    <li><a href="#tabs-2">Economics</a></li>
                                    <li><a href="#tabs-3">Risorse</a></li>
                                    <li><a href="#tabs-4">Actuals</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 460px; width: 100%">

                                    <asp:HiddenField runat="server" ID="TBProjects_id" Value='<%# Bind("Projects_id") %>' />

                                    <br />   
  <%--                                  <!-- *** CODICE PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Codice: </div>
                                        <asp:TextBox ID="TBProgetto" runat="server" class="ASPInputcontent" Enabled="False"
                                            Text='<%# Bind("ProjectCode") %>' Columns="12"
                                            MaxLength="10" />
                                    </div>--%>

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
                                <!-- *** TAB 1 ***  --

                                <!-- *** TAB 2 ***  -->

                                <div id="tabs-2" style="height: 480px; width: 100%">

                                    <br />
                                    <div class="row justify-content-center">
                                    <table class="table table-sm table-hover table-border-only" style="width:740px">
                                        <thead class="table-dark">
                                            <tr>
                                                <th scope="col"></th>
                                                <th scope="col">Budget</th>
                                                <th scope="col">Actual</th>
                                                <th scope="col">EAC</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Revenue</th>
                                                <td>
                                                    <asp:Label ID="lbRevenueBDG" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbRevenueACT" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbRevenueEAC" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Costi</th>
                                                <td>
                                                    <asp:Label ID="lbCostiBDG" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbCostiACT" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbCostiEAC" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>

                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Spese</th>
                                                <td>
                                                    <asp:Label ID="lbSpeseBDG" runat="server"   />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbSpeseACT" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbSpeseEAC" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Margine</th>
                                                <td>
                                                    <asp:Label ID="lbMargineBDG" runat="server"  />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbMargineACT" runat="server" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lbMargineEAC" runat="server" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <th scope="row" style="color:grey;font-weight:normal">Writeup</th>
                                                <td></td>
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lbWriteoffEAC" runat="server" />
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    </div> <!-- centre mx-auto  -->

                                    <br />
                                    <br />
                                    <!-- *** MESI COPERTURA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Copertura: </div>
                                        <asp:TextBox ID="TBMesiCopertura" class="ASPInputcontent" runat="server" Enabled="False" />
                                        <label>mesi</label>
                                    </div>

                                </div>

                                <!-- *** TAB 2 ***  -->
                                
                                <div id="tabs-3" style="font-size: 14px; font-family: OpenSans-Regular; max-height: 400px; overflow-y: scroll">
                                    <br />
                                    <asp:GridView ID="GVConsulenti" runat="server" OnRowDataBound="GVConsulenti_RowDataBound" AllowPaging="False" BorderStyle="None" CssClass="table table-sm table-hover table-border-only" HeaderStyle-CssClass="table-dark">
                                    </asp:GridView>
                                </div>

                                <!-- *** TAB 3 ***  -->

                                <div id="tabs-4" style="font-size: 14px; font-family: OpenSans-Regular; max-width: 766px; max-height: 456px; overflow-y: scroll; overflow-x: auto !important">

                                    <div style="margin: 0 auto; width: 70%;">
                                        <canvas style="max-width: 480px; max-height: 250px;" id="myChart"></canvas>
                                    </div>

                                    <br />

                                    <asp:GridView ID="GVGGActuals" runat="server" OnRowDataBound="GVGGActuals_RowDataBound" AllowPaging="False" CssClass="table table-sm table-hover table-border-only" HeaderStyle-CssClass="table-dark" >
                                    </asp:GridView>
                                </div>
                                <!-- *** TAB 4 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                                <asp:Button ID="btn_save" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="btn1" runat="server" CausesValidation="True" CommandName="download" OnClick="Download_ore_costi" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" />
                                <asp:Button ID="btn2" runat="server" CausesValidation="True" CommandName="download" OnClick="Download_GGActuals" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" />
                                <asp:Button ID="btn_calc" runat="server" CausesValidation="False" CssClass="orangebutton" Text="<%$ appSettings: CALC_COST %>" Style="width: 120px" OnClick="btn_calc_Click" />
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

        $(function () {

            // grafico
            DrawChart();

            // abilitate tab view
            $("#tabs").tabs();
            $("#FVProgetto_btn1").hide();
            $("#FVProgetto_btn2").hide();
            $("#FVProgetto_btn_calc").hide();

            UnMaskScreen();

            // stile checkbox form    
            $(":checkbox").addClass("css-checkbox");

            // datepicker
            $("#FVProgetto_TBAttivoA").datepicker($.datepicker.regional['it']);

            // formatta il campo percentuale
            var percentDecimal = $("#FVProgetto_TBMargine").val().toString().replace(",", ".");

            if (percentDecimal != "") {
                var percentCent = Math.round(parseFloat(percentDecimal) * 10000) / 100;
                percentCent = percentCent.toString().replace(".", ",");
                $("#FVProgetto_TBMargine").val(percentCent);
            }

            $('#FVProgetto_btn_calc').click(function () {
                MaskScreen(true);
            });

            $('#FVProgetto_btnAnnulla').click(function () {
                MaskScreen(true);
            });

            // mostra bottoni download sul tab corrispondente
            $("#ui-id-3").click(function () {
                $("#FVProgetto_btn1").show();
                $("#FVProgetto_btn2").hide();
                $("#FVProgetto_btn_save").hide();
                $("#FVProgetto_btn_calc").show();
            });

            $("#ui-id-4").click(function () {
                $("#FVProgetto_btn2").show();
                $("#FVProgetto_btn1").hide();
                $("#FVProgetto_btn_save").hide();
                $("#FVProgetto_btn_calc").hide();
            });

            $("#ui-id-1").click(function () {
                $("#FVProgetto_btn2").hide();
                $("#FVProgetto_btn1").hide();
                $("#FVProgetto_btn_save").show();
                $("#FVProgetto_btn_calc").hide();
            });

            $("#ui-id-2").click(function () {
                $("#FVProgetto_btn2").hide();
                $("#FVProgetto_btn1").hide();
                $("#FVProgetto_btn_save").hide();
                $("#FVProgetto_btn_calc").hide();
            });

        });

        function DrawChart() {

            const ctx = document.getElementById('myChart');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: <%=Session["columnNamesJson"]  %>,
                    datasets: [{
                        label: 'mandays',
                        data:  <%=Session["columnSumsJson"]  %>,
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

    </script>

</body>

</html>
