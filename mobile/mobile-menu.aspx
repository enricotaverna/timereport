<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mobile-menu.aspx.cs" Inherits="mobile_menu" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1">
    <title>Form spese</title>

    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <!-- style sheets -->
    <link rel="stylesheet" href="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.css" />
    <link href="/timereport/include/TimereportMobilev2.css" rel="stylesheet" />
    <!-- jquery mobile -->
    <script src="/timereport/include/jquery/1.7.1/jquery-1.7.1.min.js"></script>
    <script src="/timereport/include/javascript/customscript.js"></script>
    <script src="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.js"></script>
    <!-- jquery mobile FINE -->

    <script type="text/javascript" src="/timereport/include/javascript/mobile/jquery.validate.js"></script>
    <script type="text/javascript" src="/timereport/include/javascript/mobile/additional-methods.js"></script>
    <!-- jquery mobile FINE -->

    <!-- jquery Resize immagine prima upload -->
    <script src="/timereport/include/resize/exif.js"></script>
    <script src="/timereport/include/resize/binaryajax.js"></script>
    <script src="/timereport/include/resize/canvasResize.js"></script>
    <!-- jquery Resize immagine prima upload FINE -->

    <!-- Logica principale -->
    <script type="text/javascript" src="./TRmobile.js"></script>

</head>

<body>
    <div data-role="page" data-dom-cache="true" id="mainmenu">
        <div data-role="header" data-position="fixed">
            <a href='./mobile-logout.aspx' class='ui-btn-left' data-icon='back' rel="external">Logoff</a>
            <h1>Menu</h1>
        </div>
        <!-- /header -->
        <div data-role="content">
            <ul data-role="listview" data-inset="true">
                <li><a href="#FormSpesePage">
                    <img src="/timereport/images/mobile/money.png" />
                    <h3>Spese</h3>
                    <p>Inserisci spese</p>
                </a></li>
                <li><a href="#FormOrePage">
                    <img src="/timereport/images/mobile/clock_128.png" />
                    <h3>Ore</h3>
                    <p>
                        Inserisci ore
                    </p>
                </a></li>
                <li><a href="index.html">
                    <img src="/timereport/images/mobile/report_check.png" />
                    <h3>Report</h3>
                    <p>Ore e spese per mese corrente e precedente</p>
                </a>
                    <ul data-role="listview" data-inset="true">
                        <li><a href="list-spese.aspx?id=<%= CurrentSession.Persons_id %>">
                            <img src="/timereport/images/mobile/money.png" /><h3>Report Spese</h3>
                            <p>Report spese mese corrente e precedente</p>
                        </a></li>
                        <li><a href="list-ore.aspx?id=<%= CurrentSession.Persons_id %>">
                            <img src="/timereport/images/mobile/clock_128.png" /><h3>Report Ore</h3>
                            <p>Report ore mese corrente e precedente</p>
                        </a></li>
                        <%--							<li><a href="list-spese.aspx?id=<%= Request.QueryString["id"] %>"><img src="/timereport/images/mobile/money.png" /><h3>Report Spese</h3><p>Report spese mese corrente e precedente</p></a></li>
							<li><a href="list-ore.aspx?id=<%= Request.QueryString["id"] %>"><img src="/timereport/images/mobile/clock_128.png" /><h3>Report Ore</h3><p>Report ore mese corrente e precedente</p></a></li>                --%>
                    </ul>
                </li>
            </ul>
        </div>
        <!--/content-primary -->

    </div>
    <!-- /page "menu" -->

    <!-- Start of second page -->
    <div data-role="page" id="FormSpesePage">

        <form id="SpeseForm" method="post" name="SpeseForm">

            <div data-role="header">
                <a href="#mainmenu" class='ui-btn-left' data-icon='arrow-l'>Back</a>
                <h1 id="speseToptitle">Inserisci spese</h1>
            </div>
            <!-- /header -->

            <div data-role="content">

                <div class="ui-grid-a">
                    <!-- Data e importo spesa -->

                    <!-- controllo nascosto con nome utente -->
                    <input id="UserName" type="hidden" value='<%=CurrentSession.UserName %>' />

                    <div class="ui-block-a">
                        <input name="Tbdate" id="Tbdate" type="date" value='<%=DateTime.Today.ToString("yyyy-MM-dd") %>' placeholder="Inserisci data">
                    </div>

                    <div class="ui-block-b">
                        <input type="text" runat="server"  name="TbExpenseAmount" id="TbExpenseAmount" placeholder="Importo spesa">
                    </div>

                </div>
                <!-- /grid-a -->


                <br />

                <select name="Projects_Id" id="Projects_Id">
                    <!-- riempito da query -->
                </select>

                <select id="Spese_Id">
                    <!-- riempito da query -->
                </select>

                <br />

                <textarea id="comment" name="comment" rows="2" textmode="MultiLine" placeholder="inserisci un commento se necessario"></textarea>

                <fieldset data-role="controlgroup" data-type="horizontal">
                    <input type="checkbox" name="CreditCardPayed" id="CreditCardPayed" class="custom" /><label for="CreditCardPayed">CCred</label>
                    <input type="checkbox" name="CompanyPayed" id="CompanyPayed" class="custom" /><label for="CompanyPayed">Bonif.</label>
                    <input type="checkbox" name="InvoiceFlag" id="InvoiceFlag" class="custom" /><label for="InvoiceFlag">Fatt</label>
                    <input type="checkbox" name="CancelFlag" id="CancelFlag" class="custom" /><label for="CancelFlag">Storno</label>
                </fieldset>

                <br />

                <div class="ui-grid-a">
                    <!-- Bottoni Form -->

                    <div class="ui-block-a">
                        <span class="fileinput-button" data-role="button" data-theme="b">
                            <span>Carica foto</span>
                            <%--                        <input type="file" name="fileToUpload" id="fileToUpload" accept="image/jpeg,image/gif,image/png"  capture="camera"/> --%>
                            <input type="file" name="fileToUpload" id="fileToUpload" accept="image/*" />
                        </span>
                    </div>

                    <div class="ui-block-b" style="text-align: center">
                        <span class="width=30" id="imagePreview"></span>
                    </div>
                </div>
                <!-- /grid-a -->

                <br />
                <div id="speseErrorMessageArea" style="text-align:center"></div>

                <div class="ui-grid-a">
                    <!-- Bottoni Form -->
                    <div class="ui-block-a">
                        <input type="submit"  id="speseSubmit" value="Salva" data-role="button" data-theme="b" />
                    </div>

                    <div class="ui-block-b">
                        <input type="button" id="speseCancel" name="reset" value="Annulla" data-role="button"  data-theme="b" />
                    </div>
                </div>
                <!-- /grid-a -->

            </div>
            <!--/content-primary -->

        </form>

    </div>
    <!-- /page #2 form spese -->

    <!-- Start of third page -->
    <div data-role="page" id="FormOrePage">

        <form id="OreForm" method="post" name="OreForm">

            <div data-role="header">
                <a href="#mainmenu" class='ui-btn-left' data-icon='arrow-l'>Back</a>
                <h1 id="oreToptitle">Inserisci ore</h1>
            </div>
            <!-- /header -->

            <div data-role="content">

                <div class="ui-grid-a">
                    <div class="ui-block-a">
                        <input name="TbdateForHours" id="ore_TbdateForHours" type="date" value='<%=DateTime.Today.ToString("yyyy-MM-dd") %>' placeholder="Inserisci data">
                    </div>
                    <div class="ui-block-b">
                        <input type="number" name="TbHours" id="ore_TbHours" placeholder="Ore" />
                    </div>
                </div>
                <!-- /grid-a -->

                <br />

                <select id="ore_Projects_Id" name="ore_Projects_Id">
                    <!-- riempito da query -->
                </select>

                <div id="DDLActivity">
                    <select id="ore_Activity_Id" name="ore_Activity_Id">
                        <!-- riempito da query -->
                    </select>
                </div>

                <div id="DDLLocation" name="DDLLocation">
                    <select id="ore_Location_Id" name="ore_Location_Id">
                        <!-- riempito da query -->
                    </select>
                </div>

                <input id="TBLocation" placeholder="Location" name="TBLocation" />

                <%--            <select id="ore_TipoOre_Id"> <!-- riempito da query --> </select>--%>

                <br />

                <textarea id="ore_comment" name="ore_comment" rows="2" textmode="MultiLine" placeholder="inserisci un commento se necessario"></textarea>

                <fieldset data-role="controlgroup" data-type="horizontal">
                    <input type="checkbox" name="CancelFlag" id="ore_CancelFlag" class="custom" /><label for="ore_CancelFlag">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Storno&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
                </fieldset>

                <br />
                <div id="oreErrorMessageArea" style="text-align:center"></div>

                <div class="ui-grid-a">
                    <!-- Bottoni Form -->
                    <div class="ui-block-a">
                        <input type="submit" id="ore_Submit" value="Salva" data-role="button" data-theme="b" />
                    </div>
                    <div class="ui-block-b">
                        <input type="button" id="oreCancel" value="Annulla" data-role="button" data-theme="b" />
                    </div>
                </div>
                <!-- /grid-a -->

            </div>
            <!--/content-primary -->

        </form>

    </div>
    <!-- /page FormOrePage -->

    <!-- usato da Jquery per chiamare servizi -->
    <div id="persons_id" style="visibility:hidden"><%= CurrentSession.Persons_id %></div>

</body>

</html>
