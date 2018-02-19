<%
' Functions for ASP Report Maker 1.0+
' (C)2006 e.World Technology Ltd.

'-------------------------------------------------------------------------------
' Functions for default date format
' ANamedFormat = 0-8, where 0-4 same as VBScript
' 5 = yyyy/mm/dd format
' 6 = mm/dd/yyyy format
' 7 = dd/mm/yyyy format
' 8 = Short Date & " " & Short Time
' (where "/" is project date separator)

Function ew_FormatDateTime(ADate, ANamedFormat)
	If IsDate(ADate) Then
		If ANamedFormat >= 0 And ANamedFormat <= 4 Then
			ew_FormatDateTime = FormatDateTime(ADate, ANamedFormat)
		ElseIf ANamedFormat = 5 Then
			ew_FormatDateTime = Year(ADate) & EW_DATE_SEPARATOR & Month(ADate) & EW_DATE_SEPARATOR & Day(ADate)
		ElseIf ANamedFormat = 6 Then
			ew_FormatDateTime = Month(ADate) & EW_DATE_SEPARATOR & Day(ADate) & EW_DATE_SEPARATOR & Year(ADate)
		ElseIf ANamedFormat = 7 Then
			ew_FormatDateTime = Day(ADate) & EW_DATE_SEPARATOR & Month(ADate) & EW_DATE_SEPARATOR & Year(ADate)
		ElseIf ANamedFormat = 8 Then
			ew_FormatDateTime = FormatDateTime(ADate, 2)
			If Hour(ADate) <> 0 Or Minute(ADate) <> 0 Or Second(ADate) <> 0 Then
				ew_FormatDateTime = ew_FormatDateTime & " " & FormatDateTime(ADate, 4) & ":" & ew_ZeroPad(Second(ADate), 2)
			End If
		Else
			ew_FormatDateTime = ADate
		End If
	Else
		ew_FormatDateTime = ADate
	End If
End Function

Function ew_UnFormatDateTime(ADate, ANamedFormat)
	Dim arDateTime, arDate
	ADate = Trim(ADate & "")
	While Instr(ADate, "  ") > 0
		ADate = Replace(ADate, "  ", " ")
	Wend
	arDateTime = Split(ADate, " ")
	If UBound(arDateTime) < 0 Then
		ew_UnFormatDateTime = ADate
		Exit Function
	End If
	arDate = Split(arDateTime(0), EW_DATE_SEPARATOR)
	If UBound(arDate) = 2 Then
		If ANamedFormat = 6 Then
			ew_UnFormatDateTime = arDate(2) & "/" & arDate(0) & "/" & arDate(1)
		ElseIf ANamedFormat = 7 Then
			ew_UnFormatDateTime = arDate(2) & "/" & arDate(1) & "/" & arDate(0)
		ElseIf ANamedFormat = 5 Then
			ew_UnFormatDateTime = arDate(0) & "/" & arDate(1) & "/" & arDate(2)
		Else
			ew_UnFormatDateTime = arDateTime(0)
		End If
		If UBound(arDateTime) > 0 Then
			If IsDate(arDateTime(1)) Then ' Is time
				ew_UnFormatDateTime = ew_UnFormatDateTime & " " & arDateTime(1)
			End If
		End If
	Else
		ew_UnFormatDateTime = ADate
	End If
End Function

'-------------------------------------------------------------------------------
' Function to format currency

Function ew_FormatCurrency(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
	If IsNumeric(Expression) Then
		ew_FormatCurrency = FormatCurrency(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
	Else
		ew_FormatCurrency = Expression
	End If
End Function

'-------------------------------------------------------------------------------
' Function to format number

Function ew_FormatNumber(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
	If IsNumeric(Expression) Then
		ew_FormatNumber = FormatNumber(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
	Else
		ew_FormatNumber = Expression
	End If
End Function

'-------------------------------------------------------------------------------
' Function to format percent

Function ew_FormatPercent(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
	On Error Resume Next
	If IsNumeric(Expression) Then
		ew_FormatPercent = FormatPercent(Expression, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits)
		If Err.Number <> 0 Then
			ew_FormatPercent = FormatNumber(Expression*100, NumDigitsAfterDecimal, IncludeLeadingDigit, UseParensForNegativeNumbers, GroupDigits) & "%"
		End If
	Else
		ew_FormatPercent = Expression
	End If
End Function

'-------------------------------------------------------------------------------
' Function to Adjust SQL

Function ew_AdjustSql(str)
	Dim sWrk
	sWrk = Trim(str & "")
	sWrk = Replace(sWrk, "'", "''") ' Adjust for Single Quote
	If EW_DB_START_QUOTE = "[" Then
		sWrk = Replace(sWrk, "[", "[[]") ' Adjust for Open Square Bracket
	End If
	ew_AdjustSql = sWrk
End Function

'-------------------------------------------------------------------------------
' Function to Build Report SQL

Function ew_BuildReportSql(sTransform, sSelect, sWhere, sGroupBy, sHaving, sOrderBy, sPivot, sFilter, sSort)

	Dim sSql, sDbWhere, sDbOrderBy

	sDbWhere = sWhere
	If sDbWhere <> "" Then
		sDbWhere = "(" & sDbWhere & ")"
	End If
	If sFilter <> "" Then
		If sDbWhere <> "" Then sDbWhere = sDbWhere & " AND "
		sDbWhere = sDbWhere & "(" & sFilter & ")"
	End If	
	sDbOrderBy = sOrderBy
	If sSort <> "" Then
		If sDbOrderBy <> "" Then sDbOrderBy = sDbOrderBy & ", "
		sDbOrderBy = sDbOrderBy & sSort
	End If
	sSql = sSelect
	If sDbWhere <> "" Then sSql = sSql & " WHERE " & sDbWhere
	If sGroupBy <> "" Then sSql = sSql & " GROUP BY " & sGroupBy
	If sHaving <> "" Then sSql = sSql & " HAVING " & sHaving
	If sDbOrderBy <> "" Then sSql = sSql & " ORDER BY " & sDbOrderBy
	If sTransform <> "" And sPivot <> "" Then
		sSql = "TRANSFORM " & sTransform & " " & sSql & " PIVOT " & sPivot
	End If

	ew_BuildReportSql = sSql

End Function

'-------------------------------------------------------------------------------
' Function to Load Recordset based on Sql

Function ew_LoadRs(sSql)

	Dim rs
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.CursorLocation = EW_CURSOR_LOCATION
	rs.Open sSql, conn, 3, 1, 1 ' adOpenStatic, adLockReadOnly, adCmdText
	Set ew_LoadRs = rs
	Set rs = Nothing

End Function

'-------------------------------------------------------------------------------
' Function to Construct a crosstab field name

Function ew_CrossTabField(smrytype, smryfld, colfld, datetype, val, qc, id)
	Dim wrkval, wrkqc
	If val = "##null" Then
		wrkval = "NULL": wrkqc = ""
	ElseIf val = "##empty" Then
		wrkval = "": wrkqc = qc
	Else
		wrkval = val: wrkqc = qc
	End If
	Select Case smrytype
	Case "SUM"
		ew_CrossTabField = _
			smrytype & "(" & smryfld & "*" & _
			ew_SQLDistinctFactor(EW_DBMSNAME, colfld, datetype, wrkval, wrkqc) &_
			") As C" & id
	Case "COUNT"
		ew_CrossTabField = _
			"SUM(" &_
			ew_SQLDistinctFactor(EW_DBMSNAME, colfld, datetype, wrkval, wrkqc) &_
			") As C" & id
	Case "MIN","MAX"
		Dim aggwrk
		aggwrk = ew_SQLDistinctFactor(EW_DBMSNAME, colfld, datetype, wrkval, wrkqc)
		If EW_DBMSNAME = "ACCESS" Or EW_DBMSNAME = "MS Jet" Then
			ew_CrossTabField = smrytype & "(IIf(" & aggwrk & "=0,NULL," & smryfld & ")) As C" & id
		ElseIf (InStr(1, EW_DBMSNAME, "SQL", vbTextCompare) > 0 And InStr(1, EW_DBMSNAME, "Microsoft", vbTextCompare) > 0) Then
			ew_CrossTabField = smrytype & "(CASE " & aggwrk & " WHEN 0 THEN NULL ELSE " & smryfld & " END) As C" & id
		ElseIf InStr(1, EW_DBMSNAME, "MySQL", vbTextCompare) > 0 Then
			ew_CrossTabField = smrytype & "(IF(" & aggwrk & "=0,NULL," & smryfld & ")) As C" & id
		End If
	Case "AVG"
		Dim sumwrk, cntwrk
		sumwrk = _
			"SUM(" & smryfld & "*" & _
			ew_SQLDistinctFactor(EW_DBMSNAME, colfld, datetype, wrkval, wrkqc) & ")"
		cntwrk = _
			"SUM(" &_
			ew_SQLDistinctFactor(EW_DBMSNAME, colfld, datetype, wrkval, wrkqc) & ")"
		If EW_DBMSNAME = "ACCESS" Or EW_DBMSNAME = "MS Jet" Then
			ew_CrossTabField = "IIf(" & cntwrk & "=0,0," & sumwrk & "/" & cntwrk &") As C" & id
		ElseIf (InStr(1, EW_DBMSNAME, "SQL", vbTextCompare) > 0 And InStr(1, EW_DBMSNAME, "Microsoft", vbTextCompare) > 0) Then
			ew_CrossTabField = "(CASE " & cntwrk & " WHEN 0 THEN 0 ELSE " & sumwrk & "/" & cntwrk & " END) As C" & id
		ElseIf InStr(1, EW_DBMSNAME, "MySQL", vbTextCompare) > 0 Then
			ew_CrossTabField = "IF(" & cntwrk & "=0,0," & sumwrk & "/" & cntwrk & ") As C" & id
		End If
	End Select
End Function

'-------------------------------------------------------------------------------
' Function to construct SQL Distinct factor
' - ACCESS
' y: IIf(Year(FieldName)=1996,1,0)
' q: IIf(DatePart(""q"",FieldName,1,0)=1,1,0))
' m: (IIf(DatePart(""m"",FieldName,1,0)=1,1,0)))
' others: (IIf(FieldName=val,1,0)))
' - MS SQL
' y: (1-ABS(SIGN(Year(FieldName)-1996)))
' q: (1-ABS(SIGN(DatePart(q,FieldName)-1)))
' m: (1-ABS(SIGN(DatePart(m,FieldName)-1)))
' d: (CASE Convert(VarChar(10),FieldName,111) WHEN '1996/1/1' THEN 1 ELSE 0 END)
' - MySQL
' y: IF(YEAR(`OrderDate`)=1996,1,0))
' q: IF(QUARTER(`OrderDate`)=1,1,0))
' m: IF(MONTH(`OrderDate`)=1,1,0))

Function ew_SQLDistinctFactor(dbmsName, sFld, dateType, val, qc)

	' ACCESS
	If dbmsName = "ACCESS" Or dbmsName = "MS Jet" Then

		If dateType = "y" Then
			ew_SQLDistinctFactor = "IIf(Year(" & sFld & ")=" & val & ",1,0)"
		ElseIf dateType = "q" Or dateType = "m" Then
			ew_SQLDistinctFactor = "IIf(DatePart(""" & dateType & """," & sFld & ",1,0)=" & val & ",1,0)"
		Else
			If val = "NULL" Then
				ew_SQLDistinctFactor = "IIf(" & sFld & " IS NULL,1,0)"
			Else
				ew_SQLDistinctFactor = "IIf(" & sFld & "=" & qc & ew_AdjustSql(val) & qc & ",1,0)"
			End If
		End If

	' MS SQL
	ElseIf (InStr(1, dbmsName, "SQL", vbTextCompare) > 0 And InStr(1, dbmsName, "Microsoft", vbTextCompare) > 0) Then

		If dateType = "y" Then
			ew_SQLDistinctFactor = "(1-ABS(SIGN(Year(" & sFld & ")-" & val & ")))"
		ElseIf dateType = "q" Or dateType = "m" Then
			ew_SQLDistinctFactor = "(1-ABS(SIGN(DatePart(" & dateType & "," & sFld & ")-" & val & ")))"
		ElseIf dateType = "d" Then
			ew_SQLDistinctFactor = "(CASE Convert(VarChar(10)," & sFld & ",111) WHEN " & qc & ew_AdjustSql(val) & qc & " THEN 1 ELSE 0 END)"
		ElseIf dateType = "dt" Then
			ew_SQLDistinctFactor = "(CASE Convert(VarChar(10)," & sFld & ",120) WHEN " & qc & ew_AdjustSql(val) & qc & " THEN 1 ELSE 0 END)"
		Else
			If val = "NULL" Then
				ew_SQLDistinctFactor = "(CASE WHEN " & sFld & " IS NULL THEN 1 ELSE 0 END)"
			Else
				ew_SQLDistinctFactor = "(CASE " & sFld & " WHEN " & qc & ew_AdjustSql(val) & qc & " THEN 1 ELSE 0 END)"
			End If
		End If

	' MySQL
	ElseIf InStr(1, dbmsName, "MySQL", vbTextCompare) > 0 Then

		If dateType = "y" Then
			ew_SQLDistinctFactor = "IF(YEAR(" & sFld & ")=" & val & ",1,0)"
		ElseIf dateType = "q" Then
			ew_SQLDistinctFactor = "IF(QUARTER(" & sFld & ")=" & val & ",1,0)"
		ElseIf dateType = "m" Then
			ew_SQLDistinctFactor = "IF(MONTH(" & sFld & ")=" & val & ",1,0)"
		Else
			If val = "NULL" Then
				ew_SQLDistinctFactor = "IF(" & sFld & " IS NULL,1,0)"
			Else
				ew_SQLDistinctFactor = "IF(" & sFld & "=" & qc & ew_AdjustSql(val) & qc & ",1,0)"
			End If
		End If

	End If

End Function

'-------------------------------------------------------------------------------
' Function to evaluate summary value
'
Function ew_SummaryValue(val1, val2, ityp)
	Select Case ityp
	Case "SUM", "COUNT"
		If IsNull(val2) Or Not IsNumeric(val2) Then
			ew_SummaryValue = val1
		Else
			ew_SummaryValue = val1 + val2
		End if
	Case "MIN"
		If IsNull(val2) Or Not IsNumeric(val2) Then
			ew_SummaryValue = val1 ' Skip null and non-numeric
		ElseIf IsNull(val1) Then
			ew_SummaryValue = val2 ' Initialize for first valid value
		ElseIf val1 < val2 Then
			ew_SummaryValue = val1
		Else
			ew_SummaryValue = val2
		End If
	Case "MAX"
		If IsNull(val2) Or Not IsNumeric(val2) Then
			ew_SummaryValue = val1 ' Skip null and non-numeric
		ElseIf IsNull(val1) Then
			ew_SummaryValue = val2 ' Initialize for first valid value
		ElseIf val1 > val2 Then
			ew_SummaryValue = val1
		Else
			ew_SummaryValue = val2
		End If
	End Select
End Function

'-------------------------------------------------------------------------------
' Function to check if all values are selected
' sName: popup name

Function ew_IsSelectedAll(sName)
	Dim bSelectedAll
	bSelectedAll = Session("all_" & sName)
	If IsNull(bSelectedAll) Or bSelectedAll = "" Then
		ew_IsSelectedAll = True
	ElseIf bSelectedAll Then
		ew_IsSelectedAll = True
	Else
		ew_IsSelectedAll = False
	End If
End Function

'-------------------------------------------------------------------------------
' Function to check if the value is selected
' sName: popup name
' value: supplied value

Function ew_IsSelectedValue(sName, value, ft)
	Dim i, arSelectedValues
	arSelectedValues = Session("sel_" & sName)
	If Not IsArray(arSelectedValues) Then ew_IsSelectedValue = True: Exit Function
	For i = 0 To Ubound(arSelectedValues)
		If Left(value,2) = "@@" Or Left(arSelectedValues(i),2) = "@@" Then ' advanced filters
			If arSelectedValues(i) = value Then
				ew_IsSelectedValue = True
				Exit Function
			End If
		ElseIf ew_CompareValue(arSelectedValues(i), value, ft) Then
			ew_IsSelectedValue = True
			Exit Function
		End If
	Next
	ew_IsSelectedValue = False
End Function

'-------------------------------------------------------------------------------
' Function to set up distinct values
' ar: array for distinct values
' val: value
' label: display value
' dup: check duplicate

Sub ew_SetupDistinctValues(ar, val, label, dup)
	Dim pos, i
	If dup Then ' check duplicate
		If IsArray(ar) Then
			For i = 0 to UBound(ar,2)
				If ar(0,i) = val Then Exit Sub
			Next
		End If
	End If
	If Not IsArray(ar) Then
		Redim ar(1,0): pos = 0
	ElseIf val = "##empty" Or val = "##null" Then ' null/empty
		pos = 0 ' insert at top
		Redim Preserve ar(1, UBound(ar,2)+1)
		For i = UBound(ar,2) to 1 Step -1
			ar(0,i) = ar(0,i-1): ar(1,i) = ar(1,i-1)
		Next
	Else
		pos = UBound(ar,2)+1 ' default insert at end
		Redim Preserve ar(1, pos)
	End If
	ar(0,pos) = val: ar(1,pos) = label
End Sub

'-------------------------------------------------------------------------------
' Function to compare values based on field type

Function ew_CompareValue(v1, v2, ft)
	Select Case ft
	' Case adBigInt, adInteger, adSmallInt, adTinyInt, adUnsignedTinyInt, adUnsignedSmallInt, adUnsignedInt, adUnsignedBigInt
	Case 20, 3, 2, 16, 17, 18, 19, 21
		If IsNumeric(v1) And IsNumeric(v2) Then
			ew_CompareValue = (CLng(v1) = CLng(v2))
			Exit Function
		End If
	' Case adSingle, adDouble, adNumeric, adCurrency
	Case 4, 5, 131, 6
		If IsNumeric(v1) And IsNumeric(v2) Then
			ew_CompareValue = (CDbl(v1) = CDbl(v2))
			Exit Function
		End If
	' Case adDate, adDBDate, adDBTime, adDBTimeStamp
	Case 7, 133, 134, 135
		If IsDate(v1) And IsDate(v2) Then
			ew_CompareValue = (CDate(v1) = CDate(v2))
			Exit Function
		End If
	End Select
	ew_CompareValue = (CStr(v1&"") = CStr(v2&"")) ' treat as string
End Function

'-------------------------------------------------------------------------------
' Function to set up distinct values from advanced filter

Sub ew_SetupDistinctValuesFromFilter(ar, af)
	Dim i, val, label
	If IsArray(af) Then
		For i = 0 to UBound(af)
			val = af(i,0)
			label = af(i,1)
			Call ew_SetupDistinctValues(ar, val, label, False)
		Next
	End If
End Sub

'-------------------------------------------------------------------------------
' Function to get group value
' - Get the group value based on field type, group type and interval
' - ft: field type
' * 1: numeric, 2: date, 3: string
' - gt: group type
' * numeric: i = interval, n = normal
' * date: d = Day, w = Week, m = Month, q = Quarter, y = Year
' * string: f = first nth character, n = normal
' - intv: interval

Function ew_GroupValue(val, ft, grp, intv)
	Dim ww, q, wrkIntv
	Select Case ft
	' Case adBigInt, adInteger, adSmallInt, adTinyInt, adSingle, adDouble, adNumeric, adCurrency, adUnsignedTinyInt, adUnsignedSmallInt, adUnsignedInt, adUnsignedBigInt ' numeric
	Case 20, 3, 2, 16, 4, 5, 131, 6, 17, 18, 19, 21 ' numeric
		If Not IsNumeric(val) Then
			GroupVal = val
			Exit Function
		End If
		wrkIntv = CInt(intv)
		If wrkIntv <= 0 Then wrkIntv = 10
		Select Case grp
			Case "i": ew_GroupValue = Int(val/wrkIntv)
			Case Else: ew_GroupValue = val
		End Select
	' Case adDate, adDBDate, adDBTime, adDBTimeStamp ' date
	Case 7, 133, 134, 135 ' date
		If Not IsDate(val) Then
			ew_GroupValue = val
			Exit Function
		End If
		Select Case grp
		Case "y": ew_GroupValue = Year(val)
		Case "q": q = DatePart("q", val): ew_GroupValue = Year(val)& "|" & q
		Case "m": ew_GroupValue = Year(val) & "|" & ew_ZeroPad(Month(val), 2)
		Case "w": ww = DatePart("ww", val): ew_GroupValue = Year(val) & "|" & ew_ZeroPad(ww, 2)
		Case "d": ew_GroupValue = Year(val) & "|" & ew_ZeroPad(Month(val), 2) & "|" & ew_ZeroPad(Day(val), 2)
		Case "h": ew_GroupValue = Hour(val)
		Case "min": ew_GroupValue = Minute(val)
		Case Else: ew_GroupValue = val
		End Select
	' Case adLongVarChar, adLongVarWChar, adChar, adWChar, adVarChar, adVarWChar ' string
	Case 201, 203, 129, 130, 200, 202 ' string
		wrkIntv = CInt(intv)
		If wrkIntv <= 0 Then wrkIntv = 1
		Select Case grp
			Case "f": ew_GroupValue = Mid(val, 1, wrkIntv)
			Case Else: ew_GroupValue = val
		End Select
	Case Else
		ew_GroupValue = val ' ignore
	End Select
End Function

'-------------------------------------------------------------------------------
' Functions to display group value

Function ew_DisplayGroupValue(val, ft, grp, intv)
	Dim ar, wrkIntv
	If IsNull(val) Then
			ew_DisplayGroupValue = val
			Exit Function
	End If
	Select Case ft
	' Case adBigInt, adInteger, adSmallInt, adTinyInt, adSingle, adDouble, adNumeric, adCurrency, adUnsignedTinyInt, adUnsignedSmallInt, adUnsignedInt, adUnsignedBigInt ' numeric
	Case 20, 3, 2, 16, 4, 5, 131, 6, 17, 18, 19, 21 ' numeric
		wrkIntv = CInt(intv)
		If wrkIntv <= 0 Then wrkIntv = 10
		Select Case grp
		Case "i": ew_DisplayGroupValue = CStr(val*wrkIntv) & " - " & CStr((val+1)*wrkIntv)
		Case Else: ew_DisplayGroupValue = val
		End Select
	' Case adDate, adDBDate, adDBTime, adDBTimeStamp ' date
	Case 7, 133, 134, 135 ' date
		ar = Split(val, "|")
		Select Case grp
		Case "y": ew_DisplayGroupValue = ar(0)
		Case "q": ew_DisplayGroupValue = ew_FormatQuarter(ar(0), ar(1))
		Case "m": ew_DisplayGroupValue = ew_FormatMonth(ar(0), ar(1))
		Case "w": ew_DisplayGroupValue = ew_FormatWeek(ar(0), ar(1))
		Case "d": ew_DisplayGroupValue = ew_FormatDay(ar(0), ar(1), ar(2))
		Case "h": ew_DisplayGroupValue = ew_FormatHour(ar(0))
		Case "min": ew_DisplayGroupValue = ew_FormatMinute(ar(0))
		Case Else: ew_DisplayGroupValue = val
		End Select
	' Case adLongVarChar, adLongVarWChar, adChar, adWChar, adVarChar, adVarWChar ' string
	Case 201, 203, 129, 130, 200, 202 ' string
		ew_DisplayGroupValue = val
	Case Else
		ew_DisplayGroupValue = val ' ignore
	End Select
End Function

Function ew_FormatQuarter(y, q)
	ew_FormatQuarter = "Q" & q & "/" & y
End Function
Function ew_FormatMonth(y, m)
	ew_FormatMonth = m & "/" & y
End Function
Function ew_FormatWeek(y, w)
	ew_FormatWeek = "WK" & w & "/" & y
End Function
Function ew_FormatDay(y, m, d)
	ew_FormatDay = y & "/" & m & "/" & d
End Function
Function ew_FormatHour(h)
	If CInt(h) = 0 Then
		ew_FormatHour = "12 AM"
	ElseIf CInt(h) < 12 Then
		ew_FormatHour = h & " AM"
	ElseIf CInt(h) = 12 Then
		ew_FormatHour = "12 PM"
	Else
		ew_FormatHour = (h-12) & " PM"
	End If
End Function
Function ew_FormatMinute(n)
	ew_FormatMinute = n & " MIN"
End Function

'-------------------------------------------------------------------------------
' Function to pad zeros before number
' - m: number
' - t: length

Function ew_ZeroPad(m, t)
  ew_ZeroPad = String(t - Len(m), "0") & m
End Function

'-------------------------------------------------------------------------------
' Function to get Js data in the form of:
' - new Array(value1, text1, selected), new Array(value2, text2, selected) ...
' - value1: "value 1", text1: "text 1": selected: true|false
' name: popup name
' list: comma separated list

Function ew_GetJsData(name, ar, ft)
	Dim i
	Dim bAllSelected: bAllSelected = ew_IsSelectedAll(name)
	Dim value, jsselect, bSelected
	Dim jsdata: jsdata = ""
	If IsArray(ar) Then
		For i = 0 to UBound(ar,2)
			value = ar(0,i)
			If bAllSelected Then
				bSelected = True
			Else
				bSelected = ew_IsSelectedValue(name, value, ft)
			End If
			If bSelected Then
				jsselect = "true"
			Else
				jsselect = "false"
			End If
			If jsdata <> "" Then jsdata = jsdata & ", "
			jsdata = jsdata & "new Array(""" & ew_EscapeJs(ar(0,i)) & """, """ & ew_EscapeJs(ar(1,i)) & """, " & jsselect & ")"
		Next
	End If
	ew_GetJsData = jsdata
End Function

'-------------------------------------------------------------------------------
' Function to check if selected value

Function ew_SelectedValue(ar, val, ft, af)
	Dim i
	If Not IsArray(ar) Then
		ew_SelectedValue = True
		Exit Function
	Else
		For i = 0 to UBound(ar)
			If ar(i) = "##empty" And val = "" Then ' empty string
				ew_SelectedValue = True
				Exit Function
			ElseIf ar(i) = "##null" And IsNull(val) Then ' null value
				ew_SelectedValue = True
				Exit Function
			ElseIf Left(val,2) = "@@" Or Left(ar(i),2) = "@@" Then ' advanced filter
				If IsArray(af) Then
					ew_SelectedValue = ew_SelectedFilter(af, ar(i), val) ' process advanced filter
					If ew_SelectedValue Then Exit Function
				End If
			ElseIf ew_CompareValue(ar(i), val, ft) Then
				ew_SelectedValue = True
				Exit Function
			End If
		Next
	End If
	ew_SelectedValue = False
End Function

'-------------------------------------------------------------------------------
' Function to check for advanced filter

Function ew_SelectedFilter(ar, sel, val)
	On Error Resume Next
	Dim i, sEvalStr
	If Not IsArray(ar) Then
		ew_SelectedFilter = True
	ElseIf IsNull(val) Then
		ew_SelectedFilter = False
	Else
		For i = 0 to UBound(ar,1)
			If CStr(sel) = CStr(ar(i,0)) Then
				sEvalStr = Replace(ar(i,2), "@@Date", val)
				ew_SelectedFilter = Eval(sEvalStr)
				If Err Then
' Response.Write "sEvalStr: " & sEvalStr & ", Err: " & Err.Descrption & "<br>"
					Err.Clear
					ew_SelectedFilter = True ' assume True for this filter
				Else
					Exit Function
				End If
			End If
		Next
		ew_SelectedFilter = True
	End If
End Function

'-------------------------------------------------------------------------------
' Function to truncate Memo Field based on specified length, string truncated to nearest space or CrLf

Function ew_TruncateMemo(str, ln)

	Dim i, j, k

	If Len(str) > 0 And Len(str) > ln Then
		k = 1
		Do While k > 0 And k < Len(str)
			i = InStr(k, str, " ", 1)
			j = InStr(k, str, vbCrLf, 1)
			If i < 0 And j < 0 Then ' Not able to truncate
				ew_TruncateMemo = str
				Exit Function
			Else
				' Get nearest space or CrLf
				If i > 0 And j > 0 Then
					If i < j Then
						k = i
					Else
						k = j
					End If
				ElseIf i > 0 Then
					k = i
				ElseIf j > 0 Then
					k = j
				End If
				' Get truncated text
				If k >= ln Then
					ew_TruncateMemo = Mid(str, 1, k-1) & "..."
					Exit Function
				Else
					k = k + 1
				End If
			End If
		Loop
	Else
		ew_TruncateMemo = str
	End If

End Function

'-------------------------------------------------------------------------------
' Function to escape Js

Function ew_EscapeJs(str)
	ew_EscapeJs = Replace(str & "", "\", "\\")
	ew_EscapeJs = Replace(ew_EscapeJs, """", "\""")
	ew_EscapeJs = Replace(ew_EscapeJs, vbCr, "\r")
	ew_EscapeJs = Replace(ew_EscapeJs, vbLf, "\n")
End Function

'-------------------------------------------------------------------------------
' Function to show chart
' id: chart id
' parms: "type=1,bgcolor=FFFFFF,..."

Function ew_ShowChart(id, parms, data, width, height, align)
	Dim arParms, i
	Dim url, wrk, wrkwidth, wrkheight, wrkalign

	url = "ewchart.asp*id=" & id
	' Save parms to session
	Session(id & "_parms") = parms
	' Save chart data to session
	Session(id & "_data") = data
	If IsNumeric(width) And IsNumeric(height) Then
		wrkwidth = width: wrkheight = height
	Else
		wrkwidth = 550: wrkheight = 450 ' default
	End If
	If LCase(align) = "left" Or LCase(align)= "right" Then
		wrkalign = LCase(align)
	Else
		wrkalign = "middle" ' default
	End If

	wrk = wrk & "<script language=""JavaScript"" type=""text/javascript"">" & vbCrLf
	wrk = wrk & "<!--" & vbCrLf
	wrk = wrk & "var chartwidth = """ & wrkwidth & """;" & vbCrLf
	wrk = wrk & "var chartheight = """ & wrkheight & """;" & vbCrLf
	wrk = wrk & "var chartalign = """ & wrkalign & """;" & vbCrLf
	wrk = wrk & "var charturl = """ & url & """;" & vbCrLf
	wrk = wrk & "EW_ShowChart(chartwidth, chartheight, chartalign, charturl);" & vbCrLf
	wrk = wrk & "//-->" & vbCrLf
	wrk = wrk & "</script>" & vbCrLf

	ew_ShowChart = wrk
' Call ew_Trace(ew_ShowChart)
End Function

'-------------------------------------------------------------------------------
' Function to sort chart data

Sub ew_SortChartData(ar, opt)
	Dim i, j, tmpname1, tmpname2, tmpval, bSwap
	If opt < 1 Or opt > 4 Then Exit Sub
	If IsArray(ar) Then
		For i = 0 to UBound(ar,2) - 1
			For j = i+1 to UBound(ar,2)
				Select Case opt
				Case 1 ' X values ascending
					bSwap = (ar(0,i) > ar(0,j)) Or (ar(0,i) = ar(0,j) And ar(1,i) > ar(1,j))
				Case 2 ' X values descending
					bSwap = (ar(0,i) < ar(0,j)) Or (ar(0,i) = ar(0,j) And ar(1,i) < ar(1,j))
				Case 3 ' Y values ascending
					bSwap = (ar(2,i) > ar(2,j))
				Case 4 ' Y values descending
					bSwap = (ar(2,i) < ar(2,j))
				End Select
				If bSwap Then
				   	tmpname1 = ar(0,i): tmpname2 = ar(1,i): tmpval = ar(2,i)
				   	ar(0,i) = ar(0,j): ar(1,i) = ar(1,j): ar(2,i) = ar(2,j)
			   		ar(0,j) = tmpname1: ar(1,j) = tmpname2: ar(2,j) = tmpval
				End If
			Next
		Next
	End If
End Sub

'-------------------------------------------------------------------------------
' Function to encode chart value
Function ew_Encode(val)
	ew_Encode = Replace(val, ",", "%2C") ' encode comma
End Function

'-------------------------------------------------------------------------------
' Function for debug

Sub ew_Trace(aMsg)
	On Error Resume Next
	Dim fso, ts
	Set fso = Server.Createobject("Scripting.FileSystemObject")
	Set ts = fso.OpenTextFile(Server.MapPath("debug.txt"), 8, True)
	ts.writeline(aMsg)
	ts.Close
	Set ts = Nothing
	Set fso = Nothing
End Sub
%>
