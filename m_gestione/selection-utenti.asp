<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<% 	Option Explicit %>

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
'	No authorization for this function
	If Session("userLevel") < AUTH_MANAGER Then 
		response.redirect("/timereport/menu.aspx?msgtype=E&msgno=" & MSGNO_AUTHORIZATION_FAILED)
	End if

	if request.form("cancel") <> ""  then
			response.redirect("menu.aspx")	  
    End if

%>	
<!-- InstanceEndEditable -->
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

	<div id="TopStripe"></div> 
	
	<div id="MainWindow">
	
    <div id="FormWrap">

    <form name="form1" method="post" action="imposta-valori-utenti.asp"  class="StandardForm">

    <!-- *** TITOLO FORM ***  -->
	<div class="formtitle">Selezionare</div> 
      
    <!-- *** SELECT ***  -->
	<div class="input nobottomborder">
			<div class="inputtext">Persona :</div>  
			<div class="InputcontentDDL">
      
             <select name="Persons_Id" class="FormInput">
                <%                   
                call MakeConn(objConn, DATABASE)			
	         	call MakeRs_view(objRs,objConn, "SELECT Persons_Id ,Nickname, Name  FROM Persons WHERE active= " & CTRUE & "  ORDER BY nickname") 
            		
           		Dim aPersons, i
       			aPersons = objRs.getrows            		
            	
       			For i=0 to Ubound(aPersons, 2)
					If aPersons(0,i) = Cint(request("Persons_id"))  then
   				response.write("<option value=" & aPersons(0,i) & " selected>" &aPersons(1,i) & " : " & aPersons(2,i) & "</option>")            		
					else
   				response.write("<option value=" & aPersons(0,i) & ">" &aPersons(1,i) & " : " & aPersons(2,i) & "</option>")            		
					End if		
            	Next            		            		
            			destroy(objRs)
            			destroy(objConn)

                %>
              </select>

         </div>
    </div>  

    <!-- *** BOTTONI ***  -->
	<div class="buttons">
        <input name="Submit" type="submit" class="orangebutton" value=<% = EXEC_TXT %>>
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
