<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    Public strMessage As String
    Dim strQueryOrdering As String = " ORDER BY Persons.Name "

    Public CurrentSession As TRSession

    Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        ' Setting of default DB table
        Session("TableName") = "Persons"
        Dim sC1 As String
        Dim sWhere As String = ""

        Auth.CheckPermission("MASTERDATA", "PERSONE")
        CurrentSession = Session("CurrentSession")

        ' Imposta il SelectCommand in base al contenuto della lista dropdown
        If DL_flattivo.SelectedValue <> "all" Or _
(Session("Persons_DL_flattivo_val") <> Nothing And Not IsPostBack) Then
            sWhere = " WHERE Persons.Active IN (@DL_flattivo)"
        End If

        If TB_Nome.Text <> Nothing Or _
            (Session("TB_Nome_val") <> Nothing And Not IsPostBack) Then
            sC1 = IIf(sWhere = "", " WHERE ", " AND ")
            sWhere = sWhere & sC1 & "Persons.Name LIKE '%' + (@TB_Nome) + '%' "
        End If

        PersonsLookUpSqlDataSource.SelectCommand = "SELECT Persons.EmployeeNumber, Persons.Persons_id, Persons.Name as Nome, Roles.Name as Ruolo, persons.active, company.name as NomeSocieta, Persons.Attivo_da FROM Persons INNER JOIN Roles ON Persons.Roles_id = Roles.Roles_Id INNER JOIN Company ON persons.company_id = company.company_id " & sWhere & strQueryOrdering

        If Not IsPostBack And Session("GridView1PageNumber") <> Nothing Then
            ' Imposta indice di aginazione
            GridView1.PageIndex = Session("GridView1PageNumber")
        End If

    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("./persons_lookup_form.aspx?Persons_Id=" & GridView1.SelectedValue)
    End Sub

    Protected Sub DL_flattivo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("Persons_DL_flattivo_val") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub TB_Codice_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TB_Nome_val") = sender.text
    End Sub

    Protected Sub TB_Nome_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("TB_Nome_val") <> Nothing Then
            TB_Nome.Text = Session("TB_Nome_val")
        End If
    End Sub

    Protected Sub DL_flattivo_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("Persons_DL_flattivo_val") <> Nothing Then
            DL_flattivo.SelectedValue = Session("Persons_DL_flattivo_val")
        End If
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)

        Dim c = New ValidationClass
        Dim de = New DictionaryEntry

        For Each de In e.Keys
            '       verifica integrità database        
            If c.CheckExistence("persons_id", de.Value, "hours") Then
                e.Cancel = True
                ' Call separate class, passing page reference, to register Client Script:
                Utilities.CreateMessageAlert(Me, "Cancellazione non possibile, persona utilizzato su tabella ore", "strKey1")
            ElseIf c.CheckExistence("persons_id", de.Value, "expenses") Then
                e.Cancel = True
                ' Call separate class, passing page reference, to register Client Script:
                Utilities.CreateMessageAlert(Me, "Cancellazione non possibile, persona utilizzato su tabella spese", "strKey1")
            End If
        Next

    End Sub

    ' Salva indice della pagina
    Protected Sub GridView1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        GridView1.PageIndex = e.NewPageIndex
        Session("GridView1PageNumber") = e.NewPageIndex
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

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica persone" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
	<div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="row justify-content-center">

                <!--**** Primo Box ***-->
                <div class="col-9 RoundedBox">

                    <table width="100%" border="0">
                        <tr>
                            <td>Attivo:
                            </td>
                            <td>
                                <asp:DropDownList ID="DL_flattivo" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged"
                                    OnPreRender="DL_flattivo_Load">
                                    <asp:ListItem Value="all">Tutti i valori</asp:ListItem>
                                    <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                                    <asp:ListItem Value="0">Non attivo</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>Nome:
                            </td>
                            <td>
                                <asp:TextBox ID="TB_Nome" CssClass="ASPInputcontent" runat="server" OnTextChanged="TB_Codice_TextChanged" OnLoad="TB_Nome_Load"></asp:TextBox>
                                &nbsp;<asp:Button ID="Button1" class="SmallOrangeButton" runat="server" Text="<%$ appSettings: FILTER_TXT %>" />
                            </td>
                        </tr>
                    </table>

                </div>
                <!-- *** End col *** -->
            </div>
            <!-- *** End row *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-9 px-0">

                    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        DataSourceID="PersonsLookUpSqlDataSource" CssClass="GridView" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                        OnRowDeleting="GridView1_RowDeleting"
                        AllowPaging="True" PageSize="15" DataKeyNames="Persons_id"
                        GridLines="None" EnableModelValidation="True" OnPageIndexChanging="GridView1_PageIndexChanging">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <Columns>
                            <asp:BoundField DataField="EmployeeNumber" HeaderText="EN" SortExpression="EmployeeNumber" />
                            <asp:BoundField DataField="Nome" HeaderText="Nome" SortExpression="Nome" />
                            <asp:BoundField DataField="Ruolo" HeaderText="Ruolo" SortExpression="Ruolo" />
                            <asp:BoundField DataField="NomeSocieta" HeaderText="Società"
                                SortExpression="NomeSocieta" />
                            <asp:CheckBoxField DataField="active" HeaderText="Attivo" />
                            <asp:BoundField DataField="attivo_da" HeaderText="Attivo da"
                                DataFormatString="{0:dd-MM-yyyy}" SortExpression="attivo_da" />
                            <asp:CommandField ShowDeleteButton="True" ButtonType="Image"
                                DeleteImageUrl="/timereport/images/icons/16x16/trash.gif"
                                SelectImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                ShowSelectButton="True" />

                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">

                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton"
                            PostBackUrl="/timereport/m_gestione/persone/persons_lookup_form.aspx" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />

                    </div>

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
    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.EmployeeNumber, Persons.Persons_id, Persons.Name,Persons.Active, Persons.Attivo_da FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PersonsLookUpSqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        DeleteCommand="DELETE FROM [Persons] WHERE [Persons_id] = @Persons_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="DL_flattivo" Name="DL_flattivo" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="TB_Nome" Name="TB_Nome" PropertyName="text" DefaultValue="%" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Persons_id" Type="string" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>
</html>
