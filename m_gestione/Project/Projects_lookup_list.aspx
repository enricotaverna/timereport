<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Projects_lookup_list.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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
    .ASPInputcontent {
        width: 170px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" />Lista Progetti</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-10 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Attivi</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLFlattivo" runat="server" class="ASPInputcontent" AutoPostBack="True" OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged">
                                <asp:ListItem Value="99">Tutti i valori</asp:ListItem>
                                <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                                <asp:ListItem Value="0">Non attivo</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-1"></div>
                        <div class="col-1">
                            <label class="inputtext">Cliente</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLCliente" runat="server" class="ASPInputcontent" AutoPostBack="True" AppendDataBoundItems="True"
                                DataSourceID="DSClienti" DataTextField="Nome1" DataValueField="CodiceCliente"
                                OnSelectedIndexChanged="DDLCliente_SelectedIndexChanged">
                                <asp:ListItem Text="Tutti i valori" Value="0" />
                            </asp:DropDownList>
                        </div>
                    </div>
                    <!-- End row -->

                    <div class="row mt-2">
                        <!-- margine per separare le righe -->

                        <div class="col-1">
                            <label class="inputtext">Mngr/Acnt</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLManager" runat="server" class="ASPInputcontent" AutoPostBack="True" OnSelectedIndexChanged="DDLManager_SelectedIndexChanged" AppendDataBoundItems="True"
                                DataSourceID="DSManager" DataTextField="Name" DataValueField="Persons_id" OnDataBound="DDLManager_DataBound">
                                <asp:ListItem Value="0">Tutti i valori</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-1"></div>
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-4">
                            <asp:TextBox ID="TB_Codice" runat="server" CssClass="ASPInputcontent" OnTextChanged="TB_Codice_TextChanged"></asp:TextBox>
                            &nbsp;<asp:Button class="SmallOrangeButton" ID="Button1" runat="server" Text="<%$ appSettings: FILTER_TXT %>" />
                        </div>
                    </div>
                    <!-- Fine Row -->
                </div>
            <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-10 px-0">

                    <asp:GridView ID="GVProjects" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        DataSourceID="DSProgetti" CssClass="GridView" OnSelectedIndexChanged="GVProjects_SelectedIndexChanged"
                        AllowPaging="True" PageSize="12" DataKeyNames="projectcode,projects_id"
                        GridLines="None" EnableModelValidation="True" OnRowCommand="GVProjects_RowCommand" OnDataBound="GVProjects_DataBound" OnPageIndexChanging="GVProjects_PageIndexChanging">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <Columns>
                            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
                            <asp:BoundField DataField="Projects_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" />
                            <asp:BoundField DataField="ProjectCode" HeaderText="Codice" SortExpression="ProjectCode" />
                            <asp:BoundField DataField="ProjectName" HeaderText="Nome" SortExpression="ProjectName" />
                            <asp:BoundField DataField="ManagerName" HeaderText="Manager" SortExpression="ManagerName" />
                            <asp:BoundField DataField="AccountName" HeaderText="Account" SortExpression="AccountName" />
                            <asp:BoundField DataField="ProjectType" HeaderText="Tipo" SortExpression="ProjectType" />  
                            <asp:BoundField DataField="TipoContrattoDesc" HeaderText="Contratto" SortExpression="TipoContrattoDesc" /> 
                            <asp:BoundField DataField="RevenueBudget" HeaderText="Revenue Bdg" SortExpression="RevenueBudget" DataFormatString="{0:###,###}" />
                            <asp:BoundField DataField="BudgetABAP" HeaderText="Bdg ABAP" SortExpression="BudgetABAP" DataFormatString="{0:###,###}" />
                            <asp:BoundField DataField="SpeseBudget" HeaderText="Spese Bdg" SortExpression="SpeseBudget" DataFormatString="{0:###,###}" />
                            <asp:BoundField DataField="MargineProposta" HeaderText="Margine Tgt" SortExpression="MargineProposta" DataFormatString="{0:P1}" />
                            <asp:CheckBoxField DataField="Active" HeaderText="Attivo" SortExpression="Active" />

                            <asp:TemplateField>
                                <ItemTemplate>

                                    <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("ProjectCode", "Projects_lookup_form.aspx?ProjectCode={0}") %>'
                                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                        Text="<%$ appSettings: EDIT_TXT %>" />
                                    &nbsp;
                        
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <ItemTemplate>

                                    <asp:ImageButton ID="BT_delete" runat="server" CausesValidation="False"
                                        OnClientClick="return confirm('Il record verrà cancellato, confermi?');"
                                        CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                                        CommandName="cancella" ImageUrl="/timereport/images/icons/16x16/trash.gif"
                                        Text="<%$ appSettings: DELETE_TXT %>" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Project/Projects_lookup_form.aspx" />
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
    <asp:SqlDataSource ID="DSCLienti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT CodiceCliente, Nome1 FROM Customers WHERE (FlagAttivo = 1) ORDER BY Nome1"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSProgetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN PAGE BEHIND***">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLFlattivo" Name="DDLFlattivo" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="DDLmanager" Name="persons_id" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLCliente" Name="CodiceCliente" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TB_Codice" Name="TB_Codice" PropertyName="text" DefaultValue="%" />
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
