<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GeneraFestivi-select.aspx.cs" Trace="false" Inherits="calendario_generaFestivi" EnableViewState="True" %>

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
<!-- Sumoselect -->
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<!-- Sumoselect -->
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

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
        <asp:Literal runat="server" Text="Genera Festivi" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
            <form id="Form1" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-5">

                <div class="formtitle">Genera Record Festivi</div>

                <!--  *** PERSONE *** -->
                <div class="input nobottomborder ">
                        <div class="inputtext">Persone</div>
                        <span>
                            <asp:ListBox class="select2-auth" ID="LBPersone" data-parsley-required="true" data-parsley-errors-container="#valMsg" SelectionMode="Multiple" multiple="multiple" runat="server" AppendDataBoundItems="True" DataSourceID="DS_Persone" DataTextField="Name" DataValueField="Persons_id" OnDataBound="LBPersone_DataBinding"></asp:ListBox></span>
                </div>

                <!--  *** LIVELLO  *** -->
                <div class="input nobottomborder ">
                        <div class="inputtext">Tipo utente</div>
                        <span>
                            <asp:ListBox class="select2-auth" ID="LBLivello" data-parsley-required="true" data-parsley-errors-container="#valMsg" SelectionMode="Multiple" multiple="multiple" runat="server" AppendDataBoundItems="True" DataSourceID="DSLivello" DataTextField="Name" DataValueField="UserLevel_id" OnDataBound="LBLivello_DataBinding"></asp:ListBox></span>
                </div>

                <!-- *** spazio bianco nel form ***  -->
                <p style="margin-bottom: 50px;"></p>

                <!--  *** MESE *** -->
                <div class="input nobottomborder ">
                    <div class="inputtext">Mese</div>
                        <asp:DropDownList ID="DDLMese" AppendDataBoundItems="True" runat="server">
                        </asp:DropDownList>
                </div>

                <!--  *** ANNO *** -->
                <div class="input nobottomborder">
                    <div class="inputtext">Anno</div>
                        <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True">
                        </asp:DropDownList>
                </div>

                <div class="buttons">
                    <div id="valMsg" class="parsley-single-error"></div>
                    <asp:Button ID="report" runat="server" Text="<%$ appSettings: EXEC_TXT %>" CssClass="orangebutton" CommandName="report" OnClick="sottometti_Click" />
                    <asp:Button ID="CancelButton" runat="server" formnovalidate="" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                </div>

                </div>
                <%-- END FormWrap  --%>
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- END Contrainer --!>

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

    <!-- *** DATASOURCE *** -->-   
    <asp:SqlDataSource ID="DS_Persone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons WHERE Persons.Active = 'true' ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSLivello" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT UserLevel_id, Name FROM AuthUserLevel ORDER BY UserLevel_id"></asp:SqlDataSource>

	<!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** Esclude i controlli nascosti *** 
        $('#FormEstrai').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        $(document).ready(function () {

            // imposta css della listbox
            $('.select2-auth').SumoSelect({ okCancelInMulti: true, selectAll: true, search: true, searchText: 'Enter here.' });
        });

        // a validazione avvenuta disabilita lo schermo e cambia il cursore in wait
        $('#FormCalendario').parsley().on('form:success', function () {

            //Get the screen height and width
            var maskHeight = $(document).height();
            var maskWidth = $(window).width();

            //Set heigth and width to mask to fill up the whole screen
            $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

            //transition effect		
            //$('#mask').fadeIn(200);
            $('#mask').fadeTo("fast", 0.5);


            document.body.style.cursor = 'wait';
            //$("body").css("cursor", "progress");

        });

    </script>

</body>

</html>

