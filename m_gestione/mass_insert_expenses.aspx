<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mass_insert_expenses.aspx.cs" Inherits="mass_insert_expenses" EnableEventValidation="False" %>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<style>
    .inputtext, .ASPInputcontent {
        Width: 170px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Gestione Spese" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%=CurrentSession.UserLevel %>-<%=CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formSpese" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-11 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Persona</label>
                        </div>
                        <div class="col-3">
                        <div style="position:absolute">
                        <asp:DropDownList ID="DDL_Persona_Sel" runat="server" AppendDataBoundItems="True" 
                            AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="DDSPersone" DataTextField="Name"
                            DataValueField="Persons_id" OnSelectedIndexChanged="DDL_Persona_Sel_SelectedIndexChanged"
                            OnDataBound="DDL_Persona_Sel_DataBound">
                            <asp:ListItem Text="Tutti i valori" Value="all" />
                        </asp:DropDownList>
                        </div>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-3">
                            <div style="position:absolute">
                            <asp:DropDownList ID="DDL_Progetti_Sel" runat="server" AppendDataBoundItems="True"
                                AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="dsProjects" DataTextField="codice" Width="220px"
                                DataValueField="Projects_Id" OnSelectedIndexChanged="DDL_Progetti_Sel_SelectedIndexChanged"
                                OnDataBound="DDL_Progetti_Sel_DataBound">
                                <asp:ListItem Text="Tutti i valori" Value="all" />
                            </asp:DropDownList>
                        </div></div>
                        <div class="col-1">
                            <label class="inputtext">Spese</label>
                        </div>
                        <div class="col-3">
                            <div style="position:absolute">
                            <asp:DropDownList ID="DDL_Spesa_Sel" runat="server" AppendDataBoundItems="True"
                                AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="dsTipoSpese" DataTextField="codiceSpesa" Width="220px"
                                DataValueField="ExpenseType_Id" OnSelectedIndexChanged="DDL_Spesa_Sel_SelectedIndexChanged"
                                OnDataBound="DDL_Spesa_Sel_DataBound">
                                <asp:ListItem Text="Tutti i valori" Value="all" />
                            </asp:DropDownList>
                        </div></div>

                    </div>
                    <!-- End row -->

                    <div class="row mt-2">
                        <!-- margine per separare le righe -->

                        <div class="col-1">
                            <label class="inputtext">Data da</label>
                        </div>
                        <div class="col-3">
                            <asp:TextBox ID="TB_Datada" runat="server" class="ASPInputcontent datepickclass" Columns="10" MaxLength="10" OnTextChanged="TB_Datada_TextChanged"
                                OnLoad="TB_Datada_Load" />
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Data a</label>
                        </div>
                        <div class="col-3">
                            <asp:TextBox ID="TB_DataA" runat="server" class="ASPInputcontent datepickclass" Columns="10" MaxLength="10" OnLoad="TB_DataA_Load"
                                OnTextChanged="TB_DataA_TextChanged"></asp:TextBox>
                            <asp:Button ID="BT_filtra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" class="SmallOrangeButton" />
                        </div>

                    </div>
                    <!-- Fine Row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->
           
            <div class="row justify-content-center pt-3">
                <div class="col-11 px-0">

                    <asp:GridView ID="GV_Spese" runat="server" AllowPaging="True" CssClass="GridView"
                        AllowSorting="True" AutoGenerateColumns="False" PageSize="16" ShowFooter="True"
                        DataSourceID="DSExpenses" GridLines="None"
                        DataKeyNames="Expenses_Id">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <Columns>
                            <%--**** TB_Data ****--%>
                            <asp:TemplateField HeaderText="Date" SortExpression="Date">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Data" data-parsley-required="true" runat="server" Text='<%# Bind("Date", "{0:d}") %>' Columns="10"
                                        CssClass="datepickclass dataField" MaxLength="10"></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Data" data-parsley-required="true" runat="server" Columns="8" CssClass="datepickclass footerForm" MaxLength="10"    
                                        Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** DDLProjects_Id ****--%>
                            <asp:TemplateField HeaderText="Progetto" SortExpression="NomeProgetto">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server" CssClass="TabellaLista projectField" DataSourceID="dsProjects"
                                        DataTextField="codice" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>'
                                        Width="110px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" BorderWidth="0px" CssClass=" GV_row_alt"
                                        ReadOnly="True" Text='<%# Bind("NomeProgetto") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server" AppendDataBoundItems="True"
                                        CssClass="TabellaLista footerForm" DataSourceID="dsProjects" DataTextField="codice" DataValueField="Projects_Id"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="120px" data-parsley-required="true">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox6" Text='<%# Bind("NomeProgetto") %>' runat="server" CssClass=" GV_row"
                                        ReadOnly="True" BorderWidth="0px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** DDL_Persona_Id ****--%>
                            <asp:TemplateField HeaderText="Persona" SortExpression="NomePersona">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDL_Persona_Id" runat="server" CssClass="TabellaLista personField" DataSourceID="DDSPersone"
                                        DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>'
                                        Width="90px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox7" runat="server" BorderWidth="0px" CssClass="GV_row_alt"
                                        ReadOnly="True" Text='<%# Bind("NomePersona") %>' Wrap="False"></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDL_Persona_Id" runat="server" AppendDataBoundItems="True" CssClass="TabellaLista footerForm"
                                        DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id" data-parsley-required="true" SelectedValue='<%# Bind("Persons_id") %>'
                                        Width="110px">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox7" Text='<%# Bind("NomePersona") %>' runat="server" CssClass="GV_row"
                                        BorderWidth="0px" ReadOnly="True" Wrap="False"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** TB_Amount ****--%>
                            <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Amount" runat="server" Text='<%# Bind("Amount", "{0:#.##;#.##}")%>' data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true"
                                        CssClass="TabellaLista amountField" Columns="6" MaxLength="10"></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Amount" runat="server" Columns="6" CssClass="TabellaLista footerForm" MaxLength="8" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true"
                                        Text='<%# Bind("Amount", "{0:N}") %>' CausesValidation="True"></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="LBAmount" runat="server" Text='<%# Eval("Amount", "{0:#.00}")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** DDLExpenseType_Id ****--%>
                            <asp:TemplateField HeaderText="TipoSpesa" SortExpression="TipoSpesa">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLTipoSpesa_Id" runat="server" CssClass="TabellaLista tipoSpesaField" DataSourceID="DStipoSpesa"
                                        DataTextField="codice" DataValueField="ExpenseType_Id" SelectedValue='<%# Bind("ExpenseType_Id") %>'
                                        Width="110px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox8" runat="server" BorderWidth="0px" CssClass="GV_row_alt"
                                        ReadOnly="True" Text='<%# Bind("TipoSpesa") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLTipoSpesa_Id" runat="server" CssClass="TabellaLista footerForm" DataSourceID="DStipoSpesa" data-parsley-required="true"
                                        DataTextField="codice" DataValueField="ExpenseType_Id" SelectedValue='<%# Bind("ExpenseType_Id") %>'
                                        Width="110px" AppendDataBoundItems="True">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList> 
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox8" Text='<%# Bind("TipoSpesa") %>' runat="server" BorderWidth="0px"
                                        CssClass="GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** TB_AccountingDate ****--%>
                            <asp:TemplateField HeaderText="Competenza" SortExpression="AccountingDate">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server" Text='<%# Bind("AccountingDate", "{0:d}") %>'
                                        Columns="10" CssClass="datepickclass accountingDateField" MaxLength="10"></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server" Columns="8" CssClass="datepickclass"
                                        MaxLength="10" Text='<%# Bind("AccountingDate", "{0:d}") %>'></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label123" runat="server" Text='<%# Bind("AccountingDate", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** CB_storno ****--%>
                            <asp:TemplateField HeaderText="St" SortExpression="CancelFlag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' CssClass="cancelFlagField" /> 
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** CB_CC ****--%>
                            <asp:TemplateField HeaderText="CC" SortExpression="creditcardpayed">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>' CssClass="CB_CCFlagField" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>'
                                        Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** CB_CompanyPayed ****--%>
                            <asp:TemplateField HeaderText="PA" SortExpression="CompanyPayed">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>'  CssClass="CB_CompanyPayedFlagField"/>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>'
                                        Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--**** CB_fattura ****--%>
                            <asp:TemplateField HeaderText="FT" SortExpression="invoiceflag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>' CssClass="CB_fatturaFlagField" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>'
                                        Enabled="False" />
                                </ItemTemplate>
                            </asp:TemplateField>
                             <%--**** Comment ****--%>
                            <asp:TemplateField HeaderText="Comment" SortExpression="Comment">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Columns="10" CssClass="TabellaLista commentField" Rows="3"
                                        Text='<%# Bind("Comment") %>' TextMode="MultiLine"></asp:TextBox>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" BorderWidth="0px" Columns="15" CssClass="GV_row_alt"
                                        Height="18px" ReadOnly="True" Rows="3" Text='<%# Bind("Comment") %>' TextMode="SingleLine"></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TX_comment" runat="server" Columns="10" CssClass="TabellaLista"
                                        Text='<%# Bind("Comment") %>' TextMode="SingleLine"></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Columns="15" CssClass="GV_row" Rows="3"
                                        Text='<%# Bind("Comment") %>' TextMode="SingleLine" BorderWidth="0px" ReadOnly="True"
                                        Height="18px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                             <%--**** Bottoni ****--%>
                            <asp:TemplateField>
                                <EditItemTemplate>
                                    <asp:Label ID="Expenses_Id" CssClass="Expenses_idField fieldsToHide" runat="server" Text='<%# Eval("Expenses_Id") %>' />
                                    <asp:ImageButton ID="BTSave" runat="server" CausesValidation="True" CssClass="EditButtonSave"
                                        ImageUrl="/timereport/images/icons/16x16/S_F_OKAY.gif" Text="<%$ appSettings: SAVE_TXT %>" /> 
                                   &nbsp;<asp:ImageButton ID="BTCancel" runat="server" CausesValidation="False"  CssClass="CancelButton"
                                       ImageUrl="/timereport/images/icons/16x16/S_F_CANC.GIF"  Text="<%$ appSettings: CANCEL_TXT %>" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="BTInsert" runat="server" CommandName="Insert" Text="<%$ appSettings: CREATE_TXT %>" class="SmallOrangeButton" />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Expenses_Id" CssClass="Expenses_idField fieldsToHide" runat="server" Text='<%# Eval("Expenses_Id") %>' />
                                    <asp:ImageButton ID="BTUpdate" runat="server" CssClass="EditButtonOpen"  CommandName="Edit"
                                        ImageUrl="/timereport/images/icons/16x16/modifica.gif" Text="<%$ appSettings: EDIT_TXT %>" />&nbsp;
                                    <asp:ImageButton ID="BTDelete" runat="server" CausesValidation="False" CssClass=" DeleteButton"
                                        ImageUrl="/timereport/images/icons/16x16/trash.gif" 
                                        Text="<%$ appSettings: DELETE_TXT %>" />
                                </ItemTemplate>
                                <ItemStyle Wrap="False" />
                            </asp:TemplateField>

                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                </div>
                <!-- *** End col *** -->
            </div>
            <!-- *** End row *** -->
        </form>
    </div>
    <!--*** End Container *** -->

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
    <asp:SqlDataSource ID="DSExpenses" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="** backend **">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDL_Persona_Sel" Name="DDL_Persona_Sel" PropertyName="SelectedValue"
                DefaultValue="%" />
            <asp:ControlParameter ControlID="DDL_Progetti_Sel" Name="DDL_Progetti_Sel" PropertyName="SelectedValue"
                DefaultValue="%" />
            <asp:ControlParameter ControlID="DDL_Spesa_Sel" Name="DDL_Spesa_Sel" PropertyName="SelectedValue"
                DefaultValue="%" />
            <asp:ControlParameter ControlID="TB_DataDa" Name="TB_DataDa" PropertyName="text"
                Type="datetime" DefaultValue="1/1/2008" />
            <asp:ControlParameter ControlID="TB_DataA" Name="TB_DataA" PropertyName="text" Type="datetime"
                DefaultValue="31/12/9999" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsProjects" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + ' ' + Name AS codice, Active FROM Projects WHERE (Active = 1) ORDER BY codice"></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsTipoSpese" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT ExpenseType_Id, ExpenseCode + ' ' + Name AS codiceSpesa, Active FROM ExpenseType WHERE (Active = 1) ORDER BY codiceSpesa"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DDSPersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DStipoSpesa" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT ExpenseType_Id, ExpenseCode + N' ' + Name AS codice FROM ExpenseType WHERE (Active = 1) ORDER BY codice"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(document).ready(function () {

            $(".fieldsToHide").hide(); // nasconde i campi utilizzato solo per update
            $(".datepickclass").datepicker($.datepicker.regional['it']);

            // Inizializza SumoSelect
            $('#DDL_Persona_Sel').SumoSelect({ search: true, searchText: '' });
            $('#DDL_Progetti_Sel').SumoSelect({ search: true, searchText: '' });
            $('#DDL_Spesa_Sel').SumoSelect({ search: true, searchText: '' });
            
            $('.SumoSelect').css('width', '220px');

        });

        // Initialize Parsley
        var form = $('#formSpese').parsley({
            excluded: "input[type=button], input[type=submit], input[type=image], input[type=hidden], [disabled], :hidden"
        });

        // Disabilita temporaneamente la validazione di Parsley quando si preme il tasto edit o filtra
        $(".EditButtonOpen, .CancelButton, #BT_filtra").on("click", function (e) {
            $('#formSpese').parsley().destroy();
        });

        // Cancella record
        $(".DeleteButton").on("click", function (e) {
            e.preventDefault();
            var row = $(this).closest("tr");
            ConfirmDialog("Conferma cancellazione", "Vuoi cancellare il record?", "Cancella", (confirm) => { confirm && DeleteRecord(row) });
        });

        // chiude riga di edit
        $(".CancelButton").on("click", function (e) {
            e.preventDefault();
            window.location.href = "/timereport/m_gestione/mass_insert_expenses.aspx";
        });

        // Aggiorna Spese
        $(".EditButtonSave").on("click", function (e) {

            $('.footerForm').attr('data-parsley-required', 'false');

            // Check if the form is valid
            form.validate();
            if (!form.isValid())
                return;

            // Trova la riga contenente il pulsante cliccato
            var row = $(this).closest("tr");

            // Accedi ai campi all'interno di quella riga
            var expensesId = row.find(".Expenses_idField").text();
            var TaskName = row.find(".SalesforceTaskIdField").text();
            var dataField = row.find(".dataField").val();
            var projectField = row.find(".projectField").val();
            var personField = row.find(".personField").val();
            var tipoSpesaField = row.find(".tipoSpesaField").val();
            var amountField = row.find(".amountField").val().replace(',', '.');
            var accountingDateField = row.find(".accountingDateField").val();

            var cancelFlagField = row.find(".cancelFlagField > input").is(":checked");
            var CB_CCFlagField = row.find(".CB_CCFlagField > input").is(":checked");
            var CB_CompanyPayedFlagField = row.find(".CB_CompanyPayedFlagField > input").is(":checked");
            var CB_fatturaFlagField = row.find(".CB_fatturaFlagField > input").is(":checked");

            var commentField = row.find(".commentField").val();

            var OpportunityId = "";

            var values = "{ 'Expenses_Id': " + expensesId +
                " , 'Date': '" + dataField + "'" +
                " , 'ExpenseAmount':  '" + amountField + "'" +
                " , 'Person_Id': " + personField +
                " , 'Project_Id': " + projectField +
                " , 'ExpenseType_Id': " + tipoSpesaField +
                " , 'Comment': '" + commentField + "'" +
                " , 'CreditCardPayed': " + CB_CCFlagField + 
                " , 'CompanyPayed': " + CB_CompanyPayedFlagField +
                " , 'CancelFlag': " + cancelFlagField +
                " , 'InvoiceFlag': " + CB_fatturaFlagField +
                " , 'strFileName': ''" +
                " , 'strFileData': ''" +
                " , 'OpportunityId': '" + OpportunityId + "'" +
                " , 'AccountingDate': '" + accountingDateField + "'" +
                " , 'UserId': ''" +
                "  }";

            // Aggiorna ore
            PostAjax(values);

        });

        // Crea Ore
        $("#GV_Spese_BTInsert").on("click", function (e) {

            e.preventDefault();

            // Trigger validation without submitting the form
            form.validate();

            // Check if the form is valid
            if (!form.isValid())
                return;

            // formattazione valori
            var TaskName = isNullOrEmpty($('#FVore_DDLTaskName').val()) ? "" : $('#FVore_DDLTaskName').val();
            var OpportunityId = "";
            var expensesId = 0;

            // tipo ora sempre defaultato a 1
            var values = "{ 'Expenses_Id': " + expensesId +
                " , 'Date': '" + $('#GV_Spese_TB_Data').val() + "'" +
                " , 'ExpenseAmount': '" + $('#GV_Spese_TB_Amount').val().replace(',', '.') + "'" +
                " , 'Person_Id': " + $('#GV_Spese_DDL_Persona_Id').val() +
                " , 'Project_Id': " + $('#GV_Spese_DDLProjects_Id').val() +
                " , 'ExpenseType_Id': " + $('#GV_Spese_DDLTipoSpesa_Id').val() +
                " , 'Comment': '" + $('#GV_Spese_TX_comment').val() + "'" +
                " , 'CreditCardPayed': " + $('#GV_Spese_CB_CC').is(':checked') +
                " , 'CompanyPayed': " + $('#GV_Spese_CB_CompanyPayed').is(':checked') +
                " , 'CancelFlag': " + $('#GV_Spese_CB_storno').is(':checked') +
                " , 'InvoiceFlag': " + $('#GV_Spese_CB_fattura').is(':checked') +
                " , 'strFileName': ''" +
                " , 'strFileData': ''" + 
                " , 'OpportunityId': '" + OpportunityId + "'" +
                " , 'AccountingDate': '" + $('#GV_Spese_TB_AccountingDate').val() + "'" +
                " , 'UserId': ''" +
                " }";

            // Inserisci ore
            PostAjax(values);

        });

        // Cancella record
        function DeleteRecord(row) {

            var expensesId = row.find(".Expenses_idField").text();
            var values = "{'Id': '" + expensesId + "', DeletionType : 'expenses' }";

            MaskScreen();

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/DeleteRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (response) {
                    UnMaskScreen(); 
                    var result = response.d
                    if (result.Success == true)
                        window.location.reload();
                    else
                        ShowPopup('Errore');
                },

                // in caso di errore
                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen(); 
                    ShowPopup(xhr.responseText);
                }

            }); // ajax
        }

        // Chiamata AJAX
        function PostAjax(values) {

            MaskScreen();

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/SaveExpenses",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    UnMaskScreen();
                    if (msg.d)
                        window.location.href = "/timereport/m_gestione/mass_insert_expenses.aspx";
                    //ShowPopup("Aggiornamento effettuato");
                    else
                        ShowPopup('Errore durante aggiornamento');
                },
                error: function (xhr, textStatus, error) {
                    if (xhr.responseText.trim() == 0)
                        window.location.href = "/timereport/m_gestione/mass_insert_hours.aspx";
                    else {
                        UnMaskScreen();
                        ShowPopup(xhr.responseText);
                    }
                }
            }); // ajax
        }

    </script>

</body>

</html>
