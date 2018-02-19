<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TemplateForm.aspx.cs" Inherits="Templates_TemplateForm" %>

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
<script src="/timereport/include/javascript/timereport.js"></script>

<script>

    // JQUERY

    // gestione validation summary su validator custom (richiede timereport.js)//
    $(function () {
        // gestione validation summary su validator custom (richiede timereport.js)//
        displayAlert();
    });

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> TITOLO_PAGINA </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap">

    <form id="NOME_FORM" runat="server" Class="StandardForm" >

        <div class="formtitle">TITOLO_FORM</div> 

        <!-- *** TEXT_BOX ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBNOME_CONTROLLO" runat="server" Text='<%# Bind("XXXXX") %>' />
        </div>

        <!-- *** DDL XXXX ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label8" runat="server" Text="*** TESTO_SELEZIONE ***"></asp:Label>
            <div class="InputcontentDDL">
                <asp:DropDownList ID="DDLNOME_CONTROLLO" runat="server" AppendDataBoundItems="True" AutoPostBack="true" >
                <asp:ListItem Value="">-- seleziona un valore --</asp:ListItem>
                </asp:DropDownList>
            </div>      
        </div>

        <!-- *** TEXTBOX MULTILINE ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="CommentTextBox" runat="server" Text="NOME_NOTA"></asp:Label>
            <asp:TextBox ID="TBNOME_CONTROLLO1" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("XXXXX") %>' TextMode="MultiLine" Columns="30" Enabled="False" />
        </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"      /> 
            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>"  OnClick="UpdateCancelButton_Click"   />                    
        </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>      
    </div> 

</body>
</html>
