<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input.aspx.cs" Inherits="input"  %>

<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />


<link rel="stylesheet" href="/timereport/include/jquery/tooltip/jquery.smallipop.min.css" type="text/css" media="all" title="Screen" />

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.js"></script>

<!-- ToolTip jquey add-in  -->
<script type="text/javascript" src="/timereport/include/jquery/tooltip/modernizr.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/tooltip/jquery.smallipop.min.js"></script>

<style>
    .ui-draggable-helper {
        border: 1px dashed #000;
        font-weight: bold;
        background: #fff;
        padding: 4px;
        box-shadow: 5px 5px 5px #888;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><asp:Literal runat="server" Text="<%$ Resources:Titolo%>" /></title>
</head>

<script>

    function DoPostBack() {
        __doPostBack('Button2', 'My Argument');
    }

    // ***** CANCELLA SPESA E RICEVUTE *****
    // riceve in input Id spesa e data (YYYYMMGG) e chiama WS per cancellazione
    function CancellaSpesa(iId, sData) {

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{'iIdSpesa': '" + iId +
                  "' , 'sUsername': '<%= Session["username"]%>"  +
                  "' , 'sDataSpesa': '" + sData + "'   }";

        $.ajax({

            type: "POST",
            url: "/timereport/webservices/WStimereport.asmx/CancellaSpesaERicevuta",
            data: values,
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            // se tutto va bene
            success: function (msg) {
                // se call OK cancella la riga della tabella corrispondente alla ricevuta
                var Risultato = (msg.d == undefined) ? msg : msg.d; // compatibilità ASP.NET 2.0

                if (Risultato == "OK" || Risultato==null) {
                    var elemtohide = document.getElementById("TR" + iId);
                    elemtohide.style.display = "none";
                }
                else
                    alert(Risultato);
            },

            // in caso di errore
            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }

        }); // ajax

    } // cancella_ricevuta

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
        $(".noWorkDays").droppable({
            hoverClass: "noWorkDaysHover",
            drop: function (event, ui) {
                /* concatena data e numero record e triggera postback */
                par1 = $(this).attr("title");
                par2 = ui.draggable.attr("id");
                __doPostBack("drag&drop", par1.concat(";", par2));
            }
        });

        // draggable attaccato alla classe Hours è l'elemento che si muove
        $(".WorkDays").droppable({
            hoverClass: "WorkDaysHover",
            drop: function (event, ui) {
                /* concatena data e numero record e triggera postback */
                par1 = $(this).attr("title");
                par2 = ui.draggable.attr("id");               
                __doPostBack("drag&drop", par1.concat(";",par2));                                
            }
        });

        // tooltip : hideDelay default 500, riduce tempo prima che sia nascosto il tooltip
        $('.hours').smallipop({
            hideDelay: 100
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

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!--**** Stili per effetto dialog box ***-->
<style>
    #mask {
        position: absolute;
        left: 0;
        top: 0;
        z-index: 9000;
        background-color: #000;
        display: none;
    }

    #boxes .window {
        position: fixed;
        left: 0;
        top: 0;
        width: 440px;
        height: 200px;
        display: none;
        z-index: 9999;
        padding: 20px;
    }

    #boxes #dialog {
        width: 450px;
        height: 150px;
        padding: 0px;
    }

    }
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
        <table width="90%" align="center" style="border-collapse: separate; border-spacing: 10px 0px; border-top-left-radius: 0px; -webkit-border-top-left-radius: 0px;" class="RoundedBox">
            <!--        lascia righa vuota-->
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
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

        Database.CloseConnection();
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
    <div id="boxes">

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
                        <div class="InputcontentDDL">
                            <asp:DropDownList ID="DDLBonus" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSBonus" DataTextField="Descrizione"
                                DataValueField="ExpenseType_Id" meta:resourcekey="DDLBonusResource1">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Progetto" meta:resourcekey="Label1Resource1"></asp:Label>
                        <div class="InputcontentDDL">
                            <asp:DropDownList ID="DDLProgetto" runat="server" AppendDataBoundItems="True" meta:resourcekey="DDLProgettoResource1">
                            </asp:DropDownList>
                        </div>
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

    </div>    <%--BOXES--%>

    <!-- Mask to cover the whole screen -->
    <div id="mask"></div>

</body>

</html>

