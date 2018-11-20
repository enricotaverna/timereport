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

    <div id="FormWrap" class="StandardForm" >
 
    <form id="form1" runat="server"  >     
      
    <div  class="formtitle">Report</div>              

    <div class="input nobottomborder">
          <div class="inputtext">Progetto</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLProgetti" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" 
                   onselectedindexchanged="DDLProgetti_SelectedIndexChanged" >            
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>
                    </asp:DropDownList>
          </label>
    </div>  

    <div class="input nobottomborder">
          <div class="inputtext">Fasi</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLFasi" runat="server"  
                   AppendDataBoundItems="True" AutoPostBack="True" 
                   onselectedindexchanged="DDLFasi_SelectedIndexChanged"  >
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>  
                    </asp:DropDownList>
          </label>
    </div> 

     <div class="input ">
          <div class="inputtext">Attività</div>   
          <label class="dropdown">
               <asp:DropDownList ID="DDLAttivita" runat="server"  
                        AppendDataBoundItems="True" AutoPostBack="True"  >
                    <asp:ListItem  Value="" Text="Selezionare un valore"/>                            
                    </asp:DropDownList>
          </label>
    </div> 

    <!-- *** Valore & storno***  -->
    <div class="input nobottomborder">
        <div class="inputtext">Dalla data</div>
        <label class="dropdown" >
            <asp:DropDownList style="width:150px" runat="server" id="DDLFromMonth"> </asp:DropDownList>
        </label>
                  
        <label class="dropdown" >
            <asp:DropDownList style="width:100px" runat="server" id="DDLFromYear"></asp:DropDownList>          
        </label>
    </div>  

    <div class="input">
        <div class="inputtext">Alla data</div>
        <label class="dropdown" ><asp:DropDownList style="width:150px" runat="server" ID="DDLToMonth"></asp:DropDownList></label>      
        <label class="dropdown" >
            <asp:DropDownList style="width:100px" runat="server" ID="DDLToYear"> </asp:DropDownList>         
        </label>
    </div>  

    <div class="input nobottomborder">
         <div class="inputtext">Estrazione</div>
                    <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="1" >
                        <asp:ListItem Selected="True" Value="1">Totali attività</asp:ListItem>
                        <asp:ListItem Value="2">Dettaglio Persone</asp:ListItem>
                    </asp:RadioButtonList>
    </div>
                            
    <div class="buttons">        
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" OnClick="sottometti_Click"  />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>

    </form>
    
    </div> <%-- END FormWrap  --%> 

    </div> <!-- END MainWindow -->
    
    <!-- **** FOOTER **** -->  
   <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 

</body>
</html>

