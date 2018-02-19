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

<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

<%
	Dim Arr

'	No authorization for this function
	If Session("userLevel") < AUTH_MANAGER Then 
		response.redirect("/timereport/menu.aspx?msgtype=E&msgno=" & MSGNO_AUTHORIZATION_FAILED)
	End if

'	Annulla
	If request.form("cancel") <> "" Then
		response.Redirect("/timereport/m_gestione/selection-profilo.asp?ExpensesProfile_id=" & request("ExpensesProfile_id"))		 
	End If 
	
'	premuto il tasto aggiorna
	 If request.form("submit") = SAVE_TXT Then
	 
'		stessa cosa per le spese, split multiple select
	 	Arr = Split(CStr(Request.Form("spese")),",")
		
'		prima cancella tutti i record esistenti
		call MakeConn(objConn, DATABASE)
		call MakeRs_add(objRs,objConn,"delete from ForcedExpensesProf WHERE ExpensesProfile_id = " & request("ExpensesProfile_id"))
						
'		aggiorno
		For x = 0 to UBound(Arr)	
'			poi aggiorna tutti i nuovi record						
			call MakeRs_add(objRs,objConn,"ForcedExpensesProf")
			objRS.addnew
			objRS("ExpensesProfile_id") = Cint(request("ExpensesProfile_id"))
			objRS("ExpenseType_id") = Arr(x)
			objRS.update
	 	Next 
	
		destroy(objRS)

'		torna alla pagina di selezione
		response.Redirect("/timereport/m_gestione/selection-profilo.asp?ExpensesProfile_id=" & request("ExpensesProfile_id")	 )		

	 End IF ' Fine pressione taso aggiorna
	 
	 If request("aspese") <> "" Then
		call MakeConn(objConn, DATABASE)
'		cancella tutti i record esistenti
		call MakeRs_add(objRs,objConn,"delete from ForcedExpensesProf where ExpensesProfile_id = " & request("ExpensesProfile_id"))	 
'		torna alla pagina di selezione
		response.Redirect("/timereport/m_gestione/selection-profilo.asp?ExpensesProfile_id=" & request("ExpensesProfile_id")	 )				
	 End if
	 
'	Recupera il nome della persona	 
	call MakeConn(objConn, DATABASE)
	call MakeRs_view(objRs,objConn,"SELECT Name FROM ExpensesProfile where ExpensesProfile_id = " &  request("ExpensesProfile_id") )	 	 			
%>
 
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

    <div id="TopStripe"></div> 
	
	<div id="MainWindow" >
	
    <div id="FormWrap" style="width:500px">

    <form name="form1" method="post" action="imposta-valori-profilo.asp" class="StandardForm" >
	
      <input name="ExpensesProfile_id" type="hidden" value="<%=request("ExpensesProfile_id")%>">

      <!-- *** TITOLO FORM ***  -->
	  <div class="formtitle" style="width:500px">Profilo: <%=objRs("Name")%></div> 

       <!-- *** SELECT ***  -->
	   <div class="input nobottomborder">
       <div class="inputtext">Spesa abilitate:</div>  
	   <div class="InputcontentDDL" style="height:280px;background-image:none;width:300px">
               <select name="spese" size="15" multiple="multiple" id="spese">

                <%		  
		        call MakeConn(objConn1, DATABASE)
		        call MakeRs_add(objRs1,objConn1, "SELECT ExpenseType_Id, ExpenseCode, Name  FROM " & _ 
			  				          "ExpenseType WHERE active=" & CTRUE &"")             		
                Dim aExpenses
                aExpenses = objRs1.getrows            		
            
                For i=0 to Ubound(aExpenses, 2)
				
        '		cerca se la spesa è abilitata
		        call MakeRs_view(objRs1,objConn1, "SELECT ExpensesProfile_id FROM ForcedExpensesProf WHERE  ExpensesProfile_id = " & request("ExpensesProfile_id") & " AND ExpenseType_id  = " & aExpenses(0,i) )
				
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
					
			        destroy(objRs1)
                %>					
                        </select>
			    
                </div>
		    </div>   <!-- *** SELECT ***  -->

            <!-- *** BOTTONI ***  -->
			<div class="buttons">
                <input name="Submit" type="submit" class="orangebutton" value=<% = SAVE_TXT %> >
                <input name="aspese" type="submit" class="orangebutton" id="aspese" value= <% = RESET_TXT %> >
                <input name="cancel" type="submit" class="greybutton" id="cancel" value=<% = CANCEL_TXT %> >
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
