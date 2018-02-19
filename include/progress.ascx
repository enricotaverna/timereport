<script language="VB" runat="server">

    ' **** Utilizzato su main screen per progress bar
    
    ' I've rolled all three types (HTML, Smooth, and Chunked) into one control.
    ' There's a function to build each type.  They're all pretty similar, but
    ' the details vary enough to make integrating them difficult.  The Page_Load
    ' routine acts as a traffic cop of sorts and directs execution to the
    ' appropriate function based upon the style choosen.  Since the "IE-esque"
    ' style has the least user-friendly name, I've made it the default and any
    ' time the control is passed an unrecognized style name, it reverts back
    ' to the "IE-esque" style.

	Public PercentComplete As Single  = 0    ' 0.00% to 100.00%
	Public Style           As String  = "ieesque" ' {html|IEESQUE|bluegrey|ie|classic}
	Public Width           As Short   = 150  ' in pixels

	Sub Page_Load(Source As Object, E As EventArgs)
		Dim strProgressBarHtml As String

		Select Case LCase(Style)
			Case "html"
				strProgressBarHtml = BuildProgressBarHtmlTable(PercentComplete, Width)
			Case "ie", "classic" ' chunked styles
				strProgressBarHtml = BuildProgressBarChunked(PercentComplete, Style, Width)
			Case Else ' smooth styles ("bluegrey", "ieesque")
				strProgressBarHtml = BuildProgressBarSmooth(PercentComplete, Style, Width)
		End Select

		litProgressBar.Text = strProgressBarHtml
	End Sub

	Function BuildProgressBarHtmlTable(sglPercentComplete As Single, intWidth As Integer) As String
		Dim intBarLength  As Short
		Dim sbDisplayHtml As New StringBuilder

		If 0 <= sglPercentComplete And sglPercentComplete <= 100 Then
			' Compensate for the width of the table border
			intBarLength = intWidth - 4

			sbDisplayHtml.Append("<table border=""1"" cellspacing=""0"" cellpadding=""0""><tr><td>")
			sbDisplayHtml.Append("<table width=""" & intBarLength & """ border=""0"" cellspacing=""0"" cellpadding=""0"">")
			sbDisplayHtml.Append("<tr><td width=""" & System.Math.Round(sglPercentComplete * intBarLength / 100) & """ style=""background-color:#0000FF"">&nbsp;</td><td>&nbsp;</td></tr>")
			sbDisplayHtml.Append("</table>")
			sbDisplayHtml.Append("</td></tr></table>")
		End If

		BuildProgressBarHtmlTable = sbDisplayHtml.ToString()
	End Function

	Function BuildProgressBarChunked(sglPercentComplete As Single, strStyleName As String, intWidth As Integer) As String
		Dim strImageBaseName As String

		Dim intImageHeight     As Short
		Dim intImageLeftWidth  As Short
		Dim intImageRightWidth As Short
		Dim intImageChunkWidth As Short

		Dim intChunksTotal  As Short
		Dim intChunksFilled As Short
		Dim I As Short

		Dim sbDisplayHtml As New StringBuilder

		Select Case LCase(strStyleName)
			Case "classic"
                strImageBaseName = "/timereport/images/progress_classic_"
				intImageHeight     = 16
				intImageLeftWidth  = 2
				intImageRightWidth = 2
				intImageChunkWidth = 10
			Case Else ' "ie"
				strImageBaseName   = "/timereport/images/progress_ie_"
				intImageHeight     = 17
				intImageLeftWidth  = 4
				intImageRightWidth = 4
				intImageChunkWidth = 8
		End Select

		' Since we no longer have the luxury of changing the parameters based
		' on the type of bar requested, we need to calculate the number of chunks
		' to display based on the style info and the amount of space (pixels) we
		' have to display the bar.  Using this method we should always get as
		' many chunks as we can fit without going over the allotted space.
		intChunksTotal = (intWidth - (intImageLeftWidth + intImageRightWidth)) \ intImageChunkWidth

		If 0 <= sglPercentComplete And sglPercentComplete <= 100 Then
			intChunksFilled = System.Math.Round(sglPercentComplete * intChunksTotal / 100)

			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "left.gif"" border=""0"" height=""" & intImageHeight & """ width=""" & intImageLeftWidth & """>")
			For I = 1 To intChunksTotal
				If I <= intChunksFilled Then
					sbDisplayHtml.Append("<img src=""" & strImageBaseName & "full.gif""  border=""0"" height=""" & intImageHeight & """ width=""" & intImageChunkWidth & """ alt=""" & sglPercentComplete &  "%"">")
				Else
					sbDisplayHtml.Append("<img src=""" & strImageBaseName & "empty.gif"" border=""0"" height=""" & intImageHeight & """ width=""" & intImageChunkWidth & """ alt=""" & (100 - sglPercentComplete) &  "%"">")
				End If
			Next
			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "right.gif"" border=""0"" height=""" & intImageHeight & """ width=""" & intImageRightWidth & """>")
		End If
		BuildProgressBarChunked = sbDisplayHtml.ToString()
	End Function

	Function BuildProgressBarSmooth(sglPercentComplete As Single, strStyleName As String, intWidth As Integer) As String
		Dim strImageBaseName   As String
		Dim intImageHeight     As Short
		Dim intImageLeftWidth  As Short
		Dim intImageRightWidth As Short
		Dim intBarLength       As Short
		Dim sbDisplayHtml      As New StringBuilder

		Select Case LCase(strStyleName)
			Case "bluegrey"
                strImageBaseName = "/timereport/images/progress_bluegrey_"
				intImageHeight     = 16
				intImageLeftWidth  = 3
				intImageRightWidth = 3
			Case Else ' "ieesque"
				strImageBaseName   = "/timereport/images/progress_ie7_"
				intImageHeight     = 17
				intImageLeftWidth  = 4
				intImageRightWidth = 4
		End Select

		If 0 <= sglPercentComplete And sglPercentComplete <= 100 Then
			' Compensate for the width of the two end images
			intBarLength = intWidth - (intImageLeftWidth + intImageRightWidth)

			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "left.gif""  border=""0"" height=""" & intImageHeight & """ width=""" & intImageLeftWidth & """>")
			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "full.gif""  border=""0"" height=""" & intImageHeight & """ width=""" & System.Math.Round(sglPercentComplete * intBarLength / 100) & """ alt=""" & sglPercentComplete &  "%"">")
			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "empty.gif"" border=""0"" height=""" & intImageHeight & """ width=""" & (intBarLength - System.Math.Round(sglPercentComplete * intBarLength / 100)) &  """ alt=""" & (100 - sglPercentComplete) &  "%"">")
			sbDisplayHtml.Append("<img src=""" & strImageBaseName & "right.gif"" border=""0"" height=""" & intImageHeight & """ width=""" & intImageRightWidth & """>")
		End If

		BuildProgressBarSmooth = sbDisplayHtml.ToString()
	End Function
</script>
<asp:Literal id="litProgressBar" runat="server" />