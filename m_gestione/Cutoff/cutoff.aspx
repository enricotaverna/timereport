<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cutoff.aspx.cs" Inherits="Templates_TemplateForm"   %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> <asp:Literal runat="server" Text="Cutoff" /> </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap">

    <form id="cutoffForm" runat="server" class="standardform" enableviewstate="True" >

        <div class="formtitle"><asp:Literal runat="server" Text="Cutoff" /> </div> 

        <asp:FormView ID="FVMain" runat="server" DataSourceID="dsOptions" CssClass="StandardForm" width="100%" DefaultMode="Edit" >
            <EditItemTemplate>

        <!-- *** Periodo ***  -->
        <div class="input nobottomborder">                        
	                <div class="inputtext">Periodo:</div>  
                    <label class="dropdown"  >
                        <asp:DropDownList runat="server" ID="DDLPeriodo"  DataValueField="cutoffPeriod"  SelectedValue='<%# Bind("cutoffPeriod") %>'  >
                        <asp:ListItem Text="15 del mese" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Fine Mese" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </label>
        </div>  

        <!-- *** Mese ***  -->
        <div class="input nobottomborder">                        
	                <div class="inputtext">Mese:</div>  
                    <label class="dropdown"  >
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
                    </label>
        </div>

        <!-- *** Anno ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Anno" meta:resourcekey="Label3Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBAnno" runat="server" MaxLength="5" Text='<%# Bind("cutoffYear") %>'  
                         data-parsley-required="true" data-parsley-errors-container="#valMsg" data-parsley-type="integer" data-parsley-min="2018" Columns="5" />
        </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
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

<script type="text/javascript">

// *** Esclude i controlli nascosti *** 
   $('#cutoffForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
   });

</script>

</body>

</html>


 


