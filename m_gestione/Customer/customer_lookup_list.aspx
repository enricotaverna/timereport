<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Auth.CheckPermission("MASTERDATA", "CUSTOMER")

        Dim sWhere As String

        sWhere = ""
        ' Imposta il SelectCommand in base al contenuto della lista dropdown
        If DL_flattivo.SelectedValue <> "all" Or _
          (Session("DL_flattivo_val") <> Nothing And Not IsPostBack) Then
            sWhere = " WHERE [flagAttivo] IN (@DL_flattivo)"
        End If

        If DL_manager.SelectedValue <> "all" Or _
          (Session("DL_manager_val") <> Nothing And Not IsPostBack) Then
            sWhere = IIf(sWhere = "", " WHERE [ClientManager_id] = (@DL_manager)", sWhere & " AND [ClientManager_id] = (@DL_manager)")
        End If

        SqlDataSource1.SelectCommand = "SELECT Persons.Name, Customers.* FROM Customers LEFT OUTER  JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id" & sWhere

        SqlDataSource1.SelectCommand = SqlDataSource1.SelectCommand + " ORDER BY CodiceCliente"

    End Sub

    Protected Sub GridView1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Response.Redirect("customer_lookup_form.aspx?CodiceCliente=" & GridView1.SelectedValue)
    End Sub

    Protected Sub DL_manager_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DL_manager_val") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DL_flattivo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        Session("DL_flattivo_val") = IIf(sender.selectedValue <> "all", sender.selectedValue, Nothing)
    End Sub

    Protected Sub DL_manager_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DL_manager_val") <> Nothing Then
            DL_manager.SelectedValue = Session("DL_manager_val")
        End If
    End Sub

    Protected Sub DL_flattivo_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        ' Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        If Not IsPostBack And Session("DL_flattivo_val") <> Nothing Then
            DL_flattivo.SelectedValue = Session("DL_flattivo_val")
        End If
    End Sub

    Protected Sub BtnExport_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        Utilities.ExportXls("SELECT Customers.*, Persons.Name FROM Customers LEFT OUTER  JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id")

    End Sub

    Protected Sub GridView1_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs)

        Dim c = New ValidationClass
        Dim de = New DictionaryEntry

        For Each de In e.Keys
            '       verifica integrità database        
            If c.CheckExistence("CodiceCliente", de.Value, "Projects") Then
                e.Cancel = True
                ' Call separate class, passing page reference, to register Client Script:
                Utilities.CreateMessageAlert(Me, "Cancellazione non possibile, cliente utilizzato su tabella progetti", "strKey1")
            End If
        Next

    End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lista clienti</title>    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">    
</head>

    <!-- Jquery -->
    <link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="/timereport/include/jquery/jquery-ui.min.js"></script>    

    <SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT> 
    <script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>    
    
<body>     

 <div id="TopStripe"></div> 

 <div id="MainWindow">
  
    <form id="form1" runat="server" >

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"> 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" > 

<table width="760" border="0" class="GridTab" > 
  <tr>
  <td>Attivo:</td>
  <td>
      <asp:DropDownList ID="DL_flattivo" runat="server" AutoPostBack="True" 
          OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged" 
          OnPreRender="DL_flattivo_Load" >
          <asp:ListItem Value="all">Tutti i valori</asp:ListItem>
          <asp:ListItem Selected="True" Value=1>Attivo</asp:ListItem>
          <asp:ListItem Value=0>Non attivo</asp:ListItem>
      </asp:DropDownList>
                </td>
    <td>Manager:</td>
      <td>
          <asp:DropDownList ID="DL_manager" runat="server" AutoPostBack="True" AppendDataBoundItems="true"
              DataSourceID="DS_Persone" DataTextField="Name" DataValueField="Persons_id" 
              OnSelectedIndexChanged="DL_manager_SelectedIndexChanged" 
              OnDataBound="DL_manager_DataBound" CssClass="TabellaLista">
                <asp:ListItem Text="Tutti i valori" Value="all" />
          </asp:DropDownList>
    </td>
  </tr>   
</table> 

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

        <div id="PanelWrap">  
        
        <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
            AutoGenerateColumns="False" DataKeyNames="CodiceCliente" 
            DataSourceID="SqlDataSource1" CssClass="GridView" 
            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" 
            OnRowDeleting="GridView1_RowDeleting" AllowPaging="True" GridLines="None">
            <FooterStyle CssClass="GV_footer" />
            <RowStyle Wrap="False" CssClass="GV_row" />
            <Columns>
                <asp:BoundField DataField="CodiceCliente" HeaderText="Cliente" 
                    SortExpression="CodiceCliente" />
                <asp:BoundField DataField="Nome1" HeaderText="Nome" SortExpression="Nome1" />
                <asp:TemplateField HeaderText="Manager" SortExpression="Name">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                    </ItemTemplate>                             
                </asp:TemplateField>
                <asp:BoundField DataField="PIVA" HeaderText="PIVA" SortExpression="PIVA" />
                <asp:CheckBoxField DataField="FlagAttivo" HeaderText="Attivo" 
                    SortExpression="FlagAttivo" />
                <asp:BoundField DataField="ClientManager_id" HeaderText="ClientManager_id" 
                    SortExpression="ClientManager_id" Visible="False" />
                <asp:BoundField DataField="TerminiPagamento" HeaderText="Ter. di Pag." 
                    SortExpression="TerminiPagamento" />
                <asp:BoundField DataField="MetodoPagamento" HeaderText="Met. di Pag." 
                    SortExpression="MetodoPagamento" />
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
             <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/customer/customer_lookup_form.aspx" />
             <asp:Button ID="BtnExport" runat="server"  CssClass="orangebutton" OnClick="BtnExport_Click" Text="<%$ appSettings: EXPORT_TXT %>" />       
             <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
        </div> <!--End buttons-->

        </div> <!--End PanelWrap-->
           
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"  
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            DeleteCommand="DELETE FROM [Customers] WHERE [CodiceCliente] = @CodiceCliente" 
            InsertCommand="INSERT INTO [Customers] ([CodiceCliente], [Nome1], [PIVA], [FlagAttivo], [CodiceFiscale], [SedeLegaleVia1], [SedeLegaleCitta], [SedeLegaleProv], [SedeLegaleCAP], [SedeLegaleNazione], [SedeOperativaVia1], [SedeOperativaCitta], [SedeOperativaProv], [SedeOperativaCAP], [SedeOperativaNazione], [MetodoPagamento], [TerminiPagamento], [ClientManager_id], [Note]) VALUES (@CodiceCliente, @Nome1, @PIVA, @FlagAttivo, @CodiceFiscale, @SedeLegaleVia1, @SedeLegaleCitta, @SedeLegaleProv, @SedeLegaleCAP, @SedeLegaleNazione, @SedeOperativaVia1, @SedeOperativaCitta, @SedeOperativaProv, @SedeOperativaCAP, @SedeOperativaNazione, @MetodoPagamento, @TerminiPagamento, @ClientManager_id, @Note)" 
            SelectCommand="SELECT Persons.Name, Customers.* FROM Customers INNER JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id ORDER BY Customers.CodiceCliente" 
            UpdateCommand="UPDATE [Customers] SET [Nome1] = @Nome1, [PIVA] = @PIVA, [FlagAttivo] = @FlagAttivo, [CodiceFiscale] = @CodiceFiscale, [SedeLegaleVia1] = @SedeLegaleVia1, [SedeLegaleCitta] = @SedeLegaleCitta, [SedeLegaleProv] = @SedeLegaleProv, [SedeLegaleCAP] = @SedeLegaleCAP, [SedeLegaleNazione] = @SedeLegaleNazione, [SedeOperativaVia1] = @SedeOperativaVia1, [SedeOperativaCitta] = @SedeOperativaCitta, [SedeOperativaProv] = @SedeOperativaProv, [SedeOperativaCAP] = @SedeOperativaCAP, [SedeOperativaNazione] = @SedeOperativaNazione, [MetodoPagamento] = @MetodoPagamento, [TerminiPagamento] = @TerminiPagamento, [ClientManager_id] = @ClientManager_id, [Note] = @Note WHERE [CodiceCliente] = @CodiceCliente">
            <SelectParameters>
              <asp:ControlParameter ControlID="DL_flattivo" Name="DL_flattivo" PropertyName="SelectedValue"
                Type="String" />
                <asp:ControlParameter ControlID="DL_manager" Name="DL_manager" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="CodiceCliente" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Nome1" Type="String" />
                <asp:Parameter Name="PIVA" Type="String" />
                <asp:Parameter Name="FlagAttivo" Type="Boolean" />
                <asp:Parameter Name="CodiceFiscale" Type="String" />
                <asp:Parameter Name="SedeLegaleVia1" Type="String" />
                <asp:Parameter Name="SedeLegaleCitta" Type="String" />
                <asp:Parameter Name="SedeLegaleProv" Type="String" />
                <asp:Parameter Name="SedeLegaleCAP" Type="String" />
                <asp:Parameter Name="SedeLegaleNazione" Type="String" />
                <asp:Parameter Name="SedeOperativaVia1" Type="String" />
                <asp:Parameter Name="SedeOperativaCitta" Type="String" />
                <asp:Parameter Name="SedeOperativaProv" Type="String" />
                <asp:Parameter Name="SedeOperativaCAP" Type="String" />
                <asp:Parameter Name="SedeOperativaNazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="Note" Type="String" />
                <asp:Parameter Name="CodiceCliente" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="CodiceCliente" Type="String" />
                <asp:Parameter Name="Nome1" Type="String" />
                <asp:Parameter Name="PIVA" Type="String" />
                <asp:Parameter Name="FlagAttivo" Type="Boolean" />
                <asp:Parameter Name="CodiceFiscale" Type="String" />
                <asp:Parameter Name="SedeLegaleVia1" Type="String" />
                <asp:Parameter Name="SedeLegaleCitta" Type="String" />
                <asp:Parameter Name="SedeLegaleProv" Type="String" />
                <asp:Parameter Name="SedeLegaleCAP" Type="String" />
                <asp:Parameter Name="SedeLegaleNazione" Type="String" />
                <asp:Parameter Name="SedeOperativaVia1" Type="String" />
                <asp:Parameter Name="SedeOperativaCitta" Type="String" />
                <asp:Parameter Name="SedeOperativaProv" Type="String" />
                <asp:Parameter Name="SedeOperativaCAP" Type="String" />
                <asp:Parameter Name="SedeOperativaNazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="Note" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>   
 
                <asp:SqlDataSource ID="DS_Persone" runat="server" 
    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
    
      
    SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Customers ON Persons.Persons_id = Customers.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                    </SelectParameters>
</asp:SqlDataSource>
        
    </form>

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
        <div  id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
     </div>   
      
</body>
</html>
