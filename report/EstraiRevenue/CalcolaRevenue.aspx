<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CalcolaRevenue.aspx.cs" trace="false" Inherits="report_esportaAttivita" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
    
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script> 


<head id="Head1" runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Calcola Revenue</title>
</head>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="StandardForm" >
 
    <form id="FVForm" runat="server"  >     
      
    <div  class="formtitle">Calcolo Revenue</div>              

    <!--  *** VERSIONE *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Versione</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLRevenueVersion" runat="server" DataTextField="RevenueVersionDescription" DataValueField="RevenueVersionCode"
                                 data-parsley-errors-container="#valMsg" data-parsley-checkversion="true" 
                                 DataSourceID ="DS_RevenueVersion" style="width:150px"  >                   
                    </asp:DropDownList> 
          </label>
    </div> 
  
    <!--  *** ALLA DATA *** --> 
    <div class="input nobottomborder">
        <div class="inputtext">Dalla data</div>
        <label class="dropdown" >
            <asp:DropDownList style="width:150px" runat="server" id="DDLFromMonth"> </asp:DropDownList>
        </label>
        &nbsp;          
        <label class="dropdown" >
            <asp:DropDownList style="width:100px" runat="server" id="DDLFromYear"></asp:DropDownList>          
        </label>
    </div>  

    <div class="input nobottomborder">
         <div class="inputtext">Azione</div>
                    <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1" >
                        <asp:ListItem Selected="True" Value="1">Calcola Revenue Mese</asp:ListItem>
                        <asp:ListItem Value="2">Cancella Revenue Mese</asp:ListItem>
                    </asp:RadioButtonList>
    </div>
                            
    <div class="buttons">  
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton"  CommandName="Exec" OnClick="sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 

    </div> <!-- END MainWindow -->

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>
    
    <!-- **** FOOTER **** -->  
   <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 


    <script type="text/javascript">

        $(function () {

            // reset cursore e finestra modale
            UnMaskScreen();
        });
      
        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // *** Custom Validator Parsley *** 
        window.Parsley.addValidator('checkversion', function (value, requirement) {

            // controllo che non esista una versione 00 nel mese di calcolo
            var response;
            var dataAjax = "{ RevenueVersionCode: '" + $("#DDLRevenueVersion").val() + "', " +
                " Anno: '" + $("#DDLFromYear").val() + "', " +
                " Mese: '" + $("#DDLFromMonth").val() + "' }";

            if ($("#RBTipoReport_1").prop("checked")) // se cancella va sempre bene
                return true;

            $.ajax({
                url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/CheckVersion", // nome del Web Service
                data: dataAjax,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false, // validazione sincrona
                success: function (data) {
                    response = data.d; // false esiste già versione
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(thrownError);
                }
            });
            return response;
        }, 32)
        .addMessage('it', 'checkversion', 'Esiste già un versione 00 sul mese');

        // al click del bottone disabilita lo schermo e cambia il cursore in wait
        $('#BtExec').click(function(e) {

            //Cancel the link behavior
            //e.preventDefault();

            if (!$('#FVForm').parsley().validate())
                return;

            // maschera lo schermo
            // NB: deve essere definito un elemento <div id="mask"></div> nel corpo del HTML
            MaskScreen(true);
 
        });

</script>

<asp:SqlDataSource ID="DS_RevenueVersion" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"        
       SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode + ' ' + RevenueVersionDescription as RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode" >        
</asp:SqlDataSource>

</body>
</html>

