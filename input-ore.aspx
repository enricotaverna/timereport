<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-ore.aspx.cs" Inherits="input_ore" EnableEventValidation="False" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
    </title>
</head>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <div id="FormWrap" class="StandardForm" > 

            <form id="FormOre" runat="server" data-parsley-validate>

                <asp:FormView ID="FVore" runat="server" DataKeyNames="Hours_Id"
                    DataSourceID="DSore" align="center" DefaultMode="Edit"
                    OnItemInserted="FVore_ItemInserted" OnItemUpdated="FVore_ItemUpdated"
                    OnDataBound="FVore_DataBound" 
                    OnModeChanging="FVore_modechanging" meta:resourcekey="FVoreResource1" CellPadding="0">

                    <%-- EDIT --%>
                    <EditItemTemplate>

                        <div class="formtitle">
                            <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                            <a href="AuditLog.aspx?RecordId=&amp;TableName=Hours&amp;TYPE=U&amp;key=&lt;Hours_Id=&gt;">
                                <asp:Image ID="Image1" runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="Image1Resource1" /></a>
                        </div>

                        <!-- *** LB Data ***  -->
                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource1" ></asp:Label>
                            <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource1" ></asp:Label>
                            <asp:Label ID="Label13" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="Label13Resource1"></asp:Label>
                        </div>

                        <!-- *** DDL Progetto ***  -->
                        <!-- messaggio parsley di errore disabilitato dropdown-->
                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource1"></asp:Label>
                            
                            <label class="dropdown"> <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLprogettoResource1" 
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                </asp:DropDownList>
                            </label>

                        </div>

                        <!-- *** DDL Attività ***  -->
                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource1"></asp:Label>
                            
                            <label id="lbDDLAttivita" class="dropdown">  <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLAttivitaResource1" 
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" >
                                    <asp:ListItem meta:resourcekey="ListItemResource1">--seleziona attività--</asp:ListItem>
                                </asp:DropDownList>
                            </label>
                        
                        </div>

                        <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                        <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                        <!-- *** TB Ore ***  -->
                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource1"></asp:Label>
                            <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource1" 
                                    data-parsley-errors-container="#valMsg" data-parsley-pattern="^\d+(,\d+)?$" data-parsley-required="true" />
                            </span>

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
                            <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource1"  autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                        </div>

                        <div class="buttons">
                            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                            <asp:Button ID="UpdateButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" meta:resourcekey="UpdateButtonResource1" />
                            <asp:Button ID="UpdateCancelButton" runat="server"  CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource1" formnovalidate />
                        </div>

                    </EditItemTemplate>

                    <%--INSERT--%>
                    <InsertItemTemplate>

                        <div class="formtitle">
                            <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" /></div>

                        <!-- *** LB Data ***  -->
                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource2"></asp:Label>
                            <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date") %>' meta:resourcekey="LBdateResource2"></asp:Label>
                            <asp:Label ID="LBperson" runat="server" Text='<%# Bind("persons_id") %>' meta:resourcekey="LBpersonResource1"></asp:Label>
                        </div>

                        <!-- *** DDL Progetto ***  -->
                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource2"></asp:Label>

                            <label class="dropdown"> <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLprogettoResource2" data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                            </label>

                        </div>

                        <!-- *** DDL Attività ***  -->
                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource2"></asp:Label>
                            
                            <label id="lbDDLAttivita" class="dropdown"> <!-- per stile CSS -->
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    meta:resourcekey="DDLAttivitaResource2" data-parsley-required="true" 
                                    data-parsley-errors-container="#valMsg">
                                </asp:DropDownList>
                            </label>

                        </div>

                        <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                        <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                        <!-- *** TB Ore ***  -->
                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource2"></asp:Label>
                            <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource2" 
                                    data-parsley-errors-container="#valMsg" data-parsley-pattern="^\d+(,\d+)?$" data-parsley-required="true" />
                            </span>

                            <asp:CheckBox ID="CancelFlagCheckBox" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource2" />
                            <asp:Label AssociatedControlID="CancelFlagCheckBox"  runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>

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
                            <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate") %>' Columns="8" meta:resourcekey="TBAccountingDateResource2"  autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                        </div>

                        <div class="buttons">
                            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" meta:resourcekey="InsertButtonResource1" />
                            <asp:Button ID="UpdateCancelButton" runat="server"  CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource2" formnovalidate />
                        </div>

                    </InsertItemTemplate>

                    <%--        DISPLAY--%>
                    <ItemTemplate>
                        <div class="formtitle">
                            <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                            <a href="AuditLog.aspx?RecordId=&amp;TableName=Hours&amp;TYPE=U&amp;key=&lt;Hours_Id=&gt;">
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
                            <label class="dropdown">
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                    Enabled="False"
                                    meta:resourcekey="DDLprogettoResource3">
                                </asp:DropDownList>
                            </label>
                        </div>

                        <!-- *** DDL Attività ***  -->
                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label8" runat="server" Text="Attività" meta:resourcekey="Label8Resource1"></asp:Label>
                            <label id="lbDDLAttivita" class="dropdown">
                                <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True"
                                    Enabled="False" Width="240px" meta:resourcekey="DDLAttivitaResource3">
                                </asp:DropDownList>
                            </label>
                        </div>

                         <!-- *** usato per portare i valori della select sul cliente per poi filtrarli con jquery ***  -->
                        <asp:DropDownList ID="DDLhidden" runat="server" AppendDataBoundItems="True" Enabled="True"></asp:DropDownList>

                        <!-- *** TB Ore ***  -->
                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource3"></asp:Label>
                            <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" Enabled="False" meta:resourcekey="HoursTextBoxResource3" />
                            </span>

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
                            <asp:TextBox ID="TBAccountingDate" enabled="false" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" meta:resourcekey="LBAccountingDateDisplayResource1"></asp:TextBox>
                        </div>

                        <!-- *** TB Competenza ***  -->
                        <div class="buttons">
                            <asp:Button ID="UpdateCancelButton" CssClass="greybutton" runat="server"  CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource3" />

                        </div>

                    </ItemTemplate>

                </asp:FormView>

                <asp:SqlDataSource ID="DSprogetti" runat="server"
                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                    SelectCommand="SELECT Projects_Id, ProjectCode + ' ' + left(Name,20) AS iProgetto FROM Projects where active = 'true' and activityON = 'true' order by ProjectCode"></asp:SqlDataSource>
                <asp:SqlDataSource ID="DStipoore" runat="server"
                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                    SelectCommand="SELECT HourType_Id, HourTypeCode + ' ' + Name AS iTipoOra FROM HourType"></asp:SqlDataSource>
                <asp:SqlDataSource ID="DSattivita" runat="server"
                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                    SelectCommand="SELECT Activity_id, Name + ' ' + ActivityCode AS iAttivita FROM Activity WHERE active = 'true'"></asp:SqlDataSource>
                <asp:SqlDataSource ID="DSore" runat="server"
                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                    SelectCommand="SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.HourType_Id, Hours.CancelFlag, Hours.Comment, Hours.TransferFlag, Hours.Activity_id, Persons.Name, CreatedBy, CreationDate, LastModifiedBy, LastModificationDate,AccountingDate FROM Hours INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id WHERE (Hours.Hours_Id = @hours_id)"
                    InsertCommand="INSERT INTO Hours(Projects_Id, Persons_id, Date, HourType_Id, Hours, CancelFlag, Comment, TransferFlag, Activity_id, CreatedBy, CreationDate, AccountingDate) VALUES (@Projects_id, @Persons_id, @Date, @HourType_id, @Hours, @CancelFlag, @Comment, @TransferFlag, @Activity_id, @CreatedBy, @CreationDate, @AccountingDate)"
                    UpdateCommand="UPDATE Hours SET Hours = @Hours, HourType_Id = @HourType_Id, CancelFlag = @CancelFlag, Comment = @Comment, TransferFlag = @TransferFlag, Activity_id = @Activity_id, Projects_Id = @Projects_Id, LastModifiedBy= @LastModifiedBy, LastModificationDate = @LastModificationDate, AccountingDate = @AccountingDate WHERE (Hours_Id = @Hours_id)"
                    OnInserting="DSore_Insert_Update" OnUpdating="DSore_Insert_Update">

                    <InsertParameters>
                        <asp:Parameter Name="Projects_id" />
                        <asp:Parameter Name="Persons_id" />
                        <asp:Parameter Name="Date" />
                        <asp:Parameter Name="HourType_id" DefaultValue="1" />
                        <asp:Parameter Name="Hours" />
                        <asp:Parameter Name="CancelFlag" />
                        <asp:Parameter Name="Comment" />
                        <asp:Parameter Name="TransferFlag" />
                        <asp:Parameter Name="Activity_id" />
                        <asp:Parameter Name="CreatedBy" />
                        <asp:Parameter Name="CreationDate" />
                        <asp:Parameter Name="AccountingDate" Type="DateTime" />
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
                        <asp:Parameter Name="Hours_id" />
                        <asp:Parameter Name="CreatedBy" />
                        <asp:Parameter Name="CreationDate" />
                        <asp:Parameter Name="LastModifiedBy" />
                        <asp:Parameter Name="LastModificationDate" />
                        <asp:Parameter Name="AccountingDate" Type="DateTime" />
                    </UpdateParameters>
                </asp:SqlDataSource>

            </form>

        </div>
        <%--        DISPLAY--%>
    </div>

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Today.Year  %></div>
        <div id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">
            <asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" />
            <%= Session["UserName"]  %></div>
    </div>

    <script type="text/javascript">

        // *** Page Load ***  
        $(function () {
            $("#FVore_TBAccountingDate").datepicker($.datepicker.regional['it']);
            $("#FVore_disCancelFlagCheckBox").attr("disabled", true);
            $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET

            // nasconde la select con i valori delle attività per bind sul client
            $("#FVore_DDLhidden").hide();
            $('#lbDDLAttivita').hide();

            BindActivity();

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

        });

         // *** popola controllo delle attività *** 
        function BindActivity() {

            var ActivityOn = $("#FVore_DDLprogetto").find("option:selected").attr("data-ActivityOn");

            if (ActivityOn != "True")  // progetto non richiede le attività
                $('#lbDDLAttivita').hide();
            else {

                $("#FVore_DDLAttivita").children().remove(); // pulisce tutti gli item della  DropDown attività

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

    </script>

</body>

</html>
