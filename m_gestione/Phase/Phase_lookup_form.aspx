<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Phase_lookup_form.aspx.cs" Inherits="m_gestione_Phase_Phase_lookup_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><!-- Jquery   -->
      
 <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script>

<script>
    $(function () {

        // validation summary su validator custom
        displayAlert();

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

    <asp:FormView ID="SchedaFase" runat="server" DataKeyNames="Phase_id" 
        DataSourceID="DSPhase" EnableModelValidation="True" DefaultMode="Insert"
        align="center" oniteminserted="SchedaFase_ItemInserted"  CssClass="StandardForm"
        onitemupdated="SchedaFase_ItemUpdated" onmodechanging="SchedaFase_ModeChanging">
        
        <EditItemTemplate>
         
                <!-- *** TITOLO FORM ***  -->
			    <div class="formtitle">Aggiorna fase</div> 

          	   <!-- *** CODICE FASE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Codice Fase: </div> 
                     <asp:TextBox ID="PhaseCodeTextBox" runat="server" Text='<%# Bind("PhaseCode") %>' CssClass="ASPInputcontent" Enabled="False"/> 
               </div>   

	           <!-- *** DESCRIZIONE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Descrizione: </div> 
                     <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent" />
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Inserisci la descrizione" ControlToValidate="NameTextBox" Display="none"></asp:RequiredFieldValidator>
               </div>   

               	<!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                    <div class="InputcontentDDL"  >
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>'></asp:DropDownList>
                    </div>
                </div>  
                			
	           <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" />            
               </div>  

        </EditItemTemplate>

        <InsertItemTemplate>

               <!-- *** TITOLO FORM ***  -->
			   <div class="formtitle">Inserisci fase</div> 

               <!-- *** DESCRIZIONE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Codice fase: </div> 
                     <asp:TextBox ID="PhaseCodeTextBox" runat="server" Text='<%# Bind("PhaseCode") %>' CssClass="ASPInputcontent"/> 
                     <asp:CustomValidator ID="ValidaFase" runat="server" Display="none" ErrorMessage="Codice fase già esistente" OnServerValidate="ValidaFase_ServerValidate" ControlToValidate="PhaseCodeTextBox"></asp:CustomValidator>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="none" runat="server" ControlToValidate="PhaseCodeTextBox" ErrorMessage="Inserisci il codice fase"></asp:RequiredFieldValidator>
               </div>   

               <!-- *** DESCRIZIONE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Descrizione: </div> 
                     <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent" />
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" Display="none" runat="server" ErrorMessage="Inserisci descrizione fase" ControlToValidate="NameTextBox"></asp:RequiredFieldValidator>
               </div>   

                <!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                        <div class="InputcontentDDL" style="width:245px" >
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>' AppendDataBoundItems="True">
                            <asp:ListItem  Value="" Text="-- Selezionare un valore --"/></asp:DropDownList>
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="none" runat="server" ErrorMessage="Inserisci il codice progetto" ControlToValidate="DropDownList1"></asp:RequiredFieldValidator>
                </div>   

               <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                 <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                 <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" />                
                </div>  

        </InsertItemTemplate>

        <ItemTemplate>
            <%--*** NON UTILIZZATO ***--%>
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

        <asp:SqlDataSource ID="DSPhase" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Phase] WHERE ([Phase_id] = @PhaseId)" 
        InsertCommand="INSERT INTO [Phase] ([PhaseCode], [Name], [Projects_id]) VALUES (@PhaseCode, @Name, @Projects_id)" 
        UpdateCommand="UPDATE [Phase] SET [PhaseCode] = @PhaseCode, [Name] = @Name, [Projects_id] = @Projects_id WHERE [Phase_id] = @Phase_id">        

        <SelectParameters>
        <asp:QueryStringParameter Name="PhaseId" QueryStringField="PhaseId" Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="PhaseCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="PhaseCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="Phase_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="DSProject" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        
        SelectCommand="SELECT Projects_Id, ProjectCode + N' ' + left(Name,15) AS ProjectName FROM Projects WHERE (ClientManager_id = @ClientManager_id) AND (Active = 1) and ActivityOn = 1" 
        onselecting="DSProject_Selecting">
        <SelectParameters>
            <asp:Parameter Name="ClientManager_id" />
        </SelectParameters>
    </asp:SqlDataSource>

</body>

</html>
