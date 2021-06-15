<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cutoff.aspx.cs" Inherits="Templates_TemplateForm" %>

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
        <asp:Literal runat="server" Text="Cutoff" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="Form1" runat="server">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <div class="formtitle">
                        <asp:Literal runat="server" Text="Cutoff" />
                    </div>

                    <asp:FormView ID="FVMain" runat="server" DataSourceID="dsOptions" CssClass="StandardForm" Width="100%" DefaultMode="Edit">
                        <EditItemTemplate>

                            <!-- *** Periodo ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Periodo:</div>
                                    <asp:DropDownList runat="server" ID="DDLPeriodo" DataValueField="cutoffPeriod" SelectedValue='<%# Bind("cutoffPeriod") %>'>
                                        <asp:ListItem Text="15 del mese" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Fine Mese" Value="2"></asp:ListItem>
                                    </asp:DropDownList>
                            </div>

                            <!-- *** Mese ***  -->
                            <div class="input nobottomborder">
                                <div class="inputtext">Mese:</div>
                                    <asp:DropDownList runat="server" ID="DDLMese" DataValueField="cutoffMonth" SelectedValue='<%# Bind("cutoffMonth")%>'>
                                        <asp:ListItem Text="Gennaio" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Febbraio" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="Marzo" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="Aprile" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="Maggio" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="Giugno" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="Luglio" Value="7"></asp:ListItem>
                                        <asp:ListItem Text="Agosto" Value="8"></asp:ListItem>
                                        <asp:ListItem Text="Settembre" Value="9"></asp:ListItem>
                                        <asp:ListItem Text="Ottobre" Value="10"></asp:ListItem>
                                        <asp:ListItem Text="Novembre" Value="11"></asp:ListItem>
                                        <asp:ListItem Text="Dicembre" Value="12"></asp:ListItem>
                                    </asp:DropDownList> 
                            </div>

                            <!-- *** Anno ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Anno" meta:resourcekey="Label3Resource1"></asp:Label>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBAnno" runat="server" MaxLength="5" Text='<%# Bind("cutoffYear") %>'
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg" data-parsley-type="integer" data-parsley-min="2018" Columns="5" />
                            </div>

                            <!-- *** BOTTONI ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                                <asp:Button ID="InsertButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />
                            </div>

                        </EditItemTemplate>

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

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource runat="server" ID="dsOptions" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Options]"
        UpdateCommand="UPDATE Options SET cutoffPeriod=@cutoffPeriod, cutoffMonth=@cutoffMonth, cutoffYear=@cutoffYear "
        OnUpdated="dsOptions_Updated">

        <UpdateParameters>
            <asp:Parameter Name="cutoffPeriod" Type="Int32" />
            <asp:Parameter Name="cutoffMonth" Type="Int32" />
            <asp:Parameter Name="cutoffYear" Type="Int32" />
        </UpdateParameters>

    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // *** Esclude i controlli nascosti *** 
        $('#cutoffForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

    </script>

</body>

</html>





