<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Straordinari-list.aspx.cs" Inherits="report_Straordinarit_list" EnableEventValidation="false" %>

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

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Lista straordinari" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-10 RoundedBox">
                    <div class="row">
                        <div class="col-1">
                            <label class="inputtext">Società</label>
                        </div>
                        <div class="col-4">
                                <asp:DropDownList ID="DL_societa" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                    DataSourceID="DS_societa" DataTextField="Name" DataValueField="Company_id"
                                    CssClass="ASPInputcontent">
                                    <asp:ListItem Text="Tutti i valori" Value="all" />
                                </asp:DropDownList>
                        </div>
                    </div>
                    <!-- Fine row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!-- Seconda Riga  -->
            <div class="row justify-content-center  pt-3" >

                <div  class="StandardForm col-10">

                    <!-- *** GRID ***  -->
                    <asp:GridView ID="GV_ListaOre" runat="server" CssClass="GridView" GridLines="None" AutoGenerateColumns="False" AllowPaging="True" PageSize="<%$ appSettings: GRID_PAGE_SIZE %>" OnDataBound="GV_ListaOre_DataBound">
                        <HeaderStyle CssClass="GV_header" />
                        <Columns>
                            <asp:BoundField DataField="Nome" HeaderText="Nome" SortExpression="Nome" />
                            <asp:BoundField DataField="Società" HeaderText="Società" />
                            <asp:BoundField DataField="Data" HeaderText="data" />
                            <asp:BoundField DataField="Ore Caricate" HeaderText="Ore" />
                            <asp:BoundField DataField="Ore Contratto" HeaderText="Ore Contratto" />
                            <asp:BoundField DataField="Straordinario" HeaderText="Straordinario" />
                        </Columns>
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle CssClass="GV_row" />
                        <AlternatingRowStyle CssClass="GV_row_alt" />

                        <%--START Pager--%>
                        <PagerStyle CssClass="GV_pager" />
                        <PagerTemplate>
                            <table>
                                <tr>
                                    <td style="width: 180px">
                                        <label id="MessageLabel"
                                            forecolor="white"
                                            text="Select a page:"
                                            runat="server" />
                                        Page: 
                        <asp:DropDownList ID="PageDropDownList"
                            AutoPostBack="true" EnableViewState="true" OnSelectedIndexChanged="Paging_SelectedIndexChanged"
                            runat="server" Width="36px" />
                                    </td>
                                    <td style="width: 520px; text-align: center;">
                                        <asp:LinkButton ID="btnPrevious" runat="server" OnClick="btnPrevious_Click"><</asp:LinkButton>
                                        <asp:Label ID="CurrentPageLabel" ForeColor="white" Text=" Page " runat="server" />
                                        <asp:LinkButton ID="btnNext" runat="server" OnClick="btnNext_Click">></asp:LinkButton>
                                    </td>

                                </tr>
                            </table>
                        </PagerTemplate>
                        <%--END Pager--%>
                    </asp:GridView>

                    <div class="buttons">

                        <%--Messaggio se nessun dato selezionato --%>
                        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>

                        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" OnClick="BtnExport_Click" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>" CssClass="greybutton" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->
            </div>
            <!--End LastRow-->

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
    <asp:SqlDataSource ID="DS_societa" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Company.Company_id, Company.Name, Persons.Active FROM Company INNER JOIN Persons ON Company.Company_id = Persons.Company_id WHERE (Persons.Active = 1) ORDER BY Company.Name"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>
</html>

