﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRatePersona_list.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<!-- Download excel da Tabulator -->
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Cost Rate" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-8 RoundedBox">
                    <div class="row">
                        <div class="col-2">
                            <label class="inputtext">Consulenti:</label>
                        </div>
                        <div class="col-2">
                            <asp:DropDownList ID="DDLAttivi" runat="server" AutoPostBack="True" 
                                CssClass="ASPInputcontent" OnSelectedIndexChanged="SelectChanged">
                                <asp:ListItem Text="Attivi" Value="true"></asp:ListItem>
                                <asp:ListItem Text="Disattivi" Value="false"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <!-- Fine row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <br />

            <div class="row justify-content-center">

                <div class="StandardForm col-8">

                    <div id="PersonsCostRateTable"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->

                <div id="ModalWindow">
                    <!--  Finestra Dialogo -->

                    <div id="dialog" class="window">

                        <div id="FormWrap" class="StandardForm">

                            <div class="formtitle">Costo Persona</div>

                            <div class="input nobottomborder">
                                <!-- ** PERSONA ** -->
                                <div class="inputtext">
                                    <asp:Literal runat="server" Text="Consulente" />
                                </div>
                                <asp:DropDownList ID="DDLPersons" runat="server" DataSourceID="DSPersons" DataTextField="Name" DataValueField="Persons_id"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                                    <asp:ListItem Text="-- selezionare un valore --" Value=""></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="input nobottomborder">
                                <!-- ** VALIDO DA ** -->
                                <div class="inputtext   ">Valido da</div>
                                <asp:TextBox class="ASPInputcontent" runat="server" ID="TBDataDa" Columns="10" autocomplete="off"
                                    data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-no-focus="true" data-parsley-errors-messages-disabled=""
                                    data-parsley-firstdayofmonth="true"
                                    data-parsley-dateinsequenza="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                                &nbsp;&nbsp;a&nbsp;&nbsp;
                     <asp:TextBox class="ASPInputcontent" autocomplete="off" runat="server" ID="TBDataA" Columns="10" data-parsley-errors-container="#valMsg" data-parsley-no-focus="true"
                         data-parsley-required="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                            </div>

                            <div class="input nobottomborder">
                                <!-- ** COST RATE ** -->
                                <div class="inputtext">Cost Rate(€)</div>
                                <asp:TextBox class="ASPInputcontent" runat="server" ID="TBCostRate"  autocomplete="off"
                                    data-parsley-required="true" data-parsley-errors-container="#valMsg" data-parsley-pattern="/^[0-9]{0,4}$/" Columns="10" />
                            </div>

                            <div class="input nobottomborder">
                                <!-- ** COMMENT ** -->
                                <div class="inputtext">Nota</div>
                                <asp:TextBox class="ASPInputcontent" runat="server" ID="TBComment" Width="260px" />
                            </div>

                            <div class="legendaText">
                                <p><span>[C] </span><span id="LBCreatedBy"></span><span id="LBCreationDate"></span></p>
                                <p><span>[M] </span><span id="LBLastModifiedBy"></span><span id="LBLastModificationDate"></span></p>
                            </div>

                            <asp:TextBox runat="server" ID="TBPersonsCostRate_id" Style="visibility: hidden; height: 0px; margin: 0px" />

                            <div class="buttons">
                                <div id="valMsg" class="parsely-single-error" ></div>
                                <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                                <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
                            </div>

                        </div>

                    </div>
                    <%--DIALOG--%>
                </div>
                <!--  Finestra Dialogo -->

            </div>
            <!--End LastRow-->

        </form>
    </div>
    <!-- END Container -->

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

    <div id="mask"></div>
    <!-- Mask to cover the whole screen -->

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // ** VALIDAZIONI **

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // controllo sulle date
        // 1 - DataDa < DataA
        // 2 - Se esiste già un record per la persona DataDa deve essere DataA + 1 giorno
        window.Parsley.addValidator('dateinsequenza', function (value, requirement) {

            var dataDaCompare = $("#TBDataDa").val().substring(6, 11) + $("#TBDataDa").val().substring(3, 5) + $("#TBDataDa").val().substring(0, 2);
            var dataACompare = $("#TBDataA").val().substring(6, 11) + $("#TBDataA").val().substring(3, 5) + $("#TBDataA").val().substring(0, 2);

            // controllo sequenza
            if (dataDaCompare > dataACompare && dataACompare != "") {
                $("#TBDataDa").parsley().removeError('dateinsequenza');
                $("#TBDataDa").parsley().addError('dateinsequenza', { message: 'Data inizio deve essere < data fine', updateClass: true });
                return false;
            }

            // controllo sovrapposizione 
            var dataAjax = "{ Persons_id: '" + $("#DDLPersons").val() + "', " +
                " PersonsCostRate_id: '" + $("#TBPersonsCostRate_id").val() + "', " +
                " DataDa: '" + $("#TBDataDa").val() + "', " +
                " DataA: '" + $("#TBDataA").val() + "' }";

            $.ajax({
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/CheckDate",
                data: dataAjax,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false,
                success: function (data) {
                    if (data.d != "true") { // esiste, quindi errore
                        response = false;
                        var myMsg = "Data inizio dovrebbe essere: " + data.d;
                        $("#TBDataDa").parsley().removeError('dateinsequenza');
                        $("#TBDataDa").parsley().addError('dateinsequenza', { message: myMsg });
                    }
                    else
                        response = true;
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    alert(xhr.status);
                    alert(thrownError);
                }
            });
            return response;
        }, 32);
        //    .addMessage('it', 'dateinsequenza', 'Controllare le date di validità');

        // Validatore personalizzato per controllare che la data inizi con il primo giorno del mese
        window.Parsley.addValidator('firstdayofmonth', {
            validateString: function (value) {
                if (value.substring(0, 2) != '01' && value != "") {
                    $("#TBDataDa").parsley().removeError('firstdayofmonth');
                    $("#TBDataDa").parsley().addError('firstdayofmonth', { message: 'La data deve essere primo giorno del mese', updateClass: true });
                    return false;       
                }
            }
        });
        
        // ** INTERFACCIA **

        $("#TBDataA").datepicker($.datepicker.regional['it']);
        $("#TBDataDa").datepicker($.datepicker.regional['it']);

        $(":checkbox").addClass("css-checkbox");     // attiva checkbox

        // ** EVENTI TRIGGER **

        //trigger download of data.xlsx file
        $("#btn_download").click(function () {
            PersonsCostRateTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
        });

        $("#btn_crea").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            if (e.originalEvent.detail == 0) {
                return true;
            }

            initValue();  // inizializza campi

            openDialogForm("#dialog");

        });  // tasto crea record

        $('#mask').click(function () {
            $(this).hide();
            $('.window').hide();
        }); // chiude form modale

        $("#btnSalvaModale").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            if (!$('#FVForm').parsley().validate()) {
                // in modale la sola applicazione di fogli di stile per nascondere i messaggi di errore non è sufficiente
                var errorMessages = $('#valMsg .parsley-errors-list.filled');
                if (errorMessages.length > 1) 
                    errorMessages.not(':first').hide();
                return;
            }

            submitCreaAggiornaRecord();

            $('#mask').hide();
            $('.window').hide();

        }); // bottone salva su form modale

        $("#btnCancelModale").click(function (e) {
            //Cancel the link behavior
            e.preventDefault();
            $('#FVForm').parsley().reset();

            $('#mask').hide();
            $('.window').hide();
        }); // bottone chiude su form modale

        // ** TABULATOR **

        var trashIcon = function (cell, formatterParams, onRendered) { //plain text value
            return "<i class='fa fa-trash'></i>";
        };  // icona cancella
        var editIcon = function (cell, formatterParams, onRendered) { //plain text value
            return "<i class='fa fa-edit'></i>";
        };  // icona edit

        var PersonsCostRateTable = new Tabulator("#PersonsCostRateTable", {
            paginationSize: 12, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/WS_PersonsCostRate.asmx/GetPersonsCostRateTable", //ajax URL
            ajaxParams: { sAnno: "", active : <%= DDLAttivi.SelectedValue %> }, //ajax parameters
            ajaxConfig: "POST", //ajax HTTP request type
            ajaxContentType: "json", // send parameters to the server as a JSON encoded string
            layout: "fitColumns", //fit columns to width of table (optional)
            ajaxResponse: function (url, params, response) {
                //url - the URL of the request
                //params - the parameters passed with the request
                //response - the JSON object returned in the body of the response.
                return JSON.parse(response.d); //return the d property of a response json object
            },
            columns: [
                { title: "PersonsCostRate_id", field: "PersonsCostRate_Id", sorter: "number", visible: false },
                { title: "Persons_id", field: "Persons_id", sorter: "number", visible: false },
                { title: "Da", field: "DataDa", sorter: "string", width: 100, headerFilter: true },
                { title: "A", field: "DataA", sorter: "string", width: 100, headerFilter: true },
                { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: true },
                { title: "Societa", field: "CompanyName", sorter: "string", headerFilter: true },
                { title: "Cost Rate", field: "CostRate", sorter: "number", width: 80, headerFilter: true },
            <% if (Auth.ReturnPermission("MASTERDATA", "COSTRATE_UPDATE"))
        {
            Response.Write("{ formatter: trashIcon, width: 40, align: \"center\", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },");
            Response.Write("\n");
            Response.Write("{ formatter: editIcon, width: 40, align: \"center\", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },");
        }
            %>

            ],
        }); // Tabella principale

        // ** FUNZIONI **

        function initValue() {

            $('#TBPersonsCostRate_id').val('0'); // attenzione!
            $('#TBComment').val('');
            $('#TBCostRate').val('');
            $('#TBDataDa').val('');
            $('#TBDataA').val('');
            $('#LBCreatedBy').text('');
            $('#LBCreationDate').text('');
            $('#LBLastModifiedBy').text('');
            $('#LBLastModificationDate').text('');

        } // inizilizza form in creazione

        function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'sPersonsCostRate_id': '" + dati.PersonsCostRate_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/GetPersonsCostRate",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objPersonsCostRate = msg.d;

                    if (objPersonsCostRate.PersonsCostRate_id > 0)
                        $('#TBPersonsCostRate_id').val(objPersonsCostRate.PersonsCostRate_id);
                    $('#DDLPersons').val(objPersonsCostRate.Persons_id);
                    $('#TBCostRate').val(objPersonsCostRate.CostRate);
                    $('#TBDataDa').val(objPersonsCostRate.DataDa);
                    $('#TBDataA').val(objPersonsCostRate.DataA);
                    $('#TBComment').val(objPersonsCostRate.Comment);
                    // valorizzazione data/autore di creazione e modifica
                    var CreatedBy = isNullOrEmpty(objPersonsCostRate.CreatedBy) ? "" : objPersonsCostRate.CreatedBy + " il ";
                    $('#LBCreatedBy').text(CreatedBy);
                    $('#LBCreationDate').text(objPersonsCostRate.CreationDate);
                    var LastModifiedBy = isNullOrEmpty(objPersonsCostRate.LastModifiedBy) ? "" : objPersonsCostRate.LastModifiedBy + " il ";
                    $('#LBLastModifiedBy').text(LastModifiedBy);
                    $('#LBLastModificationDate').text(objPersonsCostRate.LastModificationDate);

                    openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'PersonsCostRate_id': '" + dati.PersonsCostRate_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/DeletePersonsCostRate",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == true) {
                        riga.delete();
                    } else
                        ShowPopup("Impossibile cancellare il record");

                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        } // cancella record, chiamata da Tabulator

        function submitCreaAggiornaRecord() {

            if ($('#TBCostRate').val() == '')
                $('#TBCostRate').val(0);

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{ 'PersonsCostRate_id': '" + $('#TBPersonsCostRate_id').val() + "', " +
                "'Persons_id': '" + $('#DDLPersons').val() + "' , " +
                "'CostRate': '" + $('#TBCostRate').val() + "' , " +
                "'Comment': '" + $('#TBComment').val() + "' , " +
                "'DataDa': '" + $('#TBDataDa').val() + "' , " +
                "'DataA': '" + $('#TBDataA').val() + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/CreateUpdatePersonsCostRate",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    PersonsCostRateTable.replaceData() // ricarica tabella dopo insert

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

    <asp:SqlDataSource runat="server" ID="DSPersons"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="****"></asp:SqlDataSource>

</body>

</html>
