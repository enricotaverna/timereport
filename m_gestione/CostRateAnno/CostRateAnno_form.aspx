<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRateAnno_form.aspx.cs"
    Inherits="CostRateAnno_lookup_form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>    
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dettagli Attività</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" >

    <form id="form1" runat="server">

         <!-- *** TITOLO FORM ***  -->
         <div class="formtitle">Aggiorna Cost Rate</div> 

        <asp:FormView ID="FVForm" runat="server" DataKeyNames="PersonsCostRate_id" DataSourceID="DSPersonCostRate"
            EnableModelValidation="True"  DefaultMode="Insert"  
                 class="StandardForm"
            OnItemUpdated="FVForm_ItemUpdated" OnModeChanging="ItemModeChanging_FVForm" width="100%" OnItemInserted="FVForm_ItemInserted">

            <EditItemTemplate>

            <!-- *** PERSONA ***  -->
	            <div class="input">                        
	                <div class="inputtext">Persona:</div>  
                    <label class="dropdown" style="width:265px" >
                                <asp:DropDownList ID="DDLPersona" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSpersone" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>' >
                                <asp:ListItem Value="">-- seleziona persona --</asp:ListItem>
                                </asp:DropDownList>                    
                    </label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" Display="none" runat="server" ErrorMessage="Inserisci persona" ControlToValidate="DDLPersona"></asp:RequiredFieldValidator>
                </div>

            <!-- *** ANNO ***  -->
	            <div class="input">                        
	                <div class="inputtext">Anno:</div>  
                    <label class="dropdown"  >
                                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("Anno") %>' OnDataBinding="DDLAnno_DataBinding" style="width:150px" >
                                </asp:DropDownList>                    
                    </label>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="none" runat="server" ErrorMessage="Inserisci anno" ControlToValidate="DDLAnno"></asp:RequiredFieldValidator>
                </div>

            <!-- *** COST RATE ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="FLC:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBCostRate" runat="server"  style="width:140px" Text='<%# Bind("CostRate") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="none" runat="server" ErrorMessage="Inserisci cost rate" ControlToValidate="TBCostRate"></asp:RequiredFieldValidator>
                </div>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
                                ControlToValidate="TBCostRate" Display="None"
                                ErrorMessage="Inserire un valore numerico"
                                ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)">
                </asp:RegularExpressionValidator>

               <!-- *** COMMENT ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Nota"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBComment" runat="server" Text='<%# Bind("Comment") %>' Columns="32" MaxLength="40" />
                </div>
                     
                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CssClass="orangebutton" CommandName="Insert"  Text="<%$ appSettings: SAVE_TXT %>"/>
                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel"  Text="<%$ appSettings: CANCEL_TXT %>" />             
                </div>  

            </EditItemTemplate>

            <ItemTemplate>

            <!-- *** PERSONA ***  -->
	            <div class="input">                        
	                <div class="inputtext">Persona:</div>  
                    <label class="dropdown" style="width:265px" >
                                <asp:DropDownList ID="DDLPersona" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSpersone" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>' Enabled="False">
                                <asp:ListItem Value="">-- seleziona persona --</asp:ListItem>
                                </asp:DropDownList>                    
                    </label>
                 </div>

            <!-- *** ANNO ***  -->
	            <div class="input">                        
	                <div class="inputtext">Anno:</div>  
                    <label class="dropdown" style="width:150px" >
                                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("Anno") %>' OnDataBinding="DDLAnno_DataBinding" Enabled="False">
                                </asp:DropDownList>                    
                    </label>
                 </div>

            <!-- *** COST RATE ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="FLC:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBCostRate" runat="server"  style="width:140px" Text='<%# Bind("CostRate") %>' Enabled="False" />
                </div>

                <!-- *** COMMENT ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Nota"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBComment" runat="server" Text='<%# Bind("Comment") %>' Columns="32" MaxLength="40" />
                </div>
 

                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel"  Text="<%$ appSettings: CANCEL_TXT %>" />             
                </div>  

            </ItemTemplate>
                    
      </asp:FormView>

       <asp:ValidationSummary ID="VSValidator" runat="server" ShowMessageBox="True" ShowSummary="false"  />
 
    </form>

   </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div>  
 
    <asp:SqlDataSource ID="DSPersonCostRate" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [PersonsCostRate] WHERE PersonsCostRate_id = @PersonsCostRate_id" 
        UpdateCommand="UPDATE [PersonsCostRate] SET [Persons_id] = @Persons_id, [Anno] = @Anno, [CostRate] = @CostRate, [Comment] = @Comment  WHERE [PersonsCostRate_id] = @PersonsCostRate_id"        >
        <SelectParameters>
            <asp:QueryStringParameter  Name="PersonsCostRate_id" QueryStringField="PersonsCostRate_id" />
        </SelectParameters>        
 
        <UpdateParameters>
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Anno" Type="Int32" />
            <asp:Parameter Name="CostRate" Type="Decimal" />
            <asp:Parameter Name="PersonsCostRate_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
 
    <asp:SqlDataSource ID="DSpersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name, Active FROM Persons WHERE (Active = 1) ORDER BY Name">
    </asp:SqlDataSource>

</body>

</html>
