<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ricevute_select.aspx.cs" trace="false" Inherits="report_ricevute_select" EnableViewState="True" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

     <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>  
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>   
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script> 

<head id="Head1" runat="server">
    <title>Report Ricevute</title>
    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

    </head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>    
    
<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap"  >
 
    <form id="form1" runat="server"  class="StandardForm">    
   
    
    <div class="formtitle" >Report Ricevute</div>                  

    <!--  *** PERSONA *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Persona</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLPersone" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True"  >        
                    </asp:DropDownList>
          </div>
    </div>  

    <!--  *** SOCIETA *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Società</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLSocieta" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="SQLDSSocieta" DataTextField="Name" DataValueField="Company_id" >        
                        <asp:ListItem Value="" Text="--- Tutte le società ---" />
                    </asp:DropDownList>
          </div>
    </div>  

    <!--  *** PERSONA *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Tipo Spesa</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLTipoSpesa" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" DataSourceID="SQLDSTipoSpesa" DataTextField="NomeSpesa" DataValueField="ExpenseType_Id" >        
                        <asp:ListItem Value="" Text="--- Tutte le spese ---" />     
               </asp:DropDownList>
          </div>
    </div>  
       
    <!--  *** MESE *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Mese</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLMesi" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLMesi_SelectedIndexChanged"    >        
                    </asp:DropDownList>
          </div>
    </div>  

    <!--  *** ANNO *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Anno</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLAnni" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLAnni_SelectedIndexChanged"  >        
                    </asp:DropDownList>
          </div>
    </div>  
                            
    <div class="buttons">        
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
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
      
</body>
</html>

 <asp:SqlDataSource ID="SQLDSSocieta" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Name, Company_id FROM Company ORDER BY Name"></asp:SqlDataSource>
     <asp:SqlDataSource ID="SQLDSPersona" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT [Persons_id], [Name] FROM [Persons] WHERE ([Active] = 1) ORDER BY [Name]"></asp:SqlDataSource>
 <asp:sqldatasource runat="server" ID="SQLDSTipoSpesa" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ExpenseType_Id, ExpenseCode + ' ' + Name AS NomeSpesa FROM ExpenseType ORDER BY ExpenseCode"  ></asp:sqldatasource>
