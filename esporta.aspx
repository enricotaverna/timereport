<%@ Page Language="C#" AutoEventWireup="true" CodeFile="esporta.aspx.cs" Inherits="Esporta"     %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Esporta</title>

    <link href="include/newstyle.css" rel="stylesheet" type="text/css">
<%--    <link href="include/jquery/bootstrap-switch/bootstrap.min.css" rel="stylesheet" />
    <link href="include/jquery/bootstrap-switch/bootstrap-switch.css" rel="stylesheet" />--%>
    <link href="include/jquery/chosen/chosen.css" rel="stylesheet" /> <%--Chosen - Dropdown list multiple--%>

</head>

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.js"></script>


<%--Bootstrap Switch: trasforma i check box in switch--%>
<%--<script src="include/jquery/bootstrap-switch/bootstrap-switch.min.js"></script>--%>

<%--Chosen - Dropdown list multiple--%>
<script src="include/jquery/chosen/chosen.jquery.min.js"></script>

<script>

    $(function () {

        // trasforma checkbox in switch
        //$("[name='CBProgettiDisattivi']").bootstrapSwitch();

        // attiva chosen
        $(".chosen-select").chosen({ width: "410px" });

    });

</script>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div id="PanelWrap" style="width: 90%;" >
            <table  style="width: 100%;">
                
                <tr>
                    <td style="padding-bottom: 10px;">
                        <!--**** Prima colonna primo Box ***-->
                        <div class="RoundedBox" style="width: 400px;" id="DivProgetti" runat="server">
                            <asp:CheckBox name="CBProgettiDisattivi" ID="CBProgettiDisattivi" runat="server" Text="Includi progetti non attivi" Font-Bold="False" AutoPostBack="True" Checked="True" meta:resourcekey="CBProgettiDisattiviResource1" />
                        </div>
                        <!--End roundedBox-->
                    </td>
                    <td  style="padding-bottom: 10px">
                        <!--**** Seconda colonna primo Box ***-->
                        <div class="RoundedBox" style="width: 400px;float: right" id="DivPersone" runat="server">
                            <asp:CheckBox name="CBPersoneDisattive" ID="CBPersoneDisattive" runat="server" Text="Includi persone non attive" Font-Bold="False" AutoPostBack="True" Checked="True" meta:resourcekey="CBPersoneDisattiveResource1" />
                        </div>
                    </td>
                </tr>

                <tr>
                    <td style="text-align:left;vertical-align:top">
                        <!--**** Prima colonna secondo Box ***-->
                                 <asp:ListBox ID="CBLProgetti" runat="server" SelectionMode="Multiple" DataSourceID="DSProgetti" DataTextField="txtcodes" 
                                              DataValueField="ProjectCode"  OnLoad="CBLProgetti_Load"  class="chosen-select" data-placeholder="<%$ Resources:selprogetti%>" ></asp:ListBox>

                                <asp:SqlDataSource ID="DSProgetti" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                                    SelectCommand="***">
                                </asp:SqlDataSource>

                        <!--End roundedBox-->
                    </td>
                    <td style="text-align:right;vertical-align:text-top">
                        <!--**** Seconda colonna Seconda Box ***-->
 
                                <asp:ListBox ID="CBLPersone" runat="server" SelectionMode="Multiple" DataSourceID="DSPersone" DataTextField="name"   style="text-align:left" 
                                              DataValueField="Persons_id"  OnLoad="CBLPersone_Load" class="chosen-select" data-placeholder="<%$ Resources:selpersone%>" meta:resourcekey="CBLPersoneResource1" ></asp:ListBox>
     
                                <asp:SqlDataSource ID="DSPersone" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                                    SelectCommand="*"></asp:SqlDataSource>

                    </  td>
                </tr>
            </table>
            
            </div> <!--End Panelwrap -->

            <div id="FormWrap" style="width: 90%; margin-top: 25px;">

                <div class="formtitle" style="width: 98%">Report</div>

                <div class="input nobottomborder" id="DivCliente" runat="server">
                    <div class="inputtext">  <asp:Literal runat="server" Text="<%$ Resources:cliente%>" /> </div>
                    <div class="InputcontentDDL">
                        <asp:DropDownList ID="DDLClienti" runat="server" DataSourceID="Clienti"
                            DataTextField="coddes" DataValueField="CodiceCliente"
                            AppendDataBoundItems="True" meta:resourcekey="DDLClientiResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource1" />
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Clienti" runat="server"
                            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                            SelectCommand="SELECT [CodiceCliente], ([CodiceCliente] + ' ' + [Nome1]) as coddes FROM [Customers] WHERE ([FlagAttivo] = @FlagAttivo) ORDER BY [CodiceCliente]">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="1" Name="FlagAttivo" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>

                <div class="input nobottomborder" id="DivManager" runat="server">
                    <div class="inputtext">Manager</div>
                    <div class="InputcontentDDL">
                        <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="Manager"
                            DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True" meta:resourcekey="DDLManagerResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource2" />
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="Manager" runat="server"
                            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                            SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
                            <SelectParameters>
                                <asp:Parameter DefaultValue="1" Name="Active" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                </div>

                <div class="input nobottomborder" id="DivSocieta" runat="server">
                    <div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:societa%>" /></div>
                    <div class="InputcontentDDL">
                        <asp:DropDownList ID="DDLsocieta" runat="server" DataSourceID="societa"
                            DataTextField="Name" DataValueField="Company_id"
                            AppendDataBoundItems="True" meta:resourcekey="DDLsocietaResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource3" />
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="societa" runat="server"
                            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                            SelectCommand="SELECT [Company_id], [Name] FROM [Company] ORDER BY [Name]"></asp:SqlDataSource>
                    </div>
                </div>

                <div class="input nobottomborder">
                    <div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:rangedate%>" /></div>
                    <div class="InputcontentDDL" style="float: left; width: 170px">
                        <asp:DropDownList runat="server" ID="DDLFromMonth" meta:resourcekey="DDLFromMonthResource1"></asp:DropDownList></div>

                    <span class="InputcontentDDL" style="position: relative; left: 10px; float: left; width: 100px">
                        <asp:DropDownList runat="server" ID="DDLFromYear" meta:resourcekey="DDLFromYearResource1"></asp:DropDownList>
                    </span>

                    <span class="InputcontentDDL" style="position: relative; left: 70px; float: left; width: 170px">
                        <asp:DropDownList runat="server" ID="DDLToMonth" meta:resourcekey="DDLToMonthResource1"></asp:DropDownList>
                    </span>

                    <span class="InputcontentDDL" style="position: relative; left: 80px; float: left; width: 100px">
                        <asp:DropDownList runat="server" ID="DDLToYear" meta:resourcekey="DDLToYearResource1"></asp:DropDownList>
                    </span>

                </div>

                <!-- *** flag solo mie ore ***  -->
                <div class="input nobottomborder" id="DivMieore" runat="server">
                    <div class="inputtext"></div>
                    <div class="Inputcontent" >
                    <asp:CheckBox name="mieore" ID="mieore" runat="server" Text="Solo i miei consuntivi" Font-Bold="False" meta:resourcekey="mieoreResource1" />
                    </div>  
                </div>

                <!-- *** separatore ***  -->
                <div class="input"></div>

                <div class="input nobottomborder">
                    <div class="inputtext"><asp:Literal runat="server" Text="<%$ Resources:estrazione%>" /></div>
                    <div class="Inputcontent">
                        <asp:RadioButtonList ID="RBTipoReport" runat="server" RepeatColumns="3" meta:resourcekey="RBTipoReportResource1">
                            <asp:ListItem Selected="True" Value="1" meta:resourcekey="ListItemResource4">Dettaglio ore</asp:ListItem>
                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource5">Dettaglio Spese</asp:ListItem>
                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource6">Totali ore</asp:ListItem>
                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource7">Totali Spese</asp:ListItem>
                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource8">Giornate x mese</asp:ListItem>
                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource9">Spese x mese</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>

                <div class="buttons">
<%--                    <asp:Button ID="sottometti" runat="server" Text="<%$ Resources:timereport, REPORT_TXT%>" CssClass="orangebutton" OnClick="sottometti_Click" meta:resourcekey="sottomettiResource1" />--%>
                    <asp:Button ID="download" runat="server"   Text="<%$ Resources:timereport, EXPORT_TXT%>" CssClass="orangebutton" OnClick="sottometti_Click" meta:resourcekey="downloadResource1" />
                </div>

            </div>
            <%-- END FormWrap  --%>
        </form>

    </div>
    <!-- END MainWindow -->

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>  
    </div>

</body>
</html>
