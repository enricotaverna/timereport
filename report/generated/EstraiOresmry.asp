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

' ASP Report Maker 1.0 - Table level configuration (EstraiOre)
' Table Level Constants

Const EW_TABLE_VAR = "EstraiOre"
Const EW_TABLE_GROUP_PER_PAGE = "grpperpage"
Const EW_TABLE_SESSION_GROUP_PER_PAGE = "EstraiOre_grpperpage"
Const EW_TABLE_START_GROUP = "start"
Const EW_TABLE_SESSION_START_GROUP = "EstraiOre_start"
Const EW_TABLE_SESSION_SEARCH = "EstraiOre_search"
Const EW_TABLE_CHILD_USER_ID = "childuserid"
Const EW_TABLE_SESSION_CHILD_USER_ID = "EstraiOre_childuserid"

' Table Level SQL
Const EW_TABLE_SQL_FROM = "[v_ore]"
Dim EW_TABLE_SQL_SELECT
EW_TABLE_SQL_SELECT = "SELECT * FROM " & EW_TABLE_SQL_FROM
Dim EW_TABLE_SQL_WHERE
EW_TABLE_SQL_WHERE = session("whereclause")
Const EW_TABLE_SQL_GROUPBY = ""
Const EW_TABLE_SQL_HAVING = ""
Const EW_TABLE_SQL_ORDERBY = "[NomePersona] ASC"
Const EW_TABLE_SQL_USERID_FILTER = ""
Dim af_NomePersona ' Advanced filter for NomePersona
Dim af_NomeSocieta ' Advanced filter for NomeSocieta
Dim af_CodiceCliente ' Advanced filter for CodiceCliente
Dim af_NomeCliente ' Advanced filter for NomeCliente
Dim af_ProjectCode ' Advanced filter for ProjectCode
Dim af_NomeProgetto ' Advanced filter for NomeProgetto
Dim af_DescTipoProgetto ' Advanced filter for DescTipoProgetto
Dim af_NomeManager ' Advanced filter for NomeManager
Dim af_Date ' Advanced filter for Date
Dim af_AnnoMese ' Advanced filter for AnnoMese
Dim af_HourTypeCode ' Advanced filter for HourTypeCode
Dim af_flagstorno ' Advanced filter for flagstorno
Dim af_flagTrasferta ' Advanced filter for flagTrasferta
Dim af_Hours ' Advanced filter for Hours
Dim af_Giorni ' Advanced filter for Giorni
Dim af_Comment ' Advanced filter for Comment
%>
<%
Dim EW_FIELD_NOMEPERSONA_SQL_SELECT
EW_FIELD_NOMEPERSONA_SQL_SELECT = "SELECT DISTINCT [NomePersona] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_NOMEPERSONA_SQL_ORDERBY = "[NomePersona]"
Dim EW_FIELD_NOMESOCIETA_SQL_SELECT
EW_FIELD_NOMESOCIETA_SQL_SELECT = "SELECT DISTINCT [NomeSocieta] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_NOMESOCIETA_SQL_ORDERBY = "[NomeSocieta]"
Dim EW_FIELD_CODICECLIENTE_SQL_SELECT
EW_FIELD_CODICECLIENTE_SQL_SELECT = "SELECT DISTINCT [CodiceCliente] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_CODICECLIENTE_SQL_ORDERBY = "[CodiceCliente]"
Dim EW_FIELD_NOMECLIENTE_SQL_SELECT
EW_FIELD_NOMECLIENTE_SQL_SELECT = "SELECT DISTINCT [NomeCliente] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_NOMECLIENTE_SQL_ORDERBY = "[NomeCliente]"
Dim EW_FIELD_PROJECTCODE_SQL_SELECT
EW_FIELD_PROJECTCODE_SQL_SELECT = "SELECT DISTINCT [ProjectCode] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_PROJECTCODE_SQL_ORDERBY = "[ProjectCode]"
Dim EW_FIELD_NOMEPROGETTO_SQL_SELECT
EW_FIELD_NOMEPROGETTO_SQL_SELECT = "SELECT DISTINCT [NomeProgetto] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_NOMEPROGETTO_SQL_ORDERBY = "[NomeProgetto]"
Dim EW_FIELD_DESCTIPOPROGETTO_SQL_SELECT
EW_FIELD_DESCTIPOPROGETTO_SQL_SELECT = "SELECT DISTINCT [DescTipoProgetto] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_DESCTIPOPROGETTO_SQL_ORDERBY = "[DescTipoProgetto]"
Dim EW_FIELD_NOMEMANAGER_SQL_SELECT
EW_FIELD_NOMEMANAGER_SQL_SELECT = "SELECT DISTINCT [NomeManager] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_NOMEMANAGER_SQL_ORDERBY = "[NomeManager]"
Dim EW_FIELD_DATE_SQL_SELECT
EW_FIELD_DATE_SQL_SELECT = "SELECT DISTINCT [Date] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_DATE_SQL_ORDERBY = "[Date]"
Dim EW_FIELD_ANNOMESE_SQL_SELECT
EW_FIELD_ANNOMESE_SQL_SELECT = "SELECT DISTINCT [AnnoMese] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_ANNOMESE_SQL_ORDERBY = "[AnnoMese]"
Dim EW_FIELD_HOURTYPECODE_SQL_SELECT
EW_FIELD_HOURTYPECODE_SQL_SELECT = "SELECT DISTINCT [HourTypeCode] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_HOURTYPECODE_SQL_ORDERBY = "[HourTypeCode]"
Dim EW_FIELD_FLAGSTORNO_SQL_SELECT
EW_FIELD_FLAGSTORNO_SQL_SELECT = "SELECT DISTINCT [flagstorno] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_FLAGSTORNO_SQL_ORDERBY = "[flagstorno]"
Dim EW_FIELD_FLAGTRASFERTA_SQL_SELECT
EW_FIELD_FLAGTRASFERTA_SQL_SELECT = "SELECT DISTINCT [flagTrasferta] FROM " & EW_TABLE_SQL_FROM
Const EW_FIELD_FLAGTRASFERTA_SQL_ORDERBY = "[flagTrasferta]"
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

' Detail variables
Dim x_NomePersona, ox_NomePersona, tx_NomePersona, ftx_NomePersona
x_NomePersona = Null: ox_NomePersona = Null: tx_NomePersona = Null: ftx_NomePersona = 202
Dim rf_NomePersona, rt_NomePersona
Dim x_NomeSocieta, ox_NomeSocieta, tx_NomeSocieta, ftx_NomeSocieta
x_NomeSocieta = Null: ox_NomeSocieta = Null: tx_NomeSocieta = Null: ftx_NomeSocieta = 202
Dim rf_NomeSocieta, rt_NomeSocieta
Dim x_CodiceCliente, ox_CodiceCliente, tx_CodiceCliente, ftx_CodiceCliente
x_CodiceCliente = Null: ox_CodiceCliente = Null: tx_CodiceCliente = Null: ftx_CodiceCliente = 130
Dim rf_CodiceCliente, rt_CodiceCliente
Dim x_NomeCliente, ox_NomeCliente, tx_NomeCliente, ftx_NomeCliente
x_NomeCliente = Null: ox_NomeCliente = Null: tx_NomeCliente = Null: ftx_NomeCliente = 130
Dim rf_NomeCliente, rt_NomeCliente
Dim x_ProjectCode, ox_ProjectCode, tx_ProjectCode, ftx_ProjectCode
x_ProjectCode = Null: ox_ProjectCode = Null: tx_ProjectCode = Null: ftx_ProjectCode = 202
Dim rf_ProjectCode, rt_ProjectCode
Dim x_NomeProgetto, ox_NomeProgetto, tx_NomeProgetto, ftx_NomeProgetto
x_NomeProgetto = Null: ox_NomeProgetto = Null: tx_NomeProgetto = Null: ftx_NomeProgetto = 202
Dim rf_NomeProgetto, rt_NomeProgetto
Dim x_DescTipoProgetto, ox_DescTipoProgetto, tx_DescTipoProgetto, ftx_DescTipoProgetto
x_DescTipoProgetto = Null: ox_DescTipoProgetto = Null: tx_DescTipoProgetto = Null: ftx_DescTipoProgetto = 202
Dim rf_DescTipoProgetto, rt_DescTipoProgetto
Dim x_NomeManager, ox_NomeManager, tx_NomeManager, ftx_NomeManager
x_NomeManager = Null: ox_NomeManager = Null: tx_NomeManager = Null: ftx_NomeManager = 202
Dim rf_NomeManager, rt_NomeManager
Dim x_Date, ox_Date, tx_Date, ftx_Date
x_Date = Null: ox_Date = Null: tx_Date = Null: ftx_Date = 135
Dim rf_Date, rt_Date
Dim x_AnnoMese, ox_AnnoMese, tx_AnnoMese, ftx_AnnoMese
x_AnnoMese = Null: ox_AnnoMese = Null: tx_AnnoMese = Null: ftx_AnnoMese = 200
Dim rf_AnnoMese, rt_AnnoMese
Dim x_HourTypeCode, ox_HourTypeCode, tx_HourTypeCode, ftx_HourTypeCode
x_HourTypeCode = Null: ox_HourTypeCode = Null: tx_HourTypeCode = Null: ftx_HourTypeCode = 202
Dim rf_HourTypeCode, rt_HourTypeCode
Dim x_flagstorno, ox_flagstorno, tx_flagstorno, ftx_flagstorno
x_flagstorno = Null: ox_flagstorno = Null: tx_flagstorno = Null: ftx_flagstorno = 11
Dim rf_flagstorno, rt_flagstorno
Dim x_flagTrasferta, ox_flagTrasferta, tx_flagTrasferta, ftx_flagTrasferta
x_flagTrasferta = Null: ox_flagTrasferta = Null: tx_flagTrasferta = Null: ftx_flagTrasferta = 11
Dim rf_flagTrasferta, rt_flagTrasferta
Dim x_Hours, ox_Hours, tx_Hours, ftx_Hours
x_Hours = Null: ox_Hours = Null: tx_Hours = Null: ftx_Hours = 6
Dim rf_Hours, rt_Hours
Dim x_Giorni, ox_Giorni, tx_Giorni, ftx_Giorni
x_Giorni = Null: ox_Giorni = Null: tx_Giorni = Null: ftx_Giorni = 6
Dim rf_Giorni, rt_Giorni
Dim x_Comment, ox_Comment, tx_Comment, ftx_Comment
x_Comment = Null: ox_Comment = Null: tx_Comment = Null: ftx_Comment = 203
Dim rf_Comment, rt_Comment
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

Dim col(16), val(16), cnt(0,16)
Dim smry(0,16), mn(0,16), mx(0,16)
Dim grandsmry(16), grandmn(16), grandmx(16)

' Set up if accumulation required
col(1) = False
col(2) = False
col(3) = False
col(4) = False
col(5) = False
col(6) = False
col(7) = False
col(8) = False
col(9) = False
col(10) = False
col(11) = False
col(12) = False
col(13) = False
col(14) = False
col(15) = False
col(16) = False

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

' Detail distinct & selection values
Dim sel_NomePersona, val_NomePersona
Dim sel_NomeSocieta, val_NomeSocieta
Dim sel_CodiceCliente, val_CodiceCliente
Dim sel_NomeCliente, val_NomeCliente
Dim sel_ProjectCode, val_ProjectCode
Dim sel_NomeProgetto, val_NomeProgetto
Dim sel_DescTipoProgetto, val_DescTipoProgetto
Dim sel_NomeManager, val_NomeManager
Dim sel_Date, val_Date
Dim sel_AnnoMese, val_AnnoMese
Dim sel_HourTypeCode, val_HourTypeCode
Dim sel_flagstorno, val_flagstorno
Dim sel_flagTrasferta, val_flagTrasferta
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
<% jsdata = ew_GetJsData("EstraiOreNomePersona", val_NomePersona, ftx_NomePersona) %>
ew_CreatePopup("EstraiOreNomePersona", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreNomeSocieta", val_NomeSocieta, ftx_NomeSocieta) %>
ew_CreatePopup("EstraiOreNomeSocieta", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreCodiceCliente", val_CodiceCliente, ftx_CodiceCliente) %>
ew_CreatePopup("EstraiOreCodiceCliente", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreNomeCliente", val_NomeCliente, ftx_NomeCliente) %>
ew_CreatePopup("EstraiOreNomeCliente", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreProjectCode", val_ProjectCode, ftx_ProjectCode) %>
ew_CreatePopup("EstraiOreProjectCode", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreNomeProgetto", val_NomeProgetto, ftx_NomeProgetto) %>
ew_CreatePopup("EstraiOreNomeProgetto", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreDescTipoProgetto", val_DescTipoProgetto, ftx_DescTipoProgetto) %>
ew_CreatePopup("EstraiOreDescTipoProgetto", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreNomeManager", val_NomeManager, ftx_NomeManager) %>
ew_CreatePopup("EstraiOreNomeManager", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreDate", val_Date, ftx_Date) %>
ew_CreatePopup("EstraiOreDate", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreAnnoMese", val_AnnoMese, ftx_AnnoMese) %>
ew_CreatePopup("EstraiOreAnnoMese", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreHourTypeCode", val_HourTypeCode, ftx_HourTypeCode) %>
ew_CreatePopup("EstraiOreHourTypeCode", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreflagstorno", val_flagstorno, ftx_flagstorno) %>
ew_CreatePopup("EstraiOreflagstorno", [<%=jsdata%>]);
<% jsdata = ew_GetJsData("EstraiOreflagTrasferta", val_flagTrasferta, ftx_flagTrasferta) %>
ew_CreatePopup("EstraiOreflagTrasferta", [<%=jsdata%>]);
//-->
</script>
<div id="EstraiOreNomePersona_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreNomeSocieta_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreCodiceCliente_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreNomeCliente_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreProjectCode_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreNomeProgetto_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreDescTipoProgetto_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreNomeManager_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreDate_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreAnnoMese_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreHourTypeCode_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreflagstorno_Popup" class="ewPopup">
<span class="aspreportmaker"></span>
</div>
<div id="EstraiOreflagTrasferta_Popup" class="ewPopup">
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
Estrai Ore
<% If sExport = "" Then %>
&nbsp;&nbsp;<a href="EstraiOresmry.asp?export=excel">Export to Excel</a>
<% If bFilterApplied Then %>
&nbsp;&nbsp;<a href="EstraiOresmry.asp?cmd=reset">Reset All Filters</a>
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
bShowFirstHeader = True
Do While (Not rs.Eof) Or (bShowFirstHeader)

		' Show Header
	If bShowFirstHeader Then
%>
	<tr>
		<td valign="bottom" class="ewTableHeader">
		Persona
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreNomePersona', false, '<%=rf_NomePersona%>', '<%=rt_NomePersona%>');return false;" name="x_NomePersona<%=cnt(0,0)%>" id="x_NomePersona<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Società
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreNomeSocieta', false, '<%=rf_NomeSocieta%>', '<%=rt_NomeSocieta%>');return false;" name="x_NomeSocieta<%=cnt(0,0)%>" id="x_NomeSocieta<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Codice Cliente
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreCodiceCliente', false, '<%=rf_CodiceCliente%>', '<%=rt_CodiceCliente%>');return false;" name="x_CodiceCliente<%=cnt(0,0)%>" id="x_CodiceCliente<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Cliente
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreNomeCliente', false, '<%=rf_NomeCliente%>', '<%=rt_NomeCliente%>');return false;" name="x_NomeCliente<%=cnt(0,0)%>" id="x_NomeCliente<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Cod.Prog.
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreProjectCode', false, '<%=rf_ProjectCode%>', '<%=rt_ProjectCode%>');return false;" name="x_ProjectCode<%=cnt(0,0)%>" id="x_ProjectCode<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Progetto
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreNomeProgetto', false, '<%=rf_NomeProgetto%>', '<%=rt_NomeProgetto%>');return false;" name="x_NomeProgetto<%=cnt(0,0)%>" id="x_NomeProgetto<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Tipo
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreDescTipoProgetto', false, '<%=rf_DescTipoProgetto%>', '<%=rt_DescTipoProgetto%>');return false;" name="x_DescTipoProgetto<%=cnt(0,0)%>" id="x_DescTipoProgetto<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Manager
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreNomeManager', false, '<%=rf_NomeManager%>', '<%=rt_NomeManager%>');return false;" name="x_NomeManager<%=cnt(0,0)%>" id="x_NomeManager<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Date
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreDate', false, '<%=rf_Date%>', '<%=rt_Date%>');return false;" name="x_Date<%=cnt(0,0)%>" id="x_Date<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader" style="white-space: nowrap;">
		Anno Mese
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreAnnoMese', false, '<%=rf_AnnoMese%>', '<%=rt_AnnoMese%>');return false;" name="x_AnnoMese<%=cnt(0,0)%>" id="x_AnnoMese<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Tipo Ora
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreHourTypeCode', false, '<%=rf_HourTypeCode%>', '<%=rt_HourTypeCode%>');return false;" name="x_HourTypeCode<%=cnt(0,0)%>" id="x_HourTypeCode<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		STf
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreflagstorno', false, '<%=rf_flagstorno%>', '<%=rt_flagstorno%>');return false;" name="x_flagstorno<%=cnt(0,0)%>" id="x_flagstorno<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		TRf
<% If sExport = "" Then %>
		<a href="#" onClick="ew_ShowPopup(this.name, 'EstraiOreflagTrasferta', false, '<%=rf_flagTrasferta%>', '<%=rt_flagTrasferta%>');return false;" name="x_flagTrasferta<%=cnt(0,0)%>" id="x_flagTrasferta<%=cnt(0,0)%>"><img src="rptimages/popup.gif" width="15" height="14" align="texttop" border="0" alt=""></a>
<% End If %>
		</td>
		<td valign="bottom" class="ewTableHeader">
		Ore
		</td>
		<td valign="bottom" class="ewTableHeader">
		Giorni
		</td>
		<td valign="bottom" class="ewTableHeader">
		Comment
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
%>
	<tr<%=sItemRowClass%>>
		<td class="ewRptDtlField">
<%= x_NomePersona %>
</td>
		<td class="ewRptDtlField">
<%= x_NomeSocieta %>
</td>
		<td class="ewRptDtlField">
<%= x_CodiceCliente %>
</td>
		<td class="ewRptDtlField">
<%= x_NomeCliente %>
</td>
		<td class="ewRptDtlField">
<%= x_ProjectCode %>
</td>
		<td class="ewRptDtlField">
<%= x_NomeProgetto %>
</td>
		<td class="ewRptDtlField">
<%= x_DescTipoProgetto %>
</td>
		<td class="ewRptDtlField">
<%= x_NomeManager %>
</td>
		<td class="ewRptDtlField">
<%= x_Date %>
</td>
		<td class="ewRptDtlField" style="white-space: nowrap;">
<%= x_AnnoMese %>
</td>
		<td class="ewRptDtlField">
<%= x_HourTypeCode %>
</td>
		<td class="ewRptDtlField">
<%
If x_flagstorno = True Then
	sTmp = "Yes"
Else
	sTmp = "No"
End If
ox_flagstorno = x_flagstorno ' Backup Original Value
x_flagstorno = sTmp
%>
<%= x_flagstorno %>
<% x_flagstorno = ox_flagstorno ' Restore Original Value %>
</td>
		<td class="ewRptDtlField">
<%
If x_flagTrasferta = True Then
	sTmp = "Yes"
Else
	sTmp = "No"
End If
ox_flagTrasferta = x_flagTrasferta ' Backup Original Value
x_flagTrasferta = sTmp
%>
<%= x_flagTrasferta %>
<% x_flagTrasferta = ox_flagTrasferta ' Restore Original Value %>
</td>
		<td class="ewRptDtlField">
<%= x_Hours %>
</td>
		<td class="ewRptDtlField">
<%= ew_FormatNumber(x_Giorni,2,-2,-2,-2) %>
</td>
		<td class="ewRptDtlField">
<%= Replace(x_Comment&"", vbLf, "<br>") %>
</td>
	</tr>
<%

		' Accumulate page summary
		Call AccumulateSummary()
	End If

	' Accumulate grand summary
	Call AccumulateGrandSummary()

	' Get next record
	Call GetRow(rs, 2)
	nGrpCount = nGrpCount + 1
Loop
%>
<% If nTotalGrps > 0 Then %>
	<!-- tr><td colspan="16"><span class="aspreportmaker">&nbsp;<br></span></td></tr -->
	<tr class="ewRptGrandSummary"><td colspan="16">Grand Total (<%= FormatNumber(cnt(0,0),0) %> Detail Records)</td></tr>
	<!--tr><td colspan="16"><span class="aspreportmaker">&nbsp;<br></span></td></tr-->
<% End If %>
</table>
<!-- </form> -->
<% If sExport = "" Then %>
<form action="EstraiOresmry.asp" name="ewpagerform" id="ewpagerform">
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
	<td><a href="EstraiOresmry.asp?start=1"><img src="rptimages/first.gif" alt="First" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--previous page button-->
	<% If CLng(PrevStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/prevdisab.gif" alt="Previous" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="EstraiOresmry.asp?start=<%=PrevStart%>"><img src="rptimages/prev.gif" alt="Previous" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--current page number-->
	<td><input type="text" name="pageno" value="<%=(nStartGrp-1)\nDisplayGrps+1%>" size="4"></td>
<!--next page button-->
	<% If CLng(NextStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/nextdisab.gif" alt="Next" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="EstraiOresmry.asp?start=<%=NextStart%>"><img src="rptimages/next.gif" alt="Next" width="16" height="16" border="0"></a></td>
	<% End If %>
<!--last page button-->
	<% If CLng(LastStart) = CLng(nStartGrp) Then %>
	<td><img src="rptimages/lastdisab.gif" alt="Last" width="16" height="16" border="0"></td>
	<% Else %>
	<td><a href="EstraiOresmry.asp?start=<%=LastStart%>"><img src="rptimages/last.gif" alt="Last" width="16" height="16" border="0"></a></td>
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
			x_NomePersona = rs("NomePersona")
			val(1) = x_NomePersona
			x_NomeSocieta = rs("NomeSocieta")
			val(2) = x_NomeSocieta
			x_CodiceCliente = rs("CodiceCliente")
			val(3) = x_CodiceCliente
			x_NomeCliente = rs("NomeCliente")
			val(4) = x_NomeCliente
			x_ProjectCode = rs("ProjectCode")
			val(5) = x_ProjectCode
			x_NomeProgetto = rs("NomeProgetto")
			val(6) = x_NomeProgetto
			x_DescTipoProgetto = rs("DescTipoProgetto")
			val(7) = x_DescTipoProgetto
			x_NomeManager = rs("NomeManager")
			val(8) = x_NomeManager
			x_Date = rs("Date")
			val(9) = x_Date
			x_AnnoMese = rs("AnnoMese")
			val(10) = x_AnnoMese
			x_HourTypeCode = rs("HourTypeCode")
			val(11) = x_HourTypeCode
			x_flagstorno = rs("flagstorno")
			val(12) = x_flagstorno
			x_flagTrasferta = rs("flagTrasferta")
			val(13) = x_flagTrasferta
			x_Hours = rs("Hours")
			val(14) = x_Hours
			x_Giorni = rs("Giorni")
			val(15) = x_Giorni
			x_Comment = rs("Comment")
			val(16) = x_Comment
			Exit Do
		Else
			rs.MoveNext
		End If
	Loop
	If rs.Eof Then
		x_NomePersona = ""
		x_NomeSocieta = ""
		x_CodiceCliente = ""
		x_NomeCliente = ""
		x_ProjectCode = ""
		x_NomeProgetto = ""
		x_DescTipoProgetto = ""
		x_NomeManager = ""
		x_Date = ""
		x_AnnoMese = ""
		x_HourTypeCode = ""
		x_flagstorno = ""
		x_flagTrasferta = ""
		x_Hours = ""
		x_Giorni = ""
		x_Comment = ""
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
			Session("all_EstraiOreNomePersona") = True
			Session("sel_EstraiOreNomePersona") = ""
			Session("rf_EstraiOreNomePersona") = ""
			Session("rt_EstraiOreNomePersona") = ""
			Session("all_EstraiOreNomeSocieta") = True
			Session("sel_EstraiOreNomeSocieta") = ""
			Session("rf_EstraiOreNomeSocieta") = ""
			Session("rt_EstraiOreNomeSocieta") = ""
			Session("all_EstraiOreCodiceCliente") = True
			Session("sel_EstraiOreCodiceCliente") = ""
			Session("rf_EstraiOreCodiceCliente") = ""
			Session("rt_EstraiOreCodiceCliente") = ""
			Session("all_EstraiOreNomeCliente") = True
			Session("sel_EstraiOreNomeCliente") = ""
			Session("rf_EstraiOreNomeCliente") = ""
			Session("rt_EstraiOreNomeCliente") = ""
			Session("all_EstraiOreProjectCode") = True
			Session("sel_EstraiOreProjectCode") = ""
			Session("rf_EstraiOreProjectCode") = ""
			Session("rt_EstraiOreProjectCode") = ""
			Session("all_EstraiOreNomeProgetto") = True
			Session("sel_EstraiOreNomeProgetto") = ""
			Session("rf_EstraiOreNomeProgetto") = ""
			Session("rt_EstraiOreNomeProgetto") = ""
			Session("all_EstraiOreDescTipoProgetto") = True
			Session("sel_EstraiOreDescTipoProgetto") = ""
			Session("rf_EstraiOreDescTipoProgetto") = ""
			Session("rt_EstraiOreDescTipoProgetto") = ""
			Session("all_EstraiOreNomeManager") = True
			Session("sel_EstraiOreNomeManager") = ""
			Session("rf_EstraiOreNomeManager") = ""
			Session("rt_EstraiOreNomeManager") = ""
			Session("all_EstraiOreDate") = True
			Session("sel_EstraiOreDate") = ""
			Session("rf_EstraiOreDate") = ""
			Session("rt_EstraiOreDate") = ""
			Session("all_EstraiOreAnnoMese") = True
			Session("sel_EstraiOreAnnoMese") = ""
			Session("rf_EstraiOreAnnoMese") = ""
			Session("rt_EstraiOreAnnoMese") = ""
			Session("all_EstraiOreHourTypeCode") = True
			Session("sel_EstraiOreHourTypeCode") = ""
			Session("rf_EstraiOreHourTypeCode") = ""
			Session("rt_EstraiOreHourTypeCode") = ""
			Session("all_EstraiOreflagstorno") = True
			Session("sel_EstraiOreflagstorno") = ""
			Session("rf_EstraiOreflagstorno") = ""
			Session("rt_EstraiOreflagstorno") = ""
			Session("all_EstraiOreflagTrasferta") = True
			Session("sel_EstraiOreflagTrasferta") = ""
			Session("rf_EstraiOreflagTrasferta") = ""
			Session("rt_EstraiOreflagTrasferta") = ""
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

	bSelectedAll = ew_IsSelectedAll("EstraiOreNomePersona")
	If Not bSelectedAll Then
		sel_NomePersona = Session("sel_EstraiOreNomePersona")
		rf_NomePersona = Session("rf_EstraiOreNomePersona")
		rt_NomePersona = Session("rt_EstraiOreNomePersona")
	End If

	' Get Società selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreNomeSocieta")
	If Not bSelectedAll Then
		sel_NomeSocieta = Session("sel_EstraiOreNomeSocieta")
		rf_NomeSocieta = Session("rf_EstraiOreNomeSocieta")
		rt_NomeSocieta = Session("rt_EstraiOreNomeSocieta")
	End If

	' Get Codice Cliente selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreCodiceCliente")
	If Not bSelectedAll Then
		sel_CodiceCliente = Session("sel_EstraiOreCodiceCliente")
		rf_CodiceCliente = Session("rf_EstraiOreCodiceCliente")
		rt_CodiceCliente = Session("rt_EstraiOreCodiceCliente")
	End If

	' Get Cliente selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreNomeCliente")
	If Not bSelectedAll Then
		sel_NomeCliente = Session("sel_EstraiOreNomeCliente")
		rf_NomeCliente = Session("rf_EstraiOreNomeCliente")
		rt_NomeCliente = Session("rt_EstraiOreNomeCliente")
	End If

	' Get Cod.Prog. selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreProjectCode")
	If Not bSelectedAll Then
		sel_ProjectCode = Session("sel_EstraiOreProjectCode")
		rf_ProjectCode = Session("rf_EstraiOreProjectCode")
		rt_ProjectCode = Session("rt_EstraiOreProjectCode")
	End If

	' Get Progetto selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreNomeProgetto")
	If Not bSelectedAll Then
		sel_NomeProgetto = Session("sel_EstraiOreNomeProgetto")
		rf_NomeProgetto = Session("rf_EstraiOreNomeProgetto")
		rt_NomeProgetto = Session("rt_EstraiOreNomeProgetto")
	End If

	' Get Tipo selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreDescTipoProgetto")
	If Not bSelectedAll Then
		sel_DescTipoProgetto = Session("sel_EstraiOreDescTipoProgetto")
		rf_DescTipoProgetto = Session("rf_EstraiOreDescTipoProgetto")
		rt_DescTipoProgetto = Session("rt_EstraiOreDescTipoProgetto")
	End If

	' Get Manager selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreNomeManager")
	If Not bSelectedAll Then
		sel_NomeManager = Session("sel_EstraiOreNomeManager")
		rf_NomeManager = Session("rf_EstraiOreNomeManager")
		rt_NomeManager = Session("rt_EstraiOreNomeManager")
	End If

	' Get Date selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreDate")
	If Not bSelectedAll Then
		sel_Date = Session("sel_EstraiOreDate")
		rf_Date = Session("rf_EstraiOreDate")
		rt_Date = Session("rt_EstraiOreDate")
	End If

	' Get Anno Mese selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreAnnoMese")
	If Not bSelectedAll Then
		sel_AnnoMese = Session("sel_EstraiOreAnnoMese")
		rf_AnnoMese = Session("rf_EstraiOreAnnoMese")
		rt_AnnoMese = Session("rt_EstraiOreAnnoMese")
	End If

	' Get Tipo Ora selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreHourTypeCode")
	If Not bSelectedAll Then
		sel_HourTypeCode = Session("sel_EstraiOreHourTypeCode")
		rf_HourTypeCode = Session("rf_EstraiOreHourTypeCode")
		rt_HourTypeCode = Session("rt_EstraiOreHourTypeCode")
	End If

	' Get STf selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreflagstorno")
	If Not bSelectedAll Then
		sel_flagstorno = Session("sel_EstraiOreflagstorno")
		rf_flagstorno = Session("rf_EstraiOreflagstorno")
		rt_flagstorno = Session("rt_EstraiOreflagstorno")
	End If

	' Get TRf selected values
	bSelectedAll = ew_IsSelectedAll("EstraiOreflagTrasferta")
	If Not bSelectedAll Then
		sel_flagTrasferta = Session("sel_EstraiOreflagTrasferta")
		rf_flagTrasferta = Session("rf_EstraiOreflagTrasferta")
		rt_flagTrasferta = Session("rt_EstraiOreflagTrasferta")
	End If
End Sub

' Initialize group data - total number of groups + grouping field arrays
Sub InitReportData(rs)
	Dim sSql, bNullValue, bEmptyValue
	Dim bValidRow, bNewGroup
	Dim rswrk, grpcnt, grpvalue
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_NOMEPERSONA_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_NOMEPERSONA_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_NomePersona = rswrk("NomePersona")
		If IsNull(x_NomePersona) Then
			bNullValue = True
		ElseIf x_NomePersona = "" Then
			bEmptyValue = True
		Else
			tx_NomePersona = x_NomePersona
			Call ew_SetupDistinctValues(val_NomePersona, x_NomePersona, tx_NomePersona, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_NomePersona, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_NomePersona, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_NOMESOCIETA_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_NOMESOCIETA_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_NomeSocieta = rswrk("NomeSocieta")
		If IsNull(x_NomeSocieta) Then
			bNullValue = True
		ElseIf x_NomeSocieta = "" Then
			bEmptyValue = True
		Else
			tx_NomeSocieta = x_NomeSocieta
			Call ew_SetupDistinctValues(val_NomeSocieta, x_NomeSocieta, tx_NomeSocieta, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_NomeSocieta, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_NomeSocieta, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_CODICECLIENTE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_CODICECLIENTE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_CodiceCliente = rswrk("CodiceCliente")
		If IsNull(x_CodiceCliente) Then
			bNullValue = True
		ElseIf x_CodiceCliente = "" Then
			bEmptyValue = True
		Else
			tx_CodiceCliente = x_CodiceCliente
			Call ew_SetupDistinctValues(val_CodiceCliente, x_CodiceCliente, tx_CodiceCliente, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_CodiceCliente, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_CodiceCliente, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_NOMECLIENTE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_NOMECLIENTE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_NomeCliente = rswrk("NomeCliente")
		If IsNull(x_NomeCliente) Then
			bNullValue = True
		ElseIf x_NomeCliente = "" Then
			bEmptyValue = True
		Else
			tx_NomeCliente = x_NomeCliente
			Call ew_SetupDistinctValues(val_NomeCliente, x_NomeCliente, tx_NomeCliente, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_NomeCliente, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_NomeCliente, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_PROJECTCODE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_PROJECTCODE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_ProjectCode = rswrk("ProjectCode")
		If IsNull(x_ProjectCode) Then
			bNullValue = True
		ElseIf x_ProjectCode = "" Then
			bEmptyValue = True
		Else
			tx_ProjectCode = x_ProjectCode
			Call ew_SetupDistinctValues(val_ProjectCode, x_ProjectCode, tx_ProjectCode, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_ProjectCode, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_ProjectCode, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_NOMEPROGETTO_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_NOMEPROGETTO_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_NomeProgetto = rswrk("NomeProgetto")
		If IsNull(x_NomeProgetto) Then
			bNullValue = True
		ElseIf x_NomeProgetto = "" Then
			bEmptyValue = True
		Else
			tx_NomeProgetto = x_NomeProgetto
			Call ew_SetupDistinctValues(val_NomeProgetto, x_NomeProgetto, tx_NomeProgetto, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_NomeProgetto, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_NomeProgetto, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_DESCTIPOPROGETTO_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_DESCTIPOPROGETTO_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_DescTipoProgetto = rswrk("DescTipoProgetto")
		If IsNull(x_DescTipoProgetto) Then
			bNullValue = True
		ElseIf x_DescTipoProgetto = "" Then
			bEmptyValue = True
		Else
			tx_DescTipoProgetto = x_DescTipoProgetto
			Call ew_SetupDistinctValues(val_DescTipoProgetto, x_DescTipoProgetto, tx_DescTipoProgetto, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_DescTipoProgetto, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_DescTipoProgetto, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_NOMEMANAGER_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_NOMEMANAGER_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_NomeManager = rswrk("NomeManager")
		If IsNull(x_NomeManager) Then
			bNullValue = True
		ElseIf x_NomeManager = "" Then
			bEmptyValue = True
		Else
			tx_NomeManager = x_NomeManager
			Call ew_SetupDistinctValues(val_NomeManager, x_NomeManager, tx_NomeManager, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_NomeManager, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_NomeManager, "##null", EW_NULL_LABEL, False)
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
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_ANNOMESE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_ANNOMESE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_AnnoMese = rswrk("AnnoMese")
		If IsNull(x_AnnoMese) Then
			bNullValue = True
		ElseIf x_AnnoMese = "" Then
			bEmptyValue = True
		Else
			tx_AnnoMese = x_AnnoMese
			Call ew_SetupDistinctValues(val_AnnoMese, x_AnnoMese, tx_AnnoMese, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_AnnoMese, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_AnnoMese, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_HOURTYPECODE_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_HOURTYPECODE_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_HourTypeCode = rswrk("HourTypeCode")
		If IsNull(x_HourTypeCode) Then
			bNullValue = True
		ElseIf x_HourTypeCode = "" Then
			bEmptyValue = True
		Else
			tx_HourTypeCode = x_HourTypeCode
			Call ew_SetupDistinctValues(val_HourTypeCode, x_HourTypeCode, tx_HourTypeCode, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_HourTypeCode, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_HourTypeCode, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_FLAGSTORNO_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_FLAGSTORNO_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_flagstorno = rswrk("flagstorno")
		If IsNull(x_flagstorno) Then
			bNullValue = True
		ElseIf x_flagstorno = "" Then
			bEmptyValue = True
		Else
			tx_flagstorno = x_flagstorno
			Call ew_SetupDistinctValues(val_flagstorno, x_flagstorno, tx_flagstorno, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_flagstorno, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_flagstorno, "##null", EW_NULL_LABEL, False)
	bNullValue = False: bEmptyValue = False
	sSql = ew_BuildReportSql("", EW_FIELD_FLAGTRASFERTA_SQL_SELECT, EW_TABLE_SQL_WHERE, EW_TABLE_SQL_GROUPBY, EW_TABLE_SQL_HAVING, EW_FIELD_FLAGTRASFERTA_SQL_ORDERBY, "", sFilter, "")
	Set rswrk = conn.Execute(sSql)
	Do While Not rswrk.Eof
		x_flagTrasferta = rswrk("flagTrasferta")
		If IsNull(x_flagTrasferta) Then
			bNullValue = True
		ElseIf x_flagTrasferta = "" Then
			bEmptyValue = True
		Else
			tx_flagTrasferta = x_flagTrasferta
			Call ew_SetupDistinctValues(val_flagTrasferta, x_flagTrasferta, tx_flagTrasferta, False)
		End If
		rswrk.MoveNext
	Loop
	rswrk.Close
	Set rswrk = Nothing
	If bEmptyValue Then Call ew_SetupDistinctValues(val_flagTrasferta, "##empty", EW_EMPTY_LABEL, False)
	If bNullValue Then Call ew_SetupDistinctValues(val_flagTrasferta, "##null", EW_NULL_LABEL, False)

	' Initialize group count
	grpcnt = 0

	' Clone recordset
	Set rswrk = rs.Clone(1)
	Do While Not rswrk.Eof
		bValidRow = ValidRow(rswrk)
		If Not bValidRow Then bFilterApplied = True

		' Update group count
		If bValidRow Then grpcnt = grpcnt + 1
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
	If ValidRow Then ValidRow = ew_SelectedValue(sel_NomePersona, rs("NomePersona"), ftx_NomePersona, af_NomePersona)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_NomeSocieta, rs("NomeSocieta"), ftx_NomeSocieta, af_NomeSocieta)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_CodiceCliente, rs("CodiceCliente"), ftx_CodiceCliente, af_CodiceCliente)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_NomeCliente, rs("NomeCliente"), ftx_NomeCliente, af_NomeCliente)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_ProjectCode, rs("ProjectCode"), ftx_ProjectCode, af_ProjectCode)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_NomeProgetto, rs("NomeProgetto"), ftx_NomeProgetto, af_NomeProgetto)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_DescTipoProgetto, rs("DescTipoProgetto"), ftx_DescTipoProgetto, af_DescTipoProgetto)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_NomeManager, rs("NomeManager"), ftx_NomeManager, af_NomeManager)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_Date, rs("Date"), ftx_Date, af_Date)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_AnnoMese, rs("AnnoMese"), ftx_AnnoMese, af_AnnoMese)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_HourTypeCode, rs("HourTypeCode"), ftx_HourTypeCode, af_HourTypeCode)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_flagstorno, rs("flagstorno"), ftx_flagstorno, af_flagstorno)
	If ValidRow Then ValidRow = ew_SelectedValue(sel_flagTrasferta, rs("flagTrasferta"), ftx_flagTrasferta, af_flagTrasferta)
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
