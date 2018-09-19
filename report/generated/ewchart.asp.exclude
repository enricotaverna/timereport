<%@ CodePage=65001 %>
<% Option Explicit %>
<%
' default use utf-8
Response.CharSet = "utf-8"
Response.ContentType = "text/xml"

' No cache
Response.Expires = 0
Response.ExpiresAbsolute = Now() - 1
Response.AddHeader "pragma", "no-cache"
Response.AddHeader "cache-control", "private, no-cache, no-store, must-revalidate"

' ewchart parameters
Dim ewChartType, ewChartBgColor
Dim ewChartCaption
Dim ewChartBorderLeftColor, ewChartBorderTopColor, ewChartBorderBottomColor, ewChartBorderRightColor
Dim ewChartChartBgColor, ewChartChartBorderColor
Dim ewChartNumGridLines, ewChartGridLineColor
Dim ewChartXAxisName, ewChartXAxisNameRotated, ewChartXAxisValueMaxChar, ewChartXAxisValueRotation
Dim ewChartYAxisName, ewChartYAxisNameRotated, ewChartYAxisMinValue, ewChartYAxisMaxValue
Dim ewChartShowNames, ewChartShowValues, ewChartShowHover

Dim ewChartAlpha
Dim ewChartColorPalette
Dim ewChartCssUrl
%>
<%
'-------------------------------
'  Default chart parameters
'-------------------------------

' Chart type & bg color
ewChartType = "1"
ewChartBgColor = ""

' Chart caption
ewChartCaption = "Chart"

' Chart border colors
ewChartBorderLeftColor = ""
ewChartBorderTopColor = ""
ewChartBorderBottomColor = ""
ewChartBorderRightColor = ""

' Chart colors
ewChartChartBgColor = ""
ewChartChartBorderColor = ""

' Grid line
ewChartNumGridLines = "3"
ewChartGridLineColor = ""

' Chart X, Y parameters
ewChartXAxisName = "X Axis Name"
ewChartXAxisNameRotated = "0"
ewChartXAxisValueMaxChar = "10"
ewChartXAxisValueRotation = "0"
ewChartYAxisName = "Y Axis Name"
ewChartYAxisNameRotated = "0"
ewChartYAxisMinValue = "0"
ewChartYAxisMaxValue = "0"

' Show names/values/hover
ewChartShowNames = "0"
ewChartShowValues = "0"
ewChartShowHover = "0"

' Chart alpha
ewChartAlpha = "50"

' Chart Color Palette
ewChartColorPalette = ""

' Chart Css Url
ewChartCssUrl = ""
%>
<%
Dim cht_id
Dim cht_type, cht_bgcolor
Dim cht_caption
Dim cht_borderleftcolor, cht_bordertopcolor, cht_borderbottomcolor, cht_borderrightcolor
Dim cht_chartbgcolor, cht_chartbordercolor
Dim cht_numgridlines, cht_gridlinecolor
Dim cht_xaxisname, cht_xaxisnamerotated, cht_xaxisvaluemaxchar, cht_xaxisvaluerotation
Dim cht_yaxisname, cht_yaxisnamerotated, cht_yaxisminvalue, cht_yaxismaxvalue
Dim cht_shownames, cht_showvalues, cht_showhover
Dim cht_cssurl

Dim cht_alpha, cht_colorpalette

' Get chart id
cht_id = Request.QueryString("id")

' Get chart configuration from Session
Dim parms, arParms
parms = Session(cht_id & "_parms")
arParms = Split(parms, ",")

' Chart type & bg color
cht_type = LoadParm("type")
If cht_type <> "" Then ewChartType = cht_type
cht_bgcolor = LoadParm("bgcolor")
If cht_bgcolor <> "" Then ewChartBgColor = cht_bgcolor

' Chart caption
cht_caption = LoadParm("caption")
If cht_caption <> "" Then ewChartCaption = Decode(cht_caption)

' Chart border colors
cht_borderleftcolor = LoadParm("borderleftcolor")
If cht_borderleftcolor <> "" Then ewChartBorderLeftColor = cht_borderleftcolor
cht_bordertopcolor = LoadParm("bordertopcolor")
If cht_bordertopcolor <> "" Then ewChartBorderTopColor = cht_bordertopcolor
cht_borderbottomcolor = LoadParm("borderbottomcolor")
If cht_borderbottomcolor <> "" Then ewChartBorderBottomColor = cht_borderbottomcolor
cht_borderrightcolor = LoadParm("borderrightcolor")
If cht_borderrightcolor <> "" Then ewChartBorderRightColor = cht_borderrightcolor

' Chart colors
cht_chartbgcolor = LoadParm("chartbgcolor")
If cht_chartbgcolor <> "" Then ewChartChartBgColor = cht_chartbgcolor
cht_chartbordercolor = LoadParm("chartbordercolor")
If cht_chartbordercolor <> "" Then ewChartChartBorderColor = cht_chartbordercolor

' Grid Line
cht_numgridlines = LoadParm("numgridlines")
If cht_numgridlines <> "" Then ewChartNumGridLines = cht_numgridlines
cht_gridlinecolor = LoadParm("gridlinecolor")
If cht_gridlinecolor <> "" Then ewChartGridLineColor = cht_gridlinecolor

' Chart X, Y parameter
cht_xaxisname = LoadParm("xaxisname")
If cht_xaxisname <> "" Then ewChartXAxisName = Decode(cht_xaxisname)
cht_xaxisnamerotated = LoadParm("xaxisnamerotated")
If cht_xaxisnamerotated <> "" Then ewChartXAxisNameRotated = cht_xaxisnamerotated
cht_xaxisvaluemaxchar = LoadParm("xaxisvaluemaxchar")
If cht_xaxisvaluemaxchar <> "" Then ewChartXAxisValueMaxChar = cht_xaxisvaluemaxchar
cht_xaxisvaluerotation = LoadParm("xaxisvaluerotation")
If cht_xaxisvaluerotation <> "" Then ewChartXAxisValueRotation = cht_xaxisvaluerotation * -1
cht_yaxisname = LoadParm("yaxisname")
If cht_yaxisname <> "" Then ewChartYAxisName = Decode(cht_yaxisname)
cht_yaxisnamerotated = LoadParm("yaxisnamerotated")
If cht_yaxisnamerotated <> "" Then ewChartYAxisNameRotated = cht_yaxisnamerotated
cht_yaxisminvalue = LoadParm("yaxisminvalue")
If cht_yaxisminvalue <> "" Then ewChartYAxisMinValue = cht_yaxisminvalue
cht_yaxismaxvalue = LoadParm("yaxismaxvalue")
If cht_yaxismaxvalue <> "" Then ewChartYAxisMaxValue = cht_yaxismaxvalue

' Show names/values/hover
cht_shownames = LoadParm("shownames")
If cht_shownames <> "" Then ewChartShowNames = cht_shownames
cht_showvalues = LoadParm("showvalues")
If cht_showvalues <> "" Then ewChartShowValues = cht_showvalues
cht_showhover = LoadParm("showhover")
If cht_showhover <> "" Then ewChartShowHover = cht_showhover

' Chart alpha
cht_alpha = LoadParm("alpha")
If cht_alpha <> "" Then ewChartAlpha = cht_alpha

' Color palette
cht_colorpalette = LoadParm("colorpalette")
If cht_colorpalette <> "" Then ewChartColorPalette = cht_colorpalette

' Chart Css Url
cht_cssurl = LoadParm("cssurl")
If cht_cssurl <> "" Then ewChartCssUrl = cht_cssurl

Dim sChartContent
sChartContent = ChartXml(cht_id)
' Write utf-8 encoding
Response.Write "<?xml version=""1.0"" encoding=""utf-8"" ?>"
' Write content
Response.Write sChartContent

Function LoadParm(key)
	Dim i, arVal
	If Request.QueryString(key).Count > 0 Then
		LoadParm = Request.QueryString(key)
		Exit Function
	Else
		For i = 0 to UBound(arParms)
			arVal = Split(arParms(i), "=")
			If UBound(arVal) = 1 Then
				If LCase(arVal(0)) = LCase(key) Then
					LoadParm = arVal(1)
					Exit Function
				End If
			End If
		Next
	End If
	LoadParm = ""
End Function

Function ChartXml(id)
	Dim wrk, chartdata, i, maxval
	Dim name, val, color, alpha, link

	chartdata = Session(id & "_data") ' Load chart data from Session

	If IsArray(chartdata) Then
		If UBound(chartdata,1) = 2 Then
			maxval = 0
			For i = 0 to UBound(chartdata,2)
				If chartdata(2,i) > maxval Then maxval = chartdata(2,i)
			Next
			If cht_yaxismaxvalue = "" Or IsNull(cht_yaxismaxvalue) Then
				ewChartYAxisMaxValue = maxval
				Call GetBound(ewChartYAxisMinValue, ewChartYAxisMaxValue)
			End If
			wrk = ChartHeader(1) ' Get chart header
			For i = 0 to UBound(chartdata,2)
				name = chartdata(0,i)
				If IsNull(name) Then
					name = "(Null)"
				ElseIf name = "" Then
					name = "(Empty)"
				End If
				color = GetPaletteColor(i)
				If chartdata(1,i) <> "" Then name = name & ", " & chartdata(1,i)
				If IsNull(chartdata(2,i)) Then
					val = 0
				Else
					val = CLng(chartdata(2,i))
				End If
				wrk = wrk & ChartContent(name, val, color, ewChartAlpha, link) ' Get chart content
			Next
			wrk = wrk & ChartHeader(2) ' Get chart footer
		End If
	End If

	ChartXml = wrk
' Call Trace(ChartXml)
End Function

Function GetPaletteColor(i)
	Dim arColor
	arColor = Split(ewChartColorPalette, "|")
	GetPaletteColor = arColor(i Mod (UBound(arColor)+1))
End Function

Function ColorCode(c)
	Dim color
	If c <> "" Then
		' remove #
		color = Replace(c, "#", "")
		' fill to 6 digits
		ColorCode = String(6 - Len(color), "0") & color
	Else
		ColorCode = ""
	End If
End Function

Sub GetBound(min, max)
	Dim maxp10, minp10, p10, intv, lower, upper
	If max = 0 Then
		maxp10 = 0
	Else
		maxp10 = Int(Log(Abs(max)) / Log(10))
	End If
	If min = 0 Then
		minp10 = 0
	Else
		minp10 = Int(Log(Abs(min)) / Log(10))
	End If
	p10 = minp10
	If maxp10 > p10 Then p10 = maxp10
	intv = 10^p10
	If Abs(max) / intv < 2 And Abs(min) / intv < 2 Then
		p10 = p10 - 1
		intv = 10^p10
	End If
	upper = (Int(max / intv) + 1) * intv
	If min < 0 Then
		lower = Int(min / intv) * intv
	Else
		lower = 0
	End If
	If max < 0 Then
		upper = 0
	End If
	min = lower
	max = upper
End Sub

Function ChartHeader(typ)
	Dim wrk
	If typ = 1 Then
		wrk = "<ewchart"
		Call WriteAtt(wrk, "type", ewChartType)
		Call WriteAtt(wrk, "bgcolor", ColorCode(ewChartBgColor))
		Call WriteAtt(wrk, "caption", ewChartCaption)
		Call WriteAtt(wrk, "borderleftcolor", ColorCode(ewChartBorderLeftColor))
		Call WriteAtt(wrk, "bordertopcolor", ColorCode(ewChartBorderTopColor))
		Call WriteAtt(wrk, "borderbottomcolor", ColorCode(ewChartBorderBottomColor))
		Call WriteAtt(wrk, "borderrightcolor", ColorCode(ewChartBorderRightColor))
		Call WriteAtt(wrk, "chartbgcolor", ColorCode(ewChartChartBgColor))
		Call WriteAtt(wrk, "chartbordercolor", ColorCode(ewChartChartBorderColor))
		Call WriteAtt(wrk, "numgridlines", ewChartNumGridLines)
		Call WriteAtt(wrk, "gridlinecolor", ColorCode(ewChartGridLineColor))
		Call WriteAtt(wrk, "xaxisname", ewChartXAxisName)
		Call WriteAtt(wrk, "xaxisnamerotated", ewChartXAxisNameRotated)
		Call WriteAtt(wrk, "xaxisvaluemaxchar", ewChartXAxisValueMaxChar)
		Call WriteAtt(wrk, "xaxisvaluerotation", ewChartXAxisValueRotation)
		Call WriteAtt(wrk, "yaxisname", ewChartYAxisName)
		Call WriteAtt(wrk, "yaxisnamerotated", ewChartYAxisNameRotated)
		Call WriteAtt(wrk, "yaxisminvalue", ewChartYAxisMinValue)
		Call WriteAtt(wrk, "yaxismaxvalue", ewChartYAxisMaxValue)
		Call WriteAtt(wrk, "shownames", ewChartShowNames)
		Call WriteAtt(wrk, "showvalues", ewChartShowValues)
		Call WriteAtt(wrk, "showhover", ewChartShowHover)
		Call WriteAtt(wrk, "cssurl", ewChartCssUrl)
		wrk = wrk & ">"
	Else
		wrk = "</ewchart>"
	End If
	ChartHeader = wrk
End Function

Function ChartContent(name, val, color, alpha, lnk)
	Dim wrk
	wrk = "<data"
	Call WriteAtt(wrk, "name", name)
	Call WriteAtt(wrk, "value", val)
	Call WriteAtt(wrk, "color", ColorCode(color))
	Call WriteAtt(wrk, "alpha", alpha)
	Call WriteAtt(wrk, "link", lnk)
	wrk = wrk & " " & "/>"
	ChartContent = wrk
End Function

Sub WriteAtt(str, name, val)
	If val <> "" Then
		str = str & " " & name & "=""" & XmlEncode(val) & """"
	End If
End Sub

Function XmlEncode(val)
	Dim wrk
	wrk = val & ""
	wrk = Replace(wrk, "&", "&amp;") ' replace &
	wrk = Replace(wrk, "<", "&lt;") ' replace <
	wrk = Replace(wrk, ">", "&gt;") ' replace >
	XMLEncode = Replace(wrk, """", "&quot;") ' replace "
End Function

' Decode the original value
Function Decode(src)
	Decode = Replace(src, "%2C", ",")
End Function

' Function for debug
Sub Trace(aMsg)
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