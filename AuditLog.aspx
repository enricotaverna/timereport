<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AuditLog.aspx.cs" Inherits="AuditLog" validateRequest="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  

<script>    

$(document).ready(function () 
{
    //    attribuisce id alla DIV della gridview        
    $('#GridView1').closest('div').attr('id', 'PanelWrap');
});

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Log audit</title>
</head>
<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="form1" runat="server">

        <div id="PanelWrap">  

        <asp:GridView 
        ID="GridView1" runat="server" AllowPaging="True" 
        AutoGenerateColumns="False" CssClass="GridView"
        DataSourceID="DSAudit" EnableModelValidation="True" AllowSorting="True" 
        EnableSortingAndPagingCallbacks="True" PageSize="15">
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <PagerStyle CssClass="GV_footer" />
        <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
        <Columns>
            <asp:BoundField DataField="TYPE" HeaderText="TYPE" SortExpression="TYPE" />
            <asp:BoundField DataField="TableName" HeaderText="TableName" 
                SortExpression="TableName" />
            <asp:BoundField DataField="UpdateDate" HeaderText="UpdateDate" 
                SortExpression="UpdateDate" />
            <asp:BoundField DataField="FieldName" HeaderText="FieldName" 
                SortExpression="FieldName" />
            <asp:BoundField DataField="OldValue" HeaderText="OldValue" 
                SortExpression="OldValue" />
            <asp:BoundField DataField="NewValue" HeaderText="NewValue" 
                SortExpression="NewValue" />
        </Columns>
    </asp:GridView>
    
    <!-- *** BOTTONI ***  -->
    <div class="buttons">
        <asp:button runat=server name="CancelButton" CausesValidation="False" PostBackUrl="" Text="<%$ appSettings: CANCEL_TXT %>" class="greybutton" id="CancelButton" />
    </div>

    </div> <!--End PanelWrap-->

    </form>

     </div> <%-- END MainWindow --%> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div>    
   
    <asp:SqlDataSource ID="DSAudit" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        
        SelectCommand="SELECT TYPE, TableName, PK, FieldName, OldValue, NewValue, UpdateDate, UserName FROM Audit WHERE (PK = @PK) AND (TableName = @TableName) ORDER BY UpdateDate DESC">
            <SelectParameters>
                <asp:QueryStringParameter Name="PK" QueryStringField="key" Type="String" />
                <asp:QueryStringParameter Name="TableName" QueryStringField="TableName" 
                    Type="String" />
            </SelectParameters>
    </asp:SqlDataSource>

</body>
</html>
