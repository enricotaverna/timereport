<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrainingPlan_schedule.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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

<style>
    .inputtext, .ASPInputcontent { Width: 170px; }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Valuta Corsi" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="FVForm" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-11 RoundedBox">
                    <div class="row">
                        <div class="col-1">
                            <label class="inputtext">Anno</label>
                        </div>
                        <div class="col-4">
                                    <asp:DropDownList ID="DDLAnno" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                        DataTextField="AnnoDesc" DataValueField="Anno" Style="width: 150px"
                                        >
                                    </asp:DropDownList>
                        </div>
                    </div>
                    <!-- Fine row -->
                </div>
                <!-- Fine RoundedBox -->
            </div>
            <!-- *** Fine riquadro navigazione *** -->

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-11 px-0">

                    <div id="TableTrainingPlan"></div>

                    <div class="buttons">
                        <%--        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Project/Projects_lookup_form.aspx" />--%>
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->

            </div>
            <!--End LastRow-->

            <div id="ModalWindow">
                <!--  Finestra Dialogo -->

                <div id="dialog" class="window">

                    <div id="FormWrap" class="StandardForm">

                        <div class="formtitle">Commento</div>

                        <div class="input nobottomborder">
                            <!-- ** DESCRIZIONE ** -->
                            <div class="inputtext">Descrizione</div>
                            <asp:TextBox runat="server" ID="TBComment" TextMode="MultiLine" Rows="6" CssClass="textarea" />
                        </div>

                        <asp:TextBox runat="server" ID="TBCoursePlan_id" Style="visibility: hidden" />

                        <div class="buttons">
                            <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                            <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
                        </div>

                    </div>

                </div>
                <%--DIALOG--%>
            </div>
            <!--  Finestra Dialogo -->

        </form>
    </div>
    <!-- *** END Container *** -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.CutoffDate %></div>
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

        // ** EVENTI TRIGGER **
        $("#FVForm").click(function (e) {


            if (e.originalEvent.detail == 0)
                e.preventDefault(); //Cancel the link behavior

        });

        $("#btnSalvaModale").click(function (e) {

            $('#FVForm').parsley().validate();

            if (!$('#FVForm').parsley().isValid())
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
        var editIcon = function (cell, formatterParams, onRendered) { //plain text value
            var value = cell.getRow().getData().Comment;
            if (value == null || value == "")
                return "<i class='fa fa-edit'></i>";
            else
                return "<i class='fa fa-comment'></i>";
        };  // icona edit

        //validator to prevent values divisible by the provided devisor
        var CourseStatusCheck = function (cell, value, parameters) {
            //cell - the cell component for the edited cell
            //value - the new input value of the cell
            //parameters - the parameters passed in with the validator

            if (value == "ATTENDED" && cell.getRow().getData().CourseDate == null) { // stato ATTENDED e data non valorizzata
                alert("Specificare data di esecuzione del corso");
                return false;
            }

            return true;
        }

        var TableTrainingPlan = new Tabulator("#TableTrainingPlan", {
            cellEdited: function (cell) {
                //cell - cell component
                var CoursePlan_id = cell.getRow().getCells()[0].getValue(); // indice record da aggiornare

                // chiamata di aggiornamento
                var values = "{'sCoursePlan_id': '" + CoursePlan_id + "' , " +
                    " 'sFieldToUpdate': '" + cell.getField() + "' , " +
                    " 'sValue': '" + cell.getValue() + "' " +
                    "  } ";
                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/HR_Training.asmx/UpdateTrainingPlanRecord",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d != true) {
                            alert("Error in updating Training Plan, please exit and retry");
                        }
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        return false;
                    }

                }); // ajax        


            },
            paginationSize: 13, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/HR_Training.asmx/GetTrainingPlan", //ajax URL
            ajaxParams: { Persons_id: "0", Anno: $("#DDLAnno").val(), Mode: "SCHEDULE" }, //ajax parameters
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
                { title: "CoursePlan_id", field: "CoursePlan_id", sorter: "number", visible: false },
                { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: "input" },
                { title: "Manager", field: "ManagerName", sorter: "string", headerFilter: "input" },
                { title: "Codice Corso", field: "CourseCode", sorter: "string", headerFilter: "input" },
                { title: "Corso", field: "CourseName", sorter: "string", headerFilter: "input" },
                { title: "Tipo", field: "CourseTypeName", sorter: "string", headerFilter: true },
                { title: "Prodotto", field: "ProductName", sorter: "string", headerFilter: true },
                {
                    title: "Priorità", field: "Priority", sorter: "integer", headerFilter: true, align: "center",
                    headerFilter: "select", headerFilterParams: { values: { "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "": "all" } }
                },
                {
                    title: "Stato", field: "CourseStatusName", sorter: "string", headerFilter: "select",
                    headerFilterParams: { values: { "PROPOSED": "PROPOSED", "PLANNED": "PLANNED", "SCHEDULED": "SCHEDULED", "ATTENDED": "ATTENDED", "CANCELED": "CANCELED", "": "All Status" } },
                    editor: "select",
                    editorParams: { values: { "PROPOSED": "PROPOSED", "PLANNED": "PLANNED", "SCHEDULED": "SCHEDULED", "ATTENDED": "ATTENDED", "CANCELED": "CANCELED" } },
                    validator: [{ type: CourseStatusCheck, parameters: {} }] // nessun parametro
                },
                { title: "Data Corso", field: "CourseDate", sorter: "date", headerFilter: true, editor: "input", validator: "regex:^[0-9]{2}\/[0-9]{2}\/[0-9]{4}" },
                { formatter: trashIcon, width: 40, align: "center", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
                { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
            ],
        });

        // ** FUNZIONI **

        function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'sCoursePlan_id': '" + dati.CoursePlan_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/HR_Training.asmx/GetCoursePlanItem",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objCourse = msg.d;

                    if (objCourse.CoursePlan_id > 0)
                        $('#TBCoursePlan_id').val(objCourse.CoursePlan_id);
                    $('#TBComment').val(objCourse.Comment);

                    openDialogForm("#dialog");

                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            if (dati.CourseStatusName == "PROPOSED") {

                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'sCoursePlan_id': '" + dati.CoursePlan_id + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/HR_Training.asmx/CancellaTrainingPlanRecord",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d = 'true') {
                            riga.delete();
                        }
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        return false;
                    }

                }); // ajax

            }


        }

        function submitCreaAggiornaRecord() {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{ 'CoursePlan_id': '" + $('#TBCoursePlan_id').val() + "', " +
                "'Comment': '" + $('#TBComment').val() + "', " +
                "'Feedback': 'no_upd'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/HR_Training.asmx/UpdateCoursePlanItem",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    CourseCatalogTable.replaceData() // ricarica tabella dopo insert

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

</body>

</html>
