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

' ASP Report Maker 1.0 - Table level configuration (OreMese)
' Table Level Constants

Const EW_TABLE_VAR = "OreMese"
Const EW_TABLE_GROUP_PER_PAGE = "grpperpage"
Const EW_TABLE_SESSION_GROUP_PER_PAGE = "OreMese_grpperpage"
Const EW_TABLE_START_GROUP = "start"
Const EW_TABLE_SESSION_START_GROUP = "OreMese_start"
Const EW_TABLE_SESSION_SEARCH = "OreMese_search"
Const EW_TABLE_CHILD_USER_ID = "childuserid"
Const EW_TABLE_SESSION_CHILD_USER_ID = "OreMese_childuserid"

' Table Level SQL
Const EW_TABLE_SQL_FROM = "[v_ore]"
Dim EW_TABLE_SQL_SELECT
EW_TABLE_SQL_SELECT = "SELECT * FROM " & EW_TABLE_SQL_FROM
Dim EW_TABLE_SQL_WHERE
EW_TABLE_SQL_WHERE = session("whereclause")
Const EW_TABLE_SQL_GROUPBY = ""
Const EW_TABLE_SQL_HAVING = ""
Const EW_TABLE_SQL_ORDERBY = "[AnnoMese] ASC, [NomePersona] ASC"
Const EW_TABLE_SQL_USERID_FILTER = ""
Dim af_AnnoMese ' Advanced filter for AnnoMese
Dim af_NomeProgetto ' Advanced filter for NomeProgetto
Dim af_NomePersona ' Advanced filter for NomePersona
Dim af_Giorni ' Advanced filter for Giorni
Dim af_ProjectCode ' Advanced filter for ProjectCode
Dim af_Date ' Advanced filter for Date
Dim af_Hours ' Advanced filter for Hours
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
Dim x_AnnoMese, ox_AnnoMese, gx_AnnoMese, dgx_AnnoMese, tx_AnnoMese, ftx_AnnoMese, gfx_AnnoMese, gbx_AnnoMese, gix_AnnoMese
x_AnnoMese = Null: ox_AnnoMese = Null: gx_AnnoMese = Null: dgx_AnnoMese = Null: tx_AnnoMese = Null
ftx_AnnoMese = 200: gfx_AnnoMese = ftx_AnnoMese: gbx_AnnoMese = "": gix_AnnoMese = "0"
Dim rf_AnnoMese, rt_AnnoMese
Dim x_NomePersona, ox_NomePersona, gx_NomePersona, dgx_NomePersona, tx_NomePersona, ftx_NomePersona, gfx_NomePersona, gbx_NomePersona, gix_NomePersona
x_NomePersona = Null: ox_NomePersona = Null: gx_NomePersona = Null: dgx_NomePersona = Null: tx_NomePersona = Null
ftx_NomePersona = 202: gfx_NomePersona = ftx_NomePersona: gbx_NomePersona = "": gix_NomePersona = "0"
Dim rf_NomePersona, rt_NomePersona

' Detail variables
Dim x_NomeProgetto, ox_NomeProgetto, tx_NomeProgetto, ftx_NomeProgetto
x_NomeProgetto = Null: ox_NomeProgetto = Null: tx_NomeProgetto = Null: ftx_NomeProgetto = 202
Dim rf_NomeProgetto, rt_NomeProgetto
Dim x_Giorni, ox_Giorni, tx_Giorni, ftx_Giorni
x_Giorni = Null: ox_Giorni = Null: tx_Giorni = Null: ftx_Giorni = 6
Dim rf_Giorni, rt_Giorni
Dim x_ProjectCode, ox_ProjectCode, tx_ProjectCode, ftx_ProjectCode
x_ProjectCode = Null: ox_ProjectCode = Null: tx_ProjectCode = Null: ftx_ProjectCode = 202
Dim rf_ProjectCode, rt_ProjectCode
Dim x_Date, ox_Date, tx_Date, ftx_Date
x_Date = Null: ox_Date = Null: tx_Date = Null: ftx_Date = 135
Dim rf_Date, rt_Date
Dim x_Hours, ox_Hours, tx_Hours, ftx_Hours
x_Hours = Null: ox_Hours = Null: tx_Hours = Null: ftx_Hours = 6
Dim rf_Hours, rt_Hours
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

Dim col(5), val(5), cnt(2,5)
Dim smry(2,5), mn(2,5), mx(2,5)
Dim grandsmry(5), grandmn(5), grandmx(5)

' Set up if accumulation required
col(1) = False
col(2) = False
col(3) = False
col(4) = False
col(5) = False

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
' Detail distinct & selection values

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
//-->
</script>
<% End If %>
<% If sExport = "" Then %>
<!-- Table Container (Begin) -->
<table id="ewContainer" cellspacing="0" cellpadding="0" border="0">
<!-- Top Container (Begin) -->
<tr><td colspan="3" class="ewPadding"><div id="ewTop" class="aspreportmaker">
<!-- top slot -->
<a name="top"></a>
<% End If %>
Ore Mese
<% If sExport = "" Then %>
&nbsp;&nbsp;<a href="OreMesesmry.asp?export=excel">Export to Excel</a>
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
	If bShowFirstHeader Or (CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) And ChkLvlBreak(2)) Then
%>
	<tr>
		<td valign="bottom" class="ewRptGrpHeader1">
		<% If bShowFirstHeader Or ChkLvlBreak(1) Then %>
		Anno Mese
		<% End If %>
		</td>
		<td valign="bottom" class="ewRptGrpHeader2">
		<% If bShowFirstHeader Or ChkLvlBreak(2) Then %>
		Nome Persona
		<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Nome Progetto
		</td>
		<td valign="bottom" class="ewTableHeader">
		giorni
		</td>
		<td valign="bottom" class="ewTableHeader">
		Project Code
		</td>
		<td valign="bottom" class="ewTableHeader">
		Date
		</td>
		<td valign="bottom" class="ewTableHeader">
		Hours
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
		dgx_AnnoMese = x_AnnoMese
		If (IsNull(x_AnnoMese) And IsNull(ox_AnnoMese)) Or _
			((x_AnnoMese <> "" And ox_AnnoMese = dgx_AnnoMese) And _
			Not ChkLvlBreak(1)) Then
			dgx_AnnoMese = ""
		ElseIf IsNull(x_AnnoMese) Then
			dgx_AnnoMese = EW_NULL_LABEL
		ElseIf x_AnnoMese = "" Then
			dgx_AnnoMese = EW_EMPTY_LABEL
		End If
		dgx_NomePersona = x_NomePersona
		If (IsNull(x_NomePersona) And IsNull(ox_NomePersona)) Or _
			((x_NomePersona <> "" And ox_NomePersona = dgx_NomePersona) And _
			Not ChkLvlBreak(2)) Then
			dgx_NomePersona = ""
		ElseIf IsNull(x_NomePersona) Then
			dgx_NomePersona = EW_NULL_LABEL
		ElseIf x_NomePersona = "" Then
			dgx_NomePersona = EW_EMPTY_LABEL
		End If
%>
<%

		' Accumulate page summary
		Call AccumulateSummary()
	End If

	' Accumulate grand summary
	Call AccumulateGrandSummary()

	' Save old group values
	ox_AnnoMese = x_AnnoMese
	ox_NomePersona = x_NomePersona

	' Get next record
	Call GetRow(rs, 2)

	' Show Footers
	If CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) Then
%>
<%
		If ChkLvlBreak(2) And cnt(2,0) > 0 Then
%>
	<tr>
		<td class="ewRptGrpField1"></td>
		<td colspan="6" class="ewRptGrpSummary2">Summary for Nome Persona: <% tx_Hours = x_NomePersona: x_NomePersona = ox_NomePersona %>
<%= x_NomePersona %>
<% x_NomePersona = tx_Hours %> (<%= FormatNumber(cnt(2,0),0) %> Detail Records)</td></tr>
	<!--tr><td colspan="7"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<%

			' Reset level 2 summary
			Call ResetLevelSummary(2)
		End If
%>
<%
		If ChkLvlBreak(1) And cnt(1,0) > 0 Then
%>
	<tr>
		<td colspan="7" class="ewRptGrpSummary1">Summary for Anno Mese: <% tx_Hours = x_AnnoMese: x_AnnoMese = ox_AnnoMese %>
<%= x_AnnoMese %>
<% x_AnnoMese = tx_Hours %> (<%= FormatNumber(cnt(1,0),0) %> Detail Records)</td></tr>
	<!--tr><td colspan="7"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<%

			' Reset level 1 summary
			Call ResetLevelSummary(1)
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
	<!-- tr><td colspan="7"><span class="aspreportmaker">&nbsp;<br></span></td></tr -->
	<tr class="ewRptGrandSummary"><td colspan="7">Grand Total (<%= FormatNumber(cnt(0,0),0) %> Detail Records)</td></tr>
	<!--tr><td colspan="7"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<% End If %>
</table>
<!-- </form> -->
<% If sExport = "" Then %>
<form action="OreMesesmry.asp" name="ewpagerform" id="ewpagerform">
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
	<td><a href="OreMesesmry.asp?start=1"><img src="rptimages/first.gif" alt="First" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--previous page button-->
	<% If CLng(PrevStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/prevdisab.gif" alt="Previous" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="OreMesesmry.asp?start=<%=PrevStart%>"><img src="rptimages/prev.gif" alt="Previous" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(nStartGrp-1)\nDisplayGrps+1%>" size="4"></td>
<!--next page button-->
	<% If CLng(NextStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/nextdisab.gif" alt="Next" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="OreMesesmry.asp?start=<%=NextStart%>"><img src="rptimages/next.gif" alt="Next" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--last page button-->
	<% If CLng(LastStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/lastdisab.gif" alt="Last" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="OreMesesmry.asp?start=<%=LastStart%>"><img src="rptimages/last.gif" alt="Last" width="16" height="16" border="0"></a></td>
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
			(IsNull(x_AnnoMese) And Not IsNull(ox_AnnoMese)) Or _
			(Not IsNull(x_AnnoMese) And IsNull(ox_AnnoMese)) Or _
			(x_AnnoMese <> ox_AnnoMese)
		Case 2: ChkLvlBreak = _
			(IsNull(x_NomePersona) And Not IsNull(ox_NomePersona)) Or _
			(Not IsNull(x_NomePersona) And IsNull(ox_NomePersona)) Or _
			(x_NomePersona <> ox_NomePersona) Or ChkLvlBreak(1) ' Recurse upper level
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
	If lvl <= 1 Then ox_AnnoMese = ""
	If lvl <= 2 Then ox_NomePersona = ""

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
			x_AnnoMese = rs("AnnoMese")
			x_NomePersona = rs("NomePersona")
			x_NomeProgetto = rs("NomeProgetto")
			val(1) = x_NomeProgetto
			x_Giorni = rs("Giorni")
			val(2) = x_Giorni
			x_ProjectCode = rs("ProjectCode")
			val(3) = x_ProjectCode
			x_Date = rs("Date")
			val(4) = x_Date
			x_Hours = rs("Hours")
			val(5) = x_Hours
			Exit Do
		Else
			rs.MoveNext
		End If
	Loop
	If rs.Eof Then
		x_AnnoMese = ""
		x_NomePersona = ""
		x_NomeProgetto = ""
		x_Giorni = ""
		x_ProjectCode = ""
		x_Date = ""
		x_Hours = ""
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
End Sub

' Initialize group data - total number of groups + grouping field arrays
Sub InitReportData(rs)
	Dim sSql, bNullValue, bEmptyValue
	Dim bValidRow, bNewGroup
	Dim rswrk, grpcnt, grpvalue

	' Initialize group count
	grpcnt = 0

	' Clone recordset
	Set rswrk = rs.Clone(1)
	Do While Not rswrk.Eof
		bValidRow = ValidRow(rswrk)
		If Not bValidRow Then bFilterApplied = True

		' Update group count
		If bValidRow Then
			x_AnnoMese = rswrk("AnnoMese")
			gx_AnnoMese = ew_GroupValue(x_AnnoMese, ftx_AnnoMese, gbx_AnnoMese, gix_AnnoMese)
			bNewGroup = (grpcnt = 0) Or _
				(IsNull(grpvalue) And Not IsNull(x_AnnoMese)) Or _
				(Not IsNull(grpvalue) And IsNull(x_AnnoMese)) Or _
				(grpvalue <> gx_AnnoMese)
			If bNewGroup Then
				grpvalue = gx_AnnoMese
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
