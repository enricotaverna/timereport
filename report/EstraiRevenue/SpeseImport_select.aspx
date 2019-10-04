<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SpeseImport_select.aspx.cs" trace="false" Inherits="SFimport_select" %>

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
    <title>Import Revenue Spese</title>
</head>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="StandardForm"  enctype="multipart/form-data">
 
    <form id="FVForm" runat="server"  >     
      
    <div  class="formtitle">Import Revenue Spese</div>              

    <!--  *** FILE  *** -->            
    <br />
         
    <div class="input nobottomborder">
          <div class="inputtext">File (.xls)</div>   
          <asp:FileUpload  ID="FileUpload" runat="server" class="jfilestyle"  data-text="seleziona" data-inputSize="160px" accept=".xls" 
                           data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="" data-parsley-obbligofile="true" /> 
    </div>

    <div class="input nobottomborder">

          <!-- *** Checkboc Storno ***  -->
          <div class="inputtext"></div>   
          <asp:CheckBox ID="CBSkipFirstRow" runat="server" Checked="True" />
          <asp:Label AssociatedControlID="CBSkipFirstRow" runat="server" Text="intestazioni su prima riga"></asp:Label> 
    </div>
    
    <!--  *** PERIODO / VERSIONE *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Periodo</div>   

          <label class="dropdown" style="margin-right:35px">
                <asp:DropDownList ID="DDLAnnoMese" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataTextField="AnnoMeseDesc" DataValueField="AnnoMese" style="width:120px"
                    CssClass="TabellaLista"  >
                </asp:DropDownList>
          </label>

         <label class="dropdown" >
                <asp:DropDownList ID="DDLRevenueVersion" runat="server" AutoPostBack="True" 
                    DataSourceID="DSRevenueVersion" DataTextField="RevenueVersionDescription"  DataValueField="RevenueVersionCode" style="width:120px"
                    CssClass="TabellaLista"  >
                </asp:DropDownList>
         </label>

    </div>

    <!--  *** AZIONE *** -->            
    <div class="input nobottomborder">
         <div class="inputtext">Azione</div>
                    <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1" data-parsley-obbligofile="true" data-parsley-mandatory>
                        <asp:ListItem Selected="True" Value="1">Upload</asp:ListItem>
                        <asp:ListItem Value="2">Cancella Revenue Spese</asp:ListItem>
                    </asp:RadioButtonList>
    </div>


    <br />

    <div class="buttons">  
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton"  CommandName="Exec" OnClick="Sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/menu.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
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

        $(document).ready(function () {
            UnMaskScreen(); // reset cursore e finestra modale

            $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET
        })

        // BOTTONE CANCELLA
        $('#BtExec').click(function (e) {

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            MaskScreen(true);

            if ($("#RBTipoReport_1").prop('checked') ) { // cancellazione record
                $.ajax({

                    type: "POST",
                    url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/DeleteRevenueProgetti",
                    data: "{ AnnoMese: '" + $("#DDLAnnoMese").val() + "', RevenueVersionCode:'" + $("#DDLRevenueVersion").val() + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true)
                            ShowPopup("Cancellazione completata");
                        else
                            ShowPopup("Errore in aggiornamento");

                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore in aggiornamento");
                        return false;
                    }

                }); // ajax

                e.preventDefault(); // evita postback
                UnMaskScreen();
            }

        });

        // *** controllo che non esista lo stesso codice utente *** //
        window.Parsley.addValidator('obbligofile', function (value, requirement) {
            if ($("#RBTipoReport_0").prop('checked') && $("#FileUpload").val() == "")
                return false
            else
                return true;
            return 0;
        }, 32)
            .addMessage('it', 'obbligofile', 'Selezionare un file');

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

</script>

</body>

<asp:sqldatasource runat="server" ID="DSRevenueVersion"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode+ ' ' + RevenueVersionDescription AS RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode"></asp:sqldatasource>

</html>

