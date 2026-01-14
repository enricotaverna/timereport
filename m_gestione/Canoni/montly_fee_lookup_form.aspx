<%@ Page Language="C#" AutoEventWireup="true" CodeFile="montly_fee_lookup_form.aspx.cs"
    Inherits="m_gestione_Canoni_montly_fee_lookup_form" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica Fase" />
    </title>
    <!-- Jquery + parsley + datepicker  -->
    <script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
    <script src="/timereport/include/jquery/mask/jquery.mask.min.js"></script>
    <script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
    <script src="/timereport/include/jquery/jquery-ui.min.js"></script>

    <!-- Javascript -->
    <script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/timereport/include/BTmenu/menukit.js"></script>
    <script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>
    
    <script src="/timereport/include/parsley/parsley.min.js"></script>
    <script src="/timereport/include/parsley/it.js"></script>

    <!-- CSS-->
    <link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
    <link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
    <link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
    <link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="formCanoni" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">


                    <asp:FormView ID="FVCanoni" runat="server" DataKeyNames="Monthly_Fee_id" DataSourceID="DSCanoni"
                        DefaultMode="Insert" OnItemInserting="ItemInserting_FVCanoni"
                        OnItemUpdating="ItemUpdating_FVCanoni" OnItemInserted="ItemInserted_FVCanoni" class="StandardForm"
                        OnItemUpdated="ItemUpdated_FVCanoni" OnModeChanging="ItemModeChanging_FVCanoni" OnDataBound="FVCanoni_DataBound">

                        <InsertItemTemplate>
                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Canone</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** CODICE ATTIVITA ***  -->
                                    <div class="input">
                                        <div class="inputtext">Codice Canone: </div>
                                        <asp:TextBox ID="MonthlyCodeTextBox" runat="server" Text='<%# Bind("Monthly_Fee_Code") %>' Columns="15" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" Style="width:200px" />
                                        <!-- *** CHECK BOX  ***  -->
                                        <asp:CheckBox ID="CheckBox1" runat="server" 
                                            Checked='<%# (Eval("active") == DBNull.Value || Eval("active") == null) ? true : Convert.ToBoolean(Eval("active")) %>' />
                                        <asp:Label AssociatedControlID="CheckBox1" ID="Label3" runat="server">Attivo</asp:Label>
                                    </div>

                                    <!-- *** PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto (forfait):</div>
                                        <asp:DropDownList ID="DDLprogetto" runat="server"
                                            DataTextField="NomeProgetto"
                                            DataValueField="Projects_Id"
                                            AppendDataBoundItems="true"
                                            AutoPostBack="False"
                                            data-parsley-errors-container="#valMsg"
                                            data-parsley-required="true">
                                            <asp:ListItem Value="">-- Seleziona Progetto --</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <!-- *** MANAGER ***  -->
                                        <asp:Label CssClass="inputtext" Visible="false" AssociatedControlID="MangerTxt" ID="MangerLbl" runat="server">Manager:</asp:Label>
                                        <asp:TextBox ID="MangerTxt" runat="server" Visible="false" Text='<%# Bind("NomeManager") %>' MaxLength="15" CssClass="ASPInputcontent" Enabled="False" Width="270px"/>
                                    </div>

                                    <div class="input nobottomborder">
                                        <!-- *** ANNO ***  -->
                                        <asp:Label CssClass="inputtext" AssociatedControlID="YearUPD" ID="Year" runat="server">Anno</asp:Label>
                                        <asp:TextBox ID="YearUPD" runat="server" Text='<%# Bind("Year") %>' Width="50" MaxLength="15" CssClass="ASPInputcontent" Enabled="True"
                                            data-parsley-required="true"
                                            data-parsley-type="digits"
                                            data-parsley-errors-container="#valMsg" />

                                        <!-- *** Mese ***  -->
                                        <asp:Label class="css-label" Visible="false" Style="padding: 0px 5px 0px 65px" AssociatedControlID="MonthUPD" ID="Label2" runat="server">Mese</asp:Label>
                                        <asp:TextBox ID="MonthUPD" Visible="false" runat="server" Text='<%# Bind("Month") %>' Width="50" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" />
                                    </div>

                                    <div class="input nobottomborder">
                                        <%--<!-- *** REVENUE *** --%>

                                        <div class="inputtext" style="display: inline-block;" associatedcontrolid="RevenueTxt" id="RevenueLbl" runat="server">Revenue(€): </div>
                                        <asp:TextBox
                                            ID="RevenueTxt"
                                            runat="server"
                                            CssClass="ASPInputcontent"
                                            Text='<%# Bind("Revenue") %>'
                                            Width="80px"
                                            AutoPostBack="False"
                                            TextMode="SingleLine"
                                            Style="display: inline-block;"
                                            data-parsley-required="true" 
                                            data-parsley-errors-container="#valMsg" />

                                        <div class="css-label" style="display: inline-block; padding: 0 0 0 30px" associatedcontrolid="CostTxt" id="CostLbl" runat="server">Cost(€): </div>
                                        <asp:TextBox
                                            ID="CostTxt"
                                            runat="server"
                                            CssClass="ASPInputcontent"
                                            Text='<%# Bind("Cost") %>'
                                            Width="80px"
                                            AutoPostBack="False"
                                            TextMode="SingleLine"
                                            Style="display: inline-block;" 
                                            data-parsley-required="true" 
                                            data-parsley-errors-container="#valMsg" />
                                    </div>
                                </div>

                                <!-- *** BOTTONI  ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="InsertButton" runat="server" CssClass="orangebutton" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" />
                                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                                </div>
                        </InsertItemTemplate>

                        <EditItemTemplate>
                            <div id="tabs">

                                <ul>
                                    <li><a href="#tabs-1">Canone</a></li>
                                </ul>

                                <div id="tabs-1" style="height: 380px; width: 100%">

                                    <!-- *** CODICE ATTIVITA ***  -->
                                    <div class="input">
                                        <div class="inputtext">Codice Canone: </div>
                                        <asp:TextBox ID="MonthlyCodeTextBox" runat="server" Text='<%# Bind("Monthly_Fee_Code") %>' Columns="15" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" Style="width:200px" />
                                        <!-- *** CHECK BOX  ***  -->
                                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' />
                                        <asp:Label AssociatedControlID="CheckBox1" ID="Label3" runat="server">Attivo</asp:Label>
                                    </div>

                                    <!-- *** PROGETTO ***  -->
                                    <div class="input nobottomborder">
                                        <div class="inputtext">Progetto (forfait):</div>
                                        <asp:DropDownList ID="DDLprogetto" runat="server"
                                            DataTextField="NomeProgetto"
                                            DataValueField="Projects_Id"
                                            AppendDataBoundItems="true"
                                            AutoPostBack="False"
                                            data-parsley-errors-container="#valMsg"
                                            data-parsley-required="true">
                                            <asp:ListItem Value="">-- Seleziona Progetto --</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>

                                    <div class="input nobottomborder">
                                        <!-- *** MANAGER ***  -->
                                        <asp:Label CssClass="inputtext" Visible="false" AssociatedControlID="MangerTxt" ID="MangerLbl" runat="server">Manager:</asp:Label>
                                        <asp:TextBox ID="MangerTxt" runat="server" Visible="false" Text='<%# Bind("NomeManager") %>' MaxLength="15" CssClass="ASPInputcontent" Enabled="False" Width="270px" />
                                    </div>

                                    <div class="input nobottomborder">
                                        <!-- *** ANNO ***  -->
                                        <asp:Label CssClass="inputtext" AssociatedControlID="YearUPD" ID="Year" runat="server">Anno</asp:Label>
                                        <asp:TextBox ID="YearUPD" runat="server" Text='<%# Bind("Year") %>' Width="50" MaxLength="15" CssClass="ASPInputcontent" Enabled="True"
                                            data-parsley-required="true"
                                            data-parsley-type="digits"
                                            data-parsley-errors-container="#valMsg" />

                                        <!-- *** Mese ***  -->
                                        <asp:Label class="css-label" Visible="false" Style="padding: 0px 5px 0px 65px" AssociatedControlID="MonthUPD" ID="Label2" runat="server">Mese</asp:Label>
                                        <asp:TextBox ID="MonthUPD" Visible="false" runat="server" Text='<%# Bind("Month") %>' Width="50" MaxLength="15" CssClass="ASPInputcontent" Enabled="False" />
                                    </div>

                                    <div class="input nobottomborder">
                                        <%--<!-- *** REVENUE *** --%>

                                        <div class="inputtext" style="display: inline-block;" associatedcontrolid="RevenueTxt" id="RevenueLbl" runat="server">Revenue(€): </div>
                                        <asp:TextBox
                                            ID="RevenueTxt"
                                            runat="server"
                                            CssClass="ASPInputcontent"
                                            Text='<%# Bind("Revenue") %>'
                                            Width="80px"
                                            AutoPostBack="False"
                                            TextMode="SingleLine"
                                            Style="display: inline-block;"
                                            data-parsley-required="true"
                                            data-parsley-errors-container="#valMsg" />

                                        <div class="css-label" style="display: inline-block; padding: 0 0 0 30px" associatedcontrolid="CostTxt" id="CostLbl" runat="server">Cost(€): </div>
                                        <asp:TextBox
                                            ID="CostTxt"
                                            runat="server"
                                            CssClass="ASPInputcontent"
                                            Text='<%# Bind("Cost") %>'
                                            Width="80px"
                                            AutoPostBack="False"
                                            TextMode="SingleLine"
                                            Style="display: inline-block;"
                                            data-parsley-required="true"
                                            data-parsley-errors-container="#valMsg" />
                                    </div>
                                </div>

                                <!-- *** BOTTONI  ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="InsertButton" runat="server" CssClass="orangebutton" CommandName="Update" Text="<%$ appSettings: SAVE_TXT %>" />
                                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                                </div>
                        </EditItemTemplate>

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

    <asp:SqlDataSource ID="DSCanoni" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Monthly_Fee.*, Persons.Name as NomeManager 
                   FROM Monthly_Fee 
                   INNER JOIN Projects ON Monthly_Fee.Projects_id = Projects.Projects_Id 
                   INNER JOIN Persons ON Persons.persons_id = Projects.ClientManager_id
                   WHERE Monthly_Fee.Monthly_Fee_id = @Monthly_Fee_id"
        InsertCommand="INSERT INTO Monthly_Fee (Projects_id, ProjectCode, Monthly_Fee_Code, Year, Month, Revenue, Cost, Active, CreatedBy, CreationDate) 
                   VALUES (@Projects_id, @ProjectCode, @Monthly_Fee_Code, @Year, @Month, @Revenue, @Cost, @Active, @CreatedBy, GETDATE())"
        UpdateCommand="UPDATE Monthly_Fee SET Projects_id=@Projects_id, Year=@Year, Revenue=@Revenue, Cost=@Cost, Active=@Active, 
                   LastModifiedBy=@CreatedBy, LastModificationDate=GETDATE() 
                   WHERE Monthly_Fee_id=@Monthly_Fee_id">

        <SelectParameters>
            <asp:QueryStringParameter Name="Monthly_Fee_id" QueryStringField="Monthly_Fee_id" Type="Int32" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="ProjectCode" Type="String" />
            <asp:Parameter Name="Monthly_Fee_Code" Type="String" />
            <asp:Parameter Name="Year" Type="Int32" />
            <asp:Parameter Name="Month" Type="Int32" />
            <asp:Parameter Name="Revenue" Type="Decimal" />
            <asp:Parameter Name="Cost" Type="Decimal" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:Parameter Name="CreatedBy" />
            <asp:Parameter Name="CreationDate" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="Year" Type="Int32" />
            <asp:Parameter Name="Revenue" Type="Decimal" />
            <asp:Parameter Name="Cost" Type="Decimal" />
            <asp:Parameter Name="Active" Type="Boolean" />
            <asp:SessionParameter Name="CreatedBy" SessionField="CreatedBy" Type="String" />
            <asp:Parameter Name="Monthly_Fee_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSpersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name, Active FROM Persons ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSProgetti" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + ' - ' + Name AS NomeProgetto FROM Projects WHERE Active = 1 ORDER BY ProjectCode"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">
        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(function () {
            // abilitate tab view
            $("#tabs").tabs();

            $(":checkbox").addClass("css-checkbox");

            // datepicker
            $("#FVCanoni_TBAttivoDa").datepicker($.datepicker.regional['it']);
            $("#FVCanoni_TBAttivoA").datepicker($.datepicker.regional['it']);

            // Selettore robusto: trova l'ID che finisce con 'RevenueTxt'
            var $importoField = $('[id$="RevenueTxt"]');

            if ($importoField.length) {
                // Esegui la maschera solo se il campo è trovato nel DOM
                $importoField.mask('000.000.000,00', { reverse: true });

                // Per debug: verifica in console se la maschera è stata applicata
                console.log("Maschera applicata a: " + $importoField.attr('id'));

            } else {
                // Per debug: verifica in console se l'elemento NON è stato trovato
                console.warn("ATTENZIONE: Campo RevenueTxt non trovato. Modalità FormView?");
            }
        });

        $(document).ready(function () {
            // Selettore robusto: trova l'ID che finisce con 'RevenueTxt'
            var $importoField = $('[id$="RevenueTxt"],[id$="CostTxt"]');
          
            if ($importoField.length) {
                // Esegui la maschera solo se il campo è trovato nel DOM
                $importoField.mask('000.000.000,00', { reverse: true });

                // Per debug: verifica in console se la maschera è stata applicata
                console.log("Maschera applicata a: " + $importoField.attr('id'));

            } else {
                // Per debug: verifica in console se l'elemento NON è stato trovato
                console.warn("ATTENZIONE: Campo RevenueTxt non trovato. Modalità FormView?");
            }
        });

        Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
        });

        // *** attiva validazione campi form
        $('#formCanoni').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });
    </script>

</body>

</html>

