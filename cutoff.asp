<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%	

'	Authorization  
'    Auth.CheckPermission("ADMIN", "CUTOFF")

	Dim i
			
'   	if cancel go back to main menu
	if request.form("cancel") <> "" then
		response.redirect("default.asp")
	End If 

	call MakeConn(objConn, DATABASE)	
	Call MakeRs_add(objRs,objConn,"SELECT * FROM Options")			
		
	If objRS.EOF = true then
		response.redirect("menu.aspx?msgtype=E&msgno=" & MSGNO_OPTION_NOT_FOUND)
	End if		
	objRS.movefirst

'	Page called by itself, update first (et only) record
	if request.form("update") <> ""  then		
		objRS("cutoffPeriod") = request("cutoffPeriod")
		objRS("cutoffMonth") = request("cutoffMonth")
		objRS("cutoffYear") = request("cutoffYear")
		
		objRS.update
		
		session("CutOffDate") = CutoffDate(  request("cutoffPeriod"), request("cutoffMonth"), request("cutoffYear"), "end" )
		
		destroy(objRS)
		destroy(objConn)
		
		response.redirect("menu.aspx?msgtype=I&msgno=" & MSGNO_UPDATE_DONE)
	
	End If
%>
		
<html><!-- InstanceBegin template="/Templates/common.dwt" codeOutsideHTMLIsLocked="false" -->
<!--#include virtual="/timereport/include/auth.asp" -->
<!--#include virtual="/timereport/include/common.asp" -->

<head>
<!-- InstanceBeginEditable name="doctitle" -->
<title>Gestione cutoff</title>
<!-- InstanceEndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="head" -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%>  type=text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

    <div id="FormWrap"> 

    <form name="form1" class="StandardForm" method="post" action="cutoff.asp">

     <div class="formtitle">Definisce CutOff</div> 

     <!--*** Quindicina ***-->
     <div class="input nobottomborder">
        <div class="inputtext">Quindicina</div>     
        <div class="InputcontentDDL" style="width:100px">
            <select name="cutoffPeriod" class="FormInput">
                <%	For i = 1 to 2 %>
                <option value="<%=i%>" <% if objRS("cutoffPeriod")=i Then response.write("selected") End If%>><%=i%></option>
                <% Next %>
            </select>      
        </div>
    </div>  

     <!--*** Mese ***-->
     <div class="input nobottomborder">
        <div class="inputtext">Mese</div>  
        <div class="InputcontentDDL" style="width:100px">
           <select name="cutoffMonth" class="FormInput">
                <%	For i = 1 to 12%>
                <option value="<%=i%>" <% if objRS("cutoffMonth")=i Then response.write("selected") End If%>><%=i%></option>
                <%	Next %>
              </select>      
        </div>
    </div> 

     <!--*** Anno ***-->
     <div class="input nobottomborder">
        <div class="inputtext">Anno</div>     
        <div class="InputcontentDDL" style="width:100px">
            <select name="cutoffYear" class="FormInput">
                <%	For i = FIRST_YEAR to LAST_YEAR %>
                <option value="<%=i%>" <% if objRS("cutoffYear")=i Then response.write("selected") End If%>><%=i%></option>
                <%	Next %>
              </select>     
        </div>
    </div>  
	
    <!-- *** Bottoni ***  -->
    <div class="buttons">
        <input type="submit" name="update" value=<%=SAVE_TXT%> class="orangebutton">
        <input type="submit" name="cancel" value=<%=CANCEL_TXT%> class="greybutton"> 
    </div>

    </form>

    </div> <!--*** FormWrap ***-->

<%
	destroy(objRS)
	destroy(objConn)
%>	  	  
 
    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div> 
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
     </div>

</body>
<!-- InstanceEnd --></html>
