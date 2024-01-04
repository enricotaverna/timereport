<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SpeseTM_list.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

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
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

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
<%--            <div class="form-group row justify-content-center">
                <div class="col-9 RoundedBox">
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
            </div>--%>
            <!-- *** Fine riquadro navigazione *** -->

            <br />

            <div class="row justify-content-center">

                <div class="StandardForm col-8">

                    <div id="ExpenseTMTable"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->

            </div>
            <!--End LastRow-->

            <!-- *** Finestra Dialogo *** -->
            <div id="ModalWindow">

                <!--  Finestra Dialogo -->

                <div id="dialog" class="window">

                    <div id="FormWrap" class="StandardForm">

                        <div class="formtitle">Fatturazione Spese T&M</div>

                        <div class="input nobottomborder">
                            <!-- ** TIPO SPESA ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Tipo Spesa" />
                            </div>
                            <asp:DropDownList ID="DLLExpenseType" runat="server" DataSourceID="DSExpenseType" DataTextField="ExpenseDescription" DataValueField="ExpenseType_Id"
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True" data-parsley-codiceUnico="true">
                                <asp:ListItem Text="-- selezionare un valore --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** PROGETTO ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Progetto" />
                            </div>
                            <asp:DropDownList ID="DDLProjects" runat="server" DataSourceID="DSProjects" DataTextField="ProjectName" DataValueField="Projects_id"
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                                <asp:ListItem Text="-- selezionare un valore --" Value=""></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COMMENT ** -->
                            <div class="inputtext">Descrizione</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBTMDescription" data-parsley-required="true" data-parsley-errors-container="#valMsg" Width="260px" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COST RATE ** -->
                            <div class="inputtext">Importo per unità</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBTMConversionRate" Columns="10" data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-pattern="/^\d{0,4},?\d{1,2}$/" />
                            <asp:Label runat="server" ID="TextBox1" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** ESCLUDI DA FATTURAZIONE ** -->
                            <div class="inputtext"></div>
                            <asp:CheckBox ID="CBExcludeBilling" runat="server" Checked='<%# Bind("ExcludeBilling") %>' />                            
                            <asp:Label AssociatedControlID="CBExcludeBilling" class="css-label" ID="Label3" runat="server" Text="Escludi da fatturazione"></asp:Label>
                        </div>

                        <div class="" style="font-size: 10px; line-height: 14px; margin: 20px 0px -10px 10px; color: dimgrey">
                            <p style="margin: 0px"><span style="width: 200px">[C] </span><span id="LBCreatedBy"></span><span id="LBCreationDate"></span></p>
                            <p style="margin: 0px"><span style="width: 200px">[M]</span><span id="LBLastModifiedBy"></span><span id="LBLastModificationDate"></span></p>
                        </div>

                        <asp:TextBox runat="server" ID="TBExpensesTM_Id" Style="visibility: hidden; height: 0px; margin: 0px" />

                        <div class="buttons">
                            <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                            <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                            <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
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
    <asp:SqlDataSource runat="server" ID="DSExpenseType"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT ExpenseType_Id, ExpenseCode + ' ' + Name as ExpenseDescription FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="DSProjects"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_id, ProjectCode + ' ' + LEFT(Name,25) as ProjectName FROM [Projects] WHERE Active = 'true' ORDER BY ProjectName"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");
        initValue();

        // ** VALIDAZIONI **

        // *** attiva validazione campi form
        $('#FVForm').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // controllo per evitare codici doppi
        window.Parsley.addValidator('codiceunico', function (value, requirement) {

            // controllo sovrapposizione 
            var values = "{ ExpensesTM_id: '" + $("#TBExpensesTM_Id").val() + "', " +
                " ExpenseType_id: '" + $("#DLLExpenseType").val() + "', " +
                " Projects_id: '" + $("#DDLProjects").val() + "'}";

            $.ajax({
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/CheckExpensesTMDouble",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: 'json',
                type: 'post',
                async: false,
                success: function (data) {
                    if (data.d) { // esiste, quindi errore
                        response = false;
                        var myMsg = "Record duplicato";
                        $("#DLLExpenseType").parsley().removeError('codiceunico');
                        $("#DLLExpenseType").parsley().addError('codiceunico', { message: myMsg });
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

        // ** INTERFACCIA **

        $(":checkbox").addClass("css-checkbox");     // attiva checkbox

        // ** EVENTI TRIGGER **

        //trigger download of data.xlsx file
        $("#btn_download").click(function () {
            ExpenseTMTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
        });

        $("#btn_crea").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            if (e.originalEvent.detail == 0)
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

            if (!$('#FVForm').parsley().validate())
                return;

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

        var ExpenseTMTable = new Tabulator("#ExpenseTMTable", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/WS_PersonsCostRate.asmx/GetExpenseTMTable", //ajax URL
            ajaxParams: { sAnno: "" }, //ajax parameters
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
                { title: "ExpensesTM_Id", field: "ExpensesTM_Id", sorter: "number", visible: false },
                { title: "Expenses_id", field: "Expenses_id", sorter: "number", visible: false },
                { title: "Project_id", field: "Project_id", sorter: "number", visible: false },
                //{ title: "Cod.Progetto", field: "ProjectCode", sorter: "string", headerFilter: true },
                { title: "Cliente", field: "NomeCliente", sorter: "string", headerFilter: true },
                { title: "Nome progetto", field: "ProjectName", sorter: "string", headerFilter: true },
                { title: "Spesa", field: "ExpenseCode", sorter: "string", headerFilter: true },
                //{ title: "Descrizione Spese", field: "Description", sorter: "string", headerFilter: true, width: 180 },
                { title: "Escludi", field: "ExcludeBilling", width: 60 },
                { title: "Importo", field: "TMConversionRate", sorter: "number", width: 80 },
                { title: "UoM", field: "UnitOfMeasure", sorter: "string", width: 60},
                { formatter: trashIcon, width: 40, align: "center", cellClick: function(e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
                { formatter: editIcon, width: 40, align: "center", cellClick: function(e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
            ],
        }); // Tabella principale

        // ** FUNZIONI **

        function initValue() {

            $('#TBExpensesTM_Id').val('0'); // attenzione!
            $('#DDLProjects').val('');
            $('#DLLExpenseType').val('');
            $('#TBTMDescription').val('');
            $('#TBTMConversionRate').val('');
            $('#CBExcludeBilling').val('');
            //$('#TBDataDa').val('');
            //$('#TBDataA').val('');
            $('#LBCreatedBy').text('');
            $('#LBCreationDate').text('');
            $('#LBLastModifiedBy').text('');
            $('#LBLastModificationDate').text('');

        } // inizilizza form in creazione

        function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'sExpensesTM_Id': '" + dati.ExpensesTM_Id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/GetExpenseTM",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objExpenseTM = msg.d;

                    if (objExpenseTM.ExpensesTM_Id > 0)
                        $('#TBExpensesTM_Id').val(objExpenseTM.ExpensesTM_Id);

                    $('#DLLExpenseType').val(objExpenseTM.ExpenseType_Id);
                    $('#DDLProjects').val(objExpenseTM.Projects_Id);
                    $('#TBTMConversionRate').val((objExpenseTM.TMConversionRate).toString().replace('.', ','));
                    $('#CBExcludeBilling').val(objExpenseTM.ExcludeBilling);
                    $('#TBTMDescription').val(objExpenseTM.TMDescription);
                    $('#LBCreatedBy').text(objExpenseTM.CreatedBy + " il ");
                    $('#LBCreationDate').text(objExpenseTM.CreationDate);
                    $('#LBLastModifiedBy').text(objExpenseTM.LastModifiedBy + " il ");
                    $('#LBLastModificationDate').text(objExpenseTM.LastModificationDate);

                    openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ExpensesTM_Id': '" + dati.ExpensesTM_Id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/DeleteExpenseTM",
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

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{ 'ExpensesTM_Id': '" + $('#TBExpensesTM_Id').val() + "', " +
                "'ExpenseType_Id': '" + $('#DLLExpenseType').val() + "' , " +
                "'Projects_Id': '" + $('#DDLProjects').val() + "' , " +
                "'TMConversionRate': '" + $('#TBTMConversionRate').val() + "' , " +
                "'ExcludeBilling': '" + $('#CBExcludeBilling')[0].checked + "' , " +
                "'TMDescription': '" + $('#TBTMDescription').val() + "' } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/CreateUpdateExpenseTM",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    ExpenseTMTable.replaceData() // ricarica tabella dopo insert

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

</body>

</html>
