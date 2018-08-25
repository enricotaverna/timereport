<%@ Page Language="C#" %>
<%@ Import Namespace="System.Configuration" %>


<!DOCTYPE html>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {

        Session["UserLevel"] = "";
        Session["UserId"] = "";
        Session["UserName"] = "";
        Session["persons_id"] = "";
        Session["nickname"] = "";

        HttpContext.Current.Response.Redirect(ConfigurationManager.AppSettings["LOGIN_PAGE"]);

    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
</body>
</html>
