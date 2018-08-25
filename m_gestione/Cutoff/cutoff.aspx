<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cutoff.aspx.cs" Inherits="Templates_TemplateForm"   %>

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
    <title> <asp:Literal runat="server" Text="Cutoff" /> </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap">

    <form id="form" runat="server" class="standardform" enableviewstate="True" >

        <div class="formtitle"><asp:Literal runat="server" Text="Cutoff" /> </div> 

        <asp:FormView ID="FVMain" runat="server" DataSourceID="dsOptions" CssClass="StandardForm" width="100%" DefaultMode="Edit" >
            <EditItemTemplate>

<%--        <!-- *** Periodo ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Periodo" meta:resourcekey="Label1Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="periodo" runat="server" MaxLength="10" Text='<%# Bind("cutoffPeriod") %>'    />
        </div>--%>

        <!-- *** Periodo ***  -->
        <div class="input nobottomborder">                        
	                <div class="inputtext">Periodo:</div>  
                    <div class="InputcontentDDL"  >
                        <asp:DropDownList runat="server" ID="DDLPeriodo"  DataValueField="cutoffPeriod"  SelectedValue='<%# Bind("cutoffPeriod") %>'  >
                        <asp:ListItem Text="15 del mese" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Fine Mese" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
        </div>  

        <!-- *** Mese ***  -->
        <div class="input nobottomborder">                        
	                <div class="inputtext">Mese:</div>  
                    <div class="InputcontentDDL"  >
                        <asp:DropDownList runat="server" ID="DDLMese"  DataValueField="cutoffMonth" SelectedValue='<%# Bind("cutoffMonth")%>'   >
                        <asp:ListItem Text="Gennaio" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Febbraio" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Marzo" Value="3"></asp:ListItem>
                        <asp:ListItem Text="Aprile" Value="4"></asp:ListItem>
                        <asp:ListItem Text="Maggio" Value="5"></asp:ListItem>
                        <asp:ListItem Text="Giugno" Value="6"></asp:ListItem>
                        <asp:ListItem Text="Luglio" Value="7"></asp:ListItem>
                        <asp:ListItem Text="Agosto" Value="8"></asp:ListItem>
                        <asp:ListItem Text="Settembre" Value="9"></asp:ListItem>
                        <asp:ListItem Text="Ottobre" Value="10"></asp:ListItem>
                        <asp:ListItem Text="Novembre" Value="11"></asp:ListItem>
                        <asp:ListItem Text="Dicembre" Value="12"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
        </div>

        <!-- *** Anno ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Anno" meta:resourcekey="Label3Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBAnno" runat="server" MaxLength="10" Text='<%# Bind("cutoffYear") %>'   />
        </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <asp:Button ID="InsertButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" /> 
            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click"   />                    
        </div>

       </EditItemTemplate>

        </asp:FormView>
 
    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa       <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 

<asp:sqldatasource runat="server" ID="dsOptions" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
    SelectCommand="SELECT * FROM [Options]"
    UpdateCommand="UPDATE Options SET cutoffPeriod=@cutoffPeriod, cutoffMonth=@cutoffMonth, cutoffYear=@cutoffYear " 
    OnUpdated="dsOptions_Updated" >

 <UpdateParameters>
            <asp:Parameter Name="cutoffPeriod" Type="Int32" />
            <asp:Parameter Name="cutoffMonth" Type="Int32" />
            <asp:Parameter Name="cutoffYear" Type="Int32" />  
 </UpdateParameters>

</asp:sqldatasource>

</body>
</html>


 


