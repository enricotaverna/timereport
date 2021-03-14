<%@ Page Language="C#" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Security.Principal" %>

<!DOCTYPE html>
<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        Session["UserLevel"] = "";
        Session["UserId"] = "";
        Session["UserName"] = "";
        Session["persons_id"] = "";
        Session["nickname"] = "";

        // logout
   

        //HttpContext.Current.Response.Redirect(ConfigurationManager.AppSettings["LOGIN_PAGE"]);

    }

</script>

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
