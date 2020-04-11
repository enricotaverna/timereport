<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menu-new.aspx.cs" Inherits="menu" %>

<!DOCTYPE html>

<!-- Menù  -->
<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" noexpenses='<%= Session["NoExpenses"]%>' lingua='<%= Session["lingua"]%>' userlevel='<%= Session["userLevel"]%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<%--<script src="/timereport/include/jquery/jquery-ui.min.js"></script>--%>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
<link href="/timereport/include/dashboard.css" rel="stylesheet" type="text/css" />

<!-- INCLUDE JS TIMEREPORT   -->
<script src="/timereport/include/javascript/timereport.js"></script>

<!-- INCLUDE CHARTJS   -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Time Report</title>
</head>


<body>

    <style>
        .hoverOn:hover {
            cursor: pointer;
        }

        /*.card {
            width: 12rem;
        }*/
    </style>
    <div id="TopStripe"></div>
    <div id="MainWindow">

        <!--**** Riquadro navigazione ***-->
        <form id="form1" runat="server">

            <div class="container">
                <!-- *** container *** -->

                <!-- *** 1 Row *** -->
                <div class="row" id="row1" runat="server">

                        <!--  *** Box TRAINING DA VALUTARE ***    -->
                        <div class="col-md-4">
                            <div class="card my-2 widget-content hoverOn" id="TrainingDaValutare">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Training</div>
                                        <div class="widget-subheading">da valutare</div>
                                    </div>
                                    <div class="widget-content-right">
                                        <div class="widget-numbers text-warning"><span id="TrainingDaValutareKPI1">0</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!--  *** Box ASSENZE ***    -->
                        <div class="col-md-4" id="GiorniAssenza" runat="server">

                            <div class="card  my-2 widget-content hoverOn">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Giornate assenza</div>
                                        <div class="widget-subheading">prossimi 30 gg</div>
                                    </div>
                                    <div class="widget-content-right">
                                        <div class="widget-numbers text-success"><span id="GiorniAssenzaKPI1">-</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!--  *** Box GG TRAINING ***    -->
                        <div class="col-md-4" id="GiorniTraining" runat="server">
                            <div class="card  my-2 widget-content hoverOn">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Giornate training</div>
                                        <div class="widget-subheading">prossimi 30 gg</div>
                                    </div>
                                    <div class="widget-content-right">
                                        <div class="widget-numbers text-success"><span id="GiorniTrainingKPI1">-</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                </div>
                <!-- *** 1 Row *** -->

                <!-- *** 2 Row *** -->
                <div class="row" id="row2" runat="server">

                        <!--  *** Box ORE CARICATE ***    -->
                        <div class="col-md-4">
                            <div class="card my-2 widget-content hoverOn" id="OreNelMese">
                                <div class="widget-content-outer">
                                    <div class="widget-content-wrapper">
                                        <div class="widget-content-left">
                                            <div class="widget-heading">Ore</div>
                                            <div class="widget-subheading">caricate nel mese</div>
                                        </div>
                                        <div class="widget-content-right">
                                            <div class="widget-numbers text-primary" id="OreNelMeseKPI1">-</div>
                                        </div>
                                    </div>
                                    <div class="widget-progress-wrapper">
                                        <div class="progress-bar-lg progress-bar-animated progress">
                                            <div id="OreNelMeseProgressBar" class="progress-bar bg-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
                                        </div>
                                        <div class="progress-sub-label">
                                            <div class="sub-label-left">ore caricate su totale</div>
                                            <div class="sub-label-right" id="OreNelMeseKPI2">-</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                </div>
                <!-- *** 2 Row *** -->

                <!-- *** 3 Row *** -->
                <div class="row" id="row3" runat="server">

                        <!--  *** Box SPESE NEL MESE ***    -->
                        <div class="col-md-4 my-2 hoverOn" id="SpeseNelMese">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <div class="widget-content p-0">
                                        <div class="widget-content-outer">
                                            <div class="widget-content-wrapper">
                                                <div class="widget-content-left">
                                                    <div class="widget-heading">Spese Mese</div>
                                                    <div class="widget-subheading" id="SpeseNelMeseKPI3">-</div>
                                                </div>
                                                <div class="widget-content-right">
                                                    <div class="widget-numbers text-primary" id="SpeseNelMeseKPI1">-</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <li class="list-group-item">
                                    <div class="widget-content p-0">
                                        <div class="widget-content-outer">
                                            <div class="widget-content-wrapper">
                                                <div class="widget-content-left">
                                                    <div class="widget-heading">Chilometri</div>
                                                    <div class="widget-subheading">mese corrente</div>
                                                </div>
                                                <div class="widget-content-right">
                                                    <div class="widget-numbers text-primary" id="SpeseNelMeseKPI2">-</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>

                        <!--  *** Box GRAFICO ***    -->
                        <%--        <div class="main- card mx-3 col-md-4 card">
                        <div class="card-body">
                            <div class="chartjs-size-monitor" style="position: absolute; left: 0px; top: 0px; right: 0px; bottom: 0px; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
                                <div class="chartjs-size-monitor-expand" style="position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
                                    <div style="position: absolute; width: 1000000px; height: 1000000px; left: 0; top: 0"></div>
                                </div>
                                <div class="chartjs-size-monitor-shrink" style="position: absolute; left: 0; top: 0; right: 0; bottom: 0; overflow: hidden; pointer-events: none; visibility: hidden; z-index: -1;">
                                    <div style="position: absolute; width: 200%; height: 200%; left: 0; top: 0"></div>
                                </div>
                            </div>
                            <h5 class="card-title">Vertical Bars</h5>
                            <canvas id="verticalBar" height="253" width="508" class="chartjs-render-monitor" style="display: block; height: 203px; width: 407px;"></canvas>
                        </div>
                    </div>--%>

                </div>
                <!-- *** 3 Row *** -->

                <!-- *** 4 Row *** -->
                <div class="row" id="row4" runat="server">

                        <!--  *** Box RICHIESTE ***    -->
                        <div class="col-md-4" id="RichiesteAperte" runat="server">
                            <div class="card my-2 widget-content hoverOn">
                                <div class="widget-content-wrapper">
                                    <div class="widget-content-left">
                                        <div class="widget-heading">Richieste assenza</div>
                                        <div class="widget-subheading">da approvare</div>
                                    </div>
                                    <div class="widget-content-right">
                                        <div class="widget-numbers text-warning"><span id="RichiesteAperteKPI1">-</span></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                </div>
                <!-- *** 4 Row *** -->

            </div>
            <!-- *** container *** -->

        </form>

    </div>
    <!-- END MainWindow -->



    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <% if (Session["persons_id"].ToString() == "1")
            {
                string sConn = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString.ToString();
                Response.Write("&nbsp; " + sConn.Substring(12, 13) + "&nbsp; " + sConn.Substring(36, 20));
            }
        %>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">
            <asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" />
            <%= Session["UserName"]  %>
        </div>
    </div>

    <script type="text/javascript">

        $(document).ready(function () {

            $("#RichiesteAperte").click(function () {
                location.href = "/timereport/m_gestione/Approval/Approval_list.aspx";
            });

            $("#TrainingDaValutare").click(function () {
                location.href = "/timereport/m_gestione/training/TrainingPlan_evaluate.aspx";
            });

            $("#OreNelMese").click(function () {
                location.href = "/timereport/input.aspx?type=hours";
            });

            $("#SpeseNelMese").click(function () {
                location.href = "/timereport/input.aspx?type=expenses";
            });

            $("#GiorniTraining").click(function () {
                location.href = "/timereport/m_gestione/Approval/HoursList.aspx?tipoOre=<%=ConfigurationManager.AppSettings["CODICI_TRAINING"]%>";
            });

            $("#GiorniAssenza").click(function () {
                location.href = "/timereport/m_gestione/Approval/HoursList.aspx?tipoOre=<%=ConfigurationManager.AppSettings["CODICI_ASSENZE"]%>";
            });

            // Richiama Web Service per aggiornamento KPI
            var values = "{ iPersons_id : <%= Session["persons_id"]  %> }";
            $.ajax({
                type: "POST",
                url: "/timereport/webservices/WF_ApprovalWorkflow.asmx/UpdateCardKPI",
                data: values,
                async: false,
                contentType: "application/json; charset=utf-8",
                dataType: "json",

                success: function (msg) {
                    // chiude dialogo
                    var objList = JSON.parse(msg.d)

                    for (var i = 0; i < objList.length; i++) {
                        var idName = "#" + objList[i].cardName + "KPI1";
                        $(idName).text(objList[i].KPI1);
                        var idName = "#" + objList[i].cardName + "KPI2";
                        $(idName).text(objList[i].KPI2);
                        var idName = "#" + objList[i].cardName + "KPI3";
                        $(idName).text(objList[i].KPI3);

                        if (objList[i].cardName == "OreNelMese")
                            $("#OreNelMeseProgressBar").width(objList[i].KPI1); // progress bar ore

                    }

                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }
            }); // ajax



        });


        //var ctx = document.getElementById('verticalBar').getContext('2d');
        //var chart = new Chart(ctx, {
        //    // The type of chart we want to create
        //    type: 'bar',

        //    // The data for our dataset
        //    data: {
        //        labels: ['Rimborso', 'Km', 'CartaC'],
        //        datasets: [{
        //            label: 'Mese corrente',
        //            backgroundColor: 'rgb(255, 0, 0)',
        //            borderColor: 'rgb(255, 0, 0)',
        //            data: [0, 10, 5]
        //        }, {
        //            label: 'Mese -1',
        //            backgroundColor: 'rgb(0, 255, 0)',
        //            borderColor: 'rgb(0, 255, 0)',
        //            data: [0, 10, 5]
        //        }, {
        //            label: 'Media 6 mesi',
        //            backgroundColor: 'rgb(0, 0, 255)',
        //            borderColor: 'rgb(0, 0, 255)',
        //            data: [5, 10, 15]
        //        }]
        //    },

        //    // Configuration options go here
        //    options: {}
        //});

    </script>


</body>

</html>
