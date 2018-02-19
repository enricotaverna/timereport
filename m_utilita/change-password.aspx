<%@ Page Language="C#" AutoEventWireup="true" CodeFile="change-password.aspx.cs" Inherits="Templates_TemplateForm"   %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script>

<script>

    // JQUERY
    $(function () {

        // gestione validation summary su validator custom (richiede timereport.js)//
        displayAlert();

    });

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /> </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap">

    <form id="FVMain" runat="server" class="standardform" >

        <div class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:titolo%>" /> </div> 

        <!-- *** OLD PWD ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Vecchia Password" meta:resourcekey="Label1Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBOldPwd" runat="server" MaxLength="10" meta:resourcekey="TBOldPwdResource1" />
        </div>

        <!-- *** NEW PWD1 ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Nuova Password" meta:resourcekey="Label2Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd1" runat="server" MaxLength="10" meta:resourcekey="TBNewPwd1Resource1" />
        </div>

        <!-- *** NEW PWD2 ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Conferma Pwd" meta:resourcekey="Label3Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd2" runat="server" MaxLength="10" meta:resourcekey="TBNewPwd2Resource1" />
        </div>

       <div class="input nobottomborder">
                <asp:Literal runat="server" Text="<%$ Resources:testohelp%>" />
         </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" OnClick="InsertButton_Click" meta:resourcekey="InsertButtonResource1"       /> 
            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" meta:resourcekey="UpdateCancelButtonResource1"    />                    
        </div>
 
        <!-- **** VALIDAZIONI **** -->  
        <asp:CustomValidator ID="CV_OldPwd" runat="server" 
        OnServerValidate="ValidaOldPwd" Display="None" 
        ErrorMessage="Vecchia password non corrisponde" ControlToValidate="TBOldPwd" ValidateEmptyText="True" SetFocusOnError="True" meta:resourcekey="CV_OldPwdResource1"></asp:CustomValidator>    

        <!-- **** VALIDAZIONI **** -->  
        <asp:CustomValidator ID="CV_NewPwd" runat="server" 
        OnServerValidate="ValidaNewPwd" Display="None" 
        ControlToValidate="TBNewPwd1" ValidateEmptyText="True" SetFocusOnError="True" meta:resourcekey="CV_NewPwdResource1"></asp:CustomValidator> 
        
        <asp:ValidationSummary ID="ValidationSummary" runat="server" ShowMessageBox="True" ShowSummary="False" meta:resourcekey="ValidationSummaryResource1" />

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa    <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>    
    </div> 



</body>
</html>


 

