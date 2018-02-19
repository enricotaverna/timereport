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
        if (IsPostBack)  {
         
            // se arrivo qui l'utente è stato riconosciuto, recupera userid
            string strSelect = "SELECT * FROM persons WHERE userId=" + ASPcompatility.FormatStringDb(TBusername.Text) +
		                       " AND password=" + ASPcompatility.FormatStringDb(TBpassword.Text);
            
            Database.OpenConnection();
            using (SqlDataReader rdr = Database.GetReader(strSelect, this.Page))
                {
                    if (rdr != null && rdr.HasRows)
                        ValorizzaSessionVar(rdr); // utente trovato, valorizza variabili di sessione
                    else {
                         LblErrorMessage.Text = "Login errata";
                         return; // utente non trovato 
                        }
            
                    // Utente non attivo
                if (!(bool)rdr["active"])
                {
                    LblErrorMessage.Text = "Utente non attivo";
                    return; // utente non trovato 
                }

            }
            
            // Utente trovato valorizza opzioni
             using (SqlDataReader rdr = Database.GetReader("SELECT * FROM Options", this.Page))
                {
                    if (rdr != null && rdr.HasRows){
                        rdr.Read();
                        Session["CutoffDate"] = Utilities.GetCutoffDate(rdr["cutoffPeriod"].ToString(), rdr["cutoffMonth"].ToString(), rdr["cutoffYear"].ToString(), "end");
                 }
                }
            
            // inizializza alcune variabili        
            Session["NoActive"] = 1;
            Session["NoPersActive"] = 1;

            // carica variabile di sessione con spese forzate
            // Carica spese e progetti possibili
            DataRowCollection ProgettiForzati;
            DataRowCollection SpeseForzate;
				
            if (Session["ForcedAccount"] != "")  {
                //** A.1 Carica progetti possibili
                // Right join: includes all the forced projects plus the ones with the flag always_available on							
                ProgettiForzati = ASPcompatility.GetRows("SELECT Projects.Projects_Id, Projects.ProjectCode, Projects.Name,  Projects.Always_available FROM ForcedAccounts RIGHT JOIN Projects ON ForcedAccounts.Projects_id = Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" + Session["Persons_id"] + " OR Projects.Always_available = 1 ) AND Projects.active = 1 )  ORDER BY Projects.ProjectCode");

                //** A.2 Carica spese possibili				
                if ( Convert.ToInt32(Session["ExpensesProfile_id"]) > 0)  
                    //** A.2.1 Prima verifica se il cliente ha un profilo di spesa	
                    SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesProf RIGHT JOIN ExpenseType ON ForcedExpensesProf.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesProf.ExpensesProfile_id=" + Session["ExpensesProfile_id"] + " ) ) ORDER BY ExpenseType.ExpenseCode");
                else {
                    //** A.2.2 Poi cerca spese specifiche per persona			
                    SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesPers.Persons_id=" + Session["Persons_id"] + " ) ) ORDER BY ExpenseType.ExpenseCode");
                
                    //** A.2.2.1 Siamo alla fine, non ha trovato spese forzate sulla persona, a questo punto
                    //carica tutto
                    if (SpeseForzate.ToString() == "")  
                        SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType_Id, ExpenseCode, Name FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode");               
                }
            }
            else  {
                //** B.1 tutti i progetti attivi		
                ProgettiForzati = ASPcompatility.GetRows("SELECT Projects_Id, ProjectCode, Name  FROM Projects WHERE active = 1 ORDER BY ProjectCode");
                //** B.2 tutte le spese attive 							
                SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType_Id, ExpenseCode, Name  FROM ExpenseType WHERE active=1");
            }
        
        Session["ProgettiForzati"] = ProgettiForzati;
        Session["SpeseForzate"] = SpeseForzate;

        // *** carica autorizzazioni ***
        Auth.LoadPermission(Session["persons_id"].ToString());

        // forza il refresh del buffer delle spese
        Session["RefreshRicevuteBuffer"] = "refresh";   
        
        // *** Carica datatable con giorni di ferie        
        MyConstants.DTHoliday.Clear();
                
        using (SqlConnection c = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
	    {
		c.Open();
        SqlCommand cmd = new SqlCommand("SELECT Holiday_date FROM Holiday", c);
		using (SqlDataAdapter dad = new SqlDataAdapter(cmd))
             dad.Fill(MyConstants.DTHoliday);
        }

        MyConstants.DTHoliday.PrimaryKey = new DataColumn[] { MyConstants.DTHoliday.Columns["Holiday_date"] };
            //*** Carica datatable con giorni di ferie (FINE)   

            // lancia il menu principale
                LblErrorMessage.Text = "";  
                Response.Redirect("/timereport/menu.aspx");

        } // Ispostbak

    } // page_load

//** Variabili di sessioni
    protected void ValorizzaSessionVar(SqlDataReader rdr) {
        
        rdr.Read();

        // valorizza variabili di sessione
        Session["UserLevel"] = rdr["UserLevel_ID"];
        Session["UserId"] = rdr["UserId"].ToString();
        Session["UserName"] = rdr["Name"];
        Session["persons_id"] = rdr["persons_id"];
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

