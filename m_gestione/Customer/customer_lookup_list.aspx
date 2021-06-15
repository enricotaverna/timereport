<%@ Page Language="C#" AutoEventWireup="true" CodeFile="customer_lookup_list.aspx.cs" Inherits="m_gestione_Customer_customer_lookup_list" %>

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
        <asp:Literal runat="server" Text="Anagrafica Clienti" />
    </title>
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
                        <div class="col-4">
                            <asp:DropDownList ID="DL_flattivo" runat="server" AutoPostBack="True"
                                OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged"
                                CssClass="ASPInputcontent">
                                <asp:ListItem Value="99">Tutti i valori</asp:ListItem>
                                <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                                <asp:ListItem Value="0">Non attivo</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Manager</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DL_manager" runat="server" AutoPostBack="True" AppendDataBoundItems="true"
                                DataSourceID="DS_Persone" DataTextField="Name" DataValueField="Persons_id"
                                OnSelectedIndexChanged="DL_manager_SelectedIndexChanged"
                                CssClass="ASPInputcontent" Width="200px">
                                <asp:ListItem Text="Tutti i valori" Value="0" />
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
                <div class="col-9 px-0">

                    <asp:GridView ID="GVCustomers" runat="server" AllowSorting="True"
                        AutoGenerateColumns="False" DataKeyNames="CodiceCliente"
                        DataSourceID="DSCustomer" CssClass="GridView"
                        OnSelectedIndexChanged="GVCustomers_SelectedIndexChanged"
                        OnPageIndexChanging="GVCustomers_PageIndexChanging"
                        OnRowDeleting="GVCustomers_RowDeleting" AllowPaging="True" GridLines="None" PageSize=" 15">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <Columns>
                            <asp:BoundField DataField="CodiceCliente" HeaderText="Cliente"
                                SortExpression="CodiceCliente" />
                            <asp:BoundField DataField="Nome1" HeaderText="Nome" SortExpression="Nome1" />
                            <asp:TemplateField HeaderText="Manager" SortExpression="Name">
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Name") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="PIVA" HeaderText="PIVA" SortExpression="PIVA" />
                            <asp:CheckBoxField DataField="FlagAttivo" HeaderText="Attivo"
                                SortExpression="FlagAttivo" />
                            <asp:BoundField DataField="ClientManager_id" HeaderText="ClientManager_id"
                                SortExpression="ClientManager_id" Visible="False" />
                            <asp:BoundField DataField="TerminiPagamento" HeaderText="Ter. di Pag."
                                SortExpression="TerminiPagamento" />
                            <asp:BoundField DataField="MetodoPagamento" HeaderText="Met. di Pag."
                                SortExpression="MetodoPagamento" />
                            <asp:CommandField ShowDeleteButton="True" ButtonType="Image"
                                DeleteImageUrl="/timereport/images/icons/16x16/trash.gif"
                                SelectImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                ShowSelectButton="True" />
                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/customer/customer_lookup_form.aspx" />
                        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" OnClick="BtnExport_Click" Text="<%$ appSettings: EXPORT_TXT %>" />
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
    <asp:SqlDataSource ID="DSCustomer" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        DeleteCommand="DELETE FROM [Customers] WHERE [CodiceCliente] = @CodiceCliente"
        InsertCommand="INSERT INTO [Customers] ([CodiceCliente], [Nome1], [PIVA], [FlagAttivo], [CodiceFiscale], [SedeLegaleVia1], [SedeLegaleCitta], [SedeLegaleProv], [SedeLegaleCAP], [SedeLegaleNazione], [SedeOperativaVia1], [SedeOperativaCitta], [SedeOperativaProv], [SedeOperativaCAP], [SedeOperativaNazione], [MetodoPagamento], [TerminiPagamento], [ClientManager_id], [Note]) VALUES (@CodiceCliente, @Nome1, @PIVA, @FlagAttivo, @CodiceFiscale, @SedeLegaleVia1, @SedeLegaleCitta, @SedeLegaleProv, @SedeLegaleCAP, @SedeLegaleNazione, @SedeOperativaVia1, @SedeOperativaCitta, @SedeOperativaProv, @SedeOperativaCAP, @SedeOperativaNazione, @MetodoPagamento, @TerminiPagamento, @ClientManager_id, @Note)"
        SelectCommand="SELECT Persons.Name, Customers.* FROM Customers INNER JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id ORDER BY Customers.CodiceCliente"
        UpdateCommand="UPDATE [Customers] SET [Nome1] = @Nome1, [PIVA] = @PIVA, [FlagAttivo] = @FlagAttivo, [CodiceFiscale] = @CodiceFiscale, [SedeLegaleVia1] = @SedeLegaleVia1, [SedeLegaleCitta] = @SedeLegaleCitta, [SedeLegaleProv] = @SedeLegaleProv, [SedeLegaleCAP] = @SedeLegaleCAP, [SedeLegaleNazione] = @SedeLegaleNazione, [SedeOperativaVia1] = @SedeOperativaVia1, [SedeOperativaCitta] = @SedeOperativaCitta, [SedeOperativaProv] = @SedeOperativaProv, [SedeOperativaCAP] = @SedeOperativaCAP, [SedeOperativaNazione] = @SedeOperativaNazione, [MetodoPagamento] = @MetodoPagamento, [TerminiPagamento] = @TerminiPagamento, [ClientManager_id] = @ClientManager_id, [Note] = @Note WHERE [CodiceCliente] = @CodiceCliente">
        <SelectParameters>
            <asp:ControlParameter ControlID="DL_flattivo" Name="DL_flattivo" PropertyName="SelectedValue"
                Type="String" />
            <asp:ControlParameter ControlID="DL_manager" Name="DL_manager"
                PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="CodiceCliente" Type="String" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Nome1" Type="String" />
            <asp:Parameter Name="PIVA" Type="String" />
            <asp:Parameter Name="FlagAttivo" Type="Boolean" />
            <asp:Parameter Name="CodiceFiscale" Type="String" />
            <asp:Parameter Name="SedeLegaleVia1" Type="String" />
            <asp:Parameter Name="SedeLegaleCitta" Type="String" />
            <asp:Parameter Name="SedeLegaleProv" Type="String" />
            <asp:Parameter Name="SedeLegaleCAP" Type="String" />
            <asp:Parameter Name="SedeLegaleNazione" Type="String" />
            <asp:Parameter Name="SedeOperativaVia1" Type="String" />
            <asp:Parameter Name="SedeOperativaCitta" Type="String" />
            <asp:Parameter Name="SedeOperativaProv" Type="String" />
            <asp:Parameter Name="SedeOperativaCAP" Type="String" />
            <asp:Parameter Name="SedeOperativaNazione" Type="String" />
            <asp:Parameter Name="MetodoPagamento" Type="String" />
            <asp:Parameter Name="TerminiPagamento" Type="String" />
            <asp:Parameter Name="ClientManager_id" Type="Int32" />
            <asp:Parameter Name="Note" Type="String" />
            <asp:Parameter Name="CodiceCliente" Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="CodiceCliente" Type="String" />
            <asp:Parameter Name="Nome1" Type="String" />
            <asp:Parameter Name="PIVA" Type="String" />
            <asp:Parameter Name="FlagAttivo" Type="Boolean" />
            <asp:Parameter Name="CodiceFiscale" Type="String" />
            <asp:Parameter Name="SedeLegaleVia1" Type="String" />
            <asp:Parameter Name="SedeLegaleCitta" Type="String" />
            <asp:Parameter Name="SedeLegaleProv" Type="String" />
            <asp:Parameter Name="SedeLegaleCAP" Type="String" />
            <asp:Parameter Name="SedeLegaleNazione" Type="String" />
            <asp:Parameter Name="SedeOperativaVia1" Type="String" />
            <asp:Parameter Name="SedeOperativaCitta" Type="String" />
            <asp:Parameter Name="SedeOperativaProv" Type="String" />
            <asp:Parameter Name="SedeOperativaCAP" Type="String" />
            <asp:Parameter Name="SedeOperativaNazione" Type="String" />
            <asp:Parameter Name="MetodoPagamento" Type="String" />
            <asp:Parameter Name="TerminiPagamento" Type="String" />
            <asp:Parameter Name="ClientManager_id" Type="Int32" />
            <asp:Parameter Name="Note" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_Persone" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Customers ON Persons.Persons_id = Customers.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
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

