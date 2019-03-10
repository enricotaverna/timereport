<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TrainingPlan_create.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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

    <!--**** Primo Box ***-->    
    <div class="RoundedBox" >

    <table width="760" border="0" class="GridTab">
        <tr>

        <td>Consulente:</td>
        <td>
                <label class="dropdown">
                <asp:DropDownList ID="DDLConsulente" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataSourceID="DSConsulente" DataTextField="Name" DataValueField="Persons_id"
                    CssClass="TabellaLista"  >
<%--                    <asp:ListItem Text="-- seleziona un valore --" Value="0"   />--%>
                </asp:DropDownList>
                </label>
        </td>
        
        <td>Anno:</td>
        <td>
                <label class="dropdown" >
                <asp:DropDownList ID="DDLAnno" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataTextField="AnnoDesc" DataValueField="Anno" style="width:150px"
                    CssClass="TabellaLista"  >
                </asp:DropDownList>
                </label>
        </td>

        </tr>
        
    </table>

    </div> <!--End roundedBox-->          
    </div> <!--End PanelWrap-->


    <div id="PanelWrap"   >  

    <div id="TableCourses"></div>

    <br />
    
    <div id="TableTrainingPlan"></div>

    <div class="buttons">               
<%--     <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton" PostBackUrl="/timereport/m_gestione/Project/Projects_lookup_form.aspx" />--%>
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton"  />
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

<!--Seleziona manager -->
<asp:SqlDataSource ID="DSConsulente" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
       SelectCommand="SELECT DISTINCT Persons.Persons_id, Persons.Name FROM Persons WHERE Persons.Active = 'true' and company_id = 1 ORDER BY Persons.Name">
        <SelectParameters>
            <asp:Parameter DefaultValue="true" Name="Active" Type="Boolean" />
        </SelectParameters>
</asp:SqlDataSource>


<script>

    // ** INTERFACCIA **


    // ** EVENTI TRIGGER **
    $("#btn_back").click(function (e) {

        
        if (e.originalEvent.detail == 0)
            e.preventDefault(); //Cancel the link behavior
        else {
            window.location.href = "/timereport/menu.aspx";
            return false;     
        }

    });   

    // ** TABULATOR **

    var RiceviRiga = function(fromRow, toRow, fromTable){
    //fromRow - the row component from the sending table
    //toRow - the row component from the receiving table (if available)
    //fromTable - the Tabulator object for the sending table

    var content = fromRow.getData();

    // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
    var values = "{'sAnno': '" + $('#DDLAnno').val() + "' , " +
                    " 'sPersons_id': '" + $('#DDLConsulente').val() + "' , " +
                    " 'sCourse_id': '" + content.Course_id  + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WSHR_Training.asmx/CreaTrainingPlanRecord",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d > 0) {
                            content.Anno = $("#DDLAnno").val();
                            content.CoursePlan_id = msg.d;
                            content.Score = 0;
                            content.CourseStatusName = "PROPOSED";
                            TableTrainingPlan.addData(content, true);
                            return true;
                        }
                    },

                    error: function (xhr, textStatus, errorThrown) {
                        return false;
                    }

                }); // ajax
      
    }

    var TableCourses = new Tabulator("#TableCourses", {
    movableRows: true, //enable movable rows
    movableRowsConnectedTables: "#TableTrainingPlan", //connect to this table
    paginationSize: 6, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/WSHR_Training.asmx/GetCourseCatalog", //ajax URL
    ajaxParams: { bActive: true, sAnno: "" }, //ajax parameters
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
        { title: "CourseID", field:"Course_id", sorter:"number", visible:false},
        { title: "Codice Corso", field: "CourseCode", sorter:"string", headerFilter:"input"},
        { title: "Corso", field:"CourseName", sorter:"string", headerFilter:"input" },
        { title: "Tipo", field: "CourseTypeName", sorter:"string", headerFilter:true },
        { title: "Prodotto", field: "ProductName", sorter: "string", headerFilter:true },
        { title: "Area", field: "Area", sorter: "string", headerFilter:true },
        { title: "Fornitore", field: "VendorName", sorter: "string", headerFilter:true },
        { title: "Durata GG", field: "DurationDays", sorter:"number", headerFilter:true},
        ],
    });

    var TableTrainingPlan = new Tabulator("#TableTrainingPlan", {
    movableRowsReceiver: RiceviRiga,
    paginationSize: 4, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/WSHR_Training.asmx/GetTrainingPlan", //ajax URL
    ajaxParams: { Persons_id: $("#DDLConsulente").val() , Anno: "", Mode: "CREATE" }, //ajax parameters
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
        { title: "Anno", field: "Anno", sorter:"number", headerFilter:"input"},
        { title: "Codice Corso", field: "CourseCode", sorter:"string", headerFilter:"input"},
        { title: "Corso", field:"CourseName", sorter:"string", headerFilter:"input" },
        { title: "Tipo", field: "CourseTypeName", sorter:"string", headerFilter:true },
        { title: "Prodotto", field: "ProductName", sorter: "string", headerFilter:true },
        { title: "Area", field: "Area", sorter: "string", headerFilter:true },
        { title: "Stato", field: "CourseStatusName", sorter: "string", headerFilter:true },
        { title: "Data Corso", field: "CourseDate", sorter: "date", headerFilter: true },
        { title: "Score", field: "Score", sorter: "date", formatter: "star" },
        {formatter:trashIcon, width:40, align:"center", cellClick:function(e, cell){cancellaRecord(cell.getRow().getData(), cell.getRow())}},
        ],
    });

    function cancellaRecord(dati, riga) {

        if (dati.CourseStatusName == "PROPOSED") {

                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'sCoursePlan_id': '" + dati.CoursePlan_id  + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WSHR_Training.asmx/CancellaTrainingPlanRecord",
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

</script>


</html>
