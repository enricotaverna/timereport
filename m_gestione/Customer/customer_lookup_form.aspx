<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Auth.CheckPermission("MASTERDATA", "CUSTOMER")

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

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<script language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<head id="Head1" runat="server">
    <title>Crea Cliente</title>
</head>

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" >

    <form id="FormCliente" runat="server" class="StandardForm">

    <asp:FormView ID="SchedaClienteForm" runat="server" DataKeyNames="CodiceCliente" 
        DataSourceID="CustomerDataSource" DefaultMode="Insert" 
        OnItemInserted="SchedaClienteForm_ItemInserted" 
        OnModeChanging="SchedaClienteForm_ModeChanging"  
        OnItemUpdated="SchedaClienteForm_ItemUpdated"  width="100%">

            <EditItemTemplate>
               
               <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Dati generali</a></li>
                    <li><a href="#tabs-2">Sede Operativa</a></li>
                    <li><a href="#tabs-3">Sede Legale</a></li>
                    <li><a href="#tabs-4">Note</a></li>
                  </ul>

               <div id="tabs-1" style="height:360px;width:100%"> 

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Codice cliente: </div> 
                        <asp:TextBox class="ASPInputcontent" ID="CodiceClienteTextBox" runat="server" Columns="10" 
                                MaxLength="10" Text='<%# Bind("CodiceCliente") %>' Enabled="False" />	
                   
                    <!-- *** CHECK BOX  ***  -->                   
	                    <asp:CheckBox ID="FlagAttivoCheckBox" runat="server" Checked='<%# Bind("FlagAttivo") %>' />
	                    <asp:Label  AssociatedControlId="FlagAttivoCheckBox" runat="server" >Attivo</asp:Label>    
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nome</div> 
                        <asp:TextBox ID="TextBox1" runat="server" class="ASPInputcontent" Text='<%# Bind("Nome1") %>' Columns="30" MaxLength="40"
                                                   data-parsley-errors-container="#valMsg" data-parsley-required="true" />
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Partita Iva </div> 
                       <asp:TextBox class="ASPInputcontent" ID="TextBox3" runat="server" Text='<%# Bind("PIVA") %>' Columns="16" MaxLength="13" />   
               </div>   

                <!-- *** TEXT BOX ***  --> 
                <div class="input ">                 
                    <div class="inputtext">Cod.Fisc.</div>
                    <asp:TextBox class="ASPInputcontent" ID="TextBox4" runat="server" Text='<%# Bind("CodiceFiscale") %>' Columns="16" MaxLength="16" />    
                </div>    
                                          
                <!-- *** SELECT ***  -->
				<div class="input nobottomborder">                        
				        <div class="inputtext">Metodo pag.</div>  
                        <label class="dropdown" style="width:265px" >
                             <asp:DropDownList ID="DropDownList1" runat="server" 
                                DataSourceID="metododipagamento" DataTextField="Descrizione"  AppendDataBoundItems="True" 
                                DataValueField="MetodoPagamento"  
                                SelectedValue='<%# Bind("MetodoPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
                        </label>
                </div>  

                <!-- *** Termini di pagamento ***  -->
				<div class="input">
				        <div class="inputtext">Termini pag.</div>  

				        <label class="dropdown" style="width:265px">
                           <asp:DropDownList ID="DropDownList2" runat="server" 
                                DataSourceID="terminidipagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
                </div>  

                <!-- *** Manager ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager</div>  

				        <label class="dropdown" style="width:265px">
                            <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="Manager" 
                                DataTextField="Name" DataValueField="Persons_id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("ClientManager_id") %>'  
                                 data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                            </asp:DropDownList>
                        </label>
                </div>  

                 </div> <%--tabs-1--%>

               <!-- *** SEDE OPERATIVA ***  --> 
               <div id="tabs-2" style="height:360px;width:100%">
               
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
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nazione</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox11" Text='<%# Bind("SedeLegaleNazione")  %>' runat="server" Columns="20" MaxLength="20" />
               </div> 

               </div> <%--tabs-2--%>

               <!-- *** SEDE LEGALE ***  --> 
               <div id="tabs-3" style="height:360px;width:100%">

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
               
               </div> <%--tab-3--%>
               
                <!-- *** NOTE ***  --> 
               <div id="tabs-4" style="height:360px;width:100%">                 
                                             
                <!-- *** Note ***  --> 
               <div class="input nobottomborder" style="height:220px"> 
                    <div class="inputtext">Note</div> 
                    <asp:TextBox  ID="TextBox22" Text='<%# Bind("Note") %>' runat="server" rows="5" Columns="30" TextMode="MultiLine" CssClass="textarea" /> 
               </div>  
                                                                                       
                </div> <%--tab-3 --%>

                </div> <%--Tab view--%>

            	<!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton"   Text="<%$ appSettings: SAVE_TXT %>" />
                <asp:Button ID="UpdateCancelButton" runat="server" formnovalidate="" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" />               
               </div>               

            </EditItemTemplate>

            <InsertItemTemplate>
    
               <div id="tabs">
               
                  <ul>
                    <li><a href="#tabs-1">Dati generali</a></li>
                    <li><a href="#tabs-2">Sede Operativa</a></li>
                    <li><a href="#tabs-3">Sede Legale</a></li>
                    <li><a href="#tabs-4">Note</a></li>
                  </ul>

               <div id="tabs-1" style="height:360px;width:100%"> 

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Codice cliente: </div> 
                        
                        <asp:TextBox ID="CodiceClienteTextBox" runat="server" class="ASPInputcontent" Columns="10" MaxLength="10" Text='<%# Bind("CodiceCliente") %>' 
                                     data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-trigger-after-failure="focusout" data-parsley-codiceUnico="" />
                   
                        <!-- *** CHECK BOX  ***  -->
	                    <asp:CheckBox ID="FlagAttivoCheckBox" runat="server" Checked='<%# Bind("FlagAttivo") %>' />
	                    <asp:Label  AssociatedControlId="FlagAttivoCheckBox" runat="server" >Attivo</asp:Label>       
                   
                </div>                                

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nome</div> 
                        <asp:TextBox ID="TextBox1" runat="server" class="ASPInputcontent" Text='<%# Bind("Nome1") %>' Columns="30" MaxLength="40" 
                                     data-parsley-errors-container="#valMsg" data-parsley-required="true" />
               </div>   

               <!-- *** TEXT BOX ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Partita Iva </div> 
                       <asp:TextBox class="ASPInputcontent" ID="TextBox3" runat="server" Text='<%# Bind("PIVA") %>' Columns="16" MaxLength="13" />   
               </div>   

                <!-- *** TEXT BOX ***  --> 
                <div class="input ">                 
                    <div class="inputtext">Cod.Fisc.</div>
                    <asp:TextBox class="ASPInputcontent" ID="TextBox4" runat="server" Text='<%# Bind("CodiceFiscale") %>' Columns="16" MaxLength="16" />    
                </div>    
                                          
                <!-- *** SELECT ***  -->
				<div class="input nobottomborder">                        
				        <div class="inputtext">Metodo pag.</div>  
                        <label class="dropdown" style="width:265px" >
                             <asp:DropDownList ID="DropDownList1" runat="server" 
                                DataSourceID="metododipagamento" DataTextField="Descrizione"  AppendDataBoundItems="True" 
                                DataValueField="MetodoPagamento"  
                                SelectedValue='<%# Bind("MetodoPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
                        </label>
                </div>  

                <!-- *** Termini di pagamento ***  -->
				<div class="input ">
				        <div class="inputtext">Termini pag.</div>  

				        <label class="dropdown" style="width:265px">
                           <asp:DropDownList ID="DropDownList2" runat="server" 
                                DataSourceID="terminidipagamento" DataTextField="Descrizione" 
                                DataValueField="TerminiPagamento"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("TerminiPagamento") %>' >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
				        </label>
                </div>  

                <!-- *** Manager ***  -->
				<div class="input nobottomborder">
				        <div class="inputtext">Manager</div>  

				        <label class="dropdown" class="dropdown" style="width:265px">
                            <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="Manager" 
                                DataTextField="Name" DataValueField="Persons_id"  AppendDataBoundItems="True" 
                                SelectedValue='<%# Bind("ClientManager_id") %>' 
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                <asp:ListItem  Value="" Text="Selezionare un valore"/>
                            </asp:DropDownList>
 				        </label>
                </div>  

                 </div> <%--tabs-1--%>

               <!-- *** SEDE OPERTIVA ***  --> 
               <div id="tabs-2" style="height:360px;width:100%">
               
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
               <div class="input nobottomborder"> 
                    <div class="inputtext">Nazione</div> 
                        <asp:TextBox class="ASPInputcontent" ID="TextBox11" Text='<%# Bind("SedeLegaleNazione")  %>' runat="server" Columns="20" MaxLength="20" />
               </div> 

               </div> <%--tabs-2--%>

               <!-- *** SEDE LEGALE ***  --> 
               <div id="tabs-3" style="height:360px;width:100%">

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
               
               </div> <%--tab-3--%>
               
                <!-- *** NOTE ***  --> 
               <div id="tabs-4" style="height:360px;width:100%">                 
                                             
                <!-- *** Note ***  --> 
               <div class="input nobottomborder"> 
                    <div class="inputtext">Note</div> 
                    <asp:TextBox  ID="TextBox22" Text='<%# Bind("Note") %>' runat="server" rows="5" Columns="30" TextMode="MultiLine" CssClass="textarea" /> 
               </div>  
                                                                                       
                </div> <%--tab-3 --%>

                </div> <%--Tab view--%>

               <!-- *** BOTTONI  ***  -->
               <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"/>
                <asp:Button ID="InsertCancelButton" runat="server" formnovalidate="" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" />               
               </div>   

            </InsertItemTemplate>

            <ItemTemplate>
            <!-- NON NECESSARIO -->
            </ItemTemplate>

        </asp:FormView>

    </form>     

  </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(Now())  %></div> 
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
     </div>  

<script type="text/javascript">
$(function () {

    $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET
   
    $("#tabs").tabs(); // abilitate tab view

    // *** controllo che non esista lo stesso codice utente *** //
    window.Parsley.addValidator('codiceunico', function (value, requirement) {
        var response = false;
        var dataAjax = "{ sKey: 'CodiceCliente', " +
                       " sValkey: '" + value  + "', " + 
                       " sTable: 'Customers'  }";

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
        .addMessage('en', 'codiceunico', 'Customer code already exists')
        .addMessage('it', 'codiceunico', 'Codice cliente già esistente');

    // *** Esclude i controlli nascosti *** 
    $('#FormCliente').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
    });

});
</script>

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
