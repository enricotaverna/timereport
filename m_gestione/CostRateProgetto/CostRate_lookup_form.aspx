<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRate_lookup_form.aspx.cs" Inherits="m_gestione_CostRate_lookup_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><!-- Jquery   -->
      
 <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>

<script>
    $(function () {

        $("#SchedaCostRate_TBDataDa").datepicker($.datepicker.regional['it']);

    });
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Phase</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
</head>
    <SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
    <script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>
<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" >

    <form id="form1" runat="server"  >

    <asp:FormView ID="SchedaCostRate" runat="server" DataKeyNames="ForcedAccounts_Id" 
        DataSourceID="DSForcedAccounts" EnableModelValidation="True" DefaultMode="Insert"
        align="center" oniteminserted="SchedaCostRate_ItemInserted"  CssClass="StandardForm"
        onitemupdated="SchedaCostRate_ItemUpdated" onmodechanging="SchedaCostRate_ModeChanging">
        
        <EditItemTemplate>
         
                <!-- *** TITOLO FORM ***  -->
			    <div class="formtitle">Aggiorna Cost Rate</div> 

               <!-- *** PERSONA ***  --> 
                <div class="input nobottomborder">                        
	                <div class="inputtext">Persona:</div>  
                        <label class="dropdown" style="width:245px" >
                            <asp:DropDownList ID="DDLPersona" runat="server" DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>' AppendDataBoundItems="True">
                            <asp:ListItem Value="">-- seleziona persona --</asp:ListItem>
                            </asp:DropDownList>
                        </label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" Display="none" runat="server" ErrorMessage="Inserisci il codice persona" ControlToValidate="DDLPersona"></asp:RequiredFieldValidator>
                </div>    

                <!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                        <label class="dropdown" style="width:245px" >
                            <asp:DropDownList ID="DDLProgetto" runat="server" DataSourceID="DSProgetti" DataTextField="NomeProgetto" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>' AppendDataBoundItems="True">
                            <asp:ListItem Value="">-- seleziona progetto --</asp:ListItem>
                            </asp:DropDownList>
                        </label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="none" runat="server" ErrorMessage="Inserisci il codice progetto" ControlToValidate="DDLProgetto"></asp:RequiredFieldValidator>
                </div>   

               <!-- *** Cost Rate ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Cost Rate (EUR): </div> 
                     <asp:TextBox ID="TBCostRate" runat="server" Text='<%# Bind("CostRate") %>' CssClass="ASPInputcontent" />
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" Display="none" runat="server" ErrorMessage="Inserisci valore Cost Rate" ControlToValidate="TBCostRate"></asp:RequiredFieldValidator>
               </div>  
                			
	           <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" />            
               </div>  

        </EditItemTemplate>

        <ItemTemplate>

                <!-- *** TITOLO FORM ***  -->
			    <div class="formtitle">Aggiorna Cost Rate</div> 

               <!-- *** PERSONA ***  --> 
                <div class="input nobottomborder">                        
	                <div class="inputtext">Persona:</div>  
                        <label class="dropdown" style="width:245px" >
                            <asp:DropDownList ID="Persons_id" runat="server" DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Persons_id") %>' AppendDataBoundItems="True" Enabled="False">
                            </asp:DropDownList>
                        </label>
                </div>    

                <!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                        <label class="dropdown" style="width:245px" >
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSProgetti" DataTextField="NomeProgetto" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>' AppendDataBoundItems="True" Enabled="False">
                            </asp:DropDownList>
                        </label>
                </div>   

               <!-- *** Cost Rate ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Cost Rate (EUR): </div> 
                     <asp:TextBox ID="TBCostRate" runat="server" Text='<%# Bind("CostRate") %>' CssClass="ASPInputcontent" Enabled="False" />
               </div>  
                			
	           <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" />            
               </div> 
        </ItemTemplate>

    </asp:FormView>
     
    <asp:ValidationSummary ID="VSValidator" runat="server" ShowMessageBox="True" ShowSummary="false"  />

    </form>

    </td></tr>           

    </table>

    </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div>  

        <asp:SqlDataSource ID="DSForcedAccounts" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [ForcedAccounts] WHERE ([ForcedAccounts_id] = @ForcedAccounts_id)" 
        InsertCommand="INSERT INTO [ForcedAccounts] ([Persons_id],[Projects_id], [CostRate], [ListPrice] ) VALUES (@Persons_id, @Projects_id, @CostRate, @ListPrice)" 
        UpdateCommand="UPDATE [ForcedAccounts] SET [Persons_id] = @Persons_id, [Projects_id] = @Projects_id, [CostRate] = @CostRate, [ListPrice] = @ListPrice WHERE [ForcedAccounts_id] = @ForcedAccounts_id" >        

        <SelectParameters>
        <asp:QueryStringParameter Name="ForcedAccounts_id" QueryStringField="ForcedAccounts_id" Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="CostRate" Type="Decimal" />
            <asp:Parameter Name="ListPrice" Type="Decimal" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="CostRate" Type="Decimal" />
            <asp:Parameter Name="ListPrice" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="DSProgetti" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        
        SelectCommand="*** PAGE BEHIND ***" 
        onselecting="DSProject_Selecting">
        <SelectParameters>
            <asp:Parameter Name="ClientManager_id" />
        </SelectParameters>
    </asp:SqlDataSource>

     <asp:SqlDataSource ID="DSPersons" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name">  </asp:SqlDataSource>


</body>

</html>
