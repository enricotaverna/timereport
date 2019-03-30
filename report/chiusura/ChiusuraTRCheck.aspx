<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChiusuraTRCheck.aspx.cs" Inherits="report_chiusura_ChiusuraTRCheck"   %>
 
<%@ Register Src="/timereport/include/progress.ascx" TagPrefix="asp101" TagName="ProgressBar" %>



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
    <title> Chiusura TimeReport </title>
    <style type="text/css">
        .auto-style1 {
            width: 100%;
        }
    </style>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" style="width:70%;margin-top:25px;" >

    <form id="FVForm" runat="server" Class="StandardForm" >

        <div class="formtitle" style="width:98%"> <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /></div>

        <br />

        <!-- *** ORE ***  -->
        <table class="TabellaLista" >
            <tr>
                <td >
            <asp:Image ID="CheckOreImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckOreImgResource1" Width="25px" />
                </td>
                <td>
            <asp:Label ID="CheckOre" runat="server" Text="Ore Caricate" meta:resourcekey="CheckOreResource1"></asp:Label>
                </td>
                <td>
            <asp101:ProgressBar id="pbarIEesque" runat="server" Style = "IEesque" Width = 100 />
            <asp:Label ID="CheckOrePerc" runat="server" meta:resourcekey="CheckOrePercResource1"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
            <asp:Image ID="CheckTicketImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckTicketImgResource1"  Width="25px"  />
                </td>
                <td>
            <asp:Label ID="CheckTicket" runat="server" Text="Check Ticket" meta:resourcekey="CheckTicketResource1"></asp:Label> </td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>
            <asp:Image ID="CheckSpeseImg" runat="server" ImageAlign="Top" meta:resourcekey="CheckSpeseImgResource1"  Width="25px"  />
                </td>
                <td>
            <asp:Label ID="CheckSpese" runat="server" Text="Check Spese" meta:resourcekey="CheckSpeseResource1"></asp:Label> </td>
                <td>&nbsp;</td>
            </tr>
        </table>

        <br />
        <!-- *** BONUS / TICKET ***  -->

        <br />

        <!-- *** SPESE ***  -->

        <!-- *** BOTTONI ***  -->
        <div class="buttons">            
            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton"  Text="Chiudi TR" meta:resourcekey="InsertButtonResource1" OnClick="InsertButton_Click"    OnClientClick="return CheckIsRepeat();"  /> 
            <asp:Button ID="btStampaRicevute" runat="server" CommandName="Insert" CssClass="orangebutton" Text="Stampa giustificativi" meta:resourcekey="btStampaRicevuteResource1" /> 
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="CancelButtonResource1"    />                    
        </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa  <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>      
    </div> 

<script type="text/javascript">

    var submit = 0; 
    function CheckIsRepeat() {
        if (++submit > 1) {
            return false;
        }
    }

    </script>


</body>
</html>
