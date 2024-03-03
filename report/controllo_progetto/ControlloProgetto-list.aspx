<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ControlloProgetto-list.aspx.cs" Inherits="report_ControlloProgettoList" EnableEventValidation="false" %>

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
        <asp:Literal runat="server" Text="Controllo progetto" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="NOME_FORM" runat="server" cssclass="StandardForm">

            <div class="row justify-content-center">

                <div  class="StandardForm col-9">

                    <asp:GridView ID="GVAttivita" runat="server" AllowPaging="True" CssClass="GridView"
                        AllowSorting="false" PageSize="15" AutoGenerateColumns="False" EnableModelValidation="True" CellPadding="5" OnPageIndexChanging="GVAttivita_PageIndexChanging" >

                        <FooterStyle CssClass="GV_footer" />
                        <RowStyle Wrap="False" CssClass="GV_row" />
                        <PagerStyle CssClass="GV_footer" />
                        <HeaderStyle CssClass="GV_header" />
                        <AlternatingRowStyle CssClass="GV_row_alt " />

                        <Columns>
                            <asp:TemplateField HeaderText="Stato">
                                    <ItemTemplate>
                                        <asp:Image ID="ImgStato" runat="Server" ImageUrl='<%# Eval("ImgUrl") %>' Height="32px" ImageAlign="Middle" ToolTip='<%# Eval("ToolTip") %>' />
                                    </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" Visible="false" />

                            <asp:BoundField DataField="PName" HeaderText="Progetto" SortExpression="PName" />
                            <asp:BoundField DataField="Director" HeaderText="Director" SortExpression="Director" />
                            <asp:BoundField DataField="TipoContratto" HeaderText="Contratto" SortExpression="TipoContratto"  />

                            <asp:BoundField DataField="RevenueBudget" HeaderText="Budget" SortExpression="RevenueBudget" DataFormatString="{0:###,###;-; }" />
                            <asp:BoundField DataField="RevenueActual" HeaderText="Revenue Act" SortExpression="RevenueActual" DataFormatString="{0:###,###;-; }" />
                            
                            <asp:BoundField DataField="MargineProposta" HeaderText="Margine Bdg" SortExpression="MargineProposta" DataFormatString="{0:P0}" />
                            <asp:BoundField DataField="MargineActual" HeaderText="Margine Act" SortExpression="MargineActual" DataFormatString="{0:P0}" />

                            <%--<asp:BoundField DataField="SpeseActual" HeaderText="Spese Actual" SortExpression="SpeseActual" DataFormatString="{0:###,###.00;-; }" />                          --%>
                            
                            <asp:BoundField DataField="WriteUp" HeaderText="Write Up/Off" SortExpression="WriteUp" DataFormatString="{0:###,###;-###,###; }" />
                            <asp:BoundField DataField="MesiCopertura" HeaderText="Mesi C." SortExpression="MesiCopertura" DataFormatString="{0:###,###.0;-###,###.0; }"/>

<%--                            <asp:BoundField DataField="GiorniActual" HeaderText="Giorni Actual" SortExpression="OreActual" DataFormatString="{0:###,###.00;-; }" />--%>

                            <%--<asp:BoundField DataField="RevenueActual" HeaderText="Revenue Actual" SortExpression="RevenueActual" DataFormatString="{0:###,###.00}" />--%>
                            <%-- Link report revenue --%>
    <%--                        <asp:TemplateField HeaderText="Revenue Actual">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LkRevenue" OnClick="LkRevenue_Click" runat="server" CommandArgument='<%# Eval("Projects_Id") + ";" + Eval("PrimaDataCarico") %> ' CommandName="LkRevenue"><%#  Eval("RevenueActual", "{0:###,###.00}")  %></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>--%>

                            <%--<asp:BoundField DataField="AName" HeaderText="Attività" SortExpression="AName" />--%>
                            <%-- Link anagrafica attività --%>
<%--                            <asp:TemplateField HeaderText="Attività">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LkAttivita" OnClick="LkAttivita_Click" runat="server" CommandArgument='<%# Eval("Activity_id")  + ";" + Eval("Phase_Id") + ";" + Eval("Projects_Id") %> ' CommandName="LkAttivita"><%#  Eval("AName")  %></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>--%>

<%--                            <asp:BoundField DataField="PrimaDataCarico" HeaderText="Data Inizio" SortExpression="PrimaDataCarico" DataFormatString="{0:d}" />
                            <asp:TemplateField HeaderText="DataFine">
                                <ItemTemplate>
                                    <asp:Label ID="DataFine" runat="server" Text='<%# Eval("DataFine", "{0:d}") %>' ToolTip='<%# Eval("TooltipDataFine")%>' BackColor='<%# System.Drawing.Color.FromName(Eval("ColoreDataFine").ToString()) %>'> </asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
<%--                            <asp:BoundField DataField="BudgetABAP" HeaderText="Budget ABAP" SortExpression="BudgetABAP" DataFormatString="{0:###,###.00}" />--%>
<%--                            <asp:BoundField DataField="BudgetNetto" HeaderText="Budget Netto" SortExpression="BudgetNetto" DataFormatString="{0:###,###.00;-; }" />--%>
<%--                            <asp:BoundField DataField="SpeseBudget" HeaderText="Budget Spese" SortExpression="SpeseBudget" DataFormatString="{0:###,###.00}" />--%>
<%--                            <asp:BoundField DataField="MargineProposta" HeaderText="Margine proposta" SortExpression="MargineProposta" DataFormatString="{0:P1}" />--%>
<%--                            <asp:BoundField DataField="BurnRate" HeaderText="Burn Rate" SortExpression="BurnRate" DataFormatString="{0:###,###.00;(0:###,###.00); }" />--%>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("ProjectCode", "ControlloProgetto-form.aspx?ProjectCode={0}") %>'
                                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                        Text="<%$ appSettings: EDIT_TXT %>" />
                                </ItemTemplate>
                            </asp:TemplateField>


                        </Columns>

                    </asp:GridView>

                    <div class="buttons">

                        <%--Messaggio se nessun dato selezionato --%>
                        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>
                        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" style="width:140px"  Text="Download Sintesi" OnClick="BtnExport_Click" />
                        <asp:Button ID="Button1" runat="server" CssClass="orangebutton" style="width:140px" Text="Donwload Dettagli" OnClick="BtnExport_Detail_Click" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>" CssClass="greybutton" />

                    </div>
                    <!--End buttons-->

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
        UnMaskScreen();

    </script>

</body>
</html>
