<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!DOCTYPE html>

<script runat="server">

<%

	'Auth.CheckPermission("CONFIG", "TABLE"); *** non funziona con ASP classico ***

	'   se annulla torna indietro
	if request("cancel_from_list") <> "" then
		response.redirect("default.aspx")
	End if

	Dim	strKeyName		' name of the key field od the table
	Dim bolRecordFound

	'------------------------------------------------------
	Sub DeleteIcon( intIndex )
	'------------------------------------------------------

		Dim objRs1
		Dim aCheckTable, i
		Dim bolFound

		if session("CheckTable") = "" Then
			%><a href="lookup_list.asp?action=delete&id=<%=intIndex%>"><img src="images/icons/16x16/trash.gif" width="16" height="16" border="0"></a><%					
			Exit Sub		' no check table has been defined
		End If

		aCheckTable = split(session("CheckTable"), "_")
		
		bolFound = false
		
		For i = 0 to Ubound(aCheckTable, 1)
			' search the key field in the checktable	
			call MakeRs_view(objRs1, objConn, "SELECT " & strKeyName & " FROM " & aCheckTable(i)  & " WHERE " & strKeyName & "='" & intIndex &"'")						
													
			If objRs1.EOF = false then ' if a record has be found the lookup entry cannot be deleted
				bolFound = true
				Destroy(objRs1)
				Exit for
			End if	
			Destroy(objRs1)
		Next 

		If Not bolFound then ' if no record has be found the lookup entry can be deleted
				%><a href="lookup_list.asp?action=delete&id=<%=intIndex%>"><img src="images/icons/16x16/trash.gif" width="16" height="16" border="0"></a><%					
		else
				%><img src="images/transparent.gif" width="16" height="16" border="0"><%			
		End if		
												
	End Sub

	' --------------------------------------------

	'--- delete record
	if request.querystring("action") = "delete" then		
		call MakeConn(objConn, DATABASE )			
		' get the name of the key field
		call MakeRs_add(objRs,objConn, session("TableName") )		

		strKeyName = objRs(0).name
		call MakeRs_add(objRs,objConn,"SELECT * FROM " & session("TableName") & " where " & strKeyName & "=" & FormatStringDb(request("Id")) )				
		objRs.delete
		'--- Clear open connections	
		destroy(objRs)
		destroy(objConn)				
		response.redirect("lookup_list.asp?TableName=" & session("TableName") )
	End if


	'--- Initialize values
	if request("init") = "true" then		
	
		session("TableName") = ""	' name of the checktable
		session("FieldNumber") = ""	' number of fields to be dispalyed on the list
		session("SortField") = ""		' Field by which the list is sorted
		session("CheckTable") = ""	' if used name of the cross reference table (e.g. for author<->book)
'		session("FieldName") = ""	' in all the other cases name of the field within the book table containg the lookup index
	
		if request("TableName") <> "" then session("TableName") = request("TableName")
		if request("CheckTable") <> "" then session("CheckTable") = request("CheckTable")
'		if request("FieldName") <> "" then session("FieldName") = request("FieldName")
		if request("SortField") <> "" then session("SortField") = request("SortField")
		if request("FieldNumber") <> "" then session("FieldNumber") = request("FieldNumber")
	
	End if		
	
	'--- Get the records
	Dim aRecord			' contains the records
	Dim i
	
	Call MakeConn(objConn, DATABASE)
	
	If  session("SortField") = "" then
		Call MakeRs_view(objRS, objConn,  "SELECT * FROM " & session("TableName") )
	else
		Call MakeRs_view(objRS, objConn,  "SELECT * FROM " & session("TableName")  & " ORDER BY " & session("SortField") )
	End If	
	
	bolRecordFound = false
	
	if objRS.EOF <> true then
		aRecord = objRS.getrows	' fetch the record into the array
		bolRecordFound = true
	End If
			
	strKeyName = objRS(0).name
		
%>

</script>


<html><!-- InstanceBegin template="/Templates/common.dwt" codeOutsideHTMLIsLocked="false" -->
<!--#include virtual="/timereport/include/auth.asp" -->
<!--#include virtual="/timereport/include/common.asp" -->

<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Lista valori</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

	<div id="TopStripe"></div>
	
	<div id="MainWindow">

	<div id="FormWrap"> 
	
<form name="form1" method="get" action="lookup_detail.asp" class="StandardForm">

		<!-- *** TITOLO FORM ***  --> 
		<div class="formtitle">Edit Tabella</div> 

		<table class="TabellaLista">
<%
	if bolRecordFound Then ' at least one record exists	
	
		Dim intCounter          	
		intCounter = 0
		   
		While ( intCounter <= Ubound(aRecord, 2) ) 

		if ( ( intCounter mod 2 ) = 0 ) Then
			response.Write("<tr class=GV_row>")
		else
			response.Write("<tr class=GV_row_alt>")
		End if

		For i = 1 to session("FieldNumber")  
%>	
	  <td>      	
<%
				' if the record is a counter get the description from the associated lookup table
				If instr( Ucase(objRS(i).name) , "_ID") <> 0 Then	
						response.write(  GetDescription( objRS(i).name, aRecord(i, intCounter) ) )
					else
						response.write( aRecord(i, intCounter) )
					End If	      		
%>      	     	
		</td>
<%
			Next
%>      
	  <td nowrap width="10%"> <div align="center"><a href="lookup_detail.asp?action=update&Id=<%=aRecord(0, intCounter)%>"> 
		  <img src="images/icons/16x16/modifica.gif" width="16" height="16" border="0"></a>&nbsp;&nbsp; 
<% 
			call DeleteIcon( aRecord(0, intCounter) ) 
%>
		</div></td>
	</tr>
<% 
			IntCounter = IntCounter + 1  		
		Wend

	End If 'if NOT objRS.EOF Then ' at least one record exists
	
%>
  </table>
				<div class="buttons"> 
					<input type="submit" name="insert" value=<%= CREATE_TXT %> class="orangebutton">
					<input name="cancel_from_list" type="submit" class="greybutton" value=<%= CANCEL_TXT %>>
				</div>
</form>

<%
		Destroy(objRS)	
		Destroy(objConn)

    	
%>	

	</div>  <!-- END FormWrap-->

	</div> <!-- END MainWindow -->

	<!-- **** FOOTER **** -->  
	<div id="WindowFooter">       
		<div ></div>        
		<div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
		<div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
		<div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
	 </div>

</body>
</html>
