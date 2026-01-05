using System.Data.SqlClient;
using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Web;

public class EconomicsProgetto
{
    public int Projects_Id;
    public string ProjectCode;

    public double BurnRate { get; set; }

    public double RevenueBDG { get; set; }
    public double RevenueACT { get; set; }
    public double RevenueEAC { get; set; }

    public double SpeseBDG { get; set; }
    public double SpeseACT { get; set; }
    public double SpeseEAC { get; set; }

    public double MargineBDG { get; set; }
    public double MargineACT { get; set; }
    public double MargineEAC { get; set; }

    public double CostiBDG { get; set; }
    public double CostiACT { get; set; }
    public double CostiEAC { get; set; }

    public double WriteUpACT { get; set; }
    public double WriteUpEAC { get; set; }

    public double GiorniActual { get; set; }

    public string TipoContratto { get; set; }

    public double MesiCopertura { get; set; }
    public int status { get; set; }
    public string tooltip { get; set; }

    public DateTime PrimaDataCarico { get; set; }
    public DateTime UltimaDataCarico { get; set; }
    public DateTime DataFineProgetto { get; set; }

    /* ✅ Estrae dati dalla vista unica v_ProjectEconomicsReport */
    public EconomicsProgetto(string projectIdOrCode)
    {
        // Recupera la data di cutoff dalla sessione corrente
        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];
        DateTime dataCutoff = CurrentSession.dCutoffDate;
        string annoMeseCutoff = dataCutoff.ToString("yyyy-MM");

        // ✅ Query semplice sulla vista unica
        string query = "SELECT * FROM [MSSql12155].[v_ProjectEconomicsReport] " +
                      "WHERE AnnoMese = " + ASPcompatility.FormatStringDb(annoMeseCutoff);

        // Filtro per Projects_id o ProjectCode
        int projectId;
        if (int.TryParse(projectIdOrCode, out projectId))
            query += " AND Projects_id = " + ASPcompatility.FormatNumberDB(projectId);
        else
            query += " AND ProjectCode = " + ASPcompatility.FormatStringDb(projectIdOrCode);

        DataTable dt = Database.GetData(query);

        if (dt.Rows.Count == 0)
        {
            throw new Exception(string.Format(
                "Nessun dato trovato in ProjectEconomics per il progetto '{0}' nel mese {1}. Eseguire SPcontrolloProgetti_V4.",
                projectIdOrCode, annoMeseCutoff));
        }

        DataRow dr = dt.Rows[0];

        // ✅ Carica TUTTI i dati dalla vista
        CaricaDatiDaView(ref dr);

        // ✅ Calcola status e tooltip
        int recordWithoutCost = dr["RecordWithoutCost"] != DBNull.Value
            ? Convert.ToInt32(dr["RecordWithoutCost"]) : 0;
        CalcolaStatusETooltip(recordWithoutCost, dataCutoff);
    }

    //** ✅ Carica tutti i dati dalla vista **
    private void CaricaDatiDaView(ref DataRow dr)
    {
        // Identificativi
        Projects_Id = (int)dr["Projects_id"];
        ProjectCode = dr["ProjectCode"].ToString();
        TipoContratto = dr["TipoContratto"] != DBNull.Value ? dr["TipoContratto"].ToString() : "";

        /** Budget **/
        RevenueBDG = InitField("RevenueBDG", ref dr);
        SpeseBDG = InitField("SpeseBDG", ref dr);
        MargineBDG = InitField("MargineBDG", ref dr);
        CostiBDG = InitField("CostiBDG", ref dr);

        /** Actual **/
        RevenueACT = InitField("RevenueACT", ref dr);
        CostiACT = InitField("CostACT", ref dr);
        SpeseACT = InitField("SpeseACT", ref dr);
        MargineACT = InitField("MargineACT", ref dr);
        WriteUpACT = InitField("WriteUpACT", ref dr);
        GiorniActual = InitField("GiorniActual", ref dr);

        /** EAC **/
        RevenueEAC = InitField("RevenueEAC", ref dr);
        CostiEAC = InitField("CostiEAC", ref dr);
        SpeseEAC = InitField("SpeseEAC", ref dr);
        MargineEAC = InitField("MargineEAC", ref dr);
        WriteUpEAC = InitField("WriteUpEAC", ref dr);

        /** Metriche **/
        BurnRate = InitField("BurnRate", ref dr);
        MesiCopertura = InitField("MesiCopertura", ref dr);

        /* Date */
        if (dr["PrimaDataCarico"] != DBNull.Value)
            PrimaDataCarico = (DateTime)dr["PrimaDataCarico"];

        if (dr["UltimaDataCarico"] != DBNull.Value)
            UltimaDataCarico = (DateTime)dr["UltimaDataCarico"];

        if (dr["DataFineProgetto"] != DBNull.Value)
            DataFineProgetto = (DateTime)dr["DataFineProgetto"];
    }

    //** Inizializza variabile da DataRow **
    private static float InitField(string fieldName, ref DataRow dr)
    {
        return dr[fieldName] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr[fieldName]);
    }

    //** ✅ Calcola Status e Tooltip **
    private void CalcolaStatusETooltip(int recordWithoutCost, DateTime dataCutoff)
    {
        string errMsg = "";

        // Validazioni
        if (GiorniActual == 0)
        {
            errMsg += "<li>Nessun giorno caricato sul progetto</li>";
        }

        if (MargineBDG == 0)
        {
            errMsg += "<li>Margine proposta non specificato</li>";
        }

        if (DataFineProgetto == DateTime.MinValue)
        {
            errMsg += "<li>Data fine progetto non specificata</li>";
        }
        else if (dataCutoff > DataFineProgetto)
        {
            errMsg += "<li>Data fine progetto scaduta</li>";
        }

        if (recordWithoutCost > 0)
        {
            if (TipoContratto == "FORFAIT")
                errMsg += "<li>Cost Rate mancante</li>";
            else
                errMsg += "<li>Cost Rate e Bill rate consulenti mancanti</li>";
        }

        // Determina status
        if (errMsg != "")
        {
            status = 2; // Orange
            tooltip = "Errori da controllare:<ul>" + errMsg + "</ul>";
        }
        else if (WriteUpEAC > 0)
        {
            status = 0; // Green
            tooltip = "Writeup positivo!";
        }
        else
        {
            status = 1; // Red
            tooltip = "Writeoff negativo!";
        }
    }
}

public class ControlloProgetto
{
    /* ✅ Estrae Dataset dalla vista unica con filtri WHERE */
    public static DataSet PopolaDataset(string ProgettoReport, string ManagerReport, string TipoContratto = "0")
    {
        // Recupera la data di cutoff dalla sessione corrente
        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];
        DateTime dataCutoff = CurrentSession.dCutoffDate;
        string annoMeseCutoff = dataCutoff.ToString("yyyy-MM");

        // ✅ Query semplice sulla vista unica con filtri applicati via WHERE
        string query = "SELECT * FROM [MSSql12155].[v_ProjectEconomicsReport] " +
                      "WHERE AnnoMese = " + ASPcompatility.FormatStringDb(annoMeseCutoff) +
                      " AND Active = 1 " +
                      " AND TipoContratto_id IN (1, 2)"; // Solo T&M e FIXED

        // Applica filtri opzionali
        if (ProgettoReport != "0")
            query += " AND Projects_id = " + ASPcompatility.FormatStringDb(ProgettoReport);

        if (ManagerReport != "0")
            query += " AND (ClientManager_id = " + ASPcompatility.FormatStringDb(ManagerReport) +
                     " OR AccountManager_id = " + ASPcompatility.FormatStringDb(ManagerReport) + ")";

        if (TipoContratto != "0")
            query += " AND TipoContratto_id = " + ASPcompatility.FormatStringDb(TipoContratto);

        query += " ORDER BY ProjectCode";

        // Esegue la query
        DataTable dt = Database.GetData(query);

        // Crea il DataSet
        DataSet ds = new DataSet();
        dt.TableName = "Export";
        ds.Tables.Add(dt);

        if (ds.Tables["Export"].Rows.Count == 0)
        {
            return ds;
        }

        // ✅ Aggiunge solo colonne UI (Status, ImgUrl, ToolTip)
        AggiungiColonneUI(ref ds);

        // ✅ Calcola solo Status e Tooltip
        CalcolaStatusETooltip(ref ds, dataCutoff);

        return ds;
    }

    //** ✅ Aggiunge solo colonne per UI **
    private static void AggiungiColonneUI(ref DataSet ds)
    {
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string));
        ds.Tables["Export"].Columns.Add("ToolTip", typeof(string));
        ds.Tables["Export"].Columns.Add("TooltipDataFine", typeof(string));
    }

    //** ✅ Calcola solo Status e Tooltip **
    private static void CalcolaStatusETooltip(ref DataSet ds, DateTime dataCutoff)
    {
        foreach (DataRow dr in ds.Tables["Export"].Rows)
        {
            string errMsg = "";
            bool hasErrors = false;

            // Validazioni
            float giorniActual = dr["GiorniActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["GiorniActual"]);
            int recordWithoutCost = dr["RecordWithoutCost"] == DBNull.Value ? 0 : Convert.ToInt32(dr["RecordWithoutCost"]);
            DateTime dataFine = dr["DataFine"] != DBNull.Value ? (DateTime)dr["DataFine"] : DateTime.MinValue;

            if (giorniActual == 0)
            {
                errMsg += "<li>Nessun giorno caricato sul progetto</li>";
                hasErrors = true;
            }

            if (dr["MargineBDG"] == DBNull.Value)
            {
                errMsg += "<li>Margine proposta non specificato</li>";
                hasErrors = true;
            }

            if (dataFine == DateTime.MinValue)
            {
                errMsg += "<li>Data fine progetto non specificata</li>";
                hasErrors = true;
            }
            else if (dataCutoff > dataFine)
            {
                errMsg += "<li>Data fine progetto scaduta</li>";
            }

            if (recordWithoutCost > 0)
            {
                hasErrors = true;
                string tipoContratto = dr["TipoContratto"].ToString();
                if (tipoContratto == "FORFAIT")
                    errMsg += "<li>Cost Rate mancante</li>";
                else
                    errMsg += "<li>Cost Rate e Bill rate consulenti mancanti</li>";
            }

            // Imposta Status
            if (hasErrors)
            {
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/question-mark.png";
                dr["ToolTip"] = "Errori da controllare:<ul>" + errMsg + "</ul>";
            }
            else
            {
                double writeUpEAC = dr["WriteUpEAC"] == DBNull.Value ? 0 : Convert.ToDouble(dr["WriteUpEAC"]);

                if (writeUpEAC > 0)
                {
                    dr["Status"] = "G";
                    dr["ImgUrl"] = "/timereport/images/icons/other/ok_icon.png";
                    dr["ToolTip"] = "Writeup positivo!";
                }
                else
                {
                    dr["Status"] = "R";
                    dr["ImgUrl"] = "/timereport/images/icons/other/warning.png";
                    dr["ToolTip"] = "Writeoff negativo!";
                }
            }
        }
    }

    /* ✅ INVARIATO: Lancia procedura di calcolo costi */
    public static DataSet CalcolaCosti(DateTime daData, int project_id, int overwrite)
    {
        List<SqlParameter> parametersList = new List<SqlParameter>();

        if (project_id != 0)
            parametersList.Add(new SqlParameter("@Project_id", project_id));

        parametersList.Add(new SqlParameter("@fromDate", daData));
        parametersList.Add(new SqlParameter("@overwrite", overwrite));

        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure per calcolo costi Hours
        DataSet result = Database.ExecuteStoredProcedure("REV3_HoursCostAndRevenueUpdate", parameters);

        // ✅ Dopo aver calcolato i costi, aggiorna ProjectEconomics
        AggiornaDatiEconomics(project_id);

        return result;
    }

    /* ✅ Aggiorna ProjectEconomics dopo calcolo costi */
    private static void AggiornaDatiEconomics(int? projectId = null)
    {
        List<SqlParameter> parametersList = new List<SqlParameter>();

        if (projectId.HasValue && projectId.Value != 0)
            parametersList.Add(new SqlParameter("@Project_id", projectId.Value));

        SqlParameter[] parameters = parametersList.ToArray();

        // Esegue la stored procedure che calcola e salva tutti i valori
        Database.ExecuteStoredProcedure("SPcontrolloProgetti_V4", parameters);
    }

    /* ✅ INVARIATO: Numero record non valorizzati */
    public static int NumeroRecorSenzaCosti(DateTime dataDa, int Projects_id)
    {
        int numRec;
        string sQuery = "SELECT COUNT(*) FROM v_oreWithCost " +
                       "WHERE (hours > 0 AND (OreRicavi = 0 OR OreRicavi IS NULL)) " +
                       "AND data > " + ASPcompatility.FormatDatetimeDb(dataDa) +
                       " AND ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"];

        if (Projects_id != 0)
            sQuery += " AND Projects_id = " + ASPcompatility.FormatNumberDB(Projects_id);

        numRec = Convert.ToInt32(Database.ExecuteScalar(sQuery, null));

        return numRec;
    }

    /* ✅ INVARIATO: Estrae giorni con costi */
    public static DataTable EstraiGiorniCosti(string ProgettoReport, string ManagerReport)
    {
        string sQuery;

        // Recupera la data di cutoff dalla sessione corrente
        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];
        DateTime dataCutoff = CurrentSession.dCutoffDate;

        sQuery = "SELECT * FROM v_oreWithCost " +
                "WHERE Active = 1 " +
                "AND Data <= " + ASPcompatility.FormatDatetimeDb(dataCutoff) +
                " AND ProjectType_id = '" + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + "'";

        if (ProgettoReport != "0")
            sQuery += " AND Projects_id = " + ProgettoReport;

        if (ManagerReport != "0")
            sQuery += " AND (ClientManager_id = " + ManagerReport +
                     " OR AccountManager_id = " + ManagerReport + ")";

        sQuery += " ORDER BY Consulente, Data";

        return Database.GetData(sQuery, null);
    }
}