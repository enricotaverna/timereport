<%@ Page Language="C#" AutoEventWireup="true" CodeFile="imposta-valori-utenti - Copia.aspx.cs" Inherits="m_gestione_ForzaUtenti_imposta_valori_utenti" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Attiva finestra per messaggio di conferma slvataggio   -->
<script>

    // ** NB: deve essere aggiunto un DIV dialog nel corpo HTML
    function ShowPopup(message) {
        $(function () {
            $("#dialog").html(message);
            $("#dialog").dialog({
                title: "Messaggio",
                buttons: {
                    Close: function () {
                        $(this).dialog('close');
                    }
                },
                modal: true 
            });
        });
    };

</script>

<html>

<head>

    <title>Lista utenti</title>

    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <div id="FormWrap" style="width: 740px">

            <!-- lo stile è cambiato per consentire l'adattamento  -->
            <form name="form1" runat="server" class="StandardForm" style="overflow-y: visible">

                <!-- *** TITOLO FORM ***  -->
                <div class="formtitle" style="width: 740px">
                    <asp:Label ID="lbNome" runat="server" Text="Consulente: "></asp:Label>
                </div>

                <table width="70%" border="0" align="center" cellpadding="0" cellspacing="0" class="BoxDialogo">

                    <tr>
                        <td width="40%">&nbsp;</td>
                        <td width="40%">&nbsp;</td>
                    </tr>

                    <tr>
                        <td class="SeparatoreForm">Progetti</td>
                        <td class="SeparatoreForm">Spese</td>
                    </tr>

                    <tr>
                        <td style="text-align: left; vertical-align: top">
                            <div align="center" style="width: 300px">

                                <asp:ListBox ID="LBProgetti" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSProgetti"
                                    DataTextField="ProjectName" DataValueField="Projects_Id" Rows="20" OnDataBound="LBProgetti_DataBound"></asp:ListBox>

                            </div>

                        </td>
                        <td style="text-align: left; vertical-align: top">
                            <div align="center" style="width: 300px">

                                <asp:ListBox ID="LBSpese" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSExpenseType"
                                    DataTextField="ExpenseTypeName" DataValueField="ExpenseType_Id" Rows="20" OnDataBound="LBSpese_DataBound"></asp:ListBox>

                            </div>


                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="aprogetti" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aprogetti_Click"   />                                
                        <td>
                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                
                    </tr>

                </table>

                <!-- *** spazio bianco nel form ***  -->
                <p style="margin-bottom: 40px;"></p>

                <!-- *** BOTTONI ***  -->
                <div class="buttons">
                    <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />
                </div>

            </form>

        </div>
        <!-- END FormWrap-->

    </div>
    <!-- END MainWindow -->

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa     <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">Utente: <%=Session["UserName"]%></div>
    </div>

</body>
</html>

<asp:sqldatasource runat="server" connectionstring="<%$ ConnectionStrings:MSSql12155ConnectionString %>" selectcommand="SELECT ProjectCode + ' ' + left(Name,25) AS ProjectName, Projects_Id FROM Projects WHERE (Active = 1) ORDER BY ProjectName" id="DSProgetti"></asp:sqldatasource>
<asp:sqldatasource runat="server" connectionstring="<%$ ConnectionStrings:MSSql12155ConnectionString %>" selectcommand="SELECT ExpenseCode + ' ' + left(Name,25) AS ExpenseTypeName, ExpenseType_Id FROM ExpenseType WHERE (Active = 1) ORDER BY ExpenseTypeName" id="DSExpenseType"></asp:sqldatasource>
