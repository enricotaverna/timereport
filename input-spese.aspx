<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-spese.aspx.cs" Inherits="input_spese" EnableEventValidation="False" %>

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
<link href="/timereport/include/uploader/uploader.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<!--SUMO select-->
<link href="/timereport/include/jquery/sumoselect/sumoselect.css?v=<%=MyConstants.SUMO_VERSION %>"" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<!-- Jquery per Uploader  -->
<script src="/timereport/include/uploader/jquery.ui.widget.js"></script>
<script src="/timereport/include/uploader/load-image.all.min.js"></script>
<script src="/timereport/include/uploader/canvas-to-blob.min.js"></script>
<script src="/timereport/include/uploader/jquery.iframe-transport.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-process.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-image.js"></script>
<script src="/timereport/include/uploader/jquery.fileupload-validate.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="FormSpese" runat="server" data-parsley-validate>

            <div class="row justify-content-center">

                <div class="col-5">

                    <div id="FormWrap" class="StandardForm">
                        <asp:FormView ID="FVSpese" runat="server" DataKeyNames="Expenses_Id"
                            DataSourceID="DSspese" align="center" DefaultMode="Edit"
                            OnDataBound="FVSpese_DataBound" CellPadding="0"
                            OnModeChanging="FVSpese_modechanging" meta:resourcekey="FVSpeseResource1" >

                            <%--  INSERT   --%>
                            <InsertItemTemplate>

                                <div class="formtitle">
                                    <asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" />
                                </div>

                                <!-- *** LB Data ***  -->
                                <div class="input">
                                    <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource1"></asp:Label>
                                    <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date") %>' meta:resourcekey="LBdateResource2"></asp:Label>
                                    <asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource2"></asp:Label>
                                </div>

                                <!-- *** DDL Progetto ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:progetto%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"  data-parsley-required="true" data-parsley-errors-container="#valMsg"
                                        meta:resourcekey="DDLprogettoResource2"   >
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Tipo Spesa ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:tipo%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
                                        meta:resourcekey="DDLTipoSpesaResource2">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Opportunità ***  -->
                                <div class="input nobottomborder" id="lbOpportunityId">
                                    <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;" ></asp:Label>
                                    <!-- per stile CSS -->
                                    <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"  
                                         data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** Valore e storno ***  -->
                                <div class="input">

                                    <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource2"></asp:Label>
                                        <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="TBAmount" runat="server" Text='<%# Bind("Amount") %>' Columns="6"
                                            meta:resourcekey="TBAmountResource2"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$"/>
  
                                </div>

                                <!-- *** Flag ***  -->
                                <div class="input">

                                    <!-- *** posizionamento ***  -->
                                    <span class="inputtext">&nbsp;</span>

                                    <!-- *** Flag Fattura / Carta Credito ***  -->
                                    <span class="input2col">
                                        <asp:CheckBox ID="CBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                        <asp:Label runat="server" AssociatedControlID="CBInvoice" meta:resourcekey="Label3Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="CBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="CBCreditCard" meta:resourcekey="LBCBCreditCardResource2"></asp:Label>

                                    <br />

                                    <!-- *** Flag Storno / Pagato Azienda ***  -->
                                    <span class="inputtext">&nbsp;</span>
                                    <span class="input2col">
                                        <asp:CheckBox ID="CBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                        <asp:Label ID="LBcancel" runat="server" AssociatedControlID="CBcancel" meta:resourcekey="Label8Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="CBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="CBCompanyPayed" meta:resourcekey="Label9Resource1"></asp:Label>

                                </div>

                                <!-- *** TB Comment ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota" meta:resourcekey="LbCommentResource2"></asp:Label>
                                    <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource2"
                                        data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="" data-parsley-testo-obbligatorio="true" />
                                </div>

                                <!-- *** TB Competenza ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource2"></asp:Label>
                                    <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource2"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{3,4})$/" />
                                </div>

                                <!-- *** Bottoni ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="PostButton" runat="server" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>"  />
                                    <asp:Button ID="RicevuteButton" runat="server" CssClass="orangebutton" Text="<%$ Resources:timereport, TICKETS %>" />
                                    <asp:Button ID="CancelButton" runat="server" formnovalidate  CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" />
                                </div>

                            </InsertItemTemplate>

                            <%--  EDIT   --%>
                            <EditItemTemplate>

                                <div class="formtitle">
                                    <asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" />
                                    <a href="./m_utilita/AuditLog.aspx?RecordId=<%=Request.QueryString["Expenses_Id"]%>&TableName=Expenses&TYPE=U&key=<Expenses_Id=<%=Request.QueryString["Expenses_Id"] %>>">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="Image1Resource1" /></a>
                                </div>

                                <!-- *** LB Data ***  -->
                                <div class="input">
                                    <asp:Label CssClass="inputtext" ID="Label22" runat="server" Text="Data" meta:resourcekey="Label22Resource1"></asp:Label>
                                    <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource1"></asp:Label>
                                    <asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource1"></asp:Label>
                                </div>

                                <!-- *** DDL Progetto ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:progetto%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"  data-parsley-required="true" data-parsley-errors-container="#valMsg"
                                        meta:resourcekey="DDLprogettoResource1"  >
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Tipo Spesa ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:tipo%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
                                        meta:resourcekey="DDLTipoSpesaResource1">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Opportunità ***  -->
                                <div class="input nobottomborder" id="lbOpportunityId">
                                             <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;" ></asp:Label>
                                    <!-- per stile CSS -->
                                    <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"  
                                         data-parsley-required="true" data-parsley-errors-container="#valMsg">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** Valore e storno ***  -->
                                <div class="input">
                                    <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource1"></asp:Label>
                                    <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="TBAmount" runat="server" Text='<%# Bind("Amount") %>' Columns="6" meta:resourcekey="TBAmountResource1"
                                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^(?=.*[1-9])(\d*\,)?\d+$"/>
                                </div>

                                <!-- *** Flag ***  -->
                                <div class="input">

                                    <!-- *** posizionamento ***  -->
                                    <span class="inputtext">&nbsp;</span>

                                    <!-- *** Flag Fattura / Carta Credito ***  -->
                                    <span class="input2col">
                                        <asp:CheckBox ID="CBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                        <asp:Label runat="server" AssociatedControlID="CBInvoice" meta:resourcekey="Label3Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="CBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="CBCreditCard" meta:resourcekey="LBCBCreditCardResource2"></asp:Label>

                                    <br />
                                    <span class="inputtext">&nbsp;</span>
                                    <!-- *** Flag Storno / Pagato Azienda ***  -->
                                    <span class="input2col">
                                        <asp:CheckBox ID="CBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                        <asp:Label runat="server" ID="LBcancel" AssociatedControlID="CBcancel" meta:resourcekey="Label8Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="CBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="CBCompanyPayed" meta:resourcekey="Label9Resource1"></asp:Label>

                                </div>

                                <!-- *** TB Comment ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota" meta:resourcekey="LbCommentResource1"></asp:Label>
                                    <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource1"
                                        data-parsley-errors-container="#valMsg" data-parsley-validate-if-empty="" data-parsley-testo-obbligatorio="true" />
                                </div>

                                <!-- *** TB Competenza ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource1"></asp:Label>
                                    <asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource1"
                                        data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                </div>

                                <!-- *** Bottoni ***  -->
                                <div class="buttons">
                                    <div id="valMsg" class="parsley-single-error"></div>
                                    <asp:Button ID="PostButton" runat="server" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" meta:resourcekey="UpdateButtonResource1" />
                                    <asp:Button ID="CancelButton" runat="server"  CommandName="Cancel" formnovalidate CssClass="greybutton" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource1" />
                                </div>

                            </EditItemTemplate>

                            <%--  DISPLAY   --%>
                            <ItemTemplate>

                                <div class="formtitle">
                                    <asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" />
                                    <a href="./m_utilita/AuditLog.aspx?RecordId=<%=Request.QueryString["Expenses_Id"]%>&TableName=Expenses&TYPE=U&key=<Expenses_Id=<%=Request.QueryString["Expenses_Id"] %>>">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="Image1Resource2" /></a>
                                </div>


                                <!-- *** LB Data ***  -->
                                <div class="input">
                                    <asp:Label CssClass="inputtext" ID="Label22" runat="server" Text="Data" meta:resourcekey="Label22Resource2"></asp:Label>
                                    <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource3"></asp:Label>
                                    <asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource3"></asp:Label>
                                </div>

                                <!-- *** DDL Progetto ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:progetto%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
                                        AutoPostBack="True" Enabled="False" meta:resourcekey="DDLprogettoResource3">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Tipo Spesa ***  -->
                                <div class="input nobottomborder">
                                    <div class="inputtext">
                                        <asp:Literal runat="server" Text="<%$ Resources:tipo%>" />
                                    </div>
                                    <asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
                                        AutoPostBack="True" Enabled="False" meta:resourcekey="DDLTipoSpesaResource3">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** DDL Opportunità ***  -->
                                <div class="input nobottomborder" id="lbOpportunityId">
                                     <asp:Label CssClass="inputtext" runat="server" Text="Opportunit&agrave;" ></asp:Label>
                                    <!-- per stile CSS -->
                                    <asp:DropDownList ID="DDLOpportunity" runat="server" AppendDataBoundItems="True"
                                         Enabled="False">
                                    </asp:DropDownList>
                                </div>

                                <!-- *** Valore e storno ***  -->
                                <div class="input">
                                    <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource3"></asp:Label>
                                        <asp:TextBox autocomplete="off" CssClass="ASPInputcontent" ID="TBAmount" runat="server"
                                            Text='<%# Bind("Amount") %>' Columns="6" Enabled="False" meta:resourcekey="TBAmountResource3" />
                                </div>

                                <!-- *** Flag ***  -->
                                <div class="input">

                                    <!-- *** posizionamento ***  -->
                                    <span class="inputtext">&nbsp;</span>

                                    <!-- *** Flag Fattura / Carta Credito ***  -->
                                    <span class="input2col">
                                        <asp:CheckBox ID="disCBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' />
                                        <asp:Label runat="server" AssociatedControlID="disCBInvoice" meta:resourcekey="Label3Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="disCBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="disCBCreditCard" meta:resourcekey="LBCBCreditCardResource2"></asp:Label>

                                    <br />
                                    <span class="inputtext">&nbsp;</span>
                                    <!-- *** Flag Storno / Pagato Azienda ***  -->
                                    <span class="input2col">
                                        <asp:CheckBox ID="disCBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' />
                                        <asp:Label runat="server" AssociatedControlID="disCBcancel" meta:resourcekey="Label8Resource1"></asp:Label>
                                    </span>
                                    <asp:CheckBox ID="disCBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' />
                                    <asp:Label runat="server" AssociatedControlID="disCBCompanyPayed" meta:resourcekey="Label9Resource1"></asp:Label>

                                </div>

                                <!-- *** TB Comment ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota" meta:resourcekey="LbCommentResource3"></asp:Label>
                                    <asp:TextBox ID="TextBox2" runat="server" Rows="5" CssClass="textarea"
                                        Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30"
                                        Enabled="False" meta:resourcekey="TextBox2Resource1" />
                                </div>

                                <!-- *** TB Competenza ***  -->
                                <div class="input nobottomborder">
                                    <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource3"></asp:Label>
                                    <asp:TextBox ID="TBAccountingDate" runat="server" Enabled="False" Text='<%# Bind("AccountingDate","{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" meta:resourcekey="LBAccountingDateDisplayResource1"></asp:TextBox>
                                </div>

                                <!-- *** Bottoni ***  -->
                                <div class="buttons">
                                    <asp:Button ID="CancelButton" runat="server" formnovalidate PostBackUrl="/timereport/input.aspx" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>"  meta:resourcekey="UpdateCancelButtonResource3" />
                                </div>

                            </ItemTemplate>

                        </asp:FormView>
                    </div>

                    <!-- FormOre -->

                </div>
                <!-- col-6 -->

                <!-- **** Box Upload Ricevute *** -->
                <div runat="server" id="BoxRicevute" class="col-3 StandardForm">

                    <!--  Tabella viene caricata da server se ci sono file nella directory  -->
                    <div class="formtitle">
                        <asp:Literal runat="server" Text="<%$ Resources:giustificativi%>" />
                    </div>
                    <table id="TabellaRicevute" runat="server" style="border-collapse: collapse"></table>
                    <div id="pippo"></div>
                    <br />

                    <div id="progress">
                        <div class="bar" style="width: 0%;"></div>
                    </div>
                    <br />

                    <!-- Bottone Upload -->
                    <div class="buttons" runat="server" id="divBottoni">
                        <div class="fileUpload">
                            <span class="orangebutton" style="width: 80%; text-align: center">
                                <asp:Literal runat="server" Text="<%$ Resources:carica_file%>" /></span>
                            <input id="CaricaRicevuta" name="files[]" type="file" class="upload" />
                        </div>
                    </div>

                </div>
                <!--BoxRicevute-->

            </div>
            <!-- LastRow -->

        </form>

    </div>
    <!-- container -->

   <!-- Per output messaggio warning -->
    <div id="dialog" style="display: none"></div>

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
    <asp:SqlDataSource ID="DSSpese" runat="server"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Expenses_Id, Projects_Id, Expenses.Persons_id, ExpenseType_id, Date, Amount, Comment, CreditCardPayed, CompanyPayed, CancelFlag, InvoiceFlag, Expenses.CreatedBy, Expenses.CreationDate, Expenses.LastModifiedBy, Expenses.LastModificationDate, AccountingDate, TipoBonus_id, Persons.Name, Expenses.ClientManager_id, Expenses.AccountManager_id, Expenses.Company_id, Expenses.AdditionalCharges, Expenses.OpportunityId FROM Expenses INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id  WHERE (Expenses_Id = @Expenses_Id)"  >
        <SelectParameters>
            <asp:QueryStringParameter Name="expenses_id" QueryStringField="expenses_id" />
        </SelectParameters>
    </asp:SqlDataSource>

    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // evita il postback con INVIO (che non faceva funzionare bene il bind delle attivita)
        stopPostbackWithEnter();

        // Initialize Parsley
        var form = $('#FormSpese').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
            });

        // ***  Controllo che esista un commento se il progetto lo richiede ***
        window.Parsley.addValidator('testoObbligatorio', {
            validateString: function (value) {

                var flagObbligatorio = $("#FVSpese_DDLTipoSpesa option:selected").attr("data-desc-obbligatorio");
                var messaggio = $("#FVSpese_DDLTipoSpesa option:selected").attr("data-desc-message");

                //debugger;

                // progetto richiede commento ed il commento è vuoto
                if (flagObbligatorio == "True" && $("#FVSpese_TBComment").val().length == 0)
                    return $.Deferred().reject(messaggio);
                else
                    return true;
            },
            messages: {
                en: "insert a comment",
                it: "inserire un commento"
            }
        });

        $("#FVSpese_DDLprogetto").on("change", function () {
            BindOpportunity();
        });

        $(function () {

            $("#FVSpese_TBAccountingDate").datepicker($.datepicker.regional['it']);

            $(":checkbox").addClass("css-checkbox"); // post rendering dei checkbox in ASP.NET

            $("#FVSpese_disCBcancel").attr("disabled", true);
            $("#FVSpese_disCBInvoice").attr("disabled", true);
            $("#FVSpese_disCBCreditCard").attr("disabled", true);
            $("#FVSpese_disCBCompanyPayed").attr("disabled", true);

            BindOpportunity();

            // Sumo Select
            $('#FVSpese_DDLOpportunity').SumoSelect({ search: true, searchText: '' });
            $('#FVSpese_DDLprogetto').SumoSelect({ search: true, searchText: '' });
            $('#FVSpese_DDLTipoSpesa').SumoSelect({ search: true, searchText: '' });
            $('#FVSpese_DDLOpportunity')[0].sumo.optDiv.css('width', '550px'); // fa in modo che la tendina per le opportunità sia larga 550px
            $('#FVSpese_DDLprogetto')[0].sumo.optDiv.css('width', '350px'); // fa in modo che la tendina per le opportunità sia larga 550px

            // se in edit chiama Ajax per controllo carico spese sul giorni
            $('#FVSpese_DDLprogetto').change(function () {

                if ($('#FVSpese_DDLprogetto').val() == "")
                    return;

                $.ajax({
                    type: "POST",
                    url: "/timereport/webservices/WStimereport.asmx/CheckCaricoSpesa",
                    data: "{ 'projects_id' : '" + $('#FVSpese_DDLprogetto').val() + "', 'persons_id' : '<%=CurrentSession.Persons_id%>' , 'date' : '" + $('#FVSpese_LBdate').html() + "'  }",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (msg) {
                        // se messaggio tornato è diverso da stringa vuota emette un messaggio di warning
                        if (msg.d != "") {
                            MaskScreen(true);
                            ShowPopup(msg.d, '', 'Attenzione');
                            UnMaskScreen();
                            //BindOpportunity();
                        }
                    },
                    error: function (xhr, textStatus, errorThrown) {
                        alert(xhr.responseText);
                    }
                }); // ajax
            });

        });

        function BindOpportunity() {
            // gestione Opportunity Id
            var OpportunityIsRequired = $("#FVSpese_DDLprogetto").find("option:selected").attr("data-OpportunityIsRequired");

            if (OpportunityIsRequired == "True")
                $('#lbOpportunityId').show(); // visualizza DropDown
            else
                $('#lbOpportunityId').hide(); // visualizza DropDown
        }

        // ***** CANCELLA RICEVUTA *****
        function cancella_ricevuta(sFilename) {

            // valori da passare al web service in formato { campo1 : valore1 ; campo2 : valore2 }
            var values = "{'sfilename': '" + sFilename + "'" +
                "}";
            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WStimereport.asmx/cancella_file",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                // se tutto va bene
                success: function (msg) {
                    // cancella la riga della tabella corrispondente alla ricevuta
                    var elemtohide = document.getElementById(sFilename);
                    elemtohide.style.display = "none";
                },

                // in caso di errore
                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax

        } // cancella_ricevuta

        //  ***** CARICA RICEVUTA *****
        $(function () {
            var FormDate = $('#FVSpese_LBdate').html();

            // Initialize the jQuery File Upload widget:  
            $('#CaricaRicevuta').fileupload({
                // i parametri addizionali vengono letti dal form e passati nella url
                url: "/timereport/webservices/carica_file.ashx?expenses_id=<%=Request.QueryString["Expenses_Id"]%>&UserName=<%=CurrentSession.UserName%>&TbDate=" + FormDate,
                dataType: 'json',
                // caricamento parte alla selezione del file
                autoUpload: true,
                // Allowed file types and size
                acceptFileTypes: /(jpg)|(jpeg)|(png)|(gif)|(pdf)|(bmp)$/i,
                maxFileSize: 5000000, // 5 MB
                // Resize immagini
                disableImageResize: /Android(?!.*Chrome)|Opera/
                    .test(window.navigator && navigator.userAgent),
                imageMaxWidth: 1200,
                imageMaxHeight: 1200,
                imageCrop: false, // no cropped images
                // progress bar (vedi elemento con classe bar nel form di upload)
                progress: function (e, data) {
                    var bar = $('.bar');
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    var percentVal = progress + '%';
                    bar.width(percentVal);
                },
            })
                .bind('fileuploaddone', function (e, data) {
                    // aggiunge la riga alla tabella dei file quando torna la chiamata
                    $('#TabellaRicevute').append(data.result);
                    $('.bar').width(0);
                })
                .bind('fileuploadfail', function (e, data) {
                    // Cattura e visualizza il messaggio di errore
                    var errorMessage = "Errore durante il caricamento del file.";
                    if (data.errorThrown) {
                        errorMessage += " Dettagli: " + data.errorThrown;
                    }
                    ShowPopup(errorMessage);
                })
                .bind('fileuploadprocessfail', function (e, data) {
                    var errorMessage = "Errore durante il caricamento del file.";
                    if (data.files[0].error) {
                        errorMessage += " Dettagli: " + data.files[0].error;
                    }
                    ShowPopup(errorMessage);
                })
        });

        // *****  SALVA FORM *****
        $("#FVSpese_PostButton, #FVSpese_RicevuteButton" ).on("click", function (e) {

            e.preventDefault();

            // Trigger validation without submitting the form
            if (!form.validate()) {
                // in modale la sola applicazione di fogli di stile per nascondere i messaggi di errore non è sufficiente
                var errorMessages = $('#valMsg .parsley-errors-list.filled');
                if (errorMessages.length > 1)
                    errorMessages.not(':first').hide();
                return;
            }

            var ExpensesId = '<%= String.IsNullOrEmpty(Request.QueryString["expenses_id"]) ? "0" : Request.QueryString["expenses_id"] %>';
            var AccountingDate = isNullOrEmpty($('#FVSpese_TBAccountingDate').val()) ? '' : $('#FVore_TBAccountingDate').val();

            // Submit the form
            var values = "{ 'Expenses_Id' : " + ExpensesId  +
                " , 'Date': '" + $('#FVSpese_LBdate').text() + "'" +
                " , 'ExpenseAmount': '" + $('#FVSpese_TBAmount').val().replace(',', '.') + "'" +
                " , 'Person_Id': '" + <%= CurrentSession.Persons_id %> + "'" +
                " , 'Project_Id': '" + $('#FVSpese_DDLprogetto').val() + "'" +
                " , 'ExpenseType_Id': '" + $('#FVSpese_DDLTipoSpesa').val() + "'" +
                " , 'Comment': '" + $('#FVSpese_TBComment').val() + "'" +
                " , 'CreditCardPayed': " + $('#FVSpese_CBCreditCard').is(':checked') + 
                " , 'CompanyPayed': " + $('#FVSpese_CBCompanyPayed').is(':checked') + 
                " , 'CancelFlag': " + $('#FVSpese_CBcancel').is(':checked') + 
                " , 'InvoiceFlag': " + $('#FVSpese_CBInvoice').is(':checked') + 
                " , 'strFileName': ''" + // non salva il file 
                " , 'strFileData': ''" +
                " , 'OpportunityId': '" + ($('#FVSpese_DDLOpportunity').is(':visible') ? $('#FVSpese_DDLOpportunity').val() : '') + "'" +
                " , 'AccountingDate': '" + AccountingDate + "'" + 
                " , 'UserId': ''" +
                "}";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_DBUpdates.asmx/SaveExpenses",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var result = response.d;
                    if (result.Success) {
                        if (e.target.id === "FVSpese_PostButton")
                            window.location.href = "/timereport/input.aspx";
                        else
                            window.location.href = "/timereport/input-spese.aspx?action=fetch&expenses_id=" + result.ExpensesId;
                    } else {
                        ShowPopup('Errore durante aggiornamento');
                    }
                },
                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup(xhr.responseText);
                }
            }); // ajax

        });

    </script>

</body>

</html>
