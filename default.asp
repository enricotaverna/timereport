<%@ Language=VBScript %>
 
<%  
	Option explicit 
	
	Response.Buffer = true 
	Response.ExpiresAbsolute = Now() - 1 
	Response.Expires = 0 
'	imposta default data a formato italiano
	Session.LCID = 1040

'	if Session("userID")  <> "" and Session("persons_id") <> "" then ' if user already logged redirect to the menu
'	  	response.redirect("menu.aspx")
'	  	response.flush
'	End if	
    
%>
    
<!--#INCLUDE file="include/common.asp"-->

<html>
<head>
<title>Time report: login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta name="robots" content="noindex, nofollow">
<link href="include/newstyle.css" rel="stylesheet" type="text/css">
</head>

<body OnLoad="document.login.userid.focus();">

<%
	Sub checkpassword()
      
		'-- Declare your variables
		Dim objConn, objRS
		
		'-- Create object and open database
		Call MakeConn(objConn, DATABASE)
				
		Call MakeRs_view(objRS, objConn,  "SELECT * FROM persons WHERE [userId]=" & FormatStringDb( request("UserId") ) & _
		      " AND [password]=" &  FormatStringDb( request("password") )  )
		
		if objRS.EOF then
			Destroy(objRS)
    		Destroy(objConn)	
%>    		
		<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabellabianca">
        <tr> 
          <td align="center" >
          	<p><strong><img src="images/icons/22x22/S_M_ERRO.gif" width="22" height="22">&nbsp;ERRORE</strong>
              &nbsp; &nbsp; utente non riconosciuto, reinserire UserId e password <BR>
              &nbsp; 
            </td>
        </tr>
        </table>     		
<%
		elseif  objRS("active") = false then

    %>    		
		<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabellabianca">
        <tr> 
          <td align="center" >
          	<p><strong><img src="images/icons/22x22/S_M_ERRO.gif" width="22" height="22">&nbsp;ERRORE</strong>
              &nbsp; &nbsp; utente non attivo <BR>
              &nbsp; 
            </td>
        </tr>
        </table>     		
<%

        else
    				
				Dim ExpensesProfile_id
				
'			old management of user accounts: now obsolete, all login trough the persons table
				' Set session variable for users
				Session("UserLevel") = objRS("UserLevel_ID")
				Session("UserId") = objRS("UserId")
				Session("UserName") = objRS("Name")  
				Session("persons_id") = objRS("persons_id")
				Session("nickname") = objRS("nickname")
				Session("ColorScheme") = objRS("ColorScheme")
				' Manage forced account for subcontractors
				Session("ForcedAccount") = iif(objRS("ForcedAccount") = true, 1, 0)
				session("ExpensesProfile_id") = objRS("ExpensesProfile_id")   
                session("CartaCreditoAziendale") = objRS("CartaCreditoAziendale")
                session("lingua") = objRS("lingua")               

                ' abilita nuove funzionalità
                If objRS("BetaTester") = true then 
                    Session("BetaTester") = true                        
                else
                    Session("BetaTester") = false
                End if            
        
                ' debug
                session("debug") = request("debug")

   				ExpensesProfile_id = objRS("ExpensesProfile_id") 
				
				' fetch the cutoffdate and store it in a session variable
				Dim objRs2
				Call MakeRs_view(objRs2, objConn,"SELECT * FROM Options")

				If objRS2.EOF = true then
					response.redirect("menu.aspx?msgtype=E&msgno=" & MSGNO_OPTION_NOT_FOUND)
				End if		
				objRS2.movefirst

				session("CutoffDate") = CutoffDate(  objRS2("cutoffPeriod"), objRS2("cutoffMonth"), objRS2("cutoffYear"), "end" )

				Destroy(objRS2)
			
				' fecth default for hour type	
				Call MakeRs_view(objRs2, objConn,"SELECT * FROM HourType where [active] = " & CTRUE & " and [ValoreDefault] = " & CTRUE )
				If objRS2.EOF = false then
					Session("HourTypeDefault") = objRS2("HourType_Id")
				Else
					Session("HourTypeDefault") = ""
				End If
								
	    		Destroy(objRS)
				Destroy(objRS2)
				
'				Carica spese e progetti possibili
				Dim ProgettiForzati
				Dim SpeseForzate
				
				If Session("ForcedAccount") = 1 Then				
'					** A.1 Carica progetti possibili
'					Right join: includes all the forced projects plus the ones with the flag always_available on							
					call MakeRs_view(objRs,objConn, "SELECT Projects.Projects_Id, Projects.ProjectCode, Projects.Name,  Projects.Always_available FROM ForcedAccounts RIGHT JOIN Projects ON ForcedAccounts.Projects_id = Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" & session("Persons_id") & " OR Projects.Always_available = " & CTRUE &" ) AND Projects.active = " & CTRUE &" )  ORDER BY Projects.ProjectCode" ) 								

					ProgettiForzati = objRs.getrows 
					
'					** A.2 Carica spese possibili				

					if ExpensesProfile_id > 0 Then
'						** A.2.1 Prima verifica se il cliente ha un profilo di spesa					
						call MakeRs_view(objRs,objConn, "SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesProf RIGHT JOIN ExpenseType ON ForcedExpensesProf.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesProf.ExpensesProfile_id=" & ExpensesProfile_id & " ) ) ORDER BY ExpenseType.ExpenseCode" )											
						if objRs.EOF = false Then
							SpeseForzate = objRs.getrows 		
						End if					
					else
'						** A.2.2 Poi cerca spese specifiche per persona			
						call MakeRs_view(objRs,objConn, "SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesPers.Persons_id=" & session("Persons_id") & " ) ) ORDER BY ExpenseType.ExpenseCode" )										
'						** A.2.2.1 Siamo alla fine, non ha trovato spese forzate sulla persona, a questo punto
'						   carica tutto
						If objRs.EOF = true then
							call MakeRs_view(objRs,objConn, "SELECT ExpenseType_Id, ExpenseCode, Name FROM ExpenseType WHERE active = " & CTRUE &" ORDER BY ExpenseCode")
						End If
						SpeseForzate = objRs.getrows 											
					End If
				Else
'					** B.1 tutti i progetti attivi				
           			call MakeRs_view(objRs,objConn, "SELECT Projects_Id, ProjectCode, Name  FROM Projects WHERE active=" & CTRUE &"  ORDER BY ProjectCode") 				
					ProgettiForzati = objRs.getrows 
'					** B.2 tutte le spese attive 							
					call MakeRs_add(objRs,objConn, "SELECT ExpenseType_Id, ExpenseCode, Name  FROM ExpenseType WHERE active=" & CTRUE &"") 
					SpeseForzate = objRs.getrows 				
				End If

				Session("ProgettiForzati") = ProgettiForzati
				Session("SpeseForzate") = SpeseForzate	
                
                ' forza il refresh del buffer delle spese
                Session("RefreshRicevuteBuffer") = "refresh"
				
    			Destroy(objConn)			
    												
				Response.Redirect "/timereport/include/utility/share_session1.asp"     
		End If	   
    
    End Sub
%>    
  
<div id="MainWindow">

<div id="FormWrap">

<form name="login" action="default.asp" method="post" class="StandardForm">
  
  <div class="formtitle">Timereport Login</div>  
  
  <div class="input nobottomborder">
    <div class="inputtext">Nome utente: </div>
	    <div class="inputcontent">
		    <input name="userid" type="text"  /> 
	     </div>
  </div>

  <div class="input nobottomborder">
    <div class="inputtext">Password: </div>
	    <div class="inputcontent">
		    <input name="password" type="password" value="" size="40" maxlength="50" /> 
	     </div>
  </div>  

  <div class="buttons">
    <span class="testoPiccolo">Aeonvis Spa, <%= Year(now())  %>  
    </span>

    <input name="Login" type="submit" class="orangebutton" value="Login" />
  </div>

</form>

</div>

</div>

<%
	' ------------------ MAIN -------------------
  	If Request("Login") = "Login"  Then
     		If Request.form("userId") = "" OR Request.form("Password") = "" Then
%>
		<table width="50%" border="0" align="center" cellpadding="0" cellspacing="0" class="tabellabianca">
        <tr> 
          <td align="center" >
          	<p><strong><img src="images/icons/22x22/S_M_ERRO.gif" width="22" height="22">&nbsp;ERRORE</strong>
              &nbsp; &nbsp; Inserire User Name e Password <BR>
              &nbsp; 
            </td>
        </tr>
        </table> 
<%    	       
	     	Else
	     		Call CheckPassword()     
     		End if 	
	End If
%> 

</body>
</html>
