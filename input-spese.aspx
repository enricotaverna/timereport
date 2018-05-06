<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-spese.aspx.cs" Inherits="input_spese"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<style>
	.bar {
		height: 18px;
		background: green;
	}
</style>

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.js"></script>

<!-- Jquery per Uploader  -->
<script src="/timereport/include/standard/uploader/jquery.ui.widget.js"></script>
<script src="/timereport/include/standard/uploader/load-image.all.min.js"></script>
<script src="/timereport/include/standard/uploader/canvas-to-blob.min.js"></script>
<script src="/timereport/include/standard/uploader/jquery.iframe-transport.js"></script>
<script src="/timereport/include/standard/uploader/jquery.fileupload.js"></script>
<script src="/timereport/include/standard/uploader/jquery.fileupload-process.js"></script>
<script src="/timereport/include/standard/uploader/jquery.fileupload-image.js"></script>
<script src="/timereport/include/standard/uploader/jquery.fileupload-validate.js"></script>

<!-- Jquery per messaggio errore validatore custom  -->
<script src="/timereport/include/javascript/timereport.js"></script> 

<link rel="stylesheet" href="/timereport/include/standard/uploader/uploader.css" />

<script>

	$(function () {

		$("#FVSpese_TBAccountingDate").datepicker($.datepicker.regional['it']);

		$("#FVSpese_CBcancel").addClass("css-checkbox");
		$("#FVSpese_CBInvoice").addClass("css-checkbox");
		$("#FVSpese_CBCreditCard").addClass("css-checkbox");
		$("#FVSpese_CBCompanyPayed").addClass("css-checkbox");

		$("#FVSpese_disCBcancel").addClass("css-checkbox");
		$("#FVSpese_disCBcancel").attr("disabled", true);

		$("#FVSpese_disCBInvoice").addClass("css-checkbox");
		$("#FVSpese_disCBInvoice").attr("disabled", true);

		$("#FVSpese_disCBCreditCard").addClass("css-checkbox");
		$("#FVSpese_disCBCreditCard").attr("disabled", true);

		$("#FVSpese_disCBCompanyPayed").addClass("css-checkbox");
		$("#FVSpese_disCBCompanyPayed").attr("disabled", true);

		// validation summary su validator custom
		displayAlert();

	});

</script>

<script type="text/javascript" language="javascript">

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
			url: "/timereport/webservices/carica_file.ashx?expenses_id=<%=Request.QueryString["Expenses_Id"]%>&UserName=<%=Session["UserName"]%>&TbDate=" + FormDate,
			dataType: 'json',
			// caricamento parte alla selezione del file
			autoUpload: true,
			// Allowed file types and size
			acceptFileTypes: /(jpg)|(jpeg)|(png)|(gif)|(pdf)|(bmp)$/i,
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
			 $('#TabellaRicevute tbody').append(data.result);
			 $('.bar').width(0);
		 })
		 .bind('fileuploadfail', function (e, data) {
			 alert(data);
		 })
	});

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title></title>
</head>
<body>

	<div id="TopStripe"></div>

	<div id="MainWindow">

		<div id="FormWrap">

			<form id="form1" runat="server">

				<asp:FormView ID="FVSpese" runat="server" DataKeyNames="Expenses_Id"
					DataSourceID="DSspese" align="center" DefaultMode="Edit"
					CssClass="StandardForm" OnDataBound="FVSpese_DataBound"
					OnItemUpdated="FVSpese_ItemUpdated" OnModeChanging="FVSpese_modechanging" meta:resourcekey="FVSpeseResource1">

					<%--        INSERT--%>
					<InsertItemTemplate>

						<div class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" /></div>

						<!-- *** LB Data ***  -->
						<div class="input">
							<asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource1"></asp:Label>
							<asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date") %>' meta:resourcekey="LBdateResource2"></asp:Label>
							<asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource2"></asp:Label>
						</div>

						<!-- *** DDL Progetto ***  -->
						<div class="input nobottomborder">
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:progetto%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
									AutoPostBack="True" meta:resourcekey="DDLprogettoResource2" OnSelectedIndexChanged="DDLprogetto_SelectedIndexChanged">
								</asp:DropDownList>
							</div>
						</div>
						
						<asp:CustomValidator ID="CV_DDLprogetto" runat="server" Display="None" ErrorMessage="Carico spese non ammesso" ControlToValidate="DDLprogetto" OnServerValidate="CV_DDLprogetto_ServerValidate" meta:resourcekey="CV_DDLprogettoResource2"    ></asp:CustomValidator>

						<!-- *** DDL Tipo Spesa ***  -->
						<div class="input nobottomborder">
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:tipo%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
									AutoPostBack="True" OnDataBound="DDLTipoSpesa_SelectedIndexChanged"
									OnSelectedIndexChanged="DDLTipoSpesa_SelectedIndexChanged" meta:resourcekey="DDLTipoSpesaResource2">
								</asp:DropDownList>
							</div>
						</div>

						<!-- *** Valore e storno ***  -->
						<div class="input">

							<asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource2"></asp:Label>
							<span class="input2col">
								<asp:TextBox CssClass="ASPInputcontent" ID="TBAmount" runat="server" Text='<%# Bind("Amount") %>' Columns="6" meta:resourcekey="TBAmountResource2" />
							</span>

							<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TBAmount" Display="None"
								ErrorMessage="Inserire un importo" meta:resourcekey="RequiredFieldValidator3Resource2"  ></asp:RequiredFieldValidator>

							<asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server"
								ControlToValidate="TBAmount" Display="None"
								ErrorMessage="Inserire un valore numerico"
								ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)" meta:resourcekey="RegularExpressionValidator2Resource1"  ></asp:RegularExpressionValidator>

						</div>

						<!-- *** Flag Fattura / CC ***  -->
						<div class="input nobottomborder"  >

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="CBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' meta:resourcekey="CBInvoiceResource2" />
								<asp:Label AssociatedControlID="CBInvoice" CssClass="css-label" ID="Label3" runat="server" Text="Fattura" meta:resourcekey="Label3Resource1"></asp:Label>
							</span>

							<asp:CheckBox ID="CBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' meta:resourcekey="CBCreditCardResource2" />
							<asp:Label AssociatedControlID="CBCreditCard" CssClass="css-label" ID="LBCBCreditCard" runat="server" Text="C.Cred. Azienda" meta:resourcekey="LBCBCreditCardResource2"></asp:Label>

						</div>

						
						<!-- *** Flag Storno / Pagato Azienda ***  -->
						<div class="input"  >

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="CBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CBcancelResource2" />
								<asp:Label AssociatedControlID="CBcancel" CssClass="css-label" ID="Label8" runat="server" Text="Storno" meta:resourcekey="Label8Resource1"></asp:Label>
							</span>

							<asp:CheckBox ID="CBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' meta:resourcekey="CBCompanyPayedResource2" />
							<asp:Label AssociatedControlID="CBCompanyPayed" CssClass="css-label" ID="Label9" runat="server" Text="Bonifico Azienda" meta:resourcekey="Label9Resource1"></asp:Label>

						</div>

						<!-- *** TB Comment ***  -->
						<div class="input nobottomborder">
							<asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota" meta:resourcekey="LbCommentResource2"></asp:Label>
							<asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource2" />
						</div>
						<asp:CustomValidator ID="CV_TBComment" runat="server" Display="None" ErrorMessage="Inserire una nota di commento" ControlToValidate="TBComment" OnServerValidate="CV_TBComment_ServerValidate" ValidateEmptyText="True" meta:resourcekey="CV_TBCommentResource2"  ></asp:CustomValidator>

						<!-- *** TB Competenza ***  -->
						<div class="input nobottomborder">
							<asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource2"></asp:Label>
							<asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource2" />
							<asp:RangeValidator ID="RangeValidator2" runat="server" Display="None"
								ErrorMessage="Inserire una data competenza valida" ControlToValidate="TBAccountingDate"
								Type="Date" MaximumValue="31/12/9999" MinimumValue="1/1/2000" meta:resourcekey="RangeValidator2Resource2"></asp:RangeValidator>
						</div>

						<!-- *** Bottoni ***  -->
						<div class="buttons">
							<asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>"  />
							<asp:Button ID="RicevuteButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport, TICKETS %>"  />
							<asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>"   />
						</div>

					</InsertItemTemplate>

					<%--        EDIT--%>
					<EditItemTemplate>

						<div class="formtitle">
							<asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" />
			   <a href="AuditLog.aspx?RecordId=&amp;TableName=Expenses&amp;TYPE=U&amp;key=&lt;Expenses_Id=&gt;">
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
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:progetto%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"  OnSelectedIndexChanged="DDLprogetto_SelectedIndexChanged"
									AutoPostBack="True" meta:resourcekey="DDLprogettoResource1">
								</asp:DropDownList>
							</div>
						</div>

						<asp:CustomValidator ID="CV_DDLprogetto" runat="server" Display="None" ErrorMessage="Carico spese non ammesso" ControlToValidate="DDLprogetto" OnServerValidate="CV_DDLprogetto_ServerValidate" meta:resourcekey="CV_DDLprogettoResource1"    ></asp:CustomValidator>

						<!-- *** DDL Tipo Spesa ***  -->
						<div class="input nobottomborder">
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:tipo%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
									AutoPostBack="True" OnSelectedIndexChanged="DDLTipoSpesa_SelectedIndexChanged" meta:resourcekey="DDLTipoSpesaResource1">
								</asp:DropDownList>
							</div>
						</div>

						<!-- *** Valore e storno ***  -->
						<div class="input">

							<asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource1"></asp:Label>
							<span class="input2col">
								<asp:TextBox CssClass="ASPInputcontent" ID="TBAmount" runat="server" Text='<%# Bind("Amount") %>' Columns="6" meta:resourcekey="TBAmountResource1" />
							</span>

							<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TBAmount" Display="None"
								ErrorMessage="Importo deve essere un valore numerico" meta:resourcekey="RequiredFieldValidator3Resource1"  ></asp:RequiredFieldValidator>

							<asp:RegularExpressionValidator ID="Validator" runat="server"
								ControlToValidate="TBAmount" Display="None"
								ErrorMessage="Inserire un valore numerico"
								ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)" meta:resourcekey="ValidatorResource1"  ></asp:RegularExpressionValidator>

						</div>

						<!-- *** Flag Fattura / CC ***  -->
						<div class="input nobottomborder">

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="CBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' meta:resourcekey="CBInvoiceResource1" />
								<asp:Label AssociatedControlID="CBInvoice" CssClass="css-label" ID="LbInvoice" runat="server" Text="Fattura" meta:resourcekey="LbInvoiceResource1"></asp:Label>
							</span>
							
							<asp:CheckBox ID="CBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' meta:resourcekey="CBCreditCardResource1" />
							<asp:Label AssociatedControlID="CBCreditCard" CssClass="css-label" ID="LBCBCreditCard" runat="server" Text="C.Cred. Azienda" meta:resourcekey="LBCBCreditCardResource1"></asp:Label>

						</div>

						<!-- *** Flag Storno / Pagato Azienda ***  -->
						<div class="input">

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="CBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CBcancelResource1" />
								<asp:Label AssociatedControlID="CBcancel" CssClass="css-label" ID="Label5" runat="server" Text="Storno" meta:resourcekey="Label5Resource1"></asp:Label>
							</span>

							<asp:CheckBox ID="CBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' meta:resourcekey="CBCompanyPayedResource1" />
							<asp:Label AssociatedControlID="CBCompanyPayed" CssClass="css-label" ID="LBCompanyPayed" runat="server" Text="Bonifico Azienda" meta:resourcekey="LBCompanyPayedResource1"></asp:Label>

						</div>

						<!-- *** TB Comment ***  -->
						<div class="input nobottomborder">
							<asp:Label CssClass="inputtext" ID="LbComment" runat="server" Text="Nota" meta:resourcekey="LbCommentResource1"></asp:Label>
							<asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource1" />
						</div>
						<asp:CustomValidator ID="CV_TBComment" runat="server" Display="None" ErrorMessage="Inserire una nota di commento" ControlToValidate="TBComment" OnServerValidate="CV_TBComment_ServerValidate" ValidateEmptyText="True" meta:resourcekey="CV_TBCommentResource1" ></asp:CustomValidator>


						<!-- *** TB Competenza ***  -->
						<div class="input nobottomborder">
							<asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource1"></asp:Label>
							<asp:TextBox CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource1" />
							<asp:RangeValidator ID="RangeValidator2" runat="server" Display="None"
								ErrorMessage="Inserire una data competenza valida" ControlToValidate="TBAccountingDate"
								Type="Date" MaximumValue="31/12/9999" MinimumValue="1/1/2000" meta:resourcekey="RangeValidator2Resource1"></asp:RangeValidator>
						</div>

						<!-- *** Bottoni ***  -->
						<div class="buttons">
							<asp:Button ID="UpdateButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" meta:resourcekey="UpdateButtonResource1" />
							<asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource1" />
						</div>

					</EditItemTemplate>

					<%--        DISPLAY--%>
					<ItemTemplate>

						<div class="formtitle">
							 <asp:Literal runat="server" Text="<%$ Resources:inserimento_spese%>" />
			   <a href="AuditLog.aspx?RecordId=&amp;TableName=Expenses&amp;TYPE=U&amp;key=&lt;Expenses_Id=&gt;">
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
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:progetto%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"
									AutoPostBack="True" Enabled="False" meta:resourcekey="DDLprogettoResource3">
								</asp:DropDownList>
							</div>
						</div>

						<!-- *** DDL Tipo Spesa ***  -->
						<div class="input nobottomborder">
							<div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:tipo%>" /></div>
							<div class="InputcontentDDL" style="width: 265px">
								<asp:DropDownList ID="DDLTipoSpesa" runat="server" AppendDataBoundItems="True"
									AutoPostBack="True" Enabled="False" meta:resourcekey="DDLTipoSpesaResource3">
								</asp:DropDownList>
							</div>
						</div>

						<!-- *** Valore e storno ***  -->
						<div class="input">

							<asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Valore / km" meta:resourcekey="Label2Resource3"></asp:Label>
							<span class="input2col">
								<asp:TextBox CssClass="ASPInputcontent" ID="TBAmount" runat="server"
									Text='<%# Bind("Amount") %>' Columns="6" Enabled="False" meta:resourcekey="TBAmountResource3" />
							</span>

							<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TBAmount" Display="None"
								ErrorMessage="Importo deve essere un valore numerico" meta:resourcekey="RequiredFieldValidator3Resource3"  ></asp:RequiredFieldValidator>

						</div>

						<!-- *** Flag Fattura / CC ***  -->
						<div class="input nobottomborder" >

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="disCBInvoice" runat="server" Checked='<%# Bind("InvoiceFlag") %>' meta:resourcekey="disCBInvoiceResource1" />
								<asp:Label AssociatedControlID="disCBInvoice" CssClass="css-label" ID="Label3"
									runat="server" Text="Fattura" meta:resourcekey="Label3Resource2"></asp:Label>
							</span>

							<asp:CheckBox ID="disCBCreditCard" runat="server" Checked='<%# Bind("CreditCardPayed") %>' meta:resourcekey="disCBCreditCardResource1" />
							<asp:Label AssociatedControlID="disCBCreditCard" CssClass="css-label" ID="Label4" runat="server" Text="C.Cred. Azienda" meta:resourcekey="Label4Resource1"></asp:Label>

						</div>

						<!-- *** Flag Storno / Pagato azienda ***  -->
						<div class="input" >

							<!-- *** posizionamento ***  -->
							<div class="inputtext">&nbsp;</div>

							<span class="input2col">
								<asp:CheckBox ID="disCBcancel" runat="server" Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="disCBcancelResource1" />
								<asp:Label AssociatedControlID="disCBcancel" CssClass="css-label" ID="Label5" runat="server" Text="Storno" meta:resourcekey="Label5Resource2"></asp:Label>
							</span>

							<asp:CheckBox ID="disCBCompanyPayed" runat="server" Checked='<%# Bind("CompanyPayed") %>' meta:resourcekey="disCBCompanyPayedResource1" />
							<asp:Label AssociatedControlID="disCBCompanyPayed" CssClass="css-label" ID="Label6" runat="server" Text="Bonifico Azienda" meta:resourcekey="Label6Resource1"></asp:Label>

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
							<asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" Enabled="False" meta:resourcekey="LBAccountingDateResource3"></asp:Label>
							<asp:Label ID="LBAccountingDateDisplay" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" meta:resourcekey="LBAccountingDateDisplayResource1"></asp:Label>
						</div>

						<!-- *** Bottoni ***  -->
						<div class="buttons">
							<asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource3" />
						</div>

					</ItemTemplate>

				</asp:FormView>

				<%--        INSERT--%>
				<asp:SqlDataSource ID="DSSpese" runat="server"
					ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
					SelectCommand="SELECT Expenses_Id, Projects_Id, Expenses.Persons_id, ExpenseType_id, Date, Amount, Comment, CreditCardPayed, CompanyPayed, CancelFlag, InvoiceFlag, CreatedBy, CreationDate, LastModifiedBy, LastModificationDate, AccountingDate, TipoBonus_id, Persons.Name FROM Expenses INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id WHERE (Expenses_Id = @Expenses_Id)"
					InsertCommand="INSERT INTO Expenses(Projects_Id, Persons_id, Date, ExpenseType_Id, Amount, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, Comment, CreatedBy, CreationDate, AccountingDate, TipoBonus_id) VALUES (@Projects_Id, @Persons_id, @Date, @ExpenseType_id, @Amount, @CancelFlag, @CreditCardPayed, @CompanyPayed, @InvoiceFlag, @Comment, @CreatedBy, @CreationDate, @AccountingDate, @TipoBonus_id);"
					UpdateCommand="UPDATE Expenses SET Amount = @Amount , ExpenseType_Id = @ExpenseType_Id, CancelFlag = @CancelFlag, Comment = @Comment, InvoiceFlag = @InvoiceFlag, CreditCardPayed = @CreditCardPayed, CompanyPayed = @CompanyPayed, Projects_Id = @Projects_Id, LastModifiedBy= @LastModifiedBy, LastModificationDate = @LastModificationDate, AccountingDate = @AccountingDate, TipoBonus_id = @TipoBonus_id WHERE (Expenses_Id = @Expenses_Id)"
					OnInserting="DSSpese_Insert_Update" OnUpdating="DSSpese_Insert_Update" OnInserted="DSSpese_Inserted">

					<SelectParameters>
						<asp:QueryStringParameter Name="expenses_id" QueryStringField="expenses_id" />
					</SelectParameters>

					<InsertParameters>
						<asp:Parameter Name="Expenses_Id" /> <%-- per ritornare l'id del record inserito--%>
						<asp:Parameter Name="Projects_Id" />
						<asp:Parameter Name="Persons_id" />
						<asp:Parameter Name="Date" />
						<asp:Parameter Name="ExpenseType_id" />
						<asp:Parameter Name="Amount" />
						<asp:Parameter Name="CancelFlag" />
						<asp:Parameter Name="CreditCardPayed" />
						<asp:Parameter Name="CompanyPayed" />
						<asp:Parameter Name="InvoiceFlag" />
						<asp:Parameter Name="Comment" />
						<asp:Parameter Name="CreatedBy" />
						<asp:Parameter Name="CreationDate" />
						<asp:Parameter Name="AccountingDate" Type="DateTime" />
						<asp:Parameter Name="TipoBonus_id" />
					</InsertParameters>

					<UpdateParameters>
						<asp:Parameter Name="expenses_id" />
						<asp:Parameter Name="Projects_Id" />
						<asp:Parameter Name="Persons_id" />
						<asp:Parameter Name="Date" />
						<asp:Parameter Name="ExpenseType_id" />
						<asp:Parameter Name="Amount" />
						<asp:Parameter Name="CancelFlag" />
						<asp:Parameter Name="CreditCardPayed" />
						<asp:Parameter Name="CompanyPayed" />
						<asp:Parameter Name="InvoiceFlag" />
						<asp:Parameter Name="Comment" />
						<asp:Parameter Name="LastModifiedBy" />
						<asp:Parameter Name="LastModificationDate" />
						<asp:Parameter Name="AccountingDate" Type="DateTime" />
						<asp:Parameter Name="TipoBonus_id" />
					</UpdateParameters>

				</asp:SqlDataSource>
				<%--        EDIT--%>

				<asp:ValidationSummary ID="ValidationSummary" runat="server" ShowMessageBox="True" ShowSummary="False" meta:resourcekey="ValidationSummaryResource1" />

				<!-- **** UPLOAD FILE *** -->
				<div runat="server" id="BoxRicevute">
					<!--  Tabella viene caricata da server se ci sono file nella directory  -->
					<table id="TabellaRicevute" runat="server">
						<tr>
							<th colspan="3" class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:giustificativi%>" /></th>
						</tr>
					</table>
					<br />

					<div id="progress">
						<div class="bar" style="width: 0%;"></div>
					</div>
					<br />

					<!-- Bottone Upload -->
					<div class="buttons" runat="server" id="divBottoni">
						<div class="fileUpload btn btn-primary">
							<span class="orangebutton" style="width: 80%; text-align: center"><asp:Literal runat="server" Text="<%$ Resources:carica_file%>" /></span>
							<input id="CaricaRicevuta" name="files[]" type="file" class="upload" />
						</div>
					</div>

				</div>
				<!--BoxRicevute-->

			</form>

		</div>
		<%--        DISPLAY--%>
	</div>
	<%--        INSERT--%>

	<!-- Per output messaggio warning -->
	<div id="dialog" style="display: none"></div>

		<!-- **** FOOTER **** -->  
	<div id="WindowFooter">       
		<div ></div>        
		<div  id="WindowFooter-L"> Aeonvis Spa <%-- per ritornare l'id del record inserito--%></div> 
		<div  id="WindowFooter-C">cutoff: <%--        EDIT--%>  </div>              
		<div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%--        DISPLAY--%></div>       
	 </div>  

</body>
</html>
