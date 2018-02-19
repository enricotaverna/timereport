<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Revenue-list.aspx.cs" Inherits="report_ReportRevenue" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  

<script>

    // JQUERY

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title> Controllo progetto </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="NOME_FORM" runat="server" CssClass="StandardForm" >
    
    <div id="PanelWrap" style="overflow-x:auto">  

        <div style="overflow-x:auto">

        <asp:GridView ID="GVAttivita" runat="server" AllowPaging="True"  CssClass="GridView" 
                AllowSorting="True" PageSize="15" AutoGenerateColumns="False" EnableModelValidation="True" CellPadding="5" OnPageIndexChanging="GVAttivita_PageIndexChanging"  >

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
                    </asp:TemplateField>
                    <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" Visible="false" />
                    <asp:BoundField DataField="MesiCopertura" HeaderText="Mesi Copertura" SortExpression="MesiCopertura"   />
                    <asp:BoundField DataField="WriteUp" HeaderText="Write Up/Off" SortExpression="WriteUp" DataFormatString="{0:###,###.00}"  />
                    <asp:BoundField DataField="PName" HeaderText="Progetto" SortExpression="PName" />
                    <asp:BoundField DataField="AName" HeaderText="Attività" SortExpression="AName" />
                    <asp:BoundField DataField="MName" HeaderText="Manager" SortExpression="MName" />
                    <asp:BoundField DataField="DataInizio" HeaderText="Data Inizio" SortExpression="DataInizio" dataformatstring="{0:d}" />
                    <asp:BoundField DataField="DataFine" HeaderText="Data Fine" SortExpression="DataFine" dataformatstring="{0:d}" />
                    <asp:BoundField DataField="RevenueBudget" HeaderText="Budget Revenue" SortExpression="RevenueBudget" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="SpeseBudget" HeaderText="Budget Spese" SortExpression="SpeseBudget" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="MargineBudget" HeaderText="Margine budget" SortExpression="MargineBudget" dataformatstring="{0:P1}"/>
                    <asp:BoundField DataField="GiorniActual" HeaderText="Giorni Actual" SortExpression="OreActual" DataFormatString="{0:###,###.00}" />                    
                    <asp:BoundField DataField="RevenueActual" HeaderText="Revenue Actual" SortExpression="RevenueActual" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="SpeseActual" HeaderText="Spese Actual" SortExpression="SpeseActual" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="BurnRate" HeaderText="Burn Rate" SortExpression="BurnRate" DataFormatString="{0:###,###.00}" />

                </Columns>
        
       </asp:GridView> 

      </div>
                
    <div class="buttons">              
            <!--Commentato perchè non ho trovato un modo semplice di mantenere i valori dei controlli al back -->
<%--        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton"  CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                     --%>
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
