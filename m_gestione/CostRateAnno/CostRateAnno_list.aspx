<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRateAnno_list.aspx.cs" Inherits="m_CostRateAnno_lookup_list" %>

<!--**** STEP ***-->
<!--**** 1) Creazione Datasource principale della GridView ***-->
<!--**** 2) Aggiornamento colonne GridView ***-->
<!--**** 2) Creazione controlli selezione ***-->

<!DOCTYPE html>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Cost Rate per anno</title>
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
</head>

<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<body>

    <div id="TopStripe"></div>

    <div id="MainWindow">

        <form id="FVForm" runat="server"  data-parsley-validate="true" >

            <!--**** Riquadro navigazione ***-->
            <div id="PanelWrap">

                <!--**** Primo Box ***-->
                <div class="RoundedBox">

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
                                <asp:DropDownList ID="DDLAnno" runat="server" AppendDataBoundItems="True" OnSelectedIndexChanged="DDLAnno_SelectedIndexChanged"
                                    AutoPostBack="True">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Persona: </td>
                            <td>
                                <asp:DropDownList ID="DDLPersona" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DDLPersona_SelectedIndexChanged" AppendDataBoundItems="True"
                                    Width="150px" CssClass="TabellaLista" DataSourceID="DSPersona" DataTextField="NomePersona" DataValueField="Persons_id">
                                    <asp:ListItem Value="0">Tutti i valori</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                    <!--**** FINE Tabella che contiene i filtri ***-->

                </div>
                <!--End roundedBox-->
            </div>
            <!--End PanelWrap-->

            <div id="PanelWrap">

                <!--**** Regola DDL ***-->
                <!--**** OnSelectedIndexChanged -> Lancia form di dettaglio ***-->
                <!--**** DataKeyNames -> Per aggiungere valore "selezione tutti" ***-->
                <!--**** OnRowCommand -> Implementa check su cancellazione ***-->
                <!--**** OnDataBound -> Cancella tasto "delete" in caso di manager ***-->
                <asp:GridView ID="GVElenco" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                    DataSourceID="DSElenco" CssClass="GridView" OnSelectedIndexChanged="GVElenco_SelectedIndexChanged"
                    AllowPaging="True" PageSize="15" DataKeyNames="PersonsCostRate_id"
                    GridLines="None" EnableModelValidation="True" OnDataBound="GVElenco_DataBound">
                    <FooterStyle CssClass="GV_footer" />
                    <RowStyle Wrap="False" CssClass="GV_row" />
                    <Columns>
                        <%--la classe hiddencol serve per cancellare la colonnda con la chiave da utilizzare nel page behind per validazione--%>
                        <asp:BoundField DataField="PersonsCostRate_id" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" />
                        <asp:BoundField DataField="NomePersona" HeaderText="Nome Persona" SortExpression="NomePersona" />
                        <asp:BoundField DataField="Anno" HeaderText="Anno" SortExpression="Anno" />
                        <asp:BoundField DataField="CostRate" HeaderText="Cost Rate" SortExpression="CostRate" />
                        <asp:BoundField DataField="Comment" HeaderText="Nota"  />

                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>

                                <asp:ImageButton ID="BT_edit" runat="server" CausesValidation="False" PostBackUrl='<%# Eval("PersonsCostRate_id", "CostRateAnno_form.aspx?PersonsCostRate_id={0}") %>'
                                    CommandName="Edit" ImageUrl="/timereport/images/icons/16x16/modifica.gif"
                                    Text="<%$ appSettings: EDIT_TXT %>" />
                                &nbsp;
                        
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField ItemStyle-Width="20px">
                            <ItemTemplate>

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
                    <!-- non fanno validazione perchè richiamano javascript -->
                    <asp:Button ID="btn_crea" formnovalidate ="true" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" />
                    <asp:Button ID="btn_back" formnovalidate ="true" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" CommandName="Cancel" />
                </div>
                <!--End buttons-->

            </div>
            <!--End PanelWrap-->

            <!-- **** Finestre richiesta spese / trasferte **** -->
            <div id="ModalWindow">

                <%--  <form name="loginform" action="input.aspx" method="post" class="StandardForm" runat="server">--%>

                <div id="dialog" class="window">

                    <div id="FormWrap">

                        <div class="formtitle">Crea cost rate</div>

                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Persona"></asp:Label>
                            <label class="dropdown">
                                <asp:DropDownList ID="DDLPersonaModale" runat="server" AppendDataBoundItems="True"
                                    DataSourceID="DSPersona" DataTextField="NomePersona"
                                    DataValueField="Persons_id">
                                </asp:DropDownList>
                            </label>
                        </div>

                        <div class="input nobottomborder">
                            <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Anno"></asp:Label>
                            <label class="dropdown">
                                <asp:DropDownList ID="DDLAnnoModale" runat="server" AppendDataBoundItems="True" style="width:160px" >
                                </asp:DropDownList>
                            </label>
                        </div>

                        <div class="input nobottomborder">
                            <div class="inputtext">Costo: </div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBCosto" style="width:150px" 
                             data-parsley-errors-container="#valMsg" data-parsley-required="true"  data-parsley-pattern="^(\d*\,)?\d+$"/>
                        </div>

                        <!-- *** COMMENT ***  -->
                        <div class="input nobottomborder">
                                <div class="inputtext">Nota: </div>
                                <asp:TextBox CssClass="ASPInputcontent" ID="TBComment" runat="server" Columns="32" MaxLength="40" />
                        </div>

                        <div class="buttons">
                            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                            <asp:Button ID="btnCreaModale" runat="server"
                                CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>"
                                CssClass="orangebutton" />
                            <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False"
                                CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>"
                                CssClass="greybutton" />
                        </div>
        
                    </div>
                </div>
                <%--DIALOG--%>
            </div>
            <%--BOXES--%>
        </form>

    </div>
    <!-- END MainWindow -->

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Today.Year  %></div>
        <div id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>
    </div>

    <div id="mask"></div>  <!-- Mask to cover the whole screen -->

    <script type="text/javascript">

        // *** Esclude i controlli nascosti *** 
        $("#FVForm").parsley();

        $(document).ready(function () {

            // nasconde la colonna con la chiave usata nella cancellazione del record
            $('.hiddencol').css({ display: 'none' });

            //select all the a tag with name equal to modal
            $("#btn_crea").click(function (e) {

                //Cancel the link behavior
                e.preventDefault();

                //Get the screen height and width
                var maskHeight = $(document).height();
                var maskWidth = $(window).width();

                //Set heigth and width to mask to fill up the whole screen
                $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

                //transition effect		
                $('#mask').fadeIn(200);
                $('#mask').fadeTo("fast", 0.8);

                //Get the window height and width
                var winH = $(window).height();
                var winW = $(window).width();

                //Set the popup window to center
                //Set the popup window to center
                $('#dialog').css('top', winH / 3 - $('#dialog').height() / 2);
                $('#dialog').css('left', winW / 2 - $('#dialog').width() / 2);

                //transition effect
                $('#dialog').fadeIn(200);

            });

            //if close button is clicked
            $("#btnCancelModale").click(function (e) {
                //Cancel the link behavior
                e.preventDefault();

                $('#mask').hide();
                $('.window').hide();
            });

            //Salvataggio record
            $("#btnCreaModale").click(function (e) {

                $('#FVForm').parsley().validate();

                if ( !$('#FVForm').parsley().isValid() )
                    return;

                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'sAnno': '" + $('#DDLAnnoModale').val() + "' , " +
                    "'fCostRate': '" + $('#TBCosto').val() + "' , " +
                    " 'sPersonsId': '" + $('#DDLPersonaModale').val() + "' , " +
                    " 'sComment': '" + $('#TBComment').val() + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WStimereport.asmx/CreaCostRateAnno",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // aggiornamento effettuato, va alla pagina di lista per fare refresh dei dati
                        window.location.replace("/timereport/m_gestione/CostRateAnno/CostRateAnno_list.aspx") 
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        alert(xhr.responseText);
                    }

                }); // ajax

            });

            //if mask is clicked
            $('#mask').click(function () {
                $(this).hide();
                $('.window').hide();
            });

            $(window).resize(function () {

                var box = $('#ModalWindow .window');

                //Get the screen height and width
                var maskHeight = $(document).height();
                var maskWidth = $(window).width();

                //Set height and width to mask to fill up the whole screen
                $('#mask').css({ 'width': maskWidth, 'height': maskHeight });

                //Get the window height and width
                var winH = $(window).height();
                var winW = $(window).width();

                //Set the popup window to center
                box.css('top', winH / 2 - box.height() / 2);
                box.css('left', winW / 2 - box.width() / 2);

            });

        });

    </script>

    <!-- DATASOURCE PRINCIPALE-->
    <asp:SqlDataSource ID="DSElenco" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="*** COSTRUITO IN CODE BEHIND ***"
        DeleteCommand="DELETE FROM [PersonsCostRate] WHERE [PersonsCostRate_id] = @PersonsCostRate_id">
        <SelectParameters>
            <asp:ControlParameter ControlID="DDLPersona" Name="persons_id" PropertyName="SelectedValue" DefaultValue="0" />
            <asp:ControlParameter ControlID="DDLAnno" DefaultValue="2015" Name="Anno" PropertyName="SelectedValue" />
            <asp:ControlParameter ControlID="DDLFlattivo" Name="DDLFlattivo" PropertyName="SelectedValue" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="PersonsCostRate_id" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <!--DATASOURCE Persona per DDL -->
    <asp:SqlDataSource ID="DSPersona" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Persons.Persons_id, Persons.Name as NomePersona FROM Persons WHERE (Persons.Active = @Active) ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
    </asp:SqlDataSource>

</body>
</html>
