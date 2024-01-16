<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input.aspx.cs" Inherits="input" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Data" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<!-- ToolTip jquey add-in  -->
<script type="text/javascript" src="/timereport/include/jquery/tooltip/jquery.smallipop.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />
<link href="/timereport/include/jquery/tooltip/jquery.smallipop.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="<%$ Resources:titolo%>" />
    </title>
</head>

<body>

    <!-- *** Box dialogo per specifica rimborso trasferta Italia/Estero ***  -->
    <div id="ModalWindow">

        <form id="FVForm" action="input.aspx" method="post" class="StandardForm" runat="server">

            <div id="dialog" class="window">

                <div id="FormWrap">

                    <div class="formtitle">Specifica luogo trasferta</div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Rimborso" meta:resourcekey="Label7Resource1"></asp:Label>
                        <asp:DropDownList ID="DDLBonus" runat="server" AppendDataBoundItems="True"
                            DataSourceID="DSBonus" DataTextField="Descrizione"
                            DataValueField="ExpenseType_Id" meta:resourcekey="DDLBonusResource1">
                        </asp:DropDownList>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Progetto" meta:resourcekey="Label1Resource1"></asp:Label>
                        <asp:DropDownList ID="DDLProgetto" runat="server" AppendDataBoundItems="True" meta:resourcekey="DDLProgettoResource1">
                        </asp:DropDownList>
                    </div>

                    <!-- *** OpportunityId ***  -->
                    <div class="input nobottomborder" id="lbOpportunityId">
                        <asp:Label CssClass="inputtext" ID="Label3" runat="server" Text="Opportunità" meta:resourcekey="lbOpportunityId"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBOpportunityId" runat="server" 
                            data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="^AV\d{2}[A-Z]\d{3}$|^AP\w{1,13}$"  MaxLength="15" />
                    </div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Luogo di trasferta</div>
                        <asp:TextBox class="ASPInputcontent" runat="server" name="SedeViaggio" ID="SedeViaggio" meta:resourcekey="SedeViaggioResource1" data-parsley-errors-container="#valMsg" data-parsley-required="true"/>
                    </div>

                    <div class="buttons">
                        <div id="valMsg" class="parsely-single-error"></div>
                        <asp:Button ID="InsertButton" runat="server"
                            CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>"
                            CssClass="orangebutton" OnClick="InsertButton_Click" meta:resourcekey="InsertButtonResource1" />
                        <asp:Button ID="UpdateCancelButton" runat="server"  
                            CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>"
                            CssClass="greybutton" meta:resourcekey="UpdateCancelButtonResource1" formnovalidate/>
                    </div>

                    <input type="hidden" id="refDate" name="refDate" value="" />

                    <%--*** DATASOURCE ***--%>
                    <asp:SqlDataSource ID="DSBonus" runat="server"
                        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
                        SelectCommand="SELECT ExpenseType_Id, ExpenseType.ExpenseCode + ' ' + ExpenseType.Name AS Descrizione FROM ExpenseType INNER JOIN TipoBonus ON ExpenseType.TipoBonus_Id = TipoBonus.TipoBonus_Id WHERE (TipoBonus.TipoBonus_Id = @TipoBonus_id)">
                        <SelectParameters>
                            <asp:Parameter Name="TipoBonus_id" Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </div>
            <%--DIALOG--%>
        </form>

    </div>
    <%-- *** ModalWindow *** --%>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MainWindow *** -->
    <div class="container MainWindowBackground" style="padding-top: 20px">

        <div class="row justify-content-center">

            <!--**** Primo Box ***-->
            <div class="col-5 RoundedBox">

                <%
                    CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(CurrentSession.Language);
                    DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

                    int intMonth = Convert.ToInt32(Session["month"]);
                %>

                <%      
                    int cnt;
                    for (cnt = MyConstants.First_year; cnt <= MyConstants.Last_year; cnt++)
                        if (Convert.ToInt16(Session["year"]) == cnt)
                            Response.Write("<b>[" + cnt + "]</b>&nbsp;&nbsp;");
                        else
                            Response.Write("<a style=text-decoration:none href=input.aspx?refresh=true&month=" + Session["month"] + "&year=" + cnt.ToString() + ">" + cnt.ToString() + "</a>&nbsp;&nbsp;");
                %>
                <br />
                <%          			          	
                    for (cnt = 1; cnt <= 12; cnt++)
                        if (intMonth == cnt)
                            Response.Write("<b>[" + mfi.GetAbbreviatedMonthName(cnt) + "]</b>&nbsp;&nbsp;");
                        else
                            Response.Write("<a style=text-decoration:none href=input.aspx?refresh=true&year=" + Session["year"] + "&month=" + cnt.ToString().PadLeft(2, '0') + ">" + mfi.GetAbbreviatedMonthName(cnt) + "</a>&nbsp;&nbsp;");
                %>

                <br />
            </div>
            <!--End roundedBox-->

            <div class="col-1"></div>

            <!--**** Secondo Box ***-->
            <div class="col-5 RoundedBox">
                <button type="submit" class="btn btn-outline-secondary float-end mx-1" onclick="window.location.href='input.aspx?month=<%=  DateTime.Now.Month %>&year=<%=DateTime.Now.Year%>'"><i class="px-2 fas fa-calendar-alt"></i>
                    <asp:Literal runat="server" Text="<%$ Resources:mese_corrente%>" /></button>
                <button id="btChiudiTR" type="submit" class="btn btn-outline-secondary float-end mx-1" runat="server" onclick="window.location.href='./report/chiusura/ChiusuraTRCheck.aspx'"><i class="px-2 fas fa-lock"></i>
                    <asp:Literal runat="server" Text="<%$ Resources:chiudi_timereport%>" /></button>
            </div>
            <!--End roundedBox-->

        </div>

        <div class="row justify-content-center pt-3">

            <div class="col-11 px-0">

                <%
                    // *****
                    // ***** TAB TIPO CALENDARIO *****
                    // *****
                    string ch = "", ce = "", cs = "", ca = "";

                    switch ((string)Session["type"])
                    {
                        case "hours":
                            ch = "Tab-active";
                            ce = cs = ca = "Tab-noactive";
                            break;
                        case "expenses":
                            ce = "Tab-active";
                            ch = cs = ca = "Tab-noactive";
                            break;
                        case "bonus":
                            cs = "Tab-active";
                            ch = ce = ca = "Tab-noactive";
                            break;
                        case "leave":
                            ca = "Tab-active";
                            ch = ce = cs = "Tab-noactive";
                            break;
                    }

                    Response.Write("<a class=" + ch + " style='margin-left:0px' href=input.aspx?type=hours>" + GetLocalResourceObject("ORE") + "</a>");

                    // solo se ha spese
                    DataTable dtSpeseForzate = CurrentSession.dtSpeseForzate;
                    if (dtSpeseForzate.Rows.Count > 0)
                        Response.Write("<a class=" + ce + " href=input.aspx?type=expenses>" + GetLocalResourceObject("SPESE") + "</a>");

                    // solo se dipendente
                    if (Auth.ReturnPermission("DATI", "BUONI"))
                        Response.Write("<a class=" + cs + " href=input.aspx?type=bonus>" + GetLocalResourceObject("BUONI") + "</a>");

                    // solo se dipendente
                    if (Auth.ReturnPermission("DATI", "ASSENZE") && ConfigurationManager.AppSettings["LEAVE_ON"] == "true")
                        Response.Write("<a class=" + ca + " href=input.aspx?type=leave>" + GetLocalResourceObject("ASSENZE") + "</a>");

                %>
                <table align="center" id="TableOre" style="width: 100%; border-collapse: separate; border-spacing: 10px 0px; -webkit-border-top-left-radius: 0px;" class="RoundedBox">
                    <!--        lascia righa vuota-->
                    <%--                <tr>
                    <td class="hours">&nbsp;</td>
                    <td class="hours">&nbsp;</td>
                    <td class="hours">&nbsp;</td>
                </tr>--%>
                    <%          

                        for (cnt = 1; cnt <= 10; cnt++)
                        {
                            Response.Write("<tr>");

                            // First columns ---------------
                            OutputColumn(cnt);

                            // Second columns	-------------------
                            OutputColumn(cnt + 10);

                            // Third columns ----------------------------		
                            OutputColumn(cnt + 20);

                            Response.Write("</tr>");
                    %>
                    <tr>
                        <%					
                            // First columns --------------------------------------				
                            if ((string)Session["type"] == "hours")
                                FindHours(cnt);
                            else if ((string)Session["type"] == "expenses" | (string)Session["type"] == "bonus")
                                FindExpenses(cnt);
                            else
                                FindAssenze(cnt);

                            // Second columns --------------------------------------
                            if ((string)Session["type"] == "hours")
                                FindHours(cnt + 10);
                            else if ((string)Session["type"] == "expenses" | (string)Session["type"] == "bonus")
                                FindExpenses(cnt + 10);
                            else
                                FindAssenze(cnt + 10);

                            // Third columns --------------------------------------
                            if ((string)Session["type"] == "hours")
                                FindHours(cnt + 20);
                            else if ((string)Session["type"] == "expenses" | (string)Session["type"] == "bonus")
                                FindExpenses(cnt + 20);
                            else
                                FindAssenze(cnt + 20);
                        %>
                    </tr>

                    <!--        lascia righa vuota CANCELLATO -->
                    <%--                 <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>--%>

                    <%	
                        }

                        //	Print the last row for months with 	31 days
                        if (ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])) == 31)
                        {
                            Response.Write("<tr><td>&nbsp;</td><td>&nbsp;</td>");
                            OutputColumn(31);
                            Response.Write("</tr>");
                            Response.Write("<tr><td>&nbsp;</td><td>&nbsp;</td>");
                            if ((string)Session["type"] == "hours")
                                FindHours(31);
                            else if ((string)Session["type"] == "expenses" | (string)Session["type"] == "bonus")
                                FindExpenses(31);
                            else
                                FindAssenze(31);
                            Response.Write("</tr>");

                        }

                    %>
                </table>

            </div>
            <!-- *** END Col *** -->

        </div>
        <!-- *** END Row *** -->

    </div>
    <!-- *** END Container *** -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

    <!-- *** Javascript *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
        CalcolaSommaOre();

        // *** Esclude i controlli nascosti *** 
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        //calcolo delle ore inserite nel giorno
        //se inferiori ad 8 segnalate in rosso
        function CalcolaSommaOre() {
            //trovo la tabella delle ore tramite id
            var table = document.getElementById("TableOre");
            console.log('table -- ' + table);
            //ciclo tutte le righe della tabella
            for (var i = 0, row; row = table.rows[i]; i++) {
                //ciclo tutte le colonne del record
                for (var j = 0, col; col = row.cells[j]; j++) {
                    //prendo solamente le celle dove è possibile inserire i time (escludo i titoli dei giorni)
                    if (col.id.includes("TDitm")) {
                        //controllo se nella cella dei time è contenuto almeno un time
                        if (col.getElementsByClassName('TRitem')[0] != null) {
                            let sommaOre = 0;
                            console.log('ID Colonna -- ' + col.id);
                            //ciclo ogni time del giorno sommando le ore
                            Array.from(col.getElementsByClassName('TRitem')).forEach(function (element) {
                                console.log(element.innerText.split(':')[1].replace("ore", "").trimEnd());
                                sommaOre += parseInt(element.innerText.split(':')[1].replace("ore", "").trimEnd(), 10);
                            });
                            console.log(sommaOre);
                            //trovo la cella del giorno corrispondente tramite l'id unico per ogni time
                            let span = document.getElementById("ore" + col.id.replace("TDitm", ""));
                            span.textContent = "Ore: " + sommaOre;
                            span.style.color = '#666666';
                            if (sommaOre == 0) {
                                span.textContent = "";
                            } else if (sommaOre < 8) {
                                //se minore di 8 segnalo in rosso
                                span.style.color = 'red';
                            }
                        }
                    }
                }
                console.log('Fine riga');
            }
        }

        function BindOpportunity() {
            // gestione Opportunity Id
            var OpportunityIsRequired = $("#DDLProgetto").find("option:selected").attr("data-OpportunityIsRequired");

            if (OpportunityIsRequired == "True")
                $('#lbOpportunityId').show(); // visualizza DropDown
            else
                $('#lbOpportunityId').hide(); // visualizza DropDown
            CalcolaSommaOre();
        }

        //CANCELLA_ID : premendo il tasto trash cancella il record ore / spese / bonus associato e aggiorna la pagina WEB
        function CancellaId(Id) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'Id': '" + Id + "'  }";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WStimereport.asmx/CancellaId",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                // se tutto va bene
                success: function (msg) {
                    // funzione restituisce 
                    // d[0] true / false per esito
                    // d[1] "" se ore, aaaammgg se spese
                    if (msg.d[0] == "true") {

                        var elemtohide = document.getElementById("TRitm" + Id);
                        elemtohide.remove();
                        CalcolaSommaOre();
                        if (msg.d[1] != "") {
                            var hdrIcon = "#hdrIcon" + msg.d[1]; // yyyymmdd in caso di ticket                  
                            $(hdrIcon).show(); // accende icone travel
                        }
                    }
                    else
                        alert(Risultato);
                },

                // in caso di errore
                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } //CANCELLA_ID 

        //CancellaAssenza : premendo il tasto trash cancella il record richiesta assenza
        function CancellaAssenza(Id) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ApprovalRequest_id': '" + Id + "','UpdateMode': 'DELE', 'ApprovalText1' : '' }";

            MaskScreen(true); // mette in wait a schermo scuro

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/UpdateApprovalRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                // se tutto va bene
                success: function (msg) {

                    UnMaskScreen();

                    if (msg.d == true) {

                        var elemtohide = document.getElementById("TRitm" + Id);
                        elemtohide.remove();

                    }
                    else
                        ShowPopup("Errore in aggiornamento");
                },

                // in caso di errore
                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    alert(xhr.responseText);
                }

            }); // ajax
        } //CANCELLA_ID 

        //TICKETREST : inserisce il ticket restaurant ed aggiorna la pagina Web          
        $('.tktRest').on('click', function (e) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'insDate': '" + $(this).attr("restDate") + "' , " +
                " 'personsId': '" + <%= CurrentSession.Persons_id %> + "'   } ";
            var refThis = $(this);

            refThis.addClass("HdrDisabled"); // evita doppio click

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WStimereport.asmx/CreaTicket",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d > 0) {
                        var strTooltip = "";
                        var isoDate = refThis.attr("restDate"); // formato aaaammgg

                        var idItem = "#TDitm" + isoDate;    //id dell'elemento td che contiene gli item
                        var idIcon = "#hdrIcon" + isoDate; //id delle icone di viaggio e ticket

                        // visualizza la stringa con il ticket creato
                        var htmlString = "<div class=TRitem id=TRitm" + msg.d + ">";
                        htmlString = htmlString + "<a id=" + msg.d + " title=' " + strTooltip + "' class=hours href=input-spese.aspx?action=fetch&expenses_id=" + msg.d + " >ZZ90101:BPA : 1 BP</a>";
                        htmlString = htmlString + "<a href=# onclick='CancellaId(" + msg.d + ")'><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>";
                        htmlString = htmlString + "</div>";
                        $(idItem).html(htmlString);

                        // spegne le icone sulla testata della colonna e disattiva dragp & drop
                        $(idIcon).hide();
                        $("#hdr" + isoDate).removeClass("ui-droppable");

                        refThis.removeClass("HdrDisabled"); // riattiva il bottone dopo il submit

                        // richiama la funzione per abilitare il drag&drop sul nuovo item
                        $(".TRitem").draggable({
                            cursor: "move",
                            appendTo: "body",
                            helper: "clone",
                            revert: "invalid",
                            start: function (e, ui) {
                                $(ui.helper).addClass("ui-draggable-helper");
                            }
                        });

                    }
                    else
                        alert(Risultato);
                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax

        }); //TICKETREST

        // cursore in attesa durante chiamata ajax
        $(document).ajaxStart(function () {
            $('body').addClass('ajaxLoading');

        }).ajaxComplete(function () {

            $('body').removeClass('ajaxLoading');

        });

        $(document).ready(function () {

            // drag & drop
            // draggable attaccato alla classe Hours è l'elemento che si muove
            $(".TRitem").draggable({
                cursor: "move",
                appendTo: "body",
                helper: "clone",
                revert: "invalid",
                start: function (e, ui) {
                    $(ui.helper).addClass("ui-draggable-helper");
                }
            });

            // droppable è l'elemento che riceve
            $(".noWorkDays, .WorkDays").droppable({
                hoverClass: "noWorkDaysHover",
                drop: function (event, ui) {

                    var strTooltip = "";
                    var values = "{'sId': '" + ui.draggable.attr("id").substr(5) + "' , " +
                        " 'sInsDate': '" + $(this).attr("title") + "'   } ";
                    var refThis = $(this);
                    var sSessione = "<%= Session["type"]  %>";

                    // chiama Ajax per creare il nuovo record
                    $.ajax({
                        type: "POST",
                        url: "/timereport/webservices/WStimereport.asmx/ProcessDragDrop",
                        data: values,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",

                        success: function (msg) {

                            // se call OK inserisce una riga sotto l'elemento 
                            if (msg.d != "") { // msg.d[0] = testo da stampare, msg.d[1] = id dell'ora

                                var itemDate = refThis.attr("title").substr(6, 4) + refThis.attr("title").substr(3, 2) + refThis.attr("title").substr(0, 2); // formato yyyymmdd
                                var idItem = "#TDitm" + itemDate;    //id dell'elemento td che contiene gli item

                                // visualizza la stringa con il ticket creato
                                if ($(idItem).html() == "&nbsp;")
                                    $(idItem).html("");

                                var htmlString = $(idItem).html() + "<div class=TRitem id=TRitm" + msg.d[1] + ">";

                                if (sSessione == "hours")
                                    htmlString = htmlString + "<a id=TRitm" + msg.d[1] + " title=' " + strTooltip + "' class='hours ui-draggable ui-draggable-handle' href=input-ore.aspx?action=fetch&hours_id=" + msg.d[1] + " >" + msg.d[0] + "</a>";
                                else
                                    htmlString = htmlString + "<a id=TRitm" + msg.d[1] + " title=' " + strTooltip + "' class='hours ui-draggable ui-draggable-handle' href=input-spese.aspx?action=fetch&expenses_id=" + msg.d[1] + " >" + msg.d[0] + "</a>";

                                htmlString = htmlString + "<a href=# onclick='CancellaId(" + msg.d[1] + ")'><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>";
                                htmlString = htmlString + "</div>";
                                $(idItem).html(htmlString);

                                // in caso di ticket spegne l'icona della valigia e disattiva il dragp&drop
                                var idIcon = "#hdrIcon" + itemDate;
                                $("#hdr" + itemDate).removeClass("ui-droppable");
                                $(idIcon).hide();

                                // richiama la funzione per abilitare il drag&drop sul nuovo item
                                $(".TRitem").draggable({
                                    cursor: "move",
                                    appendTo: "body",
                                    helper: "clone",
                                    revert: "invalid",
                                    start: function (e, ui) {
                                        $(ui.helper).addClass("ui-draggable-helper");
                                    }
                                });
                                CalcolaSommaOre();
                            }
                            else
                                alert("Errore: dato non inserito");
                        },

                        error: function (xhr, textStatus, errorThrown) {
                            alert(xhr.responseText);
                        }

                    }); // ajax

                }
            });

            // tooltip : hideDelay default 500, riduce tempo prima che sia nascosto il tooltip
            $('.hours').smallipop({
                hideDelay: 0,
                theme: 'blue',
                popupDelay: 0
            });

            // Mostra box testo in caso della corrispondente selezione della DDL Location
            $("#DDLProgetto").change(function () {
                BindOpportunity();
            });

            //select all the a tag with name equal to modal
            $('a[name=modal]').click(function (e) {
                //Cancel the link behavior
                e.preventDefault();

                //Get the A tag
                var id = $(this).attr('href');

                var aData = $(this).attr('title').split(";");

                // setta il valore del campo Hidden con la data cliccata 
                $("#refDate").val(aData[0]);

                // setta il progetto come default
                $("#DDLProgetto").val(aData[1]);

                // mostra o nasconde campo opportunità nella finestra modale quando si inserisce la diaria giornaliera
                BindOpportunity();

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
                $(id).css('top', winH / 2 - $(id).height() / 2);
                $(id).css('left', winW / 2 - $(id).width() / 2);

                //transition effect
                $(id).fadeIn(200);

            });

            //if close button is clicked
            $('.window .close').click(function (e) {
                //Cancel the link behavior
                e.preventDefault();

                $('#mask').hide();
                $('.window').hide();
            });

            //if mask is clicked
            $('#mask').click(function () {
                $(this).hide();
                $('.window').hide();
            });

            $(window).resize(function () {

                var box = $('#boxes .window');

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

</body>

</html>

