<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HoursList.aspx.cs" Inherits="m_gestione_HoursList" %>

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
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script> <!-- Download excel da Tabulator -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title> <asp:Literal runat="server" Text="Lista Ore" /> </title>
</head>

<body>
    
    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

    <form id="FVForm" runat="server">

    <div class="row justify-content-center"  >
    
    <div class="StandardForm col-9" >
        
        <div id="HoursListTable"></div>
            
    <div class="buttons">               
        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>"  CssClass="orangebutton" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End div-->
        
    </div> <!--End LastRow-->
    
    </form>

    </div> <!-- END MainWindow -->

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

    <div id="mask"></div>  <!-- Mask to cover the whole screen -->
        
</body>

<!-- *** JAVASCRIPT *** -->
<script>

    // include di snippet html per menu
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
    //trigger download of data.xlsx file
    $("#btn_download").click(function(){
        HoursListTable.download("xlsx", "ExportData.xlsx", {sheetName:"Dati"});
    });    

    // ** TABULATOR **

    //var editIcon = function (cell, formatterParams, onRendered) { //plain text value
    //    return "<i class='fa fa-edit'></i>";
    //};  // icona edit

    var HoursListTable = new Tabulator("#HoursListTable", {
    //initialHeaderFilter: [{ field: "ApprovalStatus", value: 'REQU' } ], //valore iniziare dello stato per filtrare
    paginationSize: 18, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/WF_ApprovalWorkflow.asmx/GetHoursListTable", //ajax URL
    ajaxParams: { persons_id: <%= CurrentSession.Persons_id  %> , tipoOre :  <%= Request["tipoOre"]  %>, giorniInAvanti : 30 }, //ajax parameters
    ajaxConfig: "POST", //ajax HTTP request type
    ajaxContentType:"json", // send parameters to the server as a JSON encoded string
    layout: "fitColumns", //fit columns to width of table (optional)
    ajaxResponse:function(url, params, response){
        //url - the URL of the request
        //params - the parameters passed with the request
        //response - the JSON object returned in the body of the response.
        return JSON.parse(response.d); //return the d property of a response json object
    },
    columns: [
        { title: "Hours_id", field: "Hours_id", sorter: "number", visible: false },
        { title: "Consulente", field: "PersonName", sorter: "string", headerFilter: true },
        { title: "Manager", field: "ManagerName", sorter: "string", headerFilter: true },
        { title: "Data", field: "Date", sorter: "string", width: 100, headerFilter: true },
        { title: "Codice", field: "Codice", sorter: "string", headerFilter: true },
        { title: "Descrizione", field: "Descrizione", sorter: "string", headerFilter: true },
        { title: "Ore", field: "Hours", sorter: "number", visible: true },
        ],
    }); // Tabella principale

    // ** FUNZIONI **

</script>

</html>
