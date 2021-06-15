<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Calendario_list.aspx.cs" Inherits="m_Calendario_lookup_list" %>

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
        <asp:Literal runat="server" Text="Calendari" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-6 RoundedBox">

                    <div class="row">
                        <div class="col-1">
                            <label class="inputtext">Sede</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLSede" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLSede_SelectedIndexChanged"
                                CssClass="ASPInputcontent" Width="150px" DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id">
                            </asp:DropDownList>
                        </div>
                        <div class="col-1">
                            <label class="inputtext">Anno</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True" OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
                                AutoPostBack="True" CssClass="ASPInputcontent">
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

                    <!--**** Regola DDL ***-->
                    <!--**** OnSelectedIndexChanged -> Lancia form di dettaglio ***-->
                    <!--**** DataKeyNames -> Per aggiungere valore "selezione tutti" ***-->
                    <!--**** OnRowCommand -> Implementa check su cancellazione ***-->
                    <!--**** OnDataBound -> Cancella tasto "delete" in caso di manager ***-->
                    <asp:GridView ID="GVElenco" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        DataSourceID="DSElenco" CssClass="GridView" OnSelectedIndexChanged="GVElenco_SelectedIndexChanged"
                        AllowPaging="True" PageSize="15" DataKeyNames="CalendarHolidays_id"
                        GridLines="None" EnableModelValidation="True">
                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <Columns>
                            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
                            <asp:BoundField DataField="CalendarHolidays_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" />
                            <asp:BoundField DataField="CalCode" HeaderText="Sede" SortExpression="CalCode" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="CalYear" HeaderText="Anno" SortExpression="CalYear" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="CalDay" HeaderText="Data" SortExpression="CalDay" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:d}" />

                            <asp:TemplateField ItemStyle-Width="20px">
                                <ItemTemplate>

                                    <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("CalendarHolidays_id", "Calendario_form.aspx?CalendarHolidays_id={0}") %>'
                                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                        Text="<%$ appSettings: EDIT_TXT %>" />
                                    &nbsp;
                        
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField ItemStyle-Width="20px">
                                <ItemTemplate>

                                    <asp:ImageButton ID="BT_delete" runat="server" CausesValidation="False"
                                        CommandName="Delete" ImageUrl="/timereport/images/icons/16x16/trash.gif"
                                        Text="<%$ appSettings: DELETE_TXT %>" />

                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />
                    </asp:GridView>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Calendario/Calendario_form.aspx" />
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
    <asp:SqlDataSource ID="DSElenco" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN CODE BEHIND ***"
        DeleteCommand="DELETE FROM [CalendarHolidays] WHERE [CalendarHolidays_id] = @CalendarHolidays_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2018" Name="CalYear" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLSede" Name="Calendar_id" PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="CalendarHolidays_id" />
        </DeleteParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSSede" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Calendar_id, CalName FROM Calendar ORDER BY CalName"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        $(function () {

            // nasconde la colonna con la chiave usata nella cancellazione del record
            $('.hiddencol').css({ display: 'none' });

        });
    </script>


</body>
</html>
