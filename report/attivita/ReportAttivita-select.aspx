<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportAttivita-select.aspx.cs" trace="false" Inherits="report_esportaAttivita" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Esporta</title>
    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

    </head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>    
    
<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap"  >
 
    <form id="form1" runat="server"  class="StandardForm">    
   
    
    <div class="formtitle" >Report</div>                  

    <div class="input nobottomborder">
          <div class="inputtext">Progetto</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLProgetti" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" 
                   onselectedindexchanged="DDLProgetti_SelectedIndexChanged" >            
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>
                    </asp:DropDownList>
          </div>
    </div>  

    <div class="input nobottomborder">
          <div class="inputtext">Fasi</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLFasi" runat="server"  
                   AppendDataBoundItems="True" AutoPostBack="True" 
                   onselectedindexchanged="DDLFasi_SelectedIndexChanged"  >
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>  
                    </asp:DropDownList>
          </div>
    </div> 

     <div class="input ">
          <div class="inputtext">Attività</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLAttivita" runat="server"  
                        AppendDataBoundItems="True" AutoPostBack="True"  >
                    <asp:ListItem  Value="" Text="Selezionare un valore"/>                            
                    </asp:DropDownList>
          </div>
    </div> 

    <!-- *** Valore & storno***  -->
    <div class="input nobottomborder">
        <div class="inputtext">Dalla data</div>
        <div class="InputcontentDDL" style="float:left;width:150px"><asp:DropDownList runat="server" id="DDLFromMonth"> </asp:DropDownList></div>
                  
        <span class="InputcontentDDL" style="position:relative;left:30px;float:left;width:100px">
            <asp:DropDownList  runat="server" id="DDLFromYear"></asp:DropDownList>          
        </span>
    </div>  

    <div class="input">
        <div class="inputtext">Alla data</div>
        <div class="InputcontentDDL" style="float:left;width:150px"><asp:DropDownList  runat="server" ID="DDLToMonth"></asp:DropDownList></div>      
        <span class="InputcontentDDL" style="position:relative;left:30px;float:left;width:100px">
            <asp:DropDownList   runat="server" ID="DDLToYear"> </asp:DropDownList>         
        </span>
    </div>  

    <div class="input nobottomborder">
         <div class="inputtext">Estrazione</div>
         <div class="Inputcontent">
                    <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1" >
                        <asp:ListItem Selected="True" Value="1">Totali attività</asp:ListItem>
                        <asp:ListItem Value="2">Dettaglio Persone</asp:ListItem>
                    </asp:RadioButtonList>
    </div>     
    </div>
                            
    <div class="buttons">        
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" OnClick="sottometti_Click"  />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>
    
    </div> <%-- END FormWrap  --%> 

    </form>

    </div> <!-- END MainWindow -->
    
    <!-- **** FOOTER **** -->  
   <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 

</body>
</html>

