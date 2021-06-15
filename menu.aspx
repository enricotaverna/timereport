<%@ Page Language="C#" AutoEventWireup="true" CodeFile="menu.aspx.cs" Inherits="menu" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<%--<script src="https://cdn.jsdelivr.net/npm/chart.js@2.8.0"></script>--%>
<script src="/timereport/include/javascript/timereport.js"></script>


<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<%--<link href="/timereport/include/dashboard.css" rel="stylesheet" />--%>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Time Report</title>
</head>

<body>

    <!--**** Riquadro navigazione ***-->
    <form id="MainForm" runat="server">

        <!-- *** APPLICTION MENU *** -->
        <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>-<%= CurrentSession.Language %>.html"></div>

        <div class="container MainWindowBackground" style="padding-top:20px">

            <!-- *** 1 Row *** -->
            <div class="row" id="row1" runat="server">

                <!--  *** Box TRAINING DA VALUTARE ***    -->
                <div class="col-md-4" id="TrainingDaValutare" runat="server">
                    <div class="card my-2 widget-content hoverOn">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="widget-heading">Training da valutare</div>
                                <div class="widget-subheading">concluso entro 120gg</div>
                            </div>
                            <div class="widget-content-right">
                                <div class="widget-numbers"><span id="TrainingDaValutare-KPIValue0">0</span></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--  *** Box CV ***    -->
                <div class="col-md-4" id="CVdaConfermare" runat="server">
                    <div class="card  my-2 widget-content hoverOn">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="widget-heading">Curriculum da confermare</div>
                                <div class="widget-subheading">da parte manager</div>
                            </div>
                            <div class="widget-content-right">
                                <div class="widget-numbers"><span id="CVdaConfermare-KPIValue0">-</span></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--  *** Box GG TRAINING ***    -->
                <div class="col-md-4" id="GiorniTraining" runat="server">
                    <div class="card  my-2 widget-content hoverOn">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="widget-heading">Giornate training team</div>
                                <div class="widget-subheading">prossimi 30 gg</div>
                            </div>
                            <div class="widget-content-right">
                                <div class="widget-numbers text-success"><span id="GiorniTraining-KPIValue0">-</span></div>
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
                                    <div class="widget-heading"><asp:Literal runat="server" Text="<%$ Resources:Ore_da_caricare %>" /></div>
                                    <div class="widget-subheading"><asp:Literal runat="server" Text="<%$ Resources:da_inizio_mese_ad_oggi %>" /></div>
                                </div>
                                <div class="widget-content-right">
                                    <div class="widget-numbers" id="OreNelMese-KPIValue0">-</div>
                                </div>
                            </div>
                            <div class="widget-progress-wrapper">
                                <div class="progress-bar-lg progress-bar-animated progress">
                                    <div id="OreNelMeseProgressBar" class="progress-bar bg-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>
                                </div>
                                <div class="progress-sub-label">
                                    <div class="sub-label-left"><asp:Literal runat="server" Text="<%$ Resources:ore_caricate_su_totale_mese %>" /></div>
                                    <div class="sub-label-right" id="OreNelMese-KPIValue1">-</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!--  *** Box vuoto ***    -->
                <div class="col-md-4" id="Div2" runat="server">
                </div>

                <!--  *** Box ASSENZE ***    -->
                <div class="col-md-4" id="GiorniAssenza" runat="server">

                    <div class="card  my-2 widget-content hoverOn">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="widget-heading">Giornate assenza team</div>
                                <div class="widget-subheading">prossimi 30 gg</div>
                            </div>
                            <div class="widget-content-right">
                                <div class="widget-numbers text-success"><span id="GiorniAssenza-KPIValue0">-</span></div>
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
                                            <div class="widget-heading"><asp:Literal runat="server" Text="<%$ Resources:Spese_Mese %>" /></div>
                                            <div class="widget-subheading" id="SpeseNelMese-KPIValue2">-</div>
                                        </div>
                                        <div class="widget-content-right">
                                            <div class="widget-numbers text-primary" id="SpeseNelMese-KPIValue0">-</div>
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
                                            <div class="widget-heading"><asp:Literal runat="server" Text="<%$ Resources:Chilometri %>" /></div>
                                            <div class="widget-subheading"><asp:Literal runat="server" Text="<%$ Resources:mese_corrente %>" /></div>
                                        </div>
                                        <div class="widget-content-right">
                                            <div class="widget-numbers text-primary" id="SpeseNelMese-KPIValue1">-</div>
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

                <!--  *** ListaLocation ***    -->
                <div id="ListaLocation" class="col-md-4 my-2">
                    <div class="main-card card">
                        <div class="card-body">
                            <table class="mb-0 table">
                                <thead>
                                    <tr class="widget-heading">
                                        <th><asp:Literal runat="server" Text="<%$ Resources:Luogo %>" /></th>
                                        <th><asp:Literal runat="server" Text="<%$ Resources:Ore %>" /></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td id="ListaLocation-KPIDescription0"></td>
                                        <td id="ListaLocation-KPIValue0"></td>
                                    </tr>
                                    <tr>
                                        <td id="ListaLocation-KPIDescription1"></td>
                                        <td id="ListaLocation-KPIValue1"></td>
                                    </tr>
                                    <tr>
                                        <td id="ListaLocation-KPIDescription2"></td>
                                        <td id="ListaLocation-KPIValue2"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!--  *** Box RICHIESTE ***    -->
                <div class="col-md-4" id="RichiesteAperte" runat="server">
                    <div class="card my-2 widget-content hoverOn">
                        <div class="widget-content-wrapper">
                            <div class="widget-content-left">
                                <div class="widget-heading">Richieste assenza</div>
                                <div class="widget-subheading">da approvare</div>
                            </div>
                            <div class="widget-content-right">
                                <div class="widget-numbers text-warning"><span id="RichiesteAperte-KPIValue0">-</span></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <!-- *** 4 Row *** -->

        </div>
        <!-- *** End container *** -->

    </form>

    <!-- **** FOOTER **** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">
                    Aeonvis Spa <%= DateTime.Now.Year %>
                    <% if (CurrentSession.Persons_id.ToString() == "1")
                        {
                            string sConn = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString.ToString();
                            Response.Write("&nbsp; " + sConn.Substring(36, 15));
                        }
                    %>
                </div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.sCutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** JAVASCRIPT ***-->
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

            $("#CVdaConfermare").click(function () {
                location.href = "/timereport/m_gestione/curricula/CV_list.aspx";
            });

            // Richiama Web Service per aggiornamento KPI
            var values = "{ iPersons_id : '<%= CurrentSession.Persons_id.ToString()  %>', cutoffDate :  '<%= CurrentSession.sCutoffDate  %>'  }";
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

                        if (objList[i].cardName == "OreNelMese")
                            $("#OreNelMeseProgressBar").width(objList[i].KPIList[2].KPIValue); // progress bar ore

                        if (objList[i].KPIList != null) {
                            for (var n = 0; n < objList[i].KPIList.length; n++) {
                                var idDescription = "#" + objList[i].cardName + "-KPIDescription" + n;
                                var idValue = "#" + objList[i].cardName + "-KPIValue" + n;
                                $(idValue).parent().addClass(objList[i].KPIList[n].CSSClass);
                                $(idDescription).text(objList[i].KPIList[n].KPIDescription);
                                $(idValue).text(objList[i].KPIList[n].KPIValue);
                            }
                        }

                    }
                },

                error: function (xhr, textStatus, errorThrown) {
                    alert(xhr.responseText);
                }
            }); // ajax
        });

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>


</body>

</html>
