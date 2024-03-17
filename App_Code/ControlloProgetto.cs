using System.Data.SqlClient;
using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using System.Security.RightsManagement;

public class EconomicsProgetto
{
    public int Projects_Id;
    public string ProjectCode;
    public double RevenueBudget { get; set; }
    public double RevenueActual { get; set; }
    public double CostiActual { get; set; }
    public double SpeseActual { get; set; }
    public double GiorniActual { get; set; }
    public double MargineActual { get; set; }
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
        RevenueBudget = dr["RevenueBudget"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBudget"]);
        RevenueActual = dr["RevenueActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueActual"]);
        GiorniActual = dr["GiorniActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["GiorniActual"]);
        SpeseActual = dr["SpeseActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["SpeseActual"]);
        WriteUp = dr["WriteUp"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["WriteUp"]);
        MesiCopertura = dr["MesiCopertura"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["MesiCopertura"]);
        CostiActual = dr["CostiActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiActual"]);
        MargineActual = (RevenueActual - CostiActual) / RevenueActual;
        
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
        string sQuery = "SELECT COUNT(*) FROM v_oreWithCost where (OreRicavi = 0 or OreRicavi is null) AND data >=" + ASPcompatility.FormatDatetimeDb(dataDa) +
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
        ds.Tables["Export"].Columns.Add("MargineActual", typeof(Double));
        ds.Tables["Export"].Columns.Add("WriteUp", typeof(Double));
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine
        ds.Tables["Export"].Columns.Add("ToolTip", typeof(string)); // Commento
        ds.Tables["Export"].Columns.Add("ColoreDataFine", typeof(string)); // Colore sfondo data fine
        ds.Tables["Export"].Columns.Add("TooltipDataFine", typeof(string)); // ToolTip sfondo data fine

        // Calcola colonne
        ds = ControlloProgetto.CalcolaColonne(ds, DataReport);

        return (ds);
    }

    // Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    public static DataSet CalcolaColonne(DataSet ds, string DataReport)
    {

        foreach (DataRow dr in ds.Tables["Export"].Rows)
        {

            float dRevenueActual = dr["RevenueActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueActual"]);
            float dCostiActual = dr["CostiActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["CostiActual"]);
            float dRevenueBudget = dr["RevenueBudget"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBudget"]);
            float RecordWithoutCost = dr["RecordWithoutCost"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RecordWithoutCost"]);

            // se giorni di carico sono zero cancella il record
            if (dr["GiorniActual"].ToString() == "") { 
                dr.Delete();
                continue;
            }
            // netto budget ABAP
            //float dBudgetABAP = dr["BudgetABAP"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["BudgetABAP"]);


            //float dRevenueBudgetNet = RBTipoCalcolo.SelectedValue == "1" ? (float)dRevenueBudget - (float)dBudgetABAP : (float)dRevenueBudget;
            // eliminato il calcolo al netto del budget ABAP
            float dRevenueBudgetNet = (float)dRevenueBudget;

            // dr["BudgetNetto"] = dRevenueBudgetNet; // Budget revenue al netto del budget ABAP

            DateTime dtTBDataReport = Convert.ToDateTime(DataReport);
            DateTime dtDataFine = dr["DataFine"] != DBNull.Value ? (DateTime)dr["DataFine"] : new DateTime(2001, 1, 1);
            DateTime dtPrimaDataCarico = dr["PrimaDataCarico"] != DBNull.Value ? (DateTime)dr["PrimaDataCarico"] : new DateTime(2001, 1, 1);


            // se manca qualche dato obbligatorio mette a warning la colonna e salta i conti
            if (dr["PrimaDataCarico"] == DBNull.Value || dr["DataFine"] == DBNull.Value ||
                dRevenueBudget == 0)
            {
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/question-mark.png";
                dr["ToolTip"] = "Controllare dati del progetto/attività (date, budget)";
                continue;
            }

            if (RecordWithoutCost != 0)
            {
                // annulla valori calcolati perchè non tutti i dati sono presenti
                dr["RevenueActual"] = 0;
                dr["BurnRate"] = 0;
                dr["MesiCopertura"] = 0;
                dr["WriteUp"] = 0;
                dr["GiorniActual"] = 0;
                dr["SpeseActual"] = 0;

                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/question-mark.png";
                dr["ToolTip"] = "Impossibile valorizzare actual, controllare FLC delle persone e margine progetto";
                continue;
            }
           
            // Burn Rate = Revenue Actual / Giorni lavorativi da inizio progetto a data report
            // WriteUp/Off = Revenue Budget - Revenue Actual - (data fine - data report ) * BurnRate
            // mesi copertura =  (Revenue Budget - Revenue Actual ) / burnrate / 20
            //

            dr["BurnRate"] = Math.Round(dRevenueActual /
                             CommonFunction.NumeroGiorniLavorativi(dtPrimaDataCarico, Convert.ToDateTime(DataReport)), 2);

            // se la data fine è nel futuro proietta writeup e mesi di copertura
            if (dtTBDataReport < (DateTime)dr["DataFine"])
            {
                dr["WriteUp"] = Math.Round(dRevenueBudgetNet - dRevenueActual - CommonFunction.NumeroGiorniLavorativi(dtTBDataReport, (DateTime)dr["DataFine"]) * Convert.ToDouble(dr["BurnRate"]), 2);
                //dr["COloreDataFine"] = "#FFCC00";
                //dr["TooltipDataFine"] = "Data fine progetto nel futuro";
            }
            else
            {
                // calcola writeup/off senza proiezione
                dr["WriteUp"] = Math.Round(dRevenueBudgetNet - dRevenueActual, 2);
                // mette in arancione lo sfondo
                dr["ColoreDataFine"] = "#FFCC00";
                dr["TooltipDataFine"] = "Progetto terminato";
            }

            dr["MargineActual"] = Math.Round( Convert.ToDouble(dr["MargineProposta"]) + Convert.ToDouble(dr["WriteUp"]) / dRevenueActual, 2 );

            // Se writeup positivo calcola mesi di copertura altrimenti li forza a zero
            //if ((double)dr["WriteUp"] > 0)
                dr["MesiCopertura"] = Math.Round(((dRevenueBudgetNet - dRevenueActual) / Convert.ToDouble(dr["BurnRate"])) / 20, 2);
            //else
            //    dr["MesiCopertura"] = 0;

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
