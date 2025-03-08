<%@ Page Language="C#" AutoEventWireup="true" CodeFile="change-password.aspx.cs" Inherits="Templates_TemplateForm" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
                    </div>

                    <!-- *** OLD PWD ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" Style="width: 160px" runat="server" Text="Vecchia Password" meta:resourcekey="Label1Resource1"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBOldPwd" runat="server" MaxLength="10"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-username="" data-parsley-trigger-after-failure="focusout"
                            meta:resourcekey="TBOldPwdResource1" />
                    </div>

                    <!-- *** NEW PWD1 ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" Style="width: 160px" runat="server" Text="Nuova Password" meta:resourcekey="Label2Resource1"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd1" runat="server" minlength="3" MaxLength="10"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" meta:resourcekey="TBNewPwd1Resource1" />
                    </div>

                    <!-- *** NEW PWD2 ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" Style="width: 160px" runat="server" Text="Conferma Password" meta:resourcekey="Label3Resource1"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd2" runat="server" minlength="3" MaxLength="10"
                            data-parsley-errors-container="#valMsg" data-parsley-equalto="#TBNewPwd1" data-parsley-required="true"
                            meta:resourcekey="TBNewPwd2Resource1" />
                    </div>

                    <div class="input nobottomborder">
                        <asp:Literal runat="server" Text="<%$ Resources:testohelp%>" />
                    </div>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <div id="valMsg" class="col parsely-single-error"></div>
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" OnClick="InsertButton_Click" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CommandName="Cancel" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" formnovalidate />
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

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // Lingua
        window.Parsley.setLocale('<%=CurrentSession.Language%>');

        // *** Validazione che richiama un servizio, bisogna mettere il tag data-parsley-username sull'elemento del form *** //
        window.Parsley.addValidator('username', function (value, requirement) {
            var response = false;
            var dataAjax = "{ sPassword: '" + value + "' , " + " sUserName: '<%=CurrentSession.Persons_id%>' }"

            $.ajax({
                url: "/timereport/webservices/WStimereport.asmx/CheckPassword",
                data: dataAjax,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false,
                success: function (data) {
                    if (data.d == "false")
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
            .addMessage('en', 'username', 'Password not valid')
            .addMessage('it', 'username', 'Password non valida');

        $('#FVMain').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

    </script>

</body>

</html>




