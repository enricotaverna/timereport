<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRateReport.aspx.cs" Inherits="report_Rdl_Default" %>


<%@ Register assembly="Microsoft.ReportViewer.WebForms" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>


<!DOCTYPE html>

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        .auto-style1 {
            height: 24px;
        }
    </style>
</head>
<body style="background-color:white">

 <form id="form1" runat="server">
    

    <table style="padding:0px">

        <tr style="background-color:black; line-height:24px; ">
        <td class="auto-style1"></td>
        </tr>
        <tr>
        <td>
            
        <rsweb:ReportViewer ID="RVReport" runat="server" ClientIDMode="AutoID" HighlightBackgroundColor="" InternalBorderColor="204, 204, 204" InternalBorderStyle="Solid" InternalBorderWidth="1px" LinkActiveColor="" LinkActiveHoverColor="" LinkDisabledColor="" PrimaryButtonBackgroundColor="" PrimaryButtonForegroundColor="" PrimaryButtonHoverBackgroundColor="" PrimaryButtonHoverForegroundColor="" SecondaryButtonBackgroundColor="" SecondaryButtonForegroundColor="" SecondaryButtonHoverBackgroundColor="" SecondaryButtonHoverForegroundColor="" SplitterBackColor="" ToolbarDividerColor="" ToolbarForegroundColor="" ToolbarForegroundDisabledColor="" ToolbarHoverBackgroundColor="" ToolbarHoverForegroundColor="" ToolBarItemBorderColor="" ToolBarItemBorderStyle="Solid" ToolBarItemBorderWidth="1px" ToolBarItemHoverBackColor="" ToolBarItemPressedBorderColor="51, 102, 153" ToolBarItemPressedBorderStyle="Solid" ToolBarItemPressedBorderWidth="1px" ToolBarItemPressedHoverBackColor="153, 187, 226" Width="800px" SizeToReportContent="True" ZoomMode="FullPage" Height="600px" ShowBackButton="False" ShowRefreshButton="True">
        </rsweb:ReportViewer>

        </td>
        </tr>

    </table>



        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>


            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT * FROM [v_ore]"></asp:SqlDataSource>
        </div>
    </form>
</body>

<script type="text/javascript">

    $(function () {
        $('#menu1').css("top", "2px");

    });

</script>

</html>
