<%@ Page Language="VB" %>

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
            sWhere = IIf(sWhere = "", " WHERE Hours.Persons_id = (@DDL_Persona_Sel)", sWhere & " AND Hours.Persons_id = (@DDL_Persona_Sel)")
        End If

        If DDL_Progetti_Sel.SelectedValue <> "all" Or
            (Session("DDL_Progetti_Sel") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Hours.Projects_id = (@DDL_Progetti_Sel)", sWhere & " AND Hours.Projects_id = (@DDL_Progetti_Sel)")
        End If

        If TB_Datada.Text <> Nothing Or
            (Session("TB_Datada") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Hours.Date >= (@TB_Datada)", sWhere & " AND Hours.Date >= (@TB_Datada)")
        End If

        If TB_DataA.Text <> Nothing Or
            (Session("TB_DataA") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Hours.Date <= (@TB_DataA)", sWhere & " AND Hours.Date <= (@TB_DataA)")
        End If

        DShours.SelectCommand = "SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.AccountingDate, Hours.CancelFlag, Hours.Comment, Persons.Name AS NomePersona, " _
                                & " Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto, Activity.Activity_Id , Activity.ActivityCode + ' ' + Activity.Name AS NomeAttivita FROM Hours INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id" _
                                & " LEFT JOIN Activity ON Activity.Activity_id = Hours.Activity_id " & sWhere & " ORDER BY Hours.Date, Hours.Projects_ID, Hours.Persons_Id"

    End Sub

    Protected Sub GV_Ore_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)

        ' Insert data if the CommandName == "Insert" 
        ' and the validation controls indicate valid data... 
        If e.CommandName = "Insert" AndAlso Page.IsValid Then

            ' Programmatically reference Web controls in the inserting interface... 
            Dim NewProjectsId As DropDownList = GV_Ore.FooterRow.FindControl("DDLProjects_Id")
            Dim NewActivityId As DropDownList = GV_Ore.FooterRow.FindControl("DDLActivity_Id")
            Dim NewPersonaId As DropDownList = GV_Ore.FooterRow.FindControl("DDL_Persona")
            Dim NewData As TextBox = GV_Ore.FooterRow.FindControl("TB_Data")
            Dim NewOre As TextBox = GV_Ore.FooterRow.FindControl("TB_Ore")
            Dim NewAccountingDate As TextBox = GV_Ore.FooterRow.FindControl("TB_AccountingDate")
            Dim NewStorno As CheckBox = GV_Ore.FooterRow.FindControl("CB_Storno")
            Dim NewTrasferta As CheckBox = GV_Ore.FooterRow.FindControl("CB_Trasferta")
            Dim NewComment As TextBox = GV_Ore.FooterRow.FindControl("TX_Comment")

            ' trova la società legata all'utente
            Dim dr As DataRow = Database.GetRow("SELECT company_id FROM Persons WHERE Persons_id = " & ASPcompatility.FormatNumberDB(NewPersonaId.SelectedValue), Nothing)

            DShours.InsertParameters("Projects_Id").DefaultValue = NewProjectsId.SelectedValue
            DShours.InsertParameters("Persons_id").DefaultValue = NewPersonaId.SelectedValue

            If NewActivityId.SelectedValue = "" Then
                DShours.InsertParameters("Activity_Id").DefaultValue = 0
            Else
                DShours.InsertParameters("Activity_Id").DefaultValue = NewActivityId.SelectedValue
            End If

            DShours.InsertParameters("Date").DefaultValue = NewData.Text
            DShours.InsertParameters("Hours").DefaultValue = NewOre.Text
            DShours.InsertParameters("AccountingDate").DefaultValue = NewAccountingDate.Text
            DShours.InsertParameters("CancelFlag").DefaultValue = NewStorno.Checked
            DShours.InsertParameters("HourType_Id").DefaultValue = 1 ' valore di default
            DShours.InsertParameters("Comment").DefaultValue = NewComment.Text

            DShours.InsertParameters("Company_id").DefaultValue = dr("Company_id")
            Dim result = Utilities.GetManagerAndAccountId(NewProjectsId.SelectedValue)
            DShours.InsertParameters("ClientManager_id").DefaultValue = result.Item1
            DShours.InsertParameters("AccountManager_id").DefaultValue = result.Item2

            If NewStorno.Checked Then
                DShours.InsertParameters("Hours").DefaultValue = DShours.InsertParameters("Hours").DefaultValue * -1
            End If

            ' Log
            DShours.InsertParameters("CreatedBy").DefaultValue = CurrentSession.UserId
            DShours.InsertParameters("CreationDate").DefaultValue = DateTime.Now()

            DShours.Insert()

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

    Protected Sub DShours_Updating(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs)

        ' gestisce storno
        If e.Command.Parameters("@cancelflag").Value Then
            e.Command.Parameters("@hours").Value = e.Command.Parameters("@hours").Value * -1
        End If

        ' Audit    
        e.Command.Parameters("@LastModifiedBy").Value = CurrentSession.UserId
        e.Command.Parameters("@LastModificationDate").Value = DateTime.Now()
    End Sub

    Protected Sub GV_Ore_OnRowDataBound(sender As Object, e As GridViewRowEventArgs)

        If Not ((e.Row.RowState = DataControlRowState.Edit) Or (e.Row.RowState = DataControlRowState.Alternate + DataControlRowState.Edit)) Then
            Return
        End If

        Dim DDLProjects_Id As DropDownList = e.Row.FindControl("DDLProjects_Id")
        Dim DDLActivity_id As DropDownList = e.Row.FindControl("DDLActivity_Id")

        If e.Row.DataItem("Activity_id").ToString <> "" Then
            ' id progetto, controll DDL attività, indice attività          
            Call BindDDL(DDLProjects_Id.SelectedValue, DDLActivity_id, e.Row.DataItem("Activity_id"))
        Else
            DDLActivity_id.Enabled = False
            DDLActivity_id.Visible = False
        End If

    End Sub

    Protected Sub BindDDL(iProject_id As String, DDLActivity_Id As DropDownList, iActivity_Id As Integer)

        ' recupera valore ore                        
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString)

            conn.Open()

            Dim cmd As SqlCommand = New SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS iActivity FROM Activity where Projects_id='" + iProject_id + "' AND active = 'true' ORDER BY ActivityCode", conn)
            Dim dr As SqlDataReader = cmd.ExecuteReader()

            DDLActivity_Id.DataSource = dr
            DDLActivity_Id.Items.Clear()
            DDLActivity_Id.DataTextField = "iActivity"
            DDLActivity_Id.DataValueField = "Activity_id"
            DDLActivity_Id.DataBind()

            If iActivity_Id <> 0 Then
                DDLActivity_Id.SelectedValue = iActivity_Id
            End If

            DDLActivity_Id.Visible = True

            '      Se il progetto prevede attività rende il controllo visibile 
            If dr.HasRows = False Then
                DDLActivity_Id.Enabled = False
                DDLActivity_Id.Visible = False
            Else
                DDLActivity_Id.Enabled = True
                DDLActivity_Id.Visible = True
            End If

            ' se in creazione imposta il default di progetto 
            'if (FVore.CurrentMode == FormViewMode.Insert & dr.HasRows)
            '    ddlActivity.SelectedValue = (string)Session["ActivityDefault"];

        End Using

    End Sub

    Protected Sub GV_Ore_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)

        '      Forza i valori da passare alla select di insert. essendo le dropdown in
        '      dipendenza non si riesce a farlo tramite un normale bind del controllo

        Dim ddlList As DropDownList = GV_Ore.Rows(e.RowIndex).Cells(2).FindControl("DDLActivity_Id")
        DShours.UpdateParameters("Activity_id").DefaultValue = ddlList.SelectedValue


    End Sub

    Protected Sub DDLProjects_Id_SelectedIndexChanged(sender As Object, e As EventArgs)

        Dim gvrow As GridViewRow = CType(sender, DropDownList).NamingContainer
        ' Dim rowindex As Integer = CType(gvrow, GridViewRow).RowIndex

        Dim DDLProjects_Id As DropDownList = gvrow.FindControl("DDLProjects_Id")
        Dim DDLActivity As DropDownList = gvrow.FindControl("DDLActivity_Id")

        'aggiornta attività collegate al progetto
        Call BindDDL(DDLProjects_Id.SelectedValue, DDLActivity, 0)

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
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
        <asp:Literal runat="server" Text="Gestione Ore" />
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
                        <div class="col-5">
                            <asp:DropDownList ID="DDL_Persona_Sel" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True" CssClass="ASPInputcontent"
                                DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id" OnSelectedIndexChanged="DDL_Persona_Sel_SelectedIndexChanged" OnDataBound="DDL_Persona_Sel_DataBound">
                                <asp:ListItem Text="Tutti i valori" Value="all" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-5">
                            <asp:DropDownList ID="DDL_Progetti_Sel" runat="server"
                                AppendDataBoundItems="True" AutoPostBack="True" CssClass="ASPInputcontent"
                                DataSourceID="dsProjects" DataTextField="codice" DataValueField="Projects_Id" OnSelectedIndexChanged="DDL_Progetti_Sel_SelectedIndexChanged" OnDataBound="DDL_Progetti_Sel_DataBound" Width="220px">
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
                        <div class="col-5">
                            <asp:TextBox ID="TB_Datada" class="ASPInputcontent datepickclass" runat="server" Columns="10" MaxLength="10" OnTextChanged="TB_Datada_TextChanged" OnLoad="TB_Datada_Load" />
                            <asp:RangeValidator ID="RV_DataDa" runat="server" Display="Dynamic"
                                ErrorMessage="Inserire un valore valido" MaximumValue="31/12/9999"
                                MinimumValue="01/01/2000" Type="Date" ValidationGroup="input"
                                ControlToValidate="TB_Datada">*</asp:RangeValidator>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Data a</label>
                        </div>
                        <div class="col-5">
                            <asp:TextBox ID="TB_DataA" class="ASPInputcontent datepickclass" runat="server" Columns="10" MaxLength="10"
                                OnLoad="TB_DataA_Load" OnTextChanged="TB_DataA_TextChanged"></asp:TextBox>
                            <asp:RangeValidator ID="RV_DataA" runat="server" Display="Dynamic"
                                ErrorMessage="Inserire un valore valido" MaximumValue="31/12/9999"
                                MinimumValue="01/01/2000" Type="Date" ValidationGroup="input"
                                ControlToValidate="TB_DataA">*</asp:RangeValidator>

                            <asp:Button ID="BT_filtra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" class="SmallOrangeButton"
                                ValidationGroup="input" />
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
                        OnRowCommand="GV_Ore_RowCommand" DataSourceID="DShours" GridLines="None" OnRowDataBound="GV_Ore_OnRowDataBound" EnableModelValidation="True" OnRowUpdating="GV_Ore_RowUpdating">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <Columns>
                            <asp:TemplateField HeaderText="Data" SortExpression="Date">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server"
                                        class="datepickclass" Columns="8" MaxLength="10" Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                        ControlToValidate="TB_Data" Display="None"
                                        ErrorMessage="Necessario specificare una data">*</asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="RangeValidator1" runat="server"
                                        ControlToValidate="TB_Data" Display="None"
                                        ErrorMessage="Inserire una data valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Data" runat="server" Columns="8" class="datepickclass" MaxLength="10" Text='<%# Bind("Date", "{0:d}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                        ControlToValidate="TB_Data" Display="None"
                                        ErrorMessage="Necessario specificare una data" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                    &nbsp;
                                    <asp:RangeValidator ID="RangeValidator1" runat="server"
                                        ControlToValidate="TB_Data" Display="None"
                                        ErrorMessage="Inserire una data valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date" ValidationGroup="Insert"></asp:RangeValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Date", "{0:d}") %>'></asp:Label>
                                </ItemTemplate>
                                <FooterStyle Wrap="False" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Progetto" SortExpression="Projects_Id">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server" DataSourceID="dsProjects"
                                        DataTextField="codice" DataValueField="Projects_Id"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="140px"
                                        CssClass="TabellaLista" OnSelectedIndexChanged="DDLProjects_Id_SelectedIndexChanged" AutoPostBack="True" AppendDataBoundItems="True">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" BorderWidth="0px"
                                        CssClass=" GV_row_alt" Height="18px" ReadOnly="True"
                                        Text='<%#Bind("NomeProgetto") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDLProjects_Id" runat="server"
                                        AppendDataBoundItems="True" CssClass="TabellaLista" DataSourceID="dsProjects"
                                        DataTextField="codice" DataValueField="Projects_Id"
                                        SelectedValue='<%# Bind("Projects_Id") %>' Width="140px" AutoPostBack="True" OnSelectedIndexChanged="DDLProjects_Id_SelectedIndexChanged">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                                        ControlToValidate="DDLProjects_Id" Display="None"
                                        ErrorMessage="Specificare un codice progetto" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%#Bind("NomeProgetto") %>'
                                        BorderWidth="0px" CssClass=" GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Attività" SortExpression="NomeAttivita">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DDLActivity_Id" runat="server"
                                        CssClass="TabellaLista" Width="140px">
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
                                        <%--                    <asp:DropDownList ID="DDLActivity_Id" runat="server" 
                        AppendDataBoundItems="True" CssClass="TabellaLista" DataSourceID="DSattivita" 
                        DataTextField="iAttivita" DataValueField="Activity_Id" 
                        SelectedValue='<%# Bind("Activity_Id")%>' Width="90px">
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>--%>
                                    </asp:DropDownList>
                                    <%--                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="DDLActivity_Id" Display="None" 
                        ErrorMessage="Specificare un codice progetto" ValidationGroup="Insert">*</asp:RequiredFieldValidator>--%>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TBActivity" runat="server" Width="110px" Text='<%#Bind("NomeAttivita") %>'
                                        BorderWidth="0px" CssClass=" GV_row" ReadOnly="True"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Persona" SortExpression="Persons_id">
                                <EditItemTemplate>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="TabellaLista"
                                        DataSourceID="DDSPersone" DataTextField="Name" DataValueField="Persons_id"
                                        SelectedValue='<%# Bind("Persons_id") %>' Width="130px">
                                    </asp:DropDownList>
                                </EditItemTemplate>
                                <AlternatingItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="GV_row_alt" ReadOnly="True"
                                        Text='<%#Bind("NomePersona") %>'></asp:TextBox>
                                </AlternatingItemTemplate>
                                <FooterTemplate>
                                    <asp:DropDownList ID="DDL_Persona" runat="server" AppendDataBoundItems="True"
                                        CssClass="TabellaLista" DataSourceID="DDSPersone" DataTextField="Name"
                                        DataValueField="Persons_id"
                                        SelectedValue='<%# Bind("Persons_id") %>' Width="130px">
                                        <asp:ListItem Value="" Text="Selezionare un valore" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                        ControlToValidate="DDL_Persona" Display="None"
                                        ErrorMessage="Specificare una persona di carico ore" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" CssClass="GV_row"
                                        ReadOnly="True" Text='<%#Bind("NomePersona") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Ore" SortExpression="Hours">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_Ore" runat="server" Columns="6" CssClass="TabellaLista" Width="50px"
                                        MaxLength="6" Text='<%# Bind("Hours", "{0:#.##;#.##}") %>'></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                        ControlToValidate="TB_Ore" Display="None"
                                        ErrorMessage="Necessario specificare un valore per le ore">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                        ControlToValidate="TB_Ore" Display="None"
                                        ErrorMessage="Inserire un valore numerico"
                                        ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)"></asp:RegularExpressionValidator>
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:TextBox ID="TB_Ore" runat="server" Columns="6" CssClass="TabellaLista" Width="50px"
                                        MaxLength="6" Text='<%# Bind("Hours", "{0:N}") %>' CausesValidation="True"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                        ControlToValidate="TB_Ore" Display="None"
                                        ErrorMessage="Necessario specificare un valore" ValidationGroup="Insert">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                                        ControlToValidate="TB_Ore" Display="None"
                                        ErrorMessage="Inserire un valore numerico"
                                        ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)"
                                        ValidationGroup="Insert"></asp:RegularExpressionValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Width="50px" Text='<%# Bind("Hours", "{0:N}") %>' ></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Competenza" SortExpression="AccountingDate">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TB_AccountingDate" runat="server"
                                        class="datepickclass" Columns="8" MaxLength="10"
                                        Text='<%# Bind("AccountingDate", "{0:d}") %>'>
                                    </asp:TextBox>
                                    <asp:RangeValidator ID="TB_AccountingDate_RV" runat="server"
                                        ControlToValidate="TB_AccountingDate" Display="None"
                                        ErrorMessage="Inserire una data competenza valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
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
                                    <asp:RangeValidator ID="TB_AccountingDate_RV" runat="server"
                                        ControlToValidate="TB_AccountingDate" Display="None"
                                        ErrorMessage="Inserire una data competenza valida" MaximumValue="31/12/9999"
                                        MinimumValue="01/01/2000" Type="Date" ValidationGroup="Insert"></asp:RangeValidator>
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox6" runat="server" CssClass="GV_row"
                                        ReadOnly="True" Text='<%#Bind("AccountingDate", "{0:d}") %>'></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ST" SortExpression="CancelFlag">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server"
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
                            <asp:TemplateField HeaderText="Nota" SortExpression="Comment">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Columns="15" CssClass="TabellaLista"
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
                            <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                    <asp:ImageButton ID="ImageButton1" runat="server" CausesValidation="True"
                                        CommandName="Update" ImageUrl="/timereport/images/icons/16x16/S_F_OKAY.gif"
                                        Text="<%$ appSettings: SAVE_TXT %>" />
                                    &nbsp;<asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False"
                                        CommandName="Cancel" ImageUrl="/timereport/images/icons/16x16/S_F_CANC.GIF"
                                        Text="<%$ appSettings: CANCEL_TXT %>" />
                                </EditItemTemplate>
                                <FooterTemplate>
                                    <asp:Button ID="Insert" runat="server" CommandName="Insert" Text="<%$ appSettings: CREATE_TXT %>" class="SmallOrangeButton"
                                        ValidationGroup="Insert" />
                                </FooterTemplate>
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButton3" runat="server" CausesValidation="False" CommandName="Edit"
                                        ImageUrl="/timereport/images/icons/16x16/modifica.gif" Text="<%$ appSettings: EDIT_TXT %>" />&nbsp;
                        <asp:ImageButton ID="ImageButton4" runat="server" CausesValidation="False" CommandName="Delete"
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
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                        ShowMessageBox="True" ShowSummary="False" />
                    <asp:ValidationSummary ID="ValidationSummary3" runat="server"
                        ValidationGroup="input" ShowMessageBox="True" ShowSummary="False" />
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server"
                        ShowMessageBox="True" ShowSummary="False" ValidationGroup="Insert" />

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
        SelectCommand="SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.AccountingDate, Hours.CancelFlag, Hours.Comment, Persons.Name AS NomePersona, Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto FROM Hours INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id ORDER BY Hours.Date, Hours.Projects_Id, Hours.Persons_id"
        DeleteCommand="DELETE FROM [Hours] WHERE [Hours_Id] = @Hours_Id"
        InsertCommand="INSERT INTO [Hours] ([Projects_Id], [Persons_id], [Date], [Hours], [HourType_Id], [AccountingDate], [CancelFlag], [Comment], [CreatedBy], [CreationDate], [Activity_id], Company_id, ClientManager_id, AccountManager_id) VALUES (@Projects_Id, @Persons_id, @Date, @Hours, @HourType_Id, @AccountingDate, @CancelFlag, @Comment, @CreatedBy, @CreationDate, @activity_id, @Company_id, @ClientManager_id, @AccountManager_id)"
        UpdateCommand="UPDATE Hours SET Projects_Id = @Projects_Id, Persons_id = @Persons_id, Date = @Date, Hours = @Hours, AccountingDate = @AccountingDate, CancelFlag = @CancelFlag, Comment = @Comment, LastModifiedBy = @LastModifiedBy, LastModificationDate = @LastModificationDate, Activity_Id = @Activity_Id WHERE (Hours_Id = @Hours_Id)"
        OnUpdating="DShours_Updating">
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
        <UpdateParameters>
            <asp:Parameter Name="Projects_Id" Type="Int32" />
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Date" Type="DateTime" />
            <asp:Parameter Name="Hours" Type="Decimal" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="CancelFlag" Type="Boolean" />
            <asp:Parameter Name="Comment" Type="String" />
            <asp:Parameter Name="LastModifiedBy" Type="String" />
            <asp:Parameter Name="LastModificationDate" Type="DateTime" />
            <asp:Parameter Name="Activity_Id" Type="Int32" />
            <asp:Parameter Name="Hours_Id" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Projects_Id" Type="Int32" />
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Date" Type="DateTime" />
            <asp:Parameter Name="Hours" Type="Decimal" />
            <asp:Parameter Name="HourType_Id" Type="Int32" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="CancelFlag" Type="Boolean" />
            <asp:Parameter Name="Comment" Type="String" />
            <asp:Parameter Name="CreatedBy" Type="String" />
            <asp:Parameter Name="CreationDate" Type="DateTime" />
            <asp:Parameter Name="Activity_id" Type="Int32" />
            <asp:Parameter Name="ClientManager_id" />
            <asp:Parameter Name="AccountManager_id" />
            <asp:Parameter Name="Company_id" />

        </InsertParameters>
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
