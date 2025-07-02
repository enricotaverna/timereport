<%@ WebService Language="C#" Class="WS_DBUpdates" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.IO;

/// <summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_DBUpdates : System.Web.Services.WebService
{

    public TRSession CurrentSession;

    public class AjaxCallResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string RecordHtmlText { get; set; }
        public int RecordId { get; set; }
    }

    public WS_DBUpdates()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public bool SaveHours(int Hours_Id,
                            string Date, // "DD/MM/AAAA"
                            double Hours,
                            int Person_Id,
                            int Project_Id,
                            int Activity_Id,
                            string Comment,
                            bool CancelFlag,
                            string LocationKey,
                            string LocationDescription,
                            string OpportunityId,
                            string AccountingDate, // "DD/MM/AAAA"
                            string SalesforceTaskID)
    {
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        // salva default per select list
        Session["ProjectCodeDefault"] = Project_Id.ToString();
        Session["ActivityDefault"] = Activity_Id.ToString();
        Session["LocationDefault"] = LocationKey.ToString();
        Session["OpportunityDefault"] = OpportunityId.ToString();

        // recupera società e manager
        DataRow drPerson = Database.GetRow("SELECT company_id FROM Persons WHERE Persons_id = " + ASPcompatility.FormatNumberDB(Person_Id), null);
        // recupera anagrafica progetto
        DataRow drProject = Database.GetRow("SELECT ClientManager_id, AccountManager_id  FROM Projects WHERE Projects_id = " + ASPcompatility.FormatNumberDB(Project_Id), null);

        string LocationType = null;
        string LocationKeyFormatted = null;

        if (!string.IsNullOrEmpty(LocationKey))
        {
            LocationType = LocationKey.Substring(0, 1) == "9" ? "T" : LocationKey.Substring(0, 1);
            LocationKeyFormatted = LocationKey.Substring(0, 1) == "9" ? LocationKey : LocationKey.Substring(2);
        }
        else {
            LocationDescription = LocationDescription == ""  ? null : LocationDescription ; // se il progetto non prevede location rende null anche la descrizione che viene passata a space
        }

        string SQLHours = "";
        string SQLUpdateForcedAccountOld = "";
        string SQLUpdateForcedAccountNew = "";

        // creazione                
        if (Hours_Id == 0)
        {
            SQLHours = "INSERT INTO Hours " +
                    "(Date, " +
                    "Projects_Id, " +
                    "Activity_Id, " +
                    "Persons_Id, " +
                    "HourType_Id, " +
                    "Hours, " +
                    "comment, " +
                    "CancelFlag, " +
                    "Company_id, " +
                    "AccountManager_id, " +
                    "ClientManager_id, " +
                    "CreationDate, " +
                    "CreatedBy, " +
                    "LocationKey, " +
                    "LocationType, " +
                    "LocationDescription, " +
                    "OpportunityId, " +
                    "AccountingDate, " +
                    "SalesforceTaskID) " +
                    "VALUES ( " +
                    ASPcompatility.FormatDateDb(Date) + ", " +
                    ASPcompatility.FormatNumberDB(Project_Id) + ", " +
                    ASPcompatility.FormatNumberDB(Activity_Id) + ", " +
                    ASPcompatility.FormatNumberDB(Person_Id) + ", " +
                    ASPcompatility.FormatNumberDB(1) + ", " +
                    ASPcompatility.FormatNumberDB((CancelFlag == true ? -1 : 1) * Hours) + ", " +
                    ASPcompatility.FormatStringDb(Comment) + ", " +
                    ASPcompatility.FormatNumberDB((CancelFlag == true ? 1 : 0)) + ", " +
                    ASPcompatility.FormatNumberDB(Convert.ToInt32(drPerson["Company_id"])) + ", " +
                    ASPcompatility.FormatNumberDB(Convert.ToInt32(drProject["AccountManager_id"])) + ", " +
                    ASPcompatility.FormatNumberDB(Convert.ToInt32(drProject["ClientManager_id"])) + ", " +
                    ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " +
                    ASPcompatility.FormatStringDb(CurrentSession.UserId) + ", " +
                    ASPcompatility.FormatStringDb(LocationKeyFormatted) + ", " +
                    ASPcompatility.FormatStringDb(LocationType) + ", " +
                    ASPcompatility.FormatStringDb(LocationDescription) + ", " +
                    (string.IsNullOrEmpty(OpportunityId) ? "NULL" : ASPcompatility.FormatStringDb(OpportunityId)) + ", " +
                    (string.IsNullOrEmpty(AccountingDate) ? "NULL" : ASPcompatility.FormatDateDb(AccountingDate)) + ", " +
                    ASPcompatility.FormatStringDb(SalesforceTaskID) + " )";

            // aggiorna i Daysactual
            string DaysWithSign = Convert.ToString((CancelFlag == true ? -1 : 1) * Hours / 8).Replace(",", ".");
            SQLUpdateForcedAccountNew = "UPDATE ForcedAccounts SET DaysActual = COALESCE(DaysActual, 0) + " + DaysWithSign + " WHERE Persons_id = " + ASPcompatility.FormatNumberDB(Person_Id) + " AND Projects_id = " + ASPcompatility.FormatNumberDB(Project_Id);
        }
        // aggiornamento
        if (Hours_Id != 0)
        {
            SQLHours = "UPDATE Hours SET " +
                               "Projects_Id = " + ASPcompatility.FormatNumberDB(Project_Id) + " ," +
                               "Activity_Id = " + ASPcompatility.FormatNumberDB(Activity_Id) + " ," +
                               "Persons_Id =" + ASPcompatility.FormatNumberDB(Person_Id) + " ," +
                               "Hours = " + ASPcompatility.FormatNumberDB((CancelFlag == true ? -1 : 1) * Hours) + " ," +
                               "comment = " + ASPcompatility.FormatStringDb(Comment) + " ," +
                               "CancelFlag = " + ASPcompatility.FormatNumberDB((CancelFlag == true ? 1 : 0)) + " ," +
                               "Company_id = " + ASPcompatility.FormatNumberDB(Convert.ToInt32(drPerson["Company_id"])) + " ," +
                               "AccountManager_id = " + ASPcompatility.FormatNumberDB(Convert.ToInt32(drProject["AccountManager_id"])) + " ," +
                               "ClientManager_id = " + ASPcompatility.FormatNumberDB(Convert.ToInt32(drProject["ClientManager_id"])) + " ," +
                               "LastModificationDate = " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " +
                               "LastModifiedBy = " + ASPcompatility.FormatStringDb(CurrentSession.UserId) + ", " +
                               "LocationKey = " + ASPcompatility.FormatStringDb(LocationKeyFormatted) + " ," +
                               "LocationType = " + ASPcompatility.FormatStringDb(LocationType) + " ," +
                               "LocationDescription = " + ASPcompatility.FormatStringDb(LocationDescription) + " ," +
                               "OpportunityId = " + (string.IsNullOrEmpty(OpportunityId) ? "NULL" : ASPcompatility.FormatStringDb(OpportunityId)) + " ," +
                               "AccountingDate = " + (string.IsNullOrEmpty(AccountingDate) ? "NULL" : ASPcompatility.FormatDateDb(AccountingDate)) + " ," +
                               "SalesforceTaskID = " + ASPcompatility.FormatStringDb(SalesforceTaskID) +
                               " WHERE Hours_Id = " + ASPcompatility.FormatNumberDB(Hours_Id);

            // recepero vecchio valore di Hours per calcolare di quanto deve essere aggiornato ForcedHours
            DataRow drOldHours = Database.GetRow("SELECT Hours, Persons_id, Projects_id FROM Hours WHERE Hours_Id = " + ASPcompatility.FormatNumberDB(Hours_Id), null);

            double oldHours = Convert.ToDouble(drOldHours["Hours"]);
            string oldDays = Convert.ToString(oldHours / 8).Replace(",", ".");

            double newHours = (CancelFlag == true ? -1 : 1) * Hours;
            string newDays = Convert.ToString(newHours / 8).Replace(",", ".");

            // recupero vecchio valore di progetto / persona in caso sia cambiato
            SQLUpdateForcedAccountOld = "UPDATE ForcedAccounts SET DaysActual = COALESCE(DaysActual, 0) - " + oldDays + " WHERE Persons_id = " + ASPcompatility.FormatStringDb(drOldHours["Persons_id"].ToString()) + " AND Projects_id = " + ASPcompatility.FormatStringDb(drOldHours["Projects_id"].ToString());
            // NB: se il nuovo forced account non esiste l'istruzione update comunque non fallisce
            SQLUpdateForcedAccountNew = "UPDATE ForcedAccounts SET DaysActual = COALESCE(DaysActual, 0) + " + newDays + " WHERE Persons_id = " + ASPcompatility.FormatNumberDB(Person_Id) + " AND Projects_id = " + ASPcompatility.FormatNumberDB(Project_Id);
        }

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            conn.Open();
            SqlTransaction transaction = conn.BeginTransaction();

            try
            {
                SqlCommand cmdHours = new SqlCommand(SQLHours, conn, transaction);
                SqlCommand cmdUpdateOld = new SqlCommand(SQLUpdateForcedAccountOld, conn, transaction);
                SqlCommand cmdUpdateNew = new SqlCommand(SQLUpdateForcedAccountNew, conn, transaction);

                cmdHours.ExecuteNonQuery();
                if (Hours_Id != 0)
                    cmdUpdateOld.ExecuteNonQuery(); // modifica
                cmdUpdateNew.ExecuteNonQuery();

                transaction.Commit();
            }
            catch (Exception)
            {
                transaction.Rollback();
                return false;
            }
        }

        // ricarica progetti forzati
        CurrentSession.LoadProgettiForzati(Person_Id);

        return true;
    }

    public class SaveExpensesResult
    {
        public bool Success { get; set; }
        public int ExpensesId { get; set; }
    }

    //  ***** Aggiorna Spese ****   
    [WebMethod(EnableSession = true)]
    public SaveExpensesResult SaveExpenses(int Expenses_Id,
                               string Date, // "DD/MM/AAAA"
                               double ExpenseAmount,
                               int Person_Id,
                               int Project_Id,
                               int ExpenseType_Id,
                               string Comment,
                               bool CreditCardPayed,
                               bool CompanyPayed,
                               bool CancelFlag,
                               bool InvoiceFlag,
                               string strFileName,
                               string strFileData,
                               string OpportunityId,
                               string AccountingDate, // "DD/MM/AAAA"
                               string UserId = "")
    {
        SaveExpensesResult result = new SaveExpensesResult();
        int newIdentity = 0;
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        if (UserId == "") // quando chiamata da backend non riesce a recuperare le variabili di sessione
            UserId = CurrentSession.UserId;

        // salva default per select list
        Session["ProjectCodeDefault"] = Project_Id.ToString();
        Session["ExpenseDefault"] = ExpenseType_Id.ToString();
        Session["OpportunityDefault"] = OpportunityId.ToString();

        // ** SALVA IL RECORD **
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            try
            {
                conn.Open();

                // recupera flag AdditionalCharges
                DataRow dr = Database.GetRow("SELECT AdditionalCharges, ConversionRate, TipoBonus_Id FROM ExpenseType WHERE ExpenseType_id  = " + ASPcompatility.FormatNumberDB(ExpenseType_Id), null);
                DataRow dr1 = Database.GetRow("SELECT ClientManager_id, AccountManager_id FROM Projects WHERE Projects_id  = " + ASPcompatility.FormatNumberDB(Project_Id), null);
                DataRow dr2 = Database.GetRow("SELECT Company_id FROM Persons WHERE Persons_id  = " + ASPcompatility.FormatNumberDB(Person_Id), null);

                double dExpenseAmount = ((CancelFlag == true ? -1 : 1) * ExpenseAmount);
                int AdditionalCharges = Convert.ToBoolean(dr["AdditionalCharges"]) ? 1 : 0;
                string SQLCommand = "";

                // creazione                
                if (Expenses_Id == 0)
                {
                    SQLCommand = "INSERT INTO Expenses (Date, Projects_Id, Persons_Id, ExpenseType_Id, AdditionalCharges, TipoBonus_Id, amount, comment, createdBy, creationDate, CreditCardPayed, CompanyPayed, CancelFlag, InvoiceFlag, ClientManager_id, AccountManager_id, Company_id, AmountInCurrency, OpportunityId, AccountingDate) " +
                                      "VALUES (" + ASPcompatility.FormatDateDb(Date) + ", " +
                                      Project_Id + ", " +
                                      Person_Id + ", " +
                                      ExpenseType_Id + ", " +
                                      AdditionalCharges + ", " +
                                      dr["TipoBonus_Id"] + " , " +
                                      ASPcompatility.FormatNumberDB(dExpenseAmount) + ", " +
                                      "'" + Comment + "', " +
                                      ASPcompatility.FormatStringDb(UserId) + " , " +
                                      ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " , " +
                                      (CreditCardPayed ? 1 : 0) + ", " +
                                      (CompanyPayed ? 1 : 0) + ", " +
                                      (CancelFlag ? 1 : 0) + ", " +
                                      (InvoiceFlag ? 1 : 0) + ", " +
                                      dr1["ClientManager_id"] + ", " +
                                      dr1["AccountManager_id"] + ", " +
                                      dr2["Company_id"] + ", " +
                                      ASPcompatility.FormatNumberDB(dExpenseAmount * Convert.ToDouble(dr["ConversionRate"])) + ", " +
                                      (string.IsNullOrEmpty(OpportunityId) ? "NULL" : ASPcompatility.FormatStringDb(OpportunityId)) + ", " +
                                      (string.IsNullOrEmpty(AccountingDate) ? "NULL" : ASPcompatility.FormatDateDb(AccountingDate)) + ")";
                }
                else
                {
                    SQLCommand = "UPDATE Expenses SET " +
                                 "Date = " + ASPcompatility.FormatDateDb(Date) + ", " +
                                 "Projects_Id = " + Project_Id + ", " +
                                 "Persons_Id = " + Person_Id + ", " +
                                 "ExpenseType_Id = " + ExpenseType_Id + ", " +
                                 "AdditionalCharges = " + AdditionalCharges + ", " +
                                 "TipoBonus_Id = " + dr["TipoBonus_Id"] + ", " +
                                 "amount = " + ASPcompatility.FormatNumberDB(dExpenseAmount) + ", " +
                                 "comment = '" + Comment + "', " +
                                 "createdBy = " + ASPcompatility.FormatStringDb(UserId) + ", " +
                                 "creationDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + ", " +
                                 "CreditCardPayed = " + (CreditCardPayed ? 1 : 0) + ", " +
                                 "CompanyPayed = " + (CompanyPayed ? 1 : 0) + ", " +
                                 "CancelFlag = " + (CancelFlag ? 1 : 0) + ", " +
                                 "InvoiceFlag = " + (InvoiceFlag ? 1 : 0) + ", " +
                                 "ClientManager_id = " + dr1["ClientManager_id"] + ", " +
                                 "AccountManager_id = " + dr1["AccountManager_id"] + ", " +
                                 "Company_id = " + dr2["Company_id"] + ", " +
                                 "AmountInCurrency = " + ASPcompatility.FormatNumberDB(dExpenseAmount * Convert.ToDouble(dr["ConversionRate"])) + ", " +
                                 "OpportunityId = " + (string.IsNullOrEmpty(OpportunityId) ? "NULL" : ASPcompatility.FormatStringDb(OpportunityId)) + ", " +
                                 "AccountingDate = " + (string.IsNullOrEmpty(AccountingDate) ? "NULL" : ASPcompatility.FormatDateDb(AccountingDate)) +
                                 " WHERE Expenses_Id = " + Expenses_Id;
                }
                using (SqlCommand cmd = new SqlCommand(SQLCommand, conn))
                {
                    cmd.ExecuteNonQuery();
                }

                if (Expenses_Id == 0)
                {
                    // recupera chiave inserita 
                    SqlCommand sc = new SqlCommand("SELECT MAX(Expenses_id) from Expenses where Persons_Id=" + Person_Id, conn);
                    newIdentity = (int)sc.ExecuteScalar();
                }
                else
                    newIdentity = Expenses_Id; // lo stesso arrivato in input
            }
            catch (Exception)
            {
                result.Success = false;
                return result;
            }
        }

        if (strFileName.Trim() != "")
        {

            // *** SALVA IMMAGINE ***
            try
            {
                // costruisce il nome directory, formato data da chiamata WS AAAA-MM-GG    
                string TargetLocation = Server.MapPath(ConfigurationManager.AppSettings["PATH_RICEVUTE"]) + Date.Substring(6, 4) + "\\" + Date.Substring(3, 2) + "\\" + CurrentSession.UserName.Trim() + "\\";

                // se non esiste la directory la crea
                DirectoryInfo DITargetLocation = new DirectoryInfo(TargetLocation);
                if (!DITargetLocation.Exists)
                    DITargetLocation.Create();

                // costruisce il nome file     
                string ext = Path.GetExtension(strFileName);
                string FilePath = TargetLocation + "fid-" + (string)newIdentity.ToString() + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ext;

                using (FileStream fs = new FileStream(FilePath, FileMode.Create))
                {
                    using (BinaryWriter bw = new BinaryWriter(fs))
                    {
                        byte[] data = Convert.FromBase64String(strFileData);
                        bw.Write(data);
                        bw.Close();
                    }
                }
            }
            catch (Exception)
            {
                result.Success = false;
                return result;
            }
        }

        result.Success = true;
        result.ExpensesId = newIdentity;
        return result;
    }

    //  **** CANCELLA ITEM ***** 
    [WebMethod(EnableSession = true)]
    public AjaxCallResult DeleteRecord(string Id, string DeletionType)
    {
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];
        AjaxCallResult result = new AjaxCallResult();

        //CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        if (DeletionType == "hours")
        {

            DataRow drRec = Database.GetRow("SELECT projects_id, persons_id, Hours FROM Hours WHERE hours_id='" + Id + "'", null);
            string DayToUpdate = (Convert.ToDouble(drRec["hours"].ToString()) / 8).ToString().Replace(",", ".");

            string SQLdelete = "DELETE FROM hours WHERE hours_id='" + Id + "'";
            string SQLUpdateForcedAccounts = "UPDATE ForcedAccounts SET DaysActual = COALESCE(DaysActual, 0) -(" + DayToUpdate + ") WHERE Persons_id = " + ASPcompatility.FormatStringDb(drRec["persons_id"].ToString()) + " AND Projects_id = " + ASPcompatility.FormatStringDb(drRec["projects_id"].ToString());
            string SQLUpdateLog = "INSERT INTO LogDeletedRecords (RecordType, DeletedRecord_id, Timestamp) VALUES ('HOUR', " + Id + ", '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    SqlCommand cmdDelete = new SqlCommand(SQLdelete, conn, transaction);
                    SqlCommand cmdUpdateForcedAccounts = new SqlCommand(SQLUpdateForcedAccounts, conn, transaction);
                    SqlCommand cmdUpdateLog = new SqlCommand(SQLUpdateLog, conn, transaction);

                    cmdDelete.ExecuteNonQuery();
                    cmdUpdateForcedAccounts.ExecuteNonQuery();
                    cmdUpdateLog.ExecuteNonQuery();

                    transaction.Commit();

                    // ricarica progetti forzati
                    CurrentSession.LoadProgettiForzati(Convert.ToInt16(drRec["persons_id"].ToString()));

                    result.Success = true;
                    return result;
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    result.Success = false;
                    result.Message = "Errore in aggiornamento";
                    return result;
                }
            }
        }

        if (DeletionType == "expenses" | DeletionType == "tickets")
        {
            string SQLdelete = "DELETE FROM expenses WHERE expenses_id='" + Id + "'";
            string SQLUpdateLog = "INSERT INTO LogDeletedRecords (RecordType, DeletedRecord_id, Timestamp) VALUES ('EXPENSE', " + Id + ", '" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')";

            DataRow drRec = Database.GetRow("SELECT date FROM expenses WHERE expenses_id='" + Id + "'", null);
            string sDate = drRec["date"].ToString();
            sDate = sDate.Substring(6, 4) + sDate.Substring(3, 2) + sDate.Substring(0, 2); // formato YYYYMMGG

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    SqlCommand cmdDelete = new SqlCommand(SQLdelete, conn, transaction);
                    SqlCommand cmdUpdateLog = new SqlCommand(SQLUpdateLog, conn, transaction);

                    cmdDelete.ExecuteNonQuery();
                    cmdUpdateLog.ExecuteNonQuery();

                    transaction.Commit();

                    string[] filePaths = CommonFunction.TrovaRicevuteLocale(Id, CurrentSession.UserName, sDate);
                    if (filePaths != null)
                        for (int i = 0; i < filePaths.Length; i++) // cancella file
                            File.Delete(filePaths[i]);

                    if (DeletionType == "tickets")
                    {
                        result.Success = true;
                        result.RecordHtmlText = sDate; // serve per accendere l'icona del ticket
                        return result;
                    }
                    else
                    {
                        result.Success = true;
                        result.RecordHtmlText = "";
                        return result;
                    }
                }
                catch (Exception)
                {
                    transaction.Rollback();
                    result.Success = false;
                    result.Message = "Errore in aggiornamento";
                    return result;
                }
            }

        }
        result.Success = true;
        return result;
    }

    // ************ PROCESS DRAG & DROP ******************
    // 10/2018
    // se ok restituisce la stringa da appendere per far comparire la spesa/ora droppata
    [WebMethod(EnableSession = true)]
    public AjaxCallResult ProcessDragDrop(string sId, string sInsDate, string sessionType)
    {

        AjaxCallResult result = new AjaxCallResult();
        int newIdentity;
        DataTable dt;
        string strAccountingDate = "";

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        try
        {
            switch (sessionType)
            {

                case "hours":
                    dt = Database.GetData("SELECT a.projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, b.ProjectCode, a.WorkedInRemote, a.LocationKey, a.LocationType, a.LocationDescription, a.ClientManager_id, a.AccountManager_id, a.Company_id, a.OpportunityId, a.SalesforceTaskId " +
                                                   "FROM hours AS a " +
                                                   "INNER JOIN Projects AS b ON  b.Projects_id = a.Projects_id " +
                                                   "WHERE hours_id=" + sId, null);

                    if (dt.Rows.Count == 0)
                        return new AjaxCallResult { Success = false, Message = "Record non trovato." };

                    // formata alcuni campi per successiva scrittura
                    bool CancelFlag = Convert.ToBoolean(dt.Rows[0]["CancelFlag"].ToString());
                    Double iHours = Convert.ToDouble(dt.Rows[0]["hours"]) * (CancelFlag ? -1 : 1);

                    if (dt.Rows[0]["AccountingDate"].ToString() == "")
                        strAccountingDate = "";
                    else
                    {
                        DateTime accountingDate = Convert.ToDateTime(dt.Rows[0]["AccountingDate"]);
                        strAccountingDate = accountingDate.ToString("dd/MM/yyyy");
                    }

                    string locationKeyValue = dt.Rows[0]["LocationType"] != DBNull.Value ? dt.Rows[0]["LocationType"].ToString() + ":" + dt.Rows[0]["LocationKey"].ToString() : "";                   

                    bool ret = SaveHours(0, // Hours_id
                              sInsDate,  //string TbdateForHours,
                              iHours, //double TbHours,
                              Convert.ToInt32(dt.Rows[0]["persons_id"].ToString()), //int Person_Id,
                              Convert.ToInt32(dt.Rows[0]["projects_id"].ToString()), //int Projects_Id,
                              Convert.ToInt32(dt.Rows[0]["Activity_id"].ToString()),//int Activity_Id,
                              dt.Rows[0]["comment"].ToString(), //string Comment,
                              CancelFlag, //bool CancelFlag,
                              locationKeyValue, //string LocationKey,
                              dt.Rows[0]["LocationDescription"].ToString(), //string LocationDescription,
                              dt.Rows[0]["OpportunityId"].ToString(), //string OpportunityId,
                              strAccountingDate, //string AccountingDate,
                              dt.Rows[0]["SalesforceTaskId"].ToString()); //string SalesforceTaskID)

                    if (!ret)
                        return new AjaxCallResult { Success = false, Message = "Aggiornamento fallito." };

                    // recupera record Id creato 
                    newIdentity = Database.GetLastIdInserted("SELECT MAX(hours_id) FROM hours WHERE Persons_Id=" + ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()));

                    // valorizza parametri di ritorno
                    result.Success = true;
                    result.RecordHtmlText = dt.Rows[0]["ProjectCode"].ToString() + " : " + iHours.ToString() + " ore";
                    result.RecordId = newIdentity;
                    return result;

                case "expenses":
                case "tickets":

                    // leggi record da copiare
                    dt = Database.GetData("SELECT a.projects_id, persons_id, Amount, a.ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, a.TipoBonus_id, AccountingDate, comment, b.ProjectCode, c.ExpenseCode, c.UnitOfMeasure, a.ClientManager_id, a.AccountManager_id, a.Company_id, a.AdditionalCharges, a.AmountInCurrency, a.OpportunityId " +
                                                    "FROM Expenses AS a " +
                                                    "INNER JOIN Projects AS b ON  b.Projects_id = a.Projects_id " +
                                                    "INNER JOIN ExpenseType AS c ON  c.ExpenseType_id = a.ExpenseType_id " +
                                                    "WHERE Expenses_id=" + sId, null);

                    if (dt.Rows.Count == 0)
                        return new AjaxCallResult { Success = false, Message = "Record non trovato." };

                    // formata alcuni campi per successiva scrittura                            
                    double iAmount = Convert.ToDouble(dt.Rows[0]["Amount"]);

                    if (dt.Rows[0]["AccountingDate"].ToString() == "")
                        strAccountingDate = "";
                    else
                    {
                        DateTime accountingDate = Convert.ToDateTime(dt.Rows[0]["AccountingDate"]);
                        strAccountingDate = accountingDate.ToString("dd/MM/yyyy");
                    }

                    // salva il record usando SaveExpenses
                    SaveExpensesResult saveResult = SaveExpenses(
                        0, // Expenses_Id
                        sInsDate, // Date
                        iAmount, // ExpenseAmount
                        Convert.ToInt32(dt.Rows[0]["persons_id"]), // Person_Id
                        Convert.ToInt32(dt.Rows[0]["projects_id"]), // Project_Id
                        Convert.ToInt32(dt.Rows[0]["ExpenseType_id"]), // ExpenseType_Id
                        dt.Rows[0]["comment"].ToString(), // Comment
                        Convert.ToBoolean(dt.Rows[0]["CreditCardPayed"]), // CreditCardPayed
                        Convert.ToBoolean(dt.Rows[0]["CompanyPayed"]), // CompanyPayed
                        Convert.ToBoolean(dt.Rows[0]["CancelFlag"]), // CancelFlag
                        Convert.ToBoolean(dt.Rows[0]["InvoiceFlag"]), // InvoiceFlag
                        "", // strFileName
                        "", // strFileData
                        dt.Rows[0]["OpportunityId"].ToString(), // OpportunityId
                        strAccountingDate // AccountingDate
                    );

                    if (!saveResult.Success)
                        return new AjaxCallResult { Success = false, Message = "Aggiornamento fallito." };

                    // valorizza parametri di ritorno
                    result.Success = true;
                    result.RecordHtmlText = dt.Rows[0]["ProjectCode"].ToString() + ":" + dt.Rows[0]["ExpenseCode"] + " : " + iAmount.ToString() + " " + dt.Rows[0]["UnitOfMeasure"];
                    result.RecordId = saveResult.ExpensesId;
                    return result;
            }
        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = "Errore: " + ex.Message;
            return result;
        }
        result.Success = false;
        result.Message = "Errore non previsto";
        return result;
    }

    //  **** CREA TICKET ***** 
    // Richiamata da input.aspx - vista bonus, inserisce ticket restaurant al click sull'icona
    [WebMethod(EnableSession = true)]
    public int CreaTicket(string personsId, string insDate)
    {
        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        // recupera manager ed account del progetto
        var result = Utilities.GetManagerAndAccountId(Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_PROJECT"]));

        // recupera conversion rate associata al tipo spesa
        DataTable dtTipoSpesa = CurrentSession.dtSpeseTutte;
        DataRow[] dr = dtTipoSpesa.Select("ExpenseType_id =  " + ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"]);
        if (dr.Length != 1)
            throw new Exception("Errore: Tipo spesa non trovato o duplicato.");

        // insDate ha formato yyyymmdd
        string convertDate = insDate.Substring(6, 2) + "/" + insDate.Substring(4, 2) + "/" + insDate.Substring(0, 4);

        // utilizza SaveExpenses per salvare il record
        SaveExpensesResult saveResult = SaveExpenses(
            0, // Expenses_Id
            convertDate, // Date
            1, // ExpenseAmount
            Convert.ToInt32(personsId), // Person_Id
            Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_PROJECT"]), // Project_Id
            Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"]), // ExpenseType_Id
            "", // Comment
            false, // CreditCardPayed
            false, // CompanyPayed
            false, // CancelFlag
            false, // InvoiceFlag
            "", // strFileName
            "", // strFileData
            "", // OpportunityId
            "" // AccountingDate
        );

        if (!saveResult.Success)
            throw new Exception("Errore durante il salvataggio del ticket.");

        return saveResult.ExpensesId;
    }

}
    