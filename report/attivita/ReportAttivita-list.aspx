<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReportAttivita-list.aspx.cs" Inherits="report_ReportAttivita" %>

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
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<script type="text/javascript">

    window.addEventListener("resize", function () {
        "use strict"; window.location.reload();
    });


    document.addEventListener("DOMContentLoaded", function () {

        // make it as accordion for smaller screens
        if (window.innerWidth > 992) {

            document.querySelectorAll('.navbar .nav-item').forEach(function (everyitem) {

                everyitem.addEventListener('mouseover', function (e) {

                    let el_link = this.querySelector('a[data-bs-toggle]');

                    if (el_link != null) {
                        let nextEl = el_link.nextElementSibling;
                        el_link.classList.add('show');
                        nextEl.classList.add('show');
                    }

                });
                everyitem.addEventListener('mouseleave', function (e) {
                    let el_link = this.querySelector('a[data-bs-toggle]');

                    if (el_link != null) {
                        let nextEl = el_link.nextElementSibling;
                        el_link.classList.remove('show');
                        nextEl.classList.remove('show');
                    }


                })
            });

        }
        // end if innerWidth
    });
	// DOMContentLoaded  end

</script>

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>
        <asp:Literal runat="server" Text="Report Attività" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="NOME_FORM" runat="server" cssclass="StandardForm">

            <div class="row justify-content-center">

                <div  class="StandardForm col-11">

                    <asp:GridView ID="GVAttivita" runat="server" AllowPaging="True" CssClass="GridView"
                        AllowSorting="True" PageSize="15" OnPageIndexChanging="GVAttivita_PageIndexChanging">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" OnClick="BtnExport_Click" />
                        <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>" />
                    </div>

                </div>
                <!--End div-->
            </div>
            <!--End LastRow-->

        </form>

    </div>
    <!-- END MainWindow -->

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
    <script>
        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
    </script>

</body>
</html>
