<%@ Page Language="C#" AutoEventWireup="true" CodeFile="logout_landing.aspx.cs" Inherits="logoff" %>

<!DOCTYPE html>
<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>

        <div id="MainWindow">

        <div id="FormWrap" Class="StandardForm">

        <form id="form_logout" runat="server"  >

           <div class="formtitle">Timereport Logout</div>

            <!-- *** Tipo Login ***  -->
            <div class="input nobottomborder">

                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="" ></asp:Label>

                <asp:Label CssClass="inputtext" runat="server" Text="Sessione terminata" ></asp:Label>

            </div>


    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 


</body>
</html>
