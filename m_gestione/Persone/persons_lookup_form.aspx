<%@ Page Language="C#" AutoEventWireup="true" CodeFile="persons_lookup_form.aspx.cs" Inherits="persons_lookup_form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script> 

<script>
    $(function () {

        // abilitate tab view
        $("#tabs").tabs();

        $("#FVPersone_CBAttivo").addClass("css-checkbox");
        $("#FVPersone_CBForzato").addClass("css-checkbox");
        $("#FVPersone_CBBetaTester").addClass("css-checkbox");
        $("#FVPersone_CBEscludiControlloEconomics").addClass("css-checkbox");
        //$("#FVPersone_CBCartaCreditoAziendale").addClass("css-checkbox");

        $("#FVPersone_TBAttivoDa").datepicker($.datepicker.regional['it']);
        $("#FVPersone_TBAttivoFino").datepicker($.datepicker.regional['it']);

        // validation summary su validator custom
        displayAlert();

    });
</script>

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Persone</title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" >

    <form id="form1" runat="server"  >

        <asp:FormView ID="FVPersone" runat="server" DataSourceID="DSPersone" DataKeyNames="Persons_id" 
            EnableModelValidation="True" DefaultMode="Insert" CssClass="StandardForm" onmodechanging="FVPersone_ModeChanging"
            oniteminserted="FVPersone_ItemInserted" onitemupdated="FVPersone_ItemUpdated" width="100%" >
            
            <EditItemTemplate>
                <div id="tabs">         
                      
                  <ul>
                    <li><a href="#tabs-1">Dati anagrafici</a></li>
                    <li><a href="#tabs-2">Ruolo</a></li>
                    <li><a href="#tabs-3">Tariffa</a></li>
                  </ul>

                <div id="tabs-1" style="height:460px;width:100%">  
                
                    <!-- *** NOME  ***  -->
                    <div class="input">
                        <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Nome:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNome" runat="server" Text='<%# Bind("Name") %>' MaxLength="50" />
                        <asp:RequiredFieldValidator ErrorMessage = "Inserire il nome della persona" ID="RequiredFieldValidator1" runat="server" Display="None" ControlToValidate="TBNome" ></asp:RequiredFieldValidator>
                    </div>             
                
                    <!-- *** ATTIVO DA  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Attivo da:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage = "Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("attivo_da","{0:d}") %>' MaxLength="10" Rows="12" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TBAttivoDa" ErrorMessage="Inserire data inizio attività" Display="None"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="RangeValidator1" runat="server" 
                            ControlToValidate="TBAttivoDa" Display="none" 
                            ErrorMessage="Formato data inizio attività non corretto" MaximumValue="31/12/9999" 
                            MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
                    </div>

                    <!-- *** ATTIVO FINO  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label2" CssClass="inputtext" runat="server" Text="Attivo a:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoFino" runat="server" Text='<%# Bind("attivo_fino","{0:d}") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ErrorMessage = "Inserire data fine" runat="server" ControlToValidate="TBAttivoFino" Display="none"  ></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TBAttivoDa" ErrorMessage="Inserire data fine attività" Display="None"   ValidationGroup="inline"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="RangeValidator2" runat="server" 
                            ControlToValidate="TBAttivoFino" Display="None" 
                            ErrorMessage="Formato data fine attività non corretto" MaximumValue="31/12/9999" 
                            MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
                    </div>

                    <!-- *** ATTIVO CHECK  ***  -->
                    <div class="input">
                        <asp:Label ID="Label17" CssClass="inputtext" runat="server" Text=""></asp:Label>
                        <asp:CheckBox  ID="CBAttivo" runat="server"  Checked='<%# Bind("active") %>' />
					    <asp:Label  AssociatedControlId="CBAttivo" class="css-label" ID="Label3" runat="server">Attivo</asp:Label>
                    </div>                    
                    
                    <!-- *** USERID ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label9" CssClass="inputtext" runat="server" Text="Userd Id:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBUserid" runat="server" Text='<%# Bind("Userid") %>' MaxLength="20" Enabled="False" />
                    </div>

                    <!-- *** PASSWORD ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="label24" CssClass="inputtext" runat="server" Text="Password:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" Text='<%# Bind("password") %>' MaxLength="10" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="TBpassword" ErrorMessage="Inserire password" Display="none"  ></asp:RequiredFieldValidator>
                    </div>

                    <!-- *** USER LEVEL ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label10" CssClass="inputtext" runat="server" Text="Livello utente:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLLivelloUtente" runat="server" DataSourceID="DSLivelloUtente" 
                                DataTextField="Name" DataValueField="UserLevel_id" 
                                SelectedValue='<%# bind("UserLevel_id") %>' AppendDataBoundItems="True">
                            </asp:DropDownList>
                        </div>      
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="Inserire livello utente" Display="none" ControlToValidate="DDLLivelloUtente"></asp:RequiredFieldValidator>
                    </div>

                    <!-- *** LINGUA ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text="Lingua:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLLingua" runat="server"  
                                SelectedValue='<%# bind("Lingua") %>' AppendDataBoundItems="True">
                               <asp:ListItem  Value="it" Text="Italiano"/>
                               <asp:ListItem  Value="en" Text="Inglese"/>
                            </asp:DropDownList>
                        </div>      
                        <asp:CustomValidator ID="CVLingua" runat="server" Display="none" ErrorMessage="Lingua inglese supportata solo per utenti esterni" OnServerValidate="ValidaLingua_ServerValidate" ControlToValidate="DDLLingua"></asp:CustomValidator>  
                    </div>

                    <!-- *** Account forzato  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label7" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBForzato" runat="server"  Checked='<%# Bind("ForcedAccount") %>' />
					    <asp:Label  AssociatedControlId="CBForzato" class="css-label" ID="Label8" runat="server">Conti forzati</asp:Label>
                     </div>
                    
                </div> <!-- *** TAB 1 ***  -->

                <div id="tabs-2" style="height:400px;width:100%">  

                    <!-- *** NICKNAME  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label13" CssClass="inputtext" runat="server" Text="Nickname:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNickname" runat="server" Text='<%# Bind("nickname") %>' Columns="6" MaxLength="5" />
                    </div>

                    <!-- *** MAIL  ***  -->
                    <div class="input">
                        <asp:Label ID="Label14" CssClass="inputtext" runat="server" Text="Mail:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBMail" runat="server" Text='<%# Bind("mail") %>' />
                    </div>

                    <!-- *** RUOLO ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label15" CssClass="inputtext" runat="server" Text="Ruolo:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLRuolo" runat="server" DataSourceID="DSRouli" DataTextField="Name" DataValueField="Roles_Id" SelectedValue='<%# bind("roles_id") %>' AppendDataBoundItems="True">
                            </asp:DropDownList>
                        </div>      

                    </div>

                    <!-- *** SOCIETA ***  -->
                    <div class="input">
                        <asp:Label ID="Label16" CssClass="inputtext" runat="server" Text="Società:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLSocieta" runat="server" DataSourceID="DSSocieta" 
                                DataTextField="Name" DataValueField="Company_id" 
                                SelectedValue='<%# bind("company_id") %>' AppendDataBoundItems="True">
                            </asp:DropDownList>
                        </div>      
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Inserire società" Display="none" ControlToValidate="DDLSocieta" ></asp:RequiredFieldValidator>
                    </div>

                    <!-- *** PROFILO SPESE ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label11" CssClass="inputtext" runat="server" Text="Profilo spese:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLProfiloSpese" runat="server" DataSourceID="DSProfiloSpese" 
                                DataTextField="Name" DataValueField="ExpensesProfile_id" 
                                SelectedValue='<%# bind("ExpensesProfile_id") %>' AppendDataBoundItems="True">
                                <asp:ListItem  Value="0" Text="Seleziona un valore"/>
                            </asp:DropDownList>
                        </div>      
                    </div>
                    
                    <!-- *** BetaTester  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBBetaTester" runat="server"  Checked='<%# Bind("BetaTester") %>' />
					    <asp:Label  AssociatedControlId="CBBetaTester" class="css-label" ID="Label6" runat="server">Beta Tester</asp:Label>
                     </div>
                    
                    <%--                    <!-- *** Carta credito aziendale  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBCartaCreditoAziendale" runat="server"  Checked='<%# Bind("CartaCreditoAziendale") %>' />
					    <asp:Label  AssociatedControlId="CBCartaCreditoAziendale" class="css-label" ID="Label21" runat="server">Carta credito aziendale</asp:Label>
                     </div>--%>

                </div> <!-- *** TAB 2 ***  -->

                <div id="tabs-3" style="height:400px;width:100%">  

<%--                    <!-- *** FLC  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="FLC:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBFullLoadedCost" runat="server" Text='<%# Bind("FullLoadedCost") %>' />
                    </div>--%>

<%--                    <!-- *** List price  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label6" CssClass="inputtext" runat="server" Text="Tariffa:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBListprice" runat="server" Text='<%# Bind("Listprice") %>' />
                    </div>--%>

                    <!-- *** ORE CONTRATTO ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label12" CssClass="inputtext" runat="server" Text="Ore contratto:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBContractHours" runat="server" Text='<%# Bind("ContractHours") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="TBContractHours" ErrorMessage="Inserire ore contratto" Display="none"></asp:RequiredFieldValidator>
                    </div>

                   <!-- *** Escludi da controllo economics  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label18" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBEscludiControlloEconomics" runat="server"  Checked='<%# Bind("EscludiControlloEconomics") %>' />
					    <asp:Label  AssociatedControlId="CBEscludiControlloEconomics" class="css-label" ID="Label19" runat="server">Escludi da economics</asp:Label>
                     </div>

                    <!-- *** Note ***  -->
            	    <div class="input nobottomborder"> 
	                    <div class="inputtext">Note</div> 
	                    <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea"/> 
	                </div> 

                </div> <!-- *** TAB 3 ***  -->

                </div>  <!-- *** TABS ***  -->  
               
                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                     <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton"  Text="<%$ appSettings: SAVE_TXT %>"/>
                     <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" />               
                </div>    

            </EditItemTemplate>
            
            <InsertItemTemplate>

                <div id="tabs">         
                      
                  <ul>
                    <li><a href="#tabs-1">Dati anagrafici</a></li>
                    <li><a href="#tabs-2">Ruolo</a></li>
                    <li><a href="#tabs-3">Tariffa</a></li>
                  </ul>

                <div id="tabs-1" style="height:460px;width:100%">  
                
                    <!-- *** NOME  ***  -->
                    <div class="input">
                        <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Nome:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNome" runat="server" Text='<%# Bind("Name") %>' MaxLength="50" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Inserire il nome" Display="None" ControlToValidate="TBNome" ></asp:RequiredFieldValidator>
                    </div>             
                
                    <!-- *** ATTIVO INIZIO  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Attivo da:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoDa" runat="server" Text='<%# Bind("attivo_da","{0:d}") %>' MaxLength="10" Rows="12" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="TBAttivoDa" ErrorMessage="Inserire data da" Display="None"   ></asp:RequiredFieldValidator>                           
                        <asp:RangeValidator ID="RVAttivoDa" runat="server" 
                            ControlToValidate="TBAttivoDa" Display="none" 
                            ErrorMessage="Formato data inizio attività non corretto" MaximumValue="31/12/9999" 
                            MinimumValue="01/01/2000" Type="Date"  ></asp:RangeValidator>
                    </div>

                    <!-- *** ATTIVO FINE  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label2" CssClass="inputtext" runat="server" Text="Attivo a:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoFino" runat="server" Text='<%# Bind("attivo_fino","{0:d}") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="TBAttivoFino" ErrorMessage="Inserire data a" Display="none"  ></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator2" runat="server" 
                            ControlToValidate="TBAttivoFino" Display="none" 
                            ErrorMessage="Formato data fine attività non corretto" MaximumValue="31/12/9999" 
                            MinimumValue="01/01/2000" Type="Date"></asp:RangeValidator>
                    </div>

                    <!-- *** ATTIVO CHECK  ***  -->
                    <div class="input">
                        <asp:Label ID="Label17" CssClass="inputtext" runat="server" Text=""></asp:Label>
                        <asp:CheckBox  ID="CBAttivo" runat="server"  Checked='<%# Bind("active") %>' />
					    <asp:Label  AssociatedControlId="CBAttivo" class="css-label" ID="Label3" runat="server">Attivo</asp:Label>
                    </div>                    
                    
                    <!-- *** USERID ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label9" CssClass="inputtext" runat="server" Text="Userd Id:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBUserid" runat="server" Text='<%# Bind("Userid") %>' MaxLength="20" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="TBUserid" ErrorMessage="Inserire User Id" Display="none" ></asp:RequiredFieldValidator>
                        <asp:CustomValidator ID="ValidaUserid" runat="server" Display="none" ErrorMessage="Codice utente già utilizzato" OnServerValidate="ValidaUserid_ServerValidate" ControlToValidate="TBUserid"></asp:CustomValidator>  
                    </div>

                    <!-- *** PASSWORD ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="label24" CssClass="inputtext" runat="server" Text="Password:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" Text='<%# Bind("password") %>' MaxLength="10" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="TBpassword" ErrorMessage="Inserire password" Display="none"  ></asp:RequiredFieldValidator>
                    </div>
                    
                <!-- *** USER LEVEL ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label10" CssClass="inputtext" runat="server" Text="Livello utente:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLLivelloUtente" runat="server" DataSourceID="DSLivelloUtente" 
                                DataTextField="Name" AppendDataBoundItems="True" DataValueField="UserLevel_id" SelectedValue='<%# bind("UserLevel_id") %>'  >
                                <asp:ListItem  Value="" Text="Seleziona un valore"/>
                            </asp:DropDownList>
                        </div>      
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ErrorMessage="Inserire livello autorizzazione" Display="none" ControlToValidate="DDLLivelloUtente"></asp:RequiredFieldValidator>
                    </div>

                     <!-- *** LINGUA ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text="Lingua:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLLingua" runat="server"  
                                SelectedValue='<%# bind("Lingua") %>' AppendDataBoundItems="True">
                               <asp:ListItem  Value="it" Text="Italiano"/>
                               <asp:ListItem  Value="en" Text="Inglese"/>
                            </asp:DropDownList>
                        </div>      
                        <asp:CustomValidator ID="CVLingua" runat="server" Display="none" ErrorMessage="Lingua inglese supportata solo per utenti esterni" OnServerValidate="ValidaLingua_ServerValidate" ControlToValidate="DDLLingua"></asp:CustomValidator>  
                    </div>
                    
                    <!-- *** Account forzato  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label7" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBForzato" runat="server"  Checked='<%# Bind("ForcedAccount") %>' />
					    <asp:Label  AssociatedControlId="CBForzato" class="css-label" ID="Label8" runat="server">Conti forzati</asp:Label>
                     </div>

                </div> <!-- *** TAB 1 ***  -->

                <div id="tabs-2" style="height:400px;width:100%">  

                    <!-- *** NICKNAME  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label13" CssClass="inputtext" runat="server" Text="Nickname:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNickname" runat="server" Text='<%# Bind("nickname") %>' Columns="6" MaxLength="5" />
                    </div>

                    <!-- *** MAIL  ***  -->
                    <div class="input">
                        <asp:Label ID="Label14" CssClass="inputtext" runat="server" Text="Mail:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBMail" runat="server" Text='<%# Bind("mail") %>' />
                    </div>

                    <!-- *** RUOLO ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label15" CssClass="inputtext" runat="server" Text="Ruolo:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLRuolo" runat="server" DataSourceID="DSRouli" DataTextField="Name" DataValueField="Roles_Id" SelectedValue='<%# bind("roles_id") %>' AppendDataBoundItems="True">
                            <asp:ListItem  Value="" Text="Seleziona un valore"/>
                            </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Inserire ruolo" Display="none" ControlToValidate="DDLRuolo"></asp:RequiredFieldValidator>
                        </div>      

                    </div>

                    <!-- *** SOCIETA ***  -->
                    <div class="input">
                        <asp:Label ID="Label16" CssClass="inputtext" runat="server" Text="Società:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLSocieta" runat="server" DataSourceID="DSSocieta" 
                                DataTextField="Name" DataValueField="Company_id" 
                                SelectedValue='<%# bind("company_id") %>' AppendDataBoundItems="True">
                                <asp:ListItem  Value="" Text="Seleziona un valore"/>
                            </asp:DropDownList>
                        </div>      
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Inserire società" Display="none" ControlToValidate="DDLSocieta" ></asp:RequiredFieldValidator>
                    </div>

                    <!-- *** PROFILO SPESE ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label11" CssClass="inputtext" runat="server" Text="Profilo spese:"></asp:Label>
                        <div class="InputcontentDDL" style="width:190px">
                            <asp:DropDownList ID="DDLProfiloSpese" runat="server" DataSourceID="DSProfiloSpese" 
                                DataTextField="Name" DataValueField="ExpensesProfile_id" 
                                SelectedValue='<%# bind("ExpensesProfile_id") %>' AppendDataBoundItems="True">
                                <asp:ListItem  Value="0" Text="Seleziona un valore"/>
                            </asp:DropDownList>
                        </div>      
                    </div>

<%--                     <!-- *** Carta credito aziendale  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBCartaCreditoAziendale" runat="server"  Checked='<%# Bind("CartaCreditoAziendale") %>' />
					    <asp:Label  AssociatedControlId="CBCartaCreditoAziendale" class="css-label" ID="Label21" runat="server">Carta credito aziendale</asp:Label>
                     </div>--%>

                </div> <!-- *** TAB 2 ***  -->

                <div id="tabs-3" style="height:400px;width:100%">  

                    <!-- *** ORE CONTRATTO ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label12" CssClass="inputtext" runat="server" Text="Ore contratto:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBContractHours" runat="server" Text='<%# Bind("ContractHours") %>' />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="TBContractHours" ErrorMessage="Inserire ore contratto" Display="none"></asp:RequiredFieldValidator>
                    </div>

                    <!-- *** Escludi da controllo economics  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label18" CssClass="inputtext" runat="server" Text=""></asp:Label> <!--- posizionamento -->
                        <asp:CheckBox  ID="CBEscludiControlloEconomics" runat="server"  Checked='<%# Bind("EscludiControlloEconomics") %>' />
					    <asp:Label  AssociatedControlId="CBEscludiControlloEconomics" class="css-label" ID="Label19" runat="server">Escludi da economics</asp:Label>
                     </div>

                    <!-- *** Note ***  -->
            	    <div class="input nobottomborder"> 
	                    <div class="inputtext">Note</div> 
	                    <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea"/> 
	                </div> 

                </div> <!-- *** TAB 3 ***  -->

                </div>  <!-- *** TABS ***  -->  
               
                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                     <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>"/>
                     <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" />                                    
                </div>    
                             
            </InsertItemTemplate>

        </asp:FormView>
    
    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 
 
</body>

    <asp:SqlDataSource ID="DSPersone" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Persons] WHERE ([Persons_id] = @Persons_id)" 
        InsertCommand="INSERT INTO [Persons] ([Name], [Roles_Id], [Company_id], [NickName], [Mail], [Attivo_da], [Attivo_fino], [Active],  [ForcedAccount], [Lingua], [EscludiControlloEconomics], [userId], [password], [userLevel_ID], [ColorScheme], [PwdVPN], [ExpensesProfile_id], [ContractHours], [Note], [BetaTester]) VALUES (@Name, @Roles_Id, @Company_id, @NickName, @Mail, @Attivo_da, @Attivo_fino, @Active,  @ForcedAccount, @Lingua, @EscludiControlloEconomics, @userId, @password, @userLevel_ID, 1, @PwdVPN, @ExpensesProfile_id, @ContractHours, @Note, @BetaTester)" 
        UpdateCommand="UPDATE [Persons] SET [Name] = @Name, [Roles_Id] = @Roles_Id, [Company_id] = @Company_id, [NickName] = @NickName, [Mail] = @Mail, [Attivo_da] = @Attivo_da, [Attivo_fino] = @Attivo_fino, [Active] = @Active, [ForcedAccount] = @ForcedAccount, [Lingua] = @Lingua, [EscludiControlloEconomics] = @EscludiControlloEconomics,  [password] = @password, [userLevel_ID] = @userLevel_ID, [ExpensesProfile_id] = @ExpensesProfile_id, [ContractHours] = @ContractHours, [Note] = @Note, [BetaTester]=@BetaTester WHERE [Persons_id] = @Persons_id">
        <InsertParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Roles_Id" Type="Int32" />
            <asp:Parameter Name="Company_id" Type="Int32" />
            <asp:Parameter Name="NickName" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Attivo_da" Type="DateTime" />
            <asp:Parameter Name="Attivo_fino" Type="DateTime" />
            <asp:Parameter Name="Active" Type="Boolean" />
<%--            <asp:Parameter Name="FullLoadedCost" Type="Decimal" />
            <asp:Parameter Name="ListPrice" Type="Decimal" />--%>
            <asp:Parameter Name="Lingua" Type="String" />
            <asp:Parameter Name="ForcedAccount" Type="Boolean" />
            <asp:Parameter Name="EscludiControlloEconomics" Type="Boolean" />
            <asp:Parameter Name="userId" Type="String" />
            <asp:Parameter Name="password" Type="String" />
            <asp:Parameter Name="userLevel_ID" Type="String" />
            <asp:Parameter Name="ColorScheme" Type="Int16" />
            <asp:Parameter Name="PwdVPN" Type="String" />
            <asp:Parameter Name="ExpensesProfile_id" Type="Int32" />
            <asp:Parameter Name="ContractHours" Type="Int32" />
            <asp:Parameter Name="Note" Type="String" />
            <asp:Parameter Name="BetaTester" Type="Boolean" DefaultValue="false" />
        </InsertParameters>
        <SelectParameters>
            <asp:QueryStringParameter Name="Persons_id" QueryStringField="persons_id" 
                Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Persons_id" Type="Int32" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Roles_Id" Type="Int32" />
            <asp:Parameter Name="Company_id" Type="Int32" />
            <asp:Parameter Name="NickName" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Attivo_da" Type="DateTime" />
            <asp:Parameter Name="Attivo_fino" Type="DateTime" />
            <asp:Parameter Name="Active" Type="Boolean" />
<%--            <asp:Parameter Name="FullLoadedCost" Type="Decimal" />
            <asp:Parameter Name="ListPrice" Type="Decimal" />--%>
            <asp:Parameter Name="ForcedAccount" Type="Boolean" />
            <asp:Parameter Name="Lingua" Type="String" />
            <asp:Parameter Name="EscludiControlloEconomics" Type="Boolean" />
            <asp:Parameter Name="userId" Type="String" />
            <asp:Parameter Name="password" Type="String" />
            <asp:Parameter Name="userLevel_ID" Type="String" />
            <asp:Parameter Name="ColorScheme" Type="Int16" />
            <asp:Parameter Name="PwdVPN" Type="String" />
            <asp:Parameter Name="ExpensesProfile_id" Type="Int32" />
            <asp:Parameter Name="ContractHours" Type="Int32" />
            <asp:Parameter Name="Note" Type="String" />
            <asp:Parameter Name="BetaTester" Type="Boolean"   />
        </UpdateParameters>
    </asp:SqlDataSource>

<asp:sqldatasource runat="server" ID="DSProfiloSpese"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [ExpensesProfile]"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSLivelloUtente"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [AuthUserLevel]"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSRouli"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Roles]"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSSocieta"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [Company]"></asp:sqldatasource>

</html>

