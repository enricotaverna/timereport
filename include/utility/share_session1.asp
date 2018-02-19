<%@ Language=VBScript %>

<html>

<TITLE>ASPPage2.asp</TITLE>

<%
' We graf all the session variable names/values and stick them in a form
' and then we submit the form to our receiving ASP.NET page (ASPNETPage1.aspx)...
Response.Write("<form name=t id=t action=share_session2.aspx method=post >")

For each Item in Session.Contents

    if item = "UserLevel" or _ 
       item = "BetaTester" or _
       item = "CartaCreditoAziendale" or _
       item = "ColorScheme" or _
       item = "ForcedAccount" or _
       item = "UserId" or _
       item = "persons_id" or _
       item = "ExpensesProfile_id" or _
       item = "RefreshRicevuteBuffer" or _
       item = "lingua" or _
       item = "debug" or _
       item = "CutoffDate" then 
        Response.Write("<input type=hidden name=" & Item)
        Response.Write( " value=" & Session.Contents(item) & " >")
    End if

'   se nome codifica la URL per non perdere lo spazio tra nome e cognome
    if item = "UserName" then 
        Response.Write("<input type=hidden name=" & Item)
        Response.Write( " value=" & server.URLEncode(Session.Contents(item)) & " >")
    End if    
next

       Response.Write("<input type=submit name=submit")


Response.Write("</FORM>")

Response.Write("<script language=JavaScript>t.submit();</script>")
%>

</html>
