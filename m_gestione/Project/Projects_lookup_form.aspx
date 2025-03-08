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
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
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
                                        <div class="inputtext">Account:</div>
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

                                <div id="tabs-2" style="height: 460px; width: 100%">

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione"
                                            DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO SF ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto SF: </div>
                                        <label style="width: 250px">
                                            <asp:DropDownList ID="DDLTipoContrattoSF" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="SFContractType" DataTextField="Descrizione"
                                                DataValueField="SFContractType_Id"
                                                SelectedValue='<%# Bind("SFContractType_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto"
                                            DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input">
                                        <div class="inputtext">LOB:</div>
                                        <asp:DropDownList ID="DDLLOB" runat="server" DataSourceID="lob"
                                            DataTextField="Description" DataValueField="LOB_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("LOB_Id") %>'
                                            data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget", "{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>€</label>
                                    </div>

                                    <!-- *** IMPORTO SPESE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div>

                                    <!-- *** MARGINE TARGET ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta", "{0:0.####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>%</label>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext"></div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="Label9" runat="server" Text="No Overtime"></asp:Label>

                                    </div>

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
                                        <asp:CheckBox ID="ActiveCheckBox" runat="server" Checked='<%# Bind("Active") %>' />
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
                                        <div class="inputtext">Account:</div>
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

                                <div id="tabs-2" style="height: 460px; width: 100%">

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto: </div>
                                        <label style="width: 250px">
                                            <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="TipoContratto" DataTextField="Descrizione"
                                                DataValueField="TipoContratto_id"
                                                SelectedValue='<%# Bind("TipoContratto_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO CONTRATTO SF ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Contratto SF: </div>
                                        <label style="width: 250px">
                                            <asp:DropDownList ID="DDLTipoContrattoSF" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="SFContractType" DataTextField="Descrizione"
                                                DataValueField="SFContractType_Id"
                                                SelectedValue='<%# Bind("SFContractType_id") %>'
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                                <asp:ListItem Value="" Text="Selezionare un valore" />
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto"
                                            DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input ">
                                        <div class="inputtext">LOB:</div>
                                        <asp:DropDownList ID="DDLLOB" runat="server" DataSourceID="lob"
                                            DataTextField="Description" DataValueField="LOB_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("LOB_Id") %>'
                                            data-parsley-check-chargeable="true" data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget", "{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>€</label>
                                    </div>

                                    <!-- *** IMPORTO SPESE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="TextBox4" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget", "{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div>

                                    <!-- *** MARGINE TARGET ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" Columns="5" class="ASPInputcontent" runat="server" Text='<%# Bind("MargineProposta") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="true" data-parsley-required-if="number" />
                                        <label>%</label>
                                    </div>

                                    <div class="input nobottomborder">
                                        <div class="inputtext"></div>
                                        <asp:CheckBox ID="CBNoOvertime" runat="server" Checked='<%#Bind("NoOvertime") %>' />
                                        <asp:Label AssociatedControlID="CBNoOvertime" class="css-label" ID="Label9" runat="server" Text="No Overtime"></asp:Label>

                                    </div>

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
                                        <div class="inputtext">Account:</div>

                                        <asp:DropDownList ID="DDLAccountManager" runat="server"
                                            AppendDataBoundItems="True"
                                            Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>

                                    <!-- *** TIPO PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Tipo progetto:</div>
                                        <asp:DropDownList ID="DDLTipoProgetto" runat="server" DataSourceID="tipoprogetto"
                                            DataTextField="Name" DataValueField="ProjectType_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("ProjectType_Id") %>' Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>
                                    </div>

                                    <!-- *** LOB ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">LOB:</div>
                                        <asp:DropDownList ID="DDLLOB" runat="server" DataSourceID="lob"
                                            DataTextField="Description" DataValueField="LOB_Id" AppendDataBoundItems="True"
                                            SelectedValue='<%# Bind("LOB_Id") %>' Enabled="False">
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

                                <div id="tabs-2" style="height: 460px; width: 100%">

                                    <!-- *** TIPO CONTRATTO ***  -->
                                    <div class="input ">
                                        <div class="inputtext">Contratto: </div>

                                        <asp:DropDownList ID="DDLTipoContratto" runat="server" AppendDataBoundItems="True"
                                            DataSourceID="TipoContratto" DataTextField="Descrizione"
                                            DataValueField="TipoContratto_id"
                                            SelectedValue='<%# Bind("TipoContratto_id") %>' Enabled="False">
                                            <asp:ListItem Value="" Text="Selezionare un valore" />
                                        </asp:DropDownList>

                                    </div>

                                    <div class="SeparatoreForm">Budget</div>

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Revenue: </div>
                                        <asp:TextBox ID="TBRevenueBudget" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget") %>' Enabled="False" />
                                    </div>

                                    <!-- *** IMPORTO SPESE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget") %>' Enabled="False" />
                                        <asp:CheckBox ID="SpeseForfaitCheckBox" runat="server" Checked='<%# Bind("SpeseForfait") %>' />
                                        <asp:Label AssociatedControlID="SpeseForfaitCheckBox" class="css-label" ID="LBSpeseForfait" runat="server" Text="forfait"></asp:Label>
                                    </div>

                                    <!-- *** MARGINE TARGET ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta") %>' Enabled="False" />
                                    </div>

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
    <!-- Always_available non più usato viene defaultato a false -->
    <asp:SqlDataSource ID="projects" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        DeleteCommand="DELETE FROM [Projects] WHERE [Projects_Id] = @Projects_Id"
        InsertCommand="INSERT INTO Projects(ProjectCode, Name, ProjectType_Id, Channels_Id, Company_id, SFContractType_Id, Active, Always_available, BloccoCaricoSpese,ClientManager_id, AccountManager_id,TipoContratto_id, RevenueBudget, SpeseBudget, SpeseForfait, MargineProposta, DataInizio, DataFine, RevenueFatturate, SpeseFatturate, Incassato, PianoFatturazione, MetodoPagamento, TerminiPagamento, CodiceCliente, Note, ActivityOn, TestoObbligatorio, MessaggioDiErrore, NoOvertime, WorkflowType, CreationDate, CreatedBy, LOB_Id, ProjectVisibility_id ) VALUES (@ProjectCode, @Name, @ProjectType_Id, @Channels_Id, @Company_id, @SFContractType_Id, @Active, 0, @BloccoCaricoSpese, @ClientManager_id, @AccountManager_id, @TipoContratto_id, @RevenueBudget, @SpeseBudget, @SpeseForfait, @MargineProposta/100, @DataInizio, @DataFine, @RevenueFatturate, @SpeseFatturate, @Incassato, @PianoFatturazione, @MetodoPagamento, @TerminiPagamento, @CodiceCliente, @Note, @ActivityOn, @TestoObbligatorio, @MessaggioDiErrore, @NoOvertime, @WorkflowType, @CreationDate, @CreatedBy, @LOB_Id, @ProjectVisibility_id )"
        SelectCommand="SELECT * FROM [Projects] WHERE ([ProjectCode] = @ProjectCode)"
        UpdateCommand="UPDATE Projects SET ProjectCode = @ProjectCode, Name = @Name, SFContractType_Id = @SFContractType_Id, ProjectType_Id = @ProjectType_Id, Channels_Id = @Channels_Id, Company_id = @Company_id, Active = @Active, Always_available = 0, BloccoCaricoSpese = @BloccoCaricoSpese, ClientManager_id = @ClientManager_id, AccountManager_id = @AccountManager_id, TipoContratto_id = @TipoContratto_id, RevenueBudget = @RevenueBudget ,SpeseBudget = @SpeseBudget, SpeseForfait = @SpeseForfait, MargineProposta=@MargineProposta/100, DataFine=@DataFine, DataInizio=@DataInizio, RevenueFatturate = @RevenueFatturate, SpeseFatturate = @SpeseFatturate, Incassato = @Incassato, PianoFatturazione = @PianoFatturazione, MetodoPagamento = @MetodoPagamento, TerminiPagamento = @TerminiPagamento, CodiceCliente = @CodiceCliente, Note = @Note, ActivityOn = @ActivityOn, TestoObbligatorio = @TestoObbligatorio, MessaggioDiErrore  = @MessaggioDiErrore, NoOvertime = @NoOvertime, WorkflowType = @WorkflowType, LastModificationDate = @LastModificationDate, LastModifiedBy = @LastModifiedBy, LOB_Id = @LOB_Id, ProjectVisibility_id = @ProjectVisibility_id  WHERE (Projects_Id = @Projects_Id)"
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

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $('select').SumoSelect({ search: true, searchText: '' });

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
        });

        // *** se tipo progetto è Chargeable il cliente è obbligatorio
        window.Parsley.addValidator("checkChargeable", {
            validateString: function (value, requirement) {

                if ($("#FVProgetto_DDLTipoProgetto option:selected").val() == "<%=ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] %>" && value == "") {
                    return false;
                }
            }
        }).addMessage('en', 'checkChargeable', 'Please specify a lob and customer code')
            .addMessage('it', 'checkChargeable', 'Codice cliente e lob obbligatori');


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

                if (jQuery("#FVProgetto_DDLTipoContratto option:selected").val() == "<%= ConfigurationManager.AppSettings["CONTRATTO_FORFAIT"] %>") {

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

            $("#FVProgetto_DisActivityOn").attr("disabled", true);
            $("#FVProgetto_DisSpeseForfaitCheckBox").attr("disabled", true);
            $("#FVProgetto_DisActiveCheckBox").attr("disabled", true);
            $("#FVProgetto_DisBloccoCaricoSpeseCheckBox").attr("disabled", true);

            // datepicker
            $("#FVProgetto_TBAttivoDa").datepicker($.datepicker.regional['it']);
            $("#FVProgetto_TBAttivoA").datepicker($.datepicker.regional['it']);

            // formatta il campo percentuale
            var percentDecimal = $("#FVProgetto_TBMargine").val().toString().replace(",", ".");

            if (percentDecimal != "") {
                var percentCent = Math.round(parseFloat(percentDecimal) * 10000) / 100;
                percentCent = percentCent.toString().replace(".", ",");
                $("#FVProgetto_TBMargine").val(percentCent);
            }

            // in modifica posizione icona del log modifiche
            if ($("#FVProgetto_TBProgetto").val() != "" )
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
                var logUrl = "/timereport/m_utilita/AuditLog.aspx?RecordId=<%= Session["Projects_Id"].ToString() %>&TableName=Projects&ProjectCode=<%=Request.QueryString["ProjectCode"] %>&TYPE=U&key=<Projects_id=<%=Session["Projects_Id"].ToString() %>>";
                window.location.href = logUrl;                  
            });
        });
    </script>

</body>

</html>
