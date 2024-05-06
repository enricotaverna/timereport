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

    public double MargineACT { get; set; }
    public double MargineEAC { get; set; }

    public double CostiBDG { get; set; }
    public double CostiACT { get; set; }
    public double CostiEAC { get; set; }


    public double GiorniActual { get; set; }
    
    public string TipoContratto { get; set; }
    public double WriteUp { get; set; }
    public double MesiCopertura { get; set; }
    public int status { get; set; }
    public DateTime PrimaDataCarico { get; set; }

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

        BurnRate = dr["BurnRate"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["BurnRate"]);

        /** Revenue **/
        RevenueBDG = dr["RevenueBDG"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBDG"]);
        RevenueACT = dr["RevenueACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueACT"]);
        RevenueEAC = dr["RevenueEAC"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueEAC"]);

        /** Spese **/
        SpeseBDG = dr["SpeseBDG"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseBDG"]);
        SpeseACT = dr["SpeseACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseACT"]);
        SpeseEAC = dr["SpeseEAC"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseEAC"]);

        /** Costi **/
        CostiBDG = dr["CostiBDG"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiBDG"]);
        CostiACT = dr["CostiACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiACT"]);
        CostiEAC = dr["CostiEAC"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiEAC"]);

        /** Margine **/
        MargineACT = dr["MargineACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["MargineACT"]);
        MargineEAC = dr["MargineEAC"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["MargineEAC"]);

        GiorniActual = dr["GiorniActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["GiorniActual"]);
        WriteUp = dr["WriteUp"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["WriteUp"]);
        MesiCopertura = dr["MesiCopertura"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["MesiCopertura"]);
        
        if (dr["PrimaDataCarico"].ToString() != "")
            PrimaDataCarico = (DateTime)dr["PrimaDataCarico"];
        
    }

}

public class ControlloProgetto
{
    /* lancia procedura di calcolo costi */
    public static DataSet CalcolaCosti( DateTime daData, int project_id, int overwrite) {

        List<SqlParameter> parametersList = new List<SqlParameter>();
        
        if (project_id !=0 )
            parametersList.Add(new SqlParameter("@Project_id", project_id));

        parametersList.Add(new SqlParameter("@fromDate", daData));
        parametersList.Add(new SqlParameter("@overwrite", overwrite));

        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        DataSet result = Database.ExecuteStoredProcedure("REV2_HoursCostAndRevenueUpdate", parameters);
        
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

        // Aggiunge colonne calcolate
        ds.Tables["Export"].Columns.Add("BurnRate", typeof(Double));
        ds.Tables["Export"].Columns.Add("MesiCopertura", typeof(Double));

        //ds.Tables["Export"].Columns.Add("RevenueACT", typeof(Double));
        ds.Tables["Export"].Columns.Add("RevenueEAC", typeof(Double));
        ds.Tables["Export"].Columns.Add("SpeseEAC", typeof(Double));

        ds.Tables["Export"].Columns.Add("MargineACT", typeof(Double));
        ds.Tables["Export"].Columns.Add("MargineEAC", typeof(Double));

        ds.Tables["Export"].Columns.Add("CostiBDG", typeof(Double));
        ds.Tables["Export"].Columns.Add("CostiEAC", typeof(Double));

        ds.Tables["Export"].Columns.Add("WriteUp", typeof(Double));
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine
        ds.Tables["Export"].Columns.Add("ToolTip", typeof(string)); // Commento
        ds.Tables["Export"].Columns.Add("TooltipDataFine", typeof(string)); // ToolTip sfondo data fine

        // Calcola colonne
        ds = ControlloProgetto.CalcolaColonne(ds, DataReport);

        return (ds);
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

    // Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    public static DataSet CalcolaColonne(DataSet ds, string DataReport)
    {

        foreach (DataRow dr in ds.Tables["Export"].Rows)
        {

            //*** Inizio controllo dati ** //

            float RecordWithoutCost = dr["RecordWithoutCost"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RecordWithoutCost"]);
            DateTime dtTBDataReport = Convert.ToDateTime(DataReport);
            DateTime dtDataFine = dr["DataFine"] != DBNull.Value ? (DateTime)dr["DataFine"] : new DateTime(2001, 1, 1);
            DateTime dtPrimaDataCarico = dr["PrimaDataCarico"] != DBNull.Value ? (DateTime)dr["PrimaDataCarico"] : new DateTime(2001, 1, 1);
            string errMsg = "";

            // se giorni di carico sono zero cancella il record
            if (dr["GiorniActual"].ToString() == "") {
                errMsg += "<li>Nessun giorno caricato sul progetto</li>";
            }


            if (dr["MargineProposta"] == DBNull.Value)
            {
                errMsg += "<li>Margine proposta non specificato</li>";
            }

            if (dr["DataFine"] == DBNull.Value)
            {
                errMsg += "<li>Data fine progetto non specificata</li>";
            }
            else if ( DateTime.Now > (DateTime)dr["DataFine"])
            {
                errMsg += "<li>Data fine progetto scaduta</li>";
            }

            if (RecordWithoutCost != 0) {

                if (dr["TipoContratto"].ToString() == "FORFAIT")
                    errMsg += "<li>Cost Rate</li>";
                else
                    errMsg += "<li>Cost Rate e Bill rate consulenti</li>";
            }

            if (errMsg != "") {
                errMsg = "Errori da controllare:<ul>" + errMsg + "</ul>";

            }

            if (errMsg != "")
            {
                // annulla valori calcolati perchè non tutti i dati sono presenti
                dr["RevenueACT"] = 0;
                dr["BurnRate"] = 0;
                dr["MesiCopertura"] = 0;
                dr["WriteUp"] = 0;
                dr["GiorniActual"] = 0;
                dr["SpeseACT"] = 0;

                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/question-mark.png";
                dr["ToolTip"] = errMsg;
                continue;
            }

            //*** Fine controllo dati ** //

            //*** recupera valori dalla query
            float dRevenueBDG = dr["RevenueBDG"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBDG"]);
            float dRevenueACT = dr["RevenueACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueACT"]);
            float dSpeseACT = dr["SpeseACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseACT"]);
            //float dRevenueEAC = 

            float dCostiActual = dr["CostiACT"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiACT"]);
            float dRevenueBDGNet = (float)dRevenueBDG;

            //*** calcola valori dalla query
            int giorniLavorativi = CommonFunction.NumeroGiorniLavorativi(dtPrimaDataCarico, Convert.ToDateTime(DataReport));
            float dBurnRate = (float)Math.Round(dRevenueACT / giorniLavorativi, 2);
            float dSpeseBurnRate = (float)Math.Round(dSpeseACT / giorniLavorativi, 2);
            float dCostiBurnRate = (float)Math.Round(dCostiActual / giorniLavorativi, 2);

            dr["BurnRate"] = dBurnRate;

            // se la data fine è nel futuro proietta writeup e mesi di copertura
            dr["WriteUp"] = Math.Round(dRevenueBDGNet - dRevenueACT - CommonFunction.NumeroGiorniLavorativi(dtTBDataReport, (DateTime)dr["DataFine"]) * Convert.ToDouble(dr["BurnRate"]), 2);

            // Calcolo BDG
            dr["CostiBDG"] = Math.Round( (dRevenueBDG) / ( 1 - Convert.ToDouble(dr["MargineProposta"])), 2);

            // calcolo ACT
            dr["MargineACT"] = Math.Round((dRevenueACT - dCostiActual) / dRevenueACT, 2);

            // calcolo EAC
            dr["RevenueEAC"] = Math.Round( dRevenueACT  + dBurnRate * giorniLavorativi, 2);
            dr["SpeseEAC"] = Math.Round(dSpeseACT + dSpeseBurnRate * giorniLavorativi, 2);
            dr["MargineEAC"] = Math.Round( Convert.ToDouble(dr["MargineProposta"]) + Convert.ToDouble(dr["WriteUp"]) / dRevenueACT, 2 );
            dr["CostiEAC"] = Math.Round(dCostiActual + dCostiBurnRate * giorniLavorativi, 2);

            // Se writeup positivo calcola mesi di copertura altrimenti li forza a zero
            dr["MesiCopertura"] = Math.Round(((dRevenueBDGNet - dRevenueACT) / Convert.ToDouble(dr["BurnRate"])) / 20, 2);

            if (Convert.ToDouble(dr["WriteUp"]) > 0)
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

        return (ds);
    }

}
