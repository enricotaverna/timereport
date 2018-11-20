<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EstraiRevenue-select.aspx.cs" trace="false" Inherits="report_esportaAttivita" EnableViewState="True" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script> 

<head id="Head1" runat="server">
    <title>Esporta</title>
    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

    </head>
 
<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap"  >
 
    <form id="FormEstrai" runat="server"  class="StandardForm">    
   
    
    <div class="formtitle" >Report Revenue</div>                  

    <!--  *** PROGETTO *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Progetto</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLProgetti" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLProgetti_SelectedIndexChanged"  >        
                    </asp:DropDownList>
          </label>
    </div>  

    <!--  *** ATTIVITA' *** -->            
    <div class="input nobottomborder ">
          <div class="inputtext">Attività</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLAttivita" runat="server"  
                        AppendDataBoundItems="True" AutoPostBack="True"  >                         
                    </asp:DropDownList>
          </label>
    </div> 

    <!--  *** MANAGER *** -->            
    <div class="input ">
          <div class="inputtext">Manager</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLManager" runat="server" DataTextField="Name" DataValueField="Persons_id"
                        AppendDataBoundItems="True" AutoPostBack="True" OnDataBound="DDLManager_DataBound" DataSourceID="DS_Persone"> 
                   <asp:ListItem Value="0">-- tutti i manager --</asp:ListItem>                        
                    </asp:DropDownList>
          </label>
    </div> 

    <!--  **** DATA DA ** -->
    <div class="input nobottomborder">
        <asp:Label ID="Label5" CssClass="inputtext" runat="server"  Text="Data Inizio Estrazione:"></asp:Label>
        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data inizio" ID="TBDataDA"   runat="server"  MaxLength="10" Rows="12" Columns="10" 
                     data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" data-parsley-required="true" />

    </div> 

    <!--  **** DATA A ** -->
    <div class="input nobottomborder">
        <asp:Label ID="Label1" CssClass="inputtext" runat="server"  Text="Data Fine Estrazione:"></asp:Label>
        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data fine" ID="TBDataA"   runat="server"  MaxLength="10" Rows="12" Columns="10" 
                     data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" data-parsley-required="true" />

    </div> 
                            
    <div class="buttons">     
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" formnovalidate="" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>
    
    </div> <%-- END FormWrap  --%> 

    </form>

    </div> <!-- END MainWindow -->
    
    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 
    
-    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"        
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name" >        
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

<script type="text/javascript">
        $(function () {

            // datepicker
            $("#TBDataA").datepicker($.datepicker.regional['it']);
            $("#TBDataDA").datepicker($.datepicker.regional['it']);

        });

        // *** Esclude i controlli nascosti *** 
        $('#FormEstrai').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

</script>

</body>

</html>

