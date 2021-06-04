<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ricevute_list.aspx.cs" EnableEventValidation="false"  Inherits="report_ricevute_ricevute_list" %>

<!DOCTYPE html>
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        :target {
           background: yellow;
        }
    </style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
            
        <H1>Rapporto spese: <asp:Label ID="LBIntestazione" runat="server" Text=""></asp:Label></H1>    

        <asp:GridView ID="GVricevute" runat="server"  CssClass="GridView" AutoGenerateColumns="False" DataKeyNames="Expenses_Id" DataSourceID="SQLDSricevute" EnableModelValidation="True" OnRowDataBound="GVricevute_RowDataBound">
                 <FooterStyle CssClass="GV_footer" />
                <RowStyle Wrap="False" CssClass="GV_row" BorderStyle="Dotted" BorderWidth="1" />
                <PagerStyle CssClass="GV_footer" />
                <HeaderStyle CssClass="GV_header" BorderWidth="1" BorderStyle="Solid" BorderColor="#666666" />
                <AlternatingRowStyle CssClass="GV_row_alt " />
            <Columns>
                <asp:BoundField DataField="Expenses_Id" HeaderText="Expenses_Id" InsertVisible="False" ReadOnly="True" SortExpression="Expenses_Id" />
                <asp:BoundField DataField="PersonName" HeaderText="PersonName" SortExpression="PersonName" />
                <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date" DataFormatString="{0:d}" />
                <asp:BoundField DataField="ExpenseCode" HeaderText="ExpenseCode" SortExpression="ExpenseCode" />
                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                <asp:BoundField DataField="ProjectCode" HeaderText="ProjectCode" SortExpression="ProjectCode" />
                <asp:BoundField DataField="ProjectName" HeaderText="ProjectName" SortExpression="ProjectName" />
                <asp:CheckBoxField DataField="CreditCardPayed" HeaderText="CC" SortExpression="CreditCardPayed" />
                <asp:CheckBoxField DataField="CancelFlag" HeaderText="ST" SortExpression="CancelFlag" />
                <asp:CheckBoxField DataField="InvoiceFlag" HeaderText="FT" SortExpression="InvoiceFlag" />
                <asp:BoundField DataField="Importo" HeaderText="Importo" ReadOnly="True" SortExpression="Importo" />
                <asp:BoundField DataField="Comment" HeaderText="Comment" ReadOnly="True" SortExpression="Comment" />
                <asp:TemplateField headertext="Giustificativi"></asp:TemplateField>
            </Columns>
        </asp:GridView>

        <asp:SqlDataSource ID="SQLDSricevute" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Expenses.Expenses_Id, Expenses.Date, ExpenseType.ExpenseCode, ExpenseType.Name, Persons.Name AS PersonName, Projects.ProjectCode, Projects.Name AS ProjectName, Expenses.CreditCardPayed, Expenses.CancelFlag, Expenses.InvoiceFlag, Expenses.Amount * ExpenseType.ConversionRate AS Importo, Expenses.Comment FROM Projects INNER JOIN Expenses ON Projects.Projects_Id = Expenses.Projects_Id INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id WHERE (Expenses.InvoiceFlag = @invoiceflag OR @invoiceflag is NULL) AND ( Expenses.Persons_id = @persons_id OR  @persons_id IS NULL ) AND ( Expenses.ExpenseType_id = @tipospesa OR  @tipospesa IS NULL ) AND (Expenses.Date &gt;= @datada) AND ( Persons.Company_id = @societa OR  @societa IS NULL ) AND (Expenses.Date &lt;= @dataa) AND (Expenses.TipoBonus_Id = 0) ORDER BY Expenses.persons_id, Expenses.Date" 
            CancelSelectOnNullParameter="False" >
            
            <SelectParameters> 
                <asp:Parameter Name="persons_id" />
                <asp:Parameter Name="societa" />
                <asp:Parameter Name="tipospesa" />
                <asp:Parameter Name="invoiceflag" />
                <asp:Parameter Name="datada" Type="datetime"/>
                <asp:Parameter Name="dataa" Type="datetime" />
            </SelectParameters>

        </asp:SqlDataSource>
    
        <br />

        <label runat="server" id="TitoloTabellaRicevute" style="visibility:hidden" ><H1>Giustificativi</H1></label>
        <table id="TabellaRicevute" runat="server" ></table>
    
    </div>
    </form>
</body>

</html>
