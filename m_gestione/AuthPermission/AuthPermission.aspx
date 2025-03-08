<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AuthPermission.aspx.cs" Inherits="m_gestione_AuthPermission_AuthPermission" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<!--SUMO select-->
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<!--SUMO select-->
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<style type="text/css">
    .SumoSelect {
        width: 280px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Livelli autorizzativi" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-5 StandardForm">

                    <div class="formtitle">Livelli Autorizzativi</div>

                    <!-- *** DDL UserLevel ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Livello"></asp:Label>
                        <asp:DropDownList ID="DDLUserLevel" runat="server" AppendDataBoundItems="True" 
                            AutoPostBack="True" DataSourceID="DSUserLevel" DataTextField="Name" DataValueField="UserLevel_id" OnSelectedIndexChanged="DDLUserLevel_SelectedIndexChanged" >
                            <asp:ListItem Value="" Text="Selezionare una autorizzazione" />
                        </asp:DropDownList>
  
                          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="DDLUserLevel" Display="None"
                            ErrorMessage="Specificare un livello di autorizzazione" InitialValue="0"></asp:RequiredFieldValidator>

                    </div>

                    <div style="position: absolute">
                        <!-- aggiunto per evitare il troncamento della dropdonwlist -->

                        <!-- *** DDL AuthPermission ***  -->
                        <span class="inputtext" style="margin-left: 10px">Autorizzazioni</span>

                        <span>
                            <asp:ListBox ID="LBPermissions" runat="server" SelectionMode="Multiple" DataTextField="PermissionText"
                                DataValueField="Task_id" data-placeholder="Inserisci le autorizzazioni" multiple="multiple" class="select2-auth"></asp:ListBox>
                        </span>

                    </div>

                    <!-- *** spazio bianco nel form ***  -->
                    <p style="margin-bottom: 100px;"></p>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- *** End container *** -->

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
    >
    <asp:SqlDataSource ID="DSUserLevel" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT UserLevel_ID, Name from AuthUserLevel ORDER BY UserLevel_ID"></asp:SqlDataSource>


    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // JQUERY
        $(function () {

            // attiva sumo select
            $(document).ready(function () {

                // crea le label per il raggruppamento degli elementi della ListBox
                setupOptGroups($("#LBPermissions"));

                // imposta css della listbox
                $('.select2-auth').SumoSelect();

            });

        });

        // abilita il raggruppamento nel ListBox generato
        function setupOptGroups(select) {
            var optGroups = new Array();
            var i = 0;

            $(select).find("[optgroup]").each(function (index, domEle) {
                var optGroup = $(this).attr("optgroup");
                if ($.inArray(optGroup, optGroups) == -1) optGroups[i++] = optGroup;
            });

            for (i = 0; i < optGroups.length; i++) {
                $("option[optgroup='" + optGroups[i] + "']").wrapAll("<optgroup label='" + optGroups[i] + "'>");
            }
        }

    </script>

</body>

</html>
