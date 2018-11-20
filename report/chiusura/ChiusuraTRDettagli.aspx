<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChiusuraTRDettagli.aspx.cs" Inherits="Templates_TemplateForm" %>

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
<script src="/timereport/include/javascript/timereport.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> Dettagli Anomalie Chiusura </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="PanelWrap">

    <form id="NOME_FORM" runat="server"  >
       
        <!-- *** GRID ***  -->
        <asp:GridView ID="GV_anomalie" runat="server" CssClass="TabellaLista" GridLines="None" >
            <HeaderStyle CssClass="GV_header" />
            <FooterStyle CssClass="GV_footer" />
            <RowStyle CssClass="GV_row" />
            <AlternatingRowStyle CssClass="GV_row_alt"/>
        </asp:GridView>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" OnClientClick="JavaScript:window.history.back(1);return false;" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
        </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa    <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>      
    </div> 

</body>
</html>
