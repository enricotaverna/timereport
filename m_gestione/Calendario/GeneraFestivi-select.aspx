<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GeneraFestivi-select.aspx.cs" trace="false" Inherits="calendario_generaFestivi" EnableViewState="True" %>

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
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script> 

<head id="Head1" runat="server">
    <title>Esporta</title>
</head>
 
<style type="text/css">
    .SumoSelect{width:280px;}
</style>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="StandardForm" >
 
    <form id="FormCalendario" runat="server">       
    
    <div class="formtitle" >Genera Record Festivi</div>                  

    <!--  *** PERSONE *** -->     
    <div class="input nobottomborder ">
    <span style="position:absolute"> 

          <div class="inputtext"  >Persone</div>   

          <span> 
          <asp:Listbox class="select2-auth" ID="LBPersone" data-parsley-required="true" data-parsley-errors-container="#valMsg" SelectionMode="Multiple" multiple="multiple"  runat="server" AppendDataBoundItems="True" DataSourceID="DS_Persone" DataTextField="Name" DataValueField="Persons_id" OnDataBound="LBPersone_DataBinding"   >        
          </asp:Listbox></span>

    </span>  
    </div>

    <!-- *** spazio bianco nel form ***  -->
    <p style="margin-bottom: 50px;"></p>
    
        <!--  *** LIVELLO  *** -->     
    <div class="input nobottomborder ">
    <span style="position:absolute"> 

          <div class="inputtext">Tipo utente</div>   

          <span> 
          <asp:Listbox class="select2-auth" ID="LBLivello" data-parsley-required="true" data-parsley-errors-container="#valMsg" SelectionMode="Multiple" multiple="multiple"  runat="server" AppendDataBoundItems="True" DataSourceID="DSLivello" DataTextField="Name" DataValueField="UserLevel_id" OnDataBound="LBLivello_DataBinding"   >        
          </asp:Listbox></span>

    </span>  </div>

    <!-- *** spazio bianco nel form ***  -->
    <p style="margin-bottom: 50px;"></p>

    <!--  *** MESE *** -->            
    <div class="input nobottomborder ">
          <div class="inputtext">Mese</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLMese" AppendDataBoundItems="True" runat="server" >
               </asp:DropDownList>
          </label>
    </div> 

    <!--  *** ANNO *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Anno</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True" > 
                    </asp:DropDownList>
          </label>
    </div> 
                          
    <div class="buttons">     
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="report" runat="server" Text="genera record" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" formnovalidate="" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>
    
    </form>

    </div> <%-- END FormWrap  --%> 

    </div> <!-- END MainWindow -->
    
    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 
    
-    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"        
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons WHERE Persons.Active = 'true' ORDER BY Persons.Name" >        
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="DSLivello" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"        
        SelectCommand="SELECT UserLevel_id, Name FROM AuthUserLevel ORDER BY UserLevel_id" >        
    </asp:SqlDataSource>

<script type="text/javascript">

        // *** Esclude i controlli nascosti *** 
        $('#FormEstrai').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        $(document).ready(function () {
            
        // imposta css della listbox
            $('.select2-auth').SumoSelect({ okCancelInMulti: true, selectAll: true , search: true, searchText: 'Enter here.'});
        });

        // a validazione avvenuta disabilita lo schermo e cambia il cursore in wait
        $('#FormCalendario').parsley().on('form:success', function() {

            //Get the screen height and width
            var maskHeight = $(document).height();
            var maskWidth = $(window).width();

            //Set heigth and width to mask to fill up the whole screen
            $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

            //transition effect		
            //$('#mask').fadeIn(200);
            $('#mask').fadeTo("fast", 0.5);


            document.body.style.cursor = 'wait';
                //$("body").css("cursor", "progress");

        });

</script>

</body>

</html>

