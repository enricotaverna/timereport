<%@ WebService Language="C#" Class="WS_ForcedAccounts" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;

// definisce la struttura  da ritornare con GetCourse
public class ForcedAccount 
{
    public string ForcedAccounts_id { get; set; }
    public string Persons_id { get; set; }
    public string Projects_id { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string DaysBudget { get; set; }
    public string DaysActual { get; set; }
    public string ProjectName { get; set; }
    public string RecordToUpdate { get; set; }
}

// definisce la struttura  da ritornare con GetCourse
public class ForcedExpense
{
    public string ForcedExpensesPers_id { get; set; }
    public string ExpenseType_id { get; set; }
    public string Persons_id { get; set; }
    public string Projects_id { get; set; }
    public string RecordToUpdate { get; set; }
}

/// <summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_ForcedAccounts : System.Web.Services.WebService
{

    public TRSession CurrentSession;

    public WS_ForcedAccounts()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string GetForcedProjects(string persons_id)
    {

        String query = "SELECT A.ForcedAccounts_id, A.Persons_id, A.Projects_id, C.Name as PersonName, CONVERT(VARCHAR(10),A.DataDa, 103) as DataDa, CONVERT(VARCHAR(10),A.DataA, 103) as DataA, A.DaysBudget, A.DaysActual, B.ProjectCode + ' ' + B.Name as ProjectName, " +
                        " A.CreatedBy, A.CreationDate, A.LastModificationDate, A.LastModifiedBy " +
                        " FROM ForcedAccounts as A " +
                        " JOIN Projects as B ON B.Projects_id = A.Projects_id " +
                        " JOIN Persons as C ON C.Persons_id = A.Persons_id " +
                        " WHERE B.active = 1 AND C.active = 1 " +
                        (persons_id == "" ? "" : " AND A.persons_id = '" + persons_id + "'") +
                        " ORDER BY PersonName,B.ProjectCode";

        return Database.FromSQLSelectToJson(query);

    }

    [WebMethod(EnableSession = true)]
    public string GetForcedExpenses(string persons_id)
    {

        String query = "SELECT A.ForcedExpensesPers_id, A.Persons_id, A.ExpenseType_id, C.Name as PersonName, B.ExpenseCode + ' ' + B.Name as ExpenseTypeName, " +
                        " A.CreatedBy, A.CreationDate, A.LastModificationDate, A.LastModifiedBy " +
                        " FROM ForcedExpensesPers as A " +
                        " JOIN ExpenseType as B ON B.ExpenseType_id = A.ExpenseType_id " +
                        " JOIN Persons as C ON C.Persons_id = A.Persons_id " +
                        " WHERE C.active = 1 AND B.active = 1 " +
                        (persons_id == "" ? "" : " AND A.persons_id = '" + persons_id + "'") +
                        " ORDER BY PersonName, ExpenseTypeName";

        return Database.FromSQLSelectToJson(query);

    }

    [WebMethod(EnableSession = true)]
    public bool SaveProjectsTable(string[] ForcedAccountsTable)
    {
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        JavaScriptSerializer js = new JavaScriptSerializer();
        ForcedAccount record = null;

        if (ForcedAccountsTable.Length == 0)
            return true;

        // Costruisci le stringhe SQL per tutti i record
        string sqlQueryInsert = "INSERT INTO ForcedAccounts (Persons_id, Projects_id, DataDa, DataA, DaysBudget, CreationDate, CreatedBy) VALUES ";
        string sqlQueryUpdate = "UPDATE ForcedAccounts SET ";
        string sqlQueryDelete = "DELETE FROM ForcedAccounts WHERE ";
        int toInsert = 0;
        int toUpdate = 0;
        int toDelete = 0;

        // Costruisci le parti del comando UPDATE
        string updateDataDa = "DataDa = CASE ";
        string updateDataA = "DataA = CASE ";
        string updateDaysBudget = "DaysBudget = CASE ";
        string updateLastModificationDate = "LastModificationDate = CASE ";
        string updateLastModifiedBy = "LastModifiedBy = CASE ";
        string updateWhereClause = "WHERE ForcedAccounts_id IN (";

        for (int i = 0; i < ForcedAccountsTable.Length; i++)
        {
            // array json con l'elenco dei valori da inserire
            record = (ForcedAccount)js.Deserialize(ForcedAccountsTable[i], Type.GetType("ForcedAccount"));

            if (record.RecordToUpdate == "I")
            {
                toInsert++;
                sqlQueryInsert += " ('" + record.Persons_id + "', '" + record.Projects_id + "', " + ASPcompatility.FormatDateDb(record.DataDa) + ", " + ASPcompatility.FormatDateDb(record.DataA) + ", " + ASPcompatility.FormatStringDb(record.DaysBudget) + ", " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " + ASPcompatility.FormatStringDb(CurrentSession.UserId) + " ), ";
            }

            if (record.RecordToUpdate == "U")
            {
                toUpdate++;
                updateDataDa += "WHEN ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + " THEN " + ASPcompatility.FormatDateDb(record.DataDa) + " ";
                updateDataA += "WHEN ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + " THEN " + ASPcompatility.FormatDateDb(record.DataA) + " ";
                updateDaysBudget += "WHEN ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + " THEN " + ASPcompatility.FormatStringDb(record.DaysBudget) + " ";
                updateLastModificationDate += "WHEN ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + " THEN " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + " ";
                updateLastModifiedBy += "WHEN ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + " THEN " + ASPcompatility.FormatStringDb(CurrentSession.UserId) + " ";
                updateWhereClause += ASPcompatility.FormatStringDb(record.ForcedAccounts_id) + ", ";
            }

            if (record.RecordToUpdate == "D")
            {
                toDelete++;
                if (toDelete > 1)
                    sqlQueryDelete += " OR ";
                sqlQueryDelete += " ForcedAccounts_id = " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id);
            }
        }

        // Completa le parti del comando UPDATE
        updateDataDa += "END, ";
        updateDataA += "END, ";
        updateDaysBudget += "END, ";
        updateLastModificationDate += "END, ";
        updateLastModifiedBy += "END ";
        updateWhereClause = updateWhereClause.Remove(updateWhereClause.Length - 2) + ")";

        // Costruisci il comando UPDATE completo
        if (toUpdate > 0)
        {
            sqlQueryUpdate += updateDataDa + updateDataA + updateDaysBudget + updateLastModificationDate + updateLastModifiedBy + updateWhereClause;
        }

        // toglie la virgola finale
        if (toInsert > 0)
            sqlQueryInsert = sqlQueryInsert.Remove(sqlQueryInsert.Length - 2);

        // Esegui le query SQL in una transazione
        string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            SqlTransaction transaction = connection.BeginTransaction();

            try
            {
                if (toInsert > 0)
                {
                    SqlCommand cmdQueryInsert = new SqlCommand(sqlQueryInsert, connection, transaction);
                    cmdQueryInsert.ExecuteNonQuery();
                }

                if (toUpdate > 0)
                {
                    SqlCommand cmdQueryUpdate = new SqlCommand(sqlQueryUpdate, connection, transaction);
                    cmdQueryUpdate.ExecuteNonQuery();
                }

                if (toDelete > 0)
                {
                    SqlCommand cmdQueryDelete = new SqlCommand(sqlQueryDelete, connection, transaction);
                    cmdQueryDelete.ExecuteNonQuery();
                }

                transaction.Commit();
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                return false;
            }
        }

        // dopo aver aggiornato il DB lancia la SP per aggiornare i campo DaysActual
        List<SqlParameter> parametersList = new List<SqlParameter>();

        for (int i = 0; i < ForcedAccountsTable.Length; i++)
        {
            // array json con l'elenco dei valori da inserire
            record = (ForcedAccount)js.Deserialize(ForcedAccountsTable[i], Type.GetType("ForcedAccount"));

            if (record.RecordToUpdate != "D")
            {
                parametersList.Clear();
                parametersList.Add(new SqlParameter("@Persons_id", Convert.ToInt16(record.Persons_id)));
                parametersList.Add(new SqlParameter("@Projects_id", Convert.ToInt16(record.Projects_id)));
                SqlParameter[] parameters = parametersList.ToArray();
                // Esecuzione della stored procedure e ottenimento del risultato come DataSet
                DataSet ds = Database.ExecuteStoredProcedure("DB_UpdateDaysActualFA", parameters);
            }

        }
        return true;
    }

    [WebMethod(EnableSession = true)]
    public bool SaveExpensesTable(string[] ExpensesTable)
    {
    
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        JavaScriptSerializer js = new JavaScriptSerializer();
        ForcedExpense record = null;

        if (ExpensesTable.Length == 0)
            return true;

        // Costruisci la stringa SQL per tutti i record
        string sqlQueryInsert = "INSERT INTO ForcedExpensesPers (ExpenseType_id, Persons_id, CreationDate, CreatedBy) VALUES ";
        string sqlQueryDelete = "DELETE FROM ForcedExpensesPers WHERE ";
        int toDelete = 0;
        int toInsert = 0;

        for (int i = 0; i < ExpensesTable.Length; i++)
        {
            // array json con l'elenco dei valori da inserire
            record = (ForcedExpense)js.Deserialize(ExpensesTable[i], Type.GetType("ForcedExpense"));

            if (record.RecordToUpdate == "I")
            {
                toInsert++;
                sqlQueryInsert += "('" + record.ExpenseType_id + "', '" + record.Persons_id + "', " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " + ASPcompatility.FormatStringDb(CurrentSession.UserId) + "), ";
            }

            if (record.RecordToUpdate == "D")
            {
                toDelete++;
                if (toDelete > 1)
                    sqlQueryDelete = sqlQueryDelete + " OR ";
                sqlQueryDelete = sqlQueryDelete + " ForcedExpensesPers_id= " + ASPcompatility.FormatStringDb(record.ForcedExpensesPers_id);
            }
        }

        sqlQueryInsert = sqlQueryInsert.Remove(sqlQueryInsert.Length - 2);

        // Esegui le query SQL in una transazione
        string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            SqlTransaction transaction = connection.BeginTransaction();

            try
            {
                SqlCommand cmdQueryDelete = new SqlCommand(sqlQueryDelete, connection, transaction);
                SqlCommand cmdQueryInsert = new SqlCommand(sqlQueryInsert, connection, transaction);

                if (toDelete > 0)
                    cmdQueryDelete.ExecuteNonQuery();

                if (toInsert > 0)
                    cmdQueryInsert.ExecuteNonQuery(); // Esempio di seconda query

                transaction.Commit();
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                return false;
            }
        }
        return true;
    }

    public class ExtAjaxCallResult : AjaxCallResult
    {
        public bool deleteConfirm { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public ExtAjaxCallResult CheckBeforeCopy(int ConsultantFrom, int ConsultantTo)
    {
        ExtAjaxCallResult result = new ExtAjaxCallResult();
        JavaScriptSerializer js = new JavaScriptSerializer();

        try
        {
            // Verifica che ConsultantFrom abbia autorizzazioni
            var res = Database.ExecuteScalar("SELECT COUNT(*) FROM ForcedAccounts as A " +
                                                     " JOIN Projects as B ON B.projects_id = A.projects_id" +
                                                     " WHERE B.active = 1 AND A.Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantFrom));
            if (Convert.ToInt16(res) == 0)
            {
                result.Success = result.deleteConfirm = false;
                result.Message = "Non esistono record di autorizzazione da copiare";
                return result;
            }

            // Verifica che ConsultantTo NON abbia autorizzazioni
            res = Database.ExecuteScalar("SELECT COUNT(*) FROM ForcedAccounts as A " +
                                             " JOIN Projects as B ON B.projects_id = A.projects_id" +
                                             " WHERE B.active = 1 AND A.Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantTo));
            if (Convert.ToInt16(res) != 0)
            {
                result.Success = false;
                result.deleteConfirm = true;
                result.Message = "Il consulente presenta già autorizzazioni. Confermi la sovrascrittura delle autorizzazioni esistenti ?";
                return result;
            }

        }
        catch (Exception ex)
        {
            result.Success = false;
            result.Message = "Errore: " + ex.Message;
        }

        result.Success = true;
        return result;
    }

    [WebMethod(EnableSession = true)]
    public AjaxCallResult CopyForcedRecords(int ConsultantFrom, int ConsultantTo)
    {
        AjaxCallResult result = new AjaxCallResult();
        JavaScriptSerializer js = new JavaScriptSerializer();

        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            SqlTransaction transaction = connection.BeginTransaction();

            try
            {
                // Delete existing records for ConsultantTo
                string sqlDelete = "DELETE FROM ForcedAccounts WHERE Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantTo);
                SqlCommand cmdDelete = new SqlCommand(sqlDelete, connection, transaction);
                cmdDelete.ExecuteNonQuery();

                // Insert new records from ConsultantFrom to ConsultantTo
                string sqlInsert = "INSERT INTO ForcedAccounts (Persons_id, Projects_id, CreationDate, CreatedBy) " +
                                   "SELECT " + ASPcompatility.FormatNumberDB(ConsultantTo) + ", Projects_id, " +
                                   ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " +
                                   ASPcompatility.FormatStringDb(CurrentSession.UserId) +
                                   " FROM ForcedAccounts WHERE Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantFrom);
                SqlCommand cmdInsert = new SqlCommand(sqlInsert, connection, transaction);
                cmdInsert.ExecuteNonQuery();

                // Delete existing records for ConsultantTo in ForcedExpensesPers
                string sqlDeleteExpenses = "DELETE FROM ForcedExpensesPers WHERE Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantTo);
                SqlCommand cmdDeleteExpenses = new SqlCommand(sqlDeleteExpenses, connection, transaction);
                cmdDeleteExpenses.ExecuteNonQuery();

                // Insert new records from ConsultantFrom to ConsultantTo in ForcedExpensesPers
                string sqlInsertExpenses = "INSERT INTO ForcedExpensesPers (Persons_id, ExpenseType_id, CreationDate, CreatedBy) " +
                                           "SELECT " + ASPcompatility.FormatNumberDB(ConsultantTo) + ", ExpenseType_id, " +
                                            ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " +
                                            ASPcompatility.FormatStringDb(CurrentSession.UserId) +
                                           " FROM ForcedExpensesPers WHERE Persons_id = " + ASPcompatility.FormatNumberDB(ConsultantFrom);
                SqlCommand cmdInsertExpenses = new SqlCommand(sqlInsertExpenses, connection, transaction);
                cmdInsertExpenses.ExecuteNonQuery();

                transaction.Commit();
                result.Success = true;
                result.Message = "Record copiati con successo";
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                result.Success = false;
                result.Message = "Errore: " + ex.Message;
            }
        }

        return result;
    }


}
    