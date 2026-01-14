<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-ore.aspx.cs" Inherits="input_ore" EnableEventValidation="False" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<!--SUMO select-->
<script src="/timereport/include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
    </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FormOre" runat="server" data-parsley-validate>

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-5 StandardForm">

                    <asp:FormView ID="FVore" runat="server" DataKeyNames="Hours_Id"
                        DataSourceID="DSore" align="center" DefaultMode="Edit"
                        OnDataBound="FVore_DataBound"
                        CellPadding="0">

        <%-- EDIT --%>
        <EditItemTemplate>

                            <div class="formtitle">
                                <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                                <a href="./m_utilita/AuditLog.aspx?RecordId=<%=Request.QueryString["hours_id"]%>&TableName=Hours&TYPE=U&key=<Hours_Id=<%=Request.QueryString["hours_id"] %>>">
                                    <asp:Image ID="Image1" runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="Image1Resource1" /></a>
                            </div>

                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource1"></asp:Label>
                                <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource1"></asp:Label>
                                <asp:Label ID="Label13" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="Label13Resource1"></asp:Label>
                            </div>

                            <!-- *** DDL Progetto ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource1"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLprogettoResource1"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Attività ***  -->
                            <div class="input nobottomborder" id="lbDDLAttivita">
                                <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource1"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLAttivitaResource1"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true">
                                    <asp:ListItem meta:resourcekey="ListItemResource1">--seleziona attività--</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Opportunità ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Luogo" meta:resourcekey="Label2"></asp:Label>
                                <asp:DropDownList ID="DDLLocation" runat="server" AppendDataBoundItems="True"  Width="270px"
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                    <asp:ListItem>-- seleziona valore --</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBLocation" runat="server" Width="270px" Text='<%# Bind("LocationDescription") %>'
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                            </div>

                            <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                            <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>
                            <asp:DropDownList ID="DDLHiddenLocation" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                            <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource1"></asp:Label>
                                <span class="input2col" id="spanHours" runat="server">
                                    <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource1"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true" />
                                </span>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource1" />
                                <asp:Label ID="CancelFlagLabel" AssociatedControlID="CancelFlagCheckBox" runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

                            </div>

                            <!-- *** DDL Task Name ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="lblTaskName" runat="server" Text="Task Name"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLTaskName" runat="server" AppendDataBoundItems="True" Width="376" AutoPostBack="false"
                                    meta:resourcekey="DDLTaskName1" data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                                <asp:Button Text="Refresh" CssClass="greybutton" runat="server" ID="btnRefresh" OnClick="btnRefresh_Click" />
                            </div>

                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Nota" meta:resourcekey="Label1Resource1"></asp:Label>
                                <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea"
                                    Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource1"
                                    data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="" data-parsley-testo-obbligatorio="true" />
                            </div>

                            <!-- *** TB Competenza ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource1"></asp:Label>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource1" autocomplete="off"
                                    data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                            </div>

                            <!-- *** BOTTONI ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsely-single-error"></div>
                                <asp:Button ID="PostButton" runat="server" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" />
                                <asp:Button ID="CancelButton" runat="server" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate  />
                            </div>

                        </EditItemTemplate>

            <%-- INSERT --%>
            <InsertItemTemplate>

                            <div class="formtitle">
                                <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                            </div>

                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource2"></asp:Label>
                                <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date") %>' meta:resourcekey="LBdateResource2"></asp:Label>
                                <asp:Label ID="LBperson" runat="server" Text='<%# Bind("persons_id") %>' meta:resourcekey="LBpersonResource1"></asp:Label>
                            </div>

                            <!-- *** DDL Progetto ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource2"></asp:Label>

                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLprogettoResource2" data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>

                            </div>

                            <!-- *** DDL Attività ***  -->
                            <div class="input nobottomborder" id="lbDDLAttivita">
                                <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource2"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLAttivitaResource2" data-parsley-required="true"
                                    data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Opportunity ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Luogo" meta:resourcekey="Label2"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLLocation" runat="server" AppendDataBoundItems="True"  Width="270px"
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBLocation" runat="server" Width="270px"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" />
                            </div>

                            <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                            <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>
                            <asp:DropDownList ID="DDLHiddenLocation" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                            <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource2"></asp:Label>
                                <span runat="server" id="spanHours" class="input2col">
                                    <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" AutoPostBack="false" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource2"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$" data-parsley-required="true" />
                                </span>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource2" />
                                <asp:Label ID="CancelFlagLabel" AssociatedControlID="CancelFlagCheckBox" runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

                            </div>

                            <!-- *** DDL Task Name ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="lblTaskName" runat="server" Text="Task Name"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLTaskName" runat="server" AppendDataBoundItems="True" Width="376px" AutoPostBack="false"
                                    meta:resourcekey="DDLTaskName2" data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                                <asp:Button Text="Refresh" CssClass="greybutton" runat="server" ID="btnRefresh" OnClick="btnRefresh_Click" />
                            </div>
                            
                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Nota" meta:resourcekey="Label1Resource2"></asp:Label>
                                <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea"
                                    Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource2"
                                    data-parsley-validate-if-empty="" data-parsley-errors-container="#valMsg" data-parsley-testo-obbligatorio="true" />
                            </div>

                            <!-- *** TB Competenza ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource2"></asp:Label>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate") %>' Columns="8" meta:resourcekey="TBAccountingDateResource2" autocomplete="off"
                                    data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                            </div>

                            <!-- *** BOTTONI ***  -->
                            <div class="buttons">
                                <div id="valMsg" class="parsely-single-error"></div>
                                <asp:Button ID="PostButton" runat="server" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" />
                                <asp:Button ID="CancelButton" runat="server" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate  />
                            </div>

            </InsertItemTemplate>

                        <%-- DISPLAY --%>
                        <ItemTemplate>
                            <div class="formtitle">
                                <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                                <a href="./m_utilita/AuditLog.aspx?RecordId=<%=Request.QueryString["hours_id"]%>&TableName=Hours&TYPE=U&key=<Hours_Id=<%=Request.QueryString["hours_id"] %>>">
                                    <asp:Image runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="ImageResource1" /></a>
                            </div>

                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource3"></asp:Label>
                                <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource3"></asp:Label>
                                <asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource2"></asp:Label>
                            </div>

                            <!-- *** DDL Progetto ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource3"></asp:Label>
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    Enabled="False"
                                    meta:resourcekey="DDLprogettoResource3">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Attività ***  -->
                            <div class="input nobottomborder" id="lbDDLAttivita">
                                <asp:Label CssClass="inputtext" ID="Label8" runat="server" Text="Attività" meta:resourcekey="Label8Resource1"></asp:Label>
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    Enabled="False" meta:resourcekey="DDLAttivitaResource3">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Opportunità ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"
                                    Enabled="False">
                                </asp:DropDownList>
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Luogo" meta:resourcekey="Label2"></asp:Label>
                                <asp:DropDownList ID="DDLLocation" runat="server" AppendDataBoundItems="True" Enabled="False">   
                                </asp:DropDownList>
                                <asp:TextBox CssClass="ASPInputcontent" Enabled="False" ID="TBLocation" runat="server" Width="270px" Text='<%# Bind("LocationDescription") %>' />
                            </div>

                            <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                            <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>
                            <asp:DropDownList ID="DDLHiddenLocation" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                            <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource3"></asp:Label>
                                <span class="input2col" id="spanHours" runat="server">
                                    <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" Enabled="False" meta:resourcekey="HoursTextBoxResource3" />
                                </span>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="disCancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource1" />
                                <asp:Label ID="CancelFlagLabel" runat="server" AssociatedControlID="disCancelFlagCheckBox" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

                            </div>

                            <!-- *** DDL Task Name ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="lblTaskName" runat="server" Text="Task Name"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLTaskName" runat="server" AppendDataBoundItems="True" Width="376" AutoPostBack="false"
                                    meta:resourcekey="DDLTaskName3" data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                                <asp:Button Text="Refresh" CssClass="greybutton" runat="server" ID="btnRefresh" />
                            </div>

                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="CommentTextBox" runat="server" Text="Nota" meta:resourcekey="CommentTextBoxResource1"></asp:Label>
                                <asp:TextBox ID="TextBox2" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" Enabled="False" meta:resourcekey="TextBox2Resource1" />
                            </div>

                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label ID="LBAccountingDate" runat="server" Text="Competenza" CssClass="inputtext" meta:resourcekey="LBAccountingDateResource3"></asp:Label>
                                <asp:TextBox ID="TBAccountingDate" Enabled="false" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" meta:resourcekey="LBAccountingDateDisplayResource1"></asp:TextBox>
                            </div>

                            <!-- *** BOTTONI ***  -->
                            <div class="buttons">
                                <asp:Button ID="CancelButton" runat="server" CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate  />
                            </div>

                        </ItemTemplate>

                    </asp:FormView>

                </div>
                <!-- FormWrap -->

            </div>
            <!-- LastRow -->

        </form>
        <!-- Form  -->
    </div>
    <!-- container -->

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
    <asp:SqlDataSource ID="DSore" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.HourType_Id, Hours.CancelFlag, Hours.Comment, Hours.TransferFlag, Hours.Activity_id, Persons.Name, Hours.CreatedBy, Hours.CreationDate, Hours.LastModifiedBy,  Hours.LastModificationDate,AccountingDate, WorkedInRemote, LocationKey, LocationDescription, LocationType, hours.ClientManager_id, hours.AccountManager_id, hours.Company_id,hours.OpportunityId,hours.SalesforceTaskID FROM Hours INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id WHERE (Hours.Hours_Id = @hours_id)">

        <SelectParameters>
            <asp:QueryStringParameter Name="hours_id" QueryStringField="hours_id" />
        </SelectParameters>

    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // evita il postback con INVIO (che non faceva funzionare bene il bind delle attivita)
        stopPostbackWithEnter();

        // *** Page Load ***  
        $(function () {
            $("#FVore_TBAccountingDate").datepicker($.datepicker.regional['it']);
            $("#FVore_disCancelFlagCheckBox").attr("disabled", true);
            $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET

            // nasconde la select con i valori delle attività per bind sul client
            $("#FVore_DDLhidden").hide();
            $("#FVore_DDLHiddenLocation").hide();
            $('#lbDDLAttivita').hide();
            $('#FVore_DDLLocation').hide();

            $('#FVore_TBLocation').hide(); // nasconde il box di testo della Location

            $('#FVore_DDLTaskName').hide();
            $('#FVore_lblTaskName').hide();
            $('#FVore_btnRefresh').hide();

            //controllo se ci sono task attive cosi da riattivare il componente
            $('#FVore_DDLTaskName option').each(function () {
                if (this.value != "") {
                    $('#FVore_DDLTaskName').show();
                    $('#FVore_lblTaskName').show();
                    $('#FVore_btnRefresh').show();
                    return false;
                }
            });

            BindActivity();
            BindLocation();
            BindOpportunity();

            // Sumo Select
            $('#FVore_DDLprogetto').SumoSelect({ search: true, searchText: '' });
            /*    $('#FVore_DDLLocation').SumoSelect({ search: true, searchText: '' });*/
            /* $('#FVore_DDLAttivita').SumoSelect({ search: true, searchText: '' });  tolto temporaneamente */
            $('#FVore_DDLOpportunity').SumoSelect({ search: true, searchText: '' });
            if ($('#FVore_DDLprogetto')[0].sumo)
                $('#FVore_DDLprogetto')[0].sumo.optDiv.css('width', '350px'); // fa in modo che la tendina per le opportunità sia larga 550px
            if ($('#FVore_DDLOpportunity')[0].sumo)
                $('#FVore_DDLOpportunity')[0].sumo.optDiv.css('width', '550px'); // fa in modo che la tendina per le opportunità sia larga 550px

        });

        // Initialize Parsley
        var form = $('#FormOre').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        // ***  Controllo che esista un commento se il progetto lo richiede ***
        window.Parsley.addValidator('testoObbligatorio', {
            validateString: function (value) {
                FVore_DDLLocation

                var flagObbligatorio = $("#FVore_DDLprogetto option:selected").attr("data-desc-obbligatorio");
                var messaggio = $("#FVore_DDLprogetto option:selected").attr("data-desc-message");

                // progetto richiede commento ed il commento è vuoto
                if (flagObbligatorio == "True" && $("#FVore_TBComment").val().length == 0)
                    return $.Deferred().reject(messaggio);
                else
                    return true;
            },
            messages: {
                en: "insert a comment",
                it: "inserire un commento"
            }
        });

        $("#FVore_DDLprogetto").on("change", function () {

            BindActivity();
            BindLocation();
            BindOpportunity();

        });

        // *** popola controllo delle attività *** 
        function BindActivity() {

            var ActivityOn = $("#FVore_DDLprogetto").find("option:selected").attr("data-ActivityOn");
            $("#FVore_DDLAttivita").children().remove(); // pulisce tutti gli item della  DropDown attività

            if (ActivityOn != "True") {  // progetto non richiede le attività 
                $("#FVore_DDLAttivita").append($('<option>', { value: '', text: 'nessun valore' })); // pulisce il campo
                $('#lbDDLAttivita').hide();
            }
            else {
                // aggiunge selezione vuota
                $("#FVore_DDLAttivita").append($('<option>', { value: '', text: '--- seleziona un elemento ---' }));

                // loop su tutti gli item della select nascosta e li linka per il progetto selezionato
                $("#FVore_DDLhidden > option").each(function () {
                    if ($(this).attr("data-projects_id") === $("#FVore_DDLprogetto").find("option:selected").val())
                        $("#FVore_DDLAttivita").append($('<option>', {
                            value: $(this).val(),
                            text: $(this).text(),
                            selected: $(this)[0].selected
                        }));
                });
                $('#lbDDLAttivita').show(); // visualizza DropDown

            }

        }

        function BindOpportunity() {
            // gestione Opportunity Id
            var OpportunityIsRequired = $("#FVore_DDLprogetto").find("option:selected").attr("data-OpportunityIsRequired");

            if (OpportunityIsRequired == "True")
                $('#lbOpportunityId').show(); // visualizza DropDown
            else
                $('#lbOpportunityId').hide(); // visualizza DropDown
        }

        // *** popola controllo delle Location *** 
        function BindLocation() {

            // se DDL valorizzato a 99999 attiva il testo libero
            if ($("#FVore_DDLLocation").val() == 'T:99999') {
                $('#FVore_TBLocation').show();
                return;
            }

            var LocationOn = $("#FVore_DDLprogetto").find("option:selected").attr("data-filterlocation");
            $("#FVore_DDLLocation").children().remove(); // pulisce tutti gli item della  DropDown 
            if (typeof LocationOn == 'undefined') {  // non esiste l'attributo 
                $("#FVore_DDLLocation").append($('<option>', { value: '', text: 'nessun valore' })); // pulisce il campo
                $('#FVore_DDLLocation').hide();
            }
            else {
                // aggiunge selezione vuota
                $("#FVore_DDLLocation").append($('<option>', { value: '', text: '-- selezionare un valore --' }));

                // loop su tutti gli item della select nascosta e li linka per il progetto selezionato
                $("#FVore_DDLHiddenLocation > option").each(function () {
                    if ($(this).attr("data-filterlocation") === $("#FVore_DDLprogetto").find("option:selected").attr("data-filterlocation"))
                        $("#FVore_DDLLocation").append($('<option>', {
                            value: $(this).val(),
                            text: $(this).text(),
                            selected: $(this)[0].selected
                        }));
                });

                $("#FVore_DDLLocation").append($('<option>', { value: 'T:99999', text: '-- Testo Libero --' }));
                $('#FVore_DDLLocation').show(); // visualizza DropDown

                $('#FVore_TBLocation').val(""); // reset e spegnimento campo
                $('#FVore_TBLocation').hide();
            }
        }

        // Mostra box testo in caso della corrispondente selezione della DDL Location
        $("#FVore_DDLLocation").change(function () {
            if ($("#FVore_DDLLocation").val() == 'T:99999') // mostra Box Testo
            {
                /*                $('#FVore_DDLLocation').SumoSelect().sumo.unload();*/
                $('#FVore_DDLLocation').hide();
                $('#FVore_TBLocation').show();
            }
        });

        // Se campo vien sblancato riattiva il DDL
        $("#FVore_TBLocation").change(function () {
            if ($("#FVore_TBLocation").val() == '') // mostra Box Testo
            {
                $('#FVore_DDLLocation').val('');
                BindLocation(); // ricarica la DDL
            }
        });

        // Alla selezione di una task imposta automaticamente il valore del progetto
        $("#FVore_DDLTaskName").change(function () {
            console.log($(this).find("option:selected").attr("data-Projects_Id"));
            if ($(this).find("option:selected").attr("data-Projects_Id") != '') // mostra Box Testo
            {
                var projID = $(this).find("option:selected").attr("data-Projects_Id");
                var Projects_Name = $(this).find("option:selected").attr("data-Projects_Name");
                //controllo per vedere se è un valore in DDL
                var IsExists = false;
                $('#FVore_DDLprogetto option').each(function () {
                    if (this.value == projID) {
                        IsExists = true;
                    }
                });
                //controllo se esiste progetto reset
                //NON esiste resetto le selezioni
                if (IsExists == false) {
                    $("#FVore_DDLTaskName").val(0);
                    if (Projects_Name == null) {
                        alert("Il progetto della task selezionata non \u00E8 stato inviato al Timereport");
                    } else {
                        alert("Non si \u00E8 autorizzati alla commessa " + Projects_Name + " rivolgersi al proprio responsabile per l'autorizzazione");
                    }
                }
                ////imposto il valore e accendo event change
                $("#FVore_DDLprogetto").val($(this).find("option:selected").attr("data-Projects_Id")).change();
                $("#FVore_DDLprogetto")[0].sumo.reload();
            }
        });

        $("#FVore_btnRefresh").on("click", function () {
            //alert("Handler for `click` called.");
            $('#FormOre').off('submit.Parsley');
            //$('#FormOre').off('form:validate');
        });

        // Sostituisci FVore_CancelButton con l'ID generato effettivo (verifica nel DOM)
        $(document).on('click', '#FVore_CancelButton', function (e) {
            e.preventDefault();
            window.location.href = "/timereport/input.aspx"; // o altra azione desiderata
        });

        $("#FVore_PostButton").on("click", function (e) {

            e.preventDefault();

            // Trigger validation without submitting the form
            if (!form.validate()) {
                // in modale la sola applicazione di fogli di stile per nascondere i messaggi di errore non è sufficiente
                var errorMessages = $('#valMsg .parsley-errors-list.filled');
                if (errorMessages.length > 1)
                    errorMessages.not(':first').hide();
                return;
            }

            // formattazione valori
            var Activity = isNullOrEmpty($('#FVore_DDLAttivita').val()) ? 0 : $('#FVore_DDLAttivita').val();
            var TaskName = isNullOrEmpty($('#FVore_DDLTaskName').val()) ? "" : $('#FVore_DDLTaskName').val();

            if (!$('#FVore_DDLLocation').is(':hidden') || !$('#FVore_TBLocation').is(':hidden')) {
                var LocationKey = $('#FVore_DDLLocation').is(':hidden') ? "99999" : $('#FVore_DDLLocation').val();
                var LocationDescription = $('#FVore_DDLLocation').is(':hidden') ? $('#FVore_TBLocation').val() : $('#FVore_DDLLocation option:selected').text();
            }
            else {
                var LocationKey = '';
                var LocationDescription = '';
            }

            var hoursId = '<%= String.IsNullOrEmpty(Request.QueryString["hours_id"]) ? "0" : Request.QueryString["hours_id"] %>';
            var AccountingDate = isNullOrEmpty($('#FVore_TBAccountingDate').val()) ? '' : $('#FVore_TBAccountingDate').val();

            var values = {
                Hours_Id: parseInt(hoursId),
                Date: $('#FVore_LBdate').text(),
                Hours: parseFloat($('#FVore_HoursTextBox').val().replace(',', '.')),
                Person_Id: <%= CurrentSession.Persons_id %>,
                Project_Id: parseInt($('#FVore_DDLprogetto').val()),
                Activity_Id: parseInt(Activity),
                Comment: $('#FVore_TBComment').val(),
                CancelFlag: $('#FVore_CancelFlagCheckBox').is(':checked'),
                LocationKey: LocationKey,
                LocationDescription: LocationDescription,
                OpportunityId: ($('#FVore_DDLOpportunity').is(':visible') ? $('#FVore_DDLOpportunity').val() : ''),
                AccountingDate: AccountingDate,
                SalesforceTaskID: TaskName
            };

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/SaveHours",
                data: JSON.stringify(values),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {

                    if (msg.d)
                        window.location.href = "/timereport/input.aspx";
                    //ShowPopup("Aggiornamento effettuato");
                    else
                        ShowPopup('Errore durante aggiornamento');
                },
                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup(xhr.responseText);
                }
            }); // ajax

        });

    </script>

</body>

</html>
