<%@ Page Language="C#" AutoEventWireup="true" CodeFile="upload-expenses-xls.aspx.cs" Inherits="m_utilita_upload_expenses_xls1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Upload Spese</title>

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

        <form id="fileUpload" runat="Server" enctype="multipart/form-data">

            <div class="row justify-content-center pt-3">

                <div id="FormWrap" class="StandardForm col-8">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
                    </div>

                    <div class="row p-2">
                        <div class="col-2"></div>
                        <div class="col-7">
                            <asp:FileUpload ID="FUFile" runat="server" meta:resourcekey="FileUpload1Resource1" 
                            data-parsley-required="true"  data-parsley-errors-container="#valMsg"/>
                            <asp:CheckBox ID="simulazione" runat="server" Text=" Esecuzione di prova" Checked="True" meta:resourcekey="simulazioneResource1" />
                        </div>
                    </div>

                    <div class="row p-2">
                        <div class="col-2">
                            <asp:Literal runat="server" Text="<%$ Resources:logcscarti%>" />
                        </div>
                        <div class="col-7">
                            <asp:TextBox ID="messaggio" runat="server" BackColor="#E2E2E2" Rows="5" TextMode="MultiLine"
                                Columns="80" meta:resourcekey="messaggioResource1"></asp:TextBox>
                        </div>
                    </div>

                    <div class="row p-2 pb-4">
                        <div class="col-2">
                            <asp:Literal runat="server" Text="<%$ Resources:logcaricamento%>" />
                        </div>
                        <div class="col-7">
                            <asp:TextBox ID="recordOK" runat="server" BackColor="#E2E2E2" Rows="5" TextMode="MultiLine"
                                Columns="80" meta:resourcekey="recordOKResource1"></asp:TextBox>
                        </div>
                    </div>

                            <!-- *** BOTTONI  ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsley-single-error"></div>
                                <asp:Button type="submit" class="orangebutton" ID="UploadFile" Text="Upload File" runat="server" OnClick="btnUpload_Click"  meta:resourcekey="UploadFileResource1" />&nbsp;&nbsp;
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>"  formnovalidate="" />
                            </div>

                </div>
                <!-- *** End FormWrap *** -->
            </div>
            <!-- End Row -->

            <!-- *** Istruzioni *** -->
            <div class="row justify-content-center pt-3">
                <div class="col-8 RoundedBox">
                    <asp:Label CssClass="h5" runat="server" Text='<%$ Resources:istruzioni%>' />
                    <ul class="mt-2">
                        <li>
                            <asp:Literal runat="server" Text="<%$ Resources:istr_riga1%>" />
                            <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank" NavigateUrl="/timereport/m_utilita/template/templateSpese.xlsx" meta:resourcekey="HyperLink1Resource1" CssClass="link-primary">template excel</asp:HyperLink>
                        </li>
                        <li>
                            <asp:Literal runat="server" Text="<%$ Resources:istr_riga2%>" />
                        </li>
                        <li>
                            <asp:Literal runat="server" Text="<%$ Resources:istr_riga3%>" /></li>
                    </ul>
                </div>
            </div>
            <!-- End Row -->
        </form>

    </div>
    <!-- END MainWindowBackground -->

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
    <script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="/timereport/include/BTmenu/menukit.js"></script>
    <script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>
    <script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
    <script src="/timereport/include/parsley/parsley.min.js"></script>
    <script src="/timereport/include/parsley/it.js"></script>
    <script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
    <script src="/timereport/include/jquery/jquery-ui.min.js"></script>
    <script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>

    <script type="text/javascript">
        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $("#UploadFile").click(function () {
            $('#fileUpload').parsley().validate();
            if (!$('#fileUpload').parsley().isValid())
                return;
            MaskScreen(true);
        });

        $("#recordOK").on('change', function () {
            UnMaskScreen();
        });

        // *** attiva validazione campi form
        $('#fileUpload').parsley({});
    </script>

</body>
</html>