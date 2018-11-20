<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    Public strMessage As String
    Dim strQueryOrdering As String = " ORDER BY Activity.ActivityCode "

    Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim sC1 As String
        Dim sWhere As String = ""

        Auth.CheckPermission("MASTERDATA", "WBS")

        sWhere = "WHERE Projects.clientmanager_id = " & Session("persons_id")

        ' Imposta il SelectCommand in base al contenuto della lista dropdown
        If DL_flattivo.SelectedValue <> "all" Or _
          (Session("DL_flattivo_val_att") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Activity.Active IN (@DL_flattivo)", sWhere & " AND Activity.Active IN (@DL_flattivo)")
        End If

        If DL_progetto.SelectedValue <> "all" Or _
          (Session("DL_progetto") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE Projects.Projects_id = (@DL_progetto)", sWhere & " AND Projects.Projects_id = (@DL_progetto)")
        End If

        If TB_Codice.Text <> Nothing Or _
            (Session("TB_ActivityCode") <> Nothing And Not IsPostBack) Then
            sC1 = IIf(sWhere = "", " WHERE ", " AND ")
            sWhere = sWhere & sC1 & "Activity.ActivityCode LIKE '%' + (@TB_Codice) + '%' "
        End If

        DSAttivita.SelectCommand = "SELECT Activity.ActivityCode, Activity.Name, Activity.Active, Activity.Projects_id as Projectsid, Activity.Phase_id as Phaseid, Projects.ProjectCode + '  ' + Projects.Name AS NomeProgetto, Phase.PhaseCode + '  ' + Phase.name AS Fase, Activity.Activity_id, Activity.RevenueBudget, Activity.MargineTarget FROM Activity " & _
                                   "INNER JOIN Projects ON Activity.Projects_id = Projects.Projects_Id " & _
                                   "LEFT OUTER JOIN Phase ON Activity.Phase_id = Phase.Phase_id " & sWhere & strQueryOrdering

        If Not IsPostBack And Session("GridActivityPageNumber") <> Nothing Then
            ' Imposta indice di aginazione
            GridView1.PageIndex = Session("GridActivityPageNumber")
        End If

    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        '       invia all form attività, progetto e fase. progetto e fase verranno utiizzati per inizializzare
        '       la fropdonwlist che essendo a cascata non riesce ad utilizzare le normali logiche di binding

        Dim ActivityId = GridView1.DataKeys(GridView1.SelectedRow.RowIndex).Values(0)
        Dim ProjectsId = GridView1.DataKeys(GridView1.SelectedRow.RowIndex).Values(1)
        Dim PhaseId = GridView1.DataKeys(GridView1.SelectedRow.RowIndex).Values(2)

        Response.Redirect("activity_lookup_form.aspx?Activity_id=" & ActivityId & "&Projects_Id=" & ProjectsId & "&Phase_Id=" & PhaseId)

    End Sub

    Protected Sub DL_progetto_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DL_progetto") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DL_flattivo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DL_flattivo_val_att") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub TB_Codice_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("TB_ActivityCode") = sender.text
    End Sub

    Protected Sub TB_Codice_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("TB_ActivityCode") <> Nothing Then
            TB_Codice.Text = Session("TB_ActivityCode")
        End If
    End Sub

    Protected Sub DL_progetto_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DL_progetto") <> Nothing Then
            DL_progetto.SelectedValue = Session("DL_progetto")
        End If
    End Sub

    Protected Sub DL_flattivo_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DL_flattivo_val_att") <> Nothing Then
            DL_flattivo.SelectedValue = Session("DL_flattivo_val_att")
        End If
    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)

        Dim c = New ValidationClass

        '       verifica integrità database        
        If c.CheckExistence("Activity_id", e.Keys(0), "Hours") Then
            e.Cancel = True
            ' Call separate class, passing page reference, to register Client Script:
            Utilities.CreateMessageAlert(Me, "Cancellazione non possibile, attività già utilizzata su tabella ore", "strKey1")
        End If

    End Sub

    ' Salva indice della pagina
    Protected Sub GridView1_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        GridView1.PageIndex = e.NewPageIndex
        Session("GridActivityPageNumber") = e.NewPageIndex
    End Sub

</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lista progetti</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css"> 
</head>
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>
<body>

 <div id="TopStripe"></div> 

 <div id="MainWindow">

    <form id="form1" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"> 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" > 

    <table width="760" border="0">
        <tr>
            <td>
                Attivo:
            </td>
            <td>
                <asp:DropDownList ID="DL_flattivo" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged"
                    OnPreRender="DL_flattivo_Load" >
                    <asp:ListItem Value="all">Tutti i valori</asp:ListItem>
                    <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                    <asp:ListItem Value="0">Non attivo</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
                Progetto:
            </td>
            <td>
                <asp:DropDownList ID="DL_progetto" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DSprogetti" DataTextField="iProgetto" DataValueField="Projects_Id"
                    OnSelectedIndexChanged="DL_progetto_SelectedIndexChanged" OnDataBound="DL_progetto_DataBound"
                    Width="150px">
                    <asp:ListItem Text="Tutti i valori" Value="all" />
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                Codice attività:
            </td>
            <td>
                <asp:TextBox ID="TB_Codice" runat="server" OnTextChanged="TB_Codice_TextChanged"
                    OnLoad="TB_Codice_Load" ></asp:TextBox>
                &nbsp;<asp:Button ID="BTFiltra" runat="server" class="SmallOrangeButton" Text="<%$ appSettings: FILTER_TXT %>" />
            </td>
            <td>
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
    </table>
    
    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap">  
    
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="DSAttivita" CssClass="GridView" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
        AllowPaging="True" PageSize="15" OnRowDeleting="GridView1_RowDeleting" DataKeyNames="Activity_id,Projectsid,Phaseid"
        GridLines="None" EnableModelValidation="True" OnPageIndexChanging="GridView1_PageIndexChanging">
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <PagerStyle CssClass="GV_footer" />
        <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
        <Columns>
            <asp:BoundField DataField="ActivityCode" HeaderText="Attività" SortExpression="ActivityCode" />                          
            <asp:BoundField DataField="Name" HeaderText="Descrizione" SortExpression="Name" />
            <asp:CheckBoxField DataField="Active" HeaderText="Attivo" ReadOnly="True" SortExpression="Active"/> 
            <asp:BoundField DataField="NomeProgetto" HeaderText="Nome progetto" SortExpression="NomeProgetto" />                           
            <asp:BoundField DataField="RevenueBudget" HeaderText="Revenue(€)" ReadOnly="True" SortExpression="RevenueBudget" dataformatstring="{0:n0}"  />
            <asp:BoundField DataField="MargineTarget" HeaderText="Margine" ReadOnly="True" SortExpression="MargineTarget" dataformatstring="{0:P1}" />
            <asp:CommandField ShowDeleteButton="True" ShowSelectButton="True" ButtonType="Image"
                DeleteImageUrl="/timereport/images/icons/16x16/trash.gif" SelectImageUrl="/timereport/images/icons/16x16/modifica.gif" />
            <asp:CommandField />
            <asp:BoundField DataField="Projectsid" HeaderText="Projectsid" Visible="False" 
                SortExpression="Projectsid" />
             <asp:BoundField DataField="Phaseid" HeaderText="Phaseid" Visible="False" 
                SortExpression="Phaseid" />            
        </Columns>
    </asp:GridView>

    <div class="buttons">       
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"   CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/activity/activity_lookup_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />       
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->
      
    <asp:SqlDataSource ID="DSAttivita" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand= "** costruita in page load **" 
        DeleteCommand="DELETE FROM Activity WHERE (Activity_id = @Activity_id)">
        <SelectParameters>
            <asp:ControlParameter ControlID="DL_flattivo" Name="DL_flattivo" PropertyName="SelectedValue"
                Type="String" />
            <asp:SessionParameter Name="sel_managerid" SessionField="persons_id" />
            <asp:ControlParameter ControlID="DL_progetto" Name="DL_progetto" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TB_Codice" DefaultValue="%" Name="TB_codice" PropertyName="Text" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Activity_id" />
        </DeleteParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DSprogetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + N'  ' + Name AS iProgetto, ClientManager_id, Active FROM Projects WHERE (ClientManager_id = @managerid) AND (Active = 1) AND (ActivityOn = 1) ORDER BY iProgetto">
        <SelectParameters>
            <asp:SessionParameter Name="managerid" SessionField="persons_id" />
        </SelectParameters>
    </asp:SqlDataSource>
   
    </form>

    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
     </div>   

</body>
</html>
