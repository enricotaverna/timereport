<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AWSClient.aspx.cs" Inherits="m_utilita_AWSClient_AWSClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>    
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> Avvio Instanza AWS </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" style="width: 75%;" Class="StandardForm" >

    <form id="NOME_FORM" runat="server" >

        <div class="formtitle" style="width: 100%;">Avvio ambiente Demo</div> 

       <div class="input nobottomborder">
            <asp:Literal runat="server" Text="L'istanza AWS in questo momento è in stato:" />
       </div>
        
       <div class="input nobottomborder" style="font-size: xx-large; text-align: center;">
            <asp:Label ID="lbStato"  runat="server" ></asp:Label>
       </div>
       
       <div class="input nobottomborder">
             <p>Dopo l'avvio aspettare qualche minuto prima di provare il logon a SAP. <br/>
            Lo shutdown della macchina è schedulato automaticamente per le ore 18:00</>
       </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:LinkButton ID="InsertButton" runat="server" Height="18" width="130px" CssClass="orangebutton" OnClick="InsertButton_Click">
                <asp:Image runat="server" ImageUrl="/timereport/images/icons/16x16/S_COMPLE.gif" style="float:left;"/>
                <asp:Label runat="server" Text="<%$ appSettings: START_TXT %>"  style="margin:0px 0px 20px 10px; float:left;"/>
            </asp:LinkButton>
<%--            <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" style="width:150px" CssClass="orangebutton" Text="<%$ appSettings: START_TXT %>"       /> --%>
            <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
        </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa  <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>      
    </div> 

<script type="text/javascript">

    $(function () {

    // datepicker
    $("#TBFromDate").datepicker($.datepicker.regional['it']);
    $("#TBToDate").datepicker($.datepicker.regional['it']);
 
    // *** attiva validazione campi form
    $('#formLeaveRequest').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
    });

    });
</script>

</body>

</html>