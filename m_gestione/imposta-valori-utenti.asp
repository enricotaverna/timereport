<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui-1.10.3.custom.min.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>   
<script src="/timereport/include/jquery/jquery-ui-1.10.3.custom.min.js"></script>    

<html> 
<!--#include virtual="/timereport/include/auth.asp" -->
<!--#include virtual="/timereport/include/common.asp" -->

<head>
 
<title>Lista utenti</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

<%
	Dim Arr

'	No authorization for this function
	If Session("userLevel") < AUTH_EXTERNAL Then 
		response.redirect("/timereport/menu.aspx?msgtype=E&msgno=" & MSGNO_AUTHORIZATION_FAILED)
	End if

'	Annulla
	If request.form("cancel") <> "" Then
		response.Redirect("/timereport/m_gestione/selection-utenti.asp?Persons_Id=" & request("Persons_id")	 )		 
	End If 
	
'	premuto il tasto aggiorna
	 If request.form("submit") = SAVE_TXT  Then
	 
'		split multiple select per progetti
	 	Arr = Split(CStr(Request.Form("progetti")),",")
		
		call MakeConn(objConn, DATABASE)
'		prima cancella tutti i record esistenti
		call MakeRs_add(objRs,objConn,"delete from ForcedAccounts where Persons_id = " &  request("Persons_id"))
		
'		aggiorna i record selezionati
		For x = 0 to UBound(Arr)	
'			poi aggiorna tutti i nuovi record						
			call MakeRs_add(objRs,objConn,"ForcedAccounts")
			objRS.addnew
			objRS("Persons_id") = request("Persons_id")			
			objRS("Projects_id") = Arr(x)
			objRS.update
	 	Next 

'		stessa cosa per le spese, split multiple select
	 	Arr = Split(CStr(Request.Form("spese")),",")
		
'		prima cancella tutti i record esistenti
		call MakeRs_add(objRs,objConn,"delete from ForcedExpensesPers WHERE Persons_id = " & request("Persons_id"))
						
'		aggiorno
		For x = 0 to UBound(Arr)	
'			poi aggiorna tutti i nuovi record						
			call MakeRs_add(objRs,objConn,"ForcedExpensesPers")
			objRS.addnew
			objRS("Persons_Id") = Cint(request("Persons_Id"))
			objRS("ExpenseType_id") = Arr(x)
			objRS.update
	 	Next 
	
'		torna alla pagina di selezione
		response.Redirect("/timereport/m_gestione/selection-utenti.asp?Persons_Id=" & request("Persons_id")	 )		

	 End IF ' Fine pressione taso aggiorna
	 
	 If request("aprogetti") <> "" Then
		call MakeConn(objConn, DATABASE)
'		cancella tutti i record esistenti
		call MakeRs_add(objRs,objConn,"delete from ForcedAccounts where Persons_id = " &  request("Persons_id"))	 
'		torna alla pagina di selezione
		response.Redirect("/timereport/m_gestione/selection-utenti.asp?Persons_Id=" & request("Persons_id")	 )				
	 End if
	 
 	 If request("aspese") <> "" Then
		call MakeConn(objConn, DATABASE)
'		cancella tutti i record esistenti
		call MakeRs_add(objRs,objConn,"delete from ForcedExpensesPers where Persons_id = " & request("Persons_id"))	 
'		torna alla pagina di selezione
		response.Redirect("/timereport/m_gestione/selection-utenti.asp?Persons_Id=" & request("Persons_id")	 )				
	 End if
	 
'	Recupera il nome della persona	 
	call MakeConn(objConn, DATABASE)
	call MakeRs_view(objRs,objConn,"SELECT Name FROM Persons where Persons_id = " &  request("Persons_id") )	 	 			
%>
 
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

    <div id="TopStripe"></div> 
	
	<div id="MainWindow" >
	
    <div id="FormWrap" style="width:740px">
        
    <form name="form1" method="post" action="imposta-valori-utenti.asp" class="StandardForm" >
	
      <input name="Persons_id" type="hidden" value="<%=request("Persons_id")%>">
    
      <!-- *** TITOLO FORM ***  -->
	  <div class="formtitle" style="width:740px">Consulente: <%=objRs("Name")%></div> 
    
      <table width="70%" border="0" align="center" cellpadding="0" cellspacing="0" class="BoxDialogo">
        <tr>
          <td width="40%">&nbsp;</td>
          <td width="40%">&nbsp;</td>
        </tr>
        <tr>
          <td class="SeparatoreForm">Progetti</td>
          <td class="SeparatoreForm">Spese</td>
        </tr>
        
        
        <tr>
          <td><label>
            <div align="center" class="InputcontentDDL" style="height:280px;background-image:none;width:300px">
              <select name="progetti" size="15" multiple="multiple">
<%
		Dim objConn1, objRs1

'		Estrae progetti attivi
' 		Open connection to retrieve project lists
		call MakeConn(objConn1, DATABASE)
        call MakeRs_view(objRs1,objConn1, "SELECT Projects_Id, ProjectCode, Name  FROM Projects WHERE active=" & CTRUE & " AND Always_available=" & CFALSE &" ORDER BY ProjectCode") 
		
		Dim aProject, i
        aProject = objRs1.getrows            		
		            	
        For i=0 to Ubound(aProject, 2) 

'		cerca se il progetto  è abilitato
		call MakeRs_view(objRs1,objConn1, "SELECT Projects_Id FROM ForcedAccounts WHERE Persons_id = " & request("Persons_id") & " AND Projects_Id = " & aProject(0,i) )
				
		if 	objRs1.EOF = true Then
'		non trovato progetto ammesso		
			response.write("<option value=" & aProject(0,i) & "  >" &aProject(1,i) & " : " & _ 			
						aProject(2,i) & "</option>")     
		else						       	
'		trovato
			response.write("<option value=" & aProject(0,i) & " selected >" &aProject(1,i) & " : " & _			
						aProject(2,i) & "</option>")            	
		End if

		Next
		
%>												  			  
              </select>
              </div>
          </label></td>
          <td><div align="center" class="InputcontentDDL" style="height:280px;background-image:none;width:300px">

          <select name="spese" size="15" multiple="multiple" id="spese">

<%		  
		call MakeRs_add(objRs1,objConn1, "SELECT ExpenseType_Id, ExpenseCode, Name  FROM " & _ 
			  				  "ExpenseType WHERE active=" & CTRUE &"")             		
        Dim aExpenses
        aExpenses = objRs1.getrows            		
            
        For i=0 to Ubound(aExpenses, 2)
				
'		cerca se la spesa è abilitata
		call MakeRs_view(objRs1,objConn1, "SELECT Persons_Id FROM ForcedExpensesPers WHERE  Persons_Id = " & request("Persons_id") & " AND ExpenseType_id  = " & aExpenses(0,i) )
				
		if 	objRs1.EOF = true Then
'		non trovato progetto ammesso		
			response.write("<option value=" & aExpenses(0,i) & "  >" &aExpenses(1,i) & " : " & _ 			
						aExpenses(2,i) & "</option>")     
		else						       	
'		trovato
			response.write("<option value=" & aExpenses(0,i) & " selected >" &aExpenses(1,i) & " : " & _			
						aExpenses(2,i) & "</option>")            	
		End if
				
		  	Next
					
%>					
            </select>
          </div></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><input name="aprogetti" type="submit" class="SmallGreyButton" id="aprogetti" value= <% = RESET_TXT %>></td>
          <td><input name="aspese" type="submit" class="SmallGreyButton" id="aspese" value= <% = RESET_TXT %>></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>

        <!-- *** BOTTONI ***  -->
	    <div class="buttons">
            <input name="Submit" type="submit" class="orangebutton" value=<% = SAVE_TXT %>>
            <input name="cancel" type="submit" class="greybutton" id="Submit1" value= <% = CANCEL_TXT %>>
	    </div>   

    </form>

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
