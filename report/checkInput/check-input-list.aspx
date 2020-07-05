<%@ Page Language="C#" AutoEventWireup="true" CodeFile="check-input-list.aspx.cs" Inherits="m_report_checkinputlist" %>

<!DOCTYPE html>

<!-- Stili -->
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css" rel="stylesheet" /> 
<link href="/timereport/include/standard/uploader/uploader.css" rel="stylesheet"  />
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script> 
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script> <!-- Download excel da Tabulator -->

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Richieste approvazione</title>
</head>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow" >
  
    <form id="FVForm" runat="server"  >
    
    <div id="PanelWrap" style="width:720px" > 

    <div class="StandardForm">        
        <div id="ListTable"></div>
    </div>  
            
    <div class="buttons">               
        <asp:Button ID="btn_download" runat="server" Text="<%$ appSettings: EXPORT_TXT %>"  CssClass="orangebutton" />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/report/checkInput/check-input-select.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->
    
    </form>

    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div>    

    <div id="mask"></div>  <!-- Mask to cover the whole screen -->
        
</body>

<script>

    // ** VALIDAZIONI **
    var btnRifiutatoClick = false;

   // *** attiva validazione campi form
    $('#formPersone').parsley({
        excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
    });

    // ***  Controllo che esista un commento se il progetto lo richiede ***
    //window.Parsley.addValidator('testoObbligatorio', {
    //        validateString: function (value) {

    //            if (btnRifiutatoClick & $("#TBApprovalText1").val().length == 0)
    //                return $.Deferred().reject("inserire un commento");
    //            else
    //                return true;
    //        }
    //});

    // ** INTERFACCIA **

    // ** EVENTI TRIGGER **
    //trigger download of data.xlsx file
    $("#btn_download").click(function(){
        ListTable.download("xlsx", "ExportData.xlsx", {sheetName:"Dati"});
    });    

    // ** TABULATOR **

    var editIcon = function (cell, formatterParams, onRendered) { //plain text value
        var data = cell.getRow().getData();

        if (data.StatoTR != 'chiuso')
            return "<i class='fa fa-address-card'></i>";
        else
            return "";

    };  // icona edit

    var ListTable = new Tabulator("#ListTable", {
    //initialHeaderFilter: [{ field: "ApprovalStatus", value: 'REQU' } ], //valore iniziare dello stato per filtrare
    paginationSize: 16, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/RP_Chiusure.asmx/GetListaChiusure", //ajax URL
    ajaxParams: { meseLista: <%= Request.QueryString["mese"].ToString()  %> , annoLista :  <%= Request.QueryString["anno"].ToString()  %>}, //ajax parameters
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
        { title: "Persons_Id", field: "Persons_Id", sorter: "number", visible: false },
        { title: "Consulente", field: "Name", width: 150, sorter: "string", headerFilter: true },
        { title: "Società", field: "CompanyName", width: 150, sorter: "string", headerFilter: true },
        { title: "Manager", field: "Manager", width: 150, sorter: "string", headerFilter: true },
        { title: "Ore Contratto", field: "OreContratto", sorter: "number", headerFilter: true },
        { title: "GG Mancanti", field: "GGmancanti", sorter: "number", headerFilter: true },
        { title: "Mese Precedente", field: "GGMesePrecedente", sorter: "number", headerFilter: true },
        { title: "Chiuso", field: "TRChiuso", formatter: "tickCross", sorter: "string", headerFilter: "select",
          headerFilterParams: { values: { "true": "true", "false": "false", "": "All" } }
        },
        { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { OpenUrl(cell.getRow().getData()) } },
        ],
    }); // Tabella principale

    // ** FUNZIONI **
    function OpenUrl(dati)
    {

        if (dati.StatoTR == 'chiuso')
            return;

        var url = dati.urlDetailPage;
        window.open(url,'_blank');
        return;
    }


</script>

</html>
