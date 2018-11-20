<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Phase_lookup_form.aspx.cs" Inherits="m_gestione_Phase_Phase_lookup_list" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><!-- Jquery   -->
      
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
    <title>Phase</title>
</head>

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" >

    <form id="FormPhase" runat="server"  >

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
                     <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent" 
                                                                  data-parsley-Maxlength ="40" data-parsley-errors-container="#valMsg" data-parsley-required="true" />
               </div>   

               	<!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                    <label class="dropdown"  >
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>'></asp:DropDownList>
                    </label>
                </div>  
                			
	           <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                    <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton"  />
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" formnovalidate="true"/>            
               </div>  

        </EditItemTemplate>

        <InsertItemTemplate>

               <!-- *** TITOLO FORM ***  -->
			   <div class="formtitle">Inserisci fase</div> 

               <!-- *** DESCRIZIONE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Codice fase: </div> 
                     <asp:TextBox ID="PhaseCodeTextBox" runat="server" Text='<%# Bind("PhaseCode") %>' CssClass="ASPInputcontent"
                                          data-parsley-errors-container="#valMsg" data-parsley-required="true" />

               </div>   

               <!-- *** DESCRIZIONE ***  --> 
               <div class="input nobottomborder"> 
                     <div class="inputtext">Descrizione: </div> 
                     <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent" 
                                  data-parsley-errors-container="#valMsg" data-parsley-required="true" />
               </div>   

                <!-- *** PROGETTO ***  -->
	            <div class="input nobottomborder">                        
	                <div class="inputtext">Progetto:</div>  
                        <label class="dropdown" style="width:245px" >
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>' AppendDataBoundItems="True"
                                              data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                            <asp:ListItem  Value="" Text="-- Selezionare un valore --"/></asp:DropDownList>
                        </label>
                </div>   

               <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                 <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                 <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                 <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" formnovalidate="true"/>                
                </div>  

        </InsertItemTemplate>

        <ItemTemplate>
            <%--*** NON UTILIZZATO ***--%>
        </ItemTemplate>

    </asp:FormView>

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

<script type="text/javascript">

    // *** Esclude i controlli nascosti *** 
    $('#FormPhase').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

</script>

</body >

</html>
