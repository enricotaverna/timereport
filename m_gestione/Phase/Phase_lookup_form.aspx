<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Phase_lookup_form.aspx.cs" Inherits="m_gestione_Phase_Phase_lookup_list" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<style>
    .ASPInputcontent {
        width: 230px;
    }
</style>

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
        <form id="FormPhase" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="StandardForm col-5">

                    <asp:FormView ID="SchedaFase" runat="server" DataKeyNames="Phase_id"
                        DataSourceID="DSPhase" EnableModelValidation="True" DefaultMode="Insert"
                        align="center" OnItemInserted="SchedaFase_ItemInserted" CssClass="StandardForm"
                        OnItemUpdated="SchedaFase_ItemUpdated" OnModeChanging="SchedaFase_ModeChanging">

                        <EditItemTemplate>

                            <!-- *** TITOLO FORM ***  -->
                            <div class="formtitle">Aggiorna fase</div>

                            <!-- *** CODICE FASE ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Codice Fase: </div>
                                <asp:TextBox ID="PhaseCodeTextBox" runat="server" Text='<%# Bind("PhaseCode") %>' CssClass="ASPInputcontent" Enabled="False" />
                            </div>

                            <!-- *** DESCRIZIONE ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Descrizione: </div>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent"
                                    data-parsley-Maxlength="40" data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                            </div>

                            <!-- *** PROGETTO ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Progetto:</div>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="ASPInputcontent" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>'></asp:DropDownList>
                            </div>

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" formnovalidate="true" />
                            </div>

                        </EditItemTemplate>

                        <InsertItemTemplate>

                            <!-- *** TITOLO FORM ***  -->
                            <div class="formtitle">Inserisci fase</div>

                            <!-- *** DESCRIZIONE ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Codice fase: </div>
                                <asp:TextBox ID="PhaseCodeTextBox" runat="server" Text='<%# Bind("PhaseCode") %>' CssClass="ASPInputcontent"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" />

                            </div>

                            <!-- *** DESCRIZIONE ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Descrizione: </div>
                                <asp:TextBox ID="NameTextBox" runat="server" Text='<%# Bind("Name") %>' CssClass="ASPInputcontent"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                            </div>

                            <!-- *** PROGETTO ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Progetto:</div>
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="ASPInputcontent" DataSourceID="DSProject" DataTextField="ProjectName" DataValueField="Projects_Id" SelectedValue='<%# Bind("Projects_Id") %>' AppendDataBoundItems="True"
                                        data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                        <asp:ListItem Value="" Text="-- Selezionare un valore --" />
                                    </asp:DropDownList>
                            </div>

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" CssClass="orangebutton" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" formnovalidate="true" />
                            </div>

                        </InsertItemTemplate>

                        <ItemTemplate>
                            <%--*** NON UTILIZZATO ***--%>
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
    <asp:SqlDataSource ID="DSPhase" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Phase] WHERE ([Phase_id] = @PhaseId)"
        InsertCommand="INSERT INTO [Phase] ([PhaseCode], [Name], [Projects_id]) VALUES (@PhaseCode, @Name, @Projects_id)"
        UpdateCommand="UPDATE [Phase] SET [PhaseCode] = @PhaseCode, [Name] = @Name, [Projects_id] = @Projects_id WHERE [Phase_id] = @Phase_id">

        <SelectParameters>
            <asp:QueryStringParameter Name="PhaseId" QueryStringField="PhaseId" Type="String" />
        </SelectParameters>
        <InsertParameters>
            <asp:Parameter Name="PhaseCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="PhaseCode" Type="String" />
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="Projects_id" Type="Int32" />
            <asp:Parameter Name="Phase_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSProject" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + N' ' + left(Name,15) AS ProjectName FROM Projects WHERE (ClientManager_id = @ClientManager_id OR @selAll = 1) AND (Active = 1) and ActivityOn = 1"
        OnSelecting="DSProject_Selecting">
        <SelectParameters>
            <asp:Parameter Name="ClientManager_id" />
        </SelectParameters>
        <SelectParameters>
            <asp:Parameter Name="selAll" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** Esclude i controlli nascosti *** 
        $('#FormPhase').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

    </script>

</body>

</html>
