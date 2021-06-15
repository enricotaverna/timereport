<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LeaveRequestCreate.aspx.cs" Inherits="m_gestione_LeaveRequestCreate" %>

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

<style>
    .inputtext, .ASPInputcontent {
        Width: 170px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Comunicazione Assenza</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="formLeaveRequest" runat="server" >

            <div class="row justify-content-center">

                <div id="FormWrap" class="StandardForm col-6">

                    <div class="formtitle">Comunicazione Assenza</div>

                    <!-- *** DATA INIZIO  ***  -->
                    <div class="input nobottomborder">
                        <asp:Label ID="Label1" CssClass="inputtext" runat="server" Text="Periodo da"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBFromDate" runat="server" MaxLength="10" Rows="8" Width="100px"
                            data-parsley-required="true" data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" Enabled="False" />

                        <asp:Label class="css-label" ID="LBToDate" Style="padding: 0px 20px 0px 20px" runat="server">a</asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBToDate" runat="server" Width="100px" data-parsley-dateinsequenza="true" data-parsley-datanelmese="true"
                            data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/" />
                    </div>

                    <!-- *** ORE ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" data-parsley-validate-if-empty="true" data-parsley-mandatory-if-single-date="true" data-parsley-pattern="^\d+(,\d+)?$|^$" ID="TBOre" runat="server" Columns="10" data-parsley-errors-container="#valMsg" />
                    </div>

                    <!-- *** DDL Progetto ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource1"></asp:Label>
                        <asp:DropDownList ID="DDLProject" runat="server" AppendDataBoundItems="True"
                            data-parsley-errors-container="#valMsg" data-parsley-required="true">
                        </asp:DropDownList>
                    </div>

                    <!-- *** COMMENT ***  -->
                    <div class="input ">
                        <asp:Label CssClass="inputtext" runat="server" Text="Commento"></asp:Label>
                        <asp:TextBox ID="TBComment" runat="server" Rows="3" CssClass="textarea" Style="margin-bottom: 10px; height: 50px" TextMode="MultiLine" Columns="30" />
                    </div>


                    <!-- *** SEZIONE APPROVAZIONE ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" runat="server" Text="Stato"></asp:Label>
                        <asp:Label class="input2col" Style="width: 160px" ID="LBApprovalStatusDesc" runat="server"></asp:Label>
                        <asp:Label ID="LBApprovalStatus" runat="server" Visible="False"></asp:Label>
                        <%-- per memorizzare valore usato da jquery --%>
                        <asp:Label runat="server" ID="LBdate"></asp:Label>
                    </div>

                    <!-- *** Manager ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label2" runat="server" Text="Manager"></asp:Label>
                        <asp:Label ID="LBManager" runat="server" CssClass="inputtext" />
                    </div>

                    <div style="position: absolute">
                        <!-- aggiunto per evitare il troncamento della dropdonwlist -->

                        <!-- *** DDL Notifica ***  -->

                        <span id="HideChange">
                            <!-- *** a seconda della modalità del form viene acceso/spento ***  -->
                            <span class="inputtext nobottomborder" style="margin-top: 0px">Notifica</span>
                            <asp:ListBox ID="LBNotifica" runat="server" AppendDataBoundItems="True" Width="240px" SelectionMode="Multiple"
                                DataValueField="persons_id" multiple="multiple" class="sumoSelectClass" Style="margin-left: -30px; color: #777"></asp:ListBox>
                        </span>

                        <span id="HideCreate">
                            <span class="inputtext nobottomborder" style="margin-top: 0px">Nota manager</span>
                            <asp:TextBox ID="TBApprovalText1" runat="server" Rows="3" CssClass="textarea" Style="margin-bottom: 10px; margin-left: -30px; height: 50px" TextMode="MultiLine" Columns="30" />
                        </span>

                    </div>

                    <br />
                    <br />
                    <br />
                    <br />

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <div id="valMsg" class="parsely-single-error" style="display: inline-block; width: 130px"></div>
                        <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="orangebutton" Text="<%$ appSettings: SAVE_TXT %>" />
                        <asp:Button ID="UpdateCancelButton" runat="server" formnovalidate CssClass="greybutton" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" PostBackUrl="/timereport/input.aspx" />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>

        </form>

    </div>
    <!-- END MainWindow  -->

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

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
    >

    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        var approvalStatus = "";

        // *** PARSLEY VALIDATOR ***

        // controllo sulle date
        window.Parsley.addValidator('dateinsequenza', {
            validate: function (value, requirement) {

                // controllo solo se ToDate è valorizzata
                if ($("#TBFromDate").val().length == 0)
                    return true;

                var dataDaCompare = $("#TBFromDate").val().substring(6, 11) + $("#TBFromDate").val().substring(3, 5) + $("#TBFromDate").val().substring(0, 2);
                var dataACompare = $("#TBToDate").val().substring(6, 11) + $("#TBToDate").val().substring(3, 5) + $("#TBToDate").val().substring(0, 2);

                // controllo sequenza
                if (dataDaCompare > dataACompare)
                    return false;

            },
            messages: {
                en: 'Check dates range.',
                it: 'Data fine deve essere > data inizio'
            }
        });

        // controllo sulle date
        window.Parsley.addValidator('datanelmese', {
            validate: function (value, requirement) {

                // controllo solo se ToDate è valorizzata
                if ($("#TBToDate").val().length == 0)
                    return true;

                var meseToDate = $("#TBToDate").val().substring(3, 5);
                var meseFromDate = $("#TBFromDate").val().substring(3, 5);

                if (meseToDate != meseFromDate)
                    return false;
                else
                    return true;

            },
            messages: {
                en: 'Check dates range.',
                it: 'Data fine deve essere nel mese corrente'
            }
        });

        // campo ore valorizzato solo se campo ToDate è blank
        // ATTENZIONE: Le maiuscole diventano "-" nel controllo
        window.Parsley.addValidator('mandatoryIfSingleDate', {
            validate: function (value, requirement) {
                if ($("#TBOre").val() == 0 & $("#TBToDate").val().length == 0)
                    return false;
                else
                    return true;
            },
            messages: {
                en: 'fiels is mandatory',
                it: 'questo valore è richiesto.'
            }
        });

        // *** JQUERY ***

        $(function () {
            var urlParams = new URLSearchParams(window.location.search);

            // datepicker
            $("#TBFromDate").datepicker($.datepicker.regional['it']);
            $("#TBToDate").datepicker($.datepicker.regional['it']);

            // *** attiva validazione campi form
            $('#formLeaveRequest').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
            });

            // imposta css della listbox
            $('.sumoSelectClass').SumoSelect();

            // valorizza campi
            if (urlParams.get('action') == "new")
                InitNewForm();
            else
                InitChangeForm();
        });

        // *** valorizza lo stato al cambio della DDL //
        $('#DDLProject').change(function () {

            var WorkflowType = $("#DDLProject").find("option:selected").attr("data-WorkflowType");

            // 00 nessun WF 01 Approvazione Mgr 02 Notifica Amministrazione
            if (WorkflowType == "01") {
                $('#LBApprovalStatusDesc').text("Requested");
                approvalStatus = "REQU";
            }
            else {
                $('#LBApprovalStatusDesc').text("Notified");
                approvalStatus = "NOTF";
            }

        });

        // alla modifica del campo ToDate per spegnere il campo ore
        $('#TBToDate').change(function () {
            NascondiSpegniCampoOre();
        });

        $("#InsertButton").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();
            MaskScreen(true); // mette in wait a schermo scuro

            if (!$('#formLeaveRequest').parsley().validate())
                return;

            var d = new Date();
            var requestType = $('#TBToDate').val().length > 0 ? "RG" : "SG"; // richiesta range o singola data

            // costruisce la stringa con le mail per notifica
            var listaNotifica = "";
            $('#LBNotifica :selected').each(function (i, selected) {
                if ($(selected).val().length > 0)
                    listaNotifica = listaNotifica + "," + $(selected).val();
            });
            listaNotifica = listaNotifica.substring(1);

            var oreNonNull = $('#TBOre').val() == '' ? "0" : $('#TBOre').val();

            // aggiunge elemento
            values = ("{ creationDate:'" + d.toLocaleDateString() +
                "', requestType:'" + requestType +
                "', fromDate:'" + $('#TBFromDate').val() +
                "', toDate:'" + $('#TBToDate').val() +
                "', persons_id:'<%=CurrentSession.Persons_id %>" +
                "', projects_id:'" + $('#DDLProject').val() +
                "', hours:'" + oreNonNull +
                "', comment:'" + $('#TBComment').val() +
                "', notifyList:'" + listaNotifica +
                "', approvedBy: '<%= Session["ApprovalManager_id"]%>" +
                "', personName:'<%= CurrentSession.UserName%>" + 
                "', managerName:'<%=Session["ApprovalManagerName"]%>" +
                "', approvalStatusDescription:'" + $('#LBApprovalStatusDesc').text() +
                "', projectName:'" + $('#DDLProject option:selected').text() +
                "', workflowType:'" + $("#DDLProject").find("option:selected").attr("data-WorkflowType") +
                "', approvalStatus:'" + approvalStatus + "'}");

            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/CreateApprovalRequest",
                data: JSON.stringify({ approvalRequest: values }),
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    UnMaskScreen();
                    window.location.href = "/timereport/input.aspx";
                },

                error: function (xhr, textStatus, errorThrown) {
                    UnMaskScreen();
                    alert(xhr.responseText);
                }

            }); // ajax

        });         // crea o aggiorna record selezionato, chiamata da btnSalvaModale

        // ** Inizializza Form ** //
        function InitNewForm() {
            var urlParams = new URLSearchParams(window.location.search);

            $('#TBFromDate').val(urlParams.get('date')); // data richiesta
            $('#LBManager').text('<%=Session["ApprovalManagerName"]%>');
            $('#HideChange').show();
            $('#HideCreate').hide();

        }

        function InitChangeForm() {
            var urlParams = new URLSearchParams(window.location.search);

            leggiRecord(urlParams.get('ApprovalRequest_id'));  // fetch dei valori
            NascondiSpegniCampoOre(); // spegne il campo ToDate o TBOre quando non usati
            disableFields(); // disabilita campi in modifica
            $('#HideChange').hide();
            $('#HideCreate').show();
        }

        // ** Display / Change Form ** //
        function disableFields() {

            // disabilità elementi di input
            $('input').prop("disabled", true);
            $('select').prop("disabled", true);
            $('textarea').prop("disabled", true);

            // riabilita i pulsanti
            $('#UpdateCancelButton').prop("disabled", false);
            $('#InsertButton').hide();
        }

        // se range date valorizzato il campo ore viene nascosto
        function NascondiSpegniCampoOre() {

            if ($('#TBToDate').val().length != 0) { // disabilita il campo ore
                $('#TBOre').hide();
                //$('#TBToDate').show();
                //$('#LBToDate').show();
                $('#TBOre').val(""); // resetta il campo
            }
            else {
                $('#TBOre').show();
                //$('#TBToDate').hide();
                //$('#LBToDate').hide();
                $('#TBOre').val(""); // resetta il campo
            }
        }

        function leggiRecord(PersonsCostRate_id) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ApprovalRequest_id': '" + PersonsCostRate_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/GetApprovalRequest",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objAppr = msg.d;

                    if (objAppr.approvalRequest_id > 0) {
                        $('#TBApprovalRequest_id').val(objAppr.approvalRequest_id);
                        //$('#DDLPersons').val(objAppr.persons_id);
                        $('#DDLProject').val(objAppr.projects_id);
                        $('#TBOre').val(objAppr.hours != 0 ? objAppr.hours : "");
                        $('#TBFromDate').val(objAppr.fromDate);
                        $('#TBToDate').val(objAppr.toDate);
                        $('#TBComment').val(objAppr.comment);
                        $('#TBApprovalText1').val(objAppr.approvalText1);
                        $('#LBManager').text(objAppr.managerName);

                        // descrizione stato ed icona    
                        if (objAppr.approvalStatus == "APPR" | objAppr.approvalStatus == "NOTF")
                            $('#LBApprovalStatusDesc').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/WF_OK.png' border = 0 > &nbsp;" + objAppr.approvalStatusDescription);
                        else if (objAppr.approvalStatus == "REJE")
                            $('#LBApprovalStatusDesc').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/WF_Delete.png' border = 0 > &nbsp;" + objAppr.approvalStatusDescription);
                        else
                            $('#LBApprovalStatusDesc').html("<img style='vertical-align: middle' src ='/timereport/images/icons/16x16/warning.png' border = 0 > &nbsp;" + objAppr.approvalStatusDescription);

                        $('#TBNotifica').val(objAppr.notifyList);

                        if (objAppr.changeDate != "")
                            $('#LBdate').text(objAppr.changeDate);
                        else
                            $('#LBdate').text(objAppr.creationDate);

                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

    </script>

</body>


</html>
