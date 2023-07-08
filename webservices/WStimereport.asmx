<%@ WebService Language="C#" Class="WStimereport" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WStimereport : System.Web.Services.WebService
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    public WStimereport()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //  **** CANCELLA FILE ***** 
    // Riceve in input il nome file in format Web e cancella fisicamente il file dalla directory   
    [WebMethod(EnableSession = true)]
    public string cancella_file(string sfilename)
    {

        try
        {
            File.Delete(Server.MapPath(sfilename));
        }
        catch (IOException copyError)
        {
            // error
            return ("1");
        }


        // dopo aver cancellato forza il refresh del buffer usato per stampare l'icona della ricevuta su input.aspx
        Session["RefreshRicevuteBuffer"] = "refresh";
        return ("0");

    }

    //  **** CANCELLA ITEM ***** 
    // Richiamata da input.aspx, cancella record di ore/spese
    // ret[0] = "true", "false"
    // ret[1] = aaaammdd solo in caso di spese
    //
    [WebMethod(EnableSession = true)]
    public string[] CancellaId(string Id)
    {

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        string[] sRet = new string[2]; // parametri tornati dalla funzione

        switch (Session["type"].ToString())
        {

            case "hours":

                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM hours WHERE hours_id='" + Id + "'", connection))
                    {
                        try
                        {
                            connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                            cmd.ExecuteNonQuery();
                            sRet[0] = "true";
                            sRet[1] = "";
                        }
                        catch (Exception ex)
                        {
                            sRet[0] = "false";
                            sRet[1] = "";
                        }
                    }
                }

                break;

            case "expenses":
            case "bonus":

                DataRow drRec = Database.GetRow("SELECT date FROM expenses WHERE expenses_id='" + Id + "'", null);
                string sDate = drRec["date"].ToString();
                sDate = sDate.Substring(6, 4) + sDate.Substring(3, 2) + sDate.Substring(0, 2); // formato YYYYMMGG

                // cancella record da DB
                try
                {
                    Database.ExecuteSQL("DELETE FROM expenses WHERE expenses_id='" + Id + "'", null);

                    string[] filePaths = TrovaRicevuteLocale(Id, CurrentSession.UserName, sDate);

                    if (filePaths != null)
                    {
                        for (int i = 0; i < filePaths.Length; i++) // cancella file
                            File.Delete(filePaths[i]);
                    }

                    sRet[0] = "true";
                    sRet[1] = "";

                    if (Session["type"].ToString() == "bonus")
                        sRet[1] = sDate;
                }
                catch (IOException e)
                {
                    // error
                    sRet[0] = "false";
                    sRet[1] = "";
                }

                break;

        }

        return sRet;
    }

    // Crea CostRateAnno
    // Richiamata da finestra modale su lista CostRateAnno_list
    [WebMethod(EnableSession = true)]
    public void CreaCostRateAnno(string sPersonsId, string sAnno, float fCostRate, string sComment)
    {

        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        // se presente un record per la stessa chiave lo cancella       
        string cmdText = "DELETE FROM PersonsCostRate WHERE " +
                  " Persons_id = '" + sPersonsId + "' AND " +
                  " Anno = '" + sAnno + "'; ";

        // crea nuovo record
        cmdText = cmdText + "INSERT INTO PersonsCostRate (Persons_id, Anno, CostRate, Comment) " +
                  "values ( '" + sPersonsId + "' ," +
                            "'" + sAnno + "' ," +
                            "'" + fCostRate + "' ," +
                            "'" + sComment + "' )";
        Database.ExecuteSQL(cmdText, null);

        return;
    }

    //  **** CREA TICKET ***** 
    // Richiamata da input.aspx - vista bonus, inserisce ticket restaurant al click sull'icona
    [WebMethod(EnableSession = true)]
    public int CreaTicket(string personsId, string insDate)
    {

        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        int newIdentity = 0;

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        // recupera manager ed account del progetto
        var result = Utilities.GetManagerAndAccountId(Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_PROJECT"]));

        // recupera conversion rate associata al tipo spesa
        DataTable dtTipoSpesa = CurrentSession.dtSpeseTutte;
        DataRow[] dr = dtTipoSpesa.Select("ExpenseType_id =  " + ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"]);
        if (dr.Count() != 1)
        { // non dovrebbe mai succedere! 
        }

        // insDate ha formato yyyymmdd
        string convertDate = insDate.Substring(6, 2) + "/" + insDate.Substring(4, 2) + "/" + insDate.Substring(0, 4);

        string cmdText = "INSERT INTO expenses (Date, Projects_Id,Persons_Id,ExpenseType_Id,amount,comment,CreditCardPayed, CompanyPayed, CancelFlag,InvoiceFlag,CreatedBy,CreationDate,TipoBonus_id, ClientManager_id, AccountManager_id, Company_id, AdditionalCharges, AmountInCurrency) " +
                  "values (" +
                  ASPcompatility.FormatDateDb(convertDate, false) + " ," +
                  "'" + ConfigurationManager.AppSettings["TICKET_REST_PROJECT"] + "' ," +
                  "'" + CurrentSession.Persons_id + "' ," +
                  "'" + ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"] + "' ," +
                  "'1' ," +
                  "'' ," +
                  "'false' ," +
                  "'false' ," +
                  "'false' ," +
                  "'false' ," +
                  "'" + CurrentSession.UserId + "' ," +
                  ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " ," +
                  "'" + ConfigurationManager.AppSettings["TIPO_BONUS_TKTREST"] + "', " +
                  ASPcompatility.FormatNumberDB(result.Item1) + " , " +
                  ASPcompatility.FormatNumberDB(result.Item2) + " , " +
                  ASPcompatility.FormatNumberDB(CurrentSession.Company_id) + " , " +
                  "'false' , " +
                 ASPcompatility.FormatNumberDB(Convert.ToDouble(dr[0]["ConversionRate"].ToString())) +
                  " )";

        Database.ExecuteSQL(cmdText, null);

        // recupera record Id creato 
        newIdentity = Database.GetLastIdInserted("SELECT MAX(Expenses_id) from Expenses where Persons_Id=" + personsId);

        return newIdentity;
    }

    [WebMethod(EnableSession = true)]
    public string CheckPassword(string sUserName, string sPassword)
    {
        if (Database.RecordEsiste("SELECT * FROM Persons WHERE Persons_id = " + sUserName + " AND password='" + sPassword + "'"))
            return ("true");
        else
            return ("false");
    }

    [WebMethod(EnableSession = true)]
    public bool CheckExistence(string sKey, string sValkey, string sTable)
    {
        bool bRet = false;
        DataRow drRow = Database.GetRow("SELECT * FROM " + sTable + " WHERE " + sKey + "='" + sValkey + "'", null);

        if (drRow != null)
            bRet = true;
        else
            bRet = false;

        return (bRet);
    }

    [WebMethod(EnableSession = true)]
    public string CheckCaricoSpesa(int projects_id, int persons_id, string date)
    {
        string retMessage = "";
        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        // se torna una stringa diversa da "" emette un messaggio di avvertimento sul form inputspese.aspx
        if (!Database.RecordEsiste("Select hours_id , projects_id from Hours where projects_id= " + ASPcompatility.FormatNumberDB(projects_id) + 
                                    " AND date = " + ASPcompatility.FormatDateDb(date) +
                                    " AND persons_id = " + ASPcompatility.FormatNumberDB(persons_id)
                                    ))
            retMessage = CurrentSession.Language == "en" ? "Check: For the date no corresponding hours exists for this project" : "Attenzione: In questa data non è presente nessun carico ore per questo progetto";

        if (!Database.RecordEsiste("Select hours_id , projects_id from Hours where date = " + ASPcompatility.FormatDateDb(date) + " AND persons_id = " + ASPcompatility.FormatNumberDB(persons_id) ) )
            retMessage = CurrentSession.Language == "en" ? "Check: Hour record does not exist for this date" : "Non esiste un carico ore in questa data";

        return retMessage;

    }

    // riceve in input id spesa, nome user, data spesa (YYYYMMGG) e restutuisce array con nome file
    // Se id spesa = -1 allora estrae tutte le spese del mese per l'utente
    public static string[] TrovaRicevuteLocale(string sId, string sUserName, string sData)
    {

        string[] filePaths = null;

        try
        {
            // costruisci il pach di ricerca: public + anno + mese + nome persona 
            string TargetLocation = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sData.Substring(0, 4) + "\\" + sData.Substring(4, 2) + "\\" + sUserName + "\\";
            // carica immagini
            filePaths = Directory
                        .GetFiles(TargetLocation, "fid-" + sId + "*.*")
                        .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                        .ToArray();
            return (filePaths);
        }
        catch (Exception e)
        {
            //non fa niente ma evita il dump
            return (null);
        }

    }

    // ************ PROCESS DRAG & DROP ******************
    // 10/2018
    // se ok restituisce la stringa da appendere per far comparire la spesa/ora droppata
    [WebMethod(EnableSession = true)]
    public string[] ProcessDragDrop(string sId, string sInsDate)
    {

        string[] aRet = new string[2]; // parametri tornati dalla funzione
        int newIdentity;
        DataTable dt;
        string strAccountingDate = "";

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        // se TR è chiuso esce
        if (!Convert.ToBoolean(Session["InputScreenChangeMode"]))
            return aRet;

        switch (Session["type"].ToString())
        {

            case "hours":
                dt = Database.GetData("SELECT a.projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, b.ProjectCode, a.WorkedInRemote, a.LocationKey, a.LocationType, a.LocationDescription, a.ClientManager_id, a.AccountManager_id, a.Company_id, a.OpportunityId " +
                                               "FROM hours AS a " +
                                               "INNER JOIN Projects AS b ON  b.Projects_id = a.Projects_id " +
                                               "WHERE hours_id=" + sId, null);

                if (dt.Rows.Count == 0)
                    aRet = null; // dovrebbe sempre esistere

                // formata alcuni campi per successiva scrittura                            
                Double iHours = Convert.ToDouble(dt.Rows[0]["hours"]);
                strAccountingDate = dt.Rows[0]["AccountingDate"].ToString() == "" ? "null" : ASPcompatility.FormatDateDb(dt.Rows[0]["AccountingDate"].ToString(), false);

                // scrive il record copia!
                Database.ExecuteSQL("INSERT INTO hours (date, projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, WorkedInRemote, LocationKey, LocationType, LocationDescription, createdBy, creationDate, ClientManager_id, AccountManager_id, Company_id, OpportunityId ) VALUES(" +
                                     ASPcompatility.FormatDateDb(sInsDate, false) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["projects_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()) + " , " +
                                     ASPcompatility.FormatNumberDB(iHours) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["hourType_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["CancelFlag"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["TransferFlag"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["Activity_id"].ToString()) + " , " +
                                     strAccountingDate + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["comment"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["WorkedInRemote"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["LocationKey"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["LocationType"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["LocationDescription"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                                     ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["ClientManager_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["AccountManager_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["Company_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["OpportunityId"].ToString()) + " )"
                                    , null);

                // recupera record Id creato 
                newIdentity = Database.GetLastIdInserted("SELECT MAX(hours_id) FROM hours WHERE Persons_Id=" + ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()));

                // valorizza parametri di ritorno
                aRet[0] = dt.Rows[0]["ProjectCode"].ToString() + " : " + iHours.ToString() + " ore";
                aRet[1] = newIdentity.ToString();

                break;

            case "expenses":
            case "bonus":

                // leggi record da copiare
                dt = Database.GetData("SELECT a.projects_id, persons_id, Amount, a.ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, a.TipoBonus_id, AccountingDate, comment, b.ProjectCode, c.ExpenseCode, c.UnitOfMeasure, a.ClientManager_id, a.AccountManager_id, a.Company_id, a.AdditionalCharges, a.AmountInCurrency, a.OpportunityId " +
                                                "FROM Expenses AS a " +
                                                "INNER JOIN Projects AS b ON  b.Projects_id = a.Projects_id " +
                                                "INNER JOIN ExpenseType AS c ON  c.ExpenseType_id = a.ExpenseType_id " +
                                                "WHERE Expenses_id=" + sId, null);

                if (dt.Rows.Count == 0)
                    aRet = null; // dovrebbe sempre esistere

                // formata alcuni campi per successiva scrittura                            
                double iAmount = Convert.ToDouble(dt.Rows[0]["Amount"]);
                strAccountingDate = dt.Rows[0]["AccountingDate"].ToString() == "" ? "null" : ASPcompatility.FormatDateDb(dt.Rows[0]["AccountingDate"].ToString(), false);

                // scrive il record copia!
                Database.ExecuteSQL("INSERT INTO Expenses (date, projects_id, persons_id, Amount, ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, TipoBonus_id,AccountingDate, comment, createdBy, creationDate, ClientManager_id, AccountManager_id, Company_id, AdditionalCharges, AmountInCurrency, OpportunityId) VALUES(" +
                                     ASPcompatility.FormatDateDb(sInsDate, false) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["projects_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()) + " , " +
                                     ASPcompatility.FormatNumberDB(iAmount) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["ExpenseType_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["CancelFlag"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["CreditCardPayed"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["CompanyPayed"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["InvoiceFlag"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["TipoBonus_id"].ToString()) + " , " +
                                     strAccountingDate + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["comment"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                                     ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["ClientManager_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["AccountManager_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["Company_id"].ToString()) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["AdditionalCharges"].ToString()) + " , " +
                                     ASPcompatility.FormatNumberDB(Convert.ToDouble(dt.Rows[0]["AmountInCurrency"].ToString())) + " , " +
                                     ASPcompatility.FormatStringDb(dt.Rows[0]["OpportunityId"].ToString()) +
                                     " )"
                                    , null);

                // recupera record Id creato 
                newIdentity = Database.GetLastIdInserted("SELECT MAX(Expenses_id) from Expenses where Persons_Id=" + ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()));

                DataRow drRec = Database.GetRow("SELECT ExpenseCode, UnitOfMeasure FROM ExpenseType WHERE ExpenseType_id=" + ASPcompatility.FormatStringDb(dt.Rows[0]["ExpenseType_id"].ToString()), null);

                // valorizza parametri di ritorno
                aRet[0] = dt.Rows[0]["ProjectCode"].ToString() + ":" + drRec["ExpenseCode"] + " : " + iAmount.ToString() + " " + drRec["UnitOfMeasure"];
                aRet[1] = newIdentity.ToString();

                break;

        }

        return aRet;
    }
}
    