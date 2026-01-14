<%@ WebService Language="C#" Class="WS_ControlloProgetto" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using Newtonsoft.Json; // ✅ FIX Problema 1: Namespace per JsonConvert

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
    public decimal? ETC { get; set; }
    public decimal? Margine { get; set; }
    public string RecordToUpdate { get; set; }
}

// ✅ Classe per deserializzazione
public class ProjectEconomicsRecord
{
    public int Projects_id { get; set; }
    public string AnnoMese { get; set; }
    public decimal? ETC { get; set; }
    public decimal? Margine { get; set; }
}

// ✅ Classe per risposta save
public class SaveResult
{
    public bool Success { get; set; }
    public string Message { get; set; }
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
                    
                    // ✅ Se Margine è NULL nella tabella, usa il default dal progetto
                    if (rdr.IsDBNull(rdr.GetOrdinal("Margine")))
                    {
                        row["Margine"] = margineDefault.HasValue ? (object)margineDefault.Value : null;
                    }
                    else
                    {
                        // ✅ Moltiplica per 100 il margine dal DB (0.35 → 35)
                        row["Margine"] = (object)(rdr.GetDecimal(rdr.GetOrdinal("Margine")) * 100);
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
    public SaveResult SaveEconomicsData(string[] economicsTable)
    {
        try
        {
            CurrentSession = (TRSession)Session["CurrentSession"];
            string userName = CurrentSession != null ? CurrentSession.UserName : "System";
            
            string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                foreach (string jsonRecord in economicsTable)
                {
                    // ✅ FIX Problema 1: JsonConvert ora disponibile
                    var record = JsonConvert.DeserializeObject<ProjectEconomicsRecord>(jsonRecord);
                    
                    string query = @"
                        MERGE [MSSql12155].[ProjectEconomics] AS target
                        USING (SELECT @Projects_id AS Projects_id, @AnnoMese AS AnnoMese) AS source
                        ON target.Projects_id = source.Projects_id AND target.AnnoMese = source.AnnoMese
                        WHEN MATCHED THEN
                            UPDATE SET 
                                ETC = @ETC, 
                                Margine = @Margine / 100.0, 
                                LastModificationDate = GETDATE(),
                                LastModifiedBy = @User
                        WHEN NOT MATCHED THEN
                            INSERT (Projects_id, AnnoMese, ETC, Margine, CreationDate, CreatedBy)
                            VALUES (@Projects_id, @AnnoMese, @ETC, @Margine / 100.0, GETDATE(), @User);";
                    
                    // ✅ FIX Problema 3: Usa SqlCommand invece di Database.ExecuteNonQuery
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Projects_id", record.Projects_id);
                        cmd.Parameters.AddWithValue("@AnnoMese", record.AnnoMese);
                        cmd.Parameters.AddWithValue("@ETC", (object)record.ETC ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Margine", (object)record.Margine ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@User", userName); // ✅ FIX Problema 2
                        
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            
            return new SaveResult { Success = true, Message = "Dati salvati con successo" };
        }
        catch (Exception ex)
        {
            return new SaveResult { Success = false, Message = ex.Message };
        }
    }
}
