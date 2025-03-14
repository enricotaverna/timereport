﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="activity_lookup_form.aspx.cs"
    Inherits="m_gestione_Activity_activity_lookup_form" %>

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

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica Fase" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formAttivita" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">


                    <asp:FormView ID="FVattivita" runat="server" DataKeyNames="Activity_id" DataSourceID="DSattivita"
                        DefaultMode="Insert" OnItemInserting="ItemInserting_FVattivita"
                        OnItemUpdating="ItemUpdating_FVattivita" OnItemInserted="ItemInserted_FVattivita" class="StandardForm"
                        OnItemUpdated="ItemUpdated_FVattivita" OnModeChanging="ItemModeChanging_FVattivita">

                        <EditItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Attività</a></li>
                                    <li><a href="#tabs-2">Budget</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** CODICE ATTIVITA ***  -->
                                    <div class="input">
                                        <div class="inputtext">Codice attività: </div>
                                        <asp:TextBox ID="ActivityCodeTextBox" runat="server" Text='<%# Bind("ActivityCode") %>' Columns="15" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" />
                                        <!-- *** CHECK BOX  ***  -->
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("active") %>' />
                                        <asp:Label AssociatedControlID="CheckBox1" ID="Label3" runat="server">Attivo</asp:Label>
                                    </div>

                                    <!-- *** DESCRIZIONE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Descrizione: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' Columns="40" Style="width: 265px" CssClass="ASPInputcontent"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto:</div>
                                            <asp:DropDownList ID="DDLprogetto" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DDLProgetto_SelectedIndexChanged"
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** FASE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Fase:</div>
                                            <asp:DropDownList ID="DDLfase" runat="server" AppendDataBoundItems="True" CssClass="FormInput"
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** RESPONSABILE ***  -->
                                    <div class="input">
                                        <div class="inputtext">Responsabile:</div>
                                            <asp:DropDownList ID="DDLresposabile" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="DSpersone" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Responsable_id") %>'>
                                                <asp:ListItem Value="">-- seleziona responsabile --</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** COMMENT ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox1" runat="server" Columns="40" Rows="5" Text='<%# Bind("comment") %>' TextMode="MultiLine" CssClass="textarea"></asp:TextBox>
                                    </div>

                                </div>
                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 380px; width: 100%">

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Budget: </div>
                                        <asp:TextBox ID="RevenueBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>

                                    <!-- *** IMPORTO BUDGET ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Budget ABAP: </div>
                                        <asp:TextBox ID="BudgetABAPTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>--%>

                                    <!-- *** IMPORTO BUDGET GG ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Bdg GG ABAP: </div>
                                        <asp:TextBox ID="BudgetGGABAPTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                    </div>--%>

                                    <!-- *** IMPORTO SPESE ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>--%>

                                    <!-- *** MARGINE TARGET ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type='integer' data-parsley-max='100' data-parsley-min='1' />
                                        <label>%</label>
                                    </div>--%>

                                    <div class="SeparatoreForm">Durata</div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** DATA FINE  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Data fine:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine","{0:d}") %>' MaxLength="10" Rows="12" Columns="10"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                </div>
                                <!-- *** TAB 2 ***  -->

                                <!-- *** BOTTONI  ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="UpdateButton" runat="server" CssClass="orangebutton" CommandName="Update" Text="<%$ appSettings: SAVE_TXT %>" />
                                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                                </div>
                        </EditItemTemplate>

                        <InsertItemTemplate>

                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Attività</a></li>
                                    <li><a href="#tabs-2">Budget</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** CODICE ATTIVITA ***  -->
                                    <div class="input">
                                        <div class="inputtext">Codice attività: </div>
                                        <asp:TextBox ID="ActivityCodeTextBox" runat="server" Text='<%# Bind("ActivityCode") %>' Columns="15" MaxLength="15" CssClass="ASPInputcontent"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                        <!-- *** CHECK BOX  ***  -->
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("active") %>' />
                                        <asp:Label AssociatedControlID="CheckBox1" ID="Label3" runat="server">Attivo</asp:Label>
                                    </div>

                                    <!-- *** DESCRIZIONE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Descrizione: </div>
                                        <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' Columns="40" Style="width: 265px" CssClass="ASPInputcontent"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto:</div>
                                            <asp:DropDownList ID="DDLprogetto" runat="server" AutoPostBack="true" OnSelectedIndexChanged="DDLProgetto_SelectedIndexChanged"
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** FASE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Fase:</div>
                                            <asp:DropDownList ID="DDLfase" runat="server" AppendDataBoundItems="True" CssClass="FormInput"
                                                data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                                    </div>

                                    <!-- *** RESPONSABILE ***  -->
                                    <div class="input">
                                        <div class="inputtext">Responsabile:</div>
                                            <asp:DropDownList ID="DDLresposabile" runat="server" AppendDataBoundItems="True"
                                                DataSourceID="DSpersone" DataTextField="Name" DataValueField="Persons_id" SelectedValue='<%# Bind("Responsable_id") %>'>
                                                <asp:ListItem Value="">-- seleziona responsabile --</asp:ListItem>
                                            </asp:DropDownList>
                                    </div>

                                    <!-- *** COMMENT ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Note</div>
                                        <asp:TextBox ID="TextBox1" runat="server" Columns="40" Rows="5" Text='<%# Bind("comment") %>' TextMode="MultiLine" CssClass="textarea"></asp:TextBox>
                                    </div>

                                </div>
                                <!-- *** TAB 1 ***  -->

                                <div id="tabs-2" style="height: 380px; width: 100%">

                                    <!-- *** IMPORTO REVENUE ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Budget: </div>
                                        <asp:TextBox ID="RevenueBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("RevenueBudget","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>

                                    <!-- *** IMPORTO BUDGET ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Budget ABAP: </div>
                                        <asp:TextBox ID="BudgetABAPTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetABAP","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>--%>

                                    <!-- *** IMPORTO BUDGET GG ABAP ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Bdg GG ABAP: </div>
                                        <asp:TextBox ID="BudgetGGABAPTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("BudgetGGABAP","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                    </div>--%>

                                    <!-- *** IMPORTO SPESE ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Spese: </div>
                                        <asp:TextBox ID="SpeseBudgetTextBox" class="ASPInputcontent" runat="server" Text='<%# Bind("SpeseBudget","{0:#####}") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type="number" />
                                        <label>€</label>
                                    </div>--%>

                                    <!-- *** MARGINE TARGET ***  -->
<%--                                    <div class="input nobottomborder">
                                        <div class="inputtext">Margine: </div>
                                        <asp:TextBox ID="TBMargine" class="ASPInputcontent" Columns="5" runat="server" Text='<%# Bind("MargineProposta") %>'
                                            data-parsley-errors-container="#valMsg" data-parsley-type='integer' data-parsley-max='100' data-parsley-min='1' />
                                        <label>%</label>
                                    </div>--%>

                                    <div class="SeparatoreForm">Durata</div>

                                    <!-- *** DATA INIZIO  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label4" CssClass="inputtext" runat="server" Text="Data inizio:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data inizio" ID="TBAttivoDa" runat="server" Text='<%# Bind("DataInizio", "{0:d}")%>' MaxLength="10" Rows="12" Columns="10"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                    <!-- *** DATA FINE  ***  -->
                                    <div class="input nobottomborder">
                                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Data fine:"></asp:Label>
                                        <asp:TextBox CssClass="ASPInputcontent" ErrorMessage="Inserire data fine" ID="TBAttivoA" runat="server" Text='<%# Bind("DataFine","{0:d}") %>' MaxLength="10" Rows="12" Columns="10"
                                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                    </div>

                                </div>
                                <!-- *** TAB 2 ***  -->

                                <!-- *** BOTTONI  ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="UpdateButton" runat="server" CssClass="orangebutton" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" />
                                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                                </div>
                        </InsertItemTemplate>

                        <ItemTemplate>
                        </ItemTemplate>

                    </asp:FormView>

                </div>
                <!-- FormWrap -->

            </div>
            <!-- LastRow -->

        </form>
        <!-- Form  -->
    </div>
    <!-- container --

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
    <asp:SqlDataSource ID="DSattivita" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        InsertCommand="INSERT INTO Activity(ActivityCode, Name, Phase_id, Projects_id, Active, Comment, Responsable_id, RevenueBudget, BudgetABAP, BudgetGGABAP , SpeseBudget, MargineProposta, DataInizio, DataFine) VALUES (@ActivityCode, @Name, @Phase_id, @Projects_id, @active, @comment, @Responsable_id, @RevenueBudget, @BudgetABAP, @BudgetGGABAP, @SpeseBudget, @MargineProposta/100, @DataInizio, @DataFine)"
        SelectCommand="SELECT * FROM [Activity] WHERE ([Activity_id] = @Activity_id)"
        UpdateCommand="UPDATE Activity SET ActivityCode = @ActivityCode, Name = @Name, Phase_id = @Phase_id, Projects_id = @Projects_id, Active = @active, Comment = @comment, Responsable_id = @Responsable_id, RevenueBudget=@RevenueBudget, BudgetABAP = @BudgetABAP, BudgetGGABAP = @BudgetGGABAP, SpeseBudget=@SpeseBudget, MargineProposta=@MargineProposta/100, DataInizio=@DataInizio, DataFine=@DataFine WHERE (Activity_id = @Activity_id)">
        <InsertParameters>
            <asp:Parameter Name="ActivityCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Phase_id" Type="Int32" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="comment" Type="String" />
            <asp:Parameter Name="Responsable_id" />
            <asp:Parameter Name="RevenueBudget" Type="Decimal" />
            <asp:Parameter Name="BudgetABAP" Type="Decimal" />
            <asp:Parameter Name="BudgetGGABAP" Type="Decimal" />
            <asp:Parameter Name="SpeseBudget" Type="Decimal" />
            <asp:Parameter Name="MargineProposta" Type="Decimal" />
            <asp:Parameter Name="DataFine" Type="DateTime" />
            <asp:Parameter Name="DataInizio" Type="DateTime" />
        </InsertParameters>
        <SelectParameters>
            <asp:QueryStringParameter Name="Activity_id" QueryStringField="activity_id" Type="Int32" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="ActivityCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Phase_id" Type="Int32" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="active" Type="Boolean" />
            <asp:Parameter Name="comment" Type="String" />
            <asp:Parameter Name="Responsable_id" />
            <asp:Parameter Name="Activity_id" Type="Int32" />
            <asp:Parameter Name="RevenueBudget" Type="Decimal" />
            <asp:Parameter Name="BudgetABAP" Type="Decimal" />
            <asp:Parameter Name="BudgetGGABAP" Type="Decimal" />
            <asp:Parameter Name="SpeseBudget" Type="Decimal" />
            <asp:Parameter Name="MargineProposta" Type="Decimal" />
            <asp:Parameter Name="DataFine" Type="DateTime" />
            <asp:Parameter Name="DataInizio" Type="DateTime" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSpersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name, Active FROM Persons ORDER BY Name"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        $(function () {

            // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

            // abilitate tab view
            $("#tabs").tabs();

            $(":checkbox").addClass("css-checkbox");

            // datepicker
            $("#FVattivita_TBAttivoDa").datepicker($.datepicker.regional['it']);
            $("#FVattivita_TBAttivoA").datepicker($.datepicker.regional['it']);

            // formatta il campo percentuale
            //var percentDecimal = $("#FVattivita_TBMargine").val().toString().replace(",", ".");
            //if (percentDecimal != "") {
            //    var percentCent = parseFloat(percentDecimal) * 100;
            //    $("#FVattivita_TBMargine").val(percentCent);
            //}

        });

        Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
        });

        // *** attiva validazione campi form
        $('#formAttivita').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });
    </script>

</body>

</html>

