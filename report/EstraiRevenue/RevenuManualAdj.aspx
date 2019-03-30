<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RevenuManualAdj.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

<!DOCTYPE html>

<!-- Stili -->
<link href="/timereport/include/tabulator/dist/css/tabulator.min.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css" rel="stylesheet" /> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script> 
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- Tabulator  -->
<script type="text/javascript" src="/timereport/include/tabulator/dist/js/tabulator.min.js"></script>
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" >


<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Registrazioni manuali</title>
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
      
        <td>Periodo:</td>
        <td>
                <label class="dropdown" >
                <asp:DropDownList ID="DDLAnnoMese" runat="server" AutoPostBack="True" AppendDataBoundItems="True"
                    DataTextField="AnnoMeseDesc" DataValueField="AnnoMese" style="width:150px"
                    CssClass="TabellaLista"  >
                </asp:DropDownList>
                </label>
        </td>

        <td>Versione:</td>
        <td>
                <label class="dropdown" >
                <asp:DropDownList ID="DDLRevenueVersion" runat="server" AutoPostBack="True" 
                    DataSourceID="DSRevenueVersion" DataTextField="RevenueVersionDescription"  DataValueField="RevenueVersionCode" style="width:150px"
                    CssClass="TabellaLista"  >
                </asp:DropDownList>
                </label>
        </td>

        </tr>
        
    </table>

    </div> <!--End roundedBox-->
        
    </div> <!--End PanelWrap-->

    <div id="PanelWrap"   >  

    <div id="TableRevenueMese"></div>

    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton"  />
        <asp:Button ID="btn_refresh" runat="server" Text="<%$ appSettings: REFRESH_TXT %>"  CssClass="orangebutton"  />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton"  OnClientClick="JavaScript:window.location.href='/timereport/menu.aspx';return false;" CausesValidation="False" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->

  <div id="ModalWindow"> <!--  Finestra Dialogo -->

        <div id="dialog" class="window">

            <div id="FormWrap" class="StandardForm">

            <div class="formtitle">Aggiungi Record</div>

            <!-- ** INPUT ELEMENT ** --> 
			<div class="input nobottomborder"> <!-- ** PERSONA ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Persona" /></div>
				<label class="dropdown">
                     <asp:DropDownList ID="DDLPersona" runat="server" DataSourceID="DSPersona" DataTextField="Name"  DataValueField="Persons_id" 
                          data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                         <asp:ListItem Text = "-- selezionare un valore --" Value="" ></asp:ListItem>  
       			</asp:DropDownList>
				</label>
			</div>

            <!-- ** INPUT ELEMENT ** --> 
			<div class="input nobottomborder"> <!-- ** PROGETTO ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Progetto" /></div>
				<label class="dropdown">
                     <asp:DropDownList ID="DDLProgetto" runat="server" DataSourceID="DSProgetto" DataTextField="DescProgetto"  DataValueField="Projects_id" 
                          data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                         <asp:ListItem Text = "-- selezionare un valore --" Value="" ></asp:ListItem>  
       			</asp:DropDownList>
				</label>
			</div>

            <div class="buttons">
                <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                <asp:Button ID="btnSalvaModale" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                <asp:Button ID="btnCancelModale" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
           </div>

           </div>

       </div>  <!-- dialogNew -->

    </div> <!--  ModalWindowNew -->
    
  <div id="ModalWindow"> <!--  Finestra Dialogo -->

        <div id="dialogComment" class="window">

            <div id="FormWrap" class="StandardForm">

            <div class="formtitle">Commento</div>

            <div class="input nobottomborder"> <!-- ** DESCRIZIONE ** -->
                <div class="inputtext">Descrizione</div>
                <asp:TextBox runat="server" id="TBComment" TextMode="MultiLine" Rows="6" CssClass="textarea" />
            </div>
 
            <asp:TextBox runat="server" id="TBRevenueMese_id" style="visibility:hidden"/>

            <div class="buttons">
                <asp:Button ID="btnSalvaCommento" runat="server" CommandName="Insert" Text="<%$ appSettings:SAVE_TXT %>" CssClass="orangebutton" />
                <asp:Button ID="btnCancellaCommento" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings:CANCEL_TXT %>" CssClass="greybutton" />
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

</body>

    <script>
    // ** EVENTI TRIGGER **
    $("#FVForm").click(function (e) {       

        if (e.originalEvent.detail == 0)
            e.preventDefault(); //Cancel the link behavior
    });   

    $("#btnSalvaCommento").click(function (e) {

        $('#FVForm').parsley().validate();

       // if (!$('#FVForm').parsley().isValid()) ** non serve validazione ed evita problema dell'unico form **
       //     return;

        //Cancel the link behavior
        e.preventDefault();
        submitCreaAggiornaCommento();

        UnMaskScreen();
        $('.window').hide();

    }); // bottone salva su form nota

    $("#btnSalvaModale").click(function (e) { // bottone salva su form crea record

            $('#FVForm').parsley().validate();

            if (!$('#FVForm').parsley().isValid())
                return;

            //Cancel the link behavior
            e.preventDefault();
            submitCreaRevenueMese();

            UnMaskScreen();
            $('.window').hide();

    }); // bottone salva su form modale

    $(".greybutton").click(function (e) {
        //Cancel the link behavior
        e.preventDefault();
        $('#FVForm').parsley().reset();

        UnMaskScreen();
        $('.window').hide();
    }); // bottone chiude su form modale

    $("#btn_refresh").click(function (e) {

        //Cancel the link behavior
        e.preventDefault();

        TableRevenueMese.setData(); // refresh della tabella

    }); 

    $("#btn_crea").click(function (e) {

            if (e.originalEvent.detail == 0)
                return true; // se non è stato cliccato il tasto torna indietro

            //Cancel the link behavior
            e.preventDefault();
            MaskScreen(false);

            //initValue();  // inizializza campi
            openDialogForm("#dialog");

    });  // tasto crea record

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
             editor.value = cell.getValue().toLocaleString().replace(".","");
         else
             editor.value = "0";

         //set focus on the select box when the editor is selected (timeout allows for editor to be added to DOM)
         onRendered(function () {
             editor.focus();
             editor.style.css = "100%";
         });

         //when the value has been set, trigger the cell to update
         function successFunc() {
             success(editor.value.replace(",","."));
          }

         editor.addEventListener("change", successFunc);
         editor.addEventListener("blur", successFunc);

         //return the editor element
         return editor;
        };

    var TableRevenueMese = new Tabulator("#TableRevenueMese", {
    cellEdited:function(cell){
        //cell - cell component
        var RevenueMese_id = cell.getRow().getCells()[3].getValue(); // indice record da aggiornare
             
        // chiamata di aggiornamento
        var values = "{'sRevenueMese_id': '" + RevenueMese_id + "' , " +
                        " 'sFieldToUpdate': '" + cell.getField() + "' , " +
                        " 'sValue': '" + cell.getValue() + "' " +
                        "  } ";
        $.ajax({
            
                    type: "POST",
                    url: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateRevenueMese",
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
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder: "filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/GetRevenueMese", //ajax URL
    ajaxParams: { Persons_id: "0", AnnoMese: $("#DDLAnnoMese").val(), RevenueVersionCode: $("#DDLRevenueVersion").val() }, //ajax parameters
    ajaxConfig: "POST", //ajax HTTP request type
    ajaxContentType: "json", // send parameters to the server as a JSON encoded string
//    layout: "fitColumns", //fit columns to width of table (optional)
    ajaxResponse:function(url, params, response){
        //url - the URL of the request
        //params - the parameters passed with the request
        //response - the JSON object returned in the body of the response.
        return JSON.parse(response.d); //return the d property of a response json object
    },
        columns: [
            { title: "Consulente", field: "NomePersona", sorter: "string", headerFilter: "input", frozen: true, validator: "required" },
            { title: "Codice Progetto", field: "CodiceProgetto", sorter: "string", headerFilter: "input", frozen: true, validator: "required" },
            { title: "TR", field: "TipoRecord", sorter: "string", headerFilter: "input", frozen: true, width:"40"},

            { title: "RevenueMese_id", field: "RevenueMese_id", sorter: "number", visible: false }, // non spostare da posizione 3, serve per chiave di update record

            { title: "Progetto", field: "NomeProgetto", sorter: "string", headerFilter: "input" },
            { title: "Cliente", field: "NomeCliente", sorter: "string", headerFilter: "input" },
            { title: "Manager", field: "NomeManager", sorter: "string", headerFilter: "input" },
            // per tutti i campi numerici editabili
            // formatter : money -> sostituisce virgole e punti per decimali / migliaia, il campo sorgente è nel formato nnn.nn
            // editor: quanto editato il campo torna con la virgola in formato nnn,nn
            // validator: ammette solo numeri decimali
            { title: "OreCosti", field: "OreCosti", sorter: "string", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },
            { title: "GiorniCosti", field: "GiorniCosti", sorter: "number" },
            { title: "OreRevenue", field: "OreRevenue", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },
            { title: "GiorniRevenue", field: "GiorniRevenue", sorter: "number" },
            { title: "RevenueProposta", field: "RevenueProposta", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },
            { title: "Costo", field: "Costo", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },
            { title: "CostoSpese", field: "CostoSpese", sorter: "number", formatter: "money", formatterParams: { decimal: ",", thousand: "." }, editor: moneyEditor, validator: "regex:^-*[0-9]*\.?[0-9]{0,2}$" },

            { title: "Projects_id", field: "Projects_id", sorter: "number", visible: false },
            { title: "Persons_id", field: "Persons_id", sorter: "number", visible: false },
            
            { formatter: trashIcon, width: 40, align: "center", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
            { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
    ],
    });

    // ** FUNZIONI **
    function T_leggiRecord(dati, riga) {

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{'sRevenueMese_id': '" + dati.RevenueMese_id + "'   } ";

        $.ajax({

            type: "POST",
            url: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/GetRevenueMeseItem",
            data: values,
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (msg) {

                var obj = msg.d;

                if (obj.RevenueMese_id > 0)
                    $('#TBRevenueMese_id').val(obj.RevenueMese_id);
                $('#TBComment').val(obj.Comment);

                openDialogForm("#dialogComment");

            },

            error: function (xhr, textStatus, errorThrown) {
                return false;
            }

        }); // ajax

    }  // leggi dati da record, chiamata da Tabulator

    function T_cancellaRecord(dati, riga) {

                // non si può cancellare record A
                if (dati.TipoRecord == "A") {
                    ShowPopup("Impossibile cancellare record generato");
                    return false;
                }
    
                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'sRevenueMese_id': '" + dati.RevenueMese_id + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/report/EstraiRevenue/WS_EstraiRevenue.asmx/CancellaRevenueMeseRecord",
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
                        ShowPopup("Errore in cancellazione del record");
                        return false;
                    }

                }); // ajax
    }

    function submitCreaRevenueMese() {

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{ Persons_id: '" + $('#DDLPersona').val() + "', " + 
                     "  Projects_id: '" + $('#DDLProgetto').val() + "', " +
                     "  RevenueVersionCode: '" + $('#DDLRevenueVersion').val() + "', " +
                     "  AnnoMese: '" + $("#DDLAnnoMese").val() + "', " +
                     "  TipoRecord: 'M' }"; 

            $.ajax({
                type: "POST",
                url: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/CreaRevenueMese",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // se call OK inserisce una riga sotto l'elemento 
                    if (msg.d != true) {
                        ShowPopup("Errore in creazione, riprovare");
                    }
                    TableRevenueMese.setData(); // aggiorna tabella
                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }
            }); // ajax

    } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

    function submitCreaAggiornaCommento() {

        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{ 'sRevenueMese_id': '" + $('#TBRevenueMese_id').val() + "', " +
                        "sFieldToUpdate: 'Comment' , " +
                        "sValue: '" + $('#TBComment').val() + "'   } ";

        $.ajax({
            type: "POST",
            url: "/timereport/Report/EstraiRevenue/WS_EstraiRevenue.asmx/UpdateRevenueMese",
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

    } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

</script>

<asp:sqldatasource runat="server" ID="DSPersona"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT persons_id, name  FROM [Persons] where active = 1 ORDER BY name"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSProgetto"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT projects_id, ProjectCode + ' ' + left(Name,20) AS DescProgetto FROM [Projects] where active = 1 ORDER BY ProjectCode"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSRevenueVersion"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT RevenueVersionCode, RevenueVersionCode+ ' ' + RevenueVersionDescription AS RevenueVersionDescription FROM RevenueVersion ORDER BY RevenueVersionCode"></asp:sqldatasource>


</html>
