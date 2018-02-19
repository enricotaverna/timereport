<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Straordinari-list.aspx.cs" Inherits="report_Straordinarit_list" EnableEventValidation="false" %>

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

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lista Straordindari</title>
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
        <asp:GridView ID="GV_ListaOre" runat="server" CssClass="GridView" GridLines="None"  AutoGenerateColumns="False"  AllowPaging="True" PageSize ="<%$ appSettings: GRID_PAGE_SIZE %>" OnDataBound="GV_ListaOre_DataBound" >
            <HeaderStyle CssClass="GV_header" />
            <Columns>
                <asp:BoundField datafield="Nome" headertext="Nome" SortExpression="Nome" />
                <asp:BoundField datafield="Società" headertext="Società"/>
                <asp:BoundField datafield="Data" headertext="data"  />
                <asp:BoundField datafield="Ore Caricate" headertext="Ore" />
                <asp:BoundField datafield="Ore Contratto" headertext="Ore Contratto"   />
                <asp:BoundField datafield="Straordinario" headertext="Straordinario"  />
            </Columns>
            <FooterStyle CssClass="GV_footer" />
            <RowStyle CssClass="GV_row" />
            <AlternatingRowStyle CssClass="GV_row_alt"/>

            <%--START Pager--%>
            <PagerStyle CssClass="GV_pager" /> 
            <PagerTemplate>
                <table>
                    <tr>
                    <td style="width:180px">
                        <label id="MessageLabel"
                        forecolor="white"
                        text="Select a page:"
                        runat="server"/>Page: 
                        <asp:DropDownList id="PageDropDownList"
                        autopostback="true" EnableViewState="true" OnSelectedIndexChanged="Paging_SelectedIndexChanged"                  
                        runat="server" Width="36px" />
                    </td>
                    <td style="width:520px; text-align:center;">
                            <asp:LinkButton ID="btnPrevious" runat="server" OnClick="btnPrevious_Click"><</asp:LinkButton>
                            <asp:label id="CurrentPageLabel" forecolor="white" text=" Page " runat="server"/>
                            <asp:LinkButton ID="btnNext" runat="server" OnClick="btnNext_Click">></asp:LinkButton>
                    </td>

                    </tr>
                </table>
            </PagerTemplate>
            <%--END Pager--%>

        </asp:GridView>
       

    <div class="buttons">  
        
        <%--Messaggio se nessun dato selezionato --%>
        <asp:Label ID="lbMessage" runat="server" Text=""></asp:Label>
                     
        <asp:Button ID="BtnExport" runat="server" CssClass="orangebutton" Text="<%$ appSettings: EXPORT_TXT %>" OnClick="BtnExport_Click"   />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>"  CssClass="greybutton"  />
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

