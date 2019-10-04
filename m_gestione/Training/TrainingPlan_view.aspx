<%@ Page Language="C#" AutoEventWireup="true"ValidateRequest ="false" CodeFile="TrainingPlan_view.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

<!DOCTYPE html>

<!-- Stili -->
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css" rel="stylesheet" /> 
<link href="/timereport/include/standard/uploader/uploader.css" rel="stylesheet"  />

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script> 
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >


<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Lista progetti</title>
</head>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <form id="FVForm" runat="server">

    <div id="PanelWrap"  > 
      
    </div> <!--End PanelWrap-->

    <div id="PanelWrap"   >  

    <div id="TableCourses"></div>

    <br />
    
    <div id="TableTrainingPlan"></div>

    <div class="buttons">               
        <%--<asp:Button ID="btn_print" runat="server" Text="<%$ appSettings: PRINT_TXT %>"  CssClass="orangebutton"  />--%>
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
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

</body>


    <script>
    // ** EVENTI TRIGGER **


    // ** TABULATOR **

    var TableTrainingPlan = new Tabulator("#TableTrainingPlan", {
    paginationSize: 14, // this option can take any positive integer value (default = 10)
    pagination: "local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/WSHR_Training.asmx/GetTrainingPlan", //ajax URL
    ajaxParams: { Persons_id: <%= Session["persons_id"]  %> , Anno: "0", Mode: "VIEW" }, //ajax parameters
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
