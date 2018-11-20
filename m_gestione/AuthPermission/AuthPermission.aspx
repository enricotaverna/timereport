<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AuthPermission.aspx.cs" Inherits="m_gestione_AuthPermission_AuthPermission" %>

<!DOCTYPE html>
<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
<%--SUMO select--%>
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />

<!-- Menù  -->
<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<%--<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>--%>
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script> 

<!-- INCLUDE JS TIMEREPORT   -->
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Attiva finestra per messaggio di conferma salvataggio   -->
<script>

    // JQUERY
         $(function () {

             // attiva sumo select
             $(document).ready(function () {

                 // crea le label per il raggruppamento degli elementi della ListBox
                 setupOptGroups($("#LBPermissions"));

                 // imposta css della listbox
                 $('.select2-auth').SumoSelect();

             });

         });

    // abilita il raggruppamento nel ListBox generato
         function setupOptGroups(select) {
             var optGroups = new Array();
             var i = 0;

             $(select).find("[optgroup]").each(function (index, domEle) {
                 var optGroup = $(this).attr("optgroup");
                 if ($.inArray(optGroup, optGroups) == -1) optGroups[i++] = optGroup;
             });

             for (i = 0; i < optGroups.length; i++) {
                 $("option[optgroup='" + optGroups[i] + "']").wrapAll("<optgroup label='" + optGroups[i] + "'>");
             }
         }

         </script>

<style type="text/css">
    .SumoSelect{width:280px;}
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Livelli autorizzativi</title>
</head>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow" >

        <div id="FormWrap" >

            <form id="FVAuthPermission" runat="server" class="StandardForm">

                <div class="formtitle">Livelli Autorizzativi</div>

                <!-- *** DDL UserLevel ***  -->
                <div class="input nobottomborder">
                    <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Livello"></asp:Label>
              
                         <asp:DropDownList ID="DDLUserLevel" runat="server" AppendDataBoundItems="True" 
                            AutoPostBack="True" DataSourceID="DSUserLevel" DataTextField="Name" DataValueField="UserLevel_id" OnSelectedIndexChanged="DDLUserLevel_SelectedIndexChanged" Height="26px">
                            <asp:ListItem Value="" Text="Selezionare una autorizzazione" />
                        </asp:DropDownList>

                         <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="DDLUserLevel" Display="None"
                            ErrorMessage="Specificare un livello di autorizzazione" InitialValue="0"></asp:RequiredFieldValidator>
            
                </div>

                <div style="position:absolute"> <!-- aggiunto per evitare il troncamento della dropdonwlist -->
              
                <!-- *** DDL AuthPermission ***  -->
                <span class="inputtext" style="margin-left: 10px">Autorizzazioni</span>
                  
                 <span>
                    <asp:ListBox ID="LBPermissions" runat="server" SelectionMode="Multiple" DataTextField="PermissionText"   
                        DataValueField="Task_id" data-placeholder="Inserisci le autorizzazioni" multiple="multiple" class="select2-auth"  ></asp:ListBox>
                </span>
                
                </div>

                <!-- *** spazio bianco nel form ***  -->
                <p style="margin-bottom: 100px;"></p>
                
                 <!-- *** BOTTONI ***  -->
                <div class="buttons">
                    <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" OnClick="InsertButton_Click" />
                    <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" />
                </div>

            </form>

        </div>
        <%-- END FormWrap  --%>
    </div>
    <%-- END MainWindow --%>

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

<%--    Dataset progetti   --%>
<asp:sqldatasource id="DSUserLevel" runat="server"
    connectionstring="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
    selectcommand="SELECT UserLevel_ID, Name from AuthUserLevel ORDER BY UserLevel_ID">
</asp:sqldatasource>

</html>
