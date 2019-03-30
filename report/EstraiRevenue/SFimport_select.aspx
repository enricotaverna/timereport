<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SFimport_select.aspx.cs" trace="false" Inherits="SFimport_select" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/jquery/fileupload/jquery-filestyle.css" rel="stylesheet" />
    
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script> 
<script src="/timereport/include/jquery/fileupload/jquery-filestyle.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script> 


<head id="Head1" runat="server">
    <title>Import Sales Force</title>
</head>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="StandardForm"  enctype="multipart/form-data">
 
    <form id="FVForm" runat="server"  >     
      
    <div  class="formtitle">Import Sales Force</div>              

    <!--  *** VERSIONE *** -->            
    <br />
         
    <div class="input nobottomborder">
          <div class="inputtext">File</div>   
          <asp:FileUpload  ID="FileUpload" runat="server" class="jfilestyle"  data-text="seleziona" data-inputSize="160px" accept=".xls" 
                           data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-error-message="Specificare un nome file"/> 
    </div>
    
    <!--  *** Tipo controllo *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Tipo controllo</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLImport" runat="server" 
                        AppendDataBoundItems="True"  > 
                   <asp:ListItem Value="0">tutti i progetti esportati</asp:ListItem> 
                   <asp:ListItem Value="1">progetti con carichi nel mese corrente</asp:ListItem>         
                   <asp:ListItem Value="2">progetti con carichi nel mese precedente</asp:ListItem>         
                    </asp:DropDownList>
          </label>
    </div>

    <br />

    <div class="buttons">  
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton"  CommandName="Exec" OnClick="Sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 

    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
   <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 

    <script type="text/javascript">

        $(function () {
           // reset cursore e finestra modale
            UnMaskScreen();
        });

         $('#BtExec').click(function(e) {

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            MaskScreen(true);
        });

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

</script>

</body>
</html>

