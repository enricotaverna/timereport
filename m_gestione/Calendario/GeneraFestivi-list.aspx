<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GeneraFestivi-list.aspx.cs" Inherits="calendario_festiviList" EnableEventValidation="false"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<script>

    // JQUERY

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title> Report Revenue </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

 

    <form id="NOME_FORM" runat="server" CssClass="StandardForm" >
    
    <div id="PanelWrap" style="overflow-x:auto">  

        <div style="overflow-x:auto">

        <asp:GridView ID="GVAttivita" runat="server" AllowPaging="True"  CssClass="TabellaLista" GridLines="None"
                AllowSorting="True" PageSize="15"  AutoGenerateColumns="False" CellPadding="5" OnPageIndexChanging="GVAttivita_PageIndexChanging"  >

                <FooterStyle CssClass="GV_footer" />
                <RowStyle Wrap="False" CssClass="GV_row" />
                <PagerStyle CssClass="GV_footer" />
                <HeaderStyle CssClass="GV_header" />
                 <AlternatingRowStyle CssClass="GV_row_alt " />

                <Columns>
                    <asp:TemplateField HeaderText="Stato">
                        <ItemTemplate> 
                          <asp:Image ID="ImgStato" Runat="Server" ImageUrl=<%# Eval("ImgUrl") %> Height="16px" ImageAlign="Middle" />
                        </ItemTemplate>
                        <ItemStyle Width="10%" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" Visible="false" />
                    <asp:BoundField DataField="Message" HeaderText="Message" SortExpression="Message"  />
 
                </Columns>

          </asp:GridView> 

      </div>
                
    <div class="buttons">  
        
        <%--Messaggio se nessun dato selezionato --%>
        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>                     
        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" OnClick="BtnExport_Click"   />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>"  CssClass="greybutton"  />

    </div> <!--End buttons-->

    </div> <%-- END PanelWrap  --%> 

    </form>
    

    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa    <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 

</body>
</html>
