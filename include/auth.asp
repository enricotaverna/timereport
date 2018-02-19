<%

' **** VIENE UTILIZZATO DAI REPORT ASP AUTOGENERATI !!! ***
' ****  NON CANCELLARE ****

If Session("userLevel") < AUTH_EXTERNAL Then
    response.redirect("/timereport/default.asp")
End If
%>

