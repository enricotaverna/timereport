<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input.aspx.cs" Inherits="input"  %>

<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/timereport/include/jquery/tooltip/jquery.smallipop.css" type="text/css" />

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
     
<!-- ToolTip jquey add-in  -->
<script type="text/javascript" src="/timereport/include/jquery/tooltip/jquery.smallipop.min.js"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title><asp:Literal runat="server" Text="<%$ Resources:Titolo%>" /></title>
</head>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

</style>

<body>

    <div id="TopStripe"></div>
    <div id="MainWindow">

        <!--**** Riquadro navigazione ***-->
        <div id="PanelWrap">

            <!--**** Primo Box ***-->
            <div class="RoundedBox" style="width: 400px; float: left">

                <%
                    CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(Session["lingua"].ToString());
                    DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

                    int intMonth = Convert.ToInt32(Session["month"]);
                %>

                <%      
            int cnt;     
     		for (cnt=MyConstants.First_year;  cnt<=MyConstants.Last_year; cnt++)
     			if (Convert.ToInt16(Session["year"])==cnt)
     				Response.Write("<b>[" + cnt +  "]</b>&nbsp;&nbsp;");     
     			else
                    Response.Write("<a style=text-decoration:none href=input.aspx?refresh=true&month=" + Session["month"] + "&year=" + cnt.ToString() + ">" + cnt.ToString() + "</a>&nbsp;&nbsp;");    
                %>
                <br />
                <%          			          	
     		for (cnt=1; cnt<=12;cnt++)
     			if (intMonth==cnt) 
     				Response.Write("<b>[" + mfi.GetAbbreviatedMonthName(cnt) +  "]</b>&nbsp;&nbsp;");    
     			else
                    Response.Write("<a style=text-decoration:none href=input.aspx?refresh=true&year=" + Session["year"] + "&month=" + cnt.ToString().PadLeft(2, '0') + ">" + mfi.GetAbbreviatedMonthName(cnt) + "</a>&nbsp;&nbsp;");    
                %>

                <br />
            </div>
            <!--End roundedBox-->

            <!--**** Secondo Box ***-->
            <div class="RoundedBox" style="width: 400px; margin-left: 450px">

                <table style="width: 100%">
                    <tr>
                        <td style="width: 60%">
                            <img src="images/icons/16x16/S_F_MARK.gif" width="16" height="15" border="0" align="absmiddle" style="padding-right: 10px"><a href="input.aspx?month=<%=  DateTime.Now.Month %>&year=<%=DateTime.Now.Year%>"><asp:Literal runat="server" Text="<%$ Resources:mese_corrente%>" /></a><br />
                            <br />
                        </td>
                        <td>
                            <a title="" href="./report/chiusura/ChiusuraTRCheck.aspx" style="text-decoration:none" ><div id="btChiudiTR" runat="server" style="text-align: center; " class="SmallOrangeButton">
                                <img src="images/icons/other/lock-128.png" width="16px" height="16px" />&nbsp;&nbsp;&nbsp; <asp:Literal runat="server" Text="<%$ Resources:chiudi_timereport%>" />  </div></a>
                            <div id="lbTRChiuso" runat="server" style="text-align: center;cursor:default"  class="SmallGreyButton"> <asp:Literal runat="server" Text="<%$ Resources:timereport_chiiuso%>" /></div>
                        </td>
                    </tr>

                </table>



            </div>
            <!--End roundedBox-->

        </div>
        <!-- END PanelWrap -->

        <%
           // *****
           // ***** TAB TIPO CALENDARIO *****
           // *****
           string ch = "", ce = "", cs = "";
           
           switch ((string)Session["type"])
           {
               case "hours":
                   ch = "Tab-active";
                   ce = cs = "Tab-noactive";
                   break;
               case "expenses":
                   ce = "Tab-active";
                   ch = cs = "Tab-noactive";
                   break;
               case "bonus":
                   cs = "Tab-active";
                   ch = ce = "Tab-noactive";
                   break;
           }
                                  
           Response.Write("<a class=" + ch + " style='margin-left:48px' href=input.aspx?type=hours>" + GetLocalResourceObject("ORE") + "</a>");
           Response.Write("<a class=" + ce + " href=input.aspx?type=expenses>"+ GetLocalResourceObject("SPESE") +"</a>");
           // solo se dipendente
           if ( Auth.ReturnPermission("DATI","BUONI") )
              Response.Write("<a class=" + cs + " href=input.aspx?type=bonus>"+ GetLocalResourceObject("BUONI") + "</a>");
				
        %>
        <table width="90%" align="center" style="border-collapse: separate; border-spacing: 10px 0px; -webkit-border-top-left-radius: 0px;" class="RoundedBox">
            <!--        lascia righa vuota-->
            <tr>
                <td class="hours">&nbsp;</td>
                <td class="hours">&nbsp;</td>
                <td class="hours">&nbsp;</td> 
            </tr>
            <%          
			
		for(cnt=1; cnt<=10;cnt++)  {
			Response.Write("<tr>");

			// First columns ---------------
			OutputColumn(cnt);

			// Second columns	-------------------
			OutputColumn(cnt+10);
	
			// Third columns ----------------------------		
			OutputColumn(cnt+20);			
		
			Response.Write("</tr>");			
            %>
            <tr>
                <%					
			// First columns --------------------------------------				
			if ((string)Session["type"]=="hours")
				FindHours(cnt);
			else
				FindExpenses(cnt);
			
                // Second columns --------------------------------------
            if ((string)Session["type"] == "hours")
				FindHours(cnt+10);
			else
				FindExpenses(cnt+10);							

			// Third columns --------------------------------------
            if ((string)Session["type"] == "hours")
				FindHours(cnt+20);
			else
				FindExpenses(cnt+20);									
                %>
            </tr>

            <!--        lascia righa vuota-->
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>

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
		else
			FindExpenses(31);
        Response.Write("</tr>");

	}

            %>
        </table>

    </div>
    <!-- END MainWindow -->

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>
    </div>

    <!-- **** Finestre richiesta spese / trasferte **** -->
    <div id="ModalWindow">

        <form name="loginform" action="input.aspx" method="post" class="StandardForm" runat="server">

        <div id="dialog" class="window">

            <div id="FormWrap" >
              
                    <div class="formtitle">Specifica luogo trasferta</div>

                    <div class="input nobottomborder">
                        <div class="inputtext">Luogo di trasferta: </div>
                        <asp:TextBox class="ASPInputcontent" runat="server" name="SedeViaggio" ID="SedeViaggio" meta:resourcekey="SedeViaggioResource1" />
                        <asp:RequiredFieldValidator ID="VAL_SedeViaggio" runat="server"
                            ErrorMessage="RequiredFieldValidator" ControlToValidate="SedeViaggio"
                            Display="Dynamic" meta:resourcekey="VAL_SedeViaggioResource1">inserire sede</asp:RequiredFieldValidator>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Rimborso" meta:resourcekey="Label7Resource1"></asp:Label>
                        <label class="dropdown">
                            <asp:DropDownList ID="DDLBonus" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSBonus" DataTextField="Descrizione"
                                DataValueField="ExpenseType_Id" meta:resourcekey="DDLBonusResource1">
                            </asp:DropDownList>
                        </label>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Progetto" meta:resourcekey="Label1Resource1"></asp:Label>
                        <label class="dropdown">
                            <asp:DropDownList ID="DDLProgetto" runat="server" AppendDataBoundItems="True" meta:resourcekey="DDLProgettoResource1">
                            </asp:DropDownList>
                        </label>
                    </div>

                    <div class="buttons">
                        <asp:Button ID="InsertButton" runat="server"
                            CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>"
                            CssClass="orangebutton" OnClick="InsertButton_Click" meta:resourcekey="InsertButtonResource1" />
                        <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False"
                            CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>"
                            CssClass="greybutton" meta:resourcekey="UpdateCancelButtonResource1" />
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
        </div> <%--DIALOG--%>

        </form>

    </div>    <%--ModalWindow--%>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

    <script type="text/javascript">

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

    //TICKETREST : inserisce il ticket restaurant ed aggiorna la pagina Web          
    $('.tktRest').on('click', function (e) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'insDate': '" + $(this).attr("restDate") + "' , " +
                             " 'personsId': '" + <%= Session["persons_id"] %> + "'   } ";
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

                        var idItem = "#TDitm" + isoDate ;    //id dell'elemento td che contiene gli item
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
                        $(".hours").draggable({
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
    $(document).ajaxStart(function ()
    {
    $('body').addClass('ajaxLoading');

    }).ajaxComplete(function () {

    $('body').removeClass('ajaxLoading');

    });

    $(document).ready(function () {

        // drag & drop
        // draggable attaccato alla classe Hours è l'elemento che si muove
        $(".hours").draggable({
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
                var values = "{'sId': '" + ui.draggable.attr("id") + "' , " +
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
                        var idItem = "#TDitm" + itemDate ;    //id dell'elemento td che contiene gli item

                        // visualizza la stringa con il ticket creato
                            if ($(idItem).html() == "&nbsp;")
                                $(idItem).html("");

                            var htmlString = $(idItem).html() + "<div class=TRitem id=TRitm" + msg.d[1] + ">";

                            if (sSessione == "hours")
                                htmlString = htmlString + "<a id=" + msg.d[1] + " title=' " + strTooltip + "' class='hours ui-draggable ui-draggable-handle' href=input-ore.aspx?action=fetch&hours_id=" + msg.d[1] + " >" + msg.d[0] + "</a>";
                            else            
                                htmlString = htmlString + "<a id=" + msg.d[1] + " title=' " + strTooltip + "' class='hours ui-draggable ui-draggable-handle' href=input-spese.aspx?action=fetch&expenses_id=" + msg.d[1] + " >" + msg.d[0] + "</a>";

                        htmlString = htmlString + "<a href=# onclick='CancellaId(" + msg.d[1] + ")'><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>";
                        htmlString = htmlString + "</div>";
                        $(idItem).html(htmlString);

                        // in caso di ticket spegne l'icona della valigia e disattiva il dragp&drop
                        var idIcon = "#hdrIcon" + itemDate; 
                        $("#hdr" + itemDate).removeClass("ui-droppable");
                        $(idIcon).hide();

                        // richiama la funzione per abilitare il drag&drop sul nuovo item
                        $(".hours").draggable({
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
            hideDelay: 100,
            theme: 'blue',
            popupDelay: 500
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

