<%@ Page Language="C#" AutoEventWireup="true" CodeFile="imposta-valori-utenti.aspx.cs" Inherits="m_gestione_ForzaUtenti_imposta_valori_utenti" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/jquery/multiselect/multi-select.css" media="screen" rel="stylesheet" type="text/css">
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">

<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>
 <script src="/timereport/include/jquery/multiselect/jquery.multi-select.js" type="text/javascript"></script>

<!-- Menu -->
<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<html>

<head>
    <title>Lista consulenti</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <div id="FormWrap" class="StandardForm" style="width: 740px">

            <!-- lo stile è cambiato per consentire l'adattamento  -->
            <form name="form1" runat="server"  style="overflow-y: visible">

                <div id="tabs" style="display:none">     
                    
                  <ul>
                    <li><a href="#tabs-1">Progetti</a></li>
                    <li><a href="#tabs-2">Spese</a></li>
                  </ul>

<%--                <!-- *** TITOLO FORM ***  -->
                <div class="formtitle" style="width: 740px">
                    <asp:Label ID="lbNome" runat="server" Text="Consulente: "></asp:Label>
                </div>--%>

                <div id="tabs-1" style="height:420px;width:100%"> 

                <!-- *** spazio bianco nel form ***  -->
                <p style="margin-bottom: 20px;"></p>

                            <div align="center">

                                <asp:ListBox ID="LBProgetti" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSProgetti"
                                    DataTextField="ProjectName" DataValueField="Projects_Id" Rows="30" OnDataBound="LBProgetti_DataBound" ></asp:ListBox>

                            </div>

<%--                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                --%>

                </div> <%--tabs-1--%>

                <div id="tabs-2" style="height:420px;width:100%"> 

                <!-- *** spazio bianco nel form ***  -->
                <p style="margin-bottom: 20px;"></p>

                            <div align="center">

                                 <asp:ListBox ID="LBSpese" runat="server" SelectionMode="Multiple"
                                    data-placeholder="seleziona uno o più valori" DataSourceID="DSExpenseType"
                                    DataTextField="ExpenseTypeName" DataValueField="ExpenseType_Id" Rows="20" OnDataBound="LBSpese_DataBound"></asp:ListBox>

                            </div>

<%--                            <asp:Button ID="aspese" runat="server"  CommandName="Insert" CssClass="SmallGreyButton" Text="<%$ appSettings: RESET_TXT %>" OnClick="aspese_Click"  />                                --%>

                </div> <%--tabs-2--%>                        

                <!-- *** BOTTONI ***  -->
                <div class="buttons">
                    <asp:Button ID="BTSave" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                    <asp:Button ID="BTreset" runat="server"  CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: RESET_TXT %>"   />                                
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />
                </div>

            </form>

            </div> <%--Tab view--%>

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

    $('#LBProgetti').multiSelect({
        selectableHeader: "<div class='multi-select-header'>progetti selezionabili</div>",
        selectionHeader: "<div class='multi-select-header'>abilitazioni <%=Session["username"]%></div>",
        dblClick : true
    }
    )
    $('#LBSpese').multiSelect({
        selectableHeader: "<div class='multi-select-header'>spese selezionabili</div>",
        selectionHeader: "<div class='multi-select-header'>abilitazioni <%=Session["username"]%></div>",
        dblClick : true
    })

    $("#tabs").tabs(); // abilitate tab view
    $("#tabs").show();

    $("#BTreset").click(function () {

        if ($("#tabs-2").css("display") == "none" )  // selezionati progetti
            $('#LBProgetti').multiSelect('deselect_all');
        else // spese
            $('#LBSpese').multiSelect('deselect_all');
        return false;
    });

    $("#BTsave").click(function () {

        $(":button").unbind('click');
        document.body.style.cursor = 'wait';
    });


</script>

</html>

<asp:sqldatasource runat="server" connectionstring="<%$ ConnectionStrings:MSSql12155ConnectionString %>" selectcommand="SELECT ProjectCode + ' ' + left(Name,20) AS ProjectName, Projects_Id FROM Projects WHERE (Active = 1) ORDER BY ProjectName" id="DSProgetti"></asp:sqldatasource>
<asp:sqldatasource runat="server" connectionstring="<%$ ConnectionStrings:MSSql12155ConnectionString %>" selectcommand="SELECT ExpenseCode + ' ' + left(Name,20) AS ExpenseTypeName, ExpenseType_Id FROM ExpenseType WHERE (Active = 1) ORDER BY ExpenseTypeName" id="DSExpenseType"></asp:sqldatasource>
