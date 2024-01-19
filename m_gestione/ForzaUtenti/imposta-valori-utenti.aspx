<%@ Page Language="C#" AutoEventWireup="true" CodeFile="imposta-valori-utenti.aspx.cs" Inherits="m_gestione_ForzaUtenti_imposta_valori_utenti" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<!-- multi-select -->
<script src="/timereport/include/jquery/multiselect/jquery.multi-select.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<!-- multi-select -->
<link href="/timereport/include/jquery/multiselect/multi-select.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Forza Ore e Spese" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <!-- lo stile è cambiato per consentire l'adattamento  -->
        <form name="form1" runat="server" style="overflow-y: visible">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-9">

                    <div id="tabs" style="display: none">

                        <ul>
                            <li><a href="#tabs-1">Progetti</a></li>
                            <li><a href="#tabs-2">Spese</a></li>
                        </ul>

                        <div id="tabs-1" style="height: 450px; width: 100%">

                            <!-- *** spazio bianco nel form ***  -->
                            <p style="margin-bottom: 20px;"></p>

                            <div align="center">

                                <asp:ListBox ID="LBProgetti" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSProgetti"
                                    DataTextField="ProjectName" DataValueField="Projects_Id" Rows="30" OnDataBound="LBProgetti_DataBound">                                    
                                </asp:ListBox>                                
                            </div>

                            <%--                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                --%>
                        </div>
                        <%--tabs-1--%>

                        <div id="tabs-2" style="height: 450px; width: 100%">

                            <!-- *** spazio bianco nel form ***  -->
                            <p style="margin-bottom: 20px;"></p>

                            <div align="center">

                                <asp:ListBox ID="LBSpese" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSExpenseType"
                                    DataTextField="ExpenseTypeName" DataValueField="ExpenseType_Id" Rows="20" OnDataBound="LBSpese_DataBound"></asp:ListBox>
                            </div>

                            <%--                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                --%>
                        </div>
                        <%--tabs-2--%>

                        <!-- *** BOTTONI ***  -->
                        <div class="buttons">                           
                            <asp:Button ID="BTSave" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                            <asp:Button ID="BTreset" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: RESET_TXT %>" />
                            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />                                                        
                            <asp:DropDownList ID="IdPersonaSelezionata" DataSourceID="DSPersone" runat="server" DataTextField="Name" DataValueField="Persons_id" class="input nobottomborder" Visible="true" style="float: left;margin: 6px; 5px 0 0"></asp:DropDownList>
                            <asp:Button ID="BTCopyOn" runat="server" CommandName="Insert" CssClass="orangebutton" Text="Copia Su Utente" style="float:left; width:auto;" />
                        </div>

                    </div>

                </div>
                <!-- FormWrap -->
            </div>
            <!-- LastRow -->
        </form>
        <!-- Form  -->
    </div>
    <!-- container -->

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

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
    <asp:SqlDataSource runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ProjectCode + ' ' + left(Name,20) AS ProjectName, Projects_Id FROM Projects WHERE (Active = 1) ORDER BY ProjectName" ID="DSProgetti"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT ExpenseCode + ' ' + left(Name,20) AS ExpenseTypeName, ExpenseType_Id FROM ExpenseType WHERE (Active = 1) ORDER BY ExpenseTypeName" ID="DSExpenseType"></asp:SqlDataSource>    
    <asp:SqlDataSource runat="server" ID="DSPersone" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // ** NB: deve essere aggiunto un DIV dialog nel corpo HTML
        function ShowPopup(message) {
            $(function () {
                $("#dialog").html(message);
                $("#dialog").dialog({
                    title: "Messaggio",
                    buttons: {
                        Close: function () {
                            $(this).dialog('close');
                        }
                    },
                    modal: true
                });
            });
        };

        $('#LBProgetti').multiSelect({
            selectableHeader: "<div class='multi-select-header'>progetti selezionabili</div>",
            selectionHeader: "<div class='multi-select-header'>abilitazioni <%=sNomeConsulente%></div>",
            dblClick: true
        }
        )
        $('#LBSpese').multiSelect({
            selectableHeader: "<div class='multi-select-header'>spese selezionabili</div>",
            selectionHeader: "<div class='multi-select-header'>abilitazioni <%=sNomeConsulente%></div>",
            dblClick: true
        })

        $("#tabs").tabs(); // abilitate tab view
        $("#tabs").show();

        $("#BTreset").click(function () {

            if ($("#tabs-2").css("display") == "none")  // selezionati progetti
                $('#LBProgetti').multiSelect('deselect_all');
            else // spese
                $('#LBSpese').multiSelect('deselect_all');
            return false;
        });

        $("#BTCopyOn").click(function () {
            console.log($('#LBProgetti'));
            confirm("Sicuri di copiare le abilitazioni di su ");
            return false;
        });

        $("#BTsave").click(function () {

            $(":button").unbind('click');
            document.body.style.cursor = 'wait';
        });


    </script>

</body>

</html>
