<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ProjectRevenueData.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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
        <asp:Literal runat="server" Text="Dati Progetto" /></title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

        <form id="FVForm" runat="server">

            <!--**** Riquadro navigazione ***-->
            <div class="form-group row justify-content-center">
                <div class="col-9 RoundedBox">

                    <div class="row">
                        <div class="col-1">
                            <label class="inputtext">Progetto</label>
                        </div>
                        <div class="col-4">
                            <asp:DropDownList ID="DDLAttivo" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                                DataTextField="AnnoMeseDesc" DataValueField="AnnoMese" Style="width: 150px"
                                CssClass="ASPInputcontent">
                                <asp:ListItem Text="Attivi" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Non Attivi" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Tutti" Value="0"></asp:ListItem>
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
                <div class="col-9 px-0">

                    <div id="TableDatiProgetto"></div>

                    <div class="buttons">
                        <asp:Button ID="btn_refresh" runat="server" Text="<%$ appSettings: REFRESH_TXT %>" CssClass="orangebutton" />
                        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
                    </div>
                    <!--End buttons-->

                </div>
                <!--End div-->
            </div>
            <!--End LastRow-->

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

        $(".greybutton").click(function (e) {
            //Cancel the link behavior
            //e.preventDefault();
            //$('#FVForm').parsley().reset();

            //UnMaskScreen();
            //$('.window').hide();
        }); // bottone chiude su form modale

        // ** TABULATOR **
        var editIcon = function (cell, formatterParams, onRendered) { //plain text value
            var value = cell.getRow().getData().Comment;

            // se tipo record A nono si può cancellare
            //if (cell.getRow().getData().TipoRecord == "A")

            if (value == null || value == "")
                return "<i class='fa fa-edit'></i>";
            else
                return "<i class='fa fa-comment'></i>";
        };  // icona edit

        var moneyEditor = function (cell, onRendered, success, cancel, editorParams) {
            //cell - the cell component for the editable cell
            //onRendered - function to call when the editor has been rendered
            //success - function to call to pass the successfuly updated value to Tabulator
            //cancel - function to call to abort the edit and return to a normal cell
            //editorParams - params object passed into the editorParams column definition property

            //create and style editor
            var editor = document.createElement("input");

            //editor.setAttribute("type", "date");

            //create and style input
            editor.style.padding = "3px";
            editor.style.width = "100%";
            editor.style.boxSizing = "border-box";

            //Set value of editor to the current value of the cell
            if (cell.getValue() != null)
                editor.value = cell.getValue().toLocaleString().replace(".", "");
            else
                editor.value = "0";

            //set focus on the select box when the editor is selected (timeout allows for editor to be added to DOM)
            onRendered(function () {
                editor.focus();
                editor.style.css = "100%";
            });

            //when the value has been set, trigger the cell to update
            function successFunc() {
                success(editor.value.replace(",", "."));
            }

            editor.addEventListener("change", successFunc);
            editor.addEventListener("blur", successFunc);

            //return the editor element
            return editor;
        };

        var TableDatiProgetto = new Tabulator("#TableDatiProgetto", {
            cellEdited: function (cell) {
                //cell - cell component
                var Projects_id = cell.getRow().getCells()[2].getValue(); // indice record da aggiornare

                // chiamata di aggiornamento
                var values = "{'Projects_id': '" + Projects_id + "' , " +
                    " 'FieldToUpdate': '" + cell.getField() + "' , " +
                    " 'Value': '" + cell.getValue() + "' " +
                    "  } ";
                $.ajax({

                    type: "POST",
                    url: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateProjectData",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d != true) {
                            ShowPopup("Errore in aggiornamento, riprovare");
                        }
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        return false;
                    }
                }); // ajax        
            },
            paginationSize: 14, // this option can take any positive integer value (default = 10)
            pagination: "local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            layout: "fitColumns", //fit columns to width of table (optional)
            ajaxURL: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/GetProjectData", //ajax URL
            ajaxParams: { StatoAttivo: $("#DDLAttivo").val() }, //ajax parameters
            ajaxConfig: "POST", //ajax HTTP request type
            ajaxContentType: "json", // send parameters to the server as a JSON encoded string
            ajaxResponse: function (url, params, response) {
                //url - the URL of the request
                //params - the parameters passed with the request
                //response - the JSON object returned in the body of the response.
                return JSON.parse(response.d); //return the d property of a response json object
            },
            columns: [
                { title: "Codice Progetto", field: "ProjectCode", sorter: "string", headerFilter: "input", frozen: true, validator: "required" },
                { title: "Progetto", field: "Name", sorter: "string", headerFilter: "input" },

                { title: "Projects_id", field: "Projects_id", sorter: "string", visible: false, headerFilter: "input" },
                { title: "TipoContratto_id", field: "TipoContratto_id", sorter: "string", visible: false, headerFilter: "input" },

                // { title: "Tipo", field: "TipoContrattoDesc" },
                {
                    title: "Tipo", field: "TipoContrattoDesc", sorter: "string", headerFilter: "select",
                    editor: "select", editorParams: { values: { "T&M": "T&M", "Forfait": "Forfait" } }
                },
                { title: "Revenue Proposta", field: "RevenueBudget", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },
                { title: "Margine Proposta", field: "MargineProposta", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^[0-9]{0,2}\.?[0-9]{0,2}$" },
                { title: "Data Fine", field: "DataFine", sorter: "date", editor: "input", validator: "regex:^[0-9]{2}\/[0-9]{2}\/[0-9]{4}" },

            ],
        });

    </script>

</body>

</html>
