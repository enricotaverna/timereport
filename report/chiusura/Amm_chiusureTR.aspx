<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Amm_chiusureTR.aspx.cs" Inherits="report_chiusura_Amm_chiusureTR" %>

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
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
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
        <asp:Literal runat="server" Text="Apri Timereport" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-9 RoundedBox">

                    <div class="row">

                        <div class="col-1">
                            <label class="inputtext">Anno</label>
                        </div>
                        <div class="col-5">
                            <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True" OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
                                AutoPostBack="True" CssClass="ASPInputcontent">
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Persona</label>
                        </div>
                        <div class="col-5">
                        <div style="position: absolute">
                            <!-- aggiunto per evitare il troncamento della dropdonwlist -->
                            <asp:DropDownList ID="DDLPersona" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id"
                                OnSelectedIndexChanged="DDLPersona_SelectedIndexChanged"
                                CssClass="ASPInputcontent SumoDLL">
                                <asp:ListItem Text="Tutti i valori" Value="0" />
                            </asp:DropDownList>
                        </div>
                        </div>

                    </div>
                    <!-- End row -->

                    <div class="row mt-2">
                        <!-- margine per separare le righe -->

                        <div class="col-1">
                            <label class="inputtext">Mese</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLMese" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLMese_SelectedIndexChanged" AppendDataBoundItems="True"
                                CssClass="ASPInputcontent" />
                        </div>
                        <div class="col-6"></div>

                    </div>
                    <!-- Fine Row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-9 px-0">

                    <asp:GridView ID="GVLogTR" runat="server" AllowSorting="True" AutoGenerateColumns="False" Style="background-color: white" DataKeyNames="Persons_id"
                        DataSourceID="DSLogTR" CssClass="GridView" AllowPaging="True" PageSize="15" GridLines="None" EnableModelValidation="True" OnRowCommand="GVLogTR_RowCommand" OnRowDataBound="GVLogTR_RowDataBound">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <Columns>
                            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
                            <asp:BoundField DataField="LOGTR_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" HeaderText="LOGTR_id" SortExpression="LOGTR_id" />
                            <asp:BoundField DataField="Anno" HeaderText="Anno" SortExpression="Anno" />
                            <asp:BoundField DataField="Mese" HeaderText="Mese" SortExpression="Mese" />
                            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                            <asp:BoundField DataField="Stato" HeaderText="Stato" SortExpression="Stato" />
                            <asp:BoundField DataField="CreatedBy" HeaderText="Creato da" SortExpression="CreatedBy" />
                            <asp:BoundField DataField="CreationDate" HeaderText="Data creazione" SortExpression="CreationDate" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="LastModifiedBy" HeaderText="Modificato da" SortExpression="LastModifiedBy" />
                            <asp:BoundField DataField="LastModificationDate" HeaderText="Data Modifica" SortExpression="LastModificationDate" DataFormatString="{0:d}" />
                            <asp:BoundField DataField="Persons_id" HeaderText="Persons_id" SortExpression="Persons_id" Visible="False" />

                            <asp:TemplateField ItemStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="BT_lock" runat="server" CausesValidation="False" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                                        CommandName="lock" ImageUrl="/timereport/images/icons/16x16/lock.gif" />
                                    &nbsp;                        
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ItemStyle-Width="20px">
                                <ItemTemplate>
                                    <asp:ImageButton ID="BT_unlock" runat="server" CausesValidation="False" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                                        CommandName="unlock" ImageUrl="/timereport/images/icons/16x16/unlock.gif" />
                                    &nbsp;                        
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource ID="DSPersons" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource ID="DSLogTR" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="*** impostata su backend ***">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLMese" Name="Mese" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2015" Name="Anno" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLPersona" Name="Persona" PropertyName="SelectedValue" />
        </SelectParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $('.SumoDLL').SumoSelect({ search: true });
        $('.SumoSelect').css('width', '220px');

        $(function () {

            // nasconde la colonna con la chiave usata nella cancellazione del record
            $('.hiddencol').css({ display: 'none' });

        });
    </script>

</body>
</html>
