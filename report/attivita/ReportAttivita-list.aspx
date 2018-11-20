<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportAttivita-list.aspx.cs" Inherits="report_ReportAttivita" %>

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
    <title> Report Attività </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="NOME_FORM" runat="server" CssClass="StandardForm" >
    
    <div id="PanelWrap">  

   <asp:GridView ID="GVAttivita" runat="server" AllowPaging="True"  CssClass="GridView" 
            AllowSorting="True" PageSize="15">
            <FooterStyle CssClass="GV_footer" />
            <RowStyle Wrap="False" CssClass="GV_row" />
            <PagerStyle CssClass="GV_footer" />
            <HeaderStyle CssClass="GV_header" />
             <AlternatingRowStyle CssClass="GV_row_alt " />
    </asp:GridView>

    <div class="buttons">        
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                     
    </div>

    </div> <%-- END PanelWrap  --%> 

    </form>
    
    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 

</body>
</html>
