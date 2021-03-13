using System;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Owin;
using Owin;
using Microsoft.IdentityModel.Protocols.OpenIdConnect;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OpenIdConnect;
using System.Configuration;

public partial class defaultAspx : System.Web.UI.Page
{
	protected void Page_Load(object sender, EventArgs e)
	{
        string strSelect = "";
        LblErrorMessage.Text = "";

        if (!IsPostBack) {

            // recupera default
            string AuthType = Utilities.GetCookie("AuthType");

            if (AuthType == "" || AuthType == "AD")
                DDLTipoLogin.SelectedValue = "AD";
            else
            {
                DDLTipoLogin.SelectedValue = AuthType;
            }
        }

        // in caso di postback o quando arriva da redirect 302 da Azure AD                 
            if (IsPostBack || Request.IsAuthenticated)
            {

            Utilities.SetCookie("authType", DDLTipoLogin.SelectedValue); // salva tipo autenticazione didefault

            if (DDLTipoLogin.SelectedValue == "AD")
            {
                    if (Request.IsAuthenticated )
                        // autenticato da AD, recupero user con mail
                        strSelect = "SELECT * FROM persons WHERE active = 1 and mail = " + ASPcompatility.FormatStringDb(System.Security.Claims.ClaimsPrincipal.Current.FindFirst("preferred_username").Value);
                    else {
                        AzureADLogin();
                        return;
                    }
            }

            if (DDLTipoLogin.SelectedValue == "LL") { 
                // recupero user con user / pwd  
                strSelect = "SELECT * FROM persons WHERE userId=" + ASPcompatility.FormatStringDb(TBusername.Text) +
                             " AND password=" + ASPcompatility.FormatStringDb(TBpassword.Text);
            }

            var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))

            {

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

                            if (DDLTipoLogin.SelectedValue == "LL")
                                LblErrorMessage.Text = "login errata";
                            else
                                LblErrorMessage.Text = "Utente " + System.Security.Claims.ClaimsPrincipal.Current.FindFirst("preferred_username").Value.ToString()  + " non abilitato, contattare amministrazione";

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
                strSelect = "SELECT * FROM Options";
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
            DataTable dtApprovalManagerList = null;

            if (Convert.ToInt32(Session["ForcedAccount"]) != 0)  {
				//** A.1 Carica progetti possibili
				dtProgettiForzati = Database.GetData("SELECT DISTINCT v_Projects.Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType,ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM ForcedAccounts RIGHT JOIN v_Projects ON ForcedAccounts.Projects_id = v_Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" + Session["Persons_id"] + " OR v_Projects.Always_available = 1 ) AND v_Projects.active = 1 )  ORDER BY v_Projects.ProjectCode", this.Page);

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
				dtProgettiForzati = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM v_Projects WHERE active = 1 ORDER BY ProjectCode", this.Page);
				//** B.2 tutte le spese attive 							
                dtSpeseForzate = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode", this.Page);
            }

        Session["dtProgettiForzati"] = dtProgettiForzati;
        Session["dtSpeseForzate"] = dtSpeseForzate;
        Session["NoExpenses"] = dtSpeseForzate.Rows.Count == 0 ? "true" : "false";

        // Carica Manager per approvazione ore
        dtApprovalManagerList = Database.GetData("SELECT persons_id, name, mail FROM Persons WHERE active=1 AND (roles_id = 1 OR roles_id=2) ORDER BY Name" , this.Page); 
        Session["dtApprovalManagerList"] = dtApprovalManagerList;

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

        // inizializza oggetto sessione 04.2020
        TRSession CurrentSession = new TRSession(Convert.ToInt32(Session["persons_id"]));
        Session["CurrentSession"] = CurrentSession;

        // lancia il menu principale
        LblErrorMessage.Text = "";

        Response.Redirect("/timereport/menu.aspx");

        } // Ispostbak

	} // page_load

//** Variabili di sessioni
	protected void ValorizzaSessionVar(DataRow rdr) {

        // valorizza dati manager legati alla persona
        DataRow drRecord = Database.GetRow("SELECT Name, Mail from Persons WHERE persons_id= " + ASPcompatility.FormatStringDb(rdr["Manager_id"].ToString()), this.Page);
        if (drRecord != null) {
            Session["ApprovalManager_id"] = Convert.ToInt16(rdr["Manager_id"].ToString()); // usato in Jquery per post
            Session["ApprovalManagerName"] = drRecord["Name"].ToString(); ; // usato in Jquery per post
            Session["ApprovalManagerMail"] = drRecord["Mail"].ToString(); ; // usato in Jquery per post
        }

        // valorizza variabili di sessione
        Session["UserLevel"] = rdr["UserLevel_ID"];
		Session["UserId"] = rdr["UserId"].ToString();
		Session["UserName"] = rdr["Name"];
		Session["persons_id"] = rdr["persons_id"];
        Session["calendar_id"] = rdr["calendar_id"];
        Session["nickname"] = rdr["nickname"];
		Session["ColorScheme"] = rdr["ColorScheme"];
        Session["ContractHours"] = rdr["ContractHours"];
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
        Utilities.SetCookie("lingua", rdr["Lingua"].ToString());
	}

    // Azure Login
    protected void AzureADLogin() 
    {

        if (!Request.IsAuthenticated)
        {
            HttpContext.Current.GetOwinContext().Authentication.Challenge(
                new AuthenticationProperties { RedirectUri = ConfigurationManager.AppSettings["redirectUri"] },
                OpenIdConnectAuthenticationDefaults.AuthenticationType);

        }

    }

}

