<% Dim nMenuItems: nMenuItems = 0 %>
<script language="JavaScript" src="rptjs/menu.js"></script>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td class="ewPadding">
<script type="text/javascript" language="javascript">
var oMenu_base = new Menu();
var oMenu_ASPReport = oMenu_base.CreateMenu();
oMenu_ASPReport.displayHtml = "Reports";
oMenu_base.AddItem(oMenu_ASPReport);
oMenu_base.SetOrientation("h");
//oMenu_base.SetSubMenuImage("rptimages/flyout_arrow.gif", 4, 7);
oMenu_base.SetSize(150, 20);
<% If nMenuItems > 0 Then %>
oMenu_base.Render();
<% End If %>
</script>
</td>
</tr></table>
