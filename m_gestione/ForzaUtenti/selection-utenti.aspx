<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>
 
<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        '	Authorization level 3 needed for this function
        Auth.CheckPermission("MASTERDATA", "PERSONE")

        If request.form("cancel") <> ""  then
            response.redirect("menu.aspx")
        End if

    End Sub


</script>


<html> 

<head>
 
<title>Lista utenti</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

</head>

<body>

	<div id="TopStripe"></div> 
	
	<div id="MainWindow">
	
    <div id="FormWrap" class="StandardForm">

    <form name="form1" runat="server" method="post" action="imposta-valori-utenti.aspx"  >

    <!-- *** TITOLO FORM ***  -->
	<div class="formtitle">Selezionare</div> 
      
    <!-- *** SELECT ***  -->
	<div class="input nobottomborder">
			<div class="inputtext">Persona :</div>  
			<label class="dropdown">         
               <asp:DropDownList ID="IdPersonaSelezionata" runat="server" DataSourceID="DSPersone" DataTextField="Name" DataValueField="Persons_id">
               </asp:DropDownList>    
         </label>
    </div>  

    <!-- *** BOTTONI ***  -->
	<div class="buttons">
        <input runat="server" name="Submit" type="submit" class="orangebutton"  value="<%$ appSettings: EXEC_TXT %>" >
    </div>   

    </form>

    </div>  <!-- END FormWrap-->		
			
	</div> <!-- END MainWindow -->
	
	<!-- **** FOOTER **** -->  
	<div id="WindowFooter">       
	    <div ></div>        
	    <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(Now())  %></div> 
	    <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>              
	    <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>        
	    </div> 

</body>
</html>

<asp:sqldatasource runat="server" ID="DSPersone" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name"></asp:sqldatasource>
