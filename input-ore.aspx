<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-ore.aspx.cs" Inherits="input_ore" EnableEventValidation="False" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

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
                        OnItemInserted="FVore_ItemInserted" OnItemUpdated="FVore_ItemUpdated"
                        OnDataBound="FVore_DataBound"
                        OnModeChanging="FVore_modechanging" CellPadding="0">

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
                            <!-- messaggio parsley di errore disabilitato dropdown-->
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

                            <!-- *** OpportunityId ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Opportunità" meta:resourcekey="lbOpportunityId"></asp:Label>
                                <!-- per stile CSS -->
                                    <asp:TextBox CssClass="ASPInputcontent" ID="TBOpportunityId" runat="server" Text='<%# Bind("OpportunityId") %>' 
                                        data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^AV\d{2}[A-Z]\d{3}$|^AP\d{1,13}$" Columns="15" MaxLength="15" />
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Luogo"  meta:resourcekey="Label2" ></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLLocation" runat="server" AppendDataBoundItems="True"
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
                                <span class="input2col">
                                    <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource1"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="^\d+(,\d+)?$" data-parsley-required="true" />
                                </span>

                                <!-- *** Checkboc Remote ***  -->
                                <%--                            <asp:CheckBox ID="CBWorkedInRemote" runat="server" Checked='<%# Bind("WorkedInRemote") %>'  />
                            <asp:Label AssociatedControlID="CBWorkedInRemote" style="padding-right:20px" runat="server" Text="Remoto" meta:resourcekey="CBWorkedInRemote"></asp:Label>--%>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource1" />
                                <asp:Label AssociatedControlID="CancelFlagCheckBox" runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

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
                                <asp:Button ID="UpdateButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate />
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

                            <!-- *** OpportunityId ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Opportunità" meta:resourcekey="lbOpportunityId"></asp:Label>
                                <!-- per stile CSS -->
                                    <asp:TextBox CssClass="ASPInputcontent" ID="TBOpportunityId" runat="server" Text='<%# Bind("OpportunityId") %>' 
                                        data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^AV\d{2}[A-Z]\d{3}$|^AP\d{1,13}$" Columns="15" MaxLength="15" />
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server"  Text="Luogo"  meta:resourcekey="Label2"></asp:Label>
                                <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLLocation" runat="server" AppendDataBoundItems="True"
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
                                <span class="input2col">
                                    <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource2"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="^\d+(,\d+)?$" data-parsley-required="true" />
                                </span>

                                <!-- *** Checkboc Remote ***  -->
                                <%--                            <asp:CheckBox ID="CBWorkedInRemote" runat="server" Checked='<%# Bind("WorkedInRemote") %>'  />
                            <asp:Label AssociatedControlID="CBWorkedInRemote" style="padding-right:20px" runat="server" Text="Remoto" meta:resourcekey="CBWorkedInRemote"></asp:Label>--%>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource2" />
                                <asp:Label AssociatedControlID="CancelFlagCheckBox" runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

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
                                <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" />
                                <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate />
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
                                    Enabled="False"  meta:resourcekey="DDLAttivitaResource3">
                                </asp:DropDownList>
                            </div>

                            <!-- *** OpportunityId ***  -->
                            <div class="input nobottomborder" id="lbOpportunityId">
                                <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Opportunità" meta:resourcekey="lbOpportunityId"></asp:Label>
                                <!-- per stile CSS -->
                                    <asp:TextBox CssClass="ASPInputcontent" ID="TBOpportunityId" runat="server" Text='<%# Bind("OpportunityId") %>'  Enabled="False"
                                        data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^AV\d{2}[A-Z]\d{3}$|^AP\d{1,13}$" Columns="15" MaxLength="15" />
                            </div>

                            <!-- *** DDL Location ***  -->
                            <div class="input" id="lbDDLLocation">
                                <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Luogo"  meta:resourcekey="Label2"></asp:Label>
                                <!-- per stile CSS -->
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
                                <span class="input2col">
                                    <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" Enabled="False" meta:resourcekey="HoursTextBoxResource3" />
                                </span>

                                <!-- *** Checkboc Remote ***  -->
                                <%--                            <asp:CheckBox ID="CBWorkedInRemote" runat="server" Checked='<%# Bind("WorkedInRemote") %>'  />
                            <asp:Label AssociatedControlID="CBWorkedInRemote" style="padding-right:20px" runat="server" Text="Remoto" meta:resourcekey="CBWorkedInRemote"></asp:Label>--%>

                                <!-- *** Checkboc Storno ***  -->
                                <asp:CheckBox ID="disCancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource1" />
                                <asp:Label runat="server" AssociatedControlID="disCancelFlagCheckBox" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

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
                                <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" formnovalidate />
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
        SelectCommand="SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.HourType_Id, Hours.CancelFlag, Hours.Comment, Hours.TransferFlag, Hours.Activity_id, Persons.Name, Hours.CreatedBy, Hours.CreationDate, Hours.LastModifiedBy, Hours.LastModificationDate,AccountingDate, WorkedInRemote, LocationKey, LocationDescription, LocationType, hours.ClientManager_id, hours.AccountManager_id, hours.Company_id, hours.OpportunityId FROM Hours INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id WHERE (Hours.Hours_Id = @hours_id)"
        InsertCommand="INSERT INTO Hours(Projects_Id, Persons_id, Date, HourType_Id, Hours, CancelFlag, Comment, TransferFlag, Activity_id, CreatedBy, CreationDate, AccountingDate, WorkedInRemote, LocationKey, LocationDescription, LocationType, ClientManager_id, AccountManager_id, Company_id, OpportunityId) VALUES (@Projects_id, @Persons_id, @Date, @HourType_id, @Hours, @CancelFlag, @Comment, @TransferFlag, @Activity_id, @CreatedBy, @CreationDate, @AccountingDate, @WorkedInRemote, @LocationKey, @LocationDescription, @LocationType, @ClientManager_id, @AccountManager_id, @Company_id, @OpportunityId)"
        UpdateCommand="UPDATE Hours SET Hours = @Hours, HourType_Id = @HourType_Id, CancelFlag = @CancelFlag, Comment = @Comment, TransferFlag = @TransferFlag, Activity_id = @Activity_id, Projects_Id = @Projects_Id, LastModifiedBy= @LastModifiedBy, LastModificationDate = @LastModificationDate, AccountingDate = @AccountingDate, WorkedInRemote=@WorkedInRemote, LocationKey = @LocationKey, LocationDescription=@LocationDescription, LocationType=@LocationType, OpportunityId=@OpportunityId WHERE (Hours_Id = @Hours_id)"
        OnInserting="DSore_Insert_Update" OnUpdating="DSore_Insert_Update">

        <InsertParameters>
            <asp:Parameter Name="Projects_id" />
            <asp:Parameter Name="Persons_id" />
            <asp:Parameter Name="Date" />
            <asp:Parameter Name="HourType_id" DefaultValue="1" />
            <asp:Parameter Name="Hours" />
            <asp:Parameter Name="CancelFlag" />
            <asp:Parameter Name="Comment" />
            <asp:Parameter Name="LocationKey" />
            <asp:Parameter Name="LocationType" />
            <asp:Parameter Name="LocationDescription" />
            <asp:Parameter Name="ClientManager_id" />
            <asp:Parameter Name="AccountManager_id" />
            <asp:Parameter Name="Company_id" />
            <asp:Parameter Name="TransferFlag" />
            <asp:Parameter Name="Activity_id" />
            <asp:Parameter Name="CreatedBy" />
            <asp:Parameter Name="CreationDate" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="WorkedInRemote" />
        </InsertParameters>
        <SelectParameters>
            <asp:QueryStringParameter Name="hours_id" QueryStringField="hours_id" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Hours" />
            <asp:Parameter Name="HourType_Id" DefaultValue="1" />
            <asp:Parameter Name="CancelFlag" />
            <asp:Parameter Name="Comment" />
            <asp:Parameter Name="TransferFlag" />
            <asp:Parameter Name="Activity_id" />
            <asp:Parameter Name="Projects_Id" />
            <asp:Parameter Name="LocationKey" />
            <asp:Parameter Name="LocationType" />
            <asp:Parameter Name="LocationDescription" />
            <asp:Parameter Name="Hours_id" />
            <asp:Parameter Name="CreatedBy" />
            <asp:Parameter Name="CreationDate" />
            <asp:Parameter Name="LastModifiedBy" />
            <asp:Parameter Name="LastModificationDate" />
            <asp:Parameter Name="AccountingDate" Type="DateTime" />
            <asp:Parameter Name="WorkedInRemote" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

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

            BindActivity();
            BindLocation();
            BindOpportunity();

        });

        // *** Esclude i controlli nascosti *** 
        $('#FormOre').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        // ***  Controllo che esista un commento se il progetto lo richiede ***
        window.Parsley.addValidator('testoObbligatorio', {
            validateString: function (value) {

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

            //// se è valorizzato lo mostra comunqua
            //$('#lbDDLAttivita').show(); // visualizza DropDown
            //if ($("#FVore_DDLAttivita").find("option:selected").value != "")
            //    $('#lbDDLAttivita').show(); // visualizza DropDown
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

    </script>

</body>

</html>
