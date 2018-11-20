<%@ Page Language="C#" AutoEventWireup="true" CodeFile="esporta.aspx.cs" Inherits="Esporta" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

    <link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
    <link href="include/newstyle.css" rel="stylesheet" type="text/css">
    <link href="include/jquery/chosen/chosen.css" rel="stylesheet" />

    <!-- Menù  -->
    <script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" lingua='<%= Session["lingua"]%>' userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
    <script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

    <!-- Jquery   -->

    <script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
    <script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
    <script src="/timereport/include/jquery/jquery-ui.min.js"></script>

    <%--Chosen - Dropdown list multiple--%>
    <script src="include/jquery/chosen/chosen.jquery.min.js"></script>
    
<head id="Head1" runat="server">

    <title>Esporta</title>

<style>

    .custom-checkboxradio-label {
        padding: .5em 1em !important;  
        border-radius: 6px !important; 
        box-shadow:  none !important; 
        }

    .chosen-container-multi .chosen-choices {
        /*height: 32px;*/
        border-radius: 6px;
    }

</style>

</head>



<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <form id="form1" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div id="PanelWrap" style="width:90%;">

               <table style="width: 100%;">
                   <tr>
                       <td style="text-align: left; vertical-align: top; width:75px">
                            <asp:CheckBox ToolTip ="Include non attivi" name="CBProgettiDisattivi" ID="CBProgettiDisattivi"  Text="Non attivi" runat="server"  meta:resourcekey="CBProgettiDisattivi" Font-Bold="False" AutoPostBack="True" Checked="True" />              
                       </td>

                       <td style="text-align:left">
                            <asp:ListBox ID="CBLProgetti" runat="server" SelectionMode="Multiple" DataSourceID="DSProgetti" DataTextField="txtcodes" 
                                DataValueField="Projects_id" OnLoad="CBLProgetti_Load" class="chosen-select" data-placeholder="<%$ Resources:selprogetti%>"></asp:ListBox>
                       </td>

                       <td style="width:70px"></td>

                       <td style="text-align: left; vertical-align: text-top; width:75px">
                            <asp:CheckBox name="CBPersoneDisattive" ToolTip ="Include non attive"  ID="CBPersoneDisattive" runat="server" Text="non attive" Font-Bold="False" AutoPostBack="True" Checked="True" meta:resourcekey="CBPersoneDisattive" />
                       </td>

                       <td>
                            <asp:ListBox ID="CBLPersone" runat="server" SelectionMode="Multiple" DataSourceID="DSPersone" DataTextField="name" Style="text-align: left"
                            DataValueField="Persons_id" OnLoad="CBLPersone_Load" class="chosen-select" data-placeholder="<%$ Resources:selpersone%>" meta:resourcekey="CBLPersoneResource1"></asp:ListBox>
                        </td>
                    </tr>
                </table>

            </div>
            <!--End Panelwrap -->

            <asp:SqlDataSource ID="DSProgetti" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="***"></asp:SqlDataSource>
            <asp:SqlDataSource ID="DSPersone" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" SelectCommand="*"></asp:SqlDataSource>

            <div id="FormWrap" style="width: 90%; margin-top: 25px;" class="StandardForm">

                <div class="formtitle" style="width: 844px">Report</div>

                <div class="input nobottomborder" id="DivCliente" runat="server">
                    <div class="inputtext">
                        <asp:Literal runat="server" Text="<%$ Resources:cliente%>" />
                    </div>

                    <label class="dropdown">
                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLClienti" runat="server" DataSourceID="Clienti"
                            DataTextField="coddes" DataValueField="CodiceCliente"
                            AppendDataBoundItems="True" meta:resourcekey="DDLClientiResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource1" />
                        </asp:DropDownList>
                    </label>

                    <asp:SqlDataSource ID="Clienti" runat="server"
                        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                        SelectCommand="SELECT [CodiceCliente], ([CodiceCliente] + ' ' + [Nome1]) as coddes FROM [Customers] WHERE ([FlagAttivo] = @FlagAttivo) ORDER BY [CodiceCliente]">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="1" Name="FlagAttivo" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                </div>

                <div class="input nobottomborder" id="DivManager" runat="server">
                    <div class="inputtext">Manager</div>

                    <label class="dropdown">
                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLManager" runat="server" DataSourceID="Manager"
                            DataTextField="Name" DataValueField="Persons_id" AppendDataBoundItems="True" meta:resourcekey="DDLManagerResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource2" />
                        </asp:DropDownList>
                    </label>

                    <asp:SqlDataSource ID="Manager" runat="server"
                        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                        SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons INNER JOIN Projects ON Persons.Persons_id = Projects.ClientManager_id WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
                        <SelectParameters>
                            <asp:Parameter DefaultValue="1" Name="Active" />
                        </SelectParameters>
                    </asp:SqlDataSource>

                </div>

                <div class="input nobottomborder" id="DivSocieta" runat="server">
                    <div class="inputtext">
                        <asp:Literal runat="server" Text="<%$ Resources:societa%>" /></div>

                  <label class="dropdown">
                        <!-- per stile CSS -->
                        <asp:DropDownList ID="DDLsocieta" runat="server" DataSourceID="societa"
                            DataTextField="Name" DataValueField="Company_id"
                            AppendDataBoundItems="True" meta:resourcekey="DDLsocietaResource1">
                            <asp:ListItem Value="" Text="Selezionare un valore" meta:resourcekey="ListItemResource3" />
                        </asp:DropDownList>
                  </label>

                    <asp:SqlDataSource ID="societa" runat="server"
                        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                        SelectCommand="SELECT [Company_id], [Name] FROM [Company] ORDER BY [Name]"></asp:SqlDataSource>
                </div>

                <div class="input nobottomborder">
                    <div class="inputtext">
                        <asp:Literal runat="server" Text="<%$ Resources:rangedate%>" /></div>

                    <span style="position: relative; float: left">
                        <label class="dropdown">
                            <asp:DropDownList runat="server" ID="DDLFromMonth" Width="170px"></asp:DropDownList>
                        </label>
                    </span>

                    <span style="position: relative; left: 10px; float: left; width: 100px">
                        <label class="dropdown">
                            <asp:DropDownList runat="server" ID="DDLFromYear" Width="100px"></asp:DropDownList>
                        </label>
                    </span>

                    <span style="position: relative; left: 70px; float: left; width: 170px">
                        <label class="dropdown">
                            <asp:DropDownList runat="server" ID="DDLToMonth" Width="170px"></asp:DropDownList>
                        </label>
                    </span>

                    <span style="position: relative; left: 80px; float: left; width: 100px">
                        <label class="dropdown">
                            <asp:DropDownList runat="server" ID="DDLToYear" Width="100px"></asp:DropDownList>
                        </label>
                    </span>

                </div>

                <!-- *** flag solo mie ore ***  -->
                <div class="input nobottomborder">
                <div class="inputtext"></div>
                <asp:CheckBox ID="CBmieore"  runat="server" />
                <asp:Label AssociatedControlID="CBmieore" runat="server" Text="Solo i miei consuntivi" meta:resourcekey="CBmieore"></asp:Label>
                </div>

                <!-- *** separatore ***  -->
                <div class="input"></div>

                <div class="input nobottomborder">
                    <div class="inputtext">
                        <asp:Literal runat="server" Text="<%$ Resources:estrazione%>" /></div>
                    <div class="Inputcontent">
                        <asp:RadioButtonList ID="RBTipoReport" runat="server" meta:resourcekey="RBTipoReportResource1">
                            <%--                        <asp:ListItem Selected="True" Value="1" meta:resourcekey="ListItemResource4">Dettaglio ore</asp:ListItem>
                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource5">Dettaglio Spese</asp:ListItem>
                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource6">Totali ore</asp:ListItem>
                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource7">Totali Spese</asp:ListItem>--%>
                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource8" Selected="True">Ore</asp:ListItem>
                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource9">Spese</asp:ListItem>
                        </asp:RadioButtonList>
                    </div>
                </div>

                <div class="buttons">
                    <%--                    <asp:Button ID="sottometti" runat="server" Text="<%$ Resources:timereport, REPORT_TXT%>" CssClass="orangebutton" OnClick="sottometti_Click" meta:resourcekey="sottomettiResource1" />--%>
                    <asp:Button ID="download" runat="server" Text="<%$ Resources:timereport, EXPORT_TXT%>" CssClass="orangebutton" OnClick="sottometti_Click" meta:resourcekey="downloadResource1" />
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
        <div id="WindowFooter-R">
            <asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" />
            <%= Session["UserName"]  %></div>
    </div>

    <script>

        $(function () {

            // attiva chosen
            $(".chosen-select").chosen({ width: "310px", height: "32px" });

            // checkbutton                
            $("#CBProgettiDisattivi").checkboxradio({
                icon: true, 
                classes: {
                   "ui-checkboxradio-label": "custom-checkboxradio-label",
                }
            });


            $("#CBPersoneDisattive").checkboxradio({
                icon: true, 
                classes: {
                    "ui-checkboxradio-label": "custom-checkboxradio-label",
                }
            });

            
            $("#CBmieore").addClass('css-checkbox'); // post rendering dei checkbox in ASP.NET

        });

    </script>

</body>

</html>
