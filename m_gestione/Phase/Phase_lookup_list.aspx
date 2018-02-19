<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Phase_lookup_list.aspx.cs" Inherits="m_gestione_Phase_Phase_lookup_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Phase</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">  
</head>
    <SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
    <script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>
<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="form1" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"> 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

       <table border="0" >
              <tr><td>
                Progetto:
            </td>
            <td>
                <asp:DropDownList ID="DL_progetto" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DSprogetti" DataTextField="iProgetto" DataValueField="Projects_Id"
                    OnSelectedIndexChanged="DL_progetto_SelectedIndexChanged1" OnDataBound="DL_progetto_DataBound"
                    Width="150px" CssClass="TabellaLista">
                    <asp:ListItem Text="Tutti i valori" Value="all" />
                </asp:DropDownList>
            </td>
        </tr>
    </table>
 
    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap">  

        <asp:GridView ID="GridView1" runat="server" AllowPaging="True"  CssClass="GridView"
            AutoGenerateColumns="False" DataKeyNames="Phase_id" 
            DataSourceID="DSPhase" EnableModelValidation="True" 
            onrowdeleting="GridView1_RowDeleting"  GridLines="None"
            onselectedindexchanged="GridView1_SelectedIndexChanged" AllowSorting="True" PageSize="15">
            <FooterStyle CssClass="GV_footer" />
            <RowStyle Wrap="False" CssClass="GV_row" />
            <PagerStyle CssClass="GV_footer" />
            <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
            <Columns>
                <asp:BoundField DataField="NomeProgetto" HeaderText="Progetto" 
                    SortExpression="NomeProgetto" ReadOnly="True" />
                <asp:BoundField DataField="NomeFase" HeaderText="Fase" 
                    SortExpression="NomeFase" />
                <asp:BoundField DataField="Phase_id" HeaderText="Phaseid" Visible="False" 
                SortExpression="Phase_id" />
                <asp:CommandField ShowDeleteButton="True" ShowSelectButton="True" ButtonType="Image" HeaderText="Azioni"
                DeleteImageUrl="/timereport/images/icons/16x16/trash.gif" SelectImageUrl="/timereport/images/icons/16x16/modifica.gif" />
            </Columns>
        </asp:GridView>

    <div class="buttons">   
         <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"   CssClass="orangebutton"
               PostBackUrl="/timereport/m_gestione/Phase/Phase_lookup_form.aspx" />
          <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />

    </div> <!--End buttons-->

    </div> <!--End PanelWrap--> 

    <asp:SqlDataSource ID="DSPhase" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        DeleteCommand="DELETE FROM Phase WHERE (Phase_id = @Phase_id)" 
        
        SelectCommand="*** costruita in page load ***" >
        
        <SelectParameters>
            <asp:SessionParameter Name="sel_managerid" SessionField="persons_id" />
            <asp:ControlParameter ControlID="DL_progetto" Name="DL_progetto" PropertyName="SelectedValue" />
        </SelectParameters>    

        <DeleteParameters>
            <asp:Parameter Name="Phase_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DSprogetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + N'  ' + Name AS iProgetto, ClientManager_id, Active FROM Projects WHERE (ClientManager_id = @managerid) AND (Active = 1) and (ActivityOn = 1) ORDER BY iProgetto">
        <SelectParameters>
            <asp:SessionParameter Name="managerid" SessionField="persons_id" />
        </SelectParameters>
    </asp:SqlDataSource>
        
    </form>

     </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div>     

</body>
</html>
