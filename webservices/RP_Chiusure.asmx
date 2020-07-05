<%@ WebService Language="C#" Class="RP_Chiusure" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class RP_Chiusure : System.Web.Services.WebService
{

    public class CheckGiorni
    {
        public string persons_id;
        public int giorno;
        public int ore;
    }

    // Lista che contiene le giornate caricate da DB
    public List<CheckGiorni> lCheckGiorni = new List<CheckGiorni> { };

    public RP_Chiusure()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    // GetListaChiusure(string Mese, string Anno, )
    // meseLista, annoLista -> Situazione chiusura nel mese / anno
    //
    [WebMethod(EnableSession = true)]
    public string GetListaChiusure(string meseLista, string annoLista)
    {

        // Calcola mese precedente
        string sAnnoPrec = Convert.ToInt16(meseLista) == 1 ? (Convert.ToInt16(annoLista) - 1).ToString() : annoLista;
        string sMesePrec = Convert.ToInt16(meseLista) == 1 ? "12" : (Convert.ToInt16(meseLista) - 1).ToString();

        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMesePrec + "/" + sAnnoPrec, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnnoPrec), Convert.ToInt16(sMesePrec)) + "/" + sMesePrec + "/" + sAnnoPrec, false);

        // Inizializza tabella dt
        DataTable dt = new DataTable();
        dt.Columns.Add("Name");
        dt.Columns.Add("CompanyName");
        dt.Columns.Add("Manager");
        dt.Columns.Add("OreContratto");
        dt.Columns.Add("TRChiuso");
        dt.Columns.Add("GGmancanti");
        dt.Columns.Add("GGMesePrecedente");
        dt.Columns.Add("urlDetailPage");


        // carica tutte le ore del mese da DB
        CaricaOreMese(meseLista, annoLista);

        String sSelect = "SELECT  a.Persons_Id,  a.Name,  a.mail, a.CompanyName,  a.ManagerName, a.ContractHours, " +
                  " ( SELECT  SUM(Hours)  FROM hours where Persons_id =  a.Persons_id and hours.date >= " + sDataInizio + " and hours.date <= " + sDataFine + " ) as oreMesePrecedente, " +
                  " ( SELECT MAX(stato) from logTR Where LogTR.Mese=" + meseLista + " AND LogTR.Anno=" + annoLista + " AND persons_id=a.Persons_id ) as stato " +
                  " FROM v_Persons as a " +
                  " GROUP BY a.Persons_Id,  a.Name,  a.mail, a.CompanyName, a.ManagerName ,a.ContractHours  ORDER BY a.Name";

        // Esegue Select sulle persone attive
        DataTable dtPersons = Database.GetData(sSelect, null);

        // Loop sulle persone selezionate
        foreach (DataRow rdr in dtPersons.Rows)
        {

            DataRow dr = dt.NewRow();
            dr["Name"] = rdr["Name"];
            dr["CompanyName"] = rdr["CompanyName"];
            dr["Manager"] = rdr["ManagerName"];
            dr["OreContratto"] = rdr["ContractHours"];
            dr["GGmancanti"] = CalcolaGiorni(rdr["persons_id"].ToString(), Convert.ToInt16(rdr["ContractHours"]), meseLista, annoLista);

            // mette link in caso di giornate mancanti
            if (dr["GGMancanti"].ToString() != "")
                dr["urlDetailPage"] = "/timereport/report/checkInput/DettaglioOreNonCaricate.aspx?persons_id='" + rdr["persons_id"] + "'&mese=" + meseLista + "&anno=" + annoLista ;

            if (rdr["oreMesePrecedente"] != DBNull.Value)
                dr["GGMesePrecedente"] = Convert.ToInt16(rdr["oreMesePrecedente"]) > 0 ? Convert.ToInt16(rdr["oreMesePrecedente"]) / 8 : 0;
            else
                dr["GGMesePrecedente"] = 0;

            dr["TRChiuso"] = rdr["stato"].ToString() == "1" ? "true" : "false";

            dt.Rows.Add(dr);
        }

        // Popola stringa Json di ritorno
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;
        foreach (DataRow dr in dt.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dt.Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        string sRet = serializer.Serialize(rows);
        return sRet;
    }

    // Calcola Giorni mese precendente
    protected string GGMesePrecedente(string Persons_id, string sMese, string sAnno)
    {

        sMese = Convert.ToInt16(sMese) == 1 ? "12" : (Convert.ToInt16(sMese) - 1).ToString();
        sAnno = Convert.ToInt16(sMese) == 1 ? (Convert.ToInt16(sAnno) - 1).ToString() : sAnno;
        int sGiorni = 0;

        // Calcola mese precedente
        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMese + "/" + sAnno, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) + "/" + sMese + "/" + sAnno, false);

        string query = "SELECT SUM (hours) FROM hours WHERE Date >=" + sDataInizio + " AND  Date <=" + sDataFine + " AND HourType_Id = 1 AND persons_id=" + Persons_id;

        object result = Database.ExecuteScalar(query, null);
        if (result != DBNull.Value)
            sGiorni = Convert.ToInt16(result) > 0 ? Convert.ToInt16(result) / 8 : 0;

        return (sGiorni.ToString());

    }

    // Carica giorni in lista interna
    protected void CaricaOreMese(string sMese, string sAnno)
    {

        // per preparare la select
        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMese + "/" + sAnno, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) + "/" + sMese + "/" + sAnno, false);

        DataTable dtHours = Database.GetData("SELECT persons_id, date, hours FROM HOURS WHERE Date>=" + sDataInizio + "AND  Date<=" + sDataFine + " AND HourType_Id = 1", null);

        // carica tutte le ore del mese per tutte le persone nella lista lCheckGiorni

        if (dtHours.Rows.Count > 0)
        {

            foreach (DataRow rdr in dtHours.Rows)
            {
                CheckGiorni curr = new CheckGiorni();
                curr.persons_id = rdr["persons_id"].ToString();
                curr.giorno = Convert.ToDateTime(rdr["date"]).Day;
                curr.ore = Convert.ToInt16(rdr["hours"]);

                // carica lista
                lCheckGiorni.Add(curr);
            }
        }

    } // CaricaOreMese

    // Calcola i giorni mancanti nel mese
    protected int CalcolaGiorni(string sPersons_id, int iContractHours, string sMese, string sAnno)
    {

        // Calcolo giornate caricate
        // cicla sui giorni del mese selezionato		
        int iMissingDays = 0;

        for (int f = 1; f < System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)); f++)
        {

            int iHoursCounted = 0;

            // Data di riferimento in formato stringa			
            string sDate = f.ToString() + "/" + sMese + "/" + sAnno;

            //Salta sabato e domenica (i festivi sono di interesse per il controllo degli inserimenti nel TR)
            if ((DayOfWeek)(Convert.ToDateTime(sDate)).DayOfWeek != DayOfWeek.Saturday && (DayOfWeek)(Convert.ToDateTime(sDate)).DayOfWeek != DayOfWeek.Sunday)
            {
                // loop sulla lista per tutte le ore di persona / giorno
                foreach (CheckGiorni curr in lCheckGiorni.Where(curr => curr.persons_id == sPersons_id && curr.giorno == f))
                {
                    // Loop sulle ore
                    iHoursCounted = iHoursCounted + curr.ore;
                } // foreach

                if (iHoursCounted < iContractHours)
                    iMissingDays++;
            } // if
        } // for

        return (iMissingDays);
    }

}
    