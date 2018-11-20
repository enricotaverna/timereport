<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Template_lookup_list.aspx.cs" Inherits="m_gestione_Template_lookup_list" %>

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
    <title>*TMP* TITOLO *TMP*</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">  
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="form1" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"  > 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

    <!--**** Tabella che contiene i filtri ***-->  
    <table width="760" border="0" class="GridTab">
        <tr>
            <td>Attivo: </td>
            <td>
                <!--**** Regola DDL ***--> 
                <!--**** Naming DDLNomeControllo ***--> 
                <!--**** Il valore generico vale 0 ***--> 
                <!--**** OnSelectedIndexChanged -> Salva il valore in variabile sesssioni ***--> 
                <asp:DropDownList ID="DDLFlattivo" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DL_flattivo_SelectedIndexChanged"
                    CssClass="TabellaLista" Width="150px">
                    <asp:ListItem Value="99">Tutti i valori</asp:ListItem>
                    <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                    <asp:ListItem Value="0">Non attivo</asp:ListItem>    
                </asp:DropDownList>          
            </td>

            <td>Cliente:</td>
            <td>
                <!--**** Regola DDL ***--> 
                <!--**** DataSourceID -> Database con valori ***--> 
                <!--**** AppendDataBoundItems -> Per aggiungere valore "selezione tutti" ***--> 
                <!--**** DataTextField -> Testo visualizato ***--> 
                <!--**** DataValueField -> Chiave della DDL ***--> 
                <asp:DropDownList ID="DDLCliente" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DSClienti" DataTextField="Nome1" DataValueField="CodiceCliente"
                    OnSelectedIndexChanged="DDLCliente_SelectedIndexChanged" 
                    Width="150px" CssClass="TabellaLista"  >
                    <asp:ListItem Text="Tutti i valori" Value="0"   />   
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>Manager: </td>
            <td>
                <asp:DropDownList ID="DDLManager" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLManager_SelectedIndexChanged" AppendDataBoundItems="True"
                    Width="150px"  CssClass="TabellaLista" DataSourceID="DSManager" DataTextField="Name" DataValueField="Persons_id" OnDataBound="DDLManager_DataBound" >
                    <asp:ListItem Value="0">Tutti i valori</asp:ListItem>   
                </asp:DropDownList>                
            </td>
            <td>Codice progetto:</td>
            <td>
                <asp:TextBox ID="TB_Codice" runat="server" OnTextChanged="TB_Codice_TextChanged"></asp:TextBox>
                &nbsp;<asp:Button class=SmallOrangeButton ID="BTFiltra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" />
            </td>
        </tr>        
    </table>
    <!--**** FINE Tabella che contiene i filtri ***--> 

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap"   >  

    <!--**** Regola DDL ***--> 
    <!--**** OnSelectedIndexChanged -> Lancia form di dettaglio ***--> 
    <!--**** DataKeyNames -> Per aggiungere valore "selezione tutti" ***--> 
    <!--**** OnRowCommand -> Implementa check su cancellazione ***-->
    <!--**** OnDataBound -> Cancella tasto "delete" in caso di manager ***-->
    <asp:GridView ID="GVElenco" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="DSElenco" CssClass="GridView" OnSelectedIndexChanged="GVElenco_SelectedIndexChanged"
        AllowPaging="True" PageSize="15" DataKeyNames="projectcode,projects_id"   
        GridLines="None" EnableModelValidation="True" OnRowCommand="GVElenco_RowCommand" OnDataBound="GVElenco_DataBound" >
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <Columns>
            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
            <asp:BoundField DataField="Projects_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol"  /> 
            <asp:BoundField DataField="ProjectCode" HeaderText="Codice" SortExpression="ProjectCode" />                          
            <asp:BoundField DataField="ProjectName" HeaderText="Nome" SortExpression="ProjectName" />
            <asp:BoundField DataField="ManagerName" HeaderText="Manager" SortExpression="ManagerName" />
            <asp:BoundField DataField="ProjectType" HeaderText="Tipo" SortExpression="ProjectType" />
            <asp:BoundField DataField="RevenueBudget" HeaderText="Revenue Bdg" SortExpression="RevenueBudget" />
            <asp:BoundField DataField="SpeseBudget" HeaderText="Spese Bdg" SortExpression="SpeseBudget" />
            <asp:BoundField DataField="MargineTarget" HeaderText="Margine Tgt" SortExpression="MargineTarget" />
            <asp:CheckBoxField  DataField="Active" HeaderText="Attivo" SortExpression="Active" />
            
            <asp:TemplateField >
                <ItemTemplate>
                    
                        <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False"  PostBackUrl='<%# Eval("ProjectCode", "Projects_lookup_form.aspx?ProjectCode={0}") %>'
                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;
                        
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField >
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
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/CostRate/CostRate_lookup_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

     <!--Seleziona manager -->
    <asp:SqlDataSource ID="DSManager" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

     <!--Seleziona clienti -->
    <asp:SqlDataSource ID="DSCLienti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT CodiceCliente, Nome1 FROM Customers WHERE (FlagAttivo = 1) ORDER BY Nome1">

    </asp:SqlDataSource>
        
     <asp:SqlDataSource ID="DSElenco" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN CODE BEHIND ***" >
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLFlattivo" Name="DDLFlattivo" PropertyName="SelectedValue" Type="String" />
            <asp:ControlParameter ControlID="DDLmanager" Name="persons_id" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLCliente" Name="CodiceCliente" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="TB_Codice" Name="TB_Codice" PropertyName="text" DefaultValue="%" />
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
