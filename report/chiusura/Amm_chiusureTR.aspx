<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Amm_chiusureTR.aspx.cs" Inherits="report_chiusura_Amm_chiusureTR" %>

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
    <title>Chiusure TR</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">  
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>

     <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="FVForm" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"  > 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

    <table width="760" border="0" class="GridTab">
        <tr>
            <td>Anno: </td>
         <td>
          <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True"  OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
            AutoPostBack="True" >
          </asp:DropDownList>          
        </td>

        <td></td>
        <td>Persona:</td>
        <td>
                <asp:DropDownList ID="DDLPersona" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id"
                    OnSelectedIndexChanged="DDLPersona_SelectedIndexChanged" 
                    Width="150px" CssClass="TabellaLista"  >
                    <asp:ListItem Text="Tutti i valori" Value="0"   />
                </asp:DropDownList>
        </td></tr>

                <tr>
        <td>Mese: </td>
         <td>
                <asp:DropDownList ID="DDLMese" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLMese_SelectedIndexChanged" AppendDataBoundItems="True"
                  ssClass="TabellaLista" />            
        </td><td></td>
        <td>&nbsp;</td>
        <td>
           &nbsp;
            </td></tr>
        
    </table>

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap"   >  

    <asp:GridView ID="GVLogTR" runat="server" AllowSorting="True" AutoGenerateColumns="False"  
        DataSourceID="DSLogTR" CssClass="GridView" AllowPaging="True" PageSize="15"   GridLines="None" EnableModelValidation="True" OnRowCommand="GVLogTR_RowCommand" OnRowDataBound="GVLogTR_RowDataBound"  >
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <Columns>
            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
            <asp:BoundField DataField="LOGTR_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" HeaderText="LOGTR_id" SortExpression="LOGTR_id"  /> 
            <asp:BoundField DataField="Anno" HeaderText="Anno" SortExpression="Anno" />
            <asp:BoundField DataField="Mese" HeaderText="Mese" SortExpression="Mese" />                          
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="Stato" HeaderText="Stato" SortExpression="Stato" />            
            <asp:BoundField DataField="CreatedBy" HeaderText="Creato da" SortExpression="CreatedBy"/>
            <asp:BoundField DataField="CreationDate" HeaderText="Data creazione" SortExpression="CreationDate" dataformatstring="{0:d}" />
            <asp:BoundField DataField="LastModifiedBy" HeaderText="Modificato da" SortExpression="LastModifiedBy" />
            <asp:BoundField DataField="LastModificationDate" HeaderText="Data Modifica" SortExpression="LastModificationDate" dataformatstring="{0:d}" />

            <asp:TemplateField ItemStyle-Width="20px"> <ItemTemplate>                    
                        <asp:ImageButton ID="BT_lock" runat="server" CausesValidation="False"  CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                        CommandName="lock" ImageUrl="/timereport/images/icons/16x16/lock.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;                        
                </ItemTemplate></asp:TemplateField>
            
            <asp:TemplateField ItemStyle-Width="20px"><ItemTemplate>                    
                        <asp:ImageButton ID="BT_unlock" runat="server" CausesValidation="False"    CommandArgument="<%# ((GridViewRow) Container).RowIndex %>"
                        CommandName="unlock" ImageUrl="/timereport/images/icons/16x16/unlock.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;                        
                </ItemTemplate></asp:TemplateField>

        </Columns>
        <PagerStyle CssClass="GV_footer" />
        <HeaderStyle CssClass="GV_header" />
        <AlternatingRowStyle CssClass="GV_row_alt " />
    </asp:GridView>
    
    <%--    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Project/Projects_lookup_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->--%>

    </div> <!--End PanelWrap-->

     <!--Seleziona Persone -->
    <asp:SqlDataSource ID="DSPersons" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name">
    </asp:SqlDataSource>
       
    <!--Seleziona LOGTR -->  
    <asp:SqlDataSource ID="DSLogTR" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="SELECT LogTR.LogTR_id, LogTR.Persons_id, LogTR.Mese, LogTR.Anno, Persons.Name, LogTR.Stato, LogTR.CreationDate, LogTR.CreatedBy, LogTR.LastModifiedBy, LogTR.LastModificationDate FROM LogTR INNER JOIN Persons ON LogTR.Persons_id = Persons.Persons_id WHERE LogTR.Mese = @Mese AND (LogTR.Anno = @Anno) AND (LogTR.Persons_id = @persona OR @persona='0') ORDER BY LogTR.Anno, LogTR.Mese, Persons.Name"  >
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLMese"   Name="Mese" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2015" Name="Anno" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLPersona" Name="Persona" PropertyName="SelectedValue" />
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
