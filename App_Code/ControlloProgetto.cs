using System.Data.SqlClient;
using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using System.Security.RightsManagement;
using System.Activities.Expressions;

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

    /* estrae dati di singolo progetto */
    public EconomicsProgetto(string DataReport, string ProgettoReport)
    {
        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        // il codice manager non serve essendo chiamato per il singolo progetto
        DataSet ds = ControlloProgetto.PopolaDataset(DataReport, ProgettoReport, "0");

        DataRow dr = ds.Tables["Export"].Rows[0]; // record relativo al progetto selezionato

        Projects_Id = (int)dr["Projects_Id"];
        ProjectCode = dr["ProjectCode"].ToString();
        TipoContratto = dr["TipoContratto"].ToString();

        /** Revenue **/
        RevenueBDG = InitField("RevenueBDG", ref dr); 
        RevenueACT = InitField("RevenueACT", ref dr);
        RevenueEAC = InitField("RevenueEAC", ref dr);

        /** Spese **/
        SpeseBDG = InitField("SpeseBDG", ref dr); 
        SpeseACT = InitField("SpeseACT", ref dr);
        SpeseEAC = InitField("SpeseEAC", ref dr);

        /** Costi **/
        CostiBDG = InitField("CostiBDG", ref dr);
        CostiACT = InitField("CostiACT", ref dr);
        CostiEAC = InitField("CostiEAC", ref dr);

        /** Margine **/
        MargineBDG = InitField("MargineBDG", ref dr);
        MargineACT = InitField("MargineACT", ref dr); 
        MargineEAC = InitField("MargineEAC", ref dr);

        /** WriteUp **/
        WriteUpACT = InitField("WriteUpACT", ref dr);
        WriteUpEAC = InitField("WriteUpEAC", ref dr);

        GiorniActual = InitField("GiorniActual", ref dr);
        MesiCopertura = InitField("MesiCopertura", ref dr);
        BurnRate = InitField("BurnRate", ref dr);

        /* Valorizza le date */
        if (dr["PrimaDataCarico"].ToString() != "")
            PrimaDataCarico = (DateTime)dr["PrimaDataCarico"];

        if (dr["UltimaDataCarico"].ToString() != "")
            UltimaDataCarico = (DateTime)dr["UltimaDataCarico"];

        if (dr["UltimaDataCarico"].ToString() != "")
            DataFineProgetto = (DateTime)dr["DataFine"];

        tooltip = dr["tooltip"].ToString();

    }

    //** inizializza variabile **
    private static float InitField(string fieldName, ref DataRow dr)
    {
        return dr[fieldName] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr[fieldName]);
    }

}

public class ControlloProgetto
{

    /* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */
    public static DataSet PopolaDataset(string DataReport, string ProgettoReport, string ManagerReport)
    {

        List<SqlParameter> parametersList = new List<SqlParameter>();

        // Se DDL non valorizzata passa NULL al parametro
        if (ProgettoReport != "0")
            parametersList.Add(new SqlParameter("@Project_id", Convert.ToInt16(ProgettoReport)));

        // Se DDL non valorizzata passa NULL al parametro
        if (ManagerReport != "0")
            parametersList.Add(new SqlParameter("@Manager_id", Convert.ToInt16(ManagerReport)));

        parametersList.Add(new SqlParameter("@DataReport", Convert.ToDateTime(DataReport)));
        parametersList.Add(new SqlParameter("@TipoCalcolo", 0));

        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        DataSet ds = Database.ExecuteStoredProcedure("SPcontrolloProgetti", parameters);

        // *** Aggiunge colonne calcolate
        AggiungiColonne(ref ds);

        // Calcola colonne
        CalcolaColonne(ref ds, DataReport);

        return (ds);
    }

    //** Aggiunge le colonne che vengono calcolate programmaticamente e non dalla query **//
    private static void AggiungiColonne(ref DataSet ds)
    {
        ds.Tables["Export"].Columns.Add("BurnRate", typeof(Double));
        ds.Tables["Export"].Columns.Add("MesiCopertura", typeof(Double));
        ds.Tables["Export"].Columns.Add("RevenueEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("SpeseEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("MargineACT", typeof(Double));
        ds.Tables["Export"].Columns.Add("MargineEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("CostiBDG", typeof(Double));
        ds.Tables["Export"].Columns.Add("CostiEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("WriteUpACT", typeof(Double));
        ds.Tables["Export"].Columns.Add("WriteUpEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine
        ds.Tables["Export"].Columns.Add("ToolTip", typeof(string)); // Commento
        ds.Tables["Export"].Columns.Add("TooltipDataFine", typeof(string)); // ToolTip sfondo data fine

        return;
    }

    // Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    public static void CalcolaColonne(ref DataSet ds, string DataReport)
    {
        Boolean flabort = false;

        foreach (DataRow dr in ds.Tables["Export"].Rows)
        {

            flabort = false;

            //*** Inizio controllo dati ** //
            float RecordWithoutCost = dr["RecordWithoutCost"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RecordWithoutCost"]);
            DateTime TBDataReport = Convert.ToDateTime(DataReport);
            DateTime dataFineProgetto = dr["DataFine"] != DBNull.Value ? (DateTime)dr["DataFine"] : new DateTime(2001, 1, 1);
            DateTime primaDataCarico = dr["PrimaDataCarico"] != DBNull.Value ? (DateTime)dr["PrimaDataCarico"] : new DateTime(2001, 1, 1);
            DateTime ultimaDataCarico = dr["UltimaDataCarico"] != DBNull.Value ? (DateTime)dr["UltimaDataCarico"] : new DateTime(2001, 1, 1);

            string errMsg = "";

            // se giorni di carico sono zero cancella il record
            if (dr["GiorniActual"].ToString() == "")
            {
                errMsg += "<li>Nessun giorno caricato sul progetto</li>";
                flabort = true;
            }

            if (dr["MargineBDG"] == DBNull.Value)
            {
                errMsg += "<li>Margine proposta non specificato</li>";
                flabort = true;
            }

            if (dr["DataFine"] == DBNull.Value)
            {
                errMsg += "<li>Data fine progetto non specificata</li>";
                flabort = true;
            }
            else if (DateTime.Now > (DateTime)dr["DataFine"])
            {
                errMsg += "<li>Data fine progetto scaduta</li>";
            }

            if (RecordWithoutCost != 0)
            {
                flabort = true;
                if (dr["TipoContratto"].ToString() == "FORFAIT")
                    errMsg += "<li>Cost Rate</li>";
                else
                    errMsg += "<li>Cost Rate e Bill rate consulenti</li>";
            }

            if (errMsg != "")
            {
                errMsg = "Errori da controllare:<ul>" + errMsg + "</ul>";
            }

            // se true mancano dati obbligatori per calcolo ACT, abortisce
            if (flabort)
            {
                // annulla valori calcolati perchè non tutti i dati sono presenti
                dr["RevenueACT"] = 0;
                dr["BurnRate"] = 0;
                dr["MesiCopertura"] = 0;
                dr["WriteUpEAC"] = 0;
                dr["GiorniActual"] = 0;
                dr["SpeseACT"] = 0;

                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/question-mark.png";
                dr["ToolTip"] = errMsg;
                continue;
            }

            //*** Fine controllo dati ** //

            //*** calcola valori dalla query
            int giorniLavorativi = CommonFunction.NumeroGiorniLavorativi(primaDataCarico, TBDataReport);
            int giorniLavorativiRestanti=0;

            //*** calcola ACTUALS
            float dRevenueACT = dr["RevenueACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueACT"]);
            float dSpeseACT = dr["SpeseACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseACT"]);
            float dCostiACT = dr["CostiACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiACT"]);

            //*** calcola BUDGET
            float dRevenueBDG = dr["RevenueBDG"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBDG"]);
            dr["CostiBDG"] = Math.Round((dRevenueBDG) * (1 - Convert.ToDouble(dr["MargineBDG"])), 2);

            dr["MargineACT"] = Math.Round((dRevenueACT - dCostiACT) / dRevenueACT, 2);
            //dr["WriteUpACT"] = Math.Round(dRevenueBDG - dRevenueACT, 2);

            // i giorni per calcolo EAC sono 
            // se la data fine progetto è > data ultimo carico -> EAC = ACT + BR * ( data fine progetto - data report )
            // se la data fine progetto è < data ultimo carico e data report < data ultimo carico -> EAC = ACT + BR * ( data ultimo carico - data report ) con WARNING
            // se la data fine progetto è < data ultimo carico e data report > data ultimo carico -> EAC = ACT

            if (dataFineProgetto >= ultimaDataCarico)
                if (dataFineProgetto > TBDataReport)
                    giorniLavorativiRestanti = CommonFunction.NumeroGiorniLavorativi(TBDataReport, dataFineProgetto); 
                else
                    giorniLavorativiRestanti = 0;

            if (dataFineProgetto < ultimaDataCarico)
               if (ultimaDataCarico > TBDataReport)
                    giorniLavorativiRestanti = CommonFunction.NumeroGiorniLavorativi(TBDataReport, ultimaDataCarico);
                else
                    giorniLavorativiRestanti = 0;

            float dBurnRate = (float)Math.Round(dRevenueACT / giorniLavorativi, 2);
            float dSpeseBurnRate = (float)Math.Round(dSpeseACT / giorniLavorativi, 2);
            float dCostiBurnRate = (float)Math.Round(dCostiACT / giorniLavorativi, 2);

            dr["BurnRate"] = dBurnRate;

            // *** CALCOLO EAC CON ETC DA ProjectEconomics ***
            int projectId = (int)dr["Projects_Id"];
            string annoMeseReport = TBDataReport.ToString("yyyy-MM");
            float etcFromDB = GetETCFromProjectEconomics(projectId, annoMeseReport);

            // RevenueEAC: usa ETC se presente, altrimenti BurnRate
            float revenueEAC;
            if (etcFromDB > 0)
            {
                // Usa ETC da ProjectEconomics
                revenueEAC = dRevenueACT + etcFromDB;
            }
            else
            {
                // Usa calcolo tradizionale con BurnRate
                revenueEAC = dRevenueACT + (dBurnRate * giorniLavorativiRestanti);
            }
            
            dr["RevenueEAC"] = Math.Round(revenueEAC, 2);
            dr["WriteUpEAC"] = Math.Round(dRevenueBDG - revenueEAC, 2);
            dr["SpeseEAC"] = Math.Round(dSpeseACT + dSpeseBurnRate * giorniLavorativiRestanti, 2);
            dr["CostiEAC"] = Math.Round(dCostiACT + dCostiBurnRate * giorniLavorativiRestanti, 2);
            dr["MargineEAC"] = Math.Round( ( dRevenueBDG - Convert.ToDouble(dr["CostiEAC"]) ) / dRevenueBDG, 2);

            // Se writeup positivo calcola mesi di copertura altrimenti li forza a zero
            dr["MesiCopertura"] = Math.Round(((dRevenueBDG - dRevenueACT) / Convert.ToDouble(dr["BurnRate"])) / 20, 2);

            if (Convert.ToDouble(dr["WriteUpEAC"]) > 0)
            {
                dr["status"] = "G";
                dr["ImgUrl"] = "/timereport/images/icons/other/ok_icon.png";
                dr["ToolTip"] = "Writeup positivo!";
            }
            else
            {
                dr["status"] = "R";
                dr["ImgUrl"] = "/timereport/images/icons/other/warning.png";
                dr["ToolTip"] = "Writeoff negativo!";
            }
        }

        return;
    }

    // *** NUOVO METODO: Recupera ETC da ProjectEconomics per mesi futuri ***
    private static float GetETCFromProjectEconomics(int projectId, string annoMeseReport)
    {
        string query = @"SELECT ISNULL(SUM(ETC), 0) as TotalETC
                        FROM ProjectEconomics
                        WHERE Projects_id = " + projectId + 
                       " AND AnnoMese > '" + annoMeseReport + "'";

        object result = Database.ExecuteScalar(query, null);
        return result != DBNull.Value && result != null ? Convert.ToSingle(result) : 0f;
    }

    /* lancia procedura di calcolo costi */
    public static DataSet CalcolaCosti( DateTime daData, int project_id, int overwrite) {

        List<SqlParameter> parametersList = new List<SqlParameter>();
        
        if (project_id !=0 )
            parametersList.Add(new SqlParameter("@Project_id", project_id));

        parametersList.Add(new SqlParameter("@fromDate", daData));
        parametersList.Add(new SqlParameter("@overwrite", overwrite));

        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure con supporto margine mensile da ProjectEconomics
        DataSet result = Database.ExecuteStoredProcedure("REV3_HoursCostAndRevenueUpdate", parameters);
        
        return result;
    }

    /* numero record non valorizzati da una certa data */
    public static int NumeroRecorSenzaCosti(DateTime dataDa, int Projects_id) {

        int numRec;
        string sQuery = "SELECT COUNT(*) FROM v_oreWithCost where ( hours > 0 and ( OreRicavi = 0 or OreRicavi is null ) ) AND data >" + ASPcompatility.FormatDatetimeDb(dataDa) +
                        " AND ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"];

        if (Projects_id != 0)
            sQuery += " AND Projects_id = " + ASPcompatility.FormatNumberDB(Projects_id);

        numRec = Convert.ToInt32(Database.ExecuteScalar(sQuery, null));

        return numRec;
    }

    /* Estrae giorni con costi */
    public static DataTable EstraiGiorniCosti(string DataReport, string ProgettoReport, string ManagerReport) {
        string sQuery;

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        sQuery = "SELECT * FROM v_oreWithCost WHERE Active = 1 AND Data <= " + ASPcompatility.FormatDatetimeDb(Convert.ToDateTime(DataReport)) +
                                         " AND ProjectType_id = '" + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + "'";

        if (ProgettoReport != "0")
            sQuery += " AND Projects_id = " + ProgettoReport;

        if (ManagerReport != "0")
            sQuery += " AND ( ClientManager_id = " + ManagerReport + " OR AccountManager_id = " + ManagerReport + ")";

        sQuery += " ORDER BY Consulente, Data";

        return (Database.GetData(sQuery, null));

    }

}
