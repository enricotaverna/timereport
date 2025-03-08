<%@ Page Language="C#" AutoEventWireup="true" CodeFile="activity_lookup_list.aspx.cs" Inherits="m_gestione_Activity_activity_lookup_list" %>

<!DOCTYPE html>

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

<style>
    .inputtext, .ASPInputcontent {
        Width: 170px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" />Lista Attività</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-9 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Attivo</label>
                        </div>
                        <div class="col-5">
                            <asp:DropDownList ID="DL_flattivo" runat="server" class="ASPInputcontent" AutoPostBack="True" OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged">
                                <asp:ListItem Value="99">Tutti i valori</asp:ListItem>
                                <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                                <asp:ListItem Value="0">Non attivo</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-5">
                            <asp:DropDownList ID="DL_progetto" runat="server" class="ASPInputcontent" AutoPostBack="True" AppendDataBoundItems="True"
                                DataSourceID="DSprogetti" DataTextField="iProgetto" DataValueField="Projects_Id"
                                OnSelectedIndexChanged="DL_progetto_SelectedIndexChanged" OnDataBound="DL_progetto_DataBound">
                                <asp:ListItem Text="Tutti i valori" Value="0" />
                            </asp:DropDownList>
                        </div>

                    </div>
                    <!-- End row -->

                    <div class="row mt-2">
                        <!-- margine per separare le righe -->
                        <div class="col-1">
                            <label class="inputtext">Director</label>
                        </div>
                        <div class="col-5">
                            <asp:DropDownList ID="DDLManager" runat="server" class="ASPInputcontent" AutoPostBack="True" OnSelectedIndexChanged="DDLManager_SelectedIndexChanged" AppendDataBoundItems="True"
                                DataSourceID="DSManager" DataTextField="Name" DataValueField="Persons_id" OnDataBound="DDLManager_DataBound">
                                <asp:ListItem Value="0">Tutti i valori</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Attività</label>
                        </div>
                        <div class="col-5">
                            <asp:TextBox ID="TB_Codice" runat="server" CssClass="ASPInputcontent" OnTextChanged="TB_Codice_TextChanged"></asp:TextBox>
                            &nbsp;<asp:Button ID="BTFiltra" runat="server" class="SmallOrangeButton" Text="<%$ appSettings: FILTER_TXT %>" />
                        </div>
                    </div>
                    <!-- Fine Row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-9 px-0">

                    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        DataSourceID="DSAttivita" CssClass="GridView" OnSelectedIndexChanged="GridView1_SelectedIndexChanged"
                        AllowPaging="True" PageSize="12" OnRowDeleting="GridView1_RowDeleting" DataKeyNames="Activity_id,Projectsid,Phaseid"
                        GridLines="None" EnableModelValidation="True" OnPageIndexChanging="GridView1_PageIndexChanging">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                        <Columns>
                            <asp:BoundField DataField="ActivityCode" HeaderText="Attività" SortExpression="ActivityCode" />
                            <asp:BoundField DataField="Name" HeaderText="Descrizione" SortExpression="Name" />
                            <asp:CheckBoxField DataField="Active" HeaderText="Attivo" ReadOnly="True" SortExpression="Active" />
                            <asp:BoundField DataField="NomeProgetto" HeaderText="Nome progetto" SortExpression="NomeProgetto" />
                            <asp:BoundField DataField="NomeManager" HeaderText="Director" SortExpression="NomeManager" />
                            <asp:BoundField DataField="RevenueBudget" HeaderText="Budget(€)" ReadOnly="True" SortExpression="RevenueBudget" DataFormatString="{0:n0}" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="SelectButton" runat="server" CommandName="Select"><i class="fa fa-edit"></i></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete"><i class="fa fa-trash"></i></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Projectsid" HeaderText="Projectsid" Visible="False"
                                SortExpression="Projectsid" />
                            <asp:BoundField DataField="Phaseid" HeaderText="Phaseid" Visible="False"
                                SortExpression="Phaseid" />
                        </Columns>
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/activity/activity_lookup_form.aspx" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

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
    <asp:SqlDataSource ID="DSManager" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSAttivita" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="** costruita in page load **"
        DeleteCommand="DELETE FROM Activity WHERE (Activity_id = @Activity_id)">
        <SelectParameters>
            <asp:ControlParameter ControlID="DL_flattivo" Name="DL_flattivo" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="DL_progetto" Name="DL_progetto" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TB_Codice" DefaultValue="%" Name="TB_codice" PropertyName="Text" />
            <asp:ControlParameter ControlID="DDLmanager" Name="persons_id" PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="Activity_id" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSprogetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_Id, ProjectCode + N'  ' + Name AS iProgetto, ClientManager_id, Active FROM Projects WHERE (ClientManager_id = @managerid OR @selAll = 1 ) AND (Active = 1) AND (ActivityOn = 1) ORDER BY iProgetto"
        OnSelecting="DSprogetti_Selecting">
        <SelectParameters>
            <asp:SessionParameter Name="managerid" SessionField="persons_id" />
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
    </script>

</body>
</html>

