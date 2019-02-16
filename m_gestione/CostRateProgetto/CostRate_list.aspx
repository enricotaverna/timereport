<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRate_list.aspx.cs" Inherits="m_gestione_CostRate_lookup_list" %>

<!DOCTYPE html>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/javascript/timereport.js"></script>
<script>
    $(function () {

        // nasconde la colonna con la chiave usata nella cancellazione del record
        $('.hiddencol').css({ display: 'none' });

    });
</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Cost rate per progetto</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">  
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="form1" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap" style="width:750px"> 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

    <table width="760" border="0" class="GridTab">
        <tr>
        <td>
            Persona:
        
        </td>
         <td>
                <asp:DropDownList ID="DDLPersons" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLPersons_SelectedIndexChanged" AppendDataBoundItems="True"
                    Width="150px"  CssClass="TabellaLista" DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id">
                    <asp:ListItem Value="0">Tutti i valori</asp:ListItem>
                </asp:DropDownList>                
        </td>
        <td>
            Progetto:
        </td>
        <td>
            <asp:DropDownList ID="DDLProgetto" runat="server" DataSourceID="DSProgetti" DataTextField="NomeProgetto" 
                DataValueField="Projects_id" AutoPostBack="True" AppendDataBoundItems="True"
                OnSelectedIndexChanged="DDLProgetto_SelectedIndexChanged"
                Width="150px" CssClass="TabellaLista">
                <asp:ListItem Text="Tutti i valori" Value="0" />
            </asp:DropDownList>
        </td>

        </tr>

        <tr>
        <td>&nbsp;        </td>
        <td>&nbsp;        </td>
        <td>Manager:      </td>
        <td>
                <asp:DropDownList ID="DDLManager" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLManager_SelectedIndexChanged" AppendDataBoundItems="True"
                    Width="150px"  CssClass="TabellaLista" DataSourceID="DSManager" DataTextField="ManagerName" DataValueField="Manager_id" OnDataBound="DDLManager_DataBound" >
                    <asp:ListItem Value="0">Tutti i valori</asp:ListItem>
                </asp:DropDownList>  
        </td>

        </tr>

        </table>

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap" style="width:750px" >  

    <asp:GridView ID="GV_ForcedAccounts" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="DSForcedAccounts" CssClass="GridView" OnSelectedIndexChanged="GV_ForcedAccounts_SelectedIndexChanged"
        AllowPaging="True" PageSize="15" DataKeyNames="ProjectCostRate_id"  width="750px"
        GridLines="None" EnableModelValidation="True" OnRowCommand="GV_ForcedAccounts_RowCommand" OnDataBound="GV_ForcedAccounts_DataBound" >
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <Columns>
            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
            <asp:BoundField DataField="ProjectCostRate_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" /> 
            <asp:BoundField DataField="NomePersona" HeaderText="Persona"   SortExpression="NomePersona" /> 
            <asp:BoundField DataField="NomeManager" HeaderText="Manager"   SortExpression="NomeManager" />                         
            <asp:BoundField DataField="NomeProgetto" HeaderText="Progetto"   SortExpression="NomeProgetto" />
            <asp:BoundField DataField="BillRate" HeaderText="Bill Rate"   SortExpression="BillRate" />
            
            <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate>
                    
                        <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False"  PostBackUrl='<%# Eval("ProjectCostRate_id", "CostRate_lookup_form.aspx?ProjectCostRate_id={0}") %>'
                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;
                        
                </ItemTemplate>
            </asp:TemplateField>
        
                <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate >
                           
                        <asp:ImageButton ID="BT_delete" runat="server" CausesValidation="False" 
                        OnClientClick="return confirm('Il record verrà cancellato, confermi?');" 
                        CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                        CommandName="cancella" ImageUrl="/timereport/images/icons/16x16/trash.gif" 
                        Text="<%$ appSettings: DELETE_TXT %>" />
                
                </ItemTemplate>

            </asp:TemplateField>

        </Columns>
        <PagerStyle CssClass="GV_footer" />
        <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
    </asp:GridView>
    
    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/CostRateProgetto/CostRate_lookup_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

    <asp:SqlDataSource ID="DSPersons" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name">

    </asp:SqlDataSource>

    <asp:SqlDataSource ID="DSForcedAccounts" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand= "** costruita in page load **" 
        DeleteCommand="DELETE FROM ProjectCostRate WHERE (ProjectCostRate_id = @ProjectCostRate_id)">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLProgetto" name="Projects_id" PropertyName="SelectedValue" Type="Int16" />
            <asp:ControlParameter ControlID="DDLPersons" name="Persons_id" PropertyName="SelectedValue"  Type="Int16"/>
            <asp:ControlParameter ControlID="DDLManager" name="Manager_id" PropertyName="SelectedValue"  Type="Int16"/>
        </SelectParameters>
         <DeleteParameters>
            <asp:Parameter Name="ProjectCostRate_id" />
        </DeleteParameters>
    </asp:SqlDataSource>

     <!--Seleziona manager -->
    <asp:SqlDataSource ID="DSManager" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT DISTINCT Persons.Persons_id as Manager_id, Persons.Name as ManagerName FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

        <asp:SqlDataSource ID="DSProgetti" runat="server" ConnectionString='<%$ ConnectionStrings:MSSql12155ConnectionString %>' 
        SelectCommand="*** PAGE BEHIND ***"  >
            <SelectParameters>
                <asp:SessionParameter SessionField="persons_id"  Name="clientmanager" DefaultValue="null"></asp:SessionParameter>
            </SelectParameters>
        </asp:SqlDataSource>

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
</html>
