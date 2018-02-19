<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Revenue-select.aspx.cs" trace="false" Inherits="report_esportaAttivita" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

     <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>  
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>   
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script> 

<head id="Head1" runat="server">
    <title>Controllo Progetto</title>
    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

    </head>

    <script>
        $(function () {

            // validation summary su validator custom
            displayAlert();

            // datepicker
            $("#TBDataReport").datepicker($.datepicker.regional['it']);

        });
</script>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>    
    
<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap"  >
 
    <form id="form1" runat="server"  class="StandardForm">    
   
    
    <div class="formtitle" >Controllo Progetto</div>                  

    <!--  *** PROGETTO *** -->            
    <div class="input nobottomborder">
          <div class="inputtext">Progetto</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLProgetti" runat="server" 
                        AppendDataBoundItems="True" AutoPostBack="True" OnSelectedIndexChanged="DDLProgetti_SelectedIndexChanged"  >        
                    </asp:DropDownList>
          </div>
    </div>  

    <!--  *** ATTIVITA' *** -->            
    <div class="input nobottomborder ">
          <div class="inputtext">Attività</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLAttivita" runat="server"  
                        AppendDataBoundItems="True" AutoPostBack="True"  >                         
                    </asp:DropDownList>
          </div>
    </div> 

    <!--  *** MANAGER *** -->            
    <div class="input ">
          <div class="inputtext">Manager</div>   
          <div class="InputcontentDDL">
               <asp:DropDownList ID="DDLManager" runat="server" DataTextField="Name" DataValueField="Persons_id"
                        AppendDataBoundItems="True" AutoPostBack="True" OnDataBound="DDLManager_DataBound" DataSourceID="DS_Persone"> 
                   <asp:ListItem Value="0">-- tutti i manager --</asp:ListItem>                        
                    </asp:DropDownList>
          </div>
    </div> 

    <!--  **** DATA REPORT ** -->
    <div class="input nobottomborder">
        <asp:Label ID="Label5" CssClass="inputtext" runat="server"  Text="Data Report:"></asp:Label>
        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data fine" ID="TBDataReport"   runat="server"  MaxLength="10" Rows="12" Columns="10" />
 <%--       <asp:RangeValidator ID="RangeValidator1" runat="server" ControlToValidate="TBDataReport" Display="none" ErrorMessage="Formato data inizio progetto non corretto" MaximumValue="31/12/9999" MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>--%>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Inserire data report" ControlToValidate="TBDataReport" Display="none"></asp:RequiredFieldValidator>
    </div> 
                            
    <div class="buttons">        
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" CommandName="download" OnClick="sottometti_Click"  />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>
    
    </div> <%-- END FormWrap  --%> 

    <asp:ValidationSummary ID="VSValidator" runat="server" ShowMessageBox="True" ShowSummary="false"  />

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

</body>
</html>

