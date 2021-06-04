<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Phase_lookup_list.aspx.cs" Inherits="m_gestione_Phase_Phase_lookup_list" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<style>
    .inputtext, .ASPInputcontent { Width: 170px; }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Anagrafica fasi" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-6 RoundedBox">
                    <div class="row">
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DL_progetto" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                DataSourceID="DSprogetti" DataTextField="iProgetto" DataValueField="Projects_Id"
                                OnSelectedIndexChanged="DL_progetto_SelectedIndexChanged1" OnDataBound="DL_progetto_DataBound"
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

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-6 px-0">

                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="GridView"
                        AutoGenerateColumns="False" DataKeyNames="Phase_id"
                        DataSourceID="DSPhase" EnableModelValidation="True"
                        OnRowDeleting="GridView1_RowDeleting" GridLines="None"
                        OnSelectedIndexChanged="GridView1_SelectedIndexChanged" AllowSorting="True" PageSize="15">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                        <Columns>
                            <asp:BoundField DataField="NomeProgetto" HeaderText="Progetto"
                                SortExpression="NomeProgetto" ReadOnly="True" />
                            <asp:BoundField DataField="NomeFase" HeaderText="Fase"
                                SortExpression="NomeFase" />
                            <asp:BoundField DataField="Phase_id" HeaderText="Phaseid" Visible="False"
                                SortExpression="Phase_id" />
                            <asp:CommandField ShowDeleteButton="True" ShowSelectButton="True" ButtonType="Image" HeaderText="Azioni"
                                DeleteImageUrl="/timereport/images/icons/16x16/trash.gif" SelectImageUrl="/timereport/images/icons/16x16/modifica.gif" />
                        </Columns>
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton"
                            PostBackUrl="/timereport/m_gestione/Phase/Phase_lookup_form.aspx" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.CutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DSPhase" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        DeleteCommand="DELETE FROM Phase WHERE (Phase_id = @Phase_id)"
        SelectCommand="*** costruita in page load ***">

        <SelectParameters>
            <asp:SessionParameter Name="sel_managerid" SessionField="persons_id" />
            <asp:ControlParameter ControlID="DL_progetto" Name="DL_progetto" PropertyName="SelectedValue" />
        </SelectParameters>

        <DeleteParameters>
            <asp:Parameter Name="Phase_id" Type="Int32" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSprogetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + N'  ' + Name AS iProgetto, ClientManager_id, Active FROM Projects WHERE (ClientManager_id = @managerid) AND (Active = 1) and (ActivityOn = 1) ORDER BY iProgetto">
        <SelectParameters>
            <asp:SessionParameter Name="managerid" SessionField="persons_id" />
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
