<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Projects_lookup_form.aspx.cs" Inherits="m_gestione_Project_Projects_lookup_form" %>

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
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <style>
        /* etichetta Margine: affiancata alla Rev. + Risconto; da sola (utente non director) si allinea come le altre etichette */
        .lblMargineBudget { display: inline-block; margin-left: 15px; width: 100px; color: #777; }
        .lblMargineBudget:first-child { float: left; display: block; margin-left: 0; width: 130px; line-height: 30px; }
    </style>
    <title>
        <asp:Literal runat="server" Text="Anagrafica progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formProgetto" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-5">

                    <asp:FormView ID="FVProgetto" runat="server" DataKeyNames="Projects_Id"
                        DataSourceID="projects" OnItemUpdated="BackToList"
                        OnItemInserted="BackToList" OnDataBound="Bind_DDL"
                        OnItemInserting="FVProgetto_ItemInserting"
                        OnItemUpdating="FVProgetto_ItemUpdating"
                        OnModeChanging="FVProgetto_ModeChanging"
                        DefaultMode="Insert" Width="100%">

                        <EditItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Progetto</a></li>
                                    <li><a href="#tabs-2">Budget</a></li>
                                    <li><a href="#tabs-4">Altri dati</a></li>
                                    <li style="display:none"><a href="#tabs-5">Monthly fee</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 460px; width: 100%">

                                    <!-- *** CODICE PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Codice: </div>
                                        <asp:TextBox ID="TBProgetto" runat="server" class="ASPInputcontent" Enabled="False"
                                            Text='<%# Bind("ProjectCode") %>' Columns="12"
                                            MaxLength="10" />
                                        <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
                                        <asp:Label AssociatedControlID="ActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="progetto attivo"></asp:Label>
                                    </div>

                                    <!-- *** NOME PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>'
                                            Columns="26" MaxLength="50" class="ASPInputcontent"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input">
                                        <asp:Label ID="Label8" CssClass="inputtext" runat="server" Text="Inizio"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">fine</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoA" runat="server" Width="100px" Text='<%# Bind("DataFine", "{0:d}") %>' data-parsley-required="true"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** CODICE CLIENTE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Cliente:</div>
                                        <asp:DropDownList ID="DDLCliente" runat="server"
                                            data-parsley-check-chargeable="true"
                                            data-parsley-errors-container="#valMsg"
                                            data-parsley-required="true"
                                            AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CODICE MANAGER ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Manager:</div>
                                        <asp:DropDownList ID="DDLManager" runat="server"
                                            AppendDataBoundItems="True"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CODICE ACCOUNT ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Delivery Owner:</div>
                                        <asp:DropDownList ID="DDLAccountManager" runat="server"
                                            AppendDataBoundItems="True"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CANALE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Canale:</div>
                                        <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale"
                                            DataTextField="Name" DataValueField="Channels_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Channels_Id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SOCIETA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Società:</div>
                                        <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="societa"
                                            DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Company_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** data creazione/modifica ***  -->
                                    <div class="legendaText">
                                        <span>[C]</span>
                                        <asp:Label ID="label11" runat="server" Text='<%# Bind("CreatedBy")%>'></asp:Label>
                                        <%# !string.IsNullOrEmpty(Eval("CreatedBy").ToString()) ? "<span>il </span>" : "" %>
                                        <asp:Label ID="label22" runat="server" Text='<%# Bind("CreationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                        <br />
                                        <span>[M]</span>
                                        <asp:Label ID="label33" runat="server" Text='<%# Bind("LastModifiedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="label44" runat="server" Text='<%# Bind("LastModificationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                    </div>
                                </div>

                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 460px; width: 100%; overflow-y: auto;">

                                    <!-- *** REVENUE + RISCONTO (stessa riga) ***  -->
                                    <div class="input nobottomborder">
                                        <div id="lbRevenueBudget" class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("RevenueBudget", "{0:0.00}") %>' Enabled="False"
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="decimal" />
                                        <label>€</label>
                                        <asp:PlaceHolder ID="PHRisconto" runat="server">
                                        <span style="display: inline-block; margin-left: 15px; width: 100px; color: #777;">Risconto: </span>
                                        <asp:TextBox ID="TBRisconto" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("Risconto", "{0:0.00}") %>' Enabled="False" />
                                        <label>€</label>
                                        </asp:PlaceHolder>
                                    </div>

                                    <!-- *** REV. + RISCONTO (colonna calcolata DB, sola lettura) + MARGINE (stessa riga) ***  -->
                                    <div class="input nobottomborder">
                                        <asp:PlaceHolder ID="PHRevConRisconto" runat="server">
                                        <div class="inputtext">Rev. + Risconto: </div>
                                        <asp:TextBox ID="TBRevenueBudgetConRisconto" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Eval("RevenueBudgetConRisconto", "{0:0.00}") %>' Enabled="False" />
                                        <label>€</label>
                                        </asp:PlaceHolder>
                                        <span class="lblMargineBudget">Margine: </span>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>' Enabled="False"
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>%</label>
                                    </div>

                                    <!-- *** MARGINE ETC + CALCOLO RICAVI (stessa riga) ***  -->
                                    <asp:Panel ID="PNRigaEtc" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHMargineEtc" runat="server">
                                        <div class="inputtext">Margine ETC: </div>
                                        <asp:TextBox ID="TBMargineEtc" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("Margine_etc", "{0:0.####}") %>'
                                            data-parsley-errors-container="#valMsg" />
                                        <label>%</label>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="PHCalcoloRicavi" runat="server">
                                        <span style="display: inline-block; margin-left: 15px;">
                                            <asp:CheckBox ID="CBCalcoloRicavi" runat="server" />
                                            <asp:Label AssociatedControlID="CBCalcoloRicavi" class="css-label" runat="server" Text="Calcolo ricavi"></asp:Label>
                                        </span>
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** NOTE BUDGET (riga propria) ***  -->
                                    <asp:Panel ID="PNRigaNote" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHNoteBudget" runat="server">
                                        <div class="inputtext">Note: </div>
                                        <asp:TextBox ID="TBNoteBudget" class="ASPInputcontent" runat="server" Style="width: calc(100% - 140px);" Text='<%# Bind("Note_Budget") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-nota-budget="true" />
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** T&L ***  -->
                                    <div class="input">
                                        <div class="inputtext">T&L:</div>
                                        <asp:DropDownList ID="DDLTL" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="T_L" DataValueField="T_L">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">LOB:</div>
                                        <asp:DropDownList ID="DDLLOB" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="lob" DataTextField="Description" DataValueField="LOB_Id"
                                            SelectedValue='<%# Bind("LOB_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SUB LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Sub LOB:</div>
                                        <asp:DropDownList ID="DDLSUBLOB" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** OFFERING ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Offering:</div>
                                        <asp:DropDownList ID="DDLOFFERING" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** PLATFORM ***  -->
                                    <div class="input">
                                        <div class="inputtext">Platform:</div>
                                        <asp:DropDownList ID="DDLPLATFORM" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="Platform" DataValueField="Platform">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione" DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO SF ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto SF: </div>
                                        <asp:DropDownList ID="DDLTipoContrattoSF" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="SFContractType" DataTextField="Descrizione" DataValueField="SFContractType_Id"
                                            SelectedValue='<%# Bind("SFContractType_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="tipoprogetto" DataTextField="Name" DataValueField="ProjectType_Id"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext"></div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="lblCBNoOvertime" runat="server" Text="No Overtime"></asp:Label>

                                    </div>

                                    <!-- *** IMPORTO SPESE ***  ----- VIENE SOSTITUITO DA Platform
                                    <div class="input nobottomborder">
                                        <div id="lbSpeseBudgetTextBox" class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:0.00}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-resale-forfait="true" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div> -->
                                </div>
                                <!-- *** TAB 2 ***  -->

                                <!-- *** TAB 4 ***  -->
                                <div id="tabs-4" style="height: 460px; width: 100%">

                                    <!-- *** Altri dati ***  -->

                                    <!-- *** TESTO OBBLIGATORIO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Testo obbl.: </div>
                                        <asp:TextBox ID="TBMessaggioDiErrore" class="ASPInputcontent" Style="width: 270px" runat="server" Text='<%# Bind("MessaggioDiErrore")%>' />
                                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server" Checked='<%# Bind("TestoObbligatorio") %>' />
                                        <asp:Label AssociatedControlID="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
                                    </div>

                                    <!-- *** VISIBILITA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Attivo per:</div>
                                        <asp:DropDownList ID="DDLVisibility" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="DSVisibility" DataTextField="VisibilityName" data-parsley-errors-container="#valMsg" data-parsley-required="true"
                                            DataValueField="ProjectVisibility_id" SelectedValue='<%# Bind("ProjectVisibility_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CHECKBOX ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">&nbsp;</div>

                                        <%--<asp:CheckBox ID="AlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />--%>
                                        <%--<asp:Label AssociatedControlID="AlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo"></asp:Label>--%>

                                        <asp:CheckBox ID="ActivityOn" runat="server" Checked='<%#Bind("ActivityOn") %>' />
                                        <asp:Label AssociatedControlID="ActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS" Style="padding-right: 40px"></asp:Label>

                                        <br />
                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="BloccoCaricoSpeseCheckBox" runat="server" Checked='<%#Bind("BloccoCaricoSpese") %>' />
                                        <asp:Label AssociatedControlID="BloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>

                                        <br />
                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="RecurringPrj" runat="server" Checked='<%#Bind("RecurringProject") %>' />
                                        <asp:Label AssociatedControlID="RecurringPrj" class="css-label" ID="Label9" runat="server" Text="Recurring Project" Style="padding-right: 40px"></asp:Label>

                                    </div>

                                    <!-- *** Tipo Workflow ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo Workflow</div>
                                        <asp:DropDownList ID="DDLWorkflowType" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="WF_WorkflowType" DataTextField="WFDescription"
                                            DataValueField="WorkflowType" SelectedValue='<%# Bind("WorkflowType") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" />
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                                <!-- *** TAB 5 ***  -->
                                <div id="tabs-5" style="height: 460px; width: 100%;">
                                    <div class="input nobottomborder" style="display: flex; align-items: center; gap: 10px;">
                                        <asp:Label class="css-label" Style="padding: 0px 5px 0px 0px;" AssociatedControlID="TextBox2" ID="Label2" runat="server">Progetto</asp:Label>

                                        <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("ProjectCode") %>' Width="100" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" />

                                        <div style="flex:auto ; padding: 2px; display: flex; flex-direction: column; min-height: 28px;" id="pnlMessage" runat="server">

                                            <asp:Label class="css-label" ID="LblRevenueAlert" runat="server" Font-Bold="true" Font-Size="X-Small"
                                                Style="white-space: nowrap; margin: 0; padding: 0; line-height: 1.1;" />

                                            <asp:Label class="css-label" ID="LblCostAlert" runat="server" Font-Bold="true" Font-Size="X-Small"
                                                Style="white-space: nowrap; margin: 0; padding: 0; line-height: 1.1;" />
                                        </div>

                                        <asp:Button
                                            ID="btnRigenera"
                                            runat="server"
                                            CausesValidation="False"
                                            CssClass="orangebutton"
                                            Text="Rigenera"
                                            OnClick="btnRigenera_Click"
                                            OnClientClick="return confirm('Sei sicuro di voler rigenerare i dati? Questa operazione potrebbe sovrascrivere i ratei esistenti.');" />

                                        <asp:Button
                                            ID="btnRinnova"
                                            runat="server"
                                            CausesValidation="False"
                                            CssClass="orangebutton"
                                            Text="Rinnova"
                                            Visible="false"
                                            OnClientClick="return false;" />
                                        
                                        <!-- Bottone hidden che fa il vero postback dopo conferma modal -->
                                        <asp:Button
                                            ID="btnRinnovaSubmit"
                                            runat="server"
                                            CausesValidation="False"
                                            Text=""
                                            OnClick="btnRinnova_Click"
                                            style="display:none;" />
                                    </div>
                                    <div id="DivScrollableGrid" style="height: 90%; overflow: auto;">
                                        <asp:GridView Style=" width: 100%; height:100% " ID="GridView1" runat="server" AllowSorting="True" 
                                            AutoGenerateColumns="False" DataSourceID="DSCanoni" CssClass="GridView" 
                                            AllowPaging="False" auto DataKeyNames="Monthly_Fee_id,Projects_id"
                                            GridLines="None" EnableModelValidation="True"
                                            OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                                            OnPageIndexChanging="GridView1_PageIndexChanging" 
                                            OnRowDataBound="GridView1_RowDataBound"
                                            ShowFooter="true" >
                                            <FooterStyle CssClass="GV_footer" Font-Bold="true" ForeColor="#777777" Font-Size="Medium" />
                                            <RowStyle Wrap="False" CssClass="GV_row" />
                                            <PagerStyle CssClass="GV_footer" />
                                            <HeaderStyle CssClass="GV_header" />
                                            <AlternatingRowStyle CssClass="GV_row_alt " />
                                            <Columns>
                                                <asp:BoundField DataField="Year" HeaderText="Year" SortExpression="Year" />
                                                <asp:BoundField DataField="Month" HeaderText="Month" SortExpression="Month" />
                                                <asp:BoundField DataField="Days" HeaderText="Days" SortExpression="Days" Visible="false" />
                                                <asp:BoundField 
                                                    DataField="Revenue" 
                                                    HeaderText="Revenue(€)" 
                                                    ReadOnly="True" 
                                                    SortExpression="Revenue" 
                                                    DataFormatString="{0:C}" 
                                                    ItemStyle-HorizontalAlign="Left" />
                                                <asp:BoundField 
                                                    DataField="Cost" 
                                                    HeaderText="Cost(€)" 
                                                    ReadOnly="True" 
                                                    SortExpression="Cost" 
                                                    DataFormatString="{0:C}"
                                                    ItemStyle-HorizontalAlign="Left" />

                                                <asp:TemplateField>
                                                    <ItemTemplate>
                                                        <asp:LinkButton Visible="false" ID="SelectButton" runat="server" CommandName="Select"><i class="fa fa-edit"></i></asp:LinkButton>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>

                                   
                                </div>
                                <!-- *** TAB 5 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="CloneButton" runat="server" CausesValidation="True" CommandName="Clone" CssClass="orangebutton" Text="<%$ appSettings: COPY_TXT %>" OnClick="CloneButton_Click" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                            </div>

                        </EditItemTemplate>

                        <InsertItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Progetto</a></li>
                                    <li><a href="#tabs-2">Budget</a></li>
                                    <li><a href="#tabs-4">Altri dati</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 460px; width: 100%">

                                    <!-- *** CODICE PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Codice: </div>
                                        <asp:TextBox ID="TBProgetto" runat="server" class="ASPInputcontent" Text='<%# Bind("ProjectCode") %>' Columns="12" MaxLength="10"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-trigger-after-failure="focusout" data-parsley-codiceUnico="" />
                                        <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>'/>
                                        <asp:Label AssociatedControlID="ActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="attivo"></asp:Label>
                                    </div>

                                    <!-- *** NOME PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' Columns="26" MaxLength="50" class="ASPInputcontent"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input ">
                                        <asp:Label ID="Label8" CssClass="inputtext" runat="server" Text="Inizio"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}") %>' MaxLength="10" Rows="8" Width="100px"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />

                                        <asp:Label class="css-label" Style="padding: 0px 20px 0px 20px" runat="server">fine</asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ID="TBAttivoA" runat="server" Width="100px" Text='<%# Bind("DataFine", "{0:d}") %>' data-parsley-required="true"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** CODICE CLIENTE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Cliente:</div>
                                        <asp:DropDownList ID="DDLCliente" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg"
                                            AppendDataBoundItems="True"
                                            data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CODICE MANAGER ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Manager:</div>
                                        <asp:DropDownList ID="DDLManager" runat="server"
                                            AppendDataBoundItems="True"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CODICE ACCOUNT ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Delivery Owner:</div>
                                        <asp:DropDownList ID="DDLAccountManager" runat="server"
                                            AppendDataBoundItems="True"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CANALE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Canale:</div>
                                        <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale"
                                            DataTextField="Name" DataValueField="Channels_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Channels_Id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SOCIETA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Società:</div>
                                        <asp:DropDownList ID="DropDownList14" runat="server" DataSourceID="societa"
                                            DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Company_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                </div>
                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 460px; width: 100%; overflow-y: auto;">

                                    <!-- *** REVENUE + RISCONTO (stessa riga) ***  -->
                                    <div class="input nobottomborder">
                                        <div id="lbRevenueBudget" class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("RevenueBudget", "{0:0.00}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="decimal" />
                                        <label>€</label>
                                        <asp:PlaceHolder ID="PHRisconto" runat="server">
                                        <span style="display: inline-block; margin-left: 15px; width: 100px; color: #777;">Risconto: </span>
                                        <asp:TextBox ID="TBRisconto" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("Risconto", "{0:0.00}") %>'
                                            data-parsley-errors-container="#valMsg" />
                                        <label>€</label>
                                        </asp:PlaceHolder>
                                    </div>


                                    <!-- *** MARGINE (stessa riga della Rev. + Risconto, assente in inserimento) ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>%</label>
                                    </div>

                                    <!-- *** MARGINE ETC + CALCOLO RICAVI (stessa riga) ***  -->
                                    <asp:Panel ID="PNRigaEtc" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHMargineEtc" runat="server">
                                        <div class="inputtext">Margine ETC: </div>
                                        <asp:TextBox ID="TBMargineEtc" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("Margine_etc", "{0:0.####}") %>'
                                            data-parsley-errors-container="#valMsg" />
                                        <label>%</label>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="PHCalcoloRicavi" runat="server">
                                        <span style="display: inline-block; margin-left: 15px;">
                                            <asp:CheckBox ID="CBCalcoloRicavi" runat="server" />
                                            <asp:Label AssociatedControlID="CBCalcoloRicavi" class="css-label" runat="server" Text="Calcolo ricavi"></asp:Label>
                                        </span>
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** NOTE BUDGET (riga propria) ***  -->
                                    <asp:Panel ID="PNRigaNote" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHNoteBudget" runat="server">
                                        <div class="inputtext">Note: </div>
                                        <asp:TextBox ID="TBNoteBudget" class="ASPInputcontent" runat="server" Style="width: calc(100% - 140px);" Text='<%# Bind("Note_Budget") %>' />
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** T&L ***  -->
                                    <div class="input">
                                        <div class="inputtext">T&L:</div>
                                        <asp:DropDownList ID="DDLTL" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="T_L" DataValueField="T_L">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">LOB:</div>                                        
                                        <asp:DropDownList ID="DDLLOB" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="lob" DataTextField="Description" DataValueField="LOB_Id"
                                            SelectedValue='<%# Bind("LOB_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SUB LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Sub LOB:</div>                                        
                                        <asp:DropDownList ID="DDLSUBLOB" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** OFFERING ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Offering:</div>
                                        <asp:DropDownList ID="DDLOFFERING" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** PLATFORM ***  -->
                                    <div class="input">
                                        <div class="inputtext">Platform:</div>
                                        <asp:DropDownList ID="DDLPLATFORM" runat="server" data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="Platform" DataValueField="Platform">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" data-parsley-errors-container="#valMsg" data-parsley-required="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione" DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO SF ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto SF: </div>
                                        <asp:DropDownList ID="DDLTipoContrattoSF" runat="server" data-parsley-errors-container="#valMsg" data-parsley-required="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="SFContractType" DataTextField="Descrizione" DataValueField="SFContractType_Id"
                                            SelectedValue='<%# Bind("SFContractType_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" data-parsley-errors-container="#valMsg" data-parsley-required="true" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="tipoprogetto" DataTextField="Name" DataValueField="ProjectType_Id"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext"></div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="lblCBNoOvertime" runat="server" Text="No Overtime"></asp:Label>

                                    </div>

                                    <!-- *** IMPORTO SPESE ***  ----- VIENE SOSTITUITO DA Platform
                                    <div class="input nobottomborder">
                                        <div id="lbSpeseBudgetTextBox" class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:0.00}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-resale-forfait="true" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div> -->
                                </div>
                                <!-- *** TAB 2 ***  -->

                                <!-- *** TAB 4 ***  -->
                                <div id="tabs-4" style="height: 460px; width: 100%">

                                    <!-- *** Altri dati ***  -->

                                    <!-- *** TESTO OBBLIGATORIO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Testo obbl.: </div>
                                        <asp:TextBox ID="TBMessaggioDiErrore" value="messaggio di errore" class="ASPInputcontent" runat="server" Text='<%# Bind("MessaggioDiErrore")%>' />
                                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server" Checked='<%# Bind("TestoObbligatorio") %>' />
                                        <asp:Label AssociatedControlID="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
                                    </div>

                                    <!-- *** VISIBILITA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Attivo per:</div>
                                        <asp:DropDownList ID="DDLVisibility" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="DSVisibility" DataTextField="VisibilityName" data-parsley-errors-container="#valMsg" data-parsley-required="true"
                                            DataValueField="ProjectVisibility_id" SelectedValue='<%# Bind("ProjectVisibility_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CHECKBOX ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">&nbsp;</div>
                                        <%--<asp:CheckBox ID="AlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />--%>
                                        <%--<asp:Label AssociatedControlID="AlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo" Style="padding-right: 40px"></asp:Label>--%>

                                        <asp:CheckBox ID="ActivityOn" runat="server" Checked='<%#Bind("ActivityOn") %>' />
                                        <asp:Label AssociatedControlID="ActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS"></asp:Label>

                                        <br />
                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="BloccoCaricoSpeseCheckBox" runat="server" Checked='<%#Bind("BloccoCaricoSpese") %>' />
                                        <asp:Label AssociatedControlID="BloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>

                                        <br />
                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="RecurringPrj" runat="server" Checked='<%#Bind("RecurringProject") %>' />
                                        <asp:Label AssociatedControlID="RecurringPrj" class="css-label" ID="Label9" runat="server" Text="Recurring Project" Style="padding-right: 40px"></asp:Label>

                                    </div>

                                    <!-- *** Tipo Workflow ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo Workflow</div>
                                        <asp:DropDownList ID="DDLWorkflowType" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="WF_WorkflowType" DataTextField="WFDescription"
                                            DataValueField="WorkflowType" SelectedValue='<%# Bind("WorkflowType") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** NOTE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox1" runat="server" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" />
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                            </div>

                        </InsertItemTemplate>

                        <ItemTemplate>
                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Progetto</a></li>
                                    <li><a href="#tabs-2">Budget</a></li>
                                    <li><a href="#tabs-4">Altri dati</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 460px; width: 100%">

                                    <!-- *** CODICE PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Codice: </div>
                                        <asp:TextBox ID="TBProgetto" runat="server" class="ASPInputcontent"
                                            Text='<%# Bind("ProjectCode") %>' Enabled="False" Columns="12"
                                            MaxLength="10" />
                                        <asp:CheckBox ID="DisActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
                                        <asp:Label AssociatedControlID="DisActiveCheckBox" class="css-label" ID="Label3" runat="server" Text="progetto attivo"></asp:Label>
                                    </div>

                                    <!-- *** NOME PROGETTO ***  -->
                                    <div class="input">
                                        <div class="inputtext">Progetto: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>'
                                            Columns="26" MaxLength="50" Enabled="False" class="ASPInputcontent" />
                                    </div>

                                    <!-- *** CODICE CLIENTE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Cliente:</div>

                                        <asp:DropDownList ID="DDLCliente" runat="server"
                                            AppendDataBoundItems="True"
                                            Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>

                                    <!-- *** CODICE MANAGER ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Manager:</div>

                                        <asp:DropDownList ID="DDLManager" runat="server"
                                            AppendDataBoundItems="True" Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>

                                    <!-- *** CODICE ACCOUNT ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Delivery Owner:</div>

                                        <asp:DropDownList ID="DDLAccountManager" runat="server"
                                            AppendDataBoundItems="True"
                                            Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>



                                    <!-- *** CANALE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Canale:</div>
                                        <asp:DropDownList ID="DDLCanale" runat="server" DataSourceID="canale"
                                            DataTextField="Name" DataValueField="Channels_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Channels_Id") %>' Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SOCIETA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Società:</div>

                                        <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="societa"
                                            DataTextField="Name" DataValueField="Company_id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("Company_id") %>' EnableTheming="True" Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** data creazione/modifica ***  -->
                                    <div class="legendaText">
                                        <span>[C]</span>
                                        <asp:Label ID="label11" runat="server" Text='<%# Bind("CreatedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="label22" runat="server" Text='<%# Bind("CreationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                        <br />
                                        <span>[M]</span>
                                        <asp:Label ID="label33" runat="server" Text='<%# Bind("LastModifiedBy")%>'></asp:Label>
                                        <span>il </span>
                                        <asp:Label ID="label44" runat="server" Text='<%# Bind("LastModificationDate", "{0:dd/MM/yyyy HH:mm:ss}")%>'></asp:Label>
                                    </div>


                                </div>
                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 460px; width: 100%; overflow-y: auto;">

                                    <!-- *** REVENUE + RISCONTO (stessa riga) ***  -->
                                    <div class="input nobottomborder">
                                        <div id="lbRevenueBudget" class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("RevenueBudget", "{0:0.00}") %>' Enabled="False" />
                                        <label>€</label>
                                        <asp:PlaceHolder ID="PHRisconto" runat="server">
                                        <span style="display: inline-block; margin-left: 15px; width: 100px; color: #777;">Risconto: </span>
                                        <asp:TextBox ID="TBRisconto" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Bind("Risconto", "{0:0.00}") %>' Enabled="False" />
                                        <label>€</label>
                                        </asp:PlaceHolder>
                                    </div>

                                    <!-- *** REV. + RISCONTO (colonna calcolata DB, sola lettura) + MARGINE (stessa riga) ***  -->
                                    <div class="input nobottomborder">
                                        <asp:PlaceHolder ID="PHRevConRisconto" runat="server">
                                        <div class="inputtext">Rev. + Risconto: </div>
                                        <asp:TextBox ID="TBRevenueBudgetConRisconto" class="ASPInputcontent" runat="server" Width="100px" Text='<%# Eval("RevenueBudgetConRisconto", "{0:0.00}") %>' Enabled="False" />
                                        <label>€</label>
                                        </asp:PlaceHolder>
                                        <span class="lblMargineBudget">Margine: </span>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>' Enabled="False" />
                                        <label>%</label>
                                    </div>

                                    <!-- *** MARGINE ETC + CALCOLO RICAVI (stessa riga) ***  -->
                                    <asp:Panel ID="PNRigaEtc" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHMargineEtc" runat="server">
                                        <div class="inputtext">Margine ETC: </div>
                                        <asp:TextBox ID="TBMargineEtc" class="ASPInputcontent" Width="100px" runat="server" Text='<%# Bind("Margine_etc", "{0:0.####}") %>' Enabled="False" />
                                        <label>%</label>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder ID="PHCalcoloRicavi" runat="server">
                                        <span style="display: inline-block; margin-left: 15px;">
                                            <asp:CheckBox ID="DisCalcoloRicaviCheckBox" runat="server" />
                                            <asp:Label AssociatedControlID="DisCalcoloRicaviCheckBox" class="css-label" runat="server" Text="Calcolo ricavi"></asp:Label>
                                        </span>
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** NOTE BUDGET (riga propria) ***  -->
                                    <asp:Panel ID="PNRigaNote" runat="server" CssClass="input nobottomborder">
                                        <asp:PlaceHolder ID="PHNoteBudget" runat="server">
                                        <div class="inputtext">Note: </div>
                                        <asp:TextBox ID="TBNoteBudget" class="ASPInputcontent" runat="server" Style="width: calc(100% - 140px);" Text='<%# Bind("Note_Budget") %>' Enabled="False" />
                                        </asp:PlaceHolder>
                                    </asp:Panel>

                                    <!-- *** T&L ***  -->
                                    <div class="input">
                                        <div class="inputtext">T&L:</div>
                                        <asp:DropDownList ID="DDLTL" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="T_L" DataValueField="T_L">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">LOB:</div>                                        
                                        <asp:DropDownList ID="DDLLOB" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="lob" DataTextField="Description" DataValueField="LOB_Id"
                                            SelectedValue='<%# Bind("LOB_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** SUB LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Sub LOB:</div>                                        
                                        <asp:DropDownList ID="DDLSUBLOB" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** OFFERING ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Offering:</div>
                                        <asp:DropDownList ID="DDLOFFERING" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** PLATFORM ***  -->
                                    <div class="input">
                                        <div class="inputtext">Platform:</div>
                                        <asp:DropDownList ID="DDLPLATFORM" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataTextField="Platform" DataValueField="Platform">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione" DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO SF ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto SF: </div>
                                        <asp:DropDownList ID="DDLTipoContrattoSF" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="SFContractType" DataTextField="Descrizione" DataValueField="SFContractType_Id"
                                            SelectedValue='<%# Bind("SFContractType_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" Enabled="False" Style="width: calc(100% - 140px);" AppendDataBoundItems="True"
                                            DataSourceID="tipoprogetto" DataTextField="Name" DataValueField="ProjectType_Id"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext"></div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' Enabled="False" />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="lblCBNoOvertime" runat="server" Text="No Overtime"></asp:Label>

                                    </div>

                                    <!-- *** IMPORTO SPESE ***  ----- VIENE SOSTITUITO DA Platform
                                    <div class="input nobottomborder">
                                        <div id="lbSpeseBudgetTextBox" class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:0.00}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-resale-forfait="true" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div> -->

                                    <div class="SeparatoreForm">Durata</div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10" Enabled="False" />
                                    </div>

                                    <!-- *** DATA FINE  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Data fine:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine", "{0:d}") %>' MaxLength="10" Rows="12" Columns="10" Enabled="False" />
                                    </div>

                                </div>

                                <!-- *** TAB 2 ***  -->

                                <!-- *** TAB 4 ***  -->
                                <div id="tabs-4" style="height: 460px; width: 100%">

                                    <!-- *** Altri dati ***  -->

                                    <!-- *** TESTO OBBLIGATORIO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Testo obbl.: </div>
                                        <asp:TextBox ID="TBMessaggioDiErrore" class="ASPInputcontent" runat="server" Text='<%# Bind("MessaggioDiErrore")%>' Enabled="False" />
                                        <asp:CheckBox ID="CBTestoObbligatorio" runat="server" Enabled="False" Checked='<%# Bind("TestoObbligatorio") %>' />
                                        <asp:Label AssociatedControlID="CBTestoObbligatorio" class="css-label" ID="Label7" runat="server" Text=""></asp:Label>
                                    </div>

                                    <!-- *** VISIBILITA ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Attivo per:</div>
                                        <asp:DropDownList ID="DDLVisibility" runat="server" AppendDataBoundItems="True" Enabled="False"
                                            DataSourceID="DSVisibility" DataTextField="VisibilityName"
                                            DataValueField="ProjectVisibility_id" SelectedValue='<%# Bind("ProjectVisibility_id") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** CHECKBOX ***  -->
                                    <div class="input nobottomborder">

                                        <span class="input2col">
                                            <asp:CheckBox ID="DisActivityOn" runat="server" Checked='<%#Bind("ActivityOn") %>' />
                                            <asp:Label AssociatedControlID="DisActivityOn" class="css-label" ID="Label1" runat="server" Text="Gestione WBS"></asp:Label>
                                        </span>

                                        <%--<asp:CheckBox ID="DisAlwaysAvailableCheckBox" runat="server" Checked='<%# Bind("Always_available") %>' />--%>
                                        <%--<asp:Label AssociatedControlID="DisAlwaysAvailableCheckBox" class="css-label" ID="Label2" runat="server" Text="Sempre attivo"></asp:Label>--%>

                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="DisBloccoCaricoSpeseCheckBox" runat="server" Checked='<%#Bind("BloccoCaricoSpese") %>' />
                                        <asp:Label AssociatedControlID="DisBloccoCaricoSpeseCheckBox" class="css-label" ID="Label6" runat="server" Text="Blocco carico spese"></asp:Label>

                                        <br />
                                        <div class="inputtext">&nbsp;</div>
                                        <asp:CheckBox ID="RecurringPrj" runat="server" Checked='<%#Bind("RecurringProject") %>' />
                                        <asp:Label AssociatedControlID="RecurringPrj" class="css-label" ID="Label9" runat="server" Text="Recurring Project" Style="padding-right: 40px"></asp:Label>

                                    </div>

                                    <!-- *** Tipo Workflow ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo Workflow</div>

                                        <asp:DropDownList ID="DDLWorkflowType" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="WF_WorkflowType" DataTextField="WFDescription"
                                            DataValueField="WorkflowType" SelectedValue='<%# Bind("WorkflowType") %>'>
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>

                                    <!-- *** NOTE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox22" runat="server" Columns="30" Rows="5" Text='<%# Bind("Note") %>' TextMode="MultiLine" CssClass="textarea" Enabled="False" />
                                    </div>

                                </div>
                                <!-- *** TAB 4 ***  -->

                            </div>
                            <!-- *** TABS ***  -->

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                            </div>

                        </ItemTemplate>
                       
                    </asp:FormView>

                    <!-- Hidden Fields per passare i dati del Rinnova al server -->
                    <asp:HiddenField ID="hdnNuovaDataInizio" runat="server" />
                    <asp:HiddenField ID="hdnNuovaDataFine" runat="server" />
                    <asp:HiddenField ID="hdnNuovoRevenue" runat="server" />
                    <asp:HiddenField ID="hdnNuovoCost" runat="server" />

                </div>
                <!-- FormWrap -->
            </div>
            <!-- LastRow -->
            
            <!-- Modal Rinnova Progetto RESALE -->
            <div class="modal fade" id="modalRinnova" tabindex="-1" role="dialog" aria-labelledby="modalRinnovaTitle" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalRinnovaTitle">Rinnova Progetto RESALE</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="txtModalDataInizio">Data Inizio:</label>
                                <input type="text" class="form-control" id="txtModalDataInizio" placeholder="gg/mm/aaaa" />
                            </div>
                            <div class="form-group">
                                <label for="txtModalDataFine">Data Fine:</label>
                                <input type="text" class="form-control" id="txtModalDataFine" placeholder="gg/mm/aaaa" />
                            </div>
                            <div class="form-group">
                                <label for="txtModalRevenue">Revenue (€):</label>
                                <input type="text" class="form-control" id="txtModalRevenue" placeholder="0,00" />
                            </div>
                            <div class="form-group">
                                <label for="txtModalCost">Cost (€):</label>
                                <input type="text" class="form-control" id="txtModalCost" placeholder="0,00" />
                            </div>
                            <div class="form-group">
                                <label>Margine:</label>
                                <input type="text" class="form-control" id="txtModalMargine" readonly style="background-color: #e9ecef;" />
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
                            <button type="button" class="btn btn-primary" id="btnConfermaRinnova">Conferma Rinnova</button>
                        </div>
                    </div>
                </div>
            </div>
            
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
    <!-- Always_available non più usato viene defaultato a false -->
    <asp:SqlDataSource ID="projects" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        DeleteCommand="DELETE FROM [Projects] WHERE [Projects_Id] = @Projects_Id"
        InsertCommand="INSERT INTO Projects(ProjectCode, Name, ProjectType_Id, Channels_Id, Company_id, SFContractType_Id, Active, Always_available, 
            BloccoCaricoSpese,ClientManager_id, AccountManager_id,TipoContratto_id, RevenueBudget, SpeseBudget, SpeseForfait, MargineProposta, 
            DataInizio, DataFine, RevenueFatturate, SpeseFatturate, Incassato, PianoFatturazione, MetodoPagamento, TerminiPagamento, CodiceCliente, 
            Note, ActivityOn, TestoObbligatorio, MessaggioDiErrore, NoOvertime, WorkflowType, CreationDate, CreatedBy, LOB_Id, ProjectVisibility_id, RecurringProject,
            Platform, T_L, Margine_etc, Calcolo_ricavi, Risconto, SUB_LOB, Offering, Note_Budget) 
            VALUES (@ProjectCode, @Name, @ProjectType_Id, @Channels_Id, @Company_id, @SFContractType_Id, @Active, 0, 
            @BloccoCaricoSpese, @ClientManager_id, @AccountManager_id, @TipoContratto_id, @RevenueBudget, @SpeseBudget, @SpeseForfait, @MargineProposta/100, 
            @DataInizio, @DataFine, @RevenueFatturate, @SpeseFatturate, @Incassato, @PianoFatturazione, @MetodoPagamento, @TerminiPagamento, @CodiceCliente, 
            @Note, @ActivityOn, @TestoObbligatorio, @MessaggioDiErrore, @NoOvertime, @WorkflowType, @CreationDate, @CreatedBy, @LOB_Id, @ProjectVisibility_id, @RecurringProject, 
            @Platform, @T_L, @Margine_etc/100, CASE WHEN @CanEditCalcoloRicavi = 1 THEN ISNULL(@Calcolo_ricavi, 1) ELSE 1 END, CASE WHEN @CanEditRisconto = 1 THEN ISNULL(@Risconto, 0) ELSE 0 END, @SUB_LOB, @Offering, @Note_Budget)"
        SelectCommand="SELECT * FROM [Projects] WHERE ([ProjectCode] = @ProjectCode)"
        UpdateCommand="UPDATE Projects SET ProjectCode = @ProjectCode, Name = @Name, 
            Channels_Id = @Channels_Id, Company_id = @Company_id, Active = @Active, Always_available = 0, BloccoCaricoSpese = @BloccoCaricoSpese, 
            ClientManager_id = @ClientManager_id, AccountManager_id = @AccountManager_id, 
            SpeseBudget = @SpeseBudget, SpeseForfait = @SpeseForfait, DataFine=@DataFine, DataInizio=@DataInizio, 
            RevenueFatturate = @RevenueFatturate, SpeseFatturate = @SpeseFatturate, Incassato = @Incassato, PianoFatturazione = @PianoFatturazione, 
            MetodoPagamento = @MetodoPagamento, TerminiPagamento = @TerminiPagamento, CodiceCliente = @CodiceCliente, Note = @Note, ActivityOn = @ActivityOn, 
            TestoObbligatorio = @TestoObbligatorio, MessaggioDiErrore  = @MessaggioDiErrore, NoOvertime = @NoOvertime, WorkflowType = @WorkflowType, 
            LastModificationDate = @LastModificationDate, LastModifiedBy = @LastModifiedBy, ProjectVisibility_id = @ProjectVisibility_id, 
            RecurringProject = @RecurringProject, Margine_etc = CASE WHEN @CanEditMargineEtc = 1 THEN @Margine_etc/100 ELSE Margine_etc END,
            RevenueBudget = CASE WHEN @CanEditRevenueBudget = 1 THEN @RevenueBudget ELSE RevenueBudget END,
            MargineProposta = CASE WHEN @CanEditMargineBudget = 1 THEN @MargineProposta/100 ELSE MargineProposta END,
            SUB_LOB = @SUB_LOB, Offering = @Offering,
            Calcolo_ricavi = CASE WHEN @CanEditCalcoloRicavi = 1 THEN ISNULL(@Calcolo_ricavi, 1) ELSE Calcolo_ricavi END, Note_Budget = CASE WHEN @CanEditNoteBudget = 1 THEN @Note_Budget ELSE Note_Budget END WHERE (Projects_Id = @Projects_Id)"
        OnInserting="DSprojects_Insert" OnUpdating="DSprojects_Update">
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
            <asp:Parameter Name="AccountManager_id" Type="Int32" />
            <asp:Parameter Name="TipoContratto_id" Type="Int32" />
            <asp:Parameter Name="SFContractType_Id" Type="Int32" />
            <asp:Parameter Name="RevenueBudget" Type="Decimal" />
            <asp:Parameter Name="SpeseBudget" Type="Decimal" />
            <asp:Parameter Name="MargineProposta" Type="Decimal" />
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
            <asp:Parameter Name="NoOvertime" />
            <asp:Parameter Name="Projects_Id" Type="Int32" />
            <asp:Parameter Name="TestoObbligatorio" Type="Boolean" />
            <asp:Parameter Name="MessaggioDiErrore" Type="String" />
            <asp:Parameter Name="WorkflowType" Type="String" />
            <asp:Parameter Name="LastModifiedBy" />
            <asp:Parameter Name="LastModificationDate" />
            <asp:Parameter Name="LOB_Id" />
            <asp:Parameter Name="ProjectVisibility_id" />
            <asp:Parameter Name="RecurringProject" />
            <asp:Parameter Name="Platform" Type="String" />
            <asp:Parameter Name="T_L" Type="String" />
            <asp:Parameter Name="Margine_etc" Type="Decimal" />
            <asp:Parameter Name="Calcolo_ricavi" Type="Boolean" />
            <asp:Parameter Name="Risconto" Type="Decimal" />
            <asp:Parameter Name="CanEditRisconto" Type="Boolean" />
            <asp:Parameter Name="CanEditCalcoloRicavi" Type="Boolean" />
            <asp:Parameter Name="SUB_LOB" Type="String" />
            <asp:Parameter Name="Offering" Type="String" />
            <asp:Parameter Name="Note_Budget" Type="String" />
            <asp:Parameter Name="CanEditMargineEtc" Type="Boolean" />
            <asp:Parameter Name="CanEditNoteBudget" Type="Boolean" />
            <asp:Parameter Name="CanEditRevenueBudget" Type="Boolean" />
            <asp:Parameter Name="CanEditMargineBudget" Type="Boolean" />
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
            <asp:Parameter Name="AccountManager_id" Type="Int32" />
            <asp:Parameter Name="TipoContratto_id" Type="Int32" />
            <asp:Parameter Name="SFContractType_Id" Type="Int32" />
            <asp:Parameter Name="RevenueBudget" Type="Decimal" />
            <asp:Parameter Name="SpeseBudget" Type="Decimal" />
            <asp:Parameter Name="SpeseForfait" Type="Boolean" />
            <asp:Parameter Name="MargineProposta" Type="Decimal" />
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
            <asp:Parameter Name="NoOvertime" DefaultValue="false" />
            <asp:Parameter Name="TestoObbligatorio" Type="Boolean" />
            <asp:Parameter Name="MessaggioDiErrore" Type="String" />
            <asp:Parameter Name="WorkflowType" Type="String" />
            <asp:Parameter Name="CreatedBy" />
            <asp:Parameter Name="CreationDate" />
            <asp:Parameter Name="LOB_Id" />
            <asp:Parameter Name="ProjectVisibility_id" />
            <asp:Parameter Name="RecurringProject" />
            <asp:Parameter Name="Platform" Type="String" />
            <asp:Parameter Name="T_L" Type="String" />
            <asp:Parameter Name="Margine_etc" Type="Decimal" />
            <asp:Parameter Name="Calcolo_ricavi" Type="Boolean" />
            <asp:Parameter Name="Risconto" Type="Decimal" />
            <asp:Parameter Name="CanEditRisconto" Type="Boolean" />
            <asp:Parameter Name="CanEditCalcoloRicavi" Type="Boolean" />
            <asp:Parameter Name="SUB_LOB" Type="String" />
            <asp:Parameter Name="Offering" Type="String" />
            <asp:Parameter Name="Note_Budget" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSVisibility" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [ProjectVisibility]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="tipoprogetto" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [ProjectType]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="lob" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [LOB]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="canale" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Channels]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="societa" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Company] ORDER BY [Name]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TipoContratto" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [Descrizione], [TipoContratto_id] FROM [TipoContratto]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SFContractType" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT [Descrizione], [SFContractType_id] FROM [SFContractType]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="MetodoPagamento" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [MetodoPagamento]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="TerminiPagamento" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [TerminiPagamento]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="WF_WorkflowType" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT *, WorkflowType + ' : ' + Description as WFDescription FROM [WF_WorkflowType]"></asp:SqlDataSource>

    <asp:SqlDataSource ID="DSCanoni" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Monthly_Fee] WHERE ProjectCode = @ProjectCode"
        DeleteCommand="UPDATE Monthly_Fee SET Active = 0, InactiveBy = @persons_Name, LastModificationDate = GETDATE() WHERE (Monthly_Fee_id = @Monthly_Fee_id)">
        <SelectParameters>
            <asp:QueryStringParameter Name="ProjectCode" QueryStringField="ProjectCode" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    



    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

    // Tipo progetto / contratto: in inserimento dalle DropDownList, in modifica dai campi di sola lettura (valori da DB)
    function tipoProgettoValue() { var d = $("#FVProgetto_DDLTipoProgetto"); return d.length ? d.val() : $("#FVProgetto_HFProjectType_Id").val(); }
    function tipoProgettoText() { var d = $("#FVProgetto_DDLTipoProgetto"); return d.length ? d.find('option:selected').text() : ($("#FVProgetto_TXTTipoProgetto").val() || ''); }
    function tipoContrattoValue() { var d = $("#FVProgetto_DDLTipoContratto"); return d.length ? d.val() : $("#FVProgetto_HFTipoContratto_id").val(); }

    // include di snippet html per menu and background color mgt
    includeHTML();
    InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    $('select').SumoSelect({ search: true, searchText: '' });

    // SumoSelect avvolge la select in div.SumoSelect (270px da sumoselect.css) e copia lo style della select
    // sul box visibile (p.CaptionCont): la larghezza impostata sulla DDL va sul contenitore, il box interno al 100%
    $('select').each(function () {
        if (!this.style.width) return;
        var $wrap = $(this).closest('.SumoSelect');
        $wrap.css('width', this.style.width);
        $wrap.children('.CaptionCont').css('width', '100%');
    });

    // *** attiva validazione campi form
    $('#formProgetto').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
    });

    // *** messaggio di default
    Parsley.addMessages('it', {
        required: "Completare i campi obbligatori"
    });

    // se cambia selezione della DDL e non chargeable resetta il valore della lob
    $("#FVProgetto_DDLTipoProgetto").change(function () {
        if ($("#FVProgetto_DDLTipoProgetto option:selected").val() != "<%=ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] %>") // mostra Box Testo
        {
            $('#FVProgetto_DDLLOB').val('');
        }

        // prendo il valore testo della ddltipoprogetto
        var selectedText = $("#FVProgetto_DDLTipoProgetto option:selected").text();

        // 2. NUOVA LOGICA: Modifica del testo del DIV
        // Nota: l'ID del DIV target è FVProgetto_lbRevenueBudgetTextBox
        var $revenueHeaderDiv = $('#lbRevenueBudget');
        var $costHeaderDiv = $('#lbSpeseBudgetTextBox');

        // Checkbox e Label Forfait (ID dinamici)
        var $forfaitLabel = $('#<%= FVProgetto.FindControl("LBSpeseForfait").ClientID %>');
        var $CBNoOvertime = $('#<%= FVProgetto.FindControl("lblCBNoOvertime").ClientID %>');
        console.log($CBNoOvertime);

        if ($revenueHeaderDiv.length) { // Controlla che l'elemento esista

            if (selectedText === "Resale") {
                // Se è "resale", imposta il testo su "Ricavi: "
                $revenueHeaderDiv.text('Ricavi: ');
                $costHeaderDiv.text('Costi: ')
                $CBNoOvertime.hide();
                $forfaitLabel.hide();

            } else {
                // Altrimenti, imposta il testo su "Revenue: "
                $revenueHeaderDiv.text('Revenue: ');
                $costHeaderDiv.text('Spese: ');
                $CBNoOvertime.show();
                $forfaitLabel.show();
            }
        }
    });

    // *** se tipo progetto è Chargeable il cliente è obbligatorio
    window.Parsley.addValidator("checkChargeable", {
        validateString: function (value, requirement) {

            if (tipoProgettoValue() == "<%=ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] %>" && value == "") {
                return false;
            }
        }
    }).addMessage('en', 'checkChargeable', 'Please specify a lob and customer code')
        .addMessage('it', 'checkChargeable', 'Codice cliente e lob obbligatori');


    // *** progetti chargeable in modifica: se cambia il budget la nota deve essere compilata e diversa da quella salvata
    // (valori originali negli attributi data-orig-* resi dal server; il server rifà il controllo ed è l'autorità)
    window.Parsley.addValidator("notaBudget", {
        validateString: function (value) {
            var $nota = $("#FVProgetto_TBNoteBudget");
            var orig = $nota.attr("data-orig-nota");
            if (orig === undefined) return true;   // regola non applicabile (inserimento, non chargeable, utente non autorizzato)

            var num = function (v) {
                v = (v === undefined || v === null) ? "" : v.toString().replace(",", ".");
                return (v === "" || isNaN(v)) ? null : parseFloat(v);
            };
            var sameNum = function (typed, origVal, decimals, divisor) {
                var a = num(typed), b = num(origVal);
                if (a === null || b === null) return a === b;
                var f = Math.pow(10, decimals);
                return Math.round((a / divisor) * f) === Math.round(b * f);
            };

            var changed = false;
            var $rev = $("#FVProgetto_TBRevenueBudget"), $mar = $("#FVProgetto_TBMargine"), $etc = $("#FVProgetto_TBMargineEtc"), $calc = $("#FVProgetto_CBCalcoloRicavi");
            if ($rev.length && !$rev.prop("disabled") && !sameNum($rev.val(), $nota.attr("data-orig-revenue"), 2, 1)) changed = true;
            if ($mar.length && !$mar.prop("disabled") && !sameNum($mar.val(), $nota.attr("data-orig-margine"), 4, 100)) changed = true;
            if ($etc.length && !$etc.prop("disabled") && !sameNum($etc.val(), $nota.attr("data-orig-etc"), 4, 100)) changed = true;
            if ($calc.length && $calc.is(":checked") !== ($nota.attr("data-orig-calcolo") === "1")) changed = true;

            if (!changed) return true;
            var nuova = $.trim(value || "");
            return nuova !== "" && nuova !== $.trim(orig);
        },
        messages: {
            it: 'Inserire una nota che giustifichi la modifica del budget'
        }
    });

    // *** controllo che non esista lo stesso codice utente *** //
    window.Parsley.addValidator('codiceunico', {
        validateString: function (value, requirement) {
            return CheckCodiceUnico(value, requirement);
        },
        messages: {
            en: 'Project code already exists',
            it: 'Codice progetto già esistente'
        }
    });

    // validazione campo revenue in caso il progetto sia FORFAIT
    window.Parsley.addValidator("requiredIf", {
        validateString: function (value, requirement) {

            value = value.toString().replace(',', '.');

            // se inserito deve essere un numero
            if (isNaN(value) && !!value) {
                window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                return false;
            }

            if (tipoContrattoValue() == "<%= ConfigurationManager.AppSettings["CONTRATTO_FORFAIT"] %>") {

                // se FIXED verifica obbligatorietà
                if (!value && requirement != "percent") {
                    window.Parsley.addMessage('it', 'requiredIf', "Verificare i campi obbligatori");
                    return false;
                }

                // se number verifica tipo
                if (requirement == "number")
                    if (!isNaN(value)) //  compilato e numerico
                        return true;
                    else {
                        window.Parsley.addMessage('it', 'requiredIf', "Inserire un numero");
                        return false;
                    }
            }

            return true;
        },
        priority: 33
    });

    
    // validazione campo spese in caso il progetto sia FORFAIT RESELL
    // logica: se il tipo progetto è resale E il tipo contratto è forfait allora spese è obbligatorio e deve essere un numero > 0
    window.Parsley.addValidator('resaleForfait', {
        validateString: function(value) {
            // Selettori per le dropdown di Contratto e Tipo Progetto
            var $ddlContratto = $('select[id*="DDLTipoContratto"]');
            var $ddlProgetto = $('select[id*="DDLTipoProgetto"]');

            // Se i campi non sono in pagina, non validare
            if ($ddlContratto.length === 0 || $ddlProgetto.length === 0) return true;

            var txtContratto = $ddlContratto.find('option:selected').text().toLowerCase();
            var txtProgetto = $ddlProgetto.find('option:selected').text().toLowerCase();

            // CONDIZIONE: Obbligatorio SOLO se Contratto è "forfait" E Tipo Progetto è "resale"
            var isForfait = txtContratto.indexOf('forfait') !== -1;
            var isResale = txtProgetto.indexOf('resale') !== -1;

            if (isForfait && isResale) {
                // In questo caso, il valore NON può essere vuoto o 0.00
                return value.trim() !== "" && value.trim() !== "0.00" && value.trim() !== "0,00";
            }

            // In tutti gli altri casi ("altrimenti mai"), la validazione passa sempre
            return true;
        },
        messages: {
            it: 'Spese obbligatorie per contratti forfait di tipo resale.'
        }
    });

    $(function () {

        // abilitate tab view
        $("#tabs").tabs();

        // stile checkbox form    
        $(":checkbox").addClass("css-checkbox");

        // stile checkbox form in ReadOnly   
        $("#FVProgetto_DisActivityOn").addClass("css-checkbox");
        $("#FVProgetto_DisSpeseForfaitCheckBox").addClass("css-checkbox");
        $("#FVProgetto_DisActiveCheckBox").addClass("css-checkbox");
        $("#FVProgetto_DisBloccoCaricoSpeseCheckBox").addClass("css-checkbox");
        $("#FVProgetto_DisCalcoloRicaviCheckBox").addClass("css-checkbox");

        $("#FVProgetto_DisActivityOn").attr("disabled", true);
        $("#FVProgetto_DisSpeseForfaitCheckBox").attr("disabled", true);
        $("#FVProgetto_DisActiveCheckBox").attr("disabled", true);
        $("#FVProgetto_DisBloccoCaricoSpeseCheckBox").attr("disabled", true);
        $("#FVProgetto_DisCalcoloRicaviCheckBox").attr("disabled", true);

        // datepicker
        $("#FVProgetto_TBAttivoDa").datepicker($.datepicker.regional['it']);
        $("#FVProgetto_TBAttivoA").datepicker($.datepicker.regional['it']);
        
        // datepicker per il modal Rinnova
        $("#txtModalDataInizio").datepicker($.datepicker.regional['it']);
        $("#txtModalDataFine").datepicker($.datepicker.regional['it']);

        // formatta il campo percentuale
        // (salvataggio annullato dal server: i campi contengono già i valori digitati in %, non vanno riconvertiti)
        var percentDecimal = $("#FVProgetto_TBMargine").val().toString().replace(",", ".");

        if (percentDecimal != "" && !window.salvataggioAnnullato) {
            var percentCent = Math.round(parseFloat(percentDecimal) * 10000) / 100;
            percentCent = percentCent.toString().replace(".", ",");
            $("#FVProgetto_TBMargine").val(percentCent);
        }

        // formatta il campo percentuale Margine ETC (DB: decimal(5,4) -> video: %)
        var percentEtc = $("#FVProgetto_TBMargineEtc").val();
        if (percentEtc != null && percentEtc.toString() != "" && !window.salvataggioAnnullato) {
            var percentEtcCent = Math.round(parseFloat(percentEtc.toString().replace(",", ".")) * 10000) / 100;
            $("#FVProgetto_TBMargineEtc").val(percentEtcCent.toString().replace(".", ","));
        }

        // Rev. + Risconto: anteprima lato client mentre si digita (valore definitivo = colonna calcolata DB)
        function aggiornaRevConRisconto() {
            var $tot = $("#FVProgetto_TBRevenueBudgetConRisconto");
            if ($tot.length === 0) return;   // inserimento: campo non presente
            var toNum = function (v) {
                v = (v || "").toString().replace(/\./g, "").replace(",", ".");
                return (v === "" || isNaN(v)) ? 0 : parseFloat(v);
            };
            var rev = $("#FVProgetto_TBRevenueBudget").val(), ris = $("#FVProgetto_TBRisconto").val();
            if (!rev && !ris) { $tot.val(""); return; }
            $tot.val((toNum(rev) + toNum(ris)).toFixed(2).replace(".", ","));
        }
        $("#FVProgetto_TBRevenueBudget, #FVProgetto_TBRisconto").on("input change", aggiornaRevConRisconto);
        aggiornaRevConRisconto();


        // in modifica posizione icona del log modifiche
        if ($("#FVProgetto_TBProgetto").val() != "")
            $(".ui-widget-header").append('<a href="#" class="icon-link"><i class="fa fa-cog"></i></a>');

        // Optional: Add CSS to style the icon
        $(".icon-link").css({
            "float": "right",
            "margin-right": "10px",
            "color": "white",
            "font-size": "20px",
            "text-decoration": "none"
        });

        // Optional: Add click event handler for the icon
        $(".icon-link").click(function (event) {
            event.preventDefault();
            var projectsId = '<%= Session["Projects_Id"] != null ? Session["Projects_Id"].ToString() : string.Empty %>';
            if (projectsId !== '') {
                var logUrl = "/timereport/m_utilita/AuditLog.aspx?RecordId=" + projectsId + "&TableName=Projects&ProjectCode=<%=Request.QueryString["ProjectCode"] %>&TYPE=U&key=<Projects_id=" + projectsId + ">";
                window.location.href = logUrl;
            }
        });
        
    });

    $(document).ready(function () {
        // Seleziona la DropDownList usando l'ID che finisce per DDLTipoProgetto
        const ddlTipoProgetto = $("#FVProgetto_DDLTipoProgetto");   // presente solo in inserimento
        // Seleziona l'elemento LI (il link del tab)
        const tab5Link = $('#tabs').find('ul li a[href="#tabs-5"]').parent('li');
        // Seleziona l'elemento DIV (il contenuto del tab)
        const tab5Content = $('#tabs-5');

        // --- FUNZIONE PER CONTROLLARE E MOSTRARE/NASCONDERE IL TAB ---
        function checkAndToggleTab5() {
            // *** PUNTO CHIAVE: Ottieni il TESTO dell'opzione selezionata ***
            const testoSelezionato = tipoProgettoText();

            // Sostituisci 'TESTO_SPECIFICO' con il testo esatto del tipo di progetto
            // che deve essere selezionato per mostrare il tab.
            const testoDesiderato = 'Resale';

            if (testoSelezionato === testoDesiderato) {
                // MOSTRA IL TAB
                tab5Link.show();
            } else {
                // NASCONDI IL TAB
                tab5Link.hide();
                tab5Content.hide();

                // Opzionale: se il tab 5 è attivo, forziamo il passaggio al tab 1
                // Questo è utile per evitare che si veda la pagina vuota.
                if (tab5Link.hasClass('ui-tabs-active')) { // Verifica se il tab era attivo (dipende dalla libreria tabs)
                    // Solitamente si simula un click sul primo tab, o si usa il metodo della libreria UI
                    // Esempio per jQuery UI Tabs (ipotizzando sia in uso):
                    $("#tabs").tabs("option", "active", 0);
                }
            }
        }

        // 1. Esegui il controllo all'avvio della pagina
        checkAndToggleTab5();

        // 2. Esegui il controllo ogni volta che il valore della DropDownList cambia
        ddlTipoProgetto.on('change', function () {
            checkAndToggleTab5();
        });
    });

    // Funzione globale che accetta un parametro opzionale per il testo iniziale
    function checkFieldsVisibility(initialSelectedText, isEditMode) {

        // Recupera la DropDownList
        var ddlTipoProgetto = $("#FVProgetto_DDLTipoProgetto");

        // Checkbox e Label Forfait (ID dinamici)
        var divFatturati = $('#<%= FVProgetto.FindControl("LBSpeseForfait").ClientID %>');
        var divOvertime = $('#<%= FVProgetto.FindControl("lblCBNoOvertime").ClientID %>');
        const btnCopiaId = '<%= (FVProgetto.FindControl("CloneButton") != null) ? FVProgetto.FindControl("CloneButton").ClientID : "ID_NON_PRESENTE_CLONE_BUTTON" %>';
        const btnRinnovaId = '<%= (FVProgetto.FindControl("btnRinnova") != null) ? FVProgetto.FindControl("btnRinnova").ClientID : "ID_NON_PRESENTE_RINNOVA_BUTTON" %>';

        // 2. Usiamo jQuery per selezionare l'elemento SOLO SE l'ID non è quello fittizio.
        // Se l'ID è fittizio (controllo non renderizzato), btnCopia sarà una collezione jQuery vuota.
        var btnCopia = $('#' + btnCopiaId);
        var btnRinnova = $('#' + btnRinnovaId);

        // Campi Revenue e Costi nel tab Budget
        var tbRevenueBudget = $('#<%= FVProgetto.FindControl("TBRevenueBudget").ClientID %>');
        var tbSpeseBudget = $('#<%= FVProgetto.FindControl("SpeseBudgetTextBox").ClientID %>');

        let selectedText;
        if (initialSelectedText) {
            // Se la funzione è stata chiamata dal C# (Edit mode), usa il parametro
            selectedText = initialSelectedText;
        } else {
            // Se la funzione è chiamata dall'evento 'change' o dal ready in Insert mode
            selectedText = tipoProgettoText();
        }

        // Logica di visibilità: nascondi se è "Resale"
        const shouldHide = (selectedText === 'Resale');

        if (shouldHide) {
            divOvertime.hide();
            divFatturati.hide();
            // Opzionale: Pulisci i valori
            divOvertime.find('input, select').val('');
            divFatturati.find('input, select').val('');
            btnCopia.hide();
            
            // LOGICA RESALE: Applica SOLO in Edit mode (quando isEditMode è true)
            if (isEditMode === true) {
                // Blocca DDLTipoProgetto dopo selezione (solo in modifica)
                ddlTipoProgetto.prop('disabled', true);
                
                // Rendi readonly Revenue e Costi nel tab Budget (solo in modifica)
                tbRevenueBudget.prop('readonly', true);
                tbSpeseBudget.prop('readonly', true);
            }
            
            // NOTA: La visibilità del pulsante Rinnova è gestita lato server
            // Non nascondiamo più il pulsante qui, perché deve essere visibile per RESALE scaduti
        } else {
            divOvertime.show();
            divFatturati.show();
            btnCopia.show();
            
            // Abilita DDLTipoProgetto se non è RESALE
            ddlTipoProgetto.prop('disabled', false);
            
            // Abilita Revenue e Costi se non è RESALE
            tbRevenueBudget.prop('readonly', false);
            tbSpeseBudget.prop('readonly', false);
            
            // Il pulsante Rinnova può essere mostrato per altri tipi (se gestito dal server)
            // btnRinnova.show(); // Commentato perché la visibilità è gestita dal server
        }
    }

    $(function () {
        // Recupera la DropDownList solo per l'evento change
        var ddlTipoProgetto = $("#FVProgetto_DDLTipoProgetto");

        // La chiamata iniziale (necessaria per la modalità Insert, dove il C# non la chiama)
        if (ddlTipoProgetto.length && ddlTipoProgetto.find('option:selected').text() !== 'Resale') {
            // Chiama la funzione solo se non è 'Resale', altrimenti sarà chiamata dal C#
            // o se si è in modalità Insert.
            checkFieldsVisibility();
        }

        // 2. Esegui il controllo ogni volta che il valore della DropDownList cambia
        ddlTipoProgetto.on('change', function () {
            // Chiamata senza parametro, che usa il valore corrente della combo
            checkFieldsVisibility();
        });
    });

    // Definizione delle costanti ID come STRINGHE, come avevi inteso, ma con la corretta sintassi ASP.NET
    const TBRevenueBudgetId = '<%= FVProgetto.FindControl("TBRevenueBudget").ClientID %>';
    const SpeseBudgetTextBoxId = '<%= FVProgetto.FindControl("SpeseBudgetTextBox").ClientID %>';
    const TBMargineId = '<%= FVProgetto.FindControl("TBMargine").ClientID %>';
    const RESALE_TEXT = 'Resale'; // Costante mancante definita

    console.log(TBRevenueBudgetId);
    console.log(SpeseBudgetTextBoxId);
    console.log(TBMargineId);
    console.log(RESALE_TEXT);

    function calculateMargin() {
    
        // Seleziona gli elementi usando gli ID corretti
        const $revenue = $('#' + TBRevenueBudgetId);
        const $cost = $('#' + SpeseBudgetTextBoxId);
        const $margin = $('#' + TBMargineId);
        
        console.log($revenue);
        console.log($cost);
        console.log($margin);

        if ($revenue.length === 0 || $cost.length === 0 || $margin.length === 0) {
            return; // Esci se i campi non sono stati renderizzati
        }
    
        // Pulizia e conversione dei valori (sostituisci virgola con punto per parseFloat)
        // Usiamo 0 in caso di NaN (campo vuoto o non numerico)
        const revenueVal = parseFloat($revenue.val().replace(',', '.')) || 0;
        const costVal = parseFloat($cost.val().replace(',', '.')) || 0;
    
        // Controlla che Ricavi e Costi siano numeri validi e che Ricavi non sia zero
        if (revenueVal === 0) {
            $margin.val('0,00'); 
            return;
        }

        // Esegui il calcolo del margine (Formula: (Ricavi - Costi) / Ricavi * 100)
        const marginRatio = (revenueVal - costVal) / revenueVal;
    
        // Formatta il risultato in percentuale con arrotondamento a 2 decimali e virgola
        let marginPercent = (marginRatio * 100).toFixed(2); 
    
        // Scrivi il risultato nel campo Margine, sostituendo il punto decimale con la virgola
        $margin.val(marginPercent.replace('.', ','));
    }

    // ***************************************************************
    // V. BINDING CALCOLO MARGINE (Per il tipo 'resale')
    // ***************************************************************
    
    // Recupera la DropDownList (assumendo sia disponibile dallo scope precedente o globale)
    var ddlTipoProgetto = $('#<%= FVProgetto.FindControl("DDLTipoProgetto").ClientID %>'); 
    
    // Collega l'evento 'keyup' e 'change' per calcolare il margine in tempo reale
    const $revenueField = $('#' + TBRevenueBudgetId);
    const $costField = $('#' + SpeseBudgetTextBoxId);

    // Funzione handler unica per Revenue e Costi
    const marginCalculatorHandler = function() {
        // Esegui il calcolo solo se il progetto è di tipo 'Resale'
        if (ddlTipoProgetto.find('option:selected').text() === RESALE_TEXT) {        
            console.log('marginCalculatorHandler');
            calculateMargin();
        }
    };

        // Controlla se i campi esistono prima di legare l'evento
        if ($revenueField.length > 0 && $costField.length > 0) {

            $revenueField.on('keyup change', marginCalculatorHandler);
            $costField.on('keyup change', marginCalculatorHandler);
        }

        // Aggiorna anche l'handler principale per il cambio DDL, nel caso
        // si passi da un altro tipo a 'Resale'
        ddlTipoProgetto.on('change', function () {

            // Se si passa a 'Resale', esegui subito un primo calcolo
            if ($(this).find('option:selected').text() === RESALE_TEXT) {
                calculateMargin();
            }
        });

        // ***************************************************************
        // LOGICA MODAL RINNOVA PROGETTO RESALE
        // ***************************************************************

        // Intercetta il click sul pulsante Rinnova
        $('[id$="btnRinnova"]').on('click', function (e) {
            e.preventDefault(); // Previeni il postback immediato

            // Recupera la vecchia DataFine dal form
            var oldDataFine = $('[id$="TBAttivoA"]').val(); // Es: "31/12/2024"

            // Calcola la nuova DataInizio suggerita (vecchia DataFine + 1 giorno)
            var suggestedDataInizio = '';
            if (oldDataFine) {
                try {
                    var parts = oldDataFine.split('/');
                    var oldDate = new Date(parts[2], parts[1] - 1, parts[0]); // anno, mese-1, giorno
                    oldDate.setDate(oldDate.getDate() + 1); // +1 giorno

                    var day = ('0' + oldDate.getDate()).slice(-2);
                    var month = ('0' + (oldDate.getMonth() + 1)).slice(-2);
                    var year = oldDate.getFullYear();
                    suggestedDataInizio = day + '/' + month + '/' + year;
                } catch (ex) {
                    console.error('Errore calcolo data suggerita:', ex);
                }
            }

            // Popola i campi del modal con valori suggeriti
            $('#txtModalDataInizio').val(suggestedDataInizio);
            $('#txtModalDataFine').val(''); // L'utente inserirà manualmente
            $('#txtModalRevenue').val('');
            $('#txtModalCost').val('');
            $('#txtModalMargine').val('');

            // Mostra il modal
            $('#modalRinnova').modal('show');

            return false; // Previeni il postback
        });

        // Calcola il margine in tempo reale nel modal
        function calculateModalMargin() {
            var revenueStr = $('#txtModalRevenue').val().replace(/\./g, '').replace(',', '.');
            var costStr = $('#txtModalCost').val().replace(/\./g, '').replace(',', '.');

            var revenue = parseFloat(revenueStr) || 0;
            var cost = parseFloat(costStr) || 0;

            if (revenue === 0) {
                $('#txtModalMargine').val('0,00%');
                return;
            }

            var marginRatio = (revenue - cost) / revenue;
            var marginPercent = (marginRatio * 100).toFixed(2).replace('.', ',');
            $('#txtModalMargine').val(marginPercent + '%');
        }

        // Calcola margine quando cambiano Revenue o Cost
        $('#txtModalRevenue, #txtModalCost').on('keyup change', calculateModalMargin);

        // FORZA chiusura modal con bottone Annulla e X
        $('#modalRinnova button[data-dismiss="modal"]').on('click', function () {
            $('#modalRinnova').modal('hide');
        });

        // Conferma Rinnova: popola hidden fields e fai postback
        $('#btnConfermaRinnova').on('click', function () {
            // Valida che tutti i campi siano compilati
            var dataInizio = $('#txtModalDataInizio').val();
            var dataFine = $('#txtModalDataFine').val();
            var revenue = $('#txtModalRevenue').val();
            var cost = $('#txtModalCost').val();

            if (!dataInizio || !dataFine || !revenue || !cost) {
                alert('Compila tutti i campi obbligatori');
                return;
            }

            // Popola gli hidden fields
            $('[id$="hdnNuovaDataInizio"]').val(dataInizio);
            $('[id$="hdnNuovaDataFine"]').val(dataFine);
            $('[id$="hdnNuovoRevenue"]').val(revenue);
            $('[id$="hdnNuovoCost"]').val(cost);

            // Chiudi il modal
            $('#modalRinnova').modal('hide');

            // Click sul bottone hidden che fa il vero postback al server
            // (più affidabile di __doPostBack che potrebbe non essere definito)
            $('[id$="btnRinnovaSubmit"]')[0].click();
        });

    </script>

</body>

</html>
