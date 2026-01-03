<%@ WebService Language="C#" Class="WS_ControlloProgetto" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;

// Struttura dati per singolo mese Economics
public class EconomicsMonthData 
{
    public string AnnoMese { get; set; }
    public string ETC { get; set; }
    public string Margine { get; set; }
}

// Struttura dati per Economics completo (usato per SAVE)
public class EconomicsData 
{
    public int Projects_id { get; set; }
    public string AnnoMese { get; set; }
    public decimal? ETC { get; set; }  // DECIMAL per importi monetari (precisione esatta)
    public decimal? Margine { get; set; }  // DECIMAL per percentuali (precisione esatta)
    public string RecordToUpdate { get; set; }
}

/// <summary>
/// WebService per gestione Economics del Controllo Progetto
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_ControlloProgetto : System.Web.Services.WebService
{

    public TRSession CurrentSession;

    public WS_ControlloProgetto()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string GetEconomicsData(int projects_id)
    {
        CurrentSession = (TRSession)Session["CurrentSession"];
        
        List<Dictionary<string, object>> result = new List<Dictionary<string, object>>();
        
        string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();
            
            // Recupera date inizio/fine progetto e margine proposta di default
            string queryProject = "SELECT DataInizio, DataFine, MargineProposta FROM Projects WHERE Projects_id = @Projects_id";
            SqlCommand cmdProject = new SqlCommand(queryProject, conn);
            cmdProject.Parameters.AddWithValue("@Projects_id", projects_id);
            
            DateTime dataInizio = DateTime.Now;
            DateTime dataFine = DateTime.Now.AddMonths(12);
            decimal? margineDefault = null;
            
            using (SqlDataReader rdr = cmdProject.ExecuteReader())
            {
                if (rdr.Read())
                {
                    if (!rdr.IsDBNull(0)) dataInizio = rdr.GetDateTime(0);
                    if (!rdr.IsDBNull(1)) dataFine = rdr.GetDateTime(1);
                    if (!rdr.IsDBNull(2)) margineDefault = rdr.GetDecimal(2) * 100;
                }
            }
            
            // Recupera dati esistenti da ProjectEconomics
            string queryEconomics = @"SELECT AnnoMese, ETC, Margine 
                                     FROM ProjectEconomics 
                                     WHERE Projects_id = @Projects_id 
                                     ORDER BY AnnoMese";
            
            SqlCommand cmdEconomics = new SqlCommand(queryEconomics, conn);
            cmdEconomics.Parameters.AddWithValue("@Projects_id", projects_id);
            
            Dictionary<string, Dictionary<string, object>> economicsData = new Dictionary<string, Dictionary<string, object>>();
            
            using (SqlDataReader rdr = cmdEconomics.ExecuteReader())
            {
                while (rdr.Read())
                {
                    string annoMese = rdr["AnnoMese"].ToString();
                    Dictionary<string, object> row = new Dictionary<string, object>();
                    row["AnnoMese"] = annoMese;
                    row["ETC"] = rdr.IsDBNull(rdr.GetOrdinal("ETC")) ? null : (object)rdr.GetDecimal(rdr.GetOrdinal("ETC"));
                    
                    // Se Margine è NULL nella tabella, usa il default dal progetto
                    if (rdr.IsDBNull(rdr.GetOrdinal("Margine")))
                    {
                        row["Margine"] = margineDefault.HasValue ? (object)margineDefault.Value : null;
                    }
                    else
                    {
                        row["Margine"] = (object)rdr.GetDecimal(rdr.GetOrdinal("Margine"));
                    }
                    
                    economicsData[annoMese] = row;
                }
            }
            
            // Genera lista mesi da DataInizio a DataFine con formato YYYY-MM
            DateTime currentMonth = new DateTime(dataInizio.Year, dataInizio.Month, 1);
            DateTime endMonth = new DateTime(dataFine.Year, dataFine.Month, 1);
            
            while (currentMonth <= endMonth)
            {
                string annoMese = currentMonth.ToString("yyyy-MM");
                
                if (economicsData.ContainsKey(annoMese))
                {
                    result.Add(economicsData[annoMese]);
                }
                else
                {
                    // Crea record vuoto con margine di default dal progetto
                    Dictionary<string, object> emptyRow = new Dictionary<string, object>();
                    emptyRow["AnnoMese"] = annoMese;
                    emptyRow["ETC"] = null;
                    emptyRow["Margine"] = margineDefault.HasValue ? (object)margineDefault.Value : null;
                    
                    result.Add(emptyRow);
                }
                
                currentMonth = currentMonth.AddMonths(1);
            }
        }
        
        JavaScriptSerializer js = new JavaScriptSerializer();
        return js.Serialize(result);
    }

    [WebMethod(EnableSession = true)]
    public AjaxCallResult SaveEconomicsData(string[] economicsTable)
    {
        AjaxCallResult result = new AjaxCallResult();
        CurrentSession = (TRSession)Session["CurrentSession"];
        
        JavaScriptSerializer js = new JavaScriptSerializer();
        
        if (economicsTable == null || economicsTable.Length == 0)
        {
            result.Success = true;
            result.Message = "Nessun dato da salvare";
            return result;
        }
        
        // Verifica autorizzazioni per Margine
        bool canEditMargine = Auth.ReturnPermission("REPORT", "PROJECT_ALL");
        
        // Estrai Projects_id dal primo record
        EconomicsData firstRecord = js.Deserialize<EconomicsData>(economicsTable[0]);
        int projectsId = firstRecord.Projects_id;
        
        string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();
            SqlTransaction transaction = connection.BeginTransaction();
            
            try
            {
                // *** STEP 1: CANCELLA TUTTI I RECORD ESISTENTI PER QUESTO PROGETTO ***
                string deleteQuery = "DELETE FROM ProjectEconomics WHERE Projects_id = @Projects_id";
                SqlCommand deleteCmd = new SqlCommand(deleteQuery, connection, transaction);
                deleteCmd.Parameters.AddWithValue("@Projects_id", projectsId);
                deleteCmd.ExecuteNonQuery();
                
                // *** STEP 2: INSERISCI SOLO LE RIGHE CON ALMENO UN VALORE ***
                foreach (string item in economicsTable)
                {
                    EconomicsData record = js.Deserialize<EconomicsData>(item);
                    
                    // Validazione formato AnnoMese
                    if (string.IsNullOrEmpty(record.AnnoMese) || record.AnnoMese.Length != 7 || record.AnnoMese[4] != '-')
                    {
                        throw new Exception("Formato AnnoMese non valido: " + record.AnnoMese);
                    }
                    
                    // Validazione ETC
                    if (record.ETC.HasValue && (record.ETC.Value < 0 || Math.Round(record.ETC.Value, 2) != record.ETC.Value))
                    {
                        throw new Exception("ETC non valido: deve essere >= 0 con max 2 decimali");
                    }
                    
                    // Validazione Margine
                    if (record.Margine.HasValue && (Math.Round(record.Margine.Value, 2) != record.Margine.Value))
                    {
                        throw new Exception("Margine non valido: deve avere max 2 decimali");
                    }
                    
                    // *** INSERISCI SOLO SE C'È ALMENO UN VALORE ***
                    bool hasETC = record.ETC.HasValue;
                    bool hasMargine = record.Margine.HasValue && canEditMargine;
                    
                    if (hasETC || hasMargine)
                    {
                        string insertQuery = @"INSERT INTO ProjectEconomics 
                                             (Projects_id, AnnoMese, ETC, Margine, CreationDate, CreatedBy) 
                                             VALUES (@Projects_id, @AnnoMese, @ETC, @Margine, @CreationDate, @CreatedBy)";
                        
                        SqlCommand insertCmd = new SqlCommand(insertQuery, connection, transaction);
                        insertCmd.Parameters.AddWithValue("@Projects_id", record.Projects_id);
                        insertCmd.Parameters.AddWithValue("@AnnoMese", record.AnnoMese);
                        insertCmd.Parameters.Add("@ETC", SqlDbType.Decimal).Value = record.ETC.HasValue ? (object)record.ETC.Value : DBNull.Value;
                        insertCmd.Parameters.Add("@Margine", SqlDbType.Decimal).Value = (canEditMargine && record.Margine.HasValue) ? (object)record.Margine.Value : DBNull.Value;
                        insertCmd.Parameters.Add("@CreationDate", SqlDbType.DateTime).Value = DateTime.Now;
                        insertCmd.Parameters.AddWithValue("@CreatedBy", CurrentSession.UserId);
                        
                        insertCmd.ExecuteNonQuery();
                    }
                    // Se entrambi NULL, non inserisce nulla (il mese userà i default)
                }
                
                transaction.Commit();
                result.Success = true;
                result.Message = "Salvataggio completato con successo";
            }
            catch (Exception ex)
            {
                transaction.Rollback();
                result.Success = false;
                result.Message = "Errore durante il salvataggio: " + ex.Message;
            }
        }
        
        return result;
    }
}
