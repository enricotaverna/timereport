<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProjectLocation.aspx.cs" Inherits="m_gestione_Location_ProjectLocation" %>

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
<!--SUMO select-->
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<!--SUMO select-->
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script>
<!-- Download excel da Tabulator -->
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Gestione Location</title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVForm" runat="server">

            <div class="row justify-content-center">

                <div class="StandardForm col-9">

                    <div id="TabulatorTable"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate="true" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
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

                        <div class="formtitle">Scheda Location</div>

                        <div class="input nobottomborder">
                            <!-- ** PROGETTO ** -->
                            <div class="inputtext">
                                <asp:Literal runat="server" Text="Progetto" />
                            </div>
                            <label style="width: 280px; position: absolute">
                                <asp:ListBox ID="DDLProgetto" class="SumoSelectDDL" data-parsley-validate-mandatory="true" DataSourceID="DSProgetto" data-parsley-errors-container="#valMsg" runat="server" DataTextField="ProjectName" DataValueField="Projects_id" AppendDataBoundItems="True">
                                    <asp:ListItem Text="-- selezionare un valore --" Value=""></asp:ListItem>
                                </asp:ListBox>
                            </label>
                        </div>

                        <div class="input nobottomborder">
                            <!-- ** LOCATION ** -->
                            <div class="inputtext">Location</div>
                            <asp:TextBox class="ASPInputcontent" Style="width: 270px" runat="server" ID="TBLocation" data-parsley-errors-container="#valMsg" data-parsley-required="true" MaxLength="100" />
                        </div>

                        <asp:TextBox runat="server" ID="TBProjectLocation_id" Style="visibility: hidden" />


                        <div class="buttons">
                            <div id="valMsg" class="parsley-single-error"></div>
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
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <div id="mask"></div>
    <!-- Mask to cover the whole screen -->

    <!-- *** DATASOURCE *** -->
    <asp:SqlDataSource runat="server" ID="DSProgetto"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="**"></asp:SqlDataSource>

    <!-- *** JAVASCRIPT *** -->
    <script>

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

        // ***  PAGE LOAD ***
        $(function () {

            // *** attiva validazione campi form
            $('#FVForm').parsley({
            });

            // imposta css della listbox
            $('.SumoSelectDDL').SumoSelect({
                search: true,
            });

        });

        // ** INTERFACCIA **


        // ** EVENTI TRIGGER **

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

            //$('#FVForm').parsley().validate();

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

        var TabulatorTable = new Tabulator("#TabulatorTable", {
            paginationSize: 15, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            ajaxURL: "/timereport/webservices/WS_Location.asmx/GetProjectLocation", //ajax URL
            ajaxParams: { onlyActiveProjects: true }, //ajax parameters
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
                { title: "ProjectLocationId", field: "ProejctLocation_id", sorter: "number", visible: false },
                { title: "Progetto", field: "ProjectCode", sorter: "alphanum", headerFilter: "input" },
                { title: "Descrizione", field: "ProjectName", sorter: "alphanum", headerFilter: "input" },
                { title: "Tipo", field: "ProjectTypeName", sorter: "alphanum", headerFilter: "input" },
                { title: "Location", field: "LocationDescription", sorter: "alphanum", headerFilter: "input" },

                { formatter: trashIcon, width: 40, align: "center", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
                { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
            ],
        }); // Tabella principale

        // ** FUNZIONI **

        function initValue() {

            $('#TBProjectLocation_id').val('');
            $('#DDLProgetto').val('');
            $('#TBLocation').val('');

            $('#DDLProgetto')[0].sumo.reload(); // refresh controllo dopo aver settato il nuovo valore

        } // inizilizza form in creazione

        function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ProjectLocation_id': '" + dati.ProjectLocation_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_Location.asmx/GetProjectRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objCourse = msg.d;

                    if (objCourse.ProjectLocation_id > 0)
                        $('#TBProjectLocation_id').val(objCourse.ProjectLocation_id);
                    $('#TBLocation').val(objCourse.LocationDescription);

                    $('#DDLProgetto').val(objCourse.Projects_id);
                    $('#DDLProgetto')[0].sumo.reload(); // refresh controllo dopo aver settato il nuovo valore

                    openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }
            }); // ajax

        }  // leggi dati da record, chiamata da Tabulator

        function T_cancellaRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ProjectLocation_id': '" + dati.ProjectLocation_id + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_Location.asmx/DeleteProjectRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d == true) {
                        riga.delete();
                    } else
                        ShowPopup("Impossibile cancellare location già utilizzata");

                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

        } // cancella record, chiamata da Tabulator

        function submitCreaAggiornaRecord() {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{ 'ProjectLocation_id': '" + $('#TBProjectLocation_id').val() + "', " +
                "'Projects_id': '" + $('#DDLProgetto').val() + "' , " +
                "'LocationDescription': '" + $('#TBLocation').val() + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_Location.asmx/CreateUpdateProjectRecord",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    TabulatorTable.replaceData() // ricarica tabella dopo insert

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }

            }); // ajax
        } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    </script>

</body>

</html>
