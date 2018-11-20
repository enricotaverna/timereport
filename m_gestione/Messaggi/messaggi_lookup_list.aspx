<%@ Page Language="VB" AutoEventWireup="false" CodeFile="messaggi_lookup_list.aspx.vb" Inherits="m_gestione_messaggi_list" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>  
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>    

<script>

    $(document).ready(function () {
        //    attribuisce id alla DIV della gridview 
        $('#GridView1').closest('div').attr('id', 'PanelWrap');
    });

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Lista Messaggi</title>
</head>

<body>
   
<div id="TopStripe"></div>  
 
 <div id="MainWindow"> 

    <form id="form1" runat="server">
        
        <div id="PanelWrap">  

        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" EnableModelValidation="True" 
            AllowSorting="True" CssClass="GridView" GridLines="None" 
            AllowPaging="True" DataKeyNames="MessaggioID"
            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" >
            <FooterStyle CssClass="GV_footer" />
            <RowStyle Wrap="False" CssClass="GV_row" />
            <Columns>
                <asp:BoundField DataField="MessaggioID" 
                    HeaderText="MessaggioID" SortExpression="MessaggioID" Visible="False"  />
                <asp:BoundField DataField="DataDa" 
                    HeaderText="DataDa" SortExpression="DataDa" 
                    DataFormatString="{0:dd-MM-yyyy}" />
                <asp:BoundField DataField="Titolo" HeaderText="Titolo" 
                    SortExpression="Titolo" />
                <asp:BoundField DataField="Messaggio" HeaderText="Messaggio" 
                    SortExpression="Messaggio" >
                <HeaderStyle Width="100px" />
                <ItemStyle Width="100px" Wrap="True" />
                </asp:BoundField>
                <asp:CommandField ButtonType="Image" 
                    DeleteImageUrl="/timereport/images/icons/16x16/trash.gif" 
                    SelectImageUrl="/timereport/images/icons/16x16/modifica.gif" 
                    ShowDeleteButton="True" ShowSelectButton="True" />
            </Columns>
            <PagerStyle CssClass="GV_footer" />
            <HeaderStyle CssClass="GV_header" />
            <AlternatingRowStyle CssClass="GV_row_alt " />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT * FROM [Messaggi] WHERE [DataA] &gt;=  GETDATE() AND [DataDA] &lt;= GETDATE() "
            DeleteCommand="DELETE FROM [Messaggi] WHERE [MessaggioID] = @MessaggioID">
            <DeleteParameters>
                <asp:Parameter Name="MessaggioID" />
            </DeleteParameters>
        </asp:SqlDataSource>

          <div class="buttons">     
              <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass=orangebutton
             PostBackUrl="/timereport/m_gestione/messaggi/Messaggi_lookup_form.aspx" />
              <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass=greybutton PostBackUrl="/timereport/menu.aspx" />    
         </div> <!--End buttons-->

         </div> <!--End PanelWrap-->

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
