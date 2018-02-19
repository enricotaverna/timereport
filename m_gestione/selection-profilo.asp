<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui-1.10.3.custom.min.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>   
<script src="/timereport/include/jquery/jquery-ui-1.10.3.custom.min.js"></script>         

<html> 

<!--#include virtual="/timereport/include/auth.asp" -->
<!--#include virtual="/timereport/include/common.asp" -->

<head>
 
<title>Lista profili spese</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
<%
'	No authorization for this function
'    Auth.CheckPermission("MASTERDATA", "PERSONE");          
%>	
<!-- InstanceEndEditable -->
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

	<div id="TopStripe"></div> 
	
	<div id="MainWindow">
	
    <div id="FormWrap">

    <form name="form1" method="post" action="imposta-valori-profilo.asp" class="StandardForm">
    
    <!-- *** TITOLO FORM ***  -->
	<div class="formtitle">Criteri di selezione</div> 
  
    	<!-- *** SELECT ***  -->
	    <div class="input nobottomborder">
			    <div class="inputtext">Profilo di spesa :</div>  
			    <div class="InputcontentDDL">

                    <select name="ExpensesProfile_Id" >
                    <%                   
                    call MakeConn(objConn, DATABASE)			
	         	    call MakeRs_view(objRs,objConn, "SELECT ExpensesProfile_id, Name FROM ExpensesProfile ORDER BY Name") 
            		
           		    Dim aArr, i
       			    aArr = objRs.getrows            		
            	
       			    For i=0 to Ubound(aArr, 2)
					    If aArr(0,i) = Cint(request("ExpensesProfile_id"))  then
   				    response.write("<option value=" & aArr(0,i) & " selected>" &aArr(1,i) & "</option>")            		
					    else
   				    response.write("<option value=" & aArr(0,i) & ">" &aArr(1,i) & "</option>")            		
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
				<input name="Submit" type="submit" class="orangebutton" value=<%= EXEC_TXT %> />
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
