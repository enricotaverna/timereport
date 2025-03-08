<%@ Page Language="C#" AutoEventWireup="true"ValidateRequest ="false" CodeFile="TrainingPlan_view.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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
<script type="text/javascript" src="https://oss.sheetjs.com/sheetjs/xlsx.full.min.js"></script> <!-- Download excel da Tabulator -->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title> <asp:Literal runat="server" Text="Piano Training" /> </title>
</head>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">

    <form id="FVForm" runat="server">

    <div class="row justify-content-center"  >
    
    <div class="StandardForm col-11" >

    <div id="TableTrainingPlan"></div>

    <div class="buttons">               
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

</body>

    <!-- *** JAVASCRIPT *** -->
    <script>

    // include di snippet html per menu
    includeHTML();
    InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    // ** EVENTI TRIGGER **


    // ** TABULATOR **

    var TableTrainingPlan = new Tabulator("#TableTrainingPlan", {
    paginationSize: 14, // this option can take any positive integer value (default = 10)
    pagination: "local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/HR_Training.asmx/GetTrainingPlan", //ajax URL
    ajaxParams: { Persons_id: <%= CurrentSession.Persons_id  %> , Anno: "0", Mode: "VIEW" }, //ajax parameters
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
        { title: "CoursePlan_id", field: "CoursePlan_id", sorter: "number", visible: false },
        { title: "Anno", field: "Anno", sorter:"string", headerFilter:"input"},
        { title: "Codice Corso", field: "CourseCode", sorter:"string", headerFilter:"input"},
        { title: "Corso", field:"CourseName", sorter:"string", headerFilter:"input" },
        { title: "Tipo", field: "CourseTypeName", sorter:"string", headerFilter:true },
        { title: "Prodotto", field: "ProductName", sorter: "string", headerFilter:true },
        {
            title: "Stato", field: "CourseStatusName", sorter: "string", headerFilter: "select",
            headerFilterParams: { values: { "PROPOSED": "PROPOSED", "PLANNED": "PLANNED", "SCHEDULED": "SCHEDULED" , "ATTENDED": "ATTENDED" , "CANCELED": "CANCELED", "": "All Status" } } 
        },
        { title: "Data Corso", field: "CourseDate", sorter: "date", headerFilter: true, validator: "regex:^[0-9]{2}\/[0-9]{2}\/[0-9]{4}" },
        { title: "Valutazione", field: "Score",  formatter:"star", editor:false  },
    ],
    });

    // ** FUNZIONI **
    
    </script>


</html>
