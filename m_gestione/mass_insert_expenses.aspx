﻿<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    Sub DDLTipoOraFt_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        '       imposta valore di default
        sender.items.FindByText("STD001 Standard").selected = True
    End Sub

    Public CurrentSession As TRSession

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        If Not Page.IsPostBack Then
            Dim currentDate As String = DateTime.Now.ToString("dd/MM/yyyy")
            TB_Datada.Text = currentDate
        End If

        Dim sWhere As String = ""

        Auth.CheckPermission("ADMIN", "MASSCHANGE")
        CurrentSession = Session("CurrentSession")

        If DDL_Persona_Sel.SelectedValue <> "all" Or
  (Session("DDL_Persona_Sel") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Expenses.Persons_id = (@DDL_Persona_Sel)", sWhere & " AND Expenses.Persons_id = (@DDL_Persona_Sel)")
        End If

        If DDL_Progetti_Sel.SelectedValue <> "all" Or
            (Session("DDL_Progetti_Sel") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Expenses.Projects_id = (@DDL_Progetti_Sel)", sWhere & " AND Expenses.Projects_id = (@DDL_Progetti_Sel)")
        End If

        If DDL_Spesa_Sel.SelectedValue <> "all" Or
            (Session("DDL_Spesa_Sel") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Expenses.ExpenseType_id = (@DDL_Spesa_Sel)", sWhere & " AND Expenses.ExpenseType_id = (@DDL_Spesa_Sel)")
        End If

        If TB_Datada.Text <> Nothing Or
            (Session("TB_Datada") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Expenses.Date >= (@TB_Datada)", sWhere & " AND Expenses.Date >= (@TB_Datada)")
        End If

        If TB_DataA.Text <> Nothing Or
            (Session("TB_DataA") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Expenses.Date <= (@TB_DataA)", sWhere & " AND Expenses.Date <= (@TB_DataA)")
        End If

        DSExpenses.SelectCommand = "SELECT Expenses.Expenses_Id, Expenses.Projects_Id, Expenses.Persons_id, Expenses.Date, Expenses.amount, Expenses.ExpenseType_Id, Expenses.CancelFlag, Expenses.creditcardpayed, Expenses.CompanyPayed,Expenses.CompanyPayed, Expenses.invoiceFlag,Expenses.Comment, Expenses.AccountingDate,Persons.Name AS NomePersona, Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto, ExpenseType.ExpenseCode + ' ' + ExpenseType.Name AS TipoSpesa FROM Expenses INNER JOIN Projects ON Expenses.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id INNER JOIN ExpenseType ON Expenses.ExpenseType_Id = ExpenseType.ExpenseType_Id " _
                                 & sWhere & " ORDER BY Expenses.Date, Expenses.Projects_ID, Expenses.Persons_Id"

    End Sub

    Protected Sub GV_Spese_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)

        ' Insert data if the CommandName == "Insert" 
        ' and the validation controls indicate valid data... 
        If e.CommandName = "Insert" AndAlso Page.IsValid Then

            ' Programmatically reference Web controls in the inserting interface... 
            Dim NewProjectsId As DropDownList = GV_Spese.FooterRow.FindControl("DDLProjects_Id")
            Dim NewPersonaId As DropDownList = GV_Spese.FooterRow.FindControl("DDL_Persona")
            Dim NewData As TextBox = GV_Spese.FooterRow.FindControl("TB_Data")
            Dim NewAmount As TextBox = GV_Spese.FooterRow.FindControl("TB_Amount")
            Dim NewTipoSpese As DropDownList = GV_Spese.FooterRow.FindControl("DDLTipoSpesa_Id")
            Dim NewStorno As CheckBox = GV_Spese.FooterRow.FindControl("CB_Storno")
            Dim NewFattura As CheckBox = GV_Spese.FooterRow.FindControl("CB_Fattura")
            Dim NewCC As CheckBox = GV_Spese.FooterRow.FindControl("CB_CC")
            Dim CB_CompanyPayed As CheckBox = GV_Spese.FooterRow.FindControl("CB_CompanyPayed")
            Dim NewComment As TextBox = GV_Spese.FooterRow.FindControl("TX_Comment")
            Dim NewAccountingDate As TextBox = GV_Spese.FooterRow.FindControl("TB_AccountingDate")

            ' trova la società legata all'utente
            Dim dr As DataRow = Database.GetRow("SELECT company_id FROM Persons WHERE Persons_id = " & ASPcompatility.FormatNumberDB(NewPersonaId.SelectedValue), Nothing)

            ' recupera conversion rate associata al tipo spesa
            Dim dtTipoSpesa As DataTable = CurrentSession.dtSpeseTutte
            Dim dr1 As DataRow() = dtTipoSpesa.Select("ExpenseType_id =  " + NewTipoSpese.SelectedValue)
            If dr1.Count() <> 1 Then  ' non dovrebbe mai succedere! 
            End If

            DSExpenses.InsertParameters("Projects_Id").DefaultValue = NewProjectsId.SelectedValue
            DSExpenses.InsertParameters("Persons_id").DefaultValue = NewPersonaId.SelectedValue
            DSExpenses.InsertParameters("Date").DefaultValue = NewData.Text
            DSExpenses.InsertParameters("Amount").DefaultValue = NewAmount.Text
            DSExpenses.InsertParameters("ExpenseType_Id").DefaultValue = NewTipoSpese.SelectedValue
            DSExpenses.InsertParameters("CancelFlag").DefaultValue = NewStorno.Checked
            DSExpenses.InsertParameters("InvoiceFlag").DefaultValue = NewFattura.Checked
            DSExpenses.InsertParameters("CreditCardPayed").DefaultValue = NewCC.Checked
            DSExpenses.InsertParameters("CompanyPayed").DefaultValue = CB_CompanyPayed.Checked
            DSExpenses.InsertParameters("Comment").DefaultValue = NewComment.Text
            DSExpenses.InsertParameters("AccountingDate").DefaultValue = NewAccountingDate.Text

            DSExpenses.InsertParameters("Company_id").DefaultValue = dr("Company_id")
            Dim result = Utilities.GetManagerAndAccountId(NewProjectsId.SelectedValue)
            DSExpenses.InsertParameters("ClientManager_id").DefaultValue = result.Item1
            DSExpenses.InsertParameters("AccountManager_id").DefaultValue = result.Item2

            If Not (NewStorno.Checked) Then
                DSExpenses.InsertParameters("AmountInCurrency").DefaultValue = NewAmount.Text * Convert.ToDouble(dr1(0)("ConversionRate"))
            Else
                DSExpenses.InsertParameters("AmountInCurrency").DefaultValue = -1 * NewAmount.Text * Convert.ToDouble(dr1(0)("ConversionRate"))
            End If

            ' Log
            DSExpenses.InsertParameters("CreatedBy").DefaultValue = CurrentSession.UserId
            DSExpenses.InsertParameters("CreationDate").DefaultValue = DateTime.Now()

            ' Valorizza tipo Bonus e AdditionalCharges se il tipo spesa è di tipo bonus
            Dim dtExpenseType As DataRow = Database.GetRow("Select TipoBonus_id, AdditionalCharges from ExpenseType where ExpenseType_id=" + NewTipoSpese.SelectedValue, Me.Page)
            DSExpenses.InsertParameters("TipoBonus_id").DefaultValue = dtExpenseType("TipoBonus_id")
            DSExpenses.InsertParameters("AdditionalCharges").DefaultValue = dtExpenseType("AdditionalCharges")

            If NewStorno.Checked Then
                DSExpenses.InsertParameters("Amount").DefaultValue = DSExpenses.InsertParameters("Amount").DefaultValue * -1
            End If

            DSExpenses.Insert()

        End If

    End Sub

    Protected Sub DDL_Persona_Sel_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DDL_Persona_Sel") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DDL_Persona_Sel_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DDL_Persona_Sel") <> Nothing Then
            DDL_Persona_Sel.SelectedValue = Session("DDL_Persona_Sel")
        End If
    End Sub

    Protected Sub DDL_Progetti_Sel_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DDL_Progetti_Sel") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DDL_Spesa_Sel_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DDL_Spesa_Sel") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DDL_Spesa_Sel_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DDL_Spesa_Sel") <> Nothing Then
            DDL_Spesa_Sel.SelectedValue = Session("DDL_Spesa_Sel")
        End If
    End Sub

    Protected Sub DDL_Progetti_Sel_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DDL_Progetti_Sel") <> Nothing Then
            DDL_Progetti_Sel.SelectedValue = Session("DDL_Progetti_Sel")
        End If
    End Sub

    Protected Sub TB_Datada_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TB_DataDa") = sender.text
    End Sub

    Protected Sub TB_Datada_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("TB_DataDa") <> Nothing Then
            TB_Datada.Text = Session("TB_DataDa")
        End If
    End Sub

    Protected Sub TB_DataA_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("TB_DataA") <> Nothing Then
            TB_DataA.Text = Session("TB_DataA")
        End If
    End Sub

    Protected Sub TB_DataA_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TB_DataA") = sender.text
    End Sub

    Protected Sub DSExpenses_Updated(ByVal sender As Object, ByVal e As SqlDataSourceStatusEventArgs)

        ' scrive log record cancellato
        Database.ExecuteSQL("INSERT INTO LogDeletedRecords (RecordType, DeletedRecord_id, Timestamp) VALUES ('EXPENSE', " + e.Command.Parameters(0).Value.ToString() + ", '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')", Nothing)

    End Sub

    Protected Sub DSExpenses_Updating(ByVal sender As Object, ByVal e As SqlDataSourceCommandEventArgs)

        ' recupera conversion rate associata al tipo spesa
        Dim dtTipoSpesa As DataTable = CurrentSession.dtSpeseTutte
        Dim dr1 As DataRow() = dtTipoSpesa.Select("ExpenseType_id =  " + e.Command.Parameters("@ExpenseType_id").Value)
        If dr1.Count() <> 1 Then  ' non dovrebbe mai succedere! 
        End If

        ' gestisce storno
        If e.Command.Parameters("@cancelflag").Value Then
            e.Command.Parameters("@amount").Value = e.Command.Parameters("@amount").Value * -1
        End If

        e.Command.Parameters("@AmountInCurrency").Value = e.Command.Parameters("@amount").Value * Convert.ToDouble(dr1(0)("ConversionRate"))

        ' Valorizza tipo Bonus se il tipo spesa è di tipo bonus
        Dim drExpenseType = Database.GetRow("Select TipoBonus_id, AdditionalCharges from ExpenseType where ExpenseType_id=" + e.Command.Parameters("@ExpenseType_id").Value, Me.Page)
        e.Command.Parameters("@TipoBonus_id").Value = drExpenseType("TipoBonus_id")
        e.Command.Parameters("@AdditionalCharges").Value = drExpenseType("AdditionalCharges")

        ' Audit    
        e.Command.Parameters("@LastModifiedBy").Value = CurrentSession.UserId
        e.Command.Parameters("@LastModificationDate").Value = DateTime.Now()

    End Sub

</script>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

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
        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-11 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Persona</label>
                        </div>
                        <div class="col-3">
                                <asp:DropDownList ID="DDL_Persona_Sel" runat="server" AppendDataBoundItems="True"
                                    AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="DDSPersone" DataTextField="Name"
                                    DataValueField="Persons_id" OnSelectedIndexChanged="DDL_Persona_Sel_SelectedIndexChanged"
                                    OnDataBound="DDL_Persona_Sel_DataBound">
                                    <asp:ListItem Text="Tutti i valori" Value="all" />
                                </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-3">
                                <asp:DropDownList ID="DDL_Progetti_Sel" runat="server" AppendDataBoundItems="True"
                                    AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="dsProjects" DataTextField="codice" Width="220px"
                                    DataValueField="Projects_Id" OnSelectedIndexChanged="DDL_Progetti_Sel_SelectedIndexChanged"
                                    OnDataBound="DDL_Progetti_Sel_DataBound">
                                    <asp:ListItem Text="Tutti i valori" Value="all" />
                                </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Spese</label>
                        </div>
                        <div class="col-3">
                                <asp:DropDownList ID="DDL_Spesa_Sel" runat="server" AppendDataBoundItems="True"
                                    AutoPostBack="True" CssClass="ASPInputcontent" DataSourceID="dsTipoSpese" DataTextField="codiceSpesa" Width="220px"
                                    DataValueField="ExpenseType_Id" OnSelectedIndexChanged="DDL_Spesa_Sel_SelectedIndexChanged"
                                    OnDataBound="DDL_Spesa_Sel_DataBound">
                                    <asp:ListItem Text="Tutti i valori" Value="all" />
                                </asp:DropDownList>
                        </div>

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
                                <asp:RangeValidator ID="RV_DataDa" runat="server" Display="Dynamic" ErrorMessage="Inserire un valore valido"
                                    MaximumValue="31/12/9999" MinimumValue="01/01/2000" Type="Date" ValidationGroup="input"
                                    ControlToValidate="TB_Datada">*</asp:RangeValidator>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Data a</label>
                        </div>
                        <div class="col-3">
                                <asp:TextBox ID="TB_DataA" runat="server" class="ASPInputcontent datepickclass" Columns="10" MaxLength="10" OnLoad="TB_DataA_Load"
                                    OnTextChanged="TB_DataA_TextChanged"></asp:TextBox>
                                <asp:RangeValidator ID="RV_DataA" runat="server" Display="Dynamic" ErrorMessage="Inserire un valore valido"
                                    MaximumValue="31/12/9999" MinimumValue="01/01/2000" Type="Date" ValidationGroup="input"
                                    ControlToValidate="TB_DataA">*</asp:RangeValidator>
                                <asp:Button ID="BT_filtra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" ValidationGroup="input" class="SmallOrangeButton" />
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

                    <asp:GridView ID="GV_Spese" runat="server" AllowPaging="True" CssClass="GridView"
                        AllowSorting="True" AutoGenerateColumns="False" PageSize="16" ShowFooter="True"
                        OnRowCommand="GV_Spese_RowCommand" DataSourceID="DSExpenses" GridLines="None"
                        DataKeyNames="expenses_Id">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <Columns>
                            <asp:TemplateField HeaderText="Date" SortExpression="Date">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server" Text='<%# Bind("Date", "{0:d}") %>' Columns="10"
                                        CssClass="datepickclass" MaxLength="10"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Necessario specificare una data">*</asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Inserire una data valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server" Columns="8" CssClass="datepickclass" MaxLength="10"
                                        Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Necessario specificare una data" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Inserire una data valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date" ValidationGroup="Insert"></asp:RangeValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Progetto" SortExpression="NomeProgetto">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server" CssClass="TabellaLista" DataSourceID="dsProjects"
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
                                        CssClass="TabellaLista" DataSourceID="dsProjects" DataTextField="codice" DataValueField="Projects_Id"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="120px">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="DDLProjects_Id"
                                        Display="None" ErrorMessage="Specificare un codice progetto" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox6" Text='<%# Bind("NomeProgetto") %>' runat="server" CssClass=" GV_row"
                                        ReadOnly="True" BorderWidth="0px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Persona" SortExpression="NomePersona">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="TabellaLista" DataSourceID="DDSPersone"
                                        DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>'
                                        Width="90px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox7" runat="server" BorderWidth="0px" CssClass="GV_row_alt"
                                        ReadOnly="True" Text='<%# Bind("NomePersona") %>' Wrap="False"></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDL_Persona" runat="server" AppendDataBoundItems="True" CssClass="TabellaLista"
                                        DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>'
                                        Width="110px">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="DDL_Persona"
                                        Display="None" ErrorMessage="Specificare una persosa di carico spese   " ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox7" Text='<%# Bind("NomePersona") %>' runat="server" CssClass="GV_row"
                                        BorderWidth="0px" ReadOnly="True" Wrap="False"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Amount" runat="server" Text='<%# Bind("Amount", "{0:#.##;#.##}")%>'
                                        CssClass="TabellaLista" Columns="6" MaxLength="10"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TB_Amount"
                                        Display="None" ErrorMessage="Necessario specificare un valore">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="TB_Amount"
                                        Display="None" ErrorMessage="Inserire un valore numerico" ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)"></asp:RegularExpressionValidator>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Amount" runat="server" Columns="6" CssClass="TabellaLista" MaxLength="8"
                                        Text='<%# Bind("Amount", "{0:N}") %>' CausesValidation="True"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TB_Amount"
                                        Display="None" ErrorMessage="Necessario specificare un valore" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="TB_Amount"
                                        Display="None" ErrorMessage="Inserire un valore numerico" ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)"
                                        ValidationGroup="Insert"></asp:RegularExpressionValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="LBAmount" runat="server" Text='<%# Eval("Amount", "{0:#.00}")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TipoSpesa" SortExpression="TipoSpesa">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="TabellaLista" DataSourceID="DStipoSpesa"
                                        DataTextField="codice" DataValueField="ExpenseType_Id" SelectedValue='<%# Bind("ExpenseType_Id") %>'
                                        Width="110px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox8" runat="server" BorderWidth="0px" CssClass="GV_row_alt"
                                        ReadOnly="True" Text='<%# Bind("TipoSpesa") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLTipoSpesa_Id" runat="server" CssClass="TabellaLista" DataSourceID="DStipoSpesa"
                                        DataTextField="codice" DataValueField="ExpenseType_Id" SelectedValue='<%# Bind("ExpenseType_Id") %>'
                                        Width="110px" AppendDataBoundItems="True">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="DDLTipoSpesa_Id"
                                        Display="None" ErrorMessage="Specificare un codice spesa" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox8" Text='<%# Bind("TipoSpesa") %>' runat="server" BorderWidth="0px"
                                        CssClass="GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Competenza" SortExpression="AccountingDate">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server" Text='<%# Bind("AccountingDate", "{0:d}") %>'
                                        Columns="10" CssClass="datepickclass" MaxLength="10"></asp:TextBox>
                                    <asp:RangeValidator ID="TB_AccountingDate_RV" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Inserire una data competenza valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server" Columns="8" CssClass="datepickclass"
                                        MaxLength="10" Text='<%# Bind("AccountingDate", "{0:d}") %>'></asp:TextBox>
                                    <asp:RangeValidator ID="TB_AccountingDate_RV" runat="server" ControlToValidate="TB_Data"
                                        Display="None" ErrorMessage="Inserire una data competenza valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label123" runat="server" Text='<%# Bind("AccountingDate", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="St" SortExpression="CancelFlag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_storno" runat="server" Checked='<%# Bind("CancelFlag") %>' Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="CC" SortExpression="creditcardpayed">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>' />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_CC" runat="server" Checked='<%# Bind("creditcardpayed") %>'
                                        Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="PA" SortExpression="CompanyPayed">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>' />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_CompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed")%>'
                                        Enabled="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="FT" SortExpression="invoiceflag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CB_fattura" runat="server" Checked='<%# Bind("InvoiceFlag") %>'
                                        Enabled="False" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Comment" SortExpression="Comment">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Columns="10" CssClass="TabellaLista" Rows="3"
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
                            <asp:TemplateField>
                                <EditItemTemplate>
                                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="True" CommandName="Update"
                                        ImageUrl="/timereport/images/icons/16x16/S_F_OKAY.gif" Text="<%$ appSettings: SAVE_TXT %>" />&nbsp;
                        <asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" CommandName="Cancel"
                            ImageUrl="/timereport/images/icons/16x16/S_F_CANC.GIF" Text="<%$ appSettings: CANCEL_TXT %>" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="Insert" runat="server" CommandName="Insert" Text="<%$ appSettings: CREATE_TXT %>" ValidationGroup="Insert" class="SmallOrangeButton" />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="False" CommandName="Edit"
                                        ImageUrl="/timereport/images/icons/16x16/modifica.gif" Text="<%$ appSettings: EDIT_TXT %>" />&nbsp;
                        <asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" CommandName="Delete"
                            ImageUrl="/timereport/images/icons/16x16/trash.gif" OnClientClick="return confirm('Il record verrà cancellato, confermi?');"
                            Text="<%$ appSettings: DELETE_TXT %>" />
                                </ItemTemplate>
                                <ItemStyle Wrap="False" />
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <!-- **** VALIDATION **** -->
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                        ShowSummary="False" />
                    <asp:ValidationSummary ID="ValidationSummary3" runat="server" ValidationGroup="input"
                        ShowMessageBox="True" ShowSummary="False" />
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True"
                        ShowSummary="False" ValidationGroup="Insert" />

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
        SelectCommand="SELECT expenses.expenses_Id, expenses.Projects_Id, expenses.Persons_id, expenses.Date, expenses.Amount, expenses.ExpenseType_Id, expenses.CancelFlag, expenses.creditcardpayed, expenses.CompanyPayed, expenses.invoiceflag,expenses.Comment, expenses.AccountingDate, Persons.Name AS NomePersona, Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto, ExpenseType.ExpenseCode + ' ' + ExpenseType.Name AS TipoSpesa, AdditionalCharges FROM Expenses INNER JOIN Projects ON Expenses.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id INNER JOIN ExpenseType ON Expenses.ExpenseType_Id = ExpenseType.ExpenseType_Id ORDER BY Expenses.Date, Expenses.Projects_Id, Expenses.Persons_id"
        DeleteCommand="DELETE FROM [Expenses] WHERE [Expenses_Id] = @Expenses_Id"
        InsertCommand="INSERT INTO [Expenses] ([Projects_Id], [Persons_id], [Date], [Amount], [ExpenseType_Id], [CancelFlag],[InvoiceFlag],[CreditCardPayed], [CompanyPayed] ,[Comment], [CreatedBy], [CreationDate], [AccountingDate], [TipoBonus_id], Company_id, ClientManager_id, AccountManager_id, AdditionalCharges, AmountInCurrency) VALUES (@Projects_Id, @Persons_id, @Date, @amount, @ExpenseType_Id, @CancelFlag,@InvoiceFlag,@CreditCardPayed, @CompanyPayed, @Comment, @CreatedBy, @CreationDate, @AccountingDate, @TipoBonus_id, @Company_id, @ClientManager_id, @AccountManager_id, @AdditionalCharges, @AmountInCurrency)"
        UpdateCommand="UPDATE [Expenses] SET [Projects_Id] = @Projects_Id, [Persons_id] = @Persons_id, [Date] = @Date, [amount] = @amount, [ExpenseType_Id] = @ExpenseType_Id, [CancelFlag] = @CancelFlag, [CreditCardPayed] = @CreditCardPayed, [CompanyPayed] = @CompanyPayed, [InvoiceFlag] = @InvoiceFlag, [Comment] = @Comment, [LastModifiedBy] = @LastModifiedBy, [LastModificationDate] = @LastModificationDate, [AccountingDate] = @AccountingDate, [TipoBonus_id] = @TipoBonus_id, [AdditionalCharges] = @AdditionalCharges, [AmountInCurrency] = @AmountInCurrency WHERE [Expenses_Id] = @Expenses_Id"
        OnUpdating="DSExpenses_Updating" OnDeleted ="DSExpenses_Updated">
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
        <DeleteParameters>
            <asp:Parameter Name="expenses_Id" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Projects_Id" Type="Int32" />
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Date" Type="DateTime" />
            <asp:Parameter Name="Amount" Type="Decimal" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="CancelFlag" Type="Boolean" />
            <asp:Parameter Name="CreditCardPayed" Type="Boolean" />
            <asp:Parameter Name="CompanyPayed" Type="Boolean" />
            <asp:Parameter Name="InvoiceFlag" Type="Boolean" />
            <asp:Parameter Name="Comment" Type="String" />
            <asp:Parameter Name="expenses_Id" Type="Int32" />
            <asp:Parameter Name="LastModifiedBy" Type="String" />
            <asp:Parameter Name="LastModificationDate" Type="DateTime" />
            <asp:Parameter Name="TipoBonus_id" Type="Int32" />
            <asp:Parameter Name="AdditionalCharges" Type="Boolean" />
            <asp:Parameter Name="AmountInCurrency" Type="Decimal" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Projects_Id" Type="Int32" />
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Date" Type="DateTime" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="Amount" Type="Decimal" />
            <asp:Parameter Name="expenseType_Id" Type="Int32" />
            <asp:Parameter Name="CancelFlag" Type="Boolean" />
            <asp:Parameter Name="InvoiceFlag" Type="Boolean" />
            <asp:Parameter Name="CreditCardPayed" Type="Boolean" />
            <asp:Parameter Name="CompanyPayed" Type="Boolean" />
            <asp:Parameter Name="Comment" Type="String" />
            <asp:Parameter Name="CreatedBy" Type="String" />
            <asp:Parameter Name="CreationDate" Type="DateTime" />
            <asp:Parameter Name="TipoBonus_id" Type="Int32" />
            <asp:Parameter Name="ClientManager_id" />
            <asp:Parameter Name="AccountManager_id" />
            <asp:Parameter Name="Company_id" />
            <asp:Parameter Name="AdditionalCharges" Type="Boolean" />
            <asp:Parameter Name="AmountInCurrency" Type="Decimal" />
        </InsertParameters>
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
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(document).ready(function () {
            $(".datepickclass").datepicker($.datepicker.regional['it']);
        });
    </script>

</body>

</html>
