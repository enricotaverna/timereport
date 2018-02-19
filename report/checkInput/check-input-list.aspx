<%@ Page Language="C#" AutoEventWireup="true" CodeFile="check-input-list.aspx.cs" Inherits="report_checkInput_check_input_list" %>

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
<script src="/timereport/include/javascript/timereport.js"></script>

<script>

    // JQUERY

    // gestione validation summary su validator custom (richiede timereport.js)//
    displayAlert();

</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lista Ore</title>
</head>

<body>
   
   <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="form1" runat="server">

    <!--**** Riquadro navigazione ***-->    
    <div id="PanelWrap"> 

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

    <table width="760" border="0" class="GridTab">
        <tr>
        <td>
            TR Chiuso:
        </td>
        <td>
            <asp:DropDownList ID="DL_TRChiuso" runat="server" AutoPostBack="True"  CssClass="TabellaLista" >
                <asp:ListItem Selected="True" Value="all">Tutti i valori</asp:ListItem>
                <asp:ListItem Value="1">Chiuso</asp:ListItem>
                <asp:ListItem Value="0">Non Chiuso</asp:ListItem>
            </asp:DropDownList>
        </td>
        <td>
            Società:</td>
        <td>
                <asp:DropDownList ID="DL_societa" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DS_societa" DataTextField="Name" DataValueField="Company_id" 
                    Width="150px"  
                    CssClass="TabellaLista" >
                    <asp:ListItem Text="Tutti i valori" Value="all" />
                </asp:DropDownList>
                &nbsp;<asp:Button class=SmallOrangeButton ID="BTFiltra" runat="server" Text="<%$ appSettings: FILTER_TXT %>" />
        </td>
        </tr>
        </table>

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->

    <div id="PanelWrap">  

        <!-- *** GRID ***  -->
        <asp:GridView ID="GV_ListaOre" runat="server" CssClass="GridView" GridLines="None" EnableModelValidation="True" AutoGenerateColumns="False"   >
            <HeaderStyle CssClass="GV_header" />
            <Columns>
                <asp:BoundField datafield="Nome" headertext="Nome" SortExpression="Nome" />
                <asp:BoundField datafield="Società" headertext="Società"/>
                <asp:BoundField datafield="OreContratto" headertext="Ore Contratto"/>
                 <asp:BoundField datafield="GGMancanti" headertext="GG Mancanti"/>
                 <asp:BoundField datafield="StatoTR" headertext="Stato TR"/>
                 <asp:BoundField datafield="GGMesePrecedente" headertext="Mese Precedente"/>
                <asp:BoundField datafield="Dettagli" headertext="Dettagli" HtmlEncode="False" />
            </Columns>
            <FooterStyle CssClass="GV_footer" />
            <RowStyle CssClass="GV_row" />
            <AlternatingRowStyle CssClass="GV_row_alt"/>

        </asp:GridView>
    
    <div class="buttons">               
        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" OnClick="BtnExport_Click"   />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>"  CssClass="greybutton" OnClientClick="JavaScript:window.history.back(1);return false;"  />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

    </form>

    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>
    </div>  

    <asp:SqlDataSource ID="DS_societa" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT DISTINCT Company.Company_id, Company.Name, Persons.Active FROM Company INNER JOIN Persons ON Company.Company_id = Persons.Company_id WHERE (Persons.Active = 1) ORDER BY Company.Name">
    </asp:SqlDataSource>

</body>
</html>

