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

<!-- ToolTip jquey add-in  -->
<script type="text/javascript" src="/timereport/include/jquery/tooltip/jquery.smallipop.min.js"></script>

<!-- Sheet.js add-in  -->
<script src="https://cdn.sheetjs.com/xlsx-0.20.1/package/dist/xlsx.full.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />
<link href="/timereport/include/jquery/tooltip/jquery.smallipop.css" rel="stylesheet" />

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

        <div id='mask'></div>

        <form id="NOME_FORM" runat="server" cssclass="StandardForm">

            <div class="row justify-content-center">

                <div class="StandardForm col-9">

                    <div id="wrapper" style="font-size: 14px; font-family: OpenSans-Regular; max-width: 1000px; max-height: 600px; overflow-y: scroll;">

                        <asp:GridView ID="GVAttivita" runat="server" AllowPaging="False" CssClass="GridView"
                            OnRowDataBound="GVAttivita_RowDataBound"
                            AllowSorting="false" PageSize="15" AutoGenerateColumns="False" EnableModelValidation="True" CellPadding="5">

                            <FooterStyle CssClass="GV_footer" />
                            <RowStyle Wrap="False" CssClass="GV_row" />
                            <PagerStyle CssClass="GV_footer" />
                            <HeaderStyle CssClass="GV_header" />
                            <AlternatingRowStyle CssClass="GV_row_alt " />

                            <Columns>
                                <asp:TemplateField HeaderText="Stato">
                                    <ItemTemplate>
                                        <asp:Image class="imageClass" ID="ImgStato" runat="Server" ImageUrl='<%# Eval("ImgUrl") %>' Height="32px" ImageAlign="Middle" title='<%# Eval("ToolTip") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="status" HeaderText="status" SortExpression="status" Visible="false" />

                                <asp:BoundField DataField="PName" HeaderText="Progetto" SortExpression="PName" />
                                <asp:BoundField DataField="Director" HeaderText="Director" SortExpression="Director" />
                                <asp:BoundField DataField="TipoContratto" HeaderText="Contratto" SortExpression="TipoContratto" />
                                <asp:BoundField DataField="DataFine" HeaderText="Data Fine" SortExpression="DataFine" DataFormatString="{0:dd/MM/yyyy}" />

                                <asp:BoundField DataField="RevenueBDG" HeaderText="Budget" SortExpression="RevenueBDG" DataFormatString="{0:###,###;-; }" />
                                <asp:BoundField DataField="RevenueACT" HeaderText="Revenue ACT" SortExpression="RevenueACT" DataFormatString="{0:###,###;-; }" />

                                <asp:BoundField DataField="MargineProposta" HeaderText="Margine BDG" SortExpression="MargineProposta" DataFormatString="{0:#.#%;-#.#%;}" />
                                <asp:BoundField DataField="MargineEAC" HeaderText="Margine EAC" SortExpression="MargineEAC" DataFormatString="{0:#.##%;-#.##%;}" />

                                <%--<asp:BoundField DataField="SpeseActual" HeaderText="Spese Actual" SortExpression="SpeseActual" DataFormatString="{0:###,###.00;-; }" />                          --%>

                                <asp:BoundField DataField="WriteUp" HeaderText="Write Up/Off" SortExpression="WriteUp" DataFormatString="{0:###,###;-###,###; }" />
                                <asp:BoundField DataField="MesiCopertura" HeaderText="Mesi C." SortExpression="MesiCopertura" DataFormatString="{0:###,###.0;-###,###.0; }" />

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="BT_edit" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("ProjectCode", "ControlloProgetto-form.aspx?ProjectCode={0}") %>'
                                            CommandName="Edit" CssClass="fa fa-edit" Font-Size="Large" ForeColor="#333333" />
                                    </ItemTemplate>
                                </asp:TemplateField>


                            </Columns>

                        </asp:GridView>
                    </div>

                    <div class="buttons">

                        <%--Messaggio se nessun dato selezionato --%>
                        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>
                        <asp:Button ID="btn_ExportSintesi" runat="server" CssClass="orangebutton" Style="width: 140px" Text="Download Sintesi"   />
                        <asp:Button ID="btn_ExportDettagli" runat="server" CssClass="orangebutton" Style="width: 140px" Text="Donwload Dettagli"  />
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

        $("#btn_ExportDettagli").click(function (e) {

            e.preventDefault()
            MaskScreen(true); // cursore e finestra modale
            
            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_SheetJS.asmx/ControlloProgetto_ExportDetailHoursWithCost",
                //data: values, no input needed
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    UnMaskScreen();
                    downloadExcel(msg.d, "Hours", "ExportDetailHours.xlsx"); // dati, nome sheet, nome file
                },
                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    alert(xhr.responseText);
                }
            }); // ajax

        });

        $("#btn_ExportSintesi").click(function (e) {
            e.preventDefault()
            MaskScreen(true); // cursore e finestra modale

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_SheetJS.asmx/ControlloProgetto_ExportSintesi",
                //data: values, no input needed
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    UnMaskScreen();
                    downloadExcel(msg.d, "Progetti", "ExportSintesi.xlsx"); // dati, nome sheet, nome file
                },
                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    alert(xhr.responseText);
                }
            }); // ajax

        });

        // tooltip : hideDelay default 500, riduce tempo prima che sia nascosto il tooltip
        $('.imageClass').smallipop({
            hideDelay: 0,
            theme: 'blue',
            popupDelay: 0
        });

    </script>

</body>
</html>
