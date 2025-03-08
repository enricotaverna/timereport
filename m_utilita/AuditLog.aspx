<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AuditLog.aspx.cs" Inherits="AuditLog" ValidateRequest="false" %>

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
        <asp:Literal runat="server" Text="Log Audit" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form1" runat="server">

            <!--**** tabella principale ***-->
            <div class="row justify-content-center">
                <div class="col-9 px-0">

                    <asp:GridView
                        ID="GridView1" runat="server" AllowPaging="True"
                        AutoGenerateColumns="False" CssClass="GridView"
                        DataSourceID="DSAudit" EnableModelValidation="True" AllowSorting="True"
                        EnableSortingAndPagingCallbacks="True" PageSize="15">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                        <Columns>
                            <asp:BoundField DataField="TYPE" HeaderText="TYPE" SortExpression="TYPE" />
                            <asp:BoundField DataField="TableName" HeaderText="TableName"
                                SortExpression="TableName" />
                            <asp:BoundField DataField="UpdateDate" HeaderText="UpdateDate"
                                SortExpression="UpdateDate" />
                            <asp:BoundField DataField="FieldName" HeaderText="FieldName"
                                SortExpression="FieldName" />
                            <asp:BoundField DataField="OldValue" HeaderText="OldValue"
                                SortExpression="OldValue" />
                            <asp:BoundField DataField="NewValue" HeaderText="NewValue"
                                SortExpression="NewValue" />
                        </Columns>
                    </asp:GridView>

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <asp:Button runat="server" name="CancelButton" CausesValidation="False" PostBackUrl="" Text="<%$ appSettings: CANCEL_TXT %>" class="greybutton" ID="CancelButton" />
                    </div>

                </div>
                <!-- *** End col *** -->
            </div>
            <!-- *** End row *** -->

        </form>
    </div>
    <!--*** End Container *** -->

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
    <asp:SqlDataSource ID="DSAudit" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT TYPE, TableName, PK, FieldName, OldValue, NewValue, UpdateDate, UserName FROM Audit WHERE (PK = @PK) AND (TableName = @TableName) ORDER BY UpdateDate DESC">
        <SelectParameters>
            <asp:QueryStringParameter Name="PK" QueryStringField="key" Type="String" />
            <asp:QueryStringParameter Name="TableName" QueryStringField="TableName"
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>
</html>

