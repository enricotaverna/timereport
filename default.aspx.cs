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
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        string strSelect = "";
        LblErrorMessage.Text = "";

        if (!IsPostBack)
        {

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
                if (Request.IsAuthenticated)
                    // autenticato da AD, recupero user con mail
                    strSelect = "SELECT * FROM persons WHERE active = 1 and mail = " + ASPcompatility.FormatStringDb(System.Security.Claims.ClaimsPrincipal.Current.FindFirst("preferred_username").Value);
                else
                {
                    AzureADLogin();
                    return;
                }
            }

            if (DDLTipoLogin.SelectedValue == "LL")
            {
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
                                LblErrorMessage.Text = "Utente " + System.Security.Claims.ClaimsPrincipal.Current.FindFirst("preferred_username").Value.ToString() + " non abilitato, contattare amministrazione";

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
            //DataTable dtProgettiForzati = null;
            //DataTable dtSpeseForzate = null;
            DataTable dtTipoSpesa = null;
            DataTable dtApprovalManagerList = null;

            // Carica Manager per approvazione ore
            dtApprovalManagerList = Database.GetData("SELECT persons_id, name, mail FROM Persons WHERE active=1 AND (roles_id = 1 OR roles_id=2) ORDER BY Name", this.Page);
            Session["dtApprovalManagerList"] = dtApprovalManagerList;

            // Carica in buffer tipo spesa
            dtTipoSpesa = Database.GetData("Select ExpenseType_id, TipoBonus_id, AdditionalCharges from ExpenseType", this.Page);
            Session["dtTipoSpesa"] = dtTipoSpesa;

            // *** carica autorizzazioni ***
            Auth.LoadPermission(CurrentSession.Persons_id);

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

        } // Ispostbak

    } // page_load

    //** Variabili di sessioni
    protected void ValorizzaSessionVar(DataRow rdr)
    {

        // valorizza dati manager legati alla persona
        DataRow drRecord = Database.GetRow("SELECT Name, Mail from Persons WHERE persons_id= " + ASPcompatility.FormatStringDb(rdr["Manager_id"].ToString()), this.Page);
        if (drRecord != null)
        {
            Session["ApprovalManager_id"] = Convert.ToInt16(rdr["Manager_id"].ToString()); // usato in Jquery per post
            Session["ApprovalManagerName"] = drRecord["Name"].ToString(); ; // usato in Jquery per post
            Session["ApprovalManagerMail"] = drRecord["Mail"].ToString(); ; // usato in Jquery per post
        }

        // valorizza variabili di sessione
        Session["UserLevel"] = rdr["UserLevel_ID"];
        Session["UserId"] = rdr["UserId"].ToString();
        Session["UserName"] = rdr["Name"]; 
//      Session["persons_id"] = rdr["persons_id"];
        Session["calendar_id"] = rdr["calendar_id"];
        Session["lingua"] = rdr["Lingua"];
        Session["BetaTester"] = string.IsNullOrEmpty(rdr["BetaTester"].ToString()) ? false : rdr["BetaTester"]; // abilita nuove funzionalità
        Session["CartaCreditoAziendale"] = rdr["CartaCreditoAziendale"];

        // Manage forced account for subcontractors
        if (Convert.ToInt32(rdr["ForcedAccount"]) == 1)
            Session["ForcedAccount"] = 1;
        else
            Session["ForcedAccount"] = 0;
        Session["ExpensesProfile_id"] = rdr["ExpensesProfile_id"];

        // salva in cookie la preferenza di lingua
        Utilities.SetCookie("lingua", rdr["Lingua"].ToString());

        // inizializza oggetto sessione 04.2020
        CurrentSession = new TRSession(Convert.ToInt32(rdr["persons_id"].ToString()));
        Session["CurrentSession"] = CurrentSession;
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

