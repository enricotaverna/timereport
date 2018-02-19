<!--#include file="rptinc/ewconfig.asp"-->
<!--#include file="rptinc/asprptfn.asp"-->
<!--#include file="rptinc/advsecu.asp"-->
<% Session.Timeout = 20 %>
<% Response.buffer = False %>
<% Server.ScriptTimeOut = 240 %>
<%
sExport = Request.QueryString("export") ' Load Export Request
If sExport = "excel" Then
	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-Disposition", "attachment; filename=" & EW_TABLE_VAR & ".xls"
End If
%>
<%

' ASP Report Maker 1.0 - Table level configuration (TotaliSpese)
' Table Level Constants

Const EW_TABLE_VAR = "TotaliSpese"
Const EW_TABLE_GROUP_PER_PAGE = "grpperpage"
Const EW_TABLE_SESSION_GROUP_PER_PAGE = "TotaliSpese_grpperpage"
Const EW_TABLE_START_GROUP = "start"
Const EW_TABLE_SESSION_START_GROUP = "TotaliSpese_start"
Const EW_TABLE_SESSION_SEARCH = "TotaliSpese_search"
Const EW_TABLE_CHILD_USER_ID = "childuserid"
Const EW_TABLE_SESSION_CHILD_USER_ID = "TotaliSpese_childuserid"

' Table Level SQL
Const EW_TABLE_SQL_FROM = "[v_spese]"
Dim EW_TABLE_SQL_SELECT
EW_TABLE_SQL_SELECT = "SELECT * FROM " & EW_TABLE_SQL_FROM
Dim EW_TABLE_SQL_WHERE
EW_TABLE_SQL_WHERE = session("whereclause")
Const EW_TABLE_SQL_GROUPBY = ""
Const EW_TABLE_SQL_HAVING = ""
Const EW_TABLE_SQL_ORDERBY = "[NomeProgetto] ASC, [Persona] ASC, [ExpenseCode] ASC"
Const EW_TABLE_SQL_USERID_FILTER = ""
Dim af_NomeProgetto ' Advanced filter for NomeProgetto
Dim af_Persona ' Advanced filter for Persona
Dim af_ExpenseCode ' Advanced filter for ExpenseCode
Dim af_DescSpesa ' Advanced filter for DescSpesa
Dim af_KM ' Advanced filter for KM
Dim af_CreditCardPayed ' Advanced filter for CreditCardPayed
Dim af_InvoiceFlag ' Advanced filter for InvoiceFlag
Dim af_Date ' Advanced filter for Date
Dim af_Importo ' Advanced filter for Importo
%>
<%
Dim EW_FIELD_PERSONA_SQL_SELECT
EW_FIELD_PERSONA_SQL_SELECT = "SELECT DISTINCT [Persona] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_PERSONA_SQL_ORDERBY = "[Persona]"
Dim EW_FIELD_EXPENSECODE_SQL_SELECT
EW_FIELD_EXPENSECODE_SQL_SELECT = "SELECT DISTINCT [ExpenseCode] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_EXPENSECODE_SQL_ORDERBY = "[ExpenseCode]"
Dim EW_FIELD_CREDITCARDPAYED_SQL_SELECT
EW_FIELD_CREDITCARDPAYED_SQL_SELECT = "SELECT DISTINCT [CreditCardPayed] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_CREDITCARDPAYED_SQL_ORDERBY = "[CreditCardPayed]"
Dim EW_FIELD_INVOICEFLAG_SQL_SELECT
EW_FIELD_INVOICEFLAG_SQL_SELECT = "SELECT DISTINCT [InvoiceFlag] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_INVOICEFLAG_SQL_ORDERBY = "[InvoiceFlag]"
Dim EW_FIELD_DATE_SQL_SELECT
EW_FIELD_DATE_SQL_SELECT = "SELECT DISTINCT [Date] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_DATE_SQL_ORDERBY = "[Date]"
%>
<%

' Initialize common variables
' Paging variables

Dim nRecCount: nRecCount = 0       ' Record Count
Dim nStartGrp: nStartGrp = 0       ' Start Group
Dim nStopGrp: nStopGrp = 0         ' Stop Group
Dim nTotalGrps: nTotalGrps = 0     ' Total Groups
Dim nGrpCount: nGrpCount = 0       ' Group Count
Dim nDisplayGrps: nDisplayGrps = 40 ' Groups per page
Dim nGrpRange: nGrpRange = 10

' Group variables
Dim x_NomeProgetto, ox_NomeProgetto, gx_NomeProgetto, dgx_NomeProgetto, tx_NomeProgetto, ftx_NomeProgetto, gfx_NomeProgetto, gbx_NomeProgetto, gix_NomeProgetto
x_NomeProgetto = Null: ox_NomeProgetto = Null: gx_NomeProgetto = Null: dgx_NomeProgetto = Null: tx_NomeProgetto = Null
ftx_NomeProgetto = 202: gfx_NomeProgetto = ftx_NomeProgetto: gbx_NomeProgetto = "": gix_NomeProgetto = "0"
Dim rf_NomeProgetto, rt_NomeProgetto
Dim x_Persona, ox_Persona, gx_Persona, dgx_Persona, tx_Persona, ftx_Persona, gfx_Persona, gbx_Persona, gix_Persona
x_Persona = Null: ox_Persona = Null: gx_Persona = Null: dgx_Persona = Null: tx_Persona = Null
ftx_Persona = 202: gfx_Persona = ftx_Persona: gbx_Persona = "": gix_Persona = "0"
Dim rf_Persona, rt_Persona
Dim x_ExpenseCode, ox_ExpenseCode, gx_ExpenseCode, dgx_ExpenseCode, tx_ExpenseCode, ftx_ExpenseCode, gfx_ExpenseCode, gbx_ExpenseCode, gix_ExpenseCode
x_ExpenseCode = Null: ox_ExpenseCode = Null: gx_ExpenseCode = Null: dgx_ExpenseCode = Null: tx_ExpenseCode = Null
ftx_ExpenseCode = 202: gfx_ExpenseCode = ftx_ExpenseCode: gbx_ExpenseCode = "": gix_ExpenseCode = "0"
Dim rf_ExpenseCode, rt_ExpenseCode

' Detail variables
Dim x_DescSpesa, ox_DescSpesa, tx_DescSpesa, ftx_DescSpesa
x_DescSpesa = Null: ox_DescSpesa = Null: tx_DescSpesa = Null: ftx_DescSpesa = 202
Dim rf_DescSpesa, rt_DescSpesa
Dim x_KM, ox_KM, tx_KM, ftx_KM
x_KM = Null: ox_KM = Null: tx_KM = Null: ftx_KM = 6
Dim rf_KM, rt_KM
Dim x_CreditCardPayed, ox_CreditCardPayed, tx_CreditCardPayed, ftx_CreditCardPayed
x_CreditCardPayed = Null: ox_CreditCardPayed = Null: tx_CreditCardPayed = Null: ftx_CreditCardPayed = 11
Dim rf_CreditCardPayed, rt_CreditCardPayed
Dim x_InvoiceFlag, ox_InvoiceFlag, tx_InvoiceFlag, ftx_InvoiceFlag
x_InvoiceFlag = Null: ox_InvoiceFlag = Null: tx_InvoiceFlag = Null: ftx_InvoiceFlag = 11
Dim rf_InvoiceFlag, rt_InvoiceFlag
Dim x_Date, ox_Date, tx_Date, ftx_Date
x_Date = Null: ox_Date = Null: tx_Date = Null: ftx_Date = 135
Dim rf_Date, rt_Date
Dim x_Importo, ox_Importo, tx_Importo, ftx_Importo
x_Importo = Null: ox_Importo = Null: tx_Importo = Null: ftx_Importo = 5
Dim rf_Importo, rt_Importo
%>
<%
Dim conn

' Open connection to the database
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open EW_CONNECTION_STRING

' Filter
Dim sFilter: sFilter = ""
Dim bFilterApplied: bFilterApplied = False

' Aggregate variables
Dim ix, iy

' 1st dimension = no of groups (level 0 used for grand total)
' 2nd dimension = no of fields

Dim col(6), val(6), cnt(3,6)
Dim smry(3,6), mn(3,6), mx(3,6)
Dim grandsmry(6), grandmn(6), grandmx(6)

' Set up if accumulation required
col(1) = False
col(2) = False
col(3) = False
col(4) = False
col(5) = False
col(6) = True

' Reset
Call ResetCmd()

' Set up groups per page dynamically
SetUpDisplayGrps()
Call SetupSelection()

' Build sql
Dim sSql
sSql = ew_BuildReportSql("", EW_TABLE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_TABLE_SQL_ORDERBY, "", sFilter, sSort)

' Response.Write sSql & "<br>" ' uncomment to show sql
' Load recordset

Dim rs
Set rs = ew_LoadRs(sSql)

' Group distinct & selection values
Dim sel_Persona, val_Persona
Dim sel_ExpenseCode, val_ExpenseCode

' Detail distinct & selection values
Dim sel_CreditCardPayed, val_CreditCardPayed
Dim sel_InvoiceFlag, val_InvoiceFlag
Dim sel_Date, val_Date
Call InitReportData(rs)
If nDisplayGrps <= 0 Then ' Display All Records
	nDisplayGrps = nTotalGrps
End If
nStartGrp = 1
SetUpStartGroup() ' Set Up Start Record Position
%>
<% If sExport = "" Then %>
<!--#include file="rptinc/tm-header.asp"-->
<% End If %>
<!--#include file="rptinc/header.asp"-->
<% If sExport = "" Then %>
<script language="JavaScript" src="rptjs/x/x_core.js" type="text/javascript"></script>
<script language="JavaScript" src="rptjs/x/x_event.js" type="text/javascript"></script>
<script language="JavaScript" src="rptjs/x/x_drag.js" type="text/javascript"></script>
<script language="JavaScript" src="rptjs/popup.js" type="text/javascript"></script>
<script language="JavaScript" src="rptjs/ewrptpop.js" type="text/javascript"></script>
<script language="JavaScript" src="rptjs/ewchart.js" type="text/javascript"></script>
<script language="JavaScript" type="text/javascript">
<!--
var EW_POPUP_ALL = "(All)";
var EW_POPUP_OK = "  OK  ";
var EW_POPUP_CANCEL = "Cancel";
var EW_POPUP_FROM = "From";
var EW_POPUP_TO = "To";
var EW_POPUP_PLEASE_SELECT = "Please Select";
var EW_POPUP_NO_VALUE = "No value selected!";
<% Dim jsdata %>
// popup fields
<% jsdata = ew_GetJsData("TotaliSpesePersona", val_Persona, ftx_Persona) %>
ew_CreatePopup("TotaliSpesePersona", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("TotaliSpeseExpenseCode", val_ExpenseCode, ftx_ExpenseCode) %>
ew_CreatePopup("TotaliSpeseExpenseCode", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("TotaliSpeseCreditCardPayed", val_CreditCardPayed, ftx_CreditCardPayed) %>
ew_CreatePopup("TotaliSpeseCreditCardPayed", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("TotaliSpeseInvoiceFlag", val_InvoiceFlag, ftx_InvoiceFlag) %>
ew_CreatePopup("TotaliSpeseInvoiceFlag", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("TotaliSpeseDate", val_Date, ftx_Date) %>
ew_CreatePopup("TotaliSpeseDate", [<%=jsdata%>]);
//-->
</script>
<div id="TotaliSpesePersona_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="TotaliSpeseExpenseCode_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="TotaliSpeseCreditCardPayed_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="TotaliSpeseInvoiceFlag_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="TotaliSpeseDate_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<% End If %>
<% If sExport = "" Then %>
<!-- Table Container (Begin) -->
<table id="ewContainer" cellspacing="0" cellpadding="0" border="0">
<!-- Top Container (Begin) -->
<tr><td colspan="3" class="ewPadding"><div id="ewTop" class="aspreportmaker">
<!-- top slot -->
<a name="top"></a>
<% End If %>
Totali Spese
<% If sExport = "" Then %>
&nbsp;&nbsp;<a href="TotaliSpesesmry.asp?export=excel">Export to Excel</a>
<% If bFilterApplied Then %>
&nbsp;&nbsp;<a href="TotaliSpesesmry.asp?cmd=reset">Reset All Filters</a>
<% End If %>
<% End If %>
<br><br>
<% If sExport = "" Then %>
</div></td></tr>
<!-- Top Container (End) -->
<tr>
	<!-- Left Container (Begin) -->
	<td valign="top"><div id="ewLeft" class="aspreportmaker">
	<!-- Left slot -->
	</div></td>
	<!-- Left Container (End) -->
	<!-- Center Container - Report (Begin) -->
	<td valign="top" class="ewPadding"><div id="ewCenter" class="aspreportmaker">
	<!-- center slot -->
<% End If %>
<!-- summary report starts -->
<div id="report_summary">
<!-- <form method="get"> -->
<!-- Report Grid (Begin) -->
<table id="ewReport" class="ewTable">
<%

' Start group <= total number of groups
If CLng(nStartGrp) > CLng(nTotalGrps) Then
	nStartGrp = nTotalGrps
End If

' Set the last group to display
nStopGrp = nStartGrp + nDisplayGrps - 1

' Stop group <= total number of groups
If CLng(nStopGrp) > CLng(nTotalGrps) Then
	nStopGrp = nTotalGrps
End If
nRecCount = 0

' Init Summary Values
Call ResetLevelSummary(0)

' Get First Row
If Not rs.Eof Then
	Call GetRow(rs, 1)
	nGrpCount = 1
End If

' Force show first header
Dim bShowFirstHeader
bShowFirstHeader = (nStartGrp <= 1)
Do While (Not rs.Eof) Or (bShowFirstHeader)

		' Show Header
	If bShowFirstHeader Or (CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) And ChkLvlBreak(3)) Then
%>
	<tr>
		<td valign="bottom" class="ewRptGrpHeader1" style="white-space: nowrap;">
		<% If bShowFirstHeader Or ChkLvlBreak(1) Then %>
		Nome Progetto
		<% End If %>
		</td>
		<td valign="bottom" class="ewRptGrpHeader2" style="white-space: nowrap;">
		<% If bShowFirstHeader Or ChkLvlBreak(2) Then %>
		Persona
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'TotaliSpesePersona', false, '<%=rf_Persona%>', '<%=rt_Persona%>');return false;" name="x_Persona<%=cnt(0,0)%>" id="x_Persona<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		<% End If %>
		</td>
		<td valign="bottom" class="ewRptGrpHeader3" style="white-space: nowrap;">
		<% If bShowFirstHeader Or ChkLvlBreak(3) Then %>
		Expense Code
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'TotaliSpeseExpenseCode', false, '<%=rf_ExpenseCode%>', '<%=rt_ExpenseCode%>');return false;" name="x_ExpenseCode<%=cnt(0,0)%>" id="x_ExpenseCode<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader" style="width: 100px; white-space: nowrap;">
		Desc Spesa
		</td>
		<td valign="bottom" class="ewTableHeader">
		KM
		</td>
		<td valign="bottom" class="ewTableHeader" style="width: 40px;">
		CC
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'TotaliSpeseCreditCardPayed', false, '<%=rf_CreditCardPayed%>', '<%=rt_CreditCardPayed%>');return false;" name="x_CreditCardPayed<%=cnt(0,0)%>" id="x_CreditCardPayed<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Fatt
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'TotaliSpeseInvoiceFlag', false, '<%=rf_InvoiceFlag%>', '<%=rt_InvoiceFlag%>');return false;" name="x_InvoiceFlag<%=cnt(0,0)%>" id="x_InvoiceFlag<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader" style="white-space: nowrap;">
		Date
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'TotaliSpeseDate', false, '<%=rf_Date%>', '<%=rt_Date%>');return false;" name="x_Date<%=cnt(0,0)%>" id="x_Date<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader" style="white-space: nowrap;">
		Importo
		</td>
	</tr>
<%
		bShowFirstHeader = False
	End If
	If CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) Then
		nRecCount = nRecCount + 1

		' Set row color
		Dim sItemRowClass
		sItemRowClass = " class=""ewTableRow"""

		' Display alternate color for rows
		If nRecCount Mod 2 <> 1 Then
			sItemRowClass = " class=""ewTableAltRow"""
		End If

		' Show group values
		dgx_NomeProgetto = x_NomeProgetto
		If (IsNull(x_NomeProgetto) And IsNull(ox_NomeProgetto)) Or _
			((x_NomeProgetto <> "" And ox_NomeProgetto = dgx_NomeProgetto) And _
			Not ChkLvlBreak(1)) Then
			dgx_NomeProgetto = ""
		ElseIf IsNull(x_NomeProgetto) Then
			dgx_NomeProgetto = EW_NULL_LABEL
		ElseIf x_NomeProgetto = "" Then
			dgx_NomeProgetto = EW_EMPTY_LABEL
		End If
		dgx_Persona = x_Persona
		If (IsNull(x_Persona) And IsNull(ox_Persona)) Or _
			((x_Persona <> "" And ox_Persona = dgx_Persona) And _
			Not ChkLvlBreak(2)) Then
			dgx_Persona = ""
		ElseIf IsNull(x_Persona) Then
			dgx_Persona = EW_NULL_LABEL
		ElseIf x_Persona = "" Then
			dgx_Persona = EW_EMPTY_LABEL
		End If
		dgx_ExpenseCode = x_ExpenseCode
		If (IsNull(x_ExpenseCode) And IsNull(ox_ExpenseCode)) Or _
			((x_ExpenseCode <> "" And ox_ExpenseCode = dgx_ExpenseCode) And _
			Not ChkLvlBreak(3)) Then
			dgx_ExpenseCode = ""
		ElseIf IsNull(x_ExpenseCode) Then
			dgx_ExpenseCode = EW_NULL_LABEL
		ElseIf x_ExpenseCode = "" Then
			dgx_ExpenseCode = EW_EMPTY_LABEL
		End If
%>
	<tr<%=sItemRowClass%>>
		<td class="ewRptGrpField1" style="white-space: nowrap;">
		<% tx_NomeProgetto = x_NomeProgetto: x_NomeProgetto = dgx_NomeProgetto %>
<%= x_NomeProgetto %>
		<% x_NomeProgetto = tx_NomeProgetto %></td>
		<td class="ewRptGrpField2" style="white-space: nowrap;">
		<% tx_Persona = x_Persona: x_Persona = dgx_Persona %>
<%= x_Persona %>
		<% x_Persona = tx_Persona %></td>
		<td class="ewRptGrpField3" style="white-space: nowrap;">
		<% tx_ExpenseCode = x_ExpenseCode: x_ExpenseCode = dgx_ExpenseCode %>
<%= x_ExpenseCode %>
		<% x_ExpenseCode = tx_ExpenseCode %></td>
		<td class="ewRptDtlField" style="width: 100px; white-space: nowrap;">
<%= x_DescSpesa %>
</td>
		<td class="ewRptDtlField">
<%= x_KM %>
</td>
		<td class="ewRptDtlField" style="width: 40px;">
<%
If x_CreditCardPayed = True Then
	sTmp = "Yes"
Else
	sTmp = "No"
End If
ox_CreditCardPayed = x_CreditCardPayed ' Backup Original Value
x_CreditCardPayed = sTmp
%>
<%= x_CreditCardPayed %>
<% x_CreditCardPayed = ox_CreditCardPayed ' Restore Original Value %>
</td>
		<td class="ewRptDtlField">
<%
If x_InvoiceFlag = True Then
	sTmp = "Yes"
Else
	sTmp = "No"
End If
ox_InvoiceFlag = x_InvoiceFlag ' Backup Original Value
x_InvoiceFlag = sTmp
%>
<%= x_InvoiceFlag %>
<% x_InvoiceFlag = ox_InvoiceFlag ' Restore Original Value %>
</td>
		<td class="ewRptDtlField" style="white-space: nowrap;">
<%= x_Date %>
</td>
		<td class="ewRptDtlField" style="white-space: nowrap;">
<%= x_Importo %>
</td>
	</tr>
<%

		' Accumulate page summary
		Call AccumulateSummary()
	End If

	' Accumulate grand summary
	Call AccumulateGrandSummary()

	' Save old group values
	ox_NomeProgetto = x_NomeProgetto
	ox_Persona = x_Persona
	ox_ExpenseCode = x_ExpenseCode

	' Get next record
	Call GetRow(rs, 2)

	' Show Footers
	If CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) Then
%>
<%
		If ChkLvlBreak(3) And cnt(3,0) > 0 Then
%>
	<tr>
		<td class="ewRptGrpField1"></td>
		<td class="ewRptGrpField2"></td>
		<td colspan="7" class="ewRptGrpSummary3">Summary for Expense Code: <% tx_ExpenseCode = x_ExpenseCode: x_ExpenseCode = ox_ExpenseCode %>
<%= x_ExpenseCode %>
<% x_ExpenseCode = tx_ExpenseCode %> (<%= FormatNumber(cnt(3,0),0) %> Detail Records)</td></tr>
	<tr>
		<td class="ewRptGrpField1"></td>
		<td class="ewRptGrpField2"></td>
		<td colspan="1" class="ewRptGrpSummary3">SUM</td>
		<td class="ewRptGrpSummary3">&nbsp;</td>
		<td class="ewRptGrpSummary3">&nbsp;</td>
		<td class="ewRptGrpSummary3">&nbsp;</td>
		<td class="ewRptGrpSummary3">&nbsp;</td>
		<td class="ewRptGrpSummary3">&nbsp;</td>
		<td class="ewRptGrpSummary3">
		<% tx_Importo = x_Importo %>
		<% x_Importo = smry(3,6) ' Load SUM %>
<%= x_Importo %>
		<% x_Importo = tx_Importo %>
		</td>
	</tr>
	<!--tr><td colspan="9"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<%

			' Reset level 3 summary
			Call ResetLevelSummary(3)
		End If
%>
<%
		If ChkLvlBreak(2) And cnt(2,0) > 0 Then
%>
	<tr>
		<td class="ewRptGrpField1"></td>
		<td colspan="8" class="ewRptGrpSummary2">Summary for Persona: <% tx_Importo = x_Persona: x_Persona = ox_Persona %>
<%= x_Persona %>
<% x_Persona = tx_Importo %> (<%= FormatNumber(cnt(2,0),0) %> Detail Records)</td></tr>
	<tr>
		<td class="ewRptGrpField1"></td>
		<td colspan="2" class="ewRptGrpSummary2">SUM</td>
		<td class="ewRptGrpSummary2">&nbsp;</td>
		<td class="ewRptGrpSummary2">&nbsp;</td>
		<td class="ewRptGrpSummary2">&nbsp;</td>
		<td class="ewRptGrpSummary2">&nbsp;</td>
		<td class="ewRptGrpSummary2">&nbsp;</td>
		<td class="ewRptGrpSummary2">
		<% tx_Importo = x_Importo %>
		<% x_Importo = smry(2,6) ' Load SUM %>
<%= x_Importo %>
		<% x_Importo = tx_Importo %>
		</td>
	</tr>
	<!--tr><td colspan="9"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<%

			' Reset level 2 summary
			Call ResetLevelSummary(2)
		End If
%>
<%
	End If

	' Increment group count
	If ChkLvlBreak(1) Then
		nGrpCount = nGrpCount + 1
	End If
Loop
%>
<% If nTotalGrps > 0 Then %>
	<!-- tr><td colspan="9"><span class="aspreportmaker">&nbsp;<br></span></td></tr -->
	<tr class="ewRptGrandSummary"><td colspan="9">Grand Total (<%= FormatNumber(cnt(0,0),0) %> Detail Records)</td></tr>
	<tr class="ewRptGrandSummary">
		<td colspan="3" class="ewRptGrpAggregate">SUM</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>
		<% tx_Importo = x_Importo %>
		<% x_Importo = grandsmry(6) ' Load SUM %>
<%= x_Importo %>
		<% x_Importo = tx_Importo %>
		</td>
	</tr>
	<!--tr><td colspan="9"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<% End If %>
</table>
<!-- </form> -->
<% If sExport = "" Then %>
<form action="TotaliSpesesmry.asp" name="ewpagerform" id="ewpagerform">
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap>
<%
Dim rsEof, PrevStart, NextStart, LastStart
If nTotalGrps > 0 Then
	rsEof = (nTotalGrps < (nStartGrp + nDisplayGrps))
	PrevStart = nStartGrp - nDisplayGrps
	If PrevStart < 1 Then PrevStart = 1
	NextStart = nStartGrp + nDisplayGrps
	If NextStart > nTotalGrps Then NextStart = nStartGrp
	LastStart = ((nTotalGrps-1)\nDisplayGrps)*nDisplayGrps+1
	%>
	<table border="0" cellspacing="0" cellpadding="0"><tr><td><span class="aspreportmaker">Page&nbsp;</span></td>
<!--first page button-->
	<% If CLng(nStartGrp)=1 Then %>
	<td><img src="rptimages/firstdisab.gif" alt="First" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="TotaliSpesesmry.asp?start=1"><img src="rptimages/first.gif" alt="First" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--previous page button-->
	<% If CLng(PrevStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/prevdisab.gif" alt="Previous" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="TotaliSpesesmry.asp?start=<%=PrevStart%>"><img src="rptimages/prev.gif" alt="Previous" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(nStartGrp-1)\nDisplayGrps+1%>" size="4"></td>
<!--next page button-->
	<% If CLng(NextStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/nextdisab.gif" alt="Next" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="TotaliSpesesmry.asp?start=<%=NextStart%>"><img src="rptimages/next.gif" alt="Next" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--last page button-->
	<% If CLng(LastStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/lastdisab.gif" alt="Last" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="TotaliSpesesmry.asp?start=<%=LastStart%>"><img src="rptimages/last.gif" alt="Last" width="16" height="16" border="0"></a></td>
	<% End If %>
	<td><span class="aspreportmaker">&nbsp;of <%=(nTotalGrps-1)\nDisplayGrps+1%></span></td>
	</tr></table>
	<% If CLng(nStartGrp) > CLng(nTotalGrps) Then nStartGrp = nTotalGrps
	nStopRec = nStartGrp + nDisplayGrps - 1
	nRecCount = nTotalGrps - 1
	If rsEOF Then nRecCount = nTotalGrps
	If nStopRec > nRecCount Then nStopRec = nRecCount %>
	<span class="aspreportmaker">Groups <%= nStartGrp %> to <%= nStopRec %> of <%= nTotalGrps %></span>
<% Else %>
	<span class="aspreportmaker">No records found</span>
<% End If %>
		</td>
<% If nTotalGrps > 0 Then %>
		<td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="right" valign="top" nowrap><span class="aspreportmaker">Groups Per Page&nbsp;
<select name="<%= EW_TABLE_GROUP_PER_PAGE %>" onChange="this.form.submit();" class="aspreportmaker">
<option value="1"<% If nDisplayGrps = 1 Then response.write " selected" %>>1</option>
<option value="2"<% If nDisplayGrps = 2 Then response.write " selected" %>>2</option>
<option value="3"<% If nDisplayGrps = 3 Then response.write " selected" %>>3</option>
<option value="4"<% If nDisplayGrps = 4 Then response.write " selected" %>>4</option>
<option value="5"<% If nDisplayGrps = 5 Then response.write " selected" %>>5</option>
<option value="10"<% If nDisplayGrps = 10 Then response.write " selected" %>>10</option>
<option value="20"<% If nDisplayGrps = 20 Then response.write " selected" %>>20</option>
<option value="40"<% If nDisplayGrps = 40 Then response.write " selected" %>>40</option>
<option value="50"<% If nDisplayGrps = 50 Then response.write " selected" %>>50</option>
<option value="ALL"<% If Session(EW_TABLE_SESSION_GROUP_PER_PAGE) = -1 Then response.write " selected" %>>All Records</option>
</select>
		</span></td>
<% End If %>
	</tr>
</table>
</form>
<% End If %>
</div>
<!-- Summary Report Ends -->
<% If sExport = "" Then %>
	</div><br></td>
	<!-- Center Container - Report (End) -->
	<!-- Right Container (Begin) -->
	<td valign="top"><div id="ewRight" class="aspreportmaker">
	<!-- Right slot -->
	</div></td>
	<!-- Right Container (End) -->
</tr>
<!-- Bottom Container (Begin) -->
<tr><td colspan="3"><div id="ewBottom" class="aspreportmaker">
	<!-- Bottom slot -->
	</div><br></td></tr>
<!-- Bottom Container (End) -->
</table>
<!-- Table Container (End) -->
<% End If %>
<%

' Close recordset and connection
rs.Close
Set rs = Nothing
conn.Close
Set conn = Nothing
%>
<!--#include file="rptinc/footer.asp"-->
<% If sExport = "" Then %>
<!--#include file="rptinc/tm-footer.asp"-->
<% End If %>
<%

' Check level break
Function ChkLvlBreak(lvl)
	Select Case lvl
		Case 1: ChkLvlBreak = _
			(IsNull(x_NomeProgetto) And Not IsNull(ox_NomeProgetto)) Or _
			(Not IsNull(x_NomeProgetto) And IsNull(ox_NomeProgetto)) Or _
			(x_NomeProgetto <> ox_NomeProgetto)
		Case 2: ChkLvlBreak = _
			(IsNull(x_Persona) And Not IsNull(ox_Persona)) Or _
			(Not IsNull(x_Persona) And IsNull(ox_Persona)) Or _
			(x_Persona <> ox_Persona) Or ChkLvlBreak(1) ' Recurse upper level
		Case 3: ChkLvlBreak = _
			(IsNull(x_ExpenseCode) And Not IsNull(ox_ExpenseCode)) Or _
			(Not IsNull(x_ExpenseCode) And IsNull(ox_ExpenseCode)) Or _
			(x_ExpenseCode <> ox_ExpenseCode) Or ChkLvlBreak(2) ' Recurse upper level
	End Select
End Function

' Accummulate summary
Sub AccumulateSummary()
	Dim valwrk
	For ix = 0 to UBound(smry,1)
		For iy = 1 to UBound(smry,2)
			cnt(ix,iy) = cnt(ix,iy) + 1
			If col(iy) Then
				valwrk = val(iy)
				If IsNull(valwrk) Or Not IsNumeric(valwrk) Then

					' skip
				Else
					smry(ix,iy) = smry(ix,iy) + valwrk
					If IsNull(mn(ix,iy)) Then
						mn(ix,iy) = valwrk
						mx(ix,iy) = valwrk
					Else
						If mn(ix,iy) > valwrk Then mn(ix,iy) = valwrk
						If mx(ix,iy) < valwrk Then mx(ix,iy) = valwrk
					End If
				End If
			End If
		Next
	Next
	For ix = 1 to UBound(smry,1)
		cnt(ix,0) = cnt(ix,0) + 1
	Next
End Sub

' Reset level summary
Sub ResetLevelSummary(lvl)

	' Clear summary values
	For ix = lvl to UBound(smry,1)
		For iy = 1 to UBound(smry,2)
			cnt(ix,iy) = 0
			If col(iy) Then
				smry(ix,iy) = 0
				mn(ix,iy) = Null
				mx(ix,iy) = Null
			End If
		Next
	Next
	For ix = lvl to UBound(smry,1)
		cnt(ix,0) = 0
	Next

	' Clear grand summary
	If lvl = 0 Then
		For iy = 1 to UBound(grandsmry)
			If col(iy) Then
				grandsmry(iy) = 0
				grandmn(iy) = Null
				grandmx(iy) = Null
			End If
		Next
	End If

	' Clear old values
	If lvl <= 1 Then ox_NomeProgetto = ""
	If lvl <= 2 Then ox_Persona = ""
	If lvl <= 3 Then ox_ExpenseCode = ""

	' Reset record count
	nRecCount = 0
End Sub

' Accummulate grand summary
Sub AccumulateGrandSummary()
	Dim valwrk
	cnt(0,0) = cnt(0,0) + 1
	For iy = 1 to UBound(grandsmry)
		If col(iy) Then
			valwrk = val(iy)
			If IsNull(valwrk) Or Not IsNumeric(valwrk) Then

				' skip
			Else
				grandsmry(iy) = grandsmry(iy) + valwrk
				If IsNull(grandmn(iy)) Then
					grandmn(iy) = valwrk
					grandmx(iy) = valwrk
				Else
					If grandmn(iy) > valwrk Then grandmn(iy) = valwrk
					If grandmx(iy) < valwrk Then grandmx(iy) = valwrk
				End If
			End If
		End If
	Next
End Sub

' Get row values
Sub GetRow(rs, opt)
	If rs.Eof Then Exit Sub
	If opt = 1 Then ' Get first row
		rs.MoveFirst
	Else ' Get next row
		rs.MoveNext
	End If
	Do While Not rs.Eof
		If ValidRow(rs) Then
			x_NomeProgetto = rs("NomeProgetto")
			x_Persona = rs("Persona")
			x_ExpenseCode = rs("ExpenseCode")
			x_DescSpesa = rs("DescSpesa")
			val(1) = x_DescSpesa
			x_KM = rs("KM")
			val(2) = x_KM
			x_CreditCardPayed = rs("CreditCardPayed")
			val(3) = x_CreditCardPayed
			x_InvoiceFlag = rs("InvoiceFlag")
			val(4) = x_InvoiceFlag
			x_Date = rs("Date")
			val(5) = x_Date
			x_Importo = rs("Importo")
			val(6) = x_Importo
			Exit Do
		Else
			rs.MoveNext
		End If
	Loop
	If rs.Eof Then
		x_NomeProgetto = ""
		x_Persona = ""
		x_ExpenseCode = ""
		x_DescSpesa = ""
		x_KM = ""
		x_CreditCardPayed = ""
		x_InvoiceFlag = ""
		x_Date = ""
		x_Importo = ""
	End If
End Sub

'-------------------------------------------------------------------------------
' Function SetUpStartGroup
' - Set up Starting Record parameters based on Pager Navigation
' - Variables setup: nStartGrp

Sub SetUpStartGroup()
	Dim nPageNo

	' Check for a START parameter
	If Request.QueryString(EW_TABLE_START_GROUP).Count > 0 Then
		nStartGrp = Request.QueryString(EW_TABLE_START_GROUP)
		Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
	ElseIf Request.QueryString("pageno").Count > 0 Then
		nPageNo = Request.QueryString("pageno")
		If IsNumeric(nPageNo) Then
			nStartGrp = (nPageNo-1)*nDisplayGrps+1
			If nStartGrp <= 0 Then
				nStartGrp = 1
			ElseIf nStartGrp >= ((nTotalGrps-1)\nDisplayGrps)*nDisplayGrps+1 Then
				nStartGrp = ((nTotalGrps-1)\nDisplayGrps)*nDisplayGrps+1
			End If
			Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
		Else
			nStartGrp = Session(EW_TABLE_SESSION_START_GROUP)
			If Not IsNumeric(nStartGrp) Or nStartGrp = "" Then
				nStartGrp = 1 ' Reset start record counter
				Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
			End If
		End If
	Else
		nStartGrp = Session(EW_TABLE_SESSION_START_GROUP)
		If Not IsNumeric(nStartGrp) Or nStartGrp = "" Then
			nStartGrp = 1 'Reset start record counter
			Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
		End If
	End If
End Sub

'-------------------------------------------------------------------------------
' Function ResetCmd
' - RESET: reset search parameters

Sub ResetCmd()
	Dim sCmd

	' Skip if post back
	If Request.Form.Count > 0 Then Exit Sub

	' Get Reset Cmd
	If Request.QueryString("cmd").Count > 0 Then
		sCmd = Request.QueryString("cmd")
		If LCase(sCmd) = "reset" Then
			Session("all_TotaliSpesePersona") = True
			Session("sel_TotaliSpesePersona") = ""
			Session("rf_TotaliSpesePersona") = ""
			Session("rt_TotaliSpesePersona") = ""
			Session("all_TotaliSpeseExpenseCode") = True
			Session("sel_TotaliSpeseExpenseCode") = ""
			Session("rf_TotaliSpeseExpenseCode") = ""
			Session("rt_TotaliSpeseExpenseCode") = ""
			Session("all_TotaliSpeseCreditCardPayed") = True
			Session("sel_TotaliSpeseCreditCardPayed") = ""
			Session("rf_TotaliSpeseCreditCardPayed") = ""
			Session("rt_TotaliSpeseCreditCardPayed") = ""
			Session("all_TotaliSpeseInvoiceFlag") = True
			Session("sel_TotaliSpeseInvoiceFlag") = ""
			Session("rf_TotaliSpeseInvoiceFlag") = ""
			Session("rt_TotaliSpeseInvoiceFlag") = ""
			Session("all_TotaliSpeseDate") = True
			Session("sel_TotaliSpeseDate") = ""
			Session("rf_TotaliSpeseDate") = ""
			Session("rt_TotaliSpeseDate") = ""
			Call ResetPager()
		End If
	End If
End Sub
Sub ResetPager()

	' Reset Start Position (Reset Command)
	nStartGrp = 1
	Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
End Sub

' Set up selection
Sub SetupSelection()
	Dim sName, values, bSelectedAll, arValues
	Dim i

	' Process post back form
	sName = Request.Form("popup") ' Get popup form name
	If sName <> "" Then
		values = Request.Form("sel_" & sName)
		values = Replace(Trim(values), ", ", ",") ' Remove extra space
		If values <> "" Then
			arValues = Split(values, ",")
			If Trim(arValues(0)) = "" Then ' Select all
				Session("all_" & sName) = True

				' Remove first entry
				For i = 0 to UBound(arValues)-1
					arValues(i) = arValues(i+1)
				Next
				Redim Preserve arValues(UBound(arValues)-1)
			Else
				Session("all_" & sName) = False
			End If
			Session("sel_" & sName) = arValues
			Session("rf_" & sName) = Request.Form("from_" & sName)
			Session("rt_" & sName) = Request.Form("to_" & sName)
			Call ResetPager()
		End If
	End If

	' Load selection criteria to array
	' Get Persona selected values

	bSelectedAll = ew_IsSelectedAll("TotaliSpesePersona")
	If Not bSelectedAll Then
		sel_Persona = Session("sel_TotaliSpesePersona")
		rf_Persona = Session("rf_TotaliSpesePersona")
		rt_Persona = Session("rt_TotaliSpesePersona")
	End If

	' Get Expense Code selected values
	bSelectedAll = ew_IsSelectedAll("TotaliSpeseExpenseCode")
	If Not bSelectedAll Then
		sel_ExpenseCode = Session("sel_TotaliSpeseExpenseCode")
		rf_ExpenseCode = Session("rf_TotaliSpeseExpenseCode")
		rt_ExpenseCode = Session("rt_TotaliSpeseExpenseCode")
	End If

	' Get CC selected values
	bSelectedAll = ew_IsSelectedAll("TotaliSpeseCreditCardPayed")
	If Not bSelectedAll Then
		sel_CreditCardPayed = Session("sel_TotaliSpeseCreditCardPayed")
		rf_CreditCardPayed = Session("rf_TotaliSpeseCreditCardPayed")
		rt_CreditCardPayed = Session("rt_TotaliSpeseCreditCardPayed")
	End If

	' Get Fatt selected values
	bSelectedAll = ew_IsSelectedAll("TotaliSpeseInvoiceFlag")
	If Not bSelectedAll Then
		sel_InvoiceFlag = Session("sel_TotaliSpeseInvoiceFlag")
		rf_InvoiceFlag = Session("rf_TotaliSpeseInvoiceFlag")
		rt_InvoiceFlag = Session("rt_TotaliSpeseInvoiceFlag")
	End If

	' Get Date selected values
	bSelectedAll = ew_IsSelectedAll("TotaliSpeseDate")
	If Not bSelectedAll Then
		sel_Date = Session("sel_TotaliSpeseDate")
		rf_Date = Session("rf_TotaliSpeseDate")
		rt_Date = Session("rt_TotaliSpeseDate")
	End If
End Sub

' Initialize group data - total number of groups + grouping field arrays
Sub InitReportData(rs)
	Dim sSql, bNullValue, bEmptyValue
	Dim bValidRow, bNewGroup
	Dim rswrk, grpcnt, grpvalue

	' Build distinct values for Persona
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_PERSONA_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_PERSONA_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_Persona = rswrk("Persona")
		If IsNull(x_Persona) Then
			bNullValue = True
		ElseIf x_Persona = "" Then
			bEmptyValue = True
		Else
			gx_Persona = x_Persona
			dgx_Persona = x_Persona
			Call ew_SetupDistinctValues(val_Persona, gx_Persona, dgx_Persona, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_Persona, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_Persona, "##null", EW_NULL_LABEL, False)

	' Build distinct values for Expense Code
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_EXPENSECODE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_EXPENSECODE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_ExpenseCode = rswrk("ExpenseCode")
		If IsNull(x_ExpenseCode) Then
			bNullValue = True
		ElseIf x_ExpenseCode = "" Then
			bEmptyValue = True
		Else
			gx_ExpenseCode = x_ExpenseCode
			dgx_ExpenseCode = x_ExpenseCode
			Call ew_SetupDistinctValues(val_ExpenseCode, gx_ExpenseCode, dgx_ExpenseCode, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_ExpenseCode, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_ExpenseCode, "##null", EW_NULL_LABEL, False)

	' Build distinct values for Expense Code
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_CREDITCARDPAYED_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_CREDITCARDPAYED_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_CreditCardPayed = rswrk("CreditCardPayed")
		If IsNull(x_CreditCardPayed) Then
			bNullValue = True
		ElseIf x_CreditCardPayed = "" Then
			bEmptyValue = True
		Else
			tx_CreditCardPayed = x_CreditCardPayed
			Call ew_SetupDistinctValues(val_CreditCardPayed, x_CreditCardPayed, tx_CreditCardPayed, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_CreditCardPayed, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_CreditCardPayed, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_INVOICEFLAG_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_INVOICEFLAG_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_InvoiceFlag = rswrk("InvoiceFlag")
		If IsNull(x_InvoiceFlag) Then
			bNullValue = True
		ElseIf x_InvoiceFlag = "" Then
			bEmptyValue = True
		Else
			tx_InvoiceFlag = x_InvoiceFlag
			Call ew_SetupDistinctValues(val_InvoiceFlag, x_InvoiceFlag, tx_InvoiceFlag, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_InvoiceFlag, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_InvoiceFlag, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_DATE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_DATE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_Date = rswrk("Date")
		If IsNull(x_Date) Then
			bNullValue = True
		ElseIf x_Date = "" Then
			bEmptyValue = True
		Else
			tx_Date = x_Date
			Call ew_SetupDistinctValues(val_Date, x_Date, tx_Date, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_Date, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_Date, "##null", EW_NULL_LABEL, False)

	' Initialize group count
	grpcnt = 0

	' Clone recordset
	Set rswrk = rs.Clone(1)
	Do While Not rswrk.Eof
		bValidRow = ValidRow(rswrk)
		If Not bValidRow Then bFilterApplied = True

		' Update group count
		If bValidRow Then
			x_NomeProgetto = rswrk("NomeProgetto")
			gx_NomeProgetto = ew_GroupValue(x_NomeProgetto, ftx_NomeProgetto, gbx_NomeProgetto, gix_NomeProgetto)
			bNewGroup = (grpcnt = 0) Or _
				(IsNull(grpvalue) And Not IsNull(x_NomeProgetto)) Or _
				(Not IsNull(grpvalue) And IsNull(x_NomeProgetto)) Or _
				(grpvalue <> gx_NomeProgetto)
			If bNewGroup Then
				grpvalue = gx_NomeProgetto
				grpcnt = grpcnt + 1
			End If
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing

	' Set up total number of groups
	nTotalGrps = grpcnt
End Sub

' Check if row is valid
Function ValidRow(rs)
	ValidRow = True
	If ValidRow Then ValidRow = ew_SelectedValue(sel_Persona, rs("Persona"), ftx_Persona, af_Persona)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_ExpenseCode, rs("ExpenseCode"), ftx_ExpenseCode, af_ExpenseCode)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_CreditCardPayed, rs("CreditCardPayed"), ftx_CreditCardPayed, af_CreditCardPayed)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_InvoiceFlag, rs("InvoiceFlag"), ftx_InvoiceFlag, af_InvoiceFlag)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_Date, rs("Date"), ftx_Date, af_Date)
End Function
%>
<%

'-------------------------------------------------------------------------------
' Function SetUpDisplayGrps
' - Set up Number of Groups displayed per page based on Form element GrpPerPage
' - Variables setup: nDisplayGrps

Sub SetUpDisplayGrps()
	Dim sWrk
	sWrk = Request.QueryString(EW_TABLE_GROUP_PER_PAGE)
	If sWrk <> "" Then
		If IsNumeric(sWrk) Then
			nDisplayGrps = CInt(sWrk)
		Else
			If UCase(sWrk) = "ALL" Then ' Display All Records
				nDisplayGrps = -1
			Else
				nDisplayGrps = 40 ' Non-numeric, Load Default
			End If
		End If
		Session(EW_TABLE_SESSION_GROUP_PER_PAGE) = nDisplayGrps ' Save to Session

		' Reset Start Position (Reset Command)
		nStartGrp = 1
		Session(EW_TABLE_SESSION_START_GROUP) = nStartGrp
	Else
		If Session(EW_TABLE_SESSION_GROUP_PER_PAGE) <> "" Then
			nDisplayGrps = Session(EW_TABLE_SESSION_GROUP_PER_PAGE) ' Restore from Session
		Else
			nDisplayGrps = 40 ' Load Default
		End If
	End If
End Sub
%>
