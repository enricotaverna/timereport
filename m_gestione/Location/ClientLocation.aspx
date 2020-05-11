<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ClientLocation.aspx.cs" Inherits="m_gestione_Location_ClientLocation" %>

<!DOCTYPE html>

<!-- Stili -->
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="../../include/jquery/sumoselect/sumoselect.css" rel="stylesheet" />
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
<script src="../../include/jquery/sumoselect/jquery.sumoselect.js"></script>

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >


<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Gestione Location</title>
</head>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow" >
  
    <form id="FVForm" runat="server" >
    
    <div id="PanelWrap"  > 

    <div id="FormWrap1" class="StandardForm">        
        <div id="TabulatorTable"></div>
    </div>  
            

    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton"  />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" formnovalidate="true" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->
    
    <div id="ModalWindow" > <!--  Finestra Dialogo -->

        <div id="dialog" class="window">

            <div id="FormWrap" class="StandardForm">

            <div class="formtitle">Scheda Location</div>

			<div class="input nobottomborder"> <!-- ** CLIENTE ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Cliente" /></div>
				<label style="width:280px;position:absolute">
                     <asp:ListBox ID="DDLCliente" class="SumoSelectDDL" data-parsley-required="true" runat="server" DataSourceID="DSCliente" DataTextField="NomeCliente"  DataValueField="CodiceCliente" 
                          data-parsley-errors-container="#valMsg" AppendDataBoundItems="True" >
                         <asp:ListItem Text = "-- selezionare un valore --" Value="" ></asp:ListItem>  
       			</asp:ListBox>
				</label>
			</div>

            <div class="input nobottomborder"> <!-- ** LOCATION ** -->
                <div class="inputtext">Location</div>
                <asp:TextBox class="ASPInputcontent" style="width:270px" runat="server" id="TBLocation" data-parsley-errors-container="#valMsg" data-parsley-required="true" MaxLength="100" />
            </div>
 
            <asp:TextBox runat="server" id="TBClientLocation_id" style="visibility:hidden"/>


            <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
           </div>

           </div>

       </div>  <%--DIALOG--%>

    </div> <!--  Finestra Dialogo -->

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

    var trashIcon = function(cell, formatterParams, onRendered){ //plain text value
    return "<i class='fa fa-trash'></i>";
    };  // icona cancella
    var editIcon = function (cell, formatterParams, onRendered) { //plain text value
        return "<i class='fa fa-edit'></i>";
    };  // icona edit

    var TabulatorTable = new Tabulator("#TabulatorTable", {
    initialHeaderFilter: [{ field: "Active", value: "true" } //valore iniziare dello stato per filtrare
    ],
    paginationSize: 18, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/WS_Location.asmx/GetClientLocation", //ajax URL
    //ajaxParams: { onlyActiveProjects: true }, //ajax parameters
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
        { title: "LocationId", field:"ClientLocation_id", sorter:"number", visible:false},
        { title: "Codice Cliente", field: "CodiceCliente", width: 150, sorter: "alphanum", headerFilter: "input" },
        { title: "Nome", field: "NomeCliente", sorter: "alphanum", headerFilter: "input" },
        { title: "Location", field: "LocationDescription", sorter: "alphanum", headerFilter: "input" },

        { formatter: trashIcon, width: 40, align: "center", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
        { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
        ],
    }); // Tabella principale

    // ** FUNZIONI **

    function initValue() {

        $('#TBClientLocation_id').val('');
        $('#DDLCliente').val('');
        $('#TBLocation').val('');

        $('#DDLCliente')[0].sumo.reload(); // refresh controllo dopo aver settato il nuovo valore

    } // inizilizza form in creazione

    function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'ClientLocation_id': '" + dati.ClientLocation_id  + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/WS_Location.asmx/GetClientRecord",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objCourse = msg.d;

                    if (objCourse.ClientLocation_id > 0) 
                        $('#TBClientLocation_id').val(objCourse.ClientLocation_id);
                        $('#TBLocation').val(objCourse.LocationDescription);

                        $('#DDLCliente').val(objCourse.CodiceCliente);
                        $('#DDLCliente')[0].sumo.reload(); // refresh controllo dopo aver settato il nuovo valore

                         openDialogForm("#dialog");
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }
            }); // ajax

    }  // leggi dati da record, chiamata da Tabulator

    function T_cancellaRecord(dati, riga) {

                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'ClientLocation_id': '" + dati.ClientLocation_id  + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/WS_Location.asmx/DeleteClientRecord",
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
        var values = "{ 'ClientLocation_id': '" + $('#TBClientLocation_id').val() + "', " +
                     "'CodiceCliente': '" + $('#DDLCliente').val() + "' , " +
                     "'LocationDescription': '" + $('#TBLocation').val() +  "'   } ";

        $.ajax({

            type: "POST",
            url: "/timereport/webservices/WS_Location.asmx/CreateUpdateClientRecord",
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

<asp:sqldatasource runat="server" ID="DSCLiente"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT CodiceCliente, Nome1 as NomeCliente FROM [Customers] ORDER BY CodiceCliente"></asp:sqldatasource>


</html>
