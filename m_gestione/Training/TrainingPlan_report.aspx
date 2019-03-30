<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrainingPlan_report.aspx.cs" trace="false" Inherits="report_ControlloProgettoSelect" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<script language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<head id="Head1" runat="server">
    <title>Controllo Progetto</title>
    
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

    </head>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="StandardForm" >
 
    <form id="RVFOrm" runat="server"  >    
       
    <div class="formtitle" >Training Plan Report</div>

        <!-- *** DDL Anno ***  -->
        <br />
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" runat="server" Text="Anno" ></asp:Label>
            <label id="lbDDLAttivita" class="dropdown">
                <!-- per stile CSS -->
                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True" >
                    <asp:ListItem value="0">--tutti gli anni--</asp:ListItem>
                </asp:DropDownList>
            </label>
        </div>

        <div class="input nobottomborder">
        <asp:Label CssClass="inputtext" runat="server" Text="Manager" ></asp:Label>
            <label id="lbDDLManager" class="dropdown">
                <!-- per stile CSS -->
                <asp:DropDownList ID="DDLManager" runat="server" AppendDataBoundItems="True" DataSourceID="DSManager" DataTextField="Name" DataValueField="Persons_id"  >
                    <asp:ListItem value="0">--tutti i manager --</asp:ListItem>
                </asp:DropDownList>
            </label>
        </div>

        <div class="input nobottomborder">
        <asp:Label CssClass="inputtext" runat="server" Text="Consulente" ></asp:Label>
            <label id="lbDDLPersons" class="dropdown">
                <!-- per stile CSS -->
                <asp:DropDownList ID="DDLPersons" runat="server" AppendDataBoundItems="True" DataSourceID="DSPersons"  DataTextField="Name" DataValueField="Persons_id" >
                    <asp:ListItem value="0">--tutte le persone --</asp:ListItem>
                </asp:DropDownList>
            </label>
        </div>

        <br />

    <div class="buttons">    
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="report" runat="server" Text="<%$ appSettings: REPORT_TXT %>" CssClass="orangebutton"  CommandName="report" OnClick="sottometti_Click" />    
            <asp:Button ID="CancelButton" runat="server" formnovalidate="" CssClass="greybutton" OnClientClick="document.location.href='/timereport/menu.aspx'; return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
 
    </div>
    
    </div> <%-- END FormWrap  --%> 

    </form>

    </div> <!-- END MainWindow -->
    
    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div> 

</body>

<asp:SqlDataSource ID="DSmanager" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) and ( Roles_id = '1' OR Roles_id = '2' OR Roles_id = '3') and Company_id = '1'   ORDER BY Name">
</asp:SqlDataSource>

<asp:SqlDataSource ID="DSPersons" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) and Company_id = '1' ORDER BY Name">
        </asp:SqlDataSource>

</html>

