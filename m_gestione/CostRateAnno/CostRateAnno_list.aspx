<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRateAnno_list.aspx.cs" Inherits="m_CostRateAnno_lookup_list" %>

<!--**** STEP ***--> 
<!--**** 1) Creazione Datasource principale della GridView ***--> 
<!--**** 2) Aggiornamento colonne GridView ***--> 
<!--**** 2) Creazione controlli selezione ***--> 



<!DOCTYPE html>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script>
<script>
    $(function () {

        // nasconde la colonna con la chiave usata nella cancellazione del record
        $('.hiddencol').css({ display: 'none' });

    });
</script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Cost Rate per anno</title>
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
            <td>Stato persona: </td>
            <td>
                <asp:DropDownList ID="DDLFlattivo" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLFlattivo_SelectedIndexChanged"
                CssClass="TabellaLista" Width="150px">
                <asp:ListItem Value="99">Tutti i valori</asp:ListItem>
                <asp:ListItem Selected="True" Value="1">Attivo</asp:ListItem>
                <asp:ListItem Value="0">Non attivo</asp:ListItem>
            </asp:DropDownList>  
            </td>

            <td>Anno:</td>
            <td>
                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True"  OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
                AutoPostBack="True" >
          </asp:DropDownList>    
            </td>
        </tr>
        <tr>
            <td>Persona: </td>
            <td>
                <asp:DropDownList ID="DDLPersona" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLPersona_SelectedIndexChanged" AppendDataBoundItems="True"
                    Width="150px"  CssClass="TabellaLista" DataSourceID="DSPersona" DataTextField="NomePersona" DataValueField="Persons_id" >
                    <asp:ListItem Value="0">Tutti i valori</asp:ListItem>   
                </asp:DropDownList>                
            </td>
            <td> </td>
            <td>
 
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
        AllowPaging="True" PageSize="15" DataKeyNames="PersonsCostRate_id"   
        GridLines="None" EnableModelValidation="True" OnDataBound="GVElenco_DataBound" >
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <Columns>
            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
            <asp:BoundField DataField="PersonsCostRate_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol"  /> 
            <asp:BoundField DataField="NomePersona" HeaderText="Nome Persona" SortExpression="NomePersona" />
            <asp:BoundField DataField="Anno" HeaderText="Anno" SortExpression="Anno" />
            <asp:BoundField DataField="CostRate" HeaderText="Cost Rate" SortExpression="CostRate"  />
            
            <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate>
                    
                        <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False"  PostBackUrl='<%# Eval("PersonsCostRate_id", "CostRateAnno_form.aspx?PersonsCostRate_id={0}") %>'
                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;
                        
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate >
                           
                        <asp:ImageButton ID="BT_delete" runat="server" CausesValidation="False" 
                        OnClientClick="return confirm('Il record verrà cancellato, confermi?');" 
                        CommandName="Delete" ImageUrl="/timereport/images/icons/16x16/trash.gif" 
                        Text="<%$ appSettings: DELETE_TXT %>" />
                
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
        <PagerStyle CssClass="GV_footer" />
        <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
    </asp:GridView>
    
    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/CostRateAnno/CostRateAnno_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

     <!-- DATASOURCE PRINCIPALE-->  
     <asp:SqlDataSource ID="DSElenco" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN CODE BEHIND ***" 
        DeleteCommand="DELETE FROM [PersonsCostRate] WHERE [PersonsCostRate_id] = @PersonsCostRate_id" >
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLPersona" Name="persons_id" PropertyName="SelectedValue" DefaultValue="0" />
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2015" Name="Anno" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLFlattivo" Name="DDLFlattivo" PropertyName="SelectedValue" />
        </SelectParameters>
         <DeleteParameters>
            <asp:Parameter  Name="PersonsCostRate_id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <!--DATASOURCE Persona per DDL -->
    <asp:SqlDataSource ID="DSPersona" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT Persons.Persons_id, Persons.Name as NomePersona FROM Persons WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
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
