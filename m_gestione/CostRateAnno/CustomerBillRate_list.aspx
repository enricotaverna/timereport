<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CustomerBillRate_list.aspx.cs" Inherits="m_gestione_CostRateAnno_CustomerBillRate_list" %>

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
        <asp:Literal runat="server" Text="Bill Rate Cliente" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <br />

            <div class="row justify-content-center">

                <div class="StandardForm col-9">

                    <div id="CustomerBillRateTable"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: BACK_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" formnovalidate="" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->

            </div>
            <!--End LastRow-->

            <!-- *** Finestra Dialogo *** -->
            <div id="ModalWindow">

                <div id="dialog" class="window">

                    <div id="FormWrap" class="StandardForm">

                        <div class="formtitle">Bill Rate Cliente</div>

                        <div class="input nobottomborder">
                            <!-- ** CLIENTE ** -->
                            <div class="inputtext">Cliente *</div>
                            <asp:DropDownList ID="DDLCustomers" runat="server" DataSourceID="DSCustomers" DataTextField="Nome1" DataValueField="CodiceCliente"
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-required-message="Cliente obbligatorio"
                                AppendDataBoundItems="True">
                                <asp:ListItem Text="-- selezionare un valore --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** VALIDO DA / A ** -->
                            <div class="inputtext">Valido da *</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBDataDa" Columns="10" autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-no-focus="true"
                                data-parsley-required="true" data-parsley-required-message="Data da obbligatoria"
                                data-parsley-pattern="/^(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/" data-parsley-pattern-message="Data non valida (gg/mm/aaaa)"
                                data-parsley-datavalida="true" data-parsley-datavalida-message="Data non valida (gg/mm/aaaa)"
                                data-parsley-firstdayofmonth="true" data-parsley-firstdayofmonth-message="La data deve essere primo giorno del mese"
                                data-parsley-dateinsequenza="true" />
                            &nbsp;&nbsp;a *&nbsp;&nbsp;
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBDataA" Columns="10" autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-no-focus="true"
                                data-parsley-required="true" data-parsley-required-message="Data a obbligatoria"
                                data-parsley-pattern="/^(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/" data-parsley-pattern-message="Data non valida (gg/mm/aaaa)"
                                data-parsley-datavalida="true" data-parsley-datavalida-message="Data non valida (gg/mm/aaaa)" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** BILL RATE ** -->
                            <div class="inputtext">Bill Rate (€)</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBBillRate" Columns="10" autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-importo="true" data-parsley-importo-message="Importo non valido (max 2 decimali)" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COST RATE ** -->
                            <div class="inputtext">Cost Rate (€)</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBCostRate" Columns="10" autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-importo="true" data-parsley-importo-message="Importo non valido (max 2 decimali)" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COMMENT ** -->
                            <div class="inputtext">Nota</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBComment" Width="260px" MaxLength="40" autocomplete="off"
                                data-parsley-errors-container="#valMsg" data-parsley-maxlength="40" data-parsley-maxlength-message="Nota troppo lunga (max 40 caratteri)" />
                        </div>

                        <div class="legendaText">
                            <p><span>[C] </span><span id="LBCreatedBy"></span><span id="LBCreationDate"></span></p>
                            <p><span>[M] </span><span id="LBLastModifiedBy"></span><span id="LBLastModificationDate"></span></p>
                        </div>

                        <asp:TextBox runat="server" ID="TBCustomerBillRate_id" Style="visibility: hidden; height: 0px; margin: 0px" />

                        <div class="buttons">
                            <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 230px"></div>
                            <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                            <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:BACK_TXT %>" CssClass="greybutton" />
                        </div>

                    </div>

                </div>
                <%--DIALOG--%>
            </div>

        </form>
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

    <div id="mask"></div>
    <!-- Mask to cover the whole screen -->

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource runat="server" ID="DSCustomers"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT CodiceCliente, Nome1 FROM [Customers] ORDER BY Nome1"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        var WS_URL = "/timereport/webservices/WS_BillRate.asmx/";
        var REGEX_DATA = /^(0[1-9]|[12]\d|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/;

        // ** VALIDAZIONI **

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // data reale nel formato dd/MM/yyyy (es. rifiuta 31/02/2026)
        function dataReale(value) {
            if (!REGEX_DATA.test(value)) return false;
            var p = value.split('/');
            var d = new Date(parseInt(p[2], 10), parseInt(p[1], 10) - 1, parseInt(p[0], 10));
            return d.getFullYear() == parseInt(p[2], 10) && d.getMonth() == parseInt(p[1], 10) - 1 && d.getDate() == parseInt(p[0], 10);
        }

        function dataToSort(value) { // dd/MM/yyyy -> yyyyMMdd
            return value.substring(6, 10) + value.substring(3, 5) + value.substring(0, 2);
        }

        window.Parsley.addValidator('datavalida', {
            validateString: function (value) {
                return value === "" || dataReale(value);
            }
        });

        // il primo giorno del mese
        window.Parsley.addValidator('firstdayofmonth', {
            validateString: function (value) {
                return value === "" || value.substring(0, 2) == '01';
            }
        });

        // Importo: virgola come separatore decimale, max 2 decimali, max 8 cifre intere, punto ammesso solo come separatore migliaia
        window.Parsley.addValidator('importo', {
            validateString: function (value) {
                value = $.trim(value);
                if (value === "") return true;
                if (!/^(\d{1,8}|\d{1,3}(\.\d{3})+)(,\d{1,2})?$/.test(value)) return false;
                return value.split(',')[0].replace(/\./g, '').length <= 8;
            }
        });

        // Controllo sulle date (stessa semantica delle pagine Cost Rate):
        // 1 - DataDa <= DataA
        // 2 - se esistono altri record per il cliente, DataDa deve essere MAX(DataA) + 1 giorno
        window.Parsley.addValidator('dateinsequenza', {
            validateString: function (value) {

                var dataDa = $("#TBDataDa").val();
                var dataA = $("#TBDataA").val();

                // formato non valido o campi vuoti: segnalati dagli altri validatori
                if (!dataReale(dataDa) || !dataReale(dataA) || $("#DDLCustomers").val() == "") return true;

                var setMsg = function (msg) {
                    $("#TBDataDa").attr('data-parsley-dateinsequenza-message', msg);
                    $("#TBDataDa").parsley().options.dateinsequenzaMessage = msg;
                };

                if (dataToSort(dataDa) > dataToSort(dataA)) {
                    setMsg('Data inizio deve essere < data fine');
                    return false;
                }

                var esito = true;

                $.ajax({
                    url: WS_URL + "CheckDateCustomer",
                    data: JSON.stringify({
                        CodiceCliente: $("#DDLCustomers").val(),
                        CustomerBillRate_id: parseInt($("#TBCustomerBillRate_id").val(), 10) || 0,
                        DataDa: dataDa,
                        DataA: dataA
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: 'json',
                    type: 'post',
                    async: false,   // il validatore deve rispondere in modo sincrono
                    success: function (data) {
                        if (data.d != "true") {
                            // data attesa (dd/MM/yyyy) oppure messaggio di errore del servizio
                            setMsg(REGEX_DATA.test(data.d) ? "Data inizio dovrebbe essere: " + data.d : data.d);
                            esito = false;
                        }
                    },
                    error: function () {
                        setMsg("Impossibile verificare le date");
                        esito = false;
                    }
                });
                return esito;
            },
            priority: 32
        });

        // ** INTERFACCIA **

        $("#TBDataA").datepicker($.datepicker.regional['it']);
        $("#TBDataDa").datepicker($.datepicker.regional['it']);

        // ** EVENTI TRIGGER **

        //trigger download of data.xlsx file
        $("#btn_download").click(function (e) {
            e.preventDefault();
            CustomerBillRateTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
        });

        $("#btn_crea").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            if (e.originalEvent && e.originalEvent.detail == 0)
                return true;

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

            clearFormError();

            if (!$('#FVForm').parsley().validate()) {
                // in modale la sola applicazione di fogli di stile per nascondere i messaggi di errore non è sufficiente
                var errorMessages = $('#valMsg .parsley-errors-list.filled');
                if (errorMessages.length > 1)
                    errorMessages.not(':first').hide();
                return;
            }

            // almeno una tariffa (0 è valido, vuoto no)
            if ($.trim($('#TBBillRate').val()) === '' && $.trim($('#TBCostRate').val()) === '') {
                showFormError("Inserire almeno una tariffa", $('#TBBillRate, #TBCostRate'));
                return;
            }

            submitCreaAggiornaRecord();

        }); // bottone salva su form modale

        $("#btnCancelModale").click(function (e) {
            //Cancel the link behavior
            e.preventDefault();
            clearFormError();
            $('#FVForm').parsley().reset();

            $('#mask').hide();
            $('.window').hide();
        }); // bottone chiude su form modale

        // ** TABULATOR **

        // formato italiano #.##0,00 ; vuoto se NULL
        function formatImporto(v) {
            if (v === null || v === undefined || v === "") return "";
            var s = Number(v).toFixed(2).split('.');
            return s[0].replace(/\B(?=(\d{3})+(?!\d))/g, '.') + ',' + s[1];
        }

        var importoFormatter = function (cell) { return formatImporto(cell.getValue()); };
        // il filtro lavora sul testo visualizzato (1.234,56), non sul numero grezzo
        var importoHeaderFilter = function (headerValue, rowValue) { return formatImporto(rowValue).indexOf(headerValue) >= 0; };

        // cestino solo sull'ultimo periodo del cliente/progetto (flag IsLast calcolato dal web service), per non creare buchi
        var trashIconUltimo = function (cell, formatterParams, onRendered) {
            return cell.getRow().getData().IsLast ? trashIcon(cell, formatterParams, onRendered) : "";
        };

        var CustomerBillRateTable = new Tabulator("#CustomerBillRateTable", {
            paginationSize: 15,
            pagination: "local",
            headerFilterPlaceholder: "filtra i record...",
            ajaxURL: WS_URL + "GetCustomerBillRateTable",
            ajaxParams: {},
            ajaxConfig: "POST",
            ajaxContentType: "json",
            layout: "fitColumns",
            ajaxResponse: function (url, params, response) {
                return JSON.parse(response.d);
            },
            initialSort: [
                { column: "DataDa", dir: "desc" },
                { column: "NomeCliente", dir: "asc" }
            ],
            columns: [
                { title: "CustomerBillRate_id", field: "CustomerBillRate_id", sorter: "number", visible: false },
                {
                    title: "Da", field: "DataDa", width: 90, headerFilter: true,
                    sorter: function (a, b, aRow, bRow) { // cronologico, non per stringa dd/MM/yyyy
                        var x = aRow.getData().DataDaSort, y = bRow.getData().DataDaSort;
                        return x < y ? -1 : (x > y ? 1 : 0);
                    }
                },
                {
                    title: "A", field: "DataA", width: 90, headerFilter: true,
                    sorter: function (a, b, aRow, bRow) {
                        var x = aRow.getData().DataASort, y = bRow.getData().DataASort;
                        return x < y ? -1 : (x > y ? 1 : 0);
                    }
                },
                { title: "Cod. Cliente", field: "CodiceCliente", sorter: "string", width: 110, headerFilter: true },
                { title: "Cliente", field: "NomeCliente", sorter: "string", headerFilter: true },
                { title: "Bill Rate", field: "BillRate", sorter: "number", width: 100, align: "right", formatter: importoFormatter, headerFilter: true, headerFilterFunc: importoHeaderFilter },
                { title: "Cost Rate", field: "CostRate", sorter: "number", width: 100, align: "right", formatter: importoFormatter, headerFilter: true, headerFilterFunc: importoHeaderFilter },
                { title: "Nota", field: "Comment", sorter: "string", headerFilter: true },
                <%= CanUpdate ? "{ formatter: trashIconUltimo, width: 40, align: \"center\", cellClick: function(e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } }," : "" %>
                <%= CanUpdate ? "{ formatter: editIcon, width: 40, align: \"center\", cellClick: function(e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } }," : "" %>
            ],
        }); // Tabella principale

        // ** FUNZIONI **

        function showFormError(msg, $fields) {
            clearFormError();
            var $ul = $('<ul class="parsley-errors-list filled manual-error"></ul>');
            $('<li></li>').text(msg).appendTo($ul);   // text(): il messaggio del server non viene interpretato come HTML
            $('#valMsg').append($ul);
            if ($fields) $fields.addClass('parsley-error');
        }

        function clearFormError() {
            $('#valMsg .manual-error').remove();
            $('#FVForm .parsley-error').removeClass('parsley-error');
        }

        function initValue() {

            clearFormError();
            $('#valMsg').empty();
            $('#TBCustomerBillRate_id').val('0'); // attenzione!
            $('#DDLCustomers').val('');
            $('#TBComment').val('');
            $('#TBCostRate').val('');
            $('#TBBillRate').val('');
            //$('#TBDataDa').val(''); // togliendo reset si propone come dafault l'ultimo valore inserito
            //$('#TBDataA').val('');
            $('#LBCreatedBy').text('');
            $('#LBCreationDate').text('');
            $('#LBLastModifiedBy').text('');
            $('#LBLastModificationDate').text('');

        } // inizilizza form in creazione

        function T_leggiRecord(dati, riga) {

            $('#valMsg').empty(); // pulisce messaggi di errore precedenti
            clearFormError();

            $.ajax({

                type: "POST",
                url: WS_URL + "GetCustomerBillRate",
                data: JSON.stringify({ id: dati.CustomerBillRate_id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var rec = msg.d;

                    if (!rec || rec.CustomerBillRate_id <= 0) {
                        ShowPopup("Record non trovato o operazione non autorizzata");
                        return;
                    }

                    $('#TBCustomerBillRate_id').val(rec.CustomerBillRate_id);
                    $('#DDLCustomers').val(rec.CodiceCliente);   // stringa: nessuna conversione numerica
                    $('#TBBillRate').val(formatImporto(rec.BillRate));
                    $('#TBCostRate').val(formatImporto(rec.CostRate));
                    $('#TBDataDa').val(rec.DataDa);
                    $('#TBDataA').val(rec.DataA);
                    $('#TBComment').val(rec.Comment);
                    // valorizzazione data/autore di creazione e modifica
                    var CreatedBy = isNullOrEmpty(rec.CreatedBy) ? "" : rec.CreatedBy + " il ";
                    $('#LBCreatedBy').text(CreatedBy);
                    $('#LBCreationDate').text(rec.CreationDate);
                    var LastModifiedBy = isNullOrEmpty(rec.LastModifiedBy) ? "" : rec.LastModifiedBy + " il ";
                    $('#LBLastModifiedBy').text(LastModifiedBy);
                    $('#LBLastModificationDate').text(rec.LastModificationDate);

                    openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    ShowPopup("Errore nella lettura del record");
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            if (!dati.IsLast) return;   // il server rifiuta comunque la cancellazione di un periodo non ultimo

            ConfirmDialog("Conferma cancellazione", "Vuoi cancellare il record?", "Cancella", function (confirm) {

                if (!confirm) return;

                $.ajax({

                    type: "POST",
                    url: WS_URL + "DeleteCustomerBillRate",
                    data: JSON.stringify({ id: dati.CustomerBillRate_id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        var res = msg.d;
                        if (res && res.Success)
                            CustomerBillRateTable.replaceData();   // ricarica: il periodo precedente diventa il nuovo ultimo
                        else
                            ShowPopup(res && res.Message ? res.Message : "Impossibile cancellare il record");
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore di comunicazione con il server");
                    }

                }); // ajax

            });

        } // cancella record, chiamata da Tabulator

        // '1.234,56' -> 1234.56 ; vuoto -> null (NULL, non 0)
        function normalizzaImporto(v) {
            v = $.trim(v);
            if (v === '') return null;
            return parseFloat(v.replace(/\./g, '').replace(',', '.'));
        }

        function submitCreaAggiornaRecord() {

            var rec = {
                CustomerBillRate_id: parseInt($('#TBCustomerBillRate_id').val(), 10) || 0,
                CodiceCliente: $('#DDLCustomers').val(),
                BillRate: normalizzaImporto($('#TBBillRate').val()),
                CostRate: normalizzaImporto($('#TBCostRate').val()),
                DataDa: $('#TBDataDa').val(),
                DataA: $('#TBDataA').val(),
                Comment: $('#TBComment').val()
            };

            $('#btnSalvaModale').prop('disabled', true);   // evita doppio invio

            $.ajax({

                type: "POST",
                url: WS_URL + "SaveCustomerBillRate",
                data: JSON.stringify({ rec: rec }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    var res = msg.d;
                    if (res && res.Success) {
                        // chiude dialogo e ricarica tabella solo a salvataggio riuscito
                        $('#mask').hide();
                        $('.window').hide();
                        CustomerBillRateTable.replaceData();
                    } else {
                        showFormError(res && res.Message ? res.Message : "Salvataggio non riuscito");
                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    showFormError("Errore di comunicazione con il server");
                },

                complete: function () {
                    $('#btnSalvaModale').prop('disabled', false);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

</body>

</html>
