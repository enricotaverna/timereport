<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Calendario_form.aspx.cs"
    Inherits="Calendario_lookup_form" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Calendario" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FormHolidays" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                <!-- *** TITOLO FORM ***  -->
                <div class="formtitle">Giorno Festivo</div>

                <asp:FormView ID="FVForm" runat="server" DataKeyNames="CalendarHolidays_id" DataSourceID="DSCalendarHolidays"
                    EnableModelValidation="True" DefaultMode="Insert" class="StandardForm"
                    OnItemUpdated="FVForm_ItemUpdated" OnModeChanging="ItemModeChanging_FVForm" Width="100%" OnItemInserted="FVForm_ItemInserted">

                    <EditItemTemplate>
                        <!-- USATO SIA IN INSERT CHE UPDATE -->

                        <!-- *** SEDE ***  -->
                        <div class="input">
                            <div class="inputtext">Sede:</div>
                            <label class="dropdown" >
                                <asp:DropDownList ID="DDLSede" runat="server" AppendDataBoundItems="True"
                                    DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'
                                    data-parsley-errors-container="#valMsg" required="">
                                </asp:DropDownList>
                            </label>
                        </div>

                        <!-- *** DATE ***  -->
                        <div class="input nobottomborder">
                            <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Festivo:"></asp:Label>
                            <asp:TextBox CssClass="ASPInputcontent" ID="TBCalDay" runat="server" Style="width: 140px" Text='<%# Bind("CalDay" ,"{0:d}") %>' autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required="" />
                        </div>

                        <!-- *** BOTTONI  ***  -->
                        <div class="buttons">
                            <div id="valMsg" class="parsley-single-error"></div>
                            <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CssClass="orangebutton" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" />
                            <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                        </div>

                    </EditItemTemplate>

                    <ItemTemplate>

                        <!-- *** SEDE ***  -->
                        <div class="input">
                            <div class="inputtext">Sede:</div>
                            <label class="dropdown" style="width: 265px">
                                <asp:DropDownList ID="DDLSede" runat="server" AppendDataBoundItems="True"
                                    DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'
                                    data-parsley-errors-container="#valMsg" required="">
                                </asp:DropDownList>
                            </label>
                        </div>

                        <!-- *** DATE ***  -->
                        <div class="input nobottomborder">
                            <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Festivo:"></asp:Label>
                            <asp:TextBox CssClass="ASPInputcontent" ID="TBCalDay" runat="server" Style="width: 140px" Text='<%# Bind("CalDay","{0:d}") %>' autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" required="" />
                        </div>

                        <!-- *** BOTTONI  ***  -->
                        <div class="buttons">
                            <div id="valMsg" class="parsley-single-error"></div>
                            <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CssClass="orangebutton" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>" />
                            <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="" />
                        </div>

                    </ItemTemplate>

                </asp:FormView>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
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

    <!-- *** JAVASCRIPT *** -->
    <asp:SqlDataSource ID="DSCalendarHolidays" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        InsertCommand="INSERT INTO [CalendarHolidays] ([Calendar_id], [CalYear], [CalDay]) VALUES (@Calendar_id, @CalYear, @CalDay)"
        SelectCommand="SELECT * FROM [CalendarHolidays] WHERE CalendarHolidays_id = @CalendarHolidays_id"
        UpdateCommand="UPDATE [CalendarHolidays] SET [Calendar_id] = @Calendar_id, [CalYear] = @CalYear, [CalDay] = @CalDay WHERE [CalendarHolidays_id] = @CalendarHolidays_id"
        OnInserting="DSCalendarHolidays_Inserting"
        OnUpdating="DSCalendarHolidays_Inserting">
        <SelectParameters>
            <asp:QueryStringParameter Name="CalendarHolidays_id" QueryStringField="CalendarHolidays_id" />
        </SelectParameters>

        <InsertParameters>
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="CalYear" Type="Int32" />
            <asp:Parameter Name="CalDay" Type="DateTime" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="CalYear" Type="Int32" />
            <asp:Parameter Name="CalDay" Type="DateTime" />
            <asp:Parameter Name="CalendarHolidays_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DSSede" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Calendar_id, CalName FROM Calendar ORDER BY CalName"></asp:SqlDataSource>

	<!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** Page Load ***  
        $(function () {

            $("#FVForm_TBCalDay").datepicker($.datepicker.regional['it']);

        });

        // *** Esclude i controlli nascosti *** 
        $('#FormHolidays').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

    </script>

</body>

</html>
