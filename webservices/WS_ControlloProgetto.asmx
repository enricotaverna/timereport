<%@ WebService Language="C#" Class="WS_ControlloProgetto" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using Newtonsoft.Json;

// ✅ Classe per i dati del progetto
public class ProjectData
{
    public int Projects_Id { get; set; }
    public decimal RevenueBudget { get; set; }
    public decimal SpeseBudget { get; set; }
    public bool SpeseForfait { get; set; }
    public decimal MargineProposta { get; set; }
    public string DataFine { get; set; }
    public string DataInizio { get; set; }
    public bool NoOvertime { get; set; }
}

// Struttura dati per singolo mese Economics
public class EconomicsMonthData 
{
    public string AnnoMese { get; set; }
    public string CostETC { get; set; }
    public string Margine { get; set; }
}

// Struttura dati per Economics completo (usato per SAVE)
public class EconomicsData 
{
    public int Projects_id { get; set; }
    public string AnnoMese { get; set; }
    public decimal? CostETC { get; set; }
    public decimal? Margine { get; set; }
    public string RecordToUpdate { get; set; }
}

// Classe per deserializzazione
public class ProjectEconomicsRecord
{
    public int Projects_id { get; set; }
    public string AnnoMese { get; set; }
    public decimal? CostETC { get; set; }
    public decimal? Margine { get; set; }
}

// Classe per risposta save
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

    // ✅ NUOVO METODO: SaveProjectData
    [WebMethod(EnableSession = true)]
    public SaveResult SaveProjectData(ProjectData projectData)
    {
        try
        {
            CurrentSession = (TRSession)Session["CurrentSession"];
            
            if (CurrentSession == null)
            {
                return new SaveResult { Success = false, Message = "Sessione non valida" };
            }

            // Validazioni
            if (projectData.Projects_Id <= 0)
            {
                return new SaveResult { Success = false, Message = "ID progetto non valido" };
            }

            // Converte MargineProposta da percentuale (es. 35) a decimale (0.35)
            decimal margineDecimale = projectData.MargineProposta / 100;

            string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string updateQuery = @"
                    UPDATE Projects 
                    SET RevenueBudget = @RevenueBudget, 
                        SpeseBudget = @SpeseBudget, 
                        SpeseForfait = @SpeseForfait, 
                        MargineProposta = @MargineProposta, 
                        DataFine = @DataFine, 
                        DataInizio = @DataInizio, 
                        NoOvertime = @NoOvertime, 
                        LastModificationDate = @LastModificationDate, 
                        LastModifiedBy = @LastModifiedBy  
                    WHERE Projects_Id = @Projects_Id";

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Projects_Id", projectData.Projects_Id);
                    cmd.Parameters.AddWithValue("@RevenueBudget", projectData.RevenueBudget);
                    cmd.Parameters.AddWithValue("@SpeseBudget", projectData.SpeseBudget);
                    cmd.Parameters.AddWithValue("@SpeseForfait", projectData.SpeseForfait);
                    cmd.Parameters.AddWithValue("@MargineProposta", margineDecimale);
                    cmd.Parameters.AddWithValue("@NoOvertime", projectData.NoOvertime);
                    cmd.Parameters.AddWithValue("@LastModifiedBy", CurrentSession.UserName);
                    cmd.Parameters.AddWithValue("@LastModificationDate", DateTime.Now);

                    // Gestione date (possono essere vuote)
                    if (!string.IsNullOrEmpty(projectData.DataInizio))
                    {
                        DateTime dataInizio;
                        if (DateTime.TryParse(projectData.DataInizio, out dataInizio))
                            cmd.Parameters.AddWithValue("@DataInizio", dataInizio);
                        else
                            cmd.Parameters.AddWithValue("@DataInizio", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DataInizio", DBNull.Value);
                    }

                    if (!string.IsNullOrEmpty(projectData.DataFine))
                    {
                        DateTime dataFine;
                        if (DateTime.TryParse(projectData.DataFine, out dataFine))
                            cmd.Parameters.AddWithValue("@DataFine", dataFine);
                        else
                            cmd.Parameters.AddWithValue("@DataFine", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@DataFine", DBNull.Value);
                    }

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        // Aggiorna i dati economici del progetto chiamando la stored procedure
                        AggiornaEconomicsProgetto(conn, projectData.Projects_Id);

                        return new SaveResult 
                        { 
                            Success = true, 
                            Message = "Dati progetto aggiornati con successo" 
                        };
                    }
                    else
                    {
                        return new SaveResult 
                        { 
                            Success = false, 
                            Message = "Nessun record aggiornato" 
                        };
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return new SaveResult 
            { 
                Success = false, 
                Message = "Errore durante il salvataggio: " + ex.Message 
            };
        }
    }

    // ✅ METODO PRIVATO: Aggiorna Economics dopo salvataggio
    private void AggiornaEconomicsProgetto(SqlConnection conn, int projectId)
    {
        try
        {
            using (SqlCommand cmd = new SqlCommand("SPcontrolloProgetti", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Project_id", projectId);
                cmd.ExecuteNonQuery();
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Errore AggiornaEconomicsProgetto: " + ex.ToString());
            throw;
        }
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
            
            // ✅ CORRETTO: Usa CostETC invece di ETC
            string queryEconomics = @"SELECT AnnoMese, CostETC, Margine 
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
                    
                    // ✅ CORRETTO: Leggi CostETC
                    row["CostETC"] = rdr.IsDBNull(rdr.GetOrdinal("CostETC")) ? null : (object)rdr.GetDecimal(rdr.GetOrdinal("CostETC"));
                    
                    if (rdr.IsDBNull(rdr.GetOrdinal("Margine")))
                    {
                        row["Margine"] = margineDefault.HasValue ? (object)margineDefault.Value : null;
                    }
                    else
                    {
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
                    Dictionary<string, object> emptyRow = new Dictionary<string, object>();
                    emptyRow["AnnoMese"] = annoMese;
                    emptyRow["CostETC"] = null;  // ✅ CORRETTO: Usa CostETC
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
            
            int projectId = 0;
            
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                
                foreach (string jsonRecord in economicsTable)
                {
                    var record = JsonConvert.DeserializeObject<ProjectEconomicsRecord>(jsonRecord);
                    
                    if (projectId == 0)
                        projectId = record.Projects_id;
                    
                    string query = @"
                        MERGE [MSSql12155].[ProjectEconomics] AS target
                        USING (SELECT @Projects_id AS Projects_id, @AnnoMese AS AnnoMese) AS source
                        ON target.Projects_id = source.Projects_id AND target.AnnoMese = source.AnnoMese
                        WHEN MATCHED THEN
                            UPDATE SET 
                                CostETC = @CostETC,
                                Margine = @Margine / 100.0, 
                                LastModificationDate = GETDATE(),
                                LastModifiedBy = @User
                        WHEN NOT MATCHED THEN
                            INSERT (Projects_id, AnnoMese, CostETC, Margine, CreationDate, CreatedBy)
                            VALUES (@Projects_id, @AnnoMese, @CostETC, @Margine / 100.0, GETDATE(), @User);";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Projects_id", record.Projects_id);
                        cmd.Parameters.AddWithValue("@AnnoMese", record.AnnoMese);
                        cmd.Parameters.AddWithValue("@CostETC", (object)record.CostETC ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@Margine", (object)record.Margine ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@User", userName);
                        
                        cmd.ExecuteNonQuery();
                    }
                }
                
                // ✅ Aggiorna Economics dopo il salvataggio
                if (projectId > 0)
                {
                    AggiornaEconomicsProgetto(conn, projectId);
                }
            }
            
            return new SaveResult { Success = true, Message = "Dati Economics salvati con successo" };
        }
        catch (Exception ex)
        {
            return new SaveResult { Success = false, Message = "Errore: " + ex.Message };
        }
    }
}
