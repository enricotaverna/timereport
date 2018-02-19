<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Auth.CheckPermission("MASTERDATA", "CUSTOMER")

        ' Evidenzia campi form in errore
        Page.ClientScript.RegisterOnSubmitStatement(Me.GetType, "val", "fnOnUpdateValidators();")

        If (Not IsPostBack) Then
            If Len(Request.QueryString("CodiceCliente")) > 0 Then
                SchedaClienteForm.ChangeMode(FormViewMode.Edit)
                SchedaClienteForm.DefaultMode = FormViewMode.Edit
            End If
        End If

    End Sub

    Protected Sub SchedaClienteForm_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs)
        Response.Redirect("customer_lookup_list.aspx")
    End Sub

    Protected Sub SchedaClienteForm_ModeChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewModeEventArgs)
        If (e.CancelingEdit = True) Then
            Response.Redirect("customer_lookup_list.aspx")
        End If
    End Sub

    Protected Sub SchedaClienteForm_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs)
        Response.Redirect("customer_lookup_list.aspx")
    End Sub

    Sub ValidaCliente_ServerValidate(ByVal sender As Object, ByVal args As ServerValidateEventArgs)

        Dim c = New ValidationClass
        ' true se non esiste già il record
        args.IsValid = Not c.CheckExistence("CodiceCliente", args.Value, "Customers")

        ' Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, SchedaClienteForm, "CodiceClienteTextBox")

    End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Crea Cliente</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
</head>
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>  

 <!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script src="/timereport/include/jquery/jquery-ui.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>  

<script>
$(function () {

    $("#SchedaClienteForm_FlagAttivoCheckBox").addClass("css-checkbox");
    $("#SchedaClienteForm_disFlagAttivoCheckBox").addClass("css-checkbox");
    $("#SchedaClienteForm_disFlagAttivoCheckBox").attr("disabled", true);

    // abilitate tab view
    $("#tabs").tabs();

    // gestione validation summary su validator custom (richiede timereport.js)//
    displayAlert();

});
</script>

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" style="width:485px">

    <form id="form1" runat="server" class="StandardForm" >

    <asp:FormView ID="SchedaClienteForm" runat="server" DataKeyNames="CodiceCliente" 
        DataSourceID="CustomerDataSource" DefaultMode="Insert" 
        OnItemInserted="SchedaClienteForm_ItemInserted" 
        OnModeChanging="SchedaClienteForm_ModeChanging"  
        OnItemUpdated="SchedaClienteForm_ItemUpdated" >

            <EditItemTemplate>
               
               <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Dati generali</a></li>
                    <li><a href="#tabs-2">Sede</a></li>
                    <li><a href="#tabs-3">Note</a></li>
                  </ul>

               <div id="tabs-1" style="height:460px;width:100%"> 

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Codice cliente: </div> 
                        <asp:TextBox class="ASPInputcontent" ID="CodiceClienteTextBox" runat="server" Columns="10" 
                                MaxLength="10" Text='<%# Bind("CodiceCliente") %>' Enabled="False" />					
                        <asp:CheckBox  ID="FlagAttivoCheckBox" runat="server"  Checked='<%# Bind("FlagAttivo") %>' />
					    <asp:Label  AssociatedControlId="FlagAttivoCheckBox" class="css-label" ID="Label3" runat="server" Text="Trasferta">Attivo</asp:Label>      
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nome</div> 
                        <asp:TextBox ID="TextBox1" runat="server" class="ASPInputcontent" Text='<%# Bind("Nome1") %>' Columns="30" MaxLength="40" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Inserire il nome del cliente" ControlToValidate="TextBox1" Display="none"></asp:RequiredFieldValidator>                    
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Partita Iva </div> 
                       <asp:TextBox class="ASPInputcontent" ID="TextBox3" runat="server" Text='<%# Bind("PIVA") %>' Columns="16" MaxLength="13" />   
               </div>   

                <!-- *** TEXT BOX ***  --> 
                <div class="input nobottomborder">                 
                    <div class="inputtext">Cod.Fisc.</div>
                    <asp:TextBox class="ASPInputcontent" ID="TextBox4" runat="server" Text='<%# Bind("CodiceFiscale") %>' Columns="16" MaxLength="16" />    
                </div>    
                                          
                <!-- *** SELECT ***  -->
				<div class="input nobottomborder">                        
				        <div class="inputtext">Metodo pag.</div>  
                        <div class="InputcontentDDL" style="width:265px" >
                             <asp:DropDownList ID="DropDownList1" runat="server" 
                                DataSourceID="metododipagamento" DataTextField="Descrizione"  AppendDataBoundItems="True" 
                                DataValueField="MetodoPagamento"  
                                SelectedValue='<%# Bind("MetodoPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
                        </div>
                </div>  

                <!-- *** Termini di pagamento ***  -->
				<div class="input ">
				        <div class="inputtext">Termini pag.</div>  

				        <div class="InputcontentDDL" style="width:265px">
                           <asp:DropDownList ID="DropDownList2" runat="server" 
                                DataSourceID="terminidipagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </div>
                </div>  

                <!-- *** Manager ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager</div>  

				        <div class="InputcontentDDL" style="width:265px">
                            <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="Manager" 
                                DataTextField="Name" DataValueField="Persons_id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("ClientManager_id") %>'  >
                            </asp:DropDownList>
                        </div>
                </div>  

                 </div> <%--tabs-1--%>

               <!-- *** SEDE LEGALE ***  --> 
               <div id="tabs-2" style="height:460px;width:100%">
               
                <!-- *** Via ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Sede</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox5" runat="server" text='<%# Bind("SedeLegaleVia1") %>' Columns="30" MaxLength="50" />               
               </div>      
                    
                <!-- *** Città ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Città</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox9" runat="server" Text='<%# Bind("SedeLegaleCitta") %>' Columns="30" MaxLength="30" />         
               </div> 

                <!-- *** CAP/Prov. ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">CAP/Prov.</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox8" runat="server" Text='<%# Bind("SedeLegaleCAP") %>' Columns="10" MaxLength="10" /> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox7" runat="server" Columns="3" MaxLength="3" Text='<%# Bind("SedeLegaleProv") %>' />  
               </div> 

               <!-- *** Nazione ***  --> 
               <div class="input"> 
                    <div class="inputtext">Nazione</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox11" Text='<%# Bind("SedeLegaleNazione")  %>' runat="server" Columns="20" MaxLength="20" />
               </div> 

                <!-- *** Via ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Sede legale</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox13" runat="server" Text='<%# Bind("SedeOperativaVia1") %>' Columns="30" MaxLength="50" />
               </div>   

                <!-- *** Città ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Città</div> 
                    <asp:TextBox  class="ASPInputcontent" ID="TextBox17" runat="server" Text='<%# Bind("SedeOperativaCitta") %>' Columns="30" MaxLength="30" />
               </div>   

                <!-- *** CAP/Prov. ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">CAP/Prov.</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox16" runat="server" Text='<%# Bind("SedeOperativaCAP") %>' Columns="10" MaxLength="10" />
                    <asp:TextBox class="ASPInputcontent" ID="TextBox15" runat="server" Columns="3" MaxLength="3" Text='<%# Bind("SedeOperativaProv") %>' />
               </div>   

                <!-- *** Nazione ***  --> 
               <div class="input nobottomborder"> 
                    <span class="inputtext" >Nazione</span> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox12" runat="server" Text='<%# Bind("SedeOperativaNazione") %>' Columns="20" MaxLength="20" />
               </div> 
               
               </div> <%--tab-2--%>
               
                <!-- *** NOTE ***  --> 
               <div id="tabs-3" style="height:460px;width:100%">                 
                                             
                <!-- *** Note ***  --> 
               <div class="input nobottomborder" style="height:220px"> 
                    <div class="inputtext">Note</div> 
                    <asp:TextBox  ID="TextBox22" Text='<%# Bind("Note") %>' runat="server" rows=5 Columns="30" TextMode="MultiLine" CssClass="textarea" /> 
               </div>  
                                                                                       
                </div> <%--tab-3 --%>

                </div> <%--Tab view--%>

            	<!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton"   Text="<%$ appSettings: SAVE_TXT %>" />
                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" />               
               </div>               

            </EditItemTemplate>

            <InsertItemTemplate>
    
               <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Dati generali</a></li>
                    <li><a href="#tabs-2">Sede</a></li>
                    <li><a href="#tabs-3">Note</a></li>
                  </ul>

               <div id="tabs-1" style="height:460px;width:100%"> 

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Codice cliente: </div> 
                        
                        <asp:TextBox ID="CodiceClienteTextBox" runat="server" class="ASPInputcontent" Columns="10" MaxLength="10" Text='<%# Bind("CodiceCliente") %>' />
                        <asp:CheckBox  ID="FlagAttivoCheckBox" runat="server"  Checked='<%# Bind("FlagAttivo") %>' />
					    <asp:Label  AssociatedControlId="FlagAttivoCheckBox" class="css-label" ID="Label3" runat="server" Text="Trasferta">Attivo</asp:Label> 
                
                        <asp:CustomValidator ID="ValidaCliente" runat="server"  ErrorMessage="Codice cliente già esistente" Display="none" OnServerValidate="ValidaCliente_ServerValidate" ControlToValidate="CodiceClienteTextBox"></asp:CustomValidator>   
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="CodiceClienteTextBox" Display="none" ErrorMessage="Inserire il codice cliente"></asp:RequiredFieldValidator>

                </div>                   
                

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nome</div> 
                        <asp:TextBox ID="TextBox1" runat="server" class="ASPInputcontent" Text='<%# Bind("Nome1") %>' Columns="30" MaxLength="40" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Inserire il nome del cliente" style="float:none" ControlToValidate="TextBox1" Display="none"></asp:RequiredFieldValidator>                    
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Partita Iva </div> 
                       <asp:TextBox class="ASPInputcontent" ID="TextBox3" runat="server" Text='<%# Bind("PIVA") %>' Columns="16" MaxLength="13" />   
               </div>   

                <!-- *** TEXT BOX ***  --> 
                <div class="input nobottomborder">                 
                    <div class="inputtext">Cod.Fisc.</div>
                    <asp:TextBox class="ASPInputcontent" ID="TextBox4" runat="server" Text='<%# Bind("CodiceFiscale") %>' Columns="16" MaxLength="16" />    
                </div>    
                                          
                <!-- *** SELECT ***  -->
				<div class="input nobottomborder">                        
				        <div class="inputtext">Metodo pag.</div>  
                        <div class="InputcontentDDL" style="width:265px" >
                             <asp:DropDownList ID="DropDownList1" runat="server" 
                                DataSourceID="metododipagamento" DataTextField="Descrizione"  AppendDataBoundItems="True" 
                                DataValueField="MetodoPagamento"  
                                SelectedValue='<%# Bind("MetodoPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
                        </div>
                </div>  

                <!-- *** Termini di pagamento ***  -->
				<div class="input ">
				        <div class="inputtext">Termini pag.</div>  

				        <div class="InputcontentDDL" style="width:265px">
                           <asp:DropDownList ID="DropDownList2" runat="server" 
                                DataSourceID="terminidipagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </div>
                </div>  

                <!-- *** Manager ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager</div>  

				        <div class="InputcontentDDL" style="width:265px">
                            <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="Manager" 
                                DataTextField="Name" DataValueField="Persons_id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("ClientManager_id") %>'  >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
 				        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Selezionare nome manager" ControlToValidate="DropDownList3" Display="None"></asp:RequiredFieldValidator>
                </div>  

                 </div> <%--tabs-1--%>

               <!-- *** SEDE LEGALE ***  --> 
               <div id="tabs-2" style="height:460px;width:100%">
               
                <!-- *** Via ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Via</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox5" runat="server" text='<%# Bind("SedeLegaleVia1") %>' Columns="30" MaxLength="50" />               
               </div>      
                    
                <!-- *** Città ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Città</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox9" runat="server" Text='<%# Bind("SedeLegaleCitta") %>' Columns="30" MaxLength="30" />         
               </div> 

                <!-- *** CAP/Prov. ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">CAP/Prov.</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox8" runat="server" Text='<%# Bind("SedeLegaleCAP") %>' Columns="10" MaxLength="10" /> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox7" runat="server" Columns="3" MaxLength="3" Text='<%# Bind("SedeLegaleProv") %>' />  
               </div> 

               <!-- *** Nazione ***  --> 
               <div class="input"> 
                    <div class="inputtext">Nazione</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox11" Text='<%# Bind("SedeLegaleNazione")  %>' runat="server" Columns="20" MaxLength="20" />
               </div> 

               <div class="input nobottomborder"> 
               <div class="inputtext" style="font-weight:bold">Sede legale</div> 
               </div>

                <!-- *** Via ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Via</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox13" runat="server" Text='<%# Bind("SedeOperativaVia1") %>' Columns="30" MaxLength="50" />
               </div>   

                <!-- *** Città ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Città</div> 
                    <asp:TextBox  class="ASPInputcontent" ID="TextBox17" runat="server" Text='<%# Bind("SedeOperativaCitta") %>' Columns="30" MaxLength="30" />
               </div>   

                <!-- *** CAP/Prov. ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">CAP/Prov.</div> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox16" runat="server" Text='<%# Bind("SedeOperativaCAP") %>' Columns="10" MaxLength="10" />
                    <asp:TextBox class="ASPInputcontent" ID="TextBox15" runat="server" Columns="3" MaxLength="3" Text='<%# Bind("SedeOperativaProv") %>' />
               </div>   

                <!-- *** Nazione ***  --> 
               <div class="input nobottomborder"> 
                    <span class="inputtext" >Nazione</span> 
                    <asp:TextBox class="ASPInputcontent" ID="TextBox12" runat="server" Text='<%# Bind("SedeOperativaNazione") %>' Columns="20" MaxLength="20" />
               </div> 
               
               </div> <%--tab-2--%>
               
                <!-- *** NOTE ***  --> 
               <div id="tabs-3" style="height:460px;width:100%">                 
                                             
                <!-- *** Note ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Note</div> 
                    <asp:TextBox  ID="TextBox22" Text='<%# Bind("Note") %>' runat="server" Columns="30" TextMode="MultiLine" CssClass="textarea" /> 
               </div>  
                                                                                       
                </div> <%--tab-3 --%>

                </div> <%--Tab view--%>

               <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"/>
                <asp:Button ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" />               
               </div>   

            </InsertItemTemplate>

            <ItemTemplate>
            <!-- NON NECESSARIO -->
            </ItemTemplate>

        </asp:FormView>

        <asp:ValidationSummary ID="VSValidator" runat="server" ShowMessageBox="True" ShowSummary="false"  />

    </form>     

  </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
     </div>  

</body>
      <asp:SqlDataSource ID="CustomerDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            DeleteCommand="DELETE FROM [Customers] WHERE [CodiceCliente] = @CodiceCliente" 
            InsertCommand="INSERT INTO [Customers] ([CodiceCliente], [Nome1], [PIVA], [FlagAttivo], [CodiceFiscale], [SedeLegaleVia1], [SedeLegaleCitta], [SedeLegaleProv], [SedeLegaleCAP], [SedeLegaleNazione], [SedeOperativaVia1], [SedeOperativaCitta], [SedeOperativaProv], [SedeOperativaCAP], [SedeOperativaNazione], [MetodoPagamento], [TerminiPagamento], [ClientManager_id], [Note]) VALUES (@CodiceCliente, @Nome1, @PIVA, @FlagAttivo, @CodiceFiscale, @SedeLegaleVia1, @SedeLegaleCitta, @SedeLegaleProv, @SedeLegaleCAP, @SedeLegaleNazione, @SedeOperativaVia1, @SedeOperativaCitta, @SedeOperativaProv, @SedeOperativaCAP, @SedeOperativaNazione, @MetodoPagamento, @TerminiPagamento, @ClientManager_id, @Note)" 
            SelectCommand="SELECT * FROM [Customers] WHERE ([CodiceCliente] = @CodiceCliente)" 
            UpdateCommand="UPDATE [Customers] SET [Nome1] = @Nome1, [PIVA] = @PIVA, [FlagAttivo] = @FlagAttivo, [CodiceFiscale] = @CodiceFiscale, [SedeLegaleVia1] = @SedeLegaleVia1, [SedeLegaleCitta] = @SedeLegaleCitta, [SedeLegaleProv] = @SedeLegaleProv, [SedeLegaleCAP] = @SedeLegaleCAP, [SedeLegaleNazione] = @SedeLegaleNazione, [SedeOperativaVia1] = @SedeOperativaVia1, [SedeOperativaCitta] = @SedeOperativaCitta, [SedeOperativaProv] = @SedeOperativaProv, [SedeOperativaCAP] = @SedeOperativaCAP, [SedeOperativaNazione] = @SedeOperativaNazione, [MetodoPagamento] = @MetodoPagamento, [TerminiPagamento] = @TerminiPagamento, [ClientManager_id] = @ClientManager_id, [Note] = @Note WHERE [CodiceCliente] = @CodiceCliente">
            <SelectParameters>
                <asp:QueryStringParameter Name="CodiceCliente" 
                    QueryStringField="CodiceCliente" Type="String" />
            </SelectParameters>
            <DeleteParameters>
                <asp:Parameter Name="CodiceCliente" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Nome1" Type="String" />
                <asp:Parameter Name="PIVA" Type="String" />
                <asp:Parameter Name="FlagAttivo" Type="Boolean" />
                <asp:Parameter Name="CodiceFiscale" Type="String" />
                <asp:Parameter Name="SedeLegaleVia1" Type="String" />
                <asp:Parameter Name="SedeLegaleCitta" Type="String" />
                <asp:Parameter Name="SedeLegaleProv" Type="String" />
                <asp:Parameter Name="SedeLegaleCAP" Type="String" />
                <asp:Parameter Name="SedeLegaleNazione" Type="String" />
                <asp:Parameter Name="SedeOperativaVia1" Type="String" />
                <asp:Parameter Name="SedeOperativaCitta" Type="String" />
                <asp:Parameter Name="SedeOperativaProv" Type="String" />
                <asp:Parameter Name="SedeOperativaCAP" Type="String" />
                <asp:Parameter Name="SedeOperativaNazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="Note" Type="String" />
                <asp:Parameter Name="CodiceCliente" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="CodiceCliente" Type="String" />
                <asp:Parameter Name="Nome1" Type="String" />
                <asp:Parameter Name="PIVA" Type="String" />
                <asp:Parameter Name="FlagAttivo" Type="Boolean" />
                <asp:Parameter Name="CodiceFiscale" Type="String" />
                <asp:Parameter Name="SedeLegaleVia1" Type="String" />
                <asp:Parameter Name="SedeLegaleCitta" Type="String" />
                <asp:Parameter Name="SedeLegaleProv" Type="String" />
                <asp:Parameter Name="SedeLegaleCAP" Type="String" />
                <asp:Parameter Name="SedeLegaleNazione" Type="String" />
                <asp:Parameter Name="SedeOperativaVia1" Type="String" />
                <asp:Parameter Name="SedeOperativaCitta" Type="String" />
                <asp:Parameter Name="SedeOperativaProv" Type="String" />
                <asp:Parameter Name="SedeOperativaCAP" Type="String" />
                <asp:Parameter Name="SedeOperativaNazione" Type="String" />
                <asp:Parameter Name="MetodoPagamento" Type="String" />
                <asp:Parameter Name="TerminiPagamento" Type="String" />
                <asp:Parameter Name="ClientManager_id" Type="Int32" />
                <asp:Parameter Name="Note" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="metododipagamento" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [MetodoPagamento]"></asp:SqlDataSource>
        
        <asp:SqlDataSource ID="terminidipagamento" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [TerminiPagamento]"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Manager" runat="server" 
                                ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
                                
                                SelectCommand="SELECT [Persons_id], [Name] FROM [Persons] WHERE ([Active] = @Active)">
                                <SelectParameters>
                                    <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
                                </SelectParameters>
                            </asp:SqlDataSource>
</html>
