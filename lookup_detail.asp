<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<%

    'Auth.CheckPermission("CONFIG", "TABLE");  *** non funziona con ASP classico ***

	Dim strMode, fld
	Dim strKeyField	' dinamically determine the key field name
	Dim bolError		' Used when there's an error in updating to return to the datail page
	
'   se annulla torna indietro
	if request("cancel_from_list") <> "" then
		response.redirect("default.asp")
	End if

	if request.form("cancel") <> "" then
		response.redirect("lookup_list.asp?TableName=" & session("TableName"))
	End If 

'	Pagina richiamata da se stessa, aggiorna o inserisce il record quindi ritorna alla pagina lista
	if request.form("update") <> "" or request.form("insert") <> "" then
		call MakeConn(objConn, DATABASE)	
		
		' if the record is to be modified fetch it, otherwise creates a new one
		if request.form("update") <> "" then
			call MakeRs_view(objRs,objConn,session("TableName") )		' determine the name of the key field
			strKeyField = objRs(0).name
			call MakeRs_add(objRs,objConn,"SELECT * FROM " & session("TableName") & "  where " & strKeyField & "=" & FormatStringDb(request("id")) )	
		else
			call MakeRs_add(objRs,objConn, session("TableName") )	
			objRs.addnew
		End if

		on error resume next

		' scan all the fields in the recordset and assign value passed as parameters
		For each fld in objRs.fields	
		
			if fld.properties("IsAutoIncrement") = false then	' skip the autocounter			
				select case fld.type
					case adBoolean
						if len(request.form(fld.name)) then objRs(fld.name) = True else objRs(fld.name) = False
					case adLongVarBinary
						'noop
					case adDate
						if ( request.form(fld.name) = "" or request.form(fld.name) = "0" ) and (fld.attributes and adFldIsNullable) = adFldIsNullable and bConvertDateNull then
							objRs(fld.name) = NULL
						else
							if isDate(request.form(fld.name)) then 
								objRs(fld.name) = request.form(fld.name)
							End if
						end if
					case adSmallInt, adInteger, adCurrency, adUnsignedTinyInt, adDouble, adSingle 
						if ( request.form(fld.name) = "" or request.form(fld.name) = "0" ) and (fld.attributes and adFldIsNullable) = adFldIsNullable and bConvertNumericNull then
							objRs(fld.name) = NULL
						else
							if isNumeric(request.form(fld.name)) then 
								objRs(fld.name) = request.form(fld.name)
							end if						
						end if
					case else
						if request.form(fld.name) = "" and (fld.attributes and adFldIsNullable) = adFldIsNullable and bConvertNull then
						    objRs(fld.name) = NULL
						else
						    objRs(fld.name) = request.form(fld.name)
						end if						
				end select		
			End if	
		Next	
		
		objRS.update
'		Clear open connections	
		destroy(objRs)
		destroy(objConn)
		
		if err <> 0 then
				response.write "<br><br>"
				response.write "<strong>Errore</strong> in aggiornamento.<br>"
				response.write "Descrizione: " & err.description & "<br>"
				err = 0
				bolError = true
				on error goto 0
		else	
        	     response.redirect("lookup_list.asp?TableName=" & session("TableName"))	
		End If
	End if	

	'	Pagina richiamata dalla lista: verifica con quale modalità la pagina è stata chiamata 
	if request.querystring("action") = "update" or bolError then
		strMode = "update"
	else
		strMode = "insert"
	End if
'	Pagina richiamata in modalità aggiornamento
	if strMode = "update" then
		call MakeConn(objConn, DATABASE)
		call MakeRs_view(objRs,objConn,session("TableName") )		' determine the name of the key field
		strKeyField = objRs(0).name
		call MakeRs_add(objRs,objConn,"SELECT * FROM " & session("TableName") & "  where " & strKeyField & "=" & FormatStringDb(request("Id")) )	
	else
		call MakeConn(objConn, DATABASE)	
		call MakeRs_add(objRs,objConn,session("TableName"))		
	End if

function strDefault(strField, strFieldType)

	if strMode = "update" then
		strDefault = objRs.fields(strField)
	else	
		if strFieldType <> adBoolean then
			strDefault = ""
		else
			strDefault = false
		End If		
	End if

End function

%>

<html><!-- InstanceBegin template="/Templates/common.dwt" codeOutsideHTMLIsLocked="false" -->
<!--#include virtual="/timereport/include/auth.asp" -->
<!--#include virtual="/timereport/include/common.asp" -->

<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Dettaglio</title>
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

	<form name="form1" method="post" action="lookup_detail.asp"  class="StandardForm">
        
        <!-- *** TITOLO FORM ***  --> 
        <div class="formtitle">Edit Form</div> 

          <% 
       		Dim sValue, flag, intFieldSize, strLookUpTable, objRs1, objConn1, flagnbh
       		Dim strSortBy
       		
       		For each fld in objRs.fields       
       		'	Skip the Id field
			If fld.properties("IsAutoIncrement") = false then
       %>

        <!-- *** TEXT BOX ***  -->         
        <div class="input nobottomborder"> 
        
        <div class="inputtext"><%=fld.name%></div> 

              <% 
            		sValue = strDefault(fld.name, fld.type)
            	      		            		
'			Analizza il tipo di campo e genera il controllo corrispondente            	
            		select case fld.type 

				case adLongVarWChar	'memo
					response.write "<div class=inputcontent><textarea class=""Inputcontent"" cols=72 rows=5 name=""" & fld.name & """>" & sValue & "</textarea></div>"

				case adBoolean ' booleano
						response.write "<input type=""checkbox"" name=""" & fld.name & """"
						'Changed sValue to rs(fld.name) which may cause incorrect display when
						'HTML Encoding is True						
						if sValue = true then
							response.write " checked></div>"
						else
							response.write "></div>"
						end if

					case else
'					Replace quotation marks with html &quot;
					if sValue <> "" then sValue = replace(sValue, """", "&quot;")

					select case fld.type

						case adSmallInt, adInteger, adCurrency, adUnsignedTinyInt, adDBDate, adDBTime, adDBTimeStamp, 202, 130
							
							'-[2]- Added by Danival
							flag = false
								
							'Based on field naming convention checks if there's a lookup table
							If instr(Ucase(fld.name), "_ID") <> 0 Then								
								flag = true
								response.write "<div class=InputcontentDDL style=""width:200px""><select name=""" & fld.name &  """>"
								Response.Write ("<option value=0> nessun valore </option>")
								strLookUpTable = left(fld.name, instr(Ucase(fld.name), "_ID") - 1)										
								
								'open connection to load the values
								call MakeConn(objConn1, DATABASE)	
								' get the name of the second field to sort the table
								call MakeRs_add(objRs1,objConn1, strLookUpTable) 
								strSortBy = objRs1(1).name
																
								' fetch the records
								call MakeRs_add(objRs1,objConn1,"SELECT * FROM " & strLookUpTable &  " ORDER BY " & strSortBy )	
												
								do while not objRs1.eof
								'	check for selected value
									if (len(svalue) > 0 and len (objRs1(0)) > 0) then 
										if  cint(sValue) = cint(objRs1(0)) then
								   			flagnbh = " selected"
										else
											flagnbh = ""
										end if
									End if
'									Se il codice è il progetto viene visualizzato sia codice che nome
									if Ucase(fld.name) = "PROJECTS_ID" Then 										
										Response.Write "<option value="""  & objRs1.fields(0).value &"""" &flagnbh & ">" & objRs1.fields(1).value & " : " & objRs1.fields(2).value &"</option>"									
									else
										Response.Write "<option value="""  & objRs1.fields(0).value &"""" &flagnbh & ">" & objRs1.fields(1).value &"</option>"
									End if										
									objRs1.movenext
								loop
								Response.Write "</select></div> </div>   "										
							End If
																
							if flag = false then
								response.write "<div class=inputcontent><input size=70  type=""text"" name=""" & fld.name &  """ value=""" & sValue & """></div> </div>   "
							end if	
							'-[2]- End Addition

							' campo data
							case adDate
								response.write "<div class=inputcontent><input size=""10"" type=""text"" name=""" & fld.name &  """ value=""" & sValue & """ maxlength=""10"" ></div> </div>   "

							case else
								if fld.definedsize < 70 Then
									intFieldSize = fld.definedsize
								else
									intFieldSize = 70
								End if
								response.write "<div class=inputcontent><input size=""" & intFieldSize & """ type=""text"" name=""" & fld.name &  """ value=""" & sValue & """ maxlength=""" & fld.definedsize & """></div> </div>   "
						end select
				end select    
            	End if     %> 	            
         <%   Next 
        %>

        <input type="hidden" name="id" value="<%=request("Id")%>">
                      			          
        <div class="buttons"> 
                     <%	if strMode = "update" then %>
                        <input type="submit" name="update" value=<%= SAVE_TXT %> class="orangebutton">&nbsp;
                     <% else %>
                         <input type="submit" name="insert" value=<%= SAVE_TXT %> class="orangebutton">&nbsp;
                     <% End if %>
                     <input type="submit" name="cancel" value=<%= CANCEL_TXT %> class="greybutton">
        </div>
          
      </form>
	  
	  	  <%
	  	if strMode = "update" then
'			Clear open connections	
			destroy(objRs)
			destroy(objConn)		  
		End if
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
