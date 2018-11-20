<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Calendario_list.aspx.cs" Inherits="m_Calendario_lookup_list" %>

<!--**** STEP ***--> 
<!--**** 1) Creazione Datasource principale della GridView ***--> 
<!--**** 2) Aggiornamento colonne GridView ***--> 
<!--**** 2) Creazione controlli selezione ***--> 

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
    <div class="RoundedBox" style="width:550px;margin: 20px auto 0;" >

    <!--**** Tabella che contiene i filtri ***-->  
    <table width="560" border="0" class="GridTab">
        <tr>
            <td>Sede: </td>
            <td>
                <asp:DropDownList ID="DDLSede" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLSede_SelectedIndexChanged"
                CssClass="TabellaLista" Width="150px" DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id">
            </asp:DropDownList>  
            </td>

            <td>Anno:</td>
            <td>
                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True"  OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
                AutoPostBack="True" >
          </asp:DropDownList>    
            </td>
        </tr>
       
    </table>
    <!--**** FINE Tabella che contiene i filtri ***--> 

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap"   style="width:560px"  >  

    <!--**** Regola DDL ***--> 
    <!--**** OnSelectedIndexChanged -> Lancia form di dettaglio ***--> 
    <!--**** DataKeyNames -> Per aggiungere valore "selezione tutti" ***--> 
    <!--**** OnRowCommand -> Implementa check su cancellazione ***-->
    <!--**** OnDataBound -> Cancella tasto "delete" in caso di manager ***-->
    <asp:GridView ID="GVElenco" runat="server" AllowSorting="True" AutoGenerateColumns="False"
        DataSourceID="DSElenco" CssClass="GridView" OnSelectedIndexChanged="GVElenco_SelectedIndexChanged"
        AllowPaging="True" PageSize="15" DataKeyNames="CalendarHolidays_id"   
        GridLines="None" EnableModelValidation="True"  style="width:560px"  >
        <FooterStyle CssClass="GV_footer" />
        <RowStyle Wrap="False" CssClass="GV_row" />
        <Columns>
            <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
            <asp:BoundField DataField="CalendarHolidays_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol"  /> 
            <asp:BoundField DataField="CalCode" HeaderText="Sede" SortExpression="CalCode" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
            <asp:BoundField DataField="CalYear" HeaderText="Anno" SortExpression="CalYear" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center"  />
            <asp:BoundField DataField="CalDay" HeaderText="Data" SortExpression="CalDay" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" dataformatstring="{0:d}" />
            
            <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate>
                    
                        <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False"  PostBackUrl='<%# Eval("CalendarHolidays_id", "Calendario_form.aspx?CalendarHolidays_id={0}") %>'
                        CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif" 
                        Text="<%$ appSettings: EDIT_TXT %>" />
                        &nbsp;
                        
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField ItemStyle-Width="20px">
                <ItemTemplate >
                           
                        <asp:ImageButton ID="BT_delete" runat="server" CausesValidation="False" 
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
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Calendario/Calendario_form.aspx" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

     <!-- DATASOURCE PRINCIPALE-->  
     <asp:SqlDataSource ID="DSElenco" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN CODE BEHIND ***" 
        DeleteCommand="DELETE FROM [CalendarHolidays] WHERE [CalendarHolidays_id] = @CalendarHolidays_id" >
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2018" Name="CalYear" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLSede" Name="Calendar_id" PropertyName="SelectedValue" />
        </SelectParameters>
         <DeleteParameters>
            <asp:Parameter  Name="CalendarHolidays_id" />
        </DeleteParameters>
    </asp:SqlDataSource>



    <!--DATASOURCE Sede per DDL -->
    <asp:SqlDataSource ID="DSSede" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT Calendar_id, CalName FROM Calendar ORDER BY CalName">
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
