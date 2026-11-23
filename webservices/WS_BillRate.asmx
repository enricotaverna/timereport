<%@ WebService Language="C#" Class="WS_BillRate" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;

// ---------------------------------------------------------------------------------------------
// DTO (nomi univoci nel progetto: non usare SaveResult, già dichiarato in WS_ControlloProgetto)
// ---------------------------------------------------------------------------------------------

public class CustomerBillRateRecord
{
    public int CustomerBillRate_id { get; set; }
    public string CodiceCliente { get; set; }          // alfanumerico: mai convertire in numero
    public decimal? BillRate { get; set; }
    public decimal? CostRate { get; set; }
    public string DataDa { get; set; }                 // dd/MM/yyyy
    public string DataA { get; set; }                  // dd/MM/yyyy
    public string Comment { get; set; }
    // audit: solo in lettura, ignorati in scrittura
    public string CreationDate { get; set; }
    public string CreatedBy { get; set; }
    public string LastModificationDate { get; set; }
    public string LastModifiedBy { get; set; }
}

public class ProjectBillRateRecord
{
    public int ProjectBillRate_id { get; set; }
    public int Projects_id { get; set; }
    public decimal? BillRate { get; set; }
    public decimal? CostRate { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string Comment { get; set; }
    public string CreationDate { get; set; }
    public string CreatedBy { get; set; }
    public string LastModificationDate { get; set; }
    public string LastModifiedBy { get; set; }
}

// Date di inizio e fine del progetto (dd/MM/yyyy, vuote se non valorizzate)
public class ProjectDatesInfo
{
    public bool Success { get; set; }
    public string DataInizio { get; set; }
    public string DataFine { get; set; }
}

public class BillRateSaveResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
    public int Id { get; set; }
}

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class WS_BillRate : System.Web.Services.WebService
{
    // Permessi riusati dalle pagine Cost Rate.
    // DA SOSTITUIRE se in futuro vengono introdotti permessi dedicati per i Bill Rate.
    private const string AUTH_TASK = "MASTERDATA";
    private const string AUTH_DISPLAY = "COSTRATE_DISPLAY";
    private const string AUTH_UPDATE = "COSTRATE_UPDATE";

    private const int COMMENT_MAX = 40;
    private const int CODICECLIENTE_LEN = 10;          // nvarchar(10) come Customers.CodiceCliente
    private const decimal AMOUNT_MAX = 99999999.99m;   // decimal(10,2)
    private const string DATE_FMT = "dd/MM/yyyy";
    private const string DATETIME_FMT = "dd/MM/yyyy HH:mm:ss";

    // Descrittore delle due tabelle: i nomi sono costanti di codice, mai input del client
    private class RateTable
    {
        public string Table, IdCol, KeyCol;
        public SqlDbType KeyType;
        public int KeySize;
        public string KeyInvalidMsg;
    }

    private static readonly RateTable Customer = new RateTable
    {
        Table = "CustomerBillRate", IdCol = "CustomerBillRate_id", KeyCol = "CodiceCliente",
        KeyType = SqlDbType.NVarChar, KeySize = CODICECLIENTE_LEN, KeyInvalidMsg = "Cliente non valido"
    };

    private static readonly RateTable Project = new RateTable
    {
        Table = "ProjectBillRate", IdCol = "ProjectBillRate_id", KeyCol = "Projects_id",
        KeyType = SqlDbType.Int, KeySize = 0, KeyInvalidMsg = "Progetto non valido"
    };

    // ---------------------------------------------------------------------------------------------
    // Helper
    // ---------------------------------------------------------------------------------------------

    private static string ConnString
    {
        get { return ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString; }
    }

    // Auth.ReturnPermission va in NullReference se le permission non sono in sessione: in tal caso nega
    private static bool HasPermission(string activity)
    {
        try { return Auth.ReturnPermission(AUTH_TASK, activity); }
        catch (NullReferenceException) { return false; }
    }

    private static BillRateSaveResult Fail(string message)
    {
        return new BillRateSaveResult { Success = false, Message = message, Id = 0 };
    }

    private static SqlParameter KeyParam(RateTable t, object value)
    {
        SqlParameter p = t.KeySize > 0 ? new SqlParameter("@Key", t.KeyType, t.KeySize) : new SqlParameter("@Key", t.KeyType);
        p.Value = value;
        return p;
    }

    private static SqlParameter AmountParam(string name, decimal? value)
    {
        SqlParameter p = new SqlParameter(name, SqlDbType.Decimal);
        p.Precision = 10;
        p.Scale = 2;
        p.Value = value.HasValue ? (object)value.Value : DBNull.Value;
        return p;
    }

    private static SqlParameter DateParam(string name, DateTime value)
    {
        SqlParameter p = new SqlParameter(name, SqlDbType.DateTime);
        p.Value = value;
        return p;
    }

    private static SqlParameter StringParam(string name, string value, int size)
    {
        SqlParameter p = new SqlParameter(name, SqlDbType.NVarChar, size);
        p.Value = string.IsNullOrEmpty(value) ? (object)DBNull.Value : value;
        return p;
    }

    private static bool TryParseDate(string s, out DateTime d)
    {
        return DateTime.TryParseExact((s ?? "").Trim(), DATE_FMT, CultureInfo.InvariantCulture, DateTimeStyles.None, out d);
    }

    private static string FormatDate(object o, string fmt)
    {
        if (o == null || o == DBNull.Value) return "";
        return ((DateTime)o).ToString(fmt, CultureInfo.InvariantCulture);
    }

    // SELECT -> JSON per Tabulator (stesso formato di Database.FromSQLSelectToJson ma con parametri)
    private static string QueryToJson(string query, params SqlParameter[] parameters)
    {
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();

        using (SqlConnection con = new SqlConnection(ConnString))
        using (SqlCommand cmd = new SqlCommand(query, con))
        {
            if (parameters != null) cmd.Parameters.AddRange(parameters);
            con.Open();
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                while (rdr.Read())
                {
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    for (int i = 0; i < rdr.FieldCount; i++)
                        row.Add(rdr.GetName(i), rdr.IsDBNull(i) ? null : rdr.GetValue(i));
                    rows.Add(row);
                }
            }
        }
        return JsonConvert.SerializeObject(rows);
    }

    // Cancellazione: richiede il permesso di update (come nelle pagine Cost Rate). Query parametrizzata.
    private static BillRateSaveResult DeleteCore(RateTable t, int id)
    {
        try
        {
            if (HttpContext.Current.Session["CurrentSession"] as TRSession == null) return Fail("Sessione scaduta");
            if (!HasPermission(AUTH_UPDATE)) return Fail("Operazione non autorizzata");
            if (id <= 0) return Fail("Record non valido");

            // Si cancella solo l'ultimo periodo (DataA massima) dello stesso cliente/progetto, per non creare buchi:
            // condizione e DELETE in un'unica istruzione, quindi atomiche.
            string sqlDelete =
                "DELETE A FROM " + t.Table + " AS A WHERE A." + t.IdCol + " = @Id " +
                "AND NOT EXISTS (SELECT 1 FROM " + t.Table + " AS B WHERE B." + t.KeyCol + " = A." + t.KeyCol + " AND B.DataA > A.DataA)";

            using (SqlConnection con = new SqlConnection(ConnString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(sqlDelete, con))
                {
                    cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                    if (cmd.ExecuteNonQuery() > 0)
                        return new BillRateSaveResult { Success = true, Message = "", Id = id };
                }

                // nessuna riga cancellata: record inesistente oppure non ultimo
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM " + t.Table + " WHERE " + t.IdCol + " = @Id", con))
                {
                    cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                    if ((int)cmd.ExecuteScalar() == 0) return Fail("Record non trovato");
                }
            }
            return Fail("Si può cancellare solo l'ultimo periodo");
        }
        catch (Exception)
        {
            return Fail("Impossibile cancellare il record");
        }
    }

    // ---------------------------------------------------------------------------------------------
    // Validazioni (server = autorità). Ritorna null se ok, altrimenti il primo messaggio d'errore
    // ---------------------------------------------------------------------------------------------

    private static bool AmountIsValid(decimal? v)
    {
        if (!v.HasValue) return true;
        return v.Value >= 0 && v.Value <= AMOUNT_MAX && decimal.Round(v.Value, 2) == v.Value;
    }

    private static string ValidateCommon(string dataDa, string dataA, decimal? billRate, decimal? costRate,
                                         string comment, out DateTime dDa, out DateTime dA)
    {
        dDa = DateTime.MinValue;
        dA = DateTime.MinValue;

        if (string.IsNullOrWhiteSpace(dataDa)) return "Data da obbligatoria";
        if (string.IsNullOrWhiteSpace(dataA)) return "Data a obbligatoria";
        if (!TryParseDate(dataDa, out dDa) || !TryParseDate(dataA, out dA)) return "Data non valida (gg/mm/aaaa)";
        if (dDa > dA) return "Data inizio deve essere < data fine";
        if (dDa.Day != 1) return "La data deve essere primo giorno del mese";

        if (!AmountIsValid(billRate) || !AmountIsValid(costRate)) return "Importo non valido (max 2 decimali)";
        // 0 è una tariffa valida: conta solo se il campo è non valorizzato (null)
        if (!billRate.HasValue && !costRate.HasValue) return "Inserire almeno una tariffa";

        if (comment != null && comment.Length > COMMENT_MAX) return "Nota troppo lunga (max 40 caratteri)";

        return null;
    }

    // Stessa semantica di WS_PersonsCostRate.CheckDate, riferita al cliente/progetto.
    // Ritorna "true" oppure la data attesa dd/MM/yyyy.
    private static string CheckDateCore(RateTable t, SqlConnection con, SqlTransaction tx,
                                        object keyValue, int id, DateTime dDa, DateTime dA)
    {
        // 1) stessi chiave/DataDa/DataA già presenti -> solo modifica importi -> OK
        string sqlSame = "SELECT COUNT(1) FROM " + t.Table + " WHERE " + t.KeyCol + " = @Key AND DataDa = @DataDa AND DataA = @DataA";
        using (SqlCommand cmd = new SqlCommand(sqlSame, con, tx))
        {
            cmd.Parameters.Add(KeyParam(t, keyValue));
            cmd.Parameters.Add(DateParam("@DataDa", dDa));
            cmd.Parameters.Add(DateParam("@DataA", dA));
            if ((int)cmd.ExecuteScalar() > 0) return "true";
        }

        // 2) altri record (escluso quello in modifica); MAX = NULL se non ce ne sono -> primo inserimento -> OK
        string sqlMax = "SELECT MAX(DataA) FROM " + t.Table + " WHERE " + t.KeyCol + " = @Key AND " + t.IdCol + " <> @Id";
        object max;
        using (SqlCommand cmd = new SqlCommand(sqlMax, con, tx))
        {
            cmd.Parameters.Add(KeyParam(t, keyValue));
            cmd.Parameters.Add(new SqlParameter("@Id", SqlDbType.Int) { Value = id });
            max = cmd.ExecuteScalar();
        }
        if (max == null || max == DBNull.Value) return "true";

        // 3) DataDa deve essere MAX(DataA) + 1 giorno
        string expected = ((DateTime)max).AddDays(1).ToString(DATE_FMT, CultureInfo.InvariantCulture);
        return dDa.ToString(DATE_FMT, CultureInfo.InvariantCulture) == expected ? "true" : expected;
    }

    private static string CheckDateWs(RateTable t, object keyValue, int id, string dataDa, string dataA)
    {
        DateTime dDa, dA;
        // formato/obbligatorietà sono segnalati dagli altri validatori e dal Save: qui nulla da controllare
        if (keyValue == null || !TryParseDate(dataDa, out dDa) || !TryParseDate(dataA, out dA))
            return "true";

        using (SqlConnection con = new SqlConnection(ConnString))
        {
            con.Open();
            return CheckDateCore(t, con, null, keyValue, id, dDa, dA);
        }
    }

    // ---------------------------------------------------------------------------------------------
    // CustomerBillRate
    // ---------------------------------------------------------------------------------------------

    [WebMethod(EnableSession = true)]
    public string GetCustomerBillRateTable()
    {
        if (Session["CurrentSession"] as TRSession == null || !HasPermission(AUTH_DISPLAY))
            return "[]";

        string query =
            "SELECT A.CustomerBillRate_id, A.CodiceCliente, C.Nome1 AS NomeCliente, A.BillRate, A.CostRate, A.Comment, " +
            "       CONVERT(VARCHAR(10), A.DataDa, 103) AS DataDa, CONVERT(VARCHAR(8), A.DataDa, 112) AS DataDaSort, " +
            "       CONVERT(VARCHAR(10), A.DataA, 103) AS DataA, CONVERT(VARCHAR(8), A.DataA, 112) AS DataASort, " +
            "       CASE WHEN NOT EXISTS (SELECT 1 FROM CustomerBillRate AS B WHERE B.CodiceCliente = A.CodiceCliente AND B.DataA > A.DataA) THEN 1 ELSE 0 END AS IsLast " +
            "FROM CustomerBillRate AS A " +
            "LEFT JOIN Customers AS C ON C.CodiceCliente = A.CodiceCliente " +
            "ORDER BY A.DataDa DESC, C.Nome1";

        return QueryToJson(query);
    }

    [WebMethod(EnableSession = true)]
    public CustomerBillRateRecord GetCustomerBillRate(int id)
    {
        CustomerBillRateRecord rec = new CustomerBillRateRecord();   // id = 0 -> non trovato / non autorizzato

        if (Session["CurrentSession"] as TRSession == null || !HasPermission(AUTH_DISPLAY))
            return rec;

        using (SqlConnection con = new SqlConnection(ConnString))
        using (SqlCommand cmd = new SqlCommand("SELECT * FROM CustomerBillRate WHERE CustomerBillRate_id = @Id", con))
        {
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
            con.Open();
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                if (rdr.Read())
                {
                    rec.CustomerBillRate_id = (int)rdr["CustomerBillRate_id"];
                    rec.CodiceCliente = rdr["CodiceCliente"].ToString();
                    rec.BillRate = rdr["BillRate"] == DBNull.Value ? (decimal?)null : (decimal)rdr["BillRate"];
                    rec.CostRate = rdr["CostRate"] == DBNull.Value ? (decimal?)null : (decimal)rdr["CostRate"];
                    rec.DataDa = FormatDate(rdr["DataDa"], DATE_FMT);
                    rec.DataA = FormatDate(rdr["DataA"], DATE_FMT);
                    rec.Comment = rdr["Comment"] == DBNull.Value ? "" : rdr["Comment"].ToString();
                    rec.CreationDate = FormatDate(rdr["CreationDate"], DATETIME_FMT);
                    rec.CreatedBy = rdr["CreatedBy"] == DBNull.Value ? "" : rdr["CreatedBy"].ToString();
                    rec.LastModificationDate = FormatDate(rdr["LastModificationDate"], DATETIME_FMT);
                    rec.LastModifiedBy = rdr["LastModifiedBy"] == DBNull.Value ? "" : rdr["LastModifiedBy"].ToString();
                }
            }
        }
        return rec;
    }

    [WebMethod(EnableSession = true)]
    public string CheckDateCustomer(string CodiceCliente, int CustomerBillRate_id, string DataDa, string DataA)
    {
        if (Session["CurrentSession"] as TRSession == null) return "Sessione scaduta";
        if (!HasPermission(AUTH_DISPLAY)) return "Operazione non autorizzata";

        object key = string.IsNullOrWhiteSpace(CodiceCliente) ? null : CodiceCliente.Trim();
        return CheckDateWs(Customer, key, CustomerBillRate_id, DataDa, DataA);
    }

    [WebMethod(EnableSession = true)]
    public BillRateSaveResult SaveCustomerBillRate(CustomerBillRateRecord rec)
    {
        try
        {
            TRSession session = Session["CurrentSession"] as TRSession;
            if (session == null) return Fail("Sessione scaduta");
            if (!HasPermission(AUTH_UPDATE)) return Fail("Operazione non autorizzata");
            if (rec == null) return Fail("Dati mancanti");

            string codice = (rec.CodiceCliente ?? "").Trim();
            if (codice == "") return Fail("Cliente obbligatorio");
            if (codice.Length > CODICECLIENTE_LEN) return Fail("Cliente non valido");

            DateTime dDa, dA;
            string err = ValidateCommon(rec.DataDa, rec.DataA, rec.BillRate, rec.CostRate, rec.Comment, out dDa, out dA);
            if (err != null) return Fail(err);

            using (SqlConnection con = new SqlConnection(ConnString))
            {
                con.Open();
                // Serializable: check di continuità e scrittura non possono essere interlacciati da un altro Save
                using (SqlTransaction tx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Customers WHERE CodiceCliente = @Cod", con, tx))
                    {
                        cmd.Parameters.Add("@Cod", SqlDbType.NVarChar, CODICECLIENTE_LEN).Value = codice;
                        if ((int)cmd.ExecuteScalar() == 0) return Fail("Cliente non valido");
                    }

                    string expected = CheckDateCore(Customer, con, tx, codice, rec.CustomerBillRate_id, dDa, dA);
                    if (expected != "true") return Fail("Data inizio dovrebbe essere: " + expected);

                    int id = rec.CustomerBillRate_id;

                    if (id > 0)
                    {
                        string sql =
                            "UPDATE CustomerBillRate SET CodiceCliente = @Cod, BillRate = @BillRate, CostRate = @CostRate, " +
                            "DataDa = @DataDa, DataA = @DataA, Comment = @Comment, " +
                            "LastModificationDate = @Now, LastModifiedBy = @User " +
                            "WHERE CustomerBillRate_id = @Id";
                        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                        {
                            cmd.Parameters.Add("@Cod", SqlDbType.NVarChar, CODICECLIENTE_LEN).Value = codice;
                            cmd.Parameters.Add(AmountParam("@BillRate", rec.BillRate));
                            cmd.Parameters.Add(AmountParam("@CostRate", rec.CostRate));
                            cmd.Parameters.Add(DateParam("@DataDa", dDa));
                            cmd.Parameters.Add(DateParam("@DataA", dA));
                            cmd.Parameters.Add(StringParam("@Comment", rec.Comment, COMMENT_MAX));
                            cmd.Parameters.Add(DateParam("@Now", DateTime.Now));
                            cmd.Parameters.Add(StringParam("@User", session.UserId, 50));
                            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                            if (cmd.ExecuteNonQuery() == 0) return Fail("Record non trovato");
                        }
                    }
                    else
                    {
                        string sql =
                            "INSERT INTO CustomerBillRate (CodiceCliente, BillRate, CostRate, DataDa, DataA, Comment, CreationDate, CreatedBy) " +
                            "OUTPUT INSERTED.CustomerBillRate_id " +
                            "VALUES (@Cod, @BillRate, @CostRate, @DataDa, @DataA, @Comment, @Now, @User)";
                        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                        {
                            cmd.Parameters.Add("@Cod", SqlDbType.NVarChar, CODICECLIENTE_LEN).Value = codice;
                            cmd.Parameters.Add(AmountParam("@BillRate", rec.BillRate));
                            cmd.Parameters.Add(AmountParam("@CostRate", rec.CostRate));
                            cmd.Parameters.Add(DateParam("@DataDa", dDa));
                            cmd.Parameters.Add(DateParam("@DataA", dA));
                            cmd.Parameters.Add(StringParam("@Comment", rec.Comment, COMMENT_MAX));
                            cmd.Parameters.Add(DateParam("@Now", DateTime.Now));
                            cmd.Parameters.Add(StringParam("@User", session.UserId, 50));
                            id = (int)cmd.ExecuteScalar();
                        }
                    }

                    tx.Commit();
                    return new BillRateSaveResult { Success = true, Message = "", Id = id };
                }
            }
        }
        catch (Exception ex)
        {
            return Fail("Errore durante il salvataggio");
        }
    }

    [WebMethod(EnableSession = true)]
    public BillRateSaveResult DeleteCustomerBillRate(int id)
    {
        return DeleteCore(Customer, id);
    }

    // ---------------------------------------------------------------------------------------------
    // ProjectBillRate
    // ---------------------------------------------------------------------------------------------

    [WebMethod(EnableSession = true)]
    public string GetProjectBillRateTable(bool active)
    {
        if (Session["CurrentSession"] as TRSession == null || !HasPermission(AUTH_DISPLAY))
            return "[]";

        string query =
            "SELECT A.ProjectBillRate_id, A.Projects_id, D.ProjectCode, D.Name AS ProjectName, C.Nome1 AS NomeCliente, " +
            "       A.BillRate, A.Comment, " +
            "       CONVERT(VARCHAR(10), A.DataDa, 103) AS DataDa, CONVERT(VARCHAR(8), A.DataDa, 112) AS DataDaSort, " +
            "       CONVERT(VARCHAR(10), A.DataA, 103) AS DataA, CONVERT(VARCHAR(8), A.DataA, 112) AS DataASort, " +
            "       CASE WHEN NOT EXISTS (SELECT 1 FROM ProjectBillRate AS B WHERE B.Projects_id = A.Projects_id AND B.DataA > A.DataA) THEN 1 ELSE 0 END AS IsLast " +
            "FROM ProjectBillRate AS A " +
            "JOIN Projects AS D ON D.Projects_id = A.Projects_id " +
            "LEFT JOIN Customers AS C ON C.CodiceCliente = D.CodiceCliente " +
            "WHERE D.Active = @Active " +
            "ORDER BY A.DataDa DESC, C.Nome1, D.ProjectCode";

        SqlParameter pActive = new SqlParameter("@Active", SqlDbType.Bit) { Value = active };
        return QueryToJson(query, pActive);
    }

    [WebMethod(EnableSession = true)]
    public ProjectBillRateRecord GetProjectBillRate(int id)
    {
        ProjectBillRateRecord rec = new ProjectBillRateRecord();

        if (Session["CurrentSession"] as TRSession == null || !HasPermission(AUTH_DISPLAY))
            return rec;

        using (SqlConnection con = new SqlConnection(ConnString))
        using (SqlCommand cmd = new SqlCommand("SELECT * FROM ProjectBillRate WHERE ProjectBillRate_id = @Id", con))
        {
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
            con.Open();
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                if (rdr.Read())
                {
                    rec.ProjectBillRate_id = (int)rdr["ProjectBillRate_id"];
                    rec.Projects_id = (int)rdr["Projects_id"];
                    rec.BillRate = rdr["BillRate"] == DBNull.Value ? (decimal?)null : (decimal)rdr["BillRate"];
                    rec.CostRate = rdr["CostRate"] == DBNull.Value ? (decimal?)null : (decimal)rdr["CostRate"];
                    rec.DataDa = FormatDate(rdr["DataDa"], DATE_FMT);
                    rec.DataA = FormatDate(rdr["DataA"], DATE_FMT);
                    rec.Comment = rdr["Comment"] == DBNull.Value ? "" : rdr["Comment"].ToString();
                    rec.CreationDate = FormatDate(rdr["CreationDate"], DATETIME_FMT);
                    rec.CreatedBy = rdr["CreatedBy"] == DBNull.Value ? "" : rdr["CreatedBy"].ToString();
                    rec.LastModificationDate = FormatDate(rdr["LastModificationDate"], DATETIME_FMT);
                    rec.LastModifiedBy = rdr["LastModifiedBy"] == DBNull.Value ? "" : rdr["LastModifiedBy"].ToString();
                }
            }
        }
        return rec;
    }

    [WebMethod(EnableSession = true)]
    public string CheckDateProject(int Projects_id, int ProjectBillRate_id, string DataDa, string DataA)
    {
        if (Session["CurrentSession"] as TRSession == null) return "Sessione scaduta";
        if (!HasPermission(AUTH_DISPLAY)) return "Operazione non autorizzata";

        DateTime dDa, dA;
        // formato/obbligatorietà sono segnalati dagli altri validatori e dal Save: qui nulla da controllare
        if (Projects_id <= 0 || !TryParseDate(DataDa, out dDa) || !TryParseDate(DataA, out dA))
            return "true";

        using (SqlConnection con = new SqlConnection(ConnString))
        {
            con.Open();
            string overlap = CheckOverlapProject(con, null, Projects_id, ProjectBillRate_id, dDa, dA);
            if (overlap != null) return overlap;
            return CheckDateCore(Project, con, null, Projects_id, ProjectBillRate_id, dDa, dA);
        }
    }

    // Periodo sovrapposto a un altro periodo dello stesso progetto (escluso il record in modifica).
    // Ritorna null se non ci sono sovrapposizioni, altrimenti un messaggio breve che indica quale data cambiare.
    private static string CheckOverlapProject(SqlConnection con, SqlTransaction tx, int projectsId, int id, DateTime dDa, DateTime dA)
    {
        string sql =
            "SELECT TOP 1 DataDa, DataA FROM ProjectBillRate " +
            "WHERE Projects_id = @Key AND ProjectBillRate_id <> @Id AND DataDa <= @DataA AND DataA >= @DataDa " +
            "ORDER BY DataDa";

        DateTime eDa, eA;
        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
        {
            cmd.Parameters.Add("@Key", SqlDbType.Int).Value = projectsId;
            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
            cmd.Parameters.Add(DateParam("@DataDa", dDa));
            cmd.Parameters.Add(DateParam("@DataA", dA));
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                if (!rdr.Read()) return null;
                eDa = (DateTime)rdr["DataDa"];
                eA = (DateTime)rdr["DataA"];
            }
        }

        bool startIn = dDa >= eDa && dDa <= eA;
        bool endIn = dA >= eDa && dA <= eA;

        // messaggio breve: indica solo quale data cambiare
        if (startIn && !endIn)
            return "Periodo sovrapposto, cambiare la data inizio";
        if (endIn && !startIn)
            return "Periodo sovrapposto, cambiare la data fine";
        return "Periodo sovrapposto, cambiare le date";
    }

    // Periodo proposto in inserimento: inizio = ultima DataA del progetto + 1 giorno (se ci sono periodi) o inizio progetto; fine = fine progetto
    [WebMethod(EnableSession = true)]
    public ProjectDatesInfo GetProjectDates(int Projects_id)
    {
        ProjectDatesInfo info = new ProjectDatesInfo { Success = false, DataInizio = "", DataFine = "" };

        if (Session["CurrentSession"] as TRSession == null || !HasPermission(AUTH_DISPLAY) || Projects_id <= 0)
            return info;

        // DataInizio proposta: se il progetto ha già periodi, ultima DataA + 1 giorno; altrimenti inizio del progetto
        using (SqlConnection con = new SqlConnection(ConnString))
        using (SqlCommand cmd = new SqlCommand(
            "SELECT P.DataInizio, P.DataFine, (SELECT MAX(B.DataA) FROM ProjectBillRate AS B WHERE B.Projects_id = P.Projects_id) AS UltimaDataA " +
            "FROM Projects AS P WHERE P.Projects_id = @Prj", con))
        {
            cmd.Parameters.Add("@Prj", SqlDbType.Int).Value = Projects_id;
            con.Open();
            using (SqlDataReader rdr = cmd.ExecuteReader())
            {
                if (rdr.Read())
                {
                    info.Success = true;
                    info.DataFine = FormatDate(rdr["DataFine"], DATE_FMT);
                    info.DataInizio = rdr["UltimaDataA"] == DBNull.Value
                        ? FormatDate(rdr["DataInizio"], DATE_FMT)
                        : ((DateTime)rdr["UltimaDataA"]).AddDays(1).ToString(DATE_FMT, CultureInfo.InvariantCulture);
                }
            }
        }
        return info;
    }

    [WebMethod(EnableSession = true)]
    public BillRateSaveResult SaveProjectBillRate(ProjectBillRateRecord rec)
    {
        try
        {
            TRSession session = Session["CurrentSession"] as TRSession;
            if (session == null) return Fail("Sessione scaduta");
            if (!HasPermission(AUTH_UPDATE)) return Fail("Operazione non autorizzata");
            if (rec == null) return Fail("Dati mancanti");

            if (rec.Projects_id <= 0) return Fail("Progetto obbligatorio");

            // Cost Rate non è gestito da questa maschera: si ignora il valore ricevuto e il dato esistente non viene toccato.
            // Il Bill Rate è quindi l'unica tariffa e diventa obbligatorio (0 è valido, vuoto no)
            if (!rec.BillRate.HasValue) return Fail("Bill Rate obbligatorio");

            DateTime dDa, dA;
            string err = ValidateCommon(rec.DataDa, rec.DataA, rec.BillRate, null, rec.Comment, out dDa, out dA);
            if (err != null) return Fail(err);

            using (SqlConnection con = new SqlConnection(ConnString))
            {
                con.Open();
                using (SqlTransaction tx = con.BeginTransaction(IsolationLevel.Serializable))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM Projects WHERE Projects_id = @Prj", con, tx))
                    {
                        cmd.Parameters.Add("@Prj", SqlDbType.Int).Value = rec.Projects_id;
                        if ((int)cmd.ExecuteScalar() == 0) return Fail("Progetto non valido");
                    }

                    string overlap = CheckOverlapProject(con, tx, rec.Projects_id, rec.ProjectBillRate_id, dDa, dA);
                    if (overlap != null) return Fail(overlap);

                    string expected = CheckDateCore(Project, con, tx, rec.Projects_id, rec.ProjectBillRate_id, dDa, dA);
                    if (expected != "true") return Fail("Data inizio dovrebbe essere: " + expected);

                    int id = rec.ProjectBillRate_id;

                    if (id > 0)
                    {
                        string sql =
                            "UPDATE ProjectBillRate SET Projects_id = @Prj, BillRate = @BillRate, " +
                            "DataDa = @DataDa, DataA = @DataA, Comment = @Comment, " +
                            "LastModificationDate = @Now, LastModifiedBy = @User " +
                            "WHERE ProjectBillRate_id = @Id";
                        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                        {
                            cmd.Parameters.Add("@Prj", SqlDbType.Int).Value = rec.Projects_id;
                            cmd.Parameters.Add(AmountParam("@BillRate", rec.BillRate));
                            cmd.Parameters.Add(DateParam("@DataDa", dDa));
                            cmd.Parameters.Add(DateParam("@DataA", dA));
                            cmd.Parameters.Add(StringParam("@Comment", rec.Comment, COMMENT_MAX));
                            cmd.Parameters.Add(DateParam("@Now", DateTime.Now));
                            cmd.Parameters.Add(StringParam("@User", session.UserId, 50));
                            cmd.Parameters.Add("@Id", SqlDbType.Int).Value = id;
                            if (cmd.ExecuteNonQuery() == 0) return Fail("Record non trovato");
                        }
                    }
                    else
                    {
                        string sql =
                            "INSERT INTO ProjectBillRate (Projects_id, BillRate, DataDa, DataA, Comment, CreationDate, CreatedBy) " +
                            "OUTPUT INSERTED.ProjectBillRate_id " +
                            "VALUES (@Prj, @BillRate, @DataDa, @DataA, @Comment, @Now, @User)";
                        using (SqlCommand cmd = new SqlCommand(sql, con, tx))
                        {
                            cmd.Parameters.Add("@Prj", SqlDbType.Int).Value = rec.Projects_id;
                            cmd.Parameters.Add(AmountParam("@BillRate", rec.BillRate));
                            cmd.Parameters.Add(DateParam("@DataDa", dDa));
                            cmd.Parameters.Add(DateParam("@DataA", dA));
                            cmd.Parameters.Add(StringParam("@Comment", rec.Comment, COMMENT_MAX));
                            cmd.Parameters.Add(DateParam("@Now", DateTime.Now));
                            cmd.Parameters.Add(StringParam("@User", session.UserId, 50));
                            id = (int)cmd.ExecuteScalar();
                        }
                    }

                    tx.Commit();
                    return new BillRateSaveResult { Success = true, Message = "", Id = id };
                }
            }
        }
        catch (Exception ex)
        {
            return Fail("Errore durante il salvataggio");
        }
    }

    [WebMethod(EnableSession = true)]
    public BillRateSaveResult DeleteProjectBillRate(int id)
    {
        return DeleteCore(Project, id);
    }
}
