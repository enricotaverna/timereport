<%@ Page Language="C#" AutoEventWireup="true" CodeFile="persons_lookup_form.aspx.cs" Inherits="persons_lookup_form" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica Persone" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formPersone" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-5">
                    <asp:HiddenField ID="FVMode" runat="server" />
                    <asp:FormView ID="FVPersone" runat="server" DataSourceID="DSPersone" DataKeyNames="Persons_id"
                        DefaultMode="Insert" CssClass="StandardForm" OnModeChanging="FVPersone_ModeChanging" ClientIDMode="Static"
                        OnItemInserted="FVPersone_ItemInserted" OnItemUpdated="FVPersone_ItemUpdated" Width="100%">

                        <EditItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Dati anagrafici</a></li>
                                    <li><a href="#tabs-2">Userid</a></li>
                                    <li><a href="#tabs-3">Ruolo</a></li>
                                    <li><a href="#tabs-4">Tariffa</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** NOME  ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Nome:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNome" Enabled="false" runat="server" Text='<%# Bind("Name") %>' MaxLength="50" Width="270px" />
                                    </div>

                                     <!-- *** Employee Number ***  -->
                                    <div class="input nobottomborder">
                                            <asp:Label CssClass="inputtext" runat="server" Text="Employee Number:"></asp:Label>
                                            <asp:DropDownList ID="DDLEmployeeNumber" runat="server" CssClass="sumoDLL" Enabled="false"
                                                AppendDataBoundItems="True" data-parsley-errors-container="#valMsg" >
                                                <asp:ListItem Value="" Text="Non rilevante" />
                                            </asp:DropDownList>
                                    </div

                                    <!-- *** ATTIVO DA A  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Attivo da:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBAttivoDa" runat="server" Text='<%# Bind("attivo_da","{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBAttivoFino" runat="server" Width="100px" Text='<%# Bind("attivo_fino","{0:d}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required />
                                    </div>

                                    <!-- *** FLAG  ***  -->
                                    <div class="input ">
                                        <asp:CheckBox ID="CBAttivo" runat="server" Checked='<%# Bind("active") %>' />
                                        <asp:Label AssociatedControlID="CBAttivo" Style="padding: 0px 100px 0px 0px" class="css-label" ID="Label3" runat="server">Attivo</asp:Label>

                                        <!-- *** Account forzato  ***  -->
                                        <asp:Label ID="Label7" CssClass="inputtext" runat="server" Text=""></asp:Label>
                                        <!--- posizionamento -->
                                        <asp:CheckBox ID="CBForzato" runat="server" Checked='<%# Bind("ForcedAccount") %>' />
                                        <asp:Label AssociatedControlID="CBForzato" class="css-label" ID="Label8" runat="server">Conti da autorizzare</asp:Label>
                                    </div>

                                    <!-- *** SEDE ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Sede:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLCalendario" runat="server" DataSourceID="DSCalendario"
                                                DataTextField="CalName" AppendDataBoundItems="True" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'
                                                data-parsley-errors-container="#valMsg" required>
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** LINGUA ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text="Lingua:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLLingua" runat="server"
                                                SelectedValue='<%# Bind("Lingua") %>' AppendDataBoundItems="True">
                                                <asp:ListItem Value="it" Text="Italiano" />
                                                <asp:ListItem Value="en" Text="Inglese" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** data creazione/modifica ***  -->
                                    <div class="input nobottomborder" style="font-size: 10px; line-height: 14px; top: 30px; position: relative">
                                        <span style="width: 50px; display: inline-block">Creazione: </span>
                                        <asp:Label ID="Label13" runat="server" Text='<%# Bind("CreatedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="Label11" runat="server" Text='<%# Bind("CreationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                        <br />
                                        <span style="width: 50px; display: inline-block">Modifica:</span>
                                        <asp:Label ID="Label10" runat="server" Text='<%# Bind("LastModifiedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="Label6" runat="server" Text='<%# Bind("LastModificationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                    </div>

                                </div>
                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 380px; width: 100%">

                                    <!-- *** USERID ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label9" CssClass="inputtext" runat="server" Text="Userd Id:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBUserid" Enabled="false" runat="server" Text='<%# Bind("Userid") %>'
                                            data-parsley-errors-container="#valMsg" MinMaxLength="6" MaxLength="20" data-parsley-required="true" />
                                    </div>

                                    <!-- *** PASSWORD ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="label24" CssClass="inputtext" runat="server" Text="Password:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" Text='<%# Bind("password") %>'
                                            data-parsley-errors-container="#valMsg" MinLength="3" MaxLength="10" required />
                                    </div>

                                    <!-- *** MAIL  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label14" CssClass="inputtext" runat="server" Text="Mail:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBMail" runat="server" Text='<%# Bind("mail") %>' Width="265px" Columns="50"
                                            data-parsley-errors-container="#valMsg" required="true" data-parsley-type='email' />
                                    </div>

                                    <!-- *** MAIL  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label17" CssClass="inputtext" runat="server" Text="Salesforce Mail:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBSFMail" runat="server" Text='<%# Bind("SaleforceEmail") %>' Width="265px" Columns="50"
                                            data-parsley-errors-container="#valMsg" required="false" data-parsley-excluded="true" data-parsley-type='email' />
                                    </div>

                                </div>

                                <div id="tabs-3" style="height: 380px; width: 100%">

                                    <!-- *** RUOLO ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label15" CssClass="inputtext" runat="server" Text="Ruolo:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLRuolo" runat="server" DataSourceID="DSRouli" DataTextField="Name" DataValueField="Roles_Id"
                                                SelectedValue='<%# Bind("roles_id") %>' AppendDataBoundItems="True"
                                                data-parsley-errors-container="#valMsg" required>
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>

                                    </div>

                                    <!-- *** TIPO CONSULENZA ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Tipo consulenza:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLTipoConsulenza" runat="server" DataSourceID="DSTipoConsulenza"
                                                DataTextField="ConsultantTypeName" DataValueField="ConsultantType_id" data-parsley-errors-container="#valMsg" required="true"
                                                SelectedValue='<%# Bind("ConsultantType_id") %>'>
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** USER LEVEL ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label2" CssClass="inputtext" runat="server" Text="Livello utente:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="DSLivelloUtente"
                                                DataTextField="Name" AppendDataBoundItems="True" DataValueField="UserLevel_id" SelectedValue='<%# Bind("UserLevel_id") %>'
                                                data-parsley-errors-container="#valMsg" required>
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** SOCIETA ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label16" CssClass="inputtext" runat="server" Text="Società:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLSocieta" runat="server" DataSourceID="DSSocieta"
                                                DataTextField="Name" DataValueField="Company_id"
                                                SelectedValue='<%# Bind("company_id") %>' AppendDataBoundItems="True">
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** MANAGER ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Manager:"></asp:Label>
                                        <label class="dropdown">
                                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="DSManager" OnDataBound="DDLManager_DataBound"
                                                DataTextField="Name" DataValueField="Persons_id" data-parsley-errors-container="#valMsg" required="true"
                                                AppendDataBoundItems="True">
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                </div>
                                <!-- *** TAB 3 ***  -->

                                <div id="tabs-4" style="height: 380px; width: 100%">

                                    <!-- *** ORE CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label12" CssClass="inputtext" runat="server" Text="Ore contratto:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBContractHours" runat="server" Text='<%# Bind("ContractHours") %>' Width="100px"
                                            data-parsley-errors-container="#valMsg" required="" data-parsley-type="integer" data-parsley-min="1" />
                                    </div>

                                    <!-- *** CONTRATTO DA A  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Contratto da:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBContratto_da" runat="server" Text='<%# Bind("Contratto_da","{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBContratto_a" runat="server" Width="100px" Text='<%# Bind("Contratto_a","{0:d}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** Escludi da controllo economics  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label18" CssClass="inputtext" runat="server" Text=""></asp:Label>
                                        <!--- posizionamento -->
                                        <asp:CheckBox ID="CBEscludiControlloEconomics" runat="server" Checked='<%# Bind("EscludiControlloEconomics") %>' />
                                        <asp:Label AssociatedControlID="CBEscludiControlloEconomics" class="css-label" ID="Label19" runat="server">Escludi da economics</asp:Label>
                                    </div>

                                    <!-- *** Note ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" />
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="UpdateButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="Button1" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate />
                            </div>

                        </EditItemTemplate>

                        <InsertItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Dati anagrafici</a></li>
                                    <li><a href="#tabs-2">Userid</a></li>
                                    <li><a href="#tabs-3">Ruolo</a></li>
                                    <li><a href="#tabs-4">Tariffa</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** NOME  ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Nome:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNome" runat="server" Text='<%# Bind("Name") %>'
                                            data-parsley-errors-container="#valMsg" MaxLength="50" Width="270px" required="" />
                                    </div>

                                    <!-- *** Employee Number ***  -->
                                    <div class="input nobottomborder">
                                            <asp:Label CssClass="inputtext" runat="server" Text="Employee Number:"></asp:Label>
                                            <asp:DropDownList ID="DDLEmployeeNumber" runat="server" CssClass="sumoDLL"
                                                AppendDataBoundItems="True" data-parsley-errors-container="#valMsg" data-parsley-employee-number="">
                                                <asp:ListItem Value="" Text="Non rilevante" />
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** ATTIVO DA A  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Attivo da:"></asp:Label>
                                        <asp:TextBox  CssClass="ASPInputcontent sdatepicker" ID="TBAttivoDa" runat="server" Text='<%# Bind("attivo_da","{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                        <asp:TextBox  CssClass="ASPInputcontent sdatepicker" ID="TBAttivoFino" runat="server" Width="100px" Text='<%# Bind("attivo_fino","{0:d}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required />
                                    </div>

                                    <!-- *** FLAG  ***  -->
                                    <div class="input ">
                                        <asp:CheckBox ID="CBAttivo" runat="server" Checked='<%# Bind("active") %>' />
                                        <asp:Label AssociatedControlID="CBAttivo" Style="padding: 0px 100px 0px 0px" class="css-label" ID="Label3" runat="server">Attivo</asp:Label>

                                        <!-- *** Account forzato  ***  -->
                                        <asp:Label ID="Label7" CssClass="inputtext" runat="server" Text=""></asp:Label>
                                        <!--- posizionamento -->
                                        <asp:CheckBox ID="CBForzato" runat="server" Checked='<%# Bind("ForcedAccount") %>' />
                                        <asp:Label AssociatedControlID="CBForzato" class="css-label" ID="Label8" runat="server">Conti da autorizzare</asp:Label>
                                    </div>

                                    <br />

                                    <!-- *** SEDE ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Sede:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLCalendario" runat="server" DataSourceID="DSCalendario"
                                                DataTextField="CalName" AppendDataBoundItems="True" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'
                                                data-parsley-errors-container="#valMsg" required>
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** LINGUA ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label20" CssClass="inputtext" runat="server" Text="Lingua:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLLingua" runat="server"
                                                SelectedValue='<%# Bind("Lingua") %>' AppendDataBoundItems="True">
                                                <asp:ListItem Value="it" Text="Italiano" />
                                                <asp:ListItem Value="en" Text="Inglese" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                </div>
                                <!-- *** TAB 2 ***  -->

                                <div id="tabs-2" style="height: 380px; width: 100%">


                                    <!-- *** USERID ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label22" CssClass="inputtext" runat="server" Text="Userd Id:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBUserid" runat="server" Text='<%# Bind("Userid") %>'
                                            data-parsley-errors-container="#valMsg" MinMaxLength="6" MaxLength="20" required
                                            data-parsley-userid="" data-parsley-trigger-after-failure="focusout" />
                                    </div>

                                    <!-- *** PASSWORD ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="label23" CssClass="inputtext" runat="server" Text="Password:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" Text='<%# Bind("password") %>'
                                            data-parsley-errors-container="#valMsg" MinLength="3" MaxLength="10" required />
                                    </div>

                                    <!-- *** MAIL  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label14" CssClass="inputtext" runat="server" Text="Mail:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBMail" runat="server" Text='<%# Bind("mail") %>' Width="265px" Columns="50"
                                            data-parsley-errors-container="#valMsg" required data-parsley-type='email' />
                                    </div>

                                    <!-- *** MAIL  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label17" CssClass="inputtext" runat="server" Text="Salesforce Mail:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBSFMail" runat="server" Text='<%# Bind("SaleforceEmail") %>' Width="265px" Columns="50"
                                            data-parsley-errors-container="#valMsg" required="false" data-parsley-excluded="true" data-parsley-type='email' />
                                    </div>

                                </div>
                                <!-- *** TAB 3 ***  -->

                                <div id="tabs-3" style="height: 380px; width: 100%">

                                    <!-- *** RUOLO ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label15" CssClass="inputtext" runat="server" Text="Ruolo:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLRuolo" runat="server" DataSourceID="DSRouli" DataTextField="Name" DataValueField="Roles_Id"
                                                SelectedValue='<%# Bind("roles_id") %>' AppendDataBoundItems="True"
                                                data-parsley-errors-container="#valMsg" required>
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>

                                    </div>

                                    <!-- *** TIPO CONSULENZA ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Tipo consulenza:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLTipoConsulenza" runat="server" DataSourceID="DSTipoConsulenza"
                                                DataTextField="ConsultantTypeName" DataValueField="ConsultantType_id" data-parsley-errors-container="#valMsg" required="true"
                                                SelectedValue='<%# Bind("ConsultantType_id") %>'>
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** USER LEVEL ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label10" CssClass="inputtext" runat="server" Text="Livello utente:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLLivelloUtente" runat="server" DataSourceID="DSLivelloUtente"
                                                DataTextField="Name" AppendDataBoundItems="True" DataValueField="UserLevel_id" SelectedValue='<%# Bind("UserLevel_id") %>'
                                                data-parsley-errors-container="#valMsg" required>
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** SOCIETA ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label16" CssClass="inputtext" runat="server" Text="Società:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLSocieta" runat="server" DataSourceID="DSSocieta"
                                                DataTextField="Name" DataValueField="Company_id" data-parsley-errors-container="#valMsg" required
                                                SelectedValue='<%# Bind("company_id") %>' AppendDataBoundItems="True">
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                    <!-- *** MANAGER ***  -->
                                    <div class="input nobottomborder ">
                                        <asp:Label CssClass="inputtext" runat="server" Text="Manager:"></asp:Label>
                                        <label class="dropdown" style="width: 190px">
                                            <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="DSManager" OnDataBound="DDLManager_DataBound"
                                                DataTextField="Name" DataValueField="Persons_id" data-parsley-errors-container="#valMsg" required="true"
                                                SelectedValue='<%# Bind("Manager_id") %>' AppendDataBoundItems="True">
                                                <asp:ListItem Value="" Text="Seleziona un valore" />
                                            </asp:DropDownList>
                                        </label>
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                                <div id="tabs-4" style="height: 380px; width: 100%">

                                    <!-- *** ORE CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label12" CssClass="inputtext" runat="server" Text="Ore contratto:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBContractHours" runat="server" Text='<%# Bind("ContractHours") %>' Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-type="integer" data-parsley-min="1" required="" />
                                    </div>

                                    <!-- *** CONTRATTO DA A  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Contratto da:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBContratto_da" runat="server" Text='<%# Bind("Contratto_da","{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent sdatepicker" ID="TBContratto_a" runat="server" Width="100px" Text='<%# Bind("Contratto_a","{0:d}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** Escludi da controllo economics  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label18" CssClass="inputtext" runat="server" Text=""></asp:Label>
                                        <!--- posizionamento -->
                                        <asp:CheckBox ID="CBEscludiControlloEconomics" runat="server" Checked='<%# Bind("EscludiControlloEconomics") %>' />
                                        <asp:Label AssociatedControlID="CBEscludiControlloEconomics" class="css-label" ID="Label19" runat="server">Escludi da economics</asp:Label>
                                    </div>

                                    <!-- *** Note ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" />
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="Button1" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                            </div>

                        </InsertItemTemplate>

                    </asp:FormView>

                </div>
                <!-- FormWrap -->
            </div>
            <!-- LastRow -->
        </form>
        <!-- Form  -->
    </div>
    <!-- container -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DSPersone" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Persons] WHERE ([Persons_id] = @Persons_id)"
        InsertCommand="INSERT INTO [Persons] ([Name], [Roles_Id], [Company_id], [NickName], [Mail], [Attivo_da], [Attivo_fino], [Active],  [ForcedAccount], [Lingua], [EscludiControlloEconomics], [userId], [password], [userLevel_ID], [ColorScheme], [PwdVPN], [ExpensesProfile_id], [ContractHours], [Note], [BetaTester], [Calendar_id], [Manager_id], [AnniNonAeonvis], [ConsultantType_id], [Contratto_da], [Contratto_a], [CreationDate], [CreatedBy], [SaleforceEmail], [EmployeeNumber] ) VALUES (@Name, @Roles_Id, @Company_id, @NickName, @Mail, @Attivo_da, @Attivo_fino, @Active,  @ForcedAccount, @Lingua, @EscludiControlloEconomics, @userId, @password, @userLevel_ID, 1, @PwdVPN, @ExpensesProfile_id, @ContractHours, @Note, @BetaTester, @Calendar_id, @Manager_id, @AnniNonAeonvis, @ConsultantType_id, @Contratto_da, @Contratto_a, @CreationDate, @CreatedBy, @SaleforceEmail, @EmployeeNumber)"
        UpdateCommand="UPDATE [Persons] SET [Name] = @Name, [Roles_Id] = @Roles_Id, [Company_id] = @Company_id, [NickName] = @NickName, [Mail] = @Mail, [Attivo_da] = @Attivo_da, [Attivo_fino] = @Attivo_fino, [Active] = @Active, [ForcedAccount] = @ForcedAccount, [Lingua] = @Lingua, [EscludiControlloEconomics] = @EscludiControlloEconomics,  [password] = @password, [userLevel_ID] = @userLevel_ID, [ExpensesProfile_id] = @ExpensesProfile_id, [ContractHours] = @ContractHours, [Note] = @Note, [BetaTester]=@BetaTester, [Calendar_id]=@Calendar_id, [Manager_id]=@Manager_id, [AnniNonAeonvis]=@AnniNonAeonvis, [ConsultantType_id] = @ConsultantType_id, [Contratto_da] = @Contratto_da, [Contratto_a] = @Contratto_a, LastModificationDate = @LastModificationDate, LastModifiedBy = @LastModifiedBy, SaleforceEmail = @SaleforceEmail, EmployeeNumber = @EmployeeNumber WHERE [Persons_id] = @Persons_id"
        OnInserting="DSpersons_Insert" OnUpdating="DSpersons_Update">
        <InsertParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Roles_Id" Type="Int32" />
            <asp:Parameter Name="Company_id" Type="Int32" />
            <asp:Parameter Name="NickName" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Attivo_da" Type="DateTime" />
            <asp:Parameter Name="Attivo_fino" Type="DateTime" />
            <asp:Parameter Name="Active" Type="Boolean" />
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
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="Manager_id" Type="Int32" />
            <asp:Parameter Name="AnniNonAeonvis" Type="Decimal" />
            <asp:Parameter Name="ConsultantType_id" Type="Int32" />
            <asp:Parameter Name="Contratto_da" Type="DateTime" />
            <asp:Parameter Name="Contratto_a" Type="DateTime" />
            <asp:Parameter Name="CreatedBy" Type="String" />
            <asp:Parameter Name="CreationDate" Type="DateTime" />
            <asp:Parameter Name="SaleforceEmail" Type="String" />
            <asp:Parameter Name="EmployeeNumber" Type="String" />
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
            <asp:Parameter Name="BetaTester" Type="Boolean" />
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="Manager_id" Type="Int32" />
            <asp:Parameter Name="AnniNonAeonvis" Type="Decimal" />
            <asp:Parameter Name="ConsultantType_id" Type="Int32" />
            <asp:Parameter Name="Contratto_da" Type="DateTime" />
            <asp:Parameter Name="Contratto_a" Type="DateTime" />
            <asp:Parameter Name="LastModifiedBy" Type="String" />
            <asp:Parameter Name="LastModificationDate" Type="DateTime" />
            <asp:Parameter Name="SaleforceEmail" Type="String" />
            <asp:Parameter Name="EmployeeNumber" Type="String" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="DSProfiloSpese"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [ExpensesProfile]"></asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="DSLivelloUtente"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [AuthUserLevel] ORDER BY UserLevel_ID"></asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="DSCalendario"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Calendar]"></asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="DSRouli"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Roles] ORDER BY Name"></asp:SqlDataSource>

    <asp:SqlDataSource runat="server" ID="DSSocieta"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Company] ORDER BY Name"></asp:SqlDataSource>

    <asp:SqlDataSource ID="DSmanager" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>

    <asp:SqlDataSource ID="DSTipoConsulenza" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT ConsultantType_id, ConsultantTypeName FROM ConsultantType ORDER BY ConsultantTypeName"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // Inizializza SumoSelect
        $('select').SumoSelect({ search: true, searchText: '' });

        // abilitate tab view
        $("#tabs").tabs();

        $(":checkbox").addClass("css-checkbox");

        $(".sdatepicker").datepicker($.datepicker.regional['it']);

        // disabilita tooltip autocomplete su campi input
        $(document).ready(function () {
            $('input').attr('autocomplete', 'off');
        })

        //$('#FVPersone_DDLEmployeeNumberText').parent().hide();

        Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
        });

        // quando selezionato visualizza solo l'Employee number e sostituisce i valori nei campi
        $('#DDLEmployeeNumber').on('change', function GetPersonData() {

            // solo in creazione
            var formViewMode = $('#FVMode').val();
            if (formViewMode !== 'Insert') {
                return;
            }

            var $selected = $(this).find('option:selected');
            var originalText = $selected.text();

            if (originalText == 'Non rilevante')
                return;

            var onlyEmployeeNumber = originalText.split(' ')[0]; // estrare l'EM
            // valorizza la DDL solo con il numero impiegato
            $('#DDLEmployeeNumber').next('.CaptionCont').find('span').text(onlyEmployeeNumber);

            MaskScreen();

            // chiama la funzione per avere i dati personali del consulente da defaultaer
            $.ajax({
                url: '/timereport/webservices/WS_Persons.asmx/GetPersonData',
                data: JSON.stringify({ EmployeeNumber: onlyEmployeeNumber }),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                success: function (data) {
                    if (data.d) {
                        UnMaskScreen();
                        $('#TBNome').val(data.d.Consulente);
                        $('#TBMail').val(data.d.MailAziendale);
                        $('#TBAttivoDa').val(data.d.DataAssunzione);
                        $('#TBAttivoFino').val(data.d.DataCessazione);
                        $('#DDLCalendario').val(data.d.Sede);
                        $('#DDLCalendario')[0].sumo.reload();

                        $('#TBContractHours').val(data.d.OreGiornaliere);
                        $('#DDLRuolo').val(data.d.Ruolo);
                        $('#DDLRuolo')[0].sumo.reload();

                        $('#CBAttivo').prop('checked', true);
                        $('#CBForzato').prop('checked', true);

                        $('#DDLSocieta').val(1); // Aeonvis
                        $('#DDLSocieta')[0].sumo.reload();

                        // Extract the first letter and the last word of data.d.Consulente
                        var consulente = data.d.Consulente;
                        var firstWord = consulente.split(' ')[0].toLowerCase();
                        var lastWord = consulente.split(' ').pop().toLowerCase();
                        var userId = lastWord.charAt(0) + firstWord;

                        // Set the value of #TBUserid
                        $('#TBUserid').val(userId);

                        // Set the value of #TBpassword
                        var password = lastWord.charAt(0) + firstWord.charAt(0) + "123";
                        $('#TBpassword').val(password);
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    UnMaskScreen();
                    ShowPopup("Errore nella lettura dati consulente: " + xhr.responseText);
                }
            });

        });

        // *** controllo che non esista lo stesso codice utente *** //
        window.Parsley.addValidator('userid', function (value, requirement) {
            var response = false;
            var dataAjax = "{ sKey: 'UserId', " +
                " sValkey: '" + value + "', " +
                " sTable: 'Persons'  }";

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
            .addMessage('en', 'userid', 'Username already exists')
            .addMessage('it', 'userid', 'Username già esistente');

        // Validatore personalizzato per DDLEmployeeNumber
        window.Parsley.addValidator('employeeNumber', {
            validateString: function (value) {
                var societaValue = $('#DDLSocieta').val();
                if (societaValue === '1') {
                    return value.trim() !== '';
                }
                return true; 
            },
            messages: {
                it: 'Se società è Aeonvis inserire Employee Number.'
            }
        });

        // *** attiva validazione campi form
        $('#formPersone').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

    </script>

</body>

</html>

