<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mass_insert_hours.aspx.cs" Inherits="mass_insert_hours" EnableEventValidation="False" %>

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
        <asp:Literal runat="server" Text="Gestione Ore" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%=CurrentSession.UserLevel %>-<%=CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formOre" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-11 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Persona</label>
                        </div>
                        <div class="col-5">
                            <div style="position:absolute">
                            <asp:DropDownList ID="DDL_Persona_Sel" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True" CssClass="ASPInputcontent"
                                DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id" OnSelectedIndexChanged="DDL_Persona_Sel_SelectedIndexChanged" OnDataBound="DDL_Persona_Sel_DataBound">
                                <asp:ListItem Text="Tutti i valori" Value="all" />
                            </asp:DropDownList>
                        </div></div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-5">
                            <div style="position:absolute">
                            <asp:DropDownList ID="DDL_Progetti_Sel" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True" CssClass="ASPInputcontent"
                                DataSourceID="dsProjects" DataTextField="codice" DataValueField="Projects_Id" OnSelectedIndexChanged="DDL_Progetti_Sel_SelectedIndexChanged" OnDataBound="DDL_Progetti_Sel_DataBound" Width="220px">
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
                        <div class="col-5">
                            <asp:TextBox ID="TB_Datada" class="ASPInputcontent datepickclass" runat="server" Columns="10" MaxLength="10" OnTextChanged="TB_Datada_TextChanged" OnLoad="TB_Datada_Load" />
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Data a</label>
                        </div>
                        <div class="col-5">
                            <asp:TextBox ID="TB_DataA" class="ASPInputcontent datepickclass" runat="server" Columns="10" MaxLength="10"
                                OnLoad="TB_DataA_Load" OnTextChanged="TB_DataA_TextChanged"></asp:TextBox>
                            <asp:Button ID="BT_filtra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" class="SmallOrangeButton"/>
                        </div>

                    </div>
                    <!-- Fine Row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-11 px-0">

                    <!--**** tabella principale ***-->
                    <asp:GridView ID="GV_Ore" runat="server" AllowPaging="True" CssClass="GridView"
                        AllowSorting="True" AutoGenerateColumns="False"
                        DataKeyNames="Hours_Id" PageSize="16" ShowFooter="True"
                        DataSourceID="DShours" GridLines="None" OnRowDataBound="GV_Ore_OnRowDataBound" EnableModelValidation="True" >
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <Columns>

                            <%-- data --%>
                            <asp:TemplateField HeaderText="Data" SortExpression="Date">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server" data-parsley-required="true" class="dataField datepickclass" Columns="8" MaxLength="10" Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server" data-parsley-required="true" class="datepickclass footerForm" Columns="8" MaxLength="10" Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterStyle Wrap="False" />
                            </asp:TemplateField>

                            <%-- progetto --%>
                            <asp:TemplateField HeaderText="Progetto" SortExpression="Projects_Id">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server" DataSourceID="dsProjects"
                                        DataTextField="codice" DataValueField="Projects_Id"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="140px"
                                        CssClass="TabellaLista projectField" OnSelectedIndexChanged="DDLProjects_Id_SelectedIndexChanged" AutoPostBack="True" AppendDataBoundItems="True">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" BorderWidth="0px"
                                        CssClass=" GV_row_alt" Height="18px" ReadOnly="True"
                                        Text='<%#Bind("NomeProgetto") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server"
                                        AppendDataBoundItems="True" CssClass="TabellaLista footerForm" DataSourceID="dsProjects"
                                        DataTextField="codice" DataValueField="Projects_Id" data-parsley-required="true"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="140px" AutoPostBack="True" OnSelectedIndexChanged="DDLProjects_Id_SelectedIndexChanged">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%#Bind("NomeProgetto") %>'
                                        BorderWidth="0px" CssClass=" GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- attività --%>
                            <asp:TemplateField HeaderText="Attivita" SortExpression="NomeAttivita">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLActivity_Id" runat="server"
                                        CssClass="TabellaLista activityField" Width="140px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TBActivity" runat="server" BorderWidth="0px" Width="90px"
                                        CssClass=" GV_row_alt" Height="18px" ReadOnly="True"
                                        Text='<%# Bind("NomeAttivita")%>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLActivity_Id" runat="server" AppendDataBoundItems="True"
                                        CssClass="TabellaLista" Width="140px" Visible="True">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TBActivity" runat="server" Width="110px" Text='<%#Bind("NomeAttivita") %>'
                                        BorderWidth="0px" CssClass=" GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- persona --%>
                            <asp:TemplateField HeaderText="Persona" SortExpression="Persons_id">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDL_Persona_Id" runat="server" CssClass="TabellaLista personField"
                                        DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id"
                                        SelectedValue='<%# Bind("Persons_id") %>' Width="130px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="GV_row_alt" ReadOnly="True"
                                        Text='<%#Bind("NomePersona") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDL_Persona_Id" runat="server" AppendDataBoundItems="True"
                                        CssClass="TabellaLista footerForm" DataSourceID="DDSPersone" DataTextField="Name"
                                        DataValueField="Persons_id" data-parsley-required="true"
                                        SelectedValue='<%# Bind("Persons_id") %>' Width="130px">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="GV_row"
                                        ReadOnly="True" Text='<%#Bind("NomePersona") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- ore --%>
                            <asp:TemplateField HeaderText="Ore" SortExpression="Hours">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Ore" runat="server" Columns="6" CssClass="TabellaLista hoursField" Width="50px" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true"
                                        MaxLength="6" Text='<%# Bind("Hours", "{0:#.##;#.##}") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Ore" runat="server" Columns="6" CssClass="TabellaLista footerForm" Width="50px" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true"
                                        MaxLength="6" Text='<%# Bind("Hours", "{0:N}") %>'></asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Width="50px" Text='<%# Bind("Hours", "{0:N}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- data competenza --%>
                            <asp:TemplateField HeaderText="Competenza" SortExpression="AccountingDate">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server"
                                        class="datepickclass TabellaLista accountingDateField" Columns="8" MaxLength="10"
                                        Text='<%# Bind("AccountingDate", "{0:d}") %>'>
                                    </asp:TextBox>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="GV_row_alt" ReadOnly="True"
                                        Text='<%#Bind("AccountingDate", "{0:d}") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server"
                                        class="datepickclass" Columns="8" MaxLength="10"
                                        Text='<%# Bind("AccountingDate", "{0:d}") %>'>
                                    </asp:TextBox>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="GV_row"
                                        ReadOnly="True" Text='<%#Bind("AccountingDate", "{0:d}") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- flag storno --%>
                            <asp:TemplateField HeaderText="ST" SortExpression="CancelFlag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" CssClass="cancelFlagField"
                                        Checked='<%# Bind("CancelFlag") %>' />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_Storno" runat="server"
                                        Checked='<%# Bind("CancelFlag") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("CancelFlag") %>'
                                        Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <%-- commento --%>
                            <asp:TemplateField HeaderText="Nota" SortExpression="Comment">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Columns="15" CssClass="TabellaLista commentField"
                                        Rows="3" Text='<%# Bind("Comment") %>' TextMode="MultiLine"></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Comment") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TX_comment" runat="server" Columns="10" CssClass="TabellaLista"
                                        Text='<%# Bind("Comment") %>' TextMode="SingleLine"></asp:TextBox>
                                </FooterTemplate>
                            </asp:TemplateField>

                            <%-- pulsanti --%>
                            <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                    <asp:Label ID="Hours_Id" CssClass="Hours_idField fieldsToHide" runat="server" Text='<%# Eval("Hours_Id") %>' />
                                    <asp:Label ID="LocationKey" CssClass="LocationKeyField fieldsToHide" runat="server" Text='<%# Eval("LocationType") + ":" + Eval("LocationKey") %>' />
                                    <asp:Label ID="LocationDescription" CssClass="LocationDescriptionField fieldsToHide" runat="server" Text='<%# Eval("LocationDescription") %>' />
                                    <asp:Label ID="SalesforceTaskId" CssClass="TaskNameField fieldsToHide" runat="server" Text='<%# Eval("SalesforceTaskId") %>' />
                                   <asp:ImageButton ID="BTSave" runat="server" CausesValidation="True" CssClass="EditButtonSave"
                                        ImageUrl="/timereport/images/icons/16x16/S_F_OKAY.gif"
                                        Text="<%$ appSettings: SAVE_TXT %>" />
                                    &nbsp;<asp:ImageButton ID="BTCancel" runat="server" CausesValidation="False" CssClass="CancelButton"
                                        ImageUrl="/timereport/images/icons/16x16/S_F_CANC.GIF"  Text="<%$ appSettings: CANCEL_TXT %>" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="BTInsert" runat="server" Text="<%$ appSettings: CREATE_TXT %>" class="SmallOrangeButton" />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Hours_Id" CssClass="Hours_idField fieldsToHide" runat="server" Text='<%# Eval("Hours_Id") %>' />
                                    <asp:ImageButton ID="BTUpdate" runat="server" CssClass="EditButtonOpen" CommandName="Edit"
                                        ImageUrl="/timereport/images/icons/16x16/modifica.gif" Text="<%$ appSettings: EDIT_TXT %>" />&nbsp;                      
                                    <asp:ImageButton ID="BTDelete" runat="server" CausesValidation="False" CssClass="DeleteButton"
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
    <asp:SqlDataSource ID="DShours" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="** backend **"  >
        <SelectParameters>
            <asp:ControlParameter ControlID="DDL_Persona_Sel" Name="DDL_Persona_Sel"
                PropertyName="SelectedValue" DefaultValue="%" />
            <asp:ControlParameter ControlID="DDL_Progetti_Sel" Name="DDL_Progetti_Sel"
                PropertyName="SelectedValue" DefaultValue="%" />
            <asp:ControlParameter ControlID="TB_DataDa" Name="TB_DataDa"
                PropertyName="text" Type="datetime" DefaultValue="1/1/2008" />
            <asp:ControlParameter ControlID="TB_DataA" Name="TB_DataA"
                PropertyName="text" Type="datetime" DefaultValue="31/12/9999" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Hours_Id" Type="Int32" />
        </DeleteParameters>

    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSattivita" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Activity_id, Name + ' ' + ActivityCode AS iAttivita FROM Activity WHERE active = 'true'"></asp:SqlDataSource>
    <asp:SqlDataSource ID="dsProjects" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + ' ' + Name AS codice, Active FROM Projects WHERE (Active = 1) ORDER BY codice"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DDSPersone" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>

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
            $('.SumoSelect').css('width', '220px');

        });

        // Initialize Parsley
        var form = $('#formOre').parsley({
            excluded: "input[type=button], input[type=submit], input[type=image], input[type=hidden], [disabled], :hidden"
        });

        // Disabilita temporaneamente la validazione di Parsley quando si preme il tasto edit o filtra
        $(".EditButtonOpen, .CancelButton, #BT_filtra").on("click", function (e) {
            $('#formOre').parsley().destroy();
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
            window.location.href = "/timereport/m_gestione/mass_insert_hours.aspx";
        });

        // Aggiorna Ore
        $(".EditButtonSave").on("click", function (e) {

            $('.footerForm').attr('data-parsley-required', 'false');

            // Check if the form is valid
            form.validate();
            if (!form.isValid())
                return;

            // Trova la riga contenente il pulsante cliccato
            var row = $(this).closest("tr");

            // Accedi ai campi all'interno di quella riga
            var hoursId = row.find(".Hours_idField").text();
            var LocationKey = row.find(".LocationKeyField").text();
            var LocationDescription = row.find(".LocationDescriptionField").text();
            var TaskName = row.find(".SalesforceTaskIdField").text();
            var dataField = row.find(".dataField").val();
            var projectField = row.find(".projectField").val();            
            var activityField = isNullOrEmpty(row.find(".activityField").val()) ? 0 : row.find(".activityField").val();
            var personField = row.find(".personField").val();
            var hoursField = row.find(".hoursField").val().replace(',', '.');
            var accountingDateField = row.find(".accountingDateField").val();
            // checkbox viene renderizzato con una span padre del checkbox
            var cancelFlagField = row.find(".cancelFlagField > input").is(":checked");
            var commentField = row.find(".commentField").val();

            var OpportunityId = "";

            var values = "{ 'Hours_Id': " + hoursId +
                " , 'Date': '" + dataField + "'" +
                " , 'Hours': '" + hoursField + "'" +
                " , 'Person_Id': " + personField +
                " , 'Project_Id': " + projectField +
                " , 'Activity_Id': " + activityField +
                " , 'Comment': '" + commentField + "'" +
                " , 'CancelFlag': " + cancelFlagField +
                " , 'LocationKey': '" + LocationKey + "'" +
                " , 'LocationDescription': '" + LocationDescription + "'" +
                " , 'OpportunityId': '" + OpportunityId + "'" +
                " , 'AccountingDate': '" + accountingDateField + "'" +
                " , 'SalesforceTaskID': '" + TaskName + "'}";

            // Aggiorna ore
            PostAjax(values);

        });

        // Crea Ore
        $("#GV_Ore_BTInsert").on("click", function (e) {

            e.preventDefault();

            // Trigger validation without submitting the form
            form.validate();

            // Check if the form is valid
            if (!form.isValid())
                return;

            // formattazione valori
            var Activity = isNullOrEmpty($('#GV_Ore_DDLActivity_Id').val()) ? 0 : $('#GV_Ore_DDLActivity_Id').val();
            var TaskName = isNullOrEmpty($('#FVore_DDLTaskName').val()) ? "" : $('#FVore_DDLTaskName').val();
            var LocationKey = "99999";
            var LocationDescription = "NOT SPECIFIED";
            var OpportunityId = "";
            //var LocationKey = $('#FVore_DDLLocation').is(':hidden') ? "99999" : $('#FVore_DDLLocation').val();
            //var LocationDescription = $('#FVore_DDLLocation').is(':hidden') ? $('#FVore_TBLocation').val() : $('#FVore_DDLLocation option:selected').text();
            var hoursId = 0;

            // tipo ora sempre defaultato a 1
            var values = "{ 'Hours_Id': " + hoursId +
                " , 'Date': '" + $('#GV_Ore_TB_Data').val() + "'" +
                " , 'Hours': '" + $('#GV_Ore_TB_Ore').val().replace(',', '.') + "'" +
                " , 'Person_Id': " + $('#GV_Ore_DDL_Persona_Id').val() +
                " , 'Project_Id': " + $('#GV_Ore_DDLProjects_Id').val() +
                " , 'Activity_Id': " + Activity +
                " , 'Comment': '" + $('#GV_Ore_TX_comment').val() + "'" +
                " , 'CancelFlag': " + $('#GV_Ore_CB_Storno').is(':checked') +
                " , 'LocationKey': '" + LocationKey + "'" +
                " , 'LocationDescription': '" + LocationDescription + "'" +
                " , 'OpportunityId': '" + OpportunityId + "'" +
                " , 'AccountingDate': '" + $('#GV_Ore_TB_AccountingDate').val() + "'" +
                " , 'SalesforceTaskID': '" + TaskName + "'}";

            // Inserisci ore
            PostAjax(values);

        });

        // Cancella record
        function DeleteRecord(row) {

            var hoursId = row.find(".Hours_idField").text();
            var values = "{'Id': '" + hoursId + "', DeletionType : 'hours' }";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/DeleteRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (response) {
                    var result = response.d
                    if (result.Success == true)
                        window.location.reload();
                    else
                        ShowPopup('Errore');
                },

                // in caso di errore
                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup(xhr.responseText);
                }

            }); // ajax
        }

        // Chiamata AJAX
        function PostAjax(values) {

            MaskScreen();

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/SaveHours",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    UnMaskScreen();
                    if (msg.d) {
                        ShowPopup('tre');
                        /*window.location.href = "/timereport/m_gestione/mass_insert_hours.aspx";*/
                    }
                    //ShowPopup("Aggiornamento effettuato");
                    else
                        ShowPopup('Errore durante aggiornamento');
                },
                error: function (xhr, textStatus, error) {
                    if (xhr.responseText.trim() == 0) {
                        ShowPopup('uno');
                        /*window.location.href = "/timereport/m_gestione/mass_insert_hours.aspx";*/
                    }
                    else {
                        UnMaskScreen();
                        ShowPopup('due');
                        ShowPopup(xhr.responseText);
                    }
                }
            }); // ajax
        }

    </script>

</body>

</html>
