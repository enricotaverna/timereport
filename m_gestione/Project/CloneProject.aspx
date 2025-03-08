<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CloneProject.aspx.cs" Inherits="Templates_TemplateForm" %>

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

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Copia Progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="MainForm" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="Copia Progetto" />
                    </div>

                    <!-- *** Progetto origine ***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Progetto origine:</div>
                        <asp:Label runat="server" ID="ProjectFrom" />
                    </div>

                    <!-- *** CODICE PROGETTO ***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Codice: </div>
                        <asp:TextBox ID="ProjectCode" runat="server" class="ASPInputcontent" Columns="12" MaxLength="10"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-trigger-after-failure="focusout" data-parsley-codiceUnico="" />
                    </div>

                    <!-- *** NOME PROGETTO ***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext">Progetto: </div>
                        <asp:TextBox ID="ProjectName" runat="server" Columns="26" MaxLength="50" class="ASPInputcontent"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                    </div>

                    <!-- *** COPIA FORZATURA ***  -->
                    <div class="input nobottomborder">
                        <div class="inputtext"></div>
                        <asp:CheckBox ID="forceFlag" runat="server" />
                        <asp:Label AssociatedControlID="forceFlag" class="css-label" ID="Label3" runat="server" Text="Copia forzature consulenti"></asp:Label>
                    </div>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <div id="valMsg" class="parsley-single-error"></div>
                        <asp:Button ID="BTCopy" runat="server" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                        <asp:Button ID="BTCancel" runat="server" formnovalidate=""  CssClass="greybutton" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="BTCancel_Click" />
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


    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        UnMaskScreen();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** Esclude i controlli nascosti *** 
        $('#MainForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        // *** messaggio di default
        Parsley.addMessages('it', {
            required: "Completare i campi obbligatori"
        });

        // stile checkbox form    
        $(":checkbox").addClass("css-checkbox");

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

        $("#BTCopy").click(function (e) {

            e.preventDefault();

            var validate 

            if (!$('#MainForm').parsley().validate())
                return;

            var projectCode = $('#ProjectCode').val();
            var projectName = $('#ProjectName').val();
            var forceFlag = $('#forceFlag').is(':checked');

            MaskScreen();

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_Projects.asmx/CopyProject",
                data: JSON.stringify({
                    Project_Id: <%=Request.QueryString["Project_id"]%>,
                    ProjectCode: projectCode,
                    ProjectName: projectName,
                    forceFlag: forceFlag
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    UnMaskScreen();
                    if (response.d.Success) {
                        window.location.href = "/timereport/m_gestione/Project/Projects_lookup_form.aspx?ProjectCode=" + projectCode;
                    } else {
                        ShowPopup(response.d.Message);
                    }
                },
                error: function (xhr, status, error) {
                    UnMaskScreen();
                    ShowPopup("Errore: " + xhr.responseText);
                }
            });
        });


    </script>

</body>

</html>





