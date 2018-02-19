<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ScheduleStoredProcedure.aspx.cs" Inherits="m_utilita_ScheduleStoredProcedure" %>

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <p>Stored Procedure <asp:TextBox ID="TBStoredProcedure" runat="server"></asp:TextBox>
            <asp:Button ID="Exec" runat="server" Text="Esegui" OnClick="Exec_Click" />
    </form>
</body>
</html>
