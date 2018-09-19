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

' ASP Report Maker 1.0 - Table level configuration (CrossGiorniMese)
' Table Level Constants

Const EW_TABLE_VAR = "CrossGiorniMese"
Const EW_TABLE_GROUP_PER_PAGE = "grpperpage"
Const EW_TABLE_SESSION_GROUP_PER_PAGE = "CrossGiorniMese_grpperpage"
Const EW_TABLE_START_GROUP = "start"
Const EW_TABLE_SESSION_START_GROUP = "CrossGiorniMese_start"
Const EW_TABLE_SESSION_SEARCH = "CrossGiorniMese_search"
Const EW_TABLE_CHILD_USER_ID = "childuserid"
Const EW_TABLE_SESSION_CHILD_USER_ID = "CrossGiorniMese_childuserid"

' Table Level SQL
Const EW_TABLE_REPORT_SUMMARY_TYPE = "SUM"
Const EW_TABLE_REPORT_COLUMN_CAPTIONS = ""
Const EW_TABLE_REPORT_COLUMN_NAMES = ""
Const EW_TABLE_SQL_TRANSFORM = ""
Const EW_TABLE_SQL_FROM = "[v_ore]"
Dim EW_TABLE_SQL_SELECT
EW_TABLE_SQL_SELECT = "SELECT [NomeProgetto], [NomePersona] <DistinctColumnFields> FROM " & EW_TABLE_SQL_FROM
Dim EW_TABLE_SQL_WHERE
EW_TABLE_SQL_WHERE =  session("whereclause")
Const EW_TABLE_SQL_GROUPBY = "[NomeProgetto], [NomePersona]"
Const EW_TABLE_SQL_ORDERBY = "[NomeProgetto] ASC, [NomePersona] ASC"
Const EW_TABLE_SQL_PIVOT = ""
Dim EW_TABLE_DISTINCT_SQL_SELECT, EW_TABLE_DISTINCT_SQL_WHERE, EW_TABLE_DISTINCT_SQL_ORDERBY
EW_TABLE_DISTINCT_SQL_SELECT = "SELECT DISTINCT [AnnoMese] FROM [v_ore]"
EW_TABLE_DISTINCT_SQL_WHERE =  session("whereclause")
EW_TABLE_DISTINCT_SQL_ORDERBY = "[AnnoMese]"
Const EW_TABLE_SQL_USERID_FILTER = ""
Dim af_NomePersona ' Advanced filter for NomePersona
Dim af_NomeProgetto ' Advanced filter for NomeProgetto
Dim af_DescTipoProgetto ' Advanced filter for DescTipoProgetto
Dim af_HourTypeCode ' Advanced filter for HourTypeCode
Dim af_NomeSocieta ' Advanced filter for NomeSocieta
Dim af_Persons_id ' Advanced filter for Persons_id
Dim af_CodiceCliente ' Advanced filter for CodiceCliente
Dim af_NomeCliente ' Advanced filter for NomeCliente
Dim af_Company_id ' Advanced filter for Company_id
Dim af_NomeManager ' Advanced filter for NomeManager
Dim af_IdManager ' Advanced filter for IdManager
Dim af_flagstorno ' Advanced filter for flagstorno
Dim af_AnnoMese ' Advanced filter for AnnoMese
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

' Static group variables
Dim x_NomeProgetto, ox_NomeProgetto, tx_NomeProgetto, gx_NomeProgetto, ftx_NomeProgetto
x_NomeProgetto = Null: ox_NomeProgetto = Null: tx_NomeProgetto = Null: gx_NomeProgetto = Null: ftx_NomeProgetto = 202
Dim rf_NomeProgetto, rt_NomeProgetto
Dim x_NomePersona, ox_NomePersona, tx_NomePersona, gx_NomePersona, ftx_NomePersona
x_NomePersona = Null: ox_NomePersona = Null: tx_NomePersona = Null: gx_NomePersona = Null: ftx_NomePersona = 202
Dim rf_NomePersona, rt_NomePersona

' Column variables
Dim ftx_AnnoMese
ftx_AnnoMese = 200
Dim rf_AnnoMese, rt_AnnoMese

' Dynamic column variables
Dim ix, iy, ncol, ncolspan, rowsmry, rowval, rowcnt
Dim col, val, oval, cnt, smry, grandsmry
%>
<%
Dim conn

' Open connection to the database
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open EW_CONNECTION_STRING

' Filter
Dim sFilter: sFilter = ""
Dim bFilterApplied: bFilterApplied = False

' Reset
Call ResetCmd()

' Set up groups per page dynamically
SetUpDisplayGrps()

' Popup selected values
Call SetupSelection()

' Load columns to arrray
Call GetColumns()

' Default Filter, Sort
Dim defaultFilter: defaultFilter = "" ' Default filter string
Dim defaultSort: defaultSort = "" ' default sort string
If defaultFilter <> "" Then
	If sFilter <> "" Then sFilter = sFilter & " AND "
	sFilter = sFilter & defaultFilter
End If

' Build sql
Dim sSql
sSql = ew_BuildReportSql(EW_TABLE_SQL_TRANSFORM, EW_TABLE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, "", EW_TABLE_SQL_ORDERBY, EW_TABLE_SQL_PIVOT, sFilter, sSort)

' Response.Write sSql & "<br>" ' uncomment to show sql
' Load recordset

Dim rs
Set rs = ew_LoadRs(sSql)

' Set up total group count and distinct values
Call InitReportData(rs)
If nDisplayGrps <= 0 Then ' Display All Records
	nDisplayGrps = nTotalGrps
End If
nStartGrp = 1
SetUpStartGroup() ' Set Up Start Group Position
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
<!-- Table container (begin) -->
<table id="ewContainer" cellspacing="0" cellpadding="0" border="0">
<!-- Top container (begin) -->
<tr><td colspan="3" class="ewPadding"><div id="ewTop" class="aspreportmaker">
<!-- top slot -->
<a name="top"></a>
<% End If %>
Cross Ore Mese
<% If sExport = "" Then %>
&nbsp;&nbsp;<a href="CrossGiorniMesectb.asp?export=excel">Export to Excel</a>
<% End If %>
<br><br>
<% If sExport = "" Then %>
</div></td></tr>
<!-- Top container (end) -->
<tr>
	<!-- Left container (begin) -->
	<td valign="top"><div id="ewLeft" class="aspreportmaker">
	<!-- left slot -->
	</div></td>
	<!-- Left container (end) -->
	<!-- Center container (report) (begin) -->
	<td valign="top" class="ewPadding"><div id="ewCenter" class="aspreportmaker">
	<!-- center slot -->
<% End If %>
<!-- crosstab report starts -->
<div id="report_crosstab">
<!-- Report grid (begin) -->
<table id="ewReport" class="ewTable">
	<!-- Table header -->
	<tr class="ewTableRow">
		<td colspan="2" nowrap><div class="aspreportmaker">giorni (SUM)&nbsp;</div></td>
		<td class="ewRptColHeader" colspan="<%=ncolspan%>" nowrap>
			Anno Mese
		</td>
	</tr>
	<tr>
		<td class="ewRptGrpHeader1">
			Nome Progetto
		</td>
		<td class="ewRptGrpHeader2">
			Nome Persona
		</td>
<!-- Dynamic columns begin -->
	<%
	For iy = 1 to UBound(val)
		If col(2,iy) Then
			x_AnnoMese = col(1,iy)
	%>
		<td class="ewTableHeader" valign="top">
<%= x_AnnoMese %>
</td>
	<%
		End If
	Next
	%>
<!-- Dynamic columns end -->
	</tr>
<% If nTotalGrps > 0 Then %>
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

' navigate
Dim grpvalue: grpvalue = ""
nRecCount = 0

' Get first row
If Not rs.Eof Then
	Call GetRow(rs, 1): nGrpCount = 1
End If
Do While (Not rs.Eof)

	' Process groups
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
		gx_NomeProgetto = x_NomeProgetto
		If (x_NomeProgetto <> "" And ox_NomeProgetto = x_NomeProgetto) And _
			Not ChkLvlBreak(1) Then
			gx_NomeProgetto = ""
		ElseIf IsNull(x_NomeProgetto) Then
			gx_NomeProgetto = EW_NULL_LABEL
		ElseIf x_NomeProgetto = "" Then
			gx_NomeProgetto = EW_EMPTY_LABEL
		End If
		gx_NomePersona = x_NomePersona
		If (x_NomePersona <> "" And ox_NomePersona = x_NomePersona) And _
			Not ChkLvlBreak(2) Then
			gx_NomePersona = ""
		ElseIf IsNull(x_NomePersona) Then
			gx_NomePersona = EW_NULL_LABEL
		ElseIf x_NomePersona = "" Then
			gx_NomePersona = EW_EMPTY_LABEL
		End If
%>
	<!-- Data -->
	<tr<%=sItemRowClass%>>
		<!-- Nome Progetto -->
		<td class="ewRptGrpField1"><% tx_NomeProgetto = x_NomeProgetto: x_NomeProgetto = gx_NomeProgetto %>
<%= x_NomeProgetto %>
<% x_NomeProgetto = tx_NomeProgetto %></td>
		<!-- Nome Persona -->
		<td class="ewRptGrpField2"><% tx_NomePersona = x_NomePersona: x_NomePersona = gx_NomePersona %>
<%= x_NomePersona %>
<% x_NomePersona = tx_NomePersona %></td>
<!-- Dynamic columns begin -->
	<%
	rowsmry = 0
	For iy = 1 to UBound(val)
		If col(2,iy) Then
			rowval = val(iy)
			rowsmry = ew_SummaryValue(rowsmry, rowval, EW_TABLE_REPORT_SUMMARY_TYPE)
			x_Giorni = val(iy)
	%>
		<!-- <%=col(1,iy)%> -->
		<td>
<%= ew_FormatNumber(x_Giorni,2,-2,-2,-2) %>
</td>
	<%
		End If
	Next
	%>
<!-- Dynamic columns end -->
	</tr>
<%

		' Accumulate page summary
		Call AccumulateSummary()
	End If

	' Accumulate grand summary
	Call AccumulateGrandSummary()

	' Save old group values
	ox_NomeProgetto = x_NomeProgetto
	ox_NomePersona = x_NomePersona

	' Get next record
	Call GetRow(rs, 2)
	If CLng(nGrpCount) >= CLng(nStartGrp) And (nGrpCount <= nStopGrp) Then
%>
<%
	End If

	' Increment group count
	If ChkLvlBreak(1) Then
		nGrpCount = nGrpCount + 1
	End If
Loop
%>
	<!-- Grand Total -->
	<tr class="ewRptGrandSummary">
	<td colspan="2">Grand Total</td>
<!-- Dynamic columns begin -->
	<%
	rowsmry = 0
	For iy = 1 to UBound(grandsmry)
		If col(2,iy) Then
			rowval = grandsmry(iy)
			rowsmry = ew_SummaryValue(rowsmry, rowval, EW_TABLE_REPORT_SUMMARY_TYPE)
			x_Giorni = grandsmry(iy)
	%>
		<!-- <%=col(1,iy)%> -->
		<td>
<%= ew_FormatNumber(x_Giorni,2,-2,-2,-2) %>
</td>
	<%
		End If
	Next
	%>
<!-- Dynamic columns end -->
	</tr>
<% End If %>
</table>
<br>
<% If sExport = "" Then %>
<form action="CrossGiorniMesectb.asp" name="ewpagerform" id="ewpagerform">
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
	<td><a href="CrossGiorniMesectb.asp?start=1"><img src="rptimages/first.gif" alt="First" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--previous page button-->
	<% If CLng(PrevStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/prevdisab.gif" alt="Previous" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="CrossGiorniMesectb.asp?start=<%=PrevStart%>"><img src="rptimages/prev.gif" alt="Previous" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(nStartGrp-1)\nDisplayGrps+1%>" size="4"></td>
<!--next page button-->
	<% If CLng(NextStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/nextdisab.gif" alt="Next" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="CrossGiorniMesectb.asp?start=<%=NextStart%>"><img src="rptimages/next.gif" alt="Next" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--last page button-->
	<% If CLng(LastStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/lastdisab.gif" alt="Last" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="CrossGiorniMesectb.asp?start=<%=LastStart%>"><img src="rptimages/last.gif" alt="Last" width="16" height="16" border="0"></a></td>
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
<!-- Crosstab report ends -->
<% If sExport = "" Then %>
	</div><br></td>
	<!-- Center container (report) (end) -->
	<!-- Right container (begin) -->
	<td valign="top"><div id="ewRight" class="aspreportmaker">
	<!-- right slot -->
	</div></td>
	<!-- Right container (end) -->
</tr>
<!-- Bottom container (begin) -->
<tr><td colspan="3"><div id="ewBottom" class="aspreportmaker">
	<!-- bottom slot -->
	</div><br></td></tr>
<!-- Bottom container (end) -->
</table>
<!-- Table container (end) -->
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

' Get column values
Sub GetColumns()
	Dim i
	Dim bSelected, j

	' Build sql
	Dim sSql
	sSql = ew_BuildReportSql("", EW_TABLE_DISTINCT_SQL_SELECT, EW_TABLE_DISTINCT_SQL_WHERE, "", "", EW_TABLE_DISTINCT_SQL_ORDERBY, "", sFilter, sSort)

	' Load recordset
	Dim rscol
	Set rscol = ew_LoadRs(sSql)

	' Get distinct column count
	ncol = 0
	If Not rscol.Eof Then rscol.MoveFirst
	Do While Not rscol.Eof
		ncol = ncol + 1
		rscol.MoveNext
	Loop
	If ncol = 0 Then
		rscol.Close
		Set rscol = Nothing
		Response.Write "No distinct column values for sql: " & sSql & "<br>"
		Response.End
	End If

	' 1st dimension = no of groups (level 0 used for grand total)
	' 2nd dimension = no of distinct values

	Redim col(2,ncol), val(ncol), oval(ncol), cnt(2,ncol), smry(2,ncol), grandsmry(ncol)

	' Reset summary values
	Call ResetLevelSummary(0)
	Dim colcnt: colcnt = 0
	Dim wrkValue, wrkCaption
	If ncol > 0 Then rscol.MoveFirst
	Do While Not rscol.Eof
		If IsNull(rscol(0)) Then
			wrkValue = "##null"
			wrkCaption = EW_NULL_LABEL
		ElseIf rscol(0) = "" Then
			wrkValue = "##empty"
			wrkCaption = EW_EMPTY_LABEL
		Else
			wrkValue = rscol(0)
			wrkCaption = rscol(0)
		End If
		colcnt = colcnt + 1
		col(0,colcnt) = wrkValue ' value
		col(1,colcnt) = wrkCaption ' caption
		col(2,colcnt) = True  ' column visible
		rscol.MoveNext
	Loop
	rscol.Close
	Set rscol = Nothing

	' Rebuild SQL
	Dim sFld, sSqlFlds
	sSqlFlds = ""
	For colcnt = 1 to ncol
		sFld = ew_CrossTabField("SUM", "[Giorni]", "[AnnoMese]", "", col(0,colcnt), "'", colcnt)
		sSqlFlds = sSqlFlds & ", " & sFld
	Next
	EW_TABLE_SQL_SELECT = Replace(EW_TABLE_SQL_SELECT, "<DistinctColumnFields>", sSqlFlds)

	' Get active columns
	If Not IsArray(sel_AnnoMese) Then
		ncolspan = ncol
	Else
		ncolspan = 0
		For i = 1 to UBound(col,2)
			bSelected = False
			For j = 0 to UBound(sel_AnnoMese)
				If Trim(sel_AnnoMese(j)) = Trim(col(0,i)) Then
					ncolspan = ncolspan + 1
					bSelected = True
					Exit For
				End If
			Next
			col(2,i) = bSelected
			If Not bSelected Then bFilterApplied = True
		Next
	End If
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
			x_NomePersona = rs("NomePersona")
			For ix = 1 to UBound(val)
				val(ix) = rs(ix+2-1)
			Next
			Exit Do
		Else
			rs.MoveNext
		End If
	Loop
	If rs.Eof Then
		x_NomeProgetto = ""
		x_NomePersona = ""
	End If
End Sub

' Check level break
Function ChkLvlBreak(lvl)
	Select Case lvl
		Case 1: ChkLvlBreak = _
			(IsNull(x_NomeProgetto) And Not IsNull(ox_NomeProgetto)) Or _
			(Not IsNull(x_NomeProgetto) And IsNull(ox_NomeProgetto)) Or _
			(x_NomeProgetto <> ox_NomeProgetto)
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
			valwrk = val(iy)
			cnt(ix,iy) = cnt(ix,iy) + 1
			smry(ix,iy) = ew_SummaryValue(smry(ix,iy), valwrk, EW_TABLE_REPORT_SUMMARY_TYPE)
		Next
	Next
End Sub

' Reset level summary
Sub ResetLevelSummary(lvl)

	' Clear summary values
	For ix = lvl to UBound(smry,1)
		For iy = 1 to UBound(smry,2)
			cnt(ix,iy) = 0
			smry(ix,iy) = 0
		Next
	Next

	' Clear grand summary
	If lvl = 0 Then
		For iy = 1 to UBound(grandsmry)
			grandsmry(iy) = 0
		Next
	End If

	' Reset record count
	nRecCount = 0
End Sub

' Accummulate grand summary
Sub AccumulateGrandSummary()
	Dim valwrk
	For iy = 1 to UBound(grandsmry)
		valwrk = val(iy)
		grandsmry(iy) = ew_SummaryValue(grandsmry(iy), valwrk, EW_TABLE_REPORT_SUMMARY_TYPE)
	Next
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
			If Trim(arValues(0)) = "" Then ' select all
				Session("all_" & sName) = True

				' remove first entry
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

	' Clone Recordset
	Set rswrk = rs.Clone(1)
	Do While Not rswrk.Eof
		bValidRow = ValidRow(rswrk)
		If Not bValidRow Then bFilterApplied = True
		If bValidRow Then
			bNewGroup = (grpcnt = 0) Or _
				(IsNull(grpvalue) And Not IsNull(rswrk(0))) Or _
				(Not IsNull(grpvalue) And IsNull(rswrk(0))) Or _
				(grpvalue <> rswrk(0))
			If bNewGroup Then
				grpvalue = rswrk(0)
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
	If ValidRow Then ValidRow = HasColumnValues(rs) ' Rows with values
End Function

' Check if any column values is present
Function HasColumnValues(rs)
	Dim i
	For i = 1 to UBound(col,2)
		If col(2,i) Then
			If rs(2+i-1) <> 0 Then
				HasColumnValues = True
				Exit Function
			End If
		End If
	Next
	HasColumnValues = False
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
