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
        <asp:Literal runat="server" Text="Anagrafica progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- forzatura stile per form economics -->
    <style>
    .nobottomborder {
        margin: 0px 30px 5px 10px;
    }
    </style>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="MainForm" runat="server" >

            <div class="row justify-content-center">

                <div id="FormWrap" runat="server" class="StandardForm col-5">

                    <asp:FormView ID="FVProgetto" runat="server" DataKeyNames="Projects_Id"
                        DataSourceID="projects" OnItemUpdated="FVProgetto_ItemUpdated"
                        OnModeChanging="FVProgetto_ModeChanging"
                        DefaultMode="Edit" Width="100%">

                        <EditItemTemplate>                         

                            <div id="tabs" style="height:500px">

                                <ul>
                                    <li><a href="#tabs-1">Progetto</a></li>
                                    <li><a href="#tabs-2">Economics</a></li>
                                    <li><a href="#tabs-3">Risorse</a></li>
                                    <li><a href="#tabs-4">Actuals</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 460px; width: 100%">

                                    <asp:HiddenField runat="server" ID="TBProjects_id" value='<%# Bind("Projects_id") %>' />

                                    <!-- *** CODICE PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Codice: </div>
                                        <asp:TextBox ID="TBProgetto" runat="server" class="ASPInputcontent" Enabled="False"
                                            Text='<%# Bind("ProjectCode") %>' Columns="12"
                                            MaxLength="10" />
                                        <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' Enabled="False" />
                                        <asp:Label AssociatedControlID="ActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="progetto attivo"></asp:Label>
                                    </div>

                                    <!-- *** NOME PROGETTO ***  -->
                                    <div class="input">
                                        <div class="inputtext">Progetto: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>'
                                            Columns="26" MaxLength="50" class="ASPInputcontent"
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
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione"
                                            DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>
           
                                    <!-- *** OVERTIME ***  -->
                                    <div class="input ">
                                        <div class="inputtext">No Overtime:</div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' Enabled="False" />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="Label9" runat="server" ></asp:Label>

                                    </div>

                                   <div class="SeparatoreForm">Durata Progetto</div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label8" CssClass="inputtext" runat="server" Text="Da"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" Enabled="False" />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoA" runat="server" Width="100px" Text='<%# Bind("DataFine", "{0:d}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <br /><br />

                                    <!-- *** data creazione/modifica ***  -->
                                    <div class="input nobottomborder" style="font-size: 10px; line-height: 14px; top: 30px; position: relative">
                                        <span style="width: 50px; display: inline-block">[C]</span>
                                        <asp:Label ID="Label13" runat="server" Text='<%# Bind("CreatedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("CreationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                        <br />
                                        <span style="width: 50px; display: inline-block">[M]</span>
                                        <asp:Label ID="Label10" runat="server" Text='<%# Bind("LastModifiedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="Label12" runat="server" Text='<%# Bind("LastModificationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                    </div>
                                </div>

                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 460px; width: 100%">

                                    <div class="SeparatoreForm">Budget</div>

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget", "{0:#,####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>€</label>
                                    </div>

                                    <!-- *** IMPORTO BUDGET ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Budget ABAP: </div>
                                        <asp:TextBox ID="TBBudgetABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP", "{0:#####}")%>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>--%>

                                    <!-- *** GG BUDGET ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Bdg GG ABAP: </div>
                                        <asp:TextBox ID="TBBudgetGGABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP")%>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                    </div>--%>

                                    <!-- *** IMPORTO SPESE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:#,####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="incluse"></asp:Label>
                                    </div>

                                    <!-- *** MARGINE TARGET ***  -->
                                    <div class="input">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>'  
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>%</label>
                                    </div>

                                    <div class="SeparatoreForm">Actuals</div>

                                    <!-- *** REVENUE ACTUAL ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueActual" class="ASPInputcontent" runat="server" Enabled="False" /> <label>€</label>
                                    </div>

                                    <!-- *** SPESE ACTUAL ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="TBSpeseActual" class="ASPInputcontent" runat="server" Enabled="False" /> <label>€</label>
                                    </div>
                                    
                                    <!-- *** GIORNI ACTUAL ***  -->
                                    <div class="input">
                                        <div class="inputtext">Giorni: </div>
                                        <asp:TextBox ID="TBGiorniActual" class="ASPInputcontent" runat="server" Enabled="False" />  
                                    </div>

                                    <div class="SeparatoreForm">Budget vs Actuals</div>

                                    <!-- *** WRITEUP ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">WriteUp: </div>
                                        <asp:TextBox ID="TBWriteUp" class="ASPInputcontent" runat="server" Enabled="False" /> <label>€</label>
                                    </div

                                    <!-- *** MESI COPERTURA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Copertura: </div>
                                        <asp:TextBox ID="TBMesiCopertura" class="ASPInputcontent" runat="server" Enabled="False" /> <label>mesi</label>  
                                    </div>
                                   
                                </div>
                                <!-- *** TAB 2 ***  -->

                                <div id="tabs-3"  style="font-size: 14px;font-family: OpenSans-Regular;max-height:400px;overflow-y:scroll" >
                                    <asp:GridView ID="GVConsulenti" runat="server" onrowdatabound="GVConsulenti_RowDataBound"  AllowPaging="False" BorderStyle="None">
                                    </asp:GridView>
                                </div>
                                <!-- *** TAB 3 ***  -->

                                <div id="tabs-4"  style="font-size: 14px;font-family: OpenSans-Regular;max-width:540px;max-height:470px;overflow-y:scroll;overflow-x:auto !important" >
                                    <asp:GridView ID="GVGGActuals" runat="server"  onrowdatabound="GVGGActuals_RowDataBound" AllowPaging="False" BorderStyle="None" RowStyle-Wrap="False" HeaderStyle-Wrap="False" GridLines="Both">
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
                                <asp:Button ID="btn2" runat="server" CausesValidation="True" CommandName="download" OnClick="Download_GGActuals" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>"/>
                                <asp:Button ID="btn_calc" runat="server" CausesValidation="False" CssClass="orangebutton" Text="<%$ appSettings: CALC_COST %>" style="width:120px" OnClick="btn_calc_Click" />
                                <asp:Button ID="btnAnnulla" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
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
        SelectCommand="SELECT * FROM [Projects] WHERE ([ProjectCode] = @ProjectCode)"
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

                if (jQuery("#FVProgetto_DDLTipoContratto option:selected").val() == "<%= ConfigurationManager.AppSettings["CONTRATTO_FORFAIT"] %>" ) {

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

            // abilitate tab view
            $("#tabs").tabs();
            $("#FVProgetto_btn1").hide();
            $("#FVProgetto_btn2").hide();
            $("#FVProgetto_btn_calc").hide(); 

            UnMaskScreen();

            // stile checkbox form    
            $(":checkbox").addClass("css-checkbox");

            // stile checkbox form in ReadOnly   
            //$("#FVProgetto_DisActivityOn").addClass("css-checkbox")
            //$("#FVProgetto_DisAlwaysAvailableCheckBox").addClass("css-checkbox");
            //$("#FVProgetto_DisSpeseForfaitCheckBox").addClass("css-checkbox");
            //$("#FVProgetto_DisActiveCheckBox").addClass("css-checkbox");
            //$("#FVProgetto_DisBloccoCaricoSpeseCheckBox").addClass("css-checkbox");

            //$("#FVProgetto_DisActivityOn").attr("disabled", true);
            //$("#FVProgetto_DisAlwaysAvailableCheckBox").attr("disabled", true);
            //$("#FVProgetto_DisSpeseForfaitCheckBox").attr("disabled", true);
            //$("#FVProgetto_DisActiveCheckBox").attr("disabled", true);
            //$("#FVProgetto_DisBloccoCaricoSpeseCheckBox").attr("disabled", true);

            // datepicker
            //$("#FVProgetto_TBAttivoDa").datepicker($.datepicker.regional['it']);
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
                $("#FVProgetto_btn_save").show(); 
                $("#FVProgetto_btn_calc").hide(); 
            });

        });
    </script>

</body>

</html>
