<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Approval_list.aspx.cs" Inherits="m_gestione_Approval_list" %>

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

<style>
    .inputtext, .ASPInputcontent {
        Width: 170px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Richieste approvazione</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="FVForm" runat="server">

            <!--**** tabella principale ***-->
            <div class="row justify-content-center pt-3">
                <div class="col-9 px-0">

                    <div id="ApprovalListTable"></div>


                    <div class="buttons">
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

                        <div class="formtitle">Approvazione Richiesta</div>

                        <div class="input nobottomborder">
                            <!-- ** DATA RICHIESTA ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Data richiesta" />
                            </div>
                            <asp:Label CssClass="inputtext" ID="LBCreationDate" runat="server" />
                        </div>

                        <div class="input  nobottomborder">
                            <!-- ** Stato ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Stato" />
                            </div>
                            <asp:Label ID="LBApprovalStatus" class="inputtext" runat="server" Style="width: 200px" />
                        </div>

                        <div class="input">
                            <!-- ** PERSONA ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Consulente" />
                            </div>
                            <asp:Label ID="LBPersonName" CssClass="inputtext" runat="server" />
                        </div>

                        <div class="input  nobottomborder">
                            <!-- ** DATA RICHIESTA ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Periodo" />
                            </div>
                            <asp:Label ID="LBFromDate" class="inputtext" runat="server" />
                            <asp:Label ID="LBToDate" class="inputtext" runat="server" />
                        </div>

                        <div class="input">
                            <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Richiesta"></asp:Label>
                            <asp:Label class="inputtext" runat="server" ID="LBRichiesta" />
                        </div>

                        <div class="input">
                            <!-- ** COMMENT ** -->
                            <div class="inputtext">Nota</div>
                            <asp:TextBox class="textarea" runat="server" ID="TBComment" TextMode="MultiLine" Columns="30" Rows="4" Enabled="False" />
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** COMMENT ** -->
                            <div class="inputtext">Nota approvatore</div>
                            <asp:TextBox class="textarea" runat="server" ID="TBApprovalText1" TextMode="MultiLine" Columns="30" Rows="4" data-parsley-validate-if-empty="" data-parsley-errors-container="#valMsg" data-parsley-testo-obbligatorio="true" />
                        </div>

                        <asp:TextBox runat="server" ID="TBApprovalRequest_id" Style="visibility: hidden" />

                        <div class="buttons">
                            <div id="valMsg" class="parsley-single-error"></div>
                            <asp:Button ID="btnApprova" runat="server" CommandName="Insert" Text="<%$ appSettings:APPROVE_TXT %>" CssClass="greenbutton" />
                            <asp:Button ID="btnRifiuta" runat="server" CommandName="Insert" Text="<%$ appSettings:REJECT_TXT %>" CssClass="redbutton" />
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <div id="mask"></div>
    <!-- Mask to cover the whole screen -->

</body>

<!-- *** JAVASCRIPT *** -->
<script>

    // include di snippet html per menu and background color mgt
    includeHTML();
    InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    // ** VALIDAZIONI **
    var btnRifiutatoClick = false;

    // *** attiva validazione campi form
    $('#formPersone').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
    });

    // ***  Controllo che esista un commento se il progetto lo richiede ***
    window.Parsley.addValidator('testoObbligatorio', {
        validateString: function (value) {

            if (btnRifiutatoClick & $("#TBApprovalText1").val().length == 0)
                return $.Deferred().reject("inserire un commento");
            else
                return true;
        }
    });

    // ** INTERFACCIA **

    // ** EVENTI TRIGGER **

    $('#mask').click(function () {
        $(this).hide();
        $('.window').hide();
    }); // chiude form modale

    $("#btnApprova").click(function (e) {

        //Cancel the link behavior
        e.preventDefault();
        btnRifiutatoClick = false;

        if (!$('#FVForm').parsley().validate())
            return;

        submitAggiornaRecord("APPR");

        $('#mask').hide();
        $('.window').hide();

    }); // bottone salva su form modale

    $("#btnRifiuta").click(function (e) {

        //Cancel the link behavior
        e.preventDefault();
        btnRifiutatoClick = true;

        if (!$('#FVForm').parsley().validate())
            return;

        submitAggiornaRecord("REJE");

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
        return "<i class='fa fa-edit'></i>";
    };  // icona edit

    var ApprovalListTable = new Tabulator("#ApprovalListTable", {
        initialHeaderFilter: [{ field: "ApprovalStatus", value: 'REQU' } //valore iniziare dello stato per filtrare
        ],
        paginationSize: 18, // this option can take any positive integer value (default = 10)
        pagination: "local", //enable local pagination.
        headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
        ajaxURL: "/timereport/webservices/WF_ApprovalWorkflow.asmx/GetApprovalListTable", //ajax URL
        ajaxParams: { persons_id: <%= CurrentSession.Persons_id  %>  }, //ajax parameters
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
            { title: "ApprovalRequest_id", field: "ApprovalRequest_id", sorter: "number", visible: false },
            { title: "Richiesta del", field: "CreationDate", sorter: "string", width: 100, headerFilter: true },
            { title: "Da", field: "FromDate", sorter: "string", width: 100, headerFilter: true },
            { title: "A", field: "ToDate", sorter: "string", width: 100, headerFilter: true },
            { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: true },
            { title: "Approvatore", field: "ManagerName", sorter: "string", headerFilter: true },
            { title: "Causale", field: "ProjectName", sorter: "string", headerFilter: true },
            { title: "Ore", field: "Hours", sorter: "number", visible: true },
            {
                title: "Stato", field: "ApprovalStatus", sorter: "string", headerFilter: "select",
                headerFilterParams: { values: { "REQU": "Richiesti", "APPR": "Approvati", "NOTF": "Notificati", "": "All Status" } }
            },
            { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
        ],
    }); // Tabella principale

    // ** FUNZIONI **

    function T_leggiRecord(dati, riga) {

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{'ApprovalRequest_id': '" + dati.ApprovalRequest_id + "'   } ";

        $.ajax({

            type: "POST",
            url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/GetApprovalRequest",
            data: values,
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (msg) {

                var objApprovalRecord = msg.d;

                if (objApprovalRecord.approvalRequest_id > 0) {
                    $('#TBApprovalRequest_id').val(objApprovalRecord.approvalRequest_id);
                    $('#LBCreationDate').text(objApprovalRecord.creationDate);
                    $('#LBFromDate').text(objApprovalRecord.fromDate);
                    $('#LBToDate').text(objApprovalRecord.toDate);

                    // descrizione stato ed icona    
                    if (objApprovalRecord.approvalStatus == "APPR" | objApprovalRecord.approvalStatus == "NOTF")
                        $('#LBApprovalStatus').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/WF_OK.png' border = 0 > &nbsp;" + objApprovalRecord.approvalStatusDescription);
                    else if (objApprovalRecord.approvalStatus == "REJE")
                        $('#LBApprovalStatus').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/WF_Delete.png' border = 0 > &nbsp;" + objApprovalRecord.approvalStatusDescription);
                    else
                        $('#LBApprovalStatus').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/warning.png' border = 0 > &nbsp;" + objApprovalRecord.approvalStatusDescription);

                    //$('#LBApprovalStatus').text(objApprovalRecord.approvalStatusDescription);
                    $('#LBProjectCode').text(objApprovalRecord.projectCode);
                    $('#LBPersonName').text(objApprovalRecord.personName);

                    if (objApprovalRecord.hours > 0)
                        $('#LBRichiesta').text(objApprovalRecord.hours + "  ore : " + objApprovalRecord.projectName); // singolo giorno
                    else
                        $('#LBRichiesta').text(objApprovalRecord.projectName); // periodo


                    $('#TBComment').val(objApprovalRecord.comment);
                    $('#TBApprovalText1').val(objApprovalRecord.approvalText1);
                }

                // se stato è diverso da REQU disabilità bottoni e form
                if (objApprovalRecord.approvalStatus != 'REQU') {
                    $('#TBApprovalText1').prop("disabled", true); // commento
                    $('#btnApprova').hide();
                    $('#btnRifiuta').hide();
                }
                else {
                    $('#TBApprovalText1').prop("disabled", false); // commento
                    $('#btnApprova').show();
                    $('#btnRifiuta').show();
                }

                openDialogForm("#dialog");
            },

            error: function (xhr, textStatus, errorThrown) {
                return false;
            }

        }); // ajax

    }  // leggi dati da record, chiamata da Tabulator

    function submitAggiornaRecord(UpdateMode) {


        var now = Date.now();

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{ 'ApprovalRequest_id': '" + $('#TBApprovalRequest_id').val() + "', " +
            "'UpdateMode': '" + UpdateMode + "' , " +
            "'ApprovalText1': '" + $('#TBApprovalText1').val() + "' }";

        $.ajax({

            type: "POST",
            url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/UpdateApprovalRecord",
            data: values,
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (msg) {

                // chiude dialogo
                ApprovalListTable.replaceData() // ricarica tabella dopo insert

            },

            error: function (xhr, textStatus, errorThrown) {
                ShowPopup(xhr.responseText);
            }

        }); // ajax
    } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

</script>

</html>
