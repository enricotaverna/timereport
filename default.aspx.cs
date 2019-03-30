using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

public partial class defaultAspx : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{
        
        if ( Request["user"] != null )
				TBusername.Text = Request["user"].ToString();

		if (Request["password"] != null)
			TBpassword.Text = Request["password"].ToString();

		if (Request["debug"] != null) 
			Session["debug"] = Request["debug"].ToString();

        // in caso di postback                  

        if (IsPostBack)
        {

            var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))

            {
                string strSelect = "SELECT * FROM persons WHERE userId=" + ASPcompatility.FormatStringDb(TBusername.Text) +
                   " AND password=" + ASPcompatility.FormatStringDb(TBpassword.Text);
                var dtLogin = new DataTable();
                using (var da = new SqlDataAdapter(strSelect, connection))
                {
                    try
                    {
                        connection.Open(); // not necessarily needed in this case because DataAdapter.Fill does it otherwise 
                        da.Fill(dtLogin);
                        if (dtLogin.Rows.Count == 1)
                        {
                            var rwLogin = dtLogin.Rows[0];
                            // trovato, verifica che attivo

                            if (!(bool)rwLogin["active"])
                            {
                                LblErrorMessage.Text = "Utente non attivo";
                                return; // utente non attivo
                            }

                            ValorizzaSessionVar(rwLogin); // utente trovato, valorizza variabili di sessione
                        }
                        else
                        {
                            LblErrorMessage.Text = "Login errata";
                            return; // utente non trovato 
                        }
                    }
                    catch (Exception ex)
                    {
                        // log this exception or throw it up the StackTrace
                        // we do not need a finally-block to close the connection since it will be closed implicitely in an using-statement
                        //Error message in  alert box
                        Response.Write("<script>alert('Error :" + ex.Message + "');</script>");
                    }
                }
            }

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                var strSelect = "SELECT * FROM Options";
                var dtOption = new DataTable();

                using (var da = new SqlDataAdapter(strSelect, connection))
                {
                    try
                    {
                        connection.Open(); // not necessarily needed in this case because DataAdapter.Fill does it otherwise 
                        da.Fill(dtOption);
                        if (dtOption.Rows.Count == 1)
                        {
                            var rwOption = dtOption.Rows[0];
                            Session["CutoffDate"] = Utilities.GetCutoffDate(rwOption["cutoffPeriod"].ToString(), rwOption["cutoffMonth"].ToString(), rwOption["cutoffYear"].ToString(), "end");

                        }
                        else
                        {
                            LblErrorMessage.Text = "File opzioni non trovato";
                            return; // utente non trovato 
                        }
                    }
                    catch (Exception ex)
                    {
                        // log this exception or throw it up the StackTrace
                        // we do not need a finally-block to close the connection since it will be closed implicitely in an using-statement
                        //Error message in  alert box
                        Response.Write("<script>alert('Error :" + ex.Message + "');</script>");
                    }
                }
            }
          
           // inizializza alcune variabili        
            Session["NoActive"] = 1;
			Session["NoPersActive"] = 1;

			// Carica spese e progetti possibili
			DataTable dtProgettiForzati = null;
            DataTable dtSpeseForzate = null;
            DataTable dtTipoSpesa = null;
				
			if (Convert.ToInt32(Session["ForcedAccount"]) != 0)  {
				//** A.1 Carica progetti possibili
				dtProgettiForzati = Database.GetData("SELECT DISTINCT Projects.Projects_Id, Projects.ProjectCode, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn  FROM ForcedAccounts RIGHT JOIN Projects ON ForcedAccounts.Projects_id = Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" + Session["Persons_id"] + " OR Projects.Always_available = 1 ) AND Projects.active = 1 )  ORDER BY Projects.ProjectCode", this.Page);

				//** A.2 Carica spese possibili				
				//** A.2.1 Prima verifica se il cliente ha un profilo di spesa	
                // carica spese forzate per persona                
                    dtSpeseForzate = Database.GetData("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ForcedExpensesPers.Persons_id = " + Session["Persons_id"] + " ORDER BY ExpenseType.ExpenseCode", this.Page);

                // se non ha trovato spese forzate sulla persona, a questo punto carica tutto
                    if (dtSpeseForzate.Rows.Count == 0) {   
                     //   dtSpeseForzate = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore,TipoBonus_Id FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode", this.Page);
                    }
                }
			else  {
				//** B.1 tutti i progetti attivi con flag di obbligatorietà messaggio		
				dtProgettiForzati = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn  FROM Projects WHERE active = 1 ORDER BY ProjectCode", this.Page);
				//** B.2 tutte le spese attive 							
                dtSpeseForzate = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode", this.Page);
            }

		Session["dtProgettiForzati"] = dtProgettiForzati;
        Session["dtSpeseForzate"] = dtSpeseForzate;
        Session["NoExpenses"] = dtSpeseForzate.Rows.Count == 0 ? "true" : "false";

        // Carica in buffer tipo spesa
        dtTipoSpesa = Database.GetData("Select ExpenseType_id, TipoBonus_id from ExpenseType", this.Page);
        Session["dtTipoSpesa"] = dtTipoSpesa;

        // *** carica autorizzazioni ***
        Auth.LoadPermission(Session["persons_id"].ToString());

		// forza il refresh del buffer delle spese
		Session["RefreshRicevuteBuffer"] = "refresh";

        // *** Carica datatable con giorni di ferie        
        MyConstants.DTHoliday.Clear();
        MyConstants.DTHoliday = Database.GetData("SELECT calDay FROM CalendarHolidays Where Calendar_id = " + Convert.ToInt16(Session["calendar_id"]), this.Page);
          
		MyConstants.DTHoliday.PrimaryKey = new DataColumn[] { MyConstants.DTHoliday.Columns["calDay"] };
		//*** Carica datatable con giorni di ferie (FINE)   

        // lancia il menu principale
		LblErrorMessage.Text = "";

            Response.Redirect("/timereport/menu.aspx");
            //Response.Redirect("/timereport/report/EstraiRevenue/ReportRevenue.aspx");

        } // Ispostbak

	} // page_load

//** Variabili di sessioni
	protected void ValorizzaSessionVar(DataRow rdr) {
		
		//rdr.Read();

		// valorizza variabili di sessione
		Session["UserLevel"] = rdr["UserLevel_ID"];
		Session["UserId"] = rdr["UserId"].ToString();
		Session["UserName"] = rdr["Name"];
		Session["persons_id"] = rdr["persons_id"];
        Session["calendar_id"] = rdr["calendar_id"];
        Session["nickname"] = rdr["nickname"];
		Session["ColorScheme"] = rdr["ColorScheme"];
		Session["lingua"] = rdr["Lingua"];
		Session["BetaTester"] = string.IsNullOrEmpty(rdr["BetaTester"].ToString()) ? false :rdr["BetaTester"] ; // abilita nuove funzionalità
		Session["CartaCreditoAziendale"] = rdr["CartaCreditoAziendale"]; 

		// Manage forced account for subcontractors
		if (Convert.ToInt32(rdr["ForcedAccount"]) == 1)
			Session["ForcedAccount"] = 1;
		else
			Session["ForcedAccount"] = 0;
		Session["ExpensesProfile_id"] = rdr["ExpensesProfile_id"];

        // salva in cookie la preferenza di lingua
        HttpCookie myCookie = new HttpCookie("lingua");
		myCookie.Value = rdr["Lingua"].ToString();
		myCookie.Expires = DateTime.Now.AddYears(100);
		Response.Cookies.Add(myCookie);
	}
}

