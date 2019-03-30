<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SpeseImport_list.aspx.cs" trace="false" Inherits="SFimport_select" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<!-- Style -->
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
<link href="/timereport/include/jquery/fileupload/jquery-filestyle.css" rel="stylesheet" />
    
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 
<script src="/timereport/include/jquery/fileupload/jquery-filestyle.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script> 

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >


<head id="Head1" runat="server">
    <title>Import Sales Force</title>
</head>

<body>    

    <div id="TopStripe"></div> 

    <div id="MainWindow">
 
    <form id="FVForm" runat="server"  >     
      
    <div id="PanelWrap"  > 

    <!--  *** VERSIONE *** -->            
    <asp:Table  ID="TBImport" runat="server" >
    <asp:TableHeaderRow ID="TableHeaderRow1" runat="server" >
            <asp:TableHeaderCell>C</asp:TableHeaderCell>

            <asp:TableHeaderCell>ProcessingStatus</asp:TableHeaderCell>

            <asp:TableHeaderCell>ProjectCode</asp:TableHeaderCell>
            <asp:TableHeaderCell>ProjectName</asp:TableHeaderCell>
            <asp:TableHeaderCell>ProjectsId</asp:TableHeaderCell>


            <asp:TableHeaderCell>AnnoMese</asp:TableHeaderCell>
            <asp:TableHeaderCell>RevenueVersionCode</asp:TableHeaderCell>
 
            <asp:TableHeaderCell>RevenueSpese</asp:TableHeaderCell>

            <asp:TableHeaderCell>ProcessingMessage</asp:TableHeaderCell>

    </asp:TableHeaderRow>
 
    </asp:Table>
                           
    <div class="buttons">  
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="BtExec" runat="server" Text="<%$ appSettings: EDIT_TXT %>" CssClass="orangebutton"  CommandName="Exec"  />    
            <asp:Button ID="CancelButton" runat="server" CausesValidation="False" CssClass="greybutton" OnClientClick="JavaScript:window.location.href='/timereport/report/EstraiRevenue/SpeseImport_select.aspx';return false;" CommandName="Cancel" Text="<%$ appSettings: BACK_TXT %>"    />                    
     </div>

    </div> <!--End PanelWrap-->   

    </form> 
    
    </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
   <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.ToString("yyyy") %></div>       
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
    </div> 

    <script type="text/javascript">

        $(function () {
           // reset cursore e finestra modale
            UnMaskScreen();
        });

        // Aggiorna
        $("#BtExec").click(function (e) {

            //Cancel the link behavior
            e.preventDefault();

            var selectedData = SFImportTable.getData(); // array con le rige selezionate
            var dataToPost = [];

            for (i = 0; i < selectedData.length; i++) {

                if ( selectedData[i].projectsid != '' )
                    dataToPost.push("{ ProjectsId:'" + selectedData[i].projectsid + "', AnnoMese:'" + selectedData[i].annomese +
                        "', RevenueVersionCode:'" + selectedData[i].revenueversioncode +
                        "', ProjectCode:'" + selectedData[i].projectcode +
                        "', ProjectName:'" + selectedData[i].projectname +
                        "',  RevenueSpese:'" + selectedData[i].revenuespese + "'}");
            }

            $.ajax({

                    type: "POST",
                    url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateRevenueProgetti",
                    data: JSON.stringify({ arr: dataToPost }), 
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true) 
                            ShowPopup("Aggiornato completato");
                        else
                            ShowPopup("Errore in aggiornamento");

                    },

                    error: function (xhr, textStatus, errorThrown) {
                        ShowPopup("Errore in aggiornamento");
                        return false;
                    }

                }); // ajax


        });  // tasto crea record

        var SFImportTable = new Tabulator("#TBImport", {
            paginationSize: 18, // this option can take any positive integer value (default = 10)
            pagination:"local", //enable local pagination.
            headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
            layout: "fitColumns",
            columns: [
                { title: "C", formatter: "tickCross", formatterParams: { allowEmpty: true }, width: 30 }, // , responsive: 1, cellClick: function (e, cell) { var a = cell.getValue(); if (a == "") cell.setValue("1"); else if(a == "1") cell.setValue("")} },
                { title: "ProcessingStatus", sorter: "string", headerFilter: "input", formatterParams: {allowTruthy:true},  width:40 },
                { title: "ProjectCode", sorter: "string", headerFilter: "input", width: 100 },                
                { title: "ProjectName", sorter: "string", headerFilter: "input"   },
                { title: "ProjectsId", visible:false },

                { title: "AnnoMese", sorter: "string", headerFilter: "input", width: 100, align:"center", },                
                { title: "RevenueVersionCode", visible:false },

                { title: "RevenueSpese", sorter: "string", align:"right",  width: 80 },
                { title: "ProcessingMessage", sorter: "string", headerFilter: "input" },
                ],
                }); // Tabella principale

</script>

</body>
</html>

