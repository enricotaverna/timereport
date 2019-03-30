<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ricevute_select_user.aspx.cs" Inherits="report_ricevute_ricevute_select"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" NoExpenses=<%= Session["NoExpenses"]%> Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>

    <style type="text/css">
        .cella {

            width: 150px;
            text-align: center;
            color: #C0C0C0
        }
        .grande {
            width: 150px;
        }
        .piccolo {
            width: 30px;
        }
    </style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title><asp:Literal runat="server" Text="<%$ Resources:PageResource1.Title%>" /></title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" style="width:200px" Class="StandardForm" >

    <form id="NOME_FORM" runat="server" >

        <div class="formtitle">
                    
            <table>
                <tr>                    
                    <td> <asp:HyperLink ID="btPrev"  style="text-align:center" class='bottone_lista piccolo' runat="server" meta:resourcekey="btPrevResource1" Text="&lt;&lt;"></asp:HyperLink></td>
                    <td style="width:110px ;text-align:center"><asp:Label ID="AnnoCorrente" runat="server" meta:resourcekey="AnnoCorrenteResource1"></asp:Label></td>
                    <td> <asp:HyperLink ID="btNext"  style="text-align:center" class='bottone_lista piccolo' runat="server" meta:resourcekey="btNextResource1" Text="&gt;&gt;"></asp:HyperLink></td>
                </tr>

            </table>
                
        </div> 

        <br />

        <table runat="server" id="TabellaMesi" style="margin: 0 auto;">

        </table>

        <br />

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport, CANCEL_TXT%>" meta:resourcekey="CancelButtonResource1"    />                    
        </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa  <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>    
    </div> 

</body>
</html>