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

        String query = "SELECT A.ForcedAccounts_id, A.Persons_id, A.Projects_id, C.Name as PersonName, CONVERT(VARCHAR(10),A.DataDa, 103) as DataDa, CONVERT(VARCHAR(10),A.DataA, 103) as DataA, A.DaysBudget, A.DaysActual, B.ProjectCode + ' ' + B.Name as ProjectName FROM ForcedAccounts as A " +
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

        String query = "SELECT A.ForcedExpensesPers_id, A.Persons_id, A.ExpenseType_id, C.Name as PersonName, B.ExpenseCode + ' ' + B.Name as ExpenseTypeName FROM ForcedExpensesPers as A " +
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

        // Costruisci la stringa SQL per tutti i record
        string sqlQueryInsert = "INSERT INTO ForcedAccounts (Persons_id, Projects_id, DataDa, DataA, DaysBudget, CreationDate, CreatedBy) VALUES ";
        string sqlQueryDelete = "DELETE ForcedAccounts WHERE ";
        int toDelete = 0;
        int toInsert = 0;

        for (int i = 0; i < ForcedAccountsTable.Length; i++)
        {
            // array json con l'elenco dei valori da inserire
            record = (ForcedAccount)js.Deserialize(ForcedAccountsTable[i], Type.GetType("ForcedAccount"));

            // gli aggiornamenti sono gestiti come cancellazioni + inserimenti
            if (record.RecordToUpdate == "I" | record.RecordToUpdate == "U")
            {
                toInsert++;
                sqlQueryInsert += " ('" + record.Persons_id + "', '" + record.Projects_id + "', " + ASPcompatility.FormatDateDb(record.DataDa) + ", " + ASPcompatility.FormatDateDb(record.DataA) + ", " + ASPcompatility.FormatStringDb(record.DaysBudget) + ", " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + ", " + ASPcompatility.FormatStringDb(CurrentSession.UserId) + " ), ";
            }

            if (record.RecordToUpdate == "D" | record.RecordToUpdate == "U")
            {
                toDelete++;
                if (toDelete > 1)
                    sqlQueryDelete = sqlQueryDelete + " OR ";
                sqlQueryDelete = sqlQueryDelete + " ForcedAccounts_id= " + ASPcompatility.FormatStringDb(record.ForcedAccounts_id);
            }

        }

        // toglie la virgola finale            
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
        JavaScriptSerializer js = new JavaScriptSerializer();
        ForcedExpense record = null;

        if (ExpensesTable.Length == 0)
            return true;

        // Costruisci la stringa SQL per tutti i record
        string sqlQueryInsert = "INSERT INTO ForcedExpensesPers (ExpenseType_id, Persons_id) VALUES ";
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
                sqlQueryInsert += "('" + record.ExpenseType_id + "', '" + record.Persons_id + "'), ";
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

}
    