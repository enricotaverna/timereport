<%@ Page Language="VB" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%-- Pagina generica richiamata dal menù per scarico query --%>

<script runat="server">

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Auth.CheckPermission("REPORT", "ADMIN")

        Utilities.ExportXls(Request.QueryString("query"))

    End Sub

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Esporta</title>    
</head>

<script language=JavaScript src= "/timereport/include/menu/menu_array.js" type=text/javascript></script>
<script language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></script>  

<body>
    <form id="form1" runat="server">
    <div>
    
    </div>
    </form>
</body>
</html>
