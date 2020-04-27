<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CourseCatalog.aspx.cs" Inherits="m_gestione_Projects_lookup_list" %>

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
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Catalogo Corsi</title>
</head>

<body>
    
    <div id="TopStripe"></div> 

    <div id="MainWindow" >
  
    <form id="FVForm" runat="server" >
    
    <div id="PanelWrap"  > 

    <div id="FormWra1p" class="StandardForm">        
        <div id="CourseCatalogTable"></div>
    </div>  
            

    <div class="buttons">               
        <asp:Button ID="btn_crea" runat="server" Text="<%$ appSettings: CREATE_TXT %>"  CssClass="orangebutton"  />
        <asp:Button ID="btn_back" runat="server" Text="<%$ appSettings: CANCEL_TXT %>"  CssClass="greybutton" PostBackUrl="/timereport/menu.aspx" />
    </div> <!--End buttons-->

    </div> <!--End PanelWrap-->
    
    <div id="ModalWindow"> <!--  Finestra Dialogo -->

        <div id="dialog" class="window">

            <div id="FormWrap" class="StandardForm">

            <div class="formtitle">Scheda Corso</div>

            <!-- ** INPUT ELEMENT ** -->
            <div class="input nobottomborder"> <!-- ** CODICE CORSO ** -->
                <div class="inputtext">Codice Corso</div>
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBCourseCode"  Enabled="False"  />

                <asp:CheckBox  ID="CBActive" runat="server"  Checked="True" /> <!-- ** ATTIVO ** -->
				<asp:Label  AssociatedControlId="CBActive" class="css-label" ID="Label3" runat="server">Attivo</asp:Label>
            </div>
 
            <div class="input nobottomborder"> <!-- ** NOME CORSO ** -->
                <div class="inputtext">Nome Corso</div>
                <asp:TextBox class="ASPInputcontent" style="width:270px" data-parsley-codiceunico runat="server" id="TBCourseName" data-parsley-errors-container="#valMsg" data-parsley-required="true" MaxLength="100" />
            </div>

            <div class="input nobottomborder"> <!-- ** DESCRIZIONE ** -->
                <div class="inputtext">Descrizione</div>
                <asp:TextBox runat="server" id="TBDescription" TextMode="MultiLine" Rows="4" CssClass="textarea" />
            </div>
 
			<div class="input nobottomborder"> <!-- ** TIPO CORSO ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Tipo Corso" /></div>
				<label class="dropdown">
                     <asp:DropDownList ID="DDLCourseType" runat="server" DataSourceID="DSCourseType" DataTextField="CourseTypeName"  DataValueField="CourseType_id" 
                          data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                         <asp:ListItem Text = "-- selezionare un valore --" Value="" ></asp:ListItem>  
       			</asp:DropDownList>
				</label>
			</div>

			<div class="input nobottomborder"> <!-- ** PRODOTTO ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Prodotto" /></div>
				<label class="dropdown">
                     <asp:DropDownList ID="DDLProduct" runat="server" DataSourceID="DSProduct" DataTextField="ProductName"  DataValueField="Product_id" AppendDataBoundItems="True">
       			     <asp:ListItem Text = "" Value="" ></asp:ListItem>   
                     </asp:DropDownList>
				</label>
			</div>

            <div class="input nobottomborder"> <!-- ** AREA ** -->
                <div class="inputtext">Area</div>
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBArea" />
            </div>

 			<div class="input nobottomborder"> <!-- ** VENDOR ** -->
				<div class="inputtext"><asp:Literal runat="server" Text="Vendor" /></div>
				<label class="dropdown">
                     <asp:DropDownList ID="DDLCourseVendor" runat="server" DataSourceID="DSVendor" DataTextField="VendorName"  DataValueField="CourseVendor_id" 
                          data-parsley-errors-container="#valMsg" data-parsley-required="true" AppendDataBoundItems="True">
                          <asp:ListItem Text = "-- selezionare un valore --" Value="" ></asp:ListItem> 
       			</asp:DropDownList>
				</label>
			</div>
                
            <div class="input nobottomborder"> <!-- ** DURATA ** -->
                <div class="inputtext">Durata(gg)</div>
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBDurationDays"  data-parsley-errors-container="#valMsg" data-parsley-pattern="^\d+(,\d+)?$" />
            </div>

            <div class="input nobottomborder"> <!-- ** COSTO ** -->
                <div class="inputtext">Costo(€)</div>
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBCost"  />
            </div>

            <div class="input nobottomborder"> <!-- ** VALIDO DA ** -->
                <div class="inputtext">Validato da</div>
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBValidFrom"  Columns="10" 
                             data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/"/>
                &nbsp;a&nbsp;
                <asp:TextBox class="ASPInputcontent" runat="server" id="TBValidTo" Columns="10" 
                             data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/"/>
            </div>

            <asp:TextBox runat="server" id="TBCourse_id" style="visibility:hidden"/>


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

    // ** VALIDAZIONI **

    $("#FvForm").parsley();     // Esclude i controlli nascosti 

    // *** controllo che non esista lo stesso codice utente *** //
    window.Parsley.addValidator('codiceunico', function (value, requirement) {

        // solo in creazione
        if ($('#TBCourse_id').val() != 0)
            return true;

        var response = false;
        var dataAjax = "{ sKey: 'CourseCode', " +
                       " sValkey: '" + value  + "', " + 
                       " sTable: 'HR_Course'  }";

                    $.ajax({
                        url: "/timereport/webservices/WStimereport.asmx/CheckExistence",
                        data: dataAjax,
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        type: 'post',
                        async: false,
                        success: function (data) {
                            if (data.d == true) // esiste, quindi errore
                                response = false;
                            else
                                response = true;
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            alert(xhr.status);
                            alert(thrownError);
                        }
                    });
                    return response;
         }, 32)
        .addMessage('en', 'codiceunico', 'Course code already exists')
        .addMessage('it', 'codiceunico', 'Codice corso già esistente');

    // ** INTERFACCIA **

    $("#TBValidFrom").datepicker($.datepicker.regional['it']);
    $("#TBValidTo").datepicker($.datepicker.regional['it']);

    $(":checkbox").addClass("css-checkbox");     // attiva checkbox

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

        $('#FVForm').parsley().validate();

        if ( !$('#FVForm').parsley().isValid() )
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

    var CourseCatalogTable = new Tabulator("#CourseCatalogTable", {
    initialHeaderFilter: [{ field: "Active", value: "true" } //valore iniziare dello stato per filtrare
    ],
    paginationSize: 18, // this option can take any positive integer value (default = 10)
    pagination:"local", //enable local pagination.
    headerFilterPlaceholder:"filtra i record...", //set column header placeholder text
    ajaxURL:"/timereport/webservices/HR_Training.asmx/GetCourseCatalog", //ajax URL
    ajaxParams: { bActive: false, sAnno: "" }, //ajax parameters
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
        { title: "Codice Corso", field: "CourseCode", sorter:"alphanum", width:80, headerFilter:"input"},
        { title: "Corso", field:"CourseName", sorter:"string", width:150, headerFilter:"input" },
        { title: "Tipo", field: "CourseTypeName", sorter:"string", headerFilter:true },
        { title: "Prodotto", field: "ProductName", sorter: "string", headerFilter:true },
        { title: "Area", field: "Area", sorter: "string", headerFilter:true },
        { title: "Fornitore", field: "VendorName", sorter: "string", headerFilter:true },
        { title: "Durata GG", field: "Durata", sorter: "number", headerFilter: true },
        { title: "Attivo", field: "Active", headerFilter:"select", width:50, headerFilterParams:{values:{"true":"true", "false":"false"}}  },
        { formatter: trashIcon, width: 40, align: "center", cellClick: function (e, cell) { T_cancellaRecord(cell.getRow().getData(), cell.getRow()) } },
        { formatter: editIcon, width: 40, align: "center", cellClick: function (e, cell) { T_leggiRecord(cell.getRow().getData(), cell.getRow()) } },
        ],
    }); // Tabella principale

    // ** FUNZIONI **

    function initValue() {

        today = new Date();

        $('#TBCourse_id').val('0');
        $('#TBCourseCode').val('');
        $('#TBCourseName').val('');
        $('#TBDescription').val('');
        //$('#DDLCourseType').val('0');
        //$('#DDLProduct').val('');
        $('#TBArea').val('');
        //$('#DDLCourseVendor').val('');
        $('#TBDurationDays').val('');
        $('#TBCost').val('');
        $('#TBValidFrom').val('');
        $('#TBValidTo').val(''); 
    
    } // inizilizza form in creazione

    function T_leggiRecord(dati, riga) {

            // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
            var values = "{'sCourse_id': '" + dati.Course_id  + "'   } ";

            $.ajax({

                type: "POST",
                url: "/timereport/webservices/HR_Training.asmx/GetCourse",
                data: values,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {

                    var objCourse = msg.d;

                    if (objCourse.Course_id > 0) 
                        $('#TBCourse_id').val(objCourse.Course_id);
                        $('#TBCourseCode').val(objCourse.CourseCode);
                        $('#TBCourseName').val(objCourse.CourseName);
                        $('#TBDescription').val(objCourse.Description);
                        $('#DDLCourseType').val(objCourse.CourseType_id);
                        $('#DDLProduct').val(objCourse.Product_id);
                        $('#CBActive').prop('checked', objCourse.Active ); // imposta il valore del check box
                        //$('#CBActive').val(objCourse.Active);
                        $('#TBArea').val(objCourse.Area);
                        $('#DDLCourseVendor').val(objCourse.CourseVendor_id);
                        $('#TBDurationDays').val(objCourse.DurationDays);;
                        $('#TBCost').val(objCourse.Cost);;
                        $('#TBValidFrom').val(objCourse.ValidFrom);;
                        $('#TBValidTo').val(objCourse.ValidTo);;

                        openDialogForm("#dialog");

                },

                error: function (xhr, textStatus, errorThrown) {
                    return false;
                }

            }); // ajax

    }  // leggi dati da record, chiamata da Tabulator

    function T_cancellaRecord(dati, riga) {

                // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
                var values = "{'sCourse_id': '" + dati.Course_id  + "'   } ";

                $.ajax({

                    type: "POST",
                    url: "/timereport/webservices/HR_Training.asmx/DeleteCourse",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",

                    success: function (msg) {
                        // se call OK inserisce una riga sotto l'elemento 
                        if (msg.d == true) {
                            riga.delete();
                        } else
                            ShowPopup("Impossibile cancellare corso già utilizzato");

                    },

                    error: function (xhr, textStatus, errorThrown) {
                        return false;
                    }

                }); // ajax

    } // cancella record, chiamata da Tabulator
 
    function submitCreaAggiornaRecord() {
        
        // valori da passare al web service in formato { campo1 : valore1 , campo2 : valore2 }
        var values = "{ 'Course_id': '" + $('#TBCourse_id').val() + "', " +
            "'CourseName': '" + $('#TBCourseName').val() + "' , " +
            "'Description': '" + $('#TBDescription').val() + "' , " +
            "'CourseType_id': '" + $('#DDLCourseType').val() + "' , " +
            "'Product_id': '" + $('#DDLProduct').val() + "' , " +
            "'Area': '" + $('#TBArea').val() + "' , " +
            "'Active': '" + $('#CBActive').is(':checked') + "' , " +
            "'CourseVendor_id': '" + $('#DDLCourseVendor').val() + "' , " +
            "'DurationDays': '" + $('#TBDurationDays').val() + "' , " +
            "'Cost': '" + $('#TBCost').val() + "' , " +
            "'ValidFrom': '" + $('#TBValidFrom').val() + "' , " +
            "'ValidTo': '" + $('#TBValidTo').val() + "'   } ";

        $.ajax({

            type: "POST",
            url: "/timereport/webservices/HR_Training.asmx/CreateUpdateCourse",
            data: values,
            async: false,
            contentType: "application/json; charset=utf-8",
            dataType: "json",

            success: function (msg) {
                // chiude dialogo
                CourseCatalogTable.replaceData() // ricarica tabella dopo insert

            },

            error: function (xhr, textStatus, errorThrown) {
                alert(xhr.responseText);
            }

        }); // ajax
    } // crea o aggiorna record selezionato, chiamata da btnSalvaModale

</script>

<asp:sqldatasource runat="server" ID="DSCourseType"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [HR_CourseType] ORDER BY CourseTypeName"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSProduct"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [HR_Product] ORDER BY ProductName"></asp:sqldatasource>

<asp:sqldatasource runat="server" ID="DSVendor"
        ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        SelectCommand="SELECT * FROM [HR_CourseVendor] ORDER BY VendorName"></asp:sqldatasource>

</html>
