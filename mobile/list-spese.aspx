<%@ Page Title="" Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <title>Report Spese</title>
    <meta name="viewport" content="initial-scale=1">
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <!-- style sheets -->
    <link rel="stylesheet" href="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.css" />
    <link href="/timereport/include/TimereportMobilev2.css" rel="stylesheet" />
    <!-- jquery mobile -->
    <script src="/timereport/include/jquery/1.7.1/jquery-1.7.1.min.js"></script>
    <script src="/timereport/include/javascript/customscript.js"></script>
    <script src="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.js"></script>
    <!-- jquery mobile FINE -->

    <script>
       $(document).bind("mobileinit", function () {
           $.mobile.page.prototype.options.addBackBtn = true;
       });
    </script>
    <!-- jquery mobile -->
    <script src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>
    <!-- jquery mobile FINE -->
        <script>
    <!-- elimina barra -->   
            var iWebkit; if (!iWebkit) { iWebkit = window.onload = function () { function fullscreen() { var a = document.getElementsByTagName("a"); for (var i = 0; i < a.length; i++) { if (a[i].className.match("noeffect")) { } else { a[i].onclick = function () { window.location = this.getAttribute("href"); return false } } } } function hideURLbar() { window.scrollTo(0, 0.9) } iWebkit.init = function () { fullscreen(); hideURLbar() }; iWebkit.init() } }
     </script>

</head>

<body>

    <div id="FormReportSpese" data-role="page">
        
        <script type="text/javascript" language="javascript">
            // Javascript di pagina
        </script>
        
        <form id="aspnetForm" runat="server" method="post" name="myForm">
        
            <div data-role="header" data-position="fixed">
                <a href='./menu.aspx?id=<%= Request.QueryString["id"] %>' class='ui-btn-left' data-icon='arrow-l' rel=external>Back</a>
                <h1>Report Spese                
<%                      
                string sMeseAnno;
                int iMese = DateTime.Now.Month - 1;

                if (Request.QueryString["mese"] == "-1")
                {
                    Response.Write("<a href=list-spese.aspx?mese=0&id=" + Request.QueryString["id"] + " class=ui-btn-right data-icon=search data-role=button rel=external>mese corrente</a>");
                    if ( DateTime.Now.Month != 1 ) {
                        sMeseAnno = (DateTime.Now.Month -1 ).ToString() + "/" + DateTime.Now.Year.ToString();
                        iMese = DateTime.Now.Month - 2;  }
                    else {
                        sMeseAnno = "12" + "/" + ( DateTime.Now.Year - 1 ).ToString();
                        iMese = 11;  }       
                    }                                                      
                else {
                    Response.Write("<a href=list-spese.aspx?mese=-1&id=" + Request.QueryString["id"] + " class=ui-btn-right data-icon=search data-role=button rel=external>mese precedente</a>");
                    sMeseAnno = DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString();
                     }   
%>                

                </h1>
            </div> <!-- /header -->
        
            <div data-role="content">
    
<%  

                string[] LastDayInMonth = new string[12] { "31", "28", "31", "30", "31", "30", "31", "31", "30", "31", "30", "31" };     
                int nCounterTot=0,nCounterItem=0;
                string sFromDate = ASPcompatility.FormatDateDb("01/" + sMeseAnno, false);
                string sToDate = ASPcompatility.FormatDateDb(LastDayInMonth[iMese] + "/" + sMeseAnno, false);        
                string sDataCurr = "";
                ArrayList lExpContent = new ArrayList();
                
                // apre connessione per estrarre le spese                 
                SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter("SELECT Date, Amount, ExpenseCode, ExpenseType.Name AS ExpName, ProjectCode FROM Expenses " +
                                                            " RIGHT JOIN Projects ON Expenses.Projects_id = Projects.Projects_id " +
                                                            " RIGHT JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_id " +
                                                            " WHERE Expenses.persons_id=" + Request.QueryString["id"] + " and date >= " + sFromDate + " and date <= " + sToDate + " ORDER BY date", conn);
                SqlCommandBuilder builder = new SqlCommandBuilder(adapter);

                // Create a dataset object
                DataSet ds = new DataSet("DSExpenses");
                adapter.Fill(ds, "Expenses");
                    
                // Create a data table object and add a new row
                DataTable ExpensesTable = ds.Tables["Expenses"];

                foreach (DataRow dr in ExpensesTable.Rows)
                    {
                                                                    
                        if ( dr["date"].ToString().Substring(0,10) != sDataCurr )       { // cambio data

                            if (nCounterTot == 0) // primo item
                                Response.Write("<ul data-role=listview data-inset=true>"); // apre lista
                            else {
                            //  stampa blocco di item e pulisce la lista                                                                
                                Response.Write("<li><h3>" + sDataCurr + "</h3><span class=ui-li-count>" + nCounterItem.ToString()  + "</span><ul>");                                 
                                foreach ( string cursor in lExpContent )
                                    Response.Write("<li>" + cursor + "</li>");  
                                Response.Write("</ul></li>");
                                
                                lExpContent.Clear(); // pulisce la lista
                                nCounterItem = 0;      
                            } 
                        }

                        lExpContent.Add(dr["Date"].ToString().Substring(0, 10) + " - " + dr["ProjectCode"] + " - " + dr["ExpenseCode"] + " - " + dr["ExpName"] + " : " + String.Format("{0:0.00}", dr["Amount"]) + " EUR");  
                        nCounterTot++;
                        nCounterItem++;
                        sDataCurr = dr["date"].ToString().Substring(0,10);
                }
                
//              scrive l'ultimo item
                if (nCounterItem > 0)
                {
                    Response.Write("<li><h3>" + sDataCurr + "</h3><span class=ui-li-count>" + nCounterItem.ToString() + "</span><ul>");
                    foreach (string cursor in lExpContent)
                        Response.Write("<li>" + cursor + "</li>");
                    Response.Write("</ul></li>");
                }        
                
                conn.Close();                                          
%>
                </ul>

            </div> <!--/content-primary -->
       
        </form>  <!--/form-->
       
    
    </div> <!-- /page -->

</body>

</html>
