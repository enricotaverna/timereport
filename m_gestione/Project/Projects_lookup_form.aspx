<%@ Page Language="VB"  %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    Private Shared prevPage As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        '	Autorizzazione su tutti o sui progetti assegnati
        If Not Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL") Then
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED")
        End If

        If (Not IsPostBack) Then
            If Len(Request.QueryString("Projectcode")) > 0 Then
                FVProgetto.ChangeMode(FormViewMode.Edit)
                FVProgetto.DefaultMode = FormViewMode.Edit
            End If
            prevPage = Request.UrlReferrer.ToString()
        End If

    End Sub

    Protected Sub FVProgetto_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs)
        Response.Redirect(prevPage)
    End Sub

    Protected Sub FVProgetto_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs)
        Response.Redirect("projects_lookup_list.aspx?messaggio=yes")
    End Sub

    Protected Sub FVProgetto_ModeChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewModeEventArgs)
        If (e.CancelingEdit = True) Then
            Response.Redirect(prevPage)
        End If
    End Sub

    Sub ValidaProgetto_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)

        Dim c As Object = New ValidationClass
        ' true se non esiste già il record
        args.IsValid = Not c.CheckExistence("ProjectCode", args.Value, "Projects")

        ' Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, FVProgetto, "TBProgetto")

    End Sub

    Protected Sub projects_Inserting(sender As Object, e As SqlDataSourceCommandEventArgs)

    End Sub
</script>

 <!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

 <!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>    
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 


<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Crea Progetto</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

</head>

<script language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" type=text/javascript></script>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>  

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" style="width:496px">

    <form id="formProgetto" runat="server" class="StandardForm">

        <asp:FormView ID="FVProgetto" runat="server" DataKeyNames="Projects_Id" 
            DataSourceID="projects" OnItemUpdated="FVProgetto_ItemUpdated" 
            OnItemInserted="FVProgetto_ItemInserted" 
            OnModeChanging="FVProgetto_ModeChanging"  
            DefaultMode="Insert" width="100%">
            
            <EditItemTemplate>
                
                 <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Progetto</a></li>
                    <li><a href="#tabs-2">Budget</a></li>
                    <li><a href="#tabs-3">Fatturazione</a></li>
                    <li><a href="#tabs-4">Altri dati</a></li>
                  </ul>

                <div id="tabs-1" style="height:460px;width:100%"> 
                
                  <!-- *** CODICE PROGETTO ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Codice: </div>
                    <asp:TextBox ID="TBProgetto" runat="server"  class="ASPInputcontent"
                                Text='<%# Bind("ProjectCode") %>' Enabled="False" Columns="12"  
                                MaxLength="10" />
                    <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
					<asp:Label  AssociatedControlId="ActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="progetto attivo"></asp:Label>
				  </div>  

                  <!-- *** NOME PROGETTO ***  -->
				  <div class="input"  >
				    <div class="inputtext">Progetto: </div>
                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' 
                                Columns="26" MaxLength="50" class="ASPInputcontent"
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" />
				  </div>  

                <!-- *** CODICE CLIENTE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Cliente:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="cliente" 
                                DataTextField="Nome1" DataValueField="CodiceCliente"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("CodiceCliente") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>   
				        </label>
				    </div>  

                <!-- *** CODICE MANAGER ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="manager" 
                                DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ClientManager_id") %>'
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>     
				        </label>
				    </div>  

                <!-- *** TIPO PROGETTO ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Tipo progetto:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto" 
                                DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ProjectType_Id") %>' 
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                 <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
 				    </div>  

                <!-- *** CANALE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Canale:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale" 
                                DataTextField="Name" DataValueField="Channels_Id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Channels_Id") %>' 
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
 				    </div>  

                <!-- *** SOCIETA ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Società:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="societa" 
                                DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Company_id") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>				       
				    </label>  
                </div>

                <!-- *** CHECKBOX ***  -->
                 <div class="input nobottomborder">
                        <div class="inputtext">&nbsp;</div>   
                        
                        <asp:CheckBox ID="AlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />
                        <asp:Label  AssociatedControlId="AlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo" ></asp:Label>  
                  
                        <asp:CheckBox ID="ActivityOn" runat="server" Checked='<%#Bind("ActivityOn") %>' />
                        <asp:Label  AssociatedControlId="ActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS" style="padding-right:40px"></asp:Label>                              

                        <br />
                        <asp:CheckBox ID="BloccoCaricoSpeseCheckBox" runat="server" Checked='<%# bind("BloccoCaricoSpese") %>' />
                        <asp:Label  AssociatedControlId="BloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>   
                             
                </div>

                 </div> <!-- *** TAB 1 ***  -->

                <div id="tabs-2" style="height:460px;width:100%"> 
                
                <!-- *** TIPO CONTRATTO ***  -->
				<div class="input ">
				        <div class="inputtext">Contratto: </div>  
                        <label class="dropdown" >
                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="TipoContratto" DataTextField="Descrizione" 
                                DataValueField="TipoContratto_id" 
                                SelectedValue='<%# Bind("TipoContratto_id") %>'
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>
                        </asp:DropDownList>		
                        </label>		       
                </div>  

                 <div class="SeparatoreForm">Budget</div>   

                  <!-- *** IMPORTO REVENUE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                    <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number"/>
                    <label>€</label>
				  </div>  

                  <!-- *** IMPORTO BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Budget ABAP: </div>
                    <asp:TextBox ID="TBBudgetABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP", "{0:#####}")%>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"  />
                    <label>€</label>
				  </div> 

                  <!-- *** GG BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Bdg GG ABAP: </div>
                    <asp:TextBox ID="TBBudgetGGABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP")%>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
				  </div> 
  
                  <!-- *** IMPORTO SPESE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                    <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                    <label>€</label>
                    <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                    <asp:Label  AssociatedControlId="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
				  </div>                                                       
                                    
                <!-- *** MARGINE TARGET ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Margine: </div>
                    <asp:TextBox ID="TBMargine"  class="ASPInputcontent" columns="5" runat="server" Text='<%# Bind("MargineTarget") %>' 
                                  data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="percent"  /> 
                    <label>%</label>
                  </div> 
 
                <div class="SeparatoreForm">Durata</div>

                <!-- *** DATA INIZIO  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10" 
                                 data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                </div>

                 <!-- *** DATA FINE  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label5" CssClass="inputtext" runat="server"  Text="Data fine:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine","{0:d}") %>' MaxLength="10" Rows="12" Columns="10" 
                                 data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                </div>    
                     
                </div> <!-- *** TAB 2 ***  -->

                <div id="tabs-3" style="height:460px;width:100%"> 
                
                  <!-- *** Piano di fatturazione ***  -->
				  <div class="input nobottomborder">
				      <div class="inputtext">Piano di fatturazione: </div>
                       <asp:TextBox ID="PianoFatturazioneTextBox" runat="server" 
                                Text='<%# Bind("PianoFatturazione") %>' Columns="22" Rows="5" CssClass="textarea"
                                TextMode="MultiLine" />
				  </div> 

                  <!-- *** Metodo di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Metodo di pag: </div> 
                        <label class="dropdown" > 
                        <asp:DropDownList ID="DropDownList8" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="MetodoPagamento" DataTextField="Descrizione" 
                                DataValueField="MetodoPagamento" SelectedValue='<%# Bind("MetodoPagamento") %>'>
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>		       
				        </label>
                   </div> 
                           
                  <!-- *** Termini di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Termini di pag: </div>  
                        <label class="dropdown" >    
                            <asp:DropDownList ID="DropDownList9" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="TerminiPagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>'>
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>       
				        </label>
                   </div> 

                  <div class="SeparatoreForm">Actual</div>

                  <!-- *** Importo Revenue Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                      <asp:TextBox ID="RevenueFatturateTextBox" runat="server"  class="ASPInputcontent"
                                Text='<%# Bind("RevenueFatturate", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                      <label>€</label>
				  </div> 

                  <!-- *** Importo Spese Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                               <asp:TextBox ID="SpeseFatturateTextBox" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("SpeseFatturate", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                                <label>€</label>
				  </div> 
                            
                  <!-- *** Importo Incassato ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Incassato: </div>
                                <asp:TextBox ID="IncassatoTextBox" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("Incassato", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                                <label>€</label>
				  </div> 
                                                               
                </div> <!-- *** TAB 3 ***  -->

                 <!-- *** TAB 4 ***  -->
                <div id="tabs-4" style="height:460px;width:100%"> 
                
                <!-- *** Altri dati ***  -->

                <!-- *** TESTO OBBLIGATORIO ***  -->
   		        <div class="input nobottomborder">
				        <div class="inputtext">Testo obbl.: </div>
                        <asp:TextBox ID="TBMessaggioDiErrore" class="ASPInputcontent" runat="server" Text='<%# Bind("MessaggioDiErrore")%>'   />
                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server"   Checked='<%# Bind("TestoObbligatorio") %>' />
                        <asp:Label  AssociatedControlId="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
				</div>       

            	 <div class="input nobottomborder"> 
	                <div class="inputtext">Note</div> 
	                <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea"/> 
	            </div>  

                </div> <!-- *** TAB 4 ***  -->

                </div>  <!-- *** TABS ***  -->
                
                <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"/>
                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />               
               </div>                   
   
            </EditItemTemplate>
          
            <InsertItemTemplate>

                <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Progetto</a></li>
                    <li><a href="#tabs-2">Budget</a></li>
                    <li><a href="#tabs-3">Fatturazione</a></li>
                    <li><a href="#tabs-4">Altri dati</a></li>
                  </ul>

                <div id="tabs-1" style="height:460px;width:100%"> 
                
                  <!-- *** CODICE PROGETTO ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Codice: </div>
                            <asp:TextBox ID="TBProgetto" runat="server"  class="ASPInputcontent" Text='<%# Bind("ProjectCode") %>' Columns="12" MaxLength="10"
                                         data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-trigger-after-failure="focusout" data-parsley-codiceUnico="" />
                             <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
					         <asp:Label  AssociatedControlId="ActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="attivo"></asp:Label>                      
				  </div>  

                  <!-- *** NOME PROGETTO ***  -->
				  <div class="input"  >
				    <div class="inputtext">Progetto: </div>
                    <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' Columns="26" MaxLength="50" class="ASPInputcontent"
                                 data-parsley-errors-container="#valMsg" data-parsley-required="true" />
				  </div>  

                <!-- *** CODICE CLIENTE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Cliente:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DropDownList10" runat="server" DataSourceID="cliente" 
                                DataTextField="Nome1" DataValueField="CodiceCliente"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("CodiceCliente") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>   
                        </label>
				    </div>  

                <!-- *** CODICE MANAGER ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="manager" 
                                DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ClientManager_id") %>' 
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>  
	    			     </label>
  			    </div>  

                <!-- *** TIPO PROGETTO ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Tipo progetto:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto" 
                                DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ProjectType_Id") %>' 
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                 <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
 				        </label>
				    </div>  

                <!-- *** CANALE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Canale:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale" 
                                DataTextField="Name" DataValueField="Channels_Id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Channels_Id") %>'  
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
				    </div>  

                <!-- *** SOCIETA ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Società:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DropDownList14" runat="server" DataSourceID="societa" 
                                DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Company_id") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>				       
				    </label>  
                </div>

                <!-- *** CHECKBOX ***  -->
                 <div class="input nobottomborder">
                        <div class="inputtext">&nbsp;</div> 
                        <asp:CheckBox ID="AlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />
                        <asp:Label  AssociatedControlId="AlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo" style="padding-right:40px"></asp:Label> 
                                                                       
                        <asp:CheckBox ID="ActivityOn" runat="server" Checked='<%# bind("ActivityOn") %>' />
                        <asp:Label  AssociatedControlId="ActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS" ></asp:Label>           
                     
                        <br />

                        <asp:CheckBox ID="BloccoCaricoSpeseCheckBox" runat="server" Checked='<%# bind("BloccoCaricoSpese") %>' />
                        <asp:Label  AssociatedControlId="BloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>                         
     
                </div>

                </div> <!-- *** TAB 1 ***  -->

                <div id="tabs-2" style="height:460px;width:100%"> 
                
                <!-- *** TIPO CONTRATTO ***  -->
				<div class="input ">
				        <div class="inputtext">Contratto: </div>  
                        <label class="dropdown" style="width:250px">
                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"  
                                DataSourceID="TipoContratto" DataTextField="Descrizione" 
                                DataValueField="TipoContratto_id" 
                                SelectedValue='<%# Bind("TipoContratto_id") %>'
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>
                        </asp:DropDownList>		
                        </label>
                </div>  

                  <div class="SeparatoreForm">Budget</div>
                    
                  <!-- *** IMPORTO REVENUE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                    <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number"/>
                    <label>€</label>
				  </div>  

                  <!-- *** IMPORTO BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Budget ABAP: </div>
                    <asp:TextBox ID="TBBudgetABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP", "{0:#####}") %>'  
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>                    <label>€</label>
				  </div>  
  
                 <!-- *** GG BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Bdg GG ABAP: </div>
                    <asp:TextBox ID="TBBudgetGGABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP")%>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
				  </div> 

                  <!-- *** IMPORTO SPESE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                    <asp:TextBox ID="TextBox4"  class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                    <label>€</label>
                    <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                    <asp:Label  AssociatedControlId="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
				  </div>                                                       

                  <!-- *** MARGINE TARGET ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Margine: </div>
                    <asp:TextBox ID="TBMargine" columns="5" class="ASPInputcontent" runat="server" Text='<%# Bind("MargineTarget") %>' 
                                  data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="percent"   /> 
                    <label>%</label>
                  </div> 
 
                <div class="SeparatoreForm">Durata</div>

                <!-- *** DATA INIZIO  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10" 
                                 data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                </div>

                 <!-- *** DATA FINE  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Data fine:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine","{0:d}") %>' MaxLength="10" Rows="12" Columns="10" 
                                 data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                </div>
                                   
                </div> <!-- *** TAB 2 ***  -->

                <div id="tabs-3" style="height:460px;width:100%"> 
                
                  <!-- *** Piano di fatturazione ***  -->
				  <div class="input nobottomborder">
				      <div class="inputtext">Piano di fatturazione: </div>
                       <asp:TextBox ID="TextBox9" runat="server" 
                                Text='<%# Bind("PianoFatturazione") %>' Columns="22" Rows="5" CssClass="textarea"
                                TextMode="MultiLine" />
				  </div> 

                  <!-- *** Metodo di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Metodo di pag:</div> 
                        <label class="dropdown" > 
                        <asp:DropDownList ID="DropDownList15" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="MetodoPagamento" DataTextField="Descrizione" 
                                DataValueField="MetodoPagamento" SelectedValue='<%# Bind("MetodoPagamento") %>'>
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>		       
				        </label>
                   </div> 
                           
                  <!-- *** Termini di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Termini di pag:</div>  
                        <label class="dropdown" >    
                            <asp:DropDownList ID="DropDownList16" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="TerminiPagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>'>
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>       
				        </label>
                   </div> 

                <div class="SeparatoreForm">Actual</div>

                  <!-- *** Importo Revenue Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                            <asp:TextBox ID="TextBox6" runat="server"  class="ASPInputcontent"
                                Text='<%# Bind("RevenueFatturate", "{0:#####}") %>'
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                    <label>€</label>
				  </div> 

                  <!-- *** Importo Spese Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                               <asp:TextBox ID="TextBox7" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("SpeseFatturate", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                                   <label>€</label>
				  </div> 
                            
                  <!-- *** Importo Incassato ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Incassato: </div>
                                <asp:TextBox ID="TextBox8" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("Incassato", "{0:#####}") %>' 
                                 data-parsley-errors-container="#valMsg" data-parsley-type="number"/>
                    <label>€</label>
				  </div>
                                              
                </div> <!-- *** TAB 3 ***  -->

                <!-- *** TAB 4 ***  -->
                <div id="tabs-4" style="height:460px;width:100%"> 

                 <!-- *** Altri dati ***  -->

                    <!-- *** TESTO OBBLIGATORIO ***  -->
				    <div class="input nobottomborder">
				        <div class="inputtext">Testo obbl.: </div>
                        <asp:TextBox ID="TBMessaggioDiErrore" value="messaggio di errore" class="ASPInputcontent" runat="server" Text='<%# Bind("MessaggioDiErrore")%>' />
                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server" Checked='<%# Bind("TestoObbligatorio") %>' />
                        <asp:Label  AssociatedControlId="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
				    </div>         

                 <!-- *** NOTE ***  -->
            	 <div class="input nobottomborder">                      
	                <div class="inputtext">Note</div> 
	                   <asp:TextBox ID="TextBox1" runat="server" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea"/> 
                    </div>  
                            
                </div> <!-- *** TAB 4 ***  -->

                </div>  <!-- *** TABS ***  -->
                
                <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"   />
                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />               
               </div>                   

            </InsertItemTemplate>

            <ItemTemplate>
                <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Progetto</a></li>
                    <li><a href="#tabs-2">Budget</a></li>
                    <li><a href="#tabs-3">Fatturazione</a></li>
                    <li><a href="#tabs-4">Altri dati</a></li>
                  </ul>

                <div id="tabs-1" style="height:460px;width:100%"> 
                
                  <!-- *** CODICE PROGETTO ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Codice: </div>
                    <asp:TextBox ID="TBProgetto" runat="server"  class="ASPInputcontent"
                                Text='<%# Bind("ProjectCode") %>' Enabled="False" Columns="12"  
                                MaxLength="10" />
                    <asp:CheckBox ID="DisActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
					<asp:Label  AssociatedControlId="DisActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="progetto attivo"></asp:Label>
				  </div>  

                  <!-- *** NOME PROGETTO ***  -->
				  <div class="input"  >
				    <div class="inputtext">Progetto: </div>
                            <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' 
                                Columns="26" MaxLength="50" Enabled="False" class="ASPInputcontent"/>
				  </div>  

                <!-- *** CODICE CLIENTE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Cliente:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DropDownList4" runat="server" DataSourceID="cliente" 
                                DataTextField="Nome1" DataValueField="CodiceCliente"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("CodiceCliente") %>' Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>   
				        </label>
				    </div>  

                <!-- *** CODICE MANAGER ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="manager" 
                                DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ClientManager_id") %>' Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>     
				        </label>
				    </div>  

                <!-- *** TIPO PROGETTO ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Tipo progetto:</div>  
				        <label class="dropdown" >
                            <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto" 
                                DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                SelectedValue='<%# Bind("ProjectType_Id") %>' Enabled="False">
                                 <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
				    </div>  

                <!-- *** CANALE ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Canale:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale" 
                                DataTextField="Name" DataValueField="Channels_Id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Channels_Id") %>'  Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
 				    </div>  

                <!-- *** SOCIETA ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Società:</div>  
				        <label class="dropdown" >
                             <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="societa" 
                                DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("Company_id") %>' EnableTheming="True" Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>				       
				    </label>  
                </div>

                <!-- *** CHECKBOX ***  -->
                 <div class="input nobottomborder">

                        <span class="input2col">
                            <asp:CheckBox ID="DisActivityOn" runat="server" Checked='<%# bind("ActivityOn") %>' />
                            <asp:Label  AssociatedControlId="DisActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS"></asp:Label>                              
                        </span>

                        <asp:CheckBox ID="DisAlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />
                        <asp:Label  AssociatedControlId="DisAlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo"></asp:Label>  
                     
                        <asp:CheckBox ID="DisBloccoCaricoSpeseCheckBox" runat="server" Checked='<%# bind("BloccoCaricoSpese") %>' />
                        <asp:Label  AssociatedControlId="DisBloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>   
                             
                </div>

                 </div> <!-- *** TAB 1 ***  -->

                <div id="tabs-2" style="height:460px;width:100%"> 
                
                <!-- *** TIPO CONTRATTO ***  -->
				<div class="input ">
				        <div class="inputtext">Contratto: </div>  
                        <label class="dropdown" >
                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="TipoContratto" DataTextField="Descrizione" 
                                DataValueField="TipoContratto_id" 
                                SelectedValue='<%# Bind("TipoContratto_id") %>' Enabled="False">
                        <asp:ListItem  Value="" Text="Selezionare un valore"/>
                        </asp:DropDownList>		
                        </label>		       
                </div>  

                 <div class="SeparatoreForm">Budget</div>   

                  <!-- *** IMPORTO REVENUE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                    <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget") %>' Enabled="False" />
				  </div>  

                  <!-- *** IMPORTO BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Budget ABAP: </div>
                    <asp:TextBox ID="TBBudgetABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP") %>' Enabled="False" />
				  </div>

                  <!-- *** GG BUDGET ABAP ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Bdg GG ABAP: </div>
                    <asp:TextBox ID="TBBudgetGGABAP" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP")%>' Enabled="False" />
				  </div> 
                      
                  <!-- *** IMPORTO SPESE ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                    <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget") %>' Enabled="False" />
                    <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                    <asp:Label  AssociatedControlId="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
				  </div>                                                       
                                    
                <!-- *** MARGINE TARGET ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Margine: </div>
                    <asp:TextBox ID="TBMargine"  class="ASPInputcontent" columns="5" runat="server" Text='<%# Bind("MargineTarget") %>' Enabled="False" 
                                 data-parsley-errors-container="#valMsg"  data-parsley-type='integer' data-parsley-max='100' data-parsley-min='1'   /> 
				  </div> 
 
                <div class="SeparatoreForm">Durata</div>

                <!-- *** DATA INIZIO  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10" Enabled="False" />
                </div>

                 <!-- *** DATA FINE  ***  -->
                <div class="input nobottomborder">
                    <asp:Label ID="Label5" CssClass="inputtext" runat="server"  Text="Data fine:"></asp:Label>
                    <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine","{0:d}") %>' MaxLength="10" Rows="12" Columns="10" Enabled="False" />
                </div>    
                     
                </div> <!-- *** TAB 2 ***  -->

                <div id="tabs-3" style="height:460px;width:100%"> 
                
                  <!-- *** Piano di fatturazione ***  -->
				  <div class="input nobottomborder">
				      <div class="inputtext">Piano di fatturazione: </div>
                       <asp:TextBox ID="PianoFatturazioneTextBox" runat="server" 
                                Text='<%# Bind("PianoFatturazione") %>' Columns="22" Rows="5" CssClass="textarea"
                                TextMode="MultiLine" Enabled="False" />
				  </div> 

                  <!-- *** Metodo di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Metodo di pag: </div> 
                        <label class="dropdown" > 
                        <asp:DropDownList ID="DropDownList8" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="MetodoPagamento" DataTextField="Descrizione" 
                                DataValueField="MetodoPagamento" SelectedValue='<%# Bind("MetodoPagamento") %>' Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>		       
				        <</label>
                   </div> 
                           
                  <!-- *** Termini di pagamento ***  -->
				  <div class="input nobottomborder">
				        <div class="inputtext">Termini di pag: </div>  
                        <label class="dropdown" >    
                            <asp:DropDownList ID="DropDownList9" runat="server" AppendDataBoundItems="True" 
                                DataSourceID="TerminiPagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>' Enabled="False">
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>       
				        </label>
                   </div> 

                  <div class="SeparatoreForm">Actual</div>

                  <!-- *** Importo Revenue Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Revenue: </div>
                            <asp:TextBox ID="RevenueFatturateTextBox" runat="server"  class="ASPInputcontent"
                                Text='<%# Bind("RevenueFatturate") %>' Enabled="False" />
				  </div> 

                  <!-- *** Importo Spese Fatturate ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Spese: </div>
                               <asp:TextBox ID="SpeseFatturateTextBox" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("SpeseFatturate") %>' Enabled="False" />
				  </div> 
                            
                  <!-- *** Importo Incassato ***  -->
				  <div class="input nobottomborder">
				    <div class="inputtext">Incassato: </div>
                                <asp:TextBox ID="IncassatoTextBox" runat="server" class="ASPInputcontent"
                                      Text='<%# Bind("Incassato") %>' Enabled="False" />
				  </div> 
                                                               
                </div> <!-- *** TAB 3 ***  -->

                 <!-- *** TAB 4 ***  -->
                <div id="tabs-4" style="height:460px;width:100%"> 
                
                <!-- *** Altri dati ***  -->
                    
                    <!-- *** TESTO OBBLIGATORIO ***  -->
				    <div class="input nobottomborder">
				        <div class="inputtext">Testo obbl.: </div>
                        <asp:TextBox ID="TBMessaggioDiErrore" class="ASPInputcontent" runat="server" Text='<%# Bind("MessaggioDiErrore")%>' Enabled="False"  />
                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server" Enabled="False"  Checked='<%# Bind("TestoObbligatorio") %>' />
                        <asp:Label  AssociatedControlId="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
				    </div>         

                 <!-- *** NOTE ***  -->
            	 <div class="input nobottomborder"> 
	                <div class="inputtext">Note</div> 
	                <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" Enabled="False" /> 
	            </div> 

                </div> <!-- *** TAB 4 ***  -->

                </div>  <!-- *** TABS ***  -->
                
                <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />               
               </div>                   

            </ItemTemplate>
        
        </asp:FormView>

    </form>

      </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session("CutoffDate")%>  </div>
        <div id="WindowFooter-R">Utente: <%=Session("UserName")%></div>
    </div> 

           <asp:SqlDataSource ID="projects" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            DeleteCommand="DELETE FROM [Projects] WHERE [Projects_Id] = @Projects_Id" 
            InsertCommand="INSERT INTO Projects(ProjectCode, Name, ProjectType_Id, Channels_Id, Company_id, Active, Always_available, BloccoCaricoSpese,ClientManager_id, TipoContratto_id, RevenueBudget, BudgetABAP, BudgetGGABAP, SpeseBudget, SpeseForfait, MargineTarget, DataInizio, DataFine, RevenueFatturate, SpeseFatturate, Incassato, PianoFatturazione, MetodoPagamento, TerminiPagamento, CodiceCliente, Note, ActivityOn, TestoObbligatorio, MessaggioDiErrore ) VALUES (@ProjectCode, @Name, @ProjectType_Id, @Channels_Id, @Company_id, @Active, @Always_available, @BloccoCaricoSpese, @ClientManager_id, @TipoContratto_id, @RevenueBudget, @BudgetABAP, @BudgetGGABAP, @SpeseBudget, @SpeseForfait, @MargineTarget/100, @DataInizio, @DataFine, @RevenueFatturate, @SpeseFatturate, @Incassato, @PianoFatturazione, @MetodoPagamento, @TerminiPagamento, @CodiceCliente, @Note, @ActivityOn, @TestoObbligatorio, @MessaggioDiErrore )" 
            SelectCommand="SELECT * FROM [Projects] WHERE ([ProjectCode] = @ProjectCode)" 
            UpdateCommand="UPDATE Projects SET ProjectCode = @ProjectCode, Name = @Name, ProjectType_Id = @ProjectType_Id, Channels_Id = @Channels_Id, Company_id = @Company_id, Active = @Active, Always_available = @Always_available, BloccoCaricoSpese = @BloccoCaricoSpese, ClientManager_id = @ClientManager_id, TipoContratto_id = @TipoContratto_id, RevenueBudget = @RevenueBudget, BudgetABAP = @BudgetABAP, BudgetGGABAP = @BudgetGGABAP ,SpeseBudget = @SpeseBudget, SpeseForfait = @SpeseForfait, MargineTarget=@MargineTarget/100, DataFine=@DataFine, DataInizio=@DataInizio, RevenueFatturate = @RevenueFatturate, SpeseFatturate = @SpeseFatturate, Incassato = @Incassato, PianoFatturazione = @PianoFatturazione, MetodoPagamento = @MetodoPagamento, TerminiPagamento = @TerminiPagamento, CodiceCliente = @CodiceCliente, Note = @Note, ActivityOn = @ActivityOn, TestoObbligatorio = @TestoObbligatorio, MessaggioDiErrore  = @MessaggioDiErrore  WHERE (Projects_Id = @Projects_Id)" OnInserting="projects_Inserting">
            <SelectParameters>
                <asp:QueryStringParameter Name="ProjectCode" QueryStringField="ProjectCode" 
                    Type="String" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="Projects_Id" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="ProjectCode" Type="String" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="ProjectType_Id" Type="Int32" />
                <asp:Parameter Name="Channels_Id" Type="Int32" />
                <asp:Parameter Name="Company_id" Type="Int32" />
                <asp:Parameter Name="Active" Type="Boolean" />
                <asp:Parameter Name="Always_available" Type="Boolean" />
                <asp:Parameter Name="BloccoCaricoSpese" Type="Boolean" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="TipoContratto_id" Type="Int32" />
                <asp:Parameter Name="RevenueBudget" Type="Decimal" />
                <asp:Parameter Name="BudgetABAP" Type="Decimal" />
                <asp:Parameter Name="BudgetGGABAP" Type="Decimal" />
                <asp:Parameter Name="SpeseBudget" Type="Decimal" />
                <asp:Parameter Name="MargineTarget" Type="Decimal" />
                <asp:Parameter Name="DataFine" Type="DateTime" />
                <asp:Parameter Name="DataInizio" Type="DateTime" />
                <asp:Parameter Name="SpeseForfait" Type="Boolean" />
                <asp:Parameter Name="RevenueFatturate" Type="Decimal" />
                <asp:Parameter Name="SpeseFatturate" Type="Decimal" />
                <asp:Parameter Name="Incassato" Type="Decimal" />
                <asp:Parameter Name="PianoFatturazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="CodiceCliente" Type="String" />
                <asp:Parameter Name="Note" Type="String" />
                <asp:Parameter Name="ActivityOn" />
                <asp:Parameter Name="Projects_Id" Type="Int32" />
                <asp:Parameter Name="TestoObbligatorio" Type="Boolean" />
                <asp:Parameter Name="MessaggioDiErrore" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="ProjectCode" Type="String" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="ProjectType_Id" Type="Int32" />
                <asp:Parameter Name="Channels_Id" Type="Int32" />
                <asp:Parameter Name="Company_id" Type="Int32" />
                <asp:Parameter Name="Active" Type="Boolean" />
                <asp:Parameter Name="Always_available" Type="Boolean" />
                <asp:Parameter Name="BloccoCaricoSpese" Type="Boolean" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="TipoContratto_id" Type="Int32" />
                <asp:Parameter Name="RevenueBudget" Type="Decimal" />
                <asp:Parameter Name="BudgetABAP" Type="Decimal" />
                <asp:Parameter Name="BudgetGGABAP" Type="Decimal" />
                <asp:Parameter Name="SpeseBudget" Type="Decimal" />
                <asp:Parameter Name="SpeseForfait" Type="Boolean" />
                <asp:Parameter Name="MargineTarget" Type="Decimal" />
                <asp:Parameter Name="DataFine" Type="DateTime" />
                <asp:Parameter Name="DataInizio" Type="DateTime" />
                <asp:Parameter Name="RevenueFatturate" Type="Decimal" />
                <asp:Parameter Name="SpeseFatturate" Type="Decimal" />
                <asp:Parameter Name="Incassato" Type="Decimal" />
                <asp:Parameter Name="PianoFatturazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="CodiceCliente" Type="String" />
                <asp:Parameter Name="Note" Type="String" />
                <asp:Parameter Name="ActivityOn" />
                <asp:Parameter Name="TestoObbligatorio" Type="Boolean" />
                <asp:Parameter Name="MessaggioDiErrore" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="cliente" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"                                 
            SelectCommand="SELECT [Nome1], [CodiceCliente] FROM [Customers] ORDER BY [Nome1]">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="manager" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="tipoprogetto" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [ProjectType]">
        </asp:SqlDataSource>

            <asp:SqlDataSource ID="canale" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Channels]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="societa" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Company] ORDER BY [Name]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="TipoContratto" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"                                
        SelectCommand="SELECT [Descrizione], [TipoContratto_id] FROM [TipoContratto]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="MetodoPagamento" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [MetodoPagamento]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="TerminiPagamento" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [TerminiPagamento]"></asp:SqlDataSource>

<script type="text/javascript">

    $(function () {

// abilitate tab view
    $("#tabs").tabs();

    // stile checkbox form    
    $(":checkbox").addClass("css-checkbox");

    // stile checkbox form in ReadOnly   
    $("#FVProgetto_DisActivityOn").addClass("css-checkbox")
    $("#FVProgetto_DisAlwaysAvailableCheckBox").addClass("css-checkbox");
    $("#FVProgetto_DisSpeseForfaitCheckBox").addClass("css-checkbox");
    $("#FVProgetto_DisActiveCheckBox").addClass("css-checkbox");
    $("#FVProgetto_DisBloccoCaricoSpeseCheckBox").addClass("css-checkbox");

    $("#FVProgetto_DisActivityOn").attr("disabled", true);
    $("#FVProgetto_DisAlwaysAvailableCheckBox").attr("disabled", true);
    $("#FVProgetto_DisSpeseForfaitCheckBox").attr("disabled", true);
    $("#FVProgetto_DisActiveCheckBox").attr("disabled", true);
    $("#FVProgetto_DisBloccoCaricoSpeseCheckBox").attr("disabled", true);

// datepicker
    $("#FVProgetto_TBAttivoDa").datepicker($.datepicker.regional['it']);
    $("#FVProgetto_TBAttivoA").datepicker($.datepicker.regional['it']);

// formatta il campo percentuale
    var percentDecimal =  $("#FVProgetto_TBMargine").val().toString().replace(",", ".");
    if (percentDecimal != "") {
        var percentCent = parseFloat(percentDecimal) * 100;
        $("#FVProgetto_TBMargine").val(percentCent);
    } 

    Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
    });

    // *** controllo che non esista lo stesso codice utente *** //
    window.Parsley.addValidator('codiceunico', function (value, requirement) {
        var response = false;
        var dataAjax = "{ sKey: 'ProjectCode', " +
                       " sValkey: '" + value  + "', " + 
                       " sTable: 'Projects'  }";

                    $.ajax({
                        url: "/timereport/webservices/WStimereport.asmx/CheckExistence",
                        data: dataAjax,
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        type: 'post',
                        async: false,
                        success: function (data) {
                            if (data.d == true) // esiste, quindi errore
                                response = false;
                            else
                                response = true;
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            alert(xhr.status);
                            alert(thrownError);
                        }
                    });
                    return response;
         }, 32)
        .addMessage('en', 'codiceunico', 'Project code already exists')
        .addMessage('it', 'codiceunico', 'Codice progetto già esistente');

    // validazione campo revenue in caso il progetto sia FIXED
    window.Parsley.addValidator("requiredIf", {
        validateString: function (value, requirement) {

            // se inserito deve essere un numero
            if (isNaN(value) && !!value) {
                window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                return false;
            }

            if (jQuery("#FVProgetto_DDLTipoContratto option:selected").text() == "FIXED") {

                // se FIXED verifica obbligatorietà
                if (!value)  {
                    window.Parsley.addMessage('it', 'requiredIf', "Verificare i campi obbligatori");
                    return false;
                }

                // se number verifica tipo
                if ( requirement == "number")
                    if ( !isNaN(value) ) //  compilato e numerico
                        return true;
                    else {
                        window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                        return false;
                    }

                // se percent
                if (requirement == "percent")
                    if ( !isNaN(value) && value > 0 && value <= 100 ) //  compilato e numerico
                        return true;
                    else {
                        window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero tra 1 e 100");
                        return false;
                    }    
            }

            return true;
        },
        priority: 33
    })
 
    // *** attiva validazione campi form
    $('#formProgetto').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
    });

    });
</script>

</body>

</html>
