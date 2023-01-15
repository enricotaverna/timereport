<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CostRateProgetto_list.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title><asp:Literal runat="server" Text="Cost Rate" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <div class="row justify-content-center">

                <div class="StandardForm col-11">

                    <div id="ProjectCostRateTable"></div>

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

                        <div class="formtitle">Costo Persona/Progetto</div>

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
                            <!-- ** VALIDO DA ** -->
                            <div class="inputtext">Valido da</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBDataDa" Columns="10"
                                data-parsley-errors-container="#valMsg" data-parsley-required="true" data-parsley-no-focus="true" data-parsley-errors-messages-disabled=""
                                data-parsley-dateinsequenza="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                            &nbsp;&nbsp;a&nbsp;&nbsp;
                <asp:TextBox class="ASPInputcontent" runat="server" ID="TBDataA" Columns="10" data-parsley-errors-container="#valMsg" data-parsley-no-focus="true"
                    data-parsley-required="true" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COST RATE ** -->
                            <div class="inputtext">Cost Rate(€)</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBCostRate" Columns="10" data-parsley-errors-container="#valMsg" data-parsley-pattern="/^[0-9]{0,4}$/" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** BILL RATE ** -->
                            <div class="inputtext">Bill Rate(€)</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBBillRate" Columns="10" data-parsley-errors-container="#valMsg" data-parsley-pattern="/^[0-9]{0,4}$/" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COMMENT ** -->
                            <div class="inputtext">Nota</div>
                            <asp:TextBox class="ASPInputcontent" runat="server" ID="TBComment" Width="260px" />
                        </div>

                        <div class="" style="font-size: 10px; line-height: 14px;margin: 20px 0px -10px 10px;color:dimgrey">
                                        <p style="margin:0px"><span style="width:200px">[C] </span><span id="LBCreatedBy"></span><span id="LBCreationDate"></span></p>
                                        <p style="margin:0px"><span style="width:200px">[M]</span><span id="LBLastModifiedBy"></span><span id="LBLastModificationDate"></span></p>                
                        </div> 

                        <asp:TextBox runat="server" ID="TBProjectCostRate_id"  Style="visibility: hidden; height:0px; margin:0px"/>

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
    <asp:SqlDataSource runat="server" ID="DSPersons"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT * FROM [Persons] WHERE Active = 'true' ORDER BY Name"></asp:SqlDataSource>
    <asp:SqlDataSource runat="server" ID="DSProjects"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Projects_id, ProjectCode + ' ' + LEFT(Name,25) as ProjectName FROM [Projects] WHERE Active = 'true' ORDER BY ProjectName"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // ** VALIDAZIONI **

        // *** attiva validazione campi form
        $('#formPersone').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });

        // controllo sulle date
        // 1 - DataDa < DataA
        // 2 - Se esiste già un record per la persona DataDa deve essere DataA + 1 giorno
        window.Parsley.addValidator('dateinsequenza', function (value, requirement) {

            var dataDaCompare = $("#TBDataDa").val().substring(6, 11) + $("#TBDataDa").val().substring(3, 5) + $("#TBDataDa").val().substring(0, 2);
            var dataACompare = $("#TBDataA").val().substring(6, 11) + $("#TBDataA").val().substring(3, 5) + $("#TBDataA").val().substring(0, 2);

            // controllo sequenza
            if (dataDaCompare > dataACompare) {
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

        // ** INTERFACCIA **

        $("#TBDataA").datepicker($.datepicker.regional['it']);
        $("#TBDataDa").datepicker($.datepicker.regional['it']);

        $(":checkbox").addClass("css-checkbox");     // attiva checkbox

        // ** EVENTI TRIGGER **

        //trigger download of data.xlsx file
        $("#btn_download").click(function () {
            ProjectCostRateTable.download("xlsx", "ExportData.xlsx", { sheetName: "Dati" });
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

        var ProjectCostRateTable = new Tabulator("#ProjectCostRateTable", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/WS_PersonsCostRate.asmx/GetProjectCostRateTable", //ajax URL
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
                { title: "ProjectCostRate_id", field: "ProjectCostRate_Id", sorter: "number", visible: false },
                { title: "Persons_id", field: "Persons_id", sorter: "number", visible: false },
                { title: "Project_id", field: "Project_id", sorter: "number", visible: false },
                { title: "Da", field: "DataDa", sorter: "string", width: 80, headerFilter: true },
                { title: "A", field: "DataA", sorter: "string", width: 80, headerFilter: true },
                { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: true },
                { title: "Prj Code", field: "ProjectCode", sorter: "string", headerFilter: true },
                { title: "Prj Name", field: "ProjectName", sorter: "string", headerFilter: true },
                { title: "Societa", field: "CompanyName", sorter: "string", headerFilter: true },
                { title: "Cost Rate", field: "CostRate", sorter: "number", width: 60, headerFilter: true },
                { title: "Bill Rate", field: "BillRate", sorter: "number", width: 60, headerFilter: true },
                { title: "Nota", field: "Comment", sorter: "string", width: 200, headerFilter: true },
                <% if (Auth.ReturnPermission("MASTERDATA", "COSTRATE_UPDATE"))
        {
            Response.Write("{ formatter: trashIcon, width: 40, align: \"center\", cellClick: function(e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },");
            Response.Write("\n");
            Response.Write("{ formatter: editIcon, width: 40, align: \"center\", cellClick: function(e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },");
        } %>
            ],
        }); // Tabella principale

        // ** FUNZIONI **

        function initValue() {

            $('#TBProjectCostRate_id').val('0'); // attenzione!
            $('#DDLProjects').val('');
            $('#TBComment').val('');
            $('#TBCostRate').val('');
            $('#TBBillRate').val('');
            $('#TBDataDa').val('');
            $('#TBDataA').val('');
            $('#LBCreatedBy').text('');
            $('#LBCreationDate').text('');
            $('#LBLastModifiedBy').text('');
            $('#LBLastModificationDate').text('');

        } // inizilizza form in creazione

        function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'sProjectCostRate_id': '" + dati.ProjectCostRate_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/GetProjectCostRate",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objProjectCostRate = msg.d;

                    if (objProjectCostRate.ProjectCostRate_id > 0)
                        $('#TBProjectCostRate_id').val(objProjectCostRate.ProjectCostRate_id);
                    $('#DDLPersons').val(objProjectCostRate.Persons_id);
                    $('#DDLProjects').val(objProjectCostRate.Projects_id);
                    $('#TBCostRate').val(objProjectCostRate.CostRate);
                    $('#TBBillRate').val(objProjectCostRate.BillRate);
                    $('#TBDataDa').val(objProjectCostRate.DataDa);
                    $('#TBDataA').val(objProjectCostRate.DataA);
                    $('#TBComment').val(objProjectCostRate.Comment);
                    $('#LBCreatedBy').text(objProjectCostRate.CreatedBy + " il ");
                    $('#LBCreationDate').text(objProjectCostRate.CreationDate);
                    $('#LBLastModifiedBy').text(objProjectCostRate.LastModifiedBy + " il ");
                    $('#LBLastModificationDate').text(objProjectCostRate.LastModificationDate);

                    openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ProjectCostRate_id': '" + dati.ProjectCostRate_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/DeleteProjectCostRate",
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

            if ($('#TBBillRate').val() == '')
                $('#TBBillRate').val(0);

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{ 'ProjectCostRate_id': '" + $('#TBProjectCostRate_id').val() + "', " +
                "'Persons_id': '" + $('#DDLPersons').val() + "' , " +
                "'Projects_id': '" + $('#DDLProjects').val() + "' , " +
                "'CostRate': '" + $('#TBCostRate').val() + "' , " +
                "'BillRate': '" + $('#TBBillRate').val() + "' , " +
                "'Comment': '" + $('#TBComment').val() + "' , " +
                "'DataDa': '" + $('#TBDataDa').val() + "' , " +
                "'DataA': '" + $('#TBDataA').val() + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_PersonsCostRate.asmx/CreateUpdateProjectCostRate",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    ProjectCostRateTable.replaceData() // ricarica tabella dopo insert

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

</body>

</html>
