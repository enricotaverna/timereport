<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlloProgetto-list.aspx.cs" Inherits="report_ControlloProgettoList" EnableEventValidation="false" %>

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
                AllowSorting="false" PageSize="15" AutoGenerateColumns="False" EnableModelValidation="True" CellPadding="5" OnPageIndexChanging="GVAttivita_PageIndexChanging" OnRowDataBound="GVAttivita_RowDataBound"    >

                <FooterStyle CssClass="GV_footer" />
                <RowStyle Wrap="False" CssClass="GV_row" />
                <PagerStyle CssClass="GV_footer" />
                <HeaderStyle CssClass="GV_header" />
                 <AlternatingRowStyle CssClass="GV_row_alt " />

                <Columns>
                    <asp:TemplateField HeaderText="Stato">
                        <ItemTemplate> 
                          <asp:Image ID="ImgStato" Runat="Server" ImageUrl=<%# Eval("ImgUrl") %> Height="16px" ImageAlign="Middle" ToolTip=<%# Eval("ToolTip") %> />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" Visible="false" />
                    <asp:BoundField DataField="MesiCopertura" HeaderText="Mesi C." SortExpression="MesiCopertura"   />
                    <asp:BoundField DataField="WriteUp" HeaderText="Write Up/Off" SortExpression="WriteUp" DataFormatString="{0:###,###.00}"  />
                    <asp:BoundField DataField="GiorniActual" HeaderText="Giorni Actual" SortExpression="OreActual" DataFormatString="{0:###,###.00}" />              
                          
                    <%--<asp:BoundField DataField="RevenueActual" HeaderText="Revenue Actual" SortExpression="RevenueActual" DataFormatString="{0:###,###.00}" />--%>                    
                    <%-- Link report revenue --%>
                    <asp:TemplateField HeaderText="Revenue Actual">
                        <ItemTemplate> 
                            <asp:LinkButton ID="LkRevenue"  OnClick="LkRevenue_Click" runat="server" CommandArgument='<%# Eval("Projects_Id") + ";"  + Eval("Activity_Id")  + ";" + Eval("PrimaDataCarico") %> ' CommandName="LkRevenue"><%#  Eval("RevenueActual", "{0:###,###.00}")  %></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField> 
                    
                    <asp:BoundField DataField="SpeseActual" HeaderText="Spese Actual" SortExpression="SpeseActual" DataFormatString="{0:###,###.00}" />

                    <%-- <asp:BoundField DataField="PName" HeaderText="Progetto" SortExpression="PName" />--%>                    
                    <%-- Link anagrafica progetto --%>
                    <asp:TemplateField HeaderText="Progetto">
                        <ItemTemplate> 
                            <asp:LinkButton ID="LkProgetto"  OnClick="LkProgetto_Click" runat="server" CommandArgument='<%# Eval("ProjectCode") %> ' CommandName="LkProgetto"><%#  Eval("PName")  %></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                    
                    <%--<asp:BoundField DataField="AName" HeaderText="Attività" SortExpression="AName" />--%>
                     <%-- Link anagrafica attività --%>
                    <asp:TemplateField HeaderText="Attività">
                        <ItemTemplate> 
                            <asp:LinkButton ID="LkAttivita"  OnClick="LkAttivita_Click" runat="server" CommandArgument='<%# Eval("Activity_id")  + ";" + Eval("Phase_Id") + ";" + Eval("Projects_Id") %> ' CommandName="LkAttivita"><%#  Eval("AName")  %></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField> 

                    <asp:BoundField DataField="MName" HeaderText="Manager" SortExpression="MName" />
                    <asp:BoundField DataField="PrimaDataCarico" HeaderText="Data Inizio" SortExpression="PrimaDataCarico" dataformatstring="{0:d}" />
                    <asp:TemplateField HeaderText="DataFine">
                         <ItemTemplate> 
                             <asp:label ID="DataFine" runat="server" Text=<%# Eval("DataFine", "{0:d}") %> tooltip='<%# Eval("TooltipDataFine")%>'  BackColor  = '<%# System.Drawing.Color.FromName(Eval("ColoreDataFine").ToString()) %>'  > </asp:label>   
<%--                        <asp:BoundField DataField="DataFine" HeaderText="Data Fine" SortExpression="DataFine" dataformatstring="{0:d}"  ItemStyle-BackColor=<%# Eval("ColoreDataFine") %> />--%>
                         </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="RevenueBudget" HeaderText="Budget Revenue" SortExpression="RevenueBudget" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="BudgetABAP" HeaderText="Budget ABAP" SortExpression="BudgetABAP" DataFormatString="{0:###,###.00}" />                    
                    <asp:BoundField DataField="BudgetNetto" HeaderText="Budget Netto" SortExpression="BudgetNetto" DataFormatString="{0:###,###.00}" /> 
                    <asp:BoundField DataField="SpeseBudget" HeaderText="Budget Spese" SortExpression="SpeseBudget" DataFormatString="{0:###,###.00}" />
                    <asp:BoundField DataField="MargineBudget" HeaderText="Margine budget" SortExpression="MargineBudget" dataformatstring="{0:P1}"/>
                    <asp:BoundField DataField="BurnRate" HeaderText="Burn Rate" SortExpression="BurnRate" DataFormatString="{0:###,###.00}" />

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
        <div  id="WindowFooter-L"> Aeonvis Spa      <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 

</body>
</html>
