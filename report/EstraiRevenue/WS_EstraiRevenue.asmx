<%@ WebService Language="C#" Class="WS_EstraiRevenue" %>

using System.Web.Services;
using System.Web.Script.Serialization;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

// definisce la struttura inviata dalla pagina per aggiornare i progetti
public class ProjectToUpdate
{
    public string trprojectsid { get; set; }
    public string sfengagementtype { get; set; }
    public string sfamount { get; set; }
    public string sfexpectedmargin { get; set; }
    public string sfexpectedfulfillmentdate { get; set; }
}


// definisce la struttura inviata dalla pagina per aggiornare Revenue Spese
public class RevenueProgetto
{
    public string ProjectsId { get; set; }
    public string RevenueVersionCode { get; set; }
    public string AnnoMese { get; set; }
    public string ProjectCode { get; set; }
    public string ProjectName { get; set; }
    public string RevenueSpese { get; set; }
}

// definisce la struttura  da ritornare con GetRevenueItem
public class RevenueMeseItem
{
    public int RevenueMese_id { get; set; }
    public string Comment { get; set; }
}

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]

// Per consentire la chiamata di questo servizio Web dallo script utilizzando ASP.NET AJAX, rimuovere il commento dalla riga seguente. 
[System.Web.Script.Services.ScriptService]
public class WS_EstraiRevenue  : System.Web.Services.WebService {

    // Check versione per consentire calcolo revenue
    [WebMethod(EnableSession = true)]
    public bool CheckVersion(string RevenueVersionCode, string Anno, string Mese)
    {

        if (RevenueVersionCode != "00")
            return true;

        string AnnoMese = Anno + "-" + Mese;

        if (Database.RecordEsiste("SELECT TOP(1) * FROM RevenueMese WHERE AnnoMese = " + ASPcompatility.FormatStringDb(AnnoMese) +
                                  " AND TipoRecord <> 'M' AND RevenueVersionCode=" + ASPcompatility.FormatStringDb(RevenueVersionCode)) )
            return false; // trovato, errore
        else
            return true; // tutto ok
    }

    // Aggiorna progetti dopo upload SF
    [WebMethod(EnableSession = true)]
    public bool UpdateProjects(string[] arr)
    {

        bool ret = true;

        JavaScriptSerializer js = new JavaScriptSerializer();


        // aggiorna dati TR con valori di SF
        for ( int i = 0; i < arr.Length; i++ )
        {
            ProjectToUpdate r =  js.Deserialize<ProjectToUpdate>(arr[i]);

            double dMargine = Convert.ToDouble(r.sfexpectedmargin) / 100;
            string sTipoContratto_id = r.sfengagementtype == "TM" ? "1" : "2";

            ret = Database.ExecuteSQL( "UPDATE Projects SET RevenueBudget = " + ASPcompatility.FormatNumberDB( Convert.ToDouble(r.sfamount)) +
                                       " , MargineProposta =" + ASPcompatility.FormatNumberDB(dMargine) +
                                       " , TipoContratto_id =" + ASPcompatility.FormatStringDb(sTipoContratto_id) +
                                       " , DataFine =" + ASPcompatility.FormatDateDb(r.sfexpectedfulfillmentdate) +
                                       "  WHERE Projects_id=" + ASPcompatility.FormatStringDb(r.trprojectsid), null);

            if (ret == false)
                break;
        }

        return ret;

    }

    // Check versione per consentire calcolo revenue
    [WebMethod(EnableSession = true)]
    public bool DeleteRevenueProgetti(string AnnoMese, string RevenueVersionCode)
    {
        bool ret = Database.ExecuteSQL("DELETE RevenueProgetto WHERE AnnoMese=" + ASPcompatility.FormatStringDb(AnnoMese) +
                                  " AND TipoRecord='M' AND RevenueVersionCode=" + ASPcompatility.FormatStringDb(RevenueVersionCode), null);

        return ret;
    }

    // Aggiorna progetti dopo upload SF
    [WebMethod(EnableSession = true)]
    public bool UpdateRevenueProgetti(string[] arr)
    {

        bool ret = true;

        JavaScriptSerializer js = new JavaScriptSerializer();

        // aggiorna dati TR con valori di SF
        for ( int i = 0; i < arr.Length; i++ )
        {
            RevenueProgetto r =  js.Deserialize<RevenueProgetto>(arr[i]);

            // recupera i dati obbligatori per il popolamento del record.
            DataRow drPrj = Database.GetRow("SELECT B.Descrizione as TipoProgetto, ClientManager_id, CodiceCliente as CodiceCliente FROM Projects as a " +
                                             "LEFT JOIN TipoContratto as b ON b.TipoContratto_id = a.TipoContratto_id " +
                                             "WHERE Projects_id = " + ASPcompatility.FormatStringDb(r.ProjectsId), null);

            if (drPrj == null )
                return false;

            DataRow drCli = Database.GetRow("SELECT Nome1 as NomeCliente FROM Customers " +
                                            "WHERE CodiceCliente = " + ASPcompatility.FormatStringDb(drPrj["CodiceCliente"].ToString()), null);

            string sDrCli = drCli != null ? drCli["NomeCliente"].ToString() : "";

            DataRow drMgr = Database.GetRow("SELECT Name as NomeManager FROM Persons " +
                                             "WHERE Persons_id = " + ASPcompatility.FormatStringDb(drPrj["ClientManager_id"].ToString()), null);

            string sDrMgr = drMgr != null ? drMgr["NomeManager"].ToString() : "";

            r.RevenueSpese = r.RevenueSpese.Replace(",", "."); // converte indicatore decimali

            ret = Database.ExecuteSQL("INSERT INTO RevenueProgetto ( Projects_id, RevenueVersionCode, AnnoMese, TipoRecord, CodiceProgetto, NomeProgetto, TipoProgetto, ClientManager_id, NomeManager, NomeCliente, RevenueSpese ) " +
                                      "VALUES ( " + ASPcompatility.FormatStringDb(r.ProjectsId) + " , " +
                                                    ASPcompatility.FormatStringDb(r.RevenueVersionCode) + " , " +
                                                    ASPcompatility.FormatStringDb(r.AnnoMese) + " , " +
                                                    " 'M' , " +
                                                    ASPcompatility.FormatStringDb(r.ProjectCode) + " , " +
                                                    ASPcompatility.FormatStringDb(r.ProjectName) + " , " +
                                                    ASPcompatility.FormatStringDb(drPrj["TipoProgetto"].ToString()) + " , " +
                                                    ASPcompatility.FormatStringDb(drPrj["ClientManager_id"].ToString()) + " , " +
                                                    ASPcompatility.FormatStringDb(sDrMgr) + " , " +
                                                    ASPcompatility.FormatStringDb(sDrCli) + " , " +
                                                    ASPcompatility.FormatStringDb(r.RevenueSpese) + " ) ", null);

            if (ret == false)
                break;
        }

        return ret;

    }

    // aggiorna il record RevenueMese dopo l'edit della cella
    [WebMethod(EnableSession = true)]
    public bool UpdateRevenueMese(string sRevenueMese_id, string sFieldToUpdate, string sValue )
    {
        bool ret = false;

        // aggiorna record del trainig plan
        if (Convert.ToInt64(sRevenueMese_id) > 0) {

            switch (sFieldToUpdate) {
                case "OreCosti":
                    ret = Database.ExecuteSQL("Update RevenueMese SET OreCosti = '" + sValue + "', GiorniCosti = " +  ASPcompatility.FormatNumberDB(Convert.ToDouble(sValue) / 8) + " WHERE RevenueMese_id='" + sRevenueMese_id + "'", null);
                    break;

                case "OreRevenue":
                    ret = Database.ExecuteSQL("Update RevenueMese SET OreRevenue = '" + sValue + "', GiorniRevenue = " +  ASPcompatility.FormatNumberDB(Convert.ToDouble(sValue) / 8) + " WHERE RevenueMese_id='" + sRevenueMese_id + "'", null);
                    break;

                default :
                    ret = Database.ExecuteSQL("Update RevenueMese SET " + sFieldToUpdate + " = '" + sValue + "' WHERE RevenueMese_id='" + sRevenueMese_id + "'", null);
                    break;
            }

        }
        else ret = false;

        return ret;
    }

    // aggiorna il record RevenueMese dopo l'edit della cella
    [WebMethod(EnableSession = true)]
    public bool UpdateProjectData(string Projects_id, string FieldToUpdate, string Value )
    {
        bool ret = false;

        // aggiorna record del trainig plan
        if (Convert.ToInt64(Projects_id) > 0) {

            switch (FieldToUpdate) {
                case "MargineProposta":
                    // C# gestisce decimali con la , , MSSQL con il .
                    decimal val = Math.Round( Convert.ToDecimal( Value.Replace(".",",") ) / 100, 4);

                    ret = Database.ExecuteSQL("Update Projects SET MargineProposta = '" + val.ToString().Replace(",",".") + "' WHERE Projects_id='" + Projects_id + "'", null);
                    break;

                case "TipoContrattoDesc":
                    Value = ( Value == "T&M" ) ? "1" : "2";
                    ret = Database.ExecuteSQL("Update Projects SET TipoContratto_id = " + ASPcompatility.FormatStringDb(Value) + " WHERE Projects_id='" + Projects_id + "'", null);
                    break;

                case "DataFine":
                    ret = Database.ExecuteSQL("Update Projects SET DataFine = " + ASPcompatility.FormatDateDb(Value) + " WHERE Projects_id='" + Projects_id + "'", null);
                    break;

                default :
                    ret = Database.ExecuteSQL("Update Projects SET " + FieldToUpdate + " = '" + Value + "' WHERE Projects_id='" + Projects_id + "'", null);
                    break;
            }
        }
        else ret = false;

        return ret;
    }

    // Estrare la lista per popolare la tabella principale su ProjectRevenueData.aspx
    [WebMethod(EnableSession = true)]
    public string GetProjectData(string StatoAttivo)
    {

        DataTable dt = new DataTable();
        string sRet;

        string WhereCond = "";

        switch (StatoAttivo) {
            case "1": // attivo + chargable + T&M o Forfait
                WhereCond = " WHERE a.ProjectType_id = '1' AND ( a.TipoContratto_id = '1' OR a.TipoContratto_id = '2' ) AND Active='true'";
                break;
            case "2": // non attivo + chargable + T&M o Forfait
                WhereCond = " WHERE a.ProjectType_id = '1' AND ( a.TipoContratto_id = '1' OR a.TipoContratto_id = '2' ) AND Active='false'";
                break;
            case "": // chargable + T&M o Forfait
                WhereCond = "WHERE a.ProjectType_id = '1' AND ( a.TipoContratto_id = '1' OR a.TipoContratto_id = '2' ) ";
                break;
        }

        string query = "SELECT Projects_id, ProjectCode, Name, a.TipoContratto_id, b.Descrizione as TipoContrattoDesc, RevenueBudget, CONVERT(VARCHAR(10),A.DataFine, 103) as DataFine, MargineProposta * 100 as MargineProposta FROM Projects as a  " +
                       " INNER JOIN TipoContratto as b ON b.TipoContratto_id = a.TipoContratto_id " +
                       WhereCond + " ORDER BY ProjectCode";

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName,  dr[col]);
                    }
                    rows.Add(row);
                }
                sRet = serializer.Serialize(rows);
                return sRet;
            }
        }
    }

    // Estrare la lista per popolare la tabella principale
    [WebMethod(EnableSession = true)]
    public string GetRevenueMese(string Persons_id, string AnnoMese, string RevenueVersionCode)
    {

        DataTable dt = new DataTable();
        string sRet;

        String query = "SELECT RevenueMese_id, Persons_id, Projects_id, TipoRecord, NomePersona, CodiceProgetto, NomeProgetto, NomeCliente, NomeManager, OreCosti, " +
                       " GiorniCosti, OreRevenue, GiorniRevenue,  RevenueProposta, Costo, CostoSpese, Comment " +
                       " FROM RevenueMese WHERE AnnoMese = " + ASPcompatility.FormatStringDb(AnnoMese) +
                       " AND RevenueVersionCode =  " + ASPcompatility.FormatStringDb(RevenueVersionCode) +
                       " AND TipoRecord = 'M' " +
                       " ORDER BY NomePersona,CodiceProgetto ASC ";

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
                System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
                List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
                Dictionary<string, object> row;
                foreach (DataRow dr in dt.Rows)
                {
                    row = new Dictionary<string, object>();
                    foreach (DataColumn col in dt.Columns)
                    {
                        row.Add(col.ColumnName,  dr[col]);
                    }
                    rows.Add(row);
                }
                sRet = serializer.Serialize(rows);
                return sRet;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public RevenueMeseItem GetRevenueMeseItem(string sRevenueMese_id )
    {
        RevenueMeseItem rc = new RevenueMeseItem();

        DataTable dt = Database.GetData("SELECT * FROM RevenueMese where RevenueMese_id = " + sRevenueMese_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.RevenueMese_id = 0;
        }
        else
        {
            rc.RevenueMese_id = Convert.ToInt32(dt.Rows[0]["RevenueMese_id"].ToString());
            rc.Comment = dt.Rows[0]["Comment"].ToString();
        }
        return rc;
    }

    [WebMethod(EnableSession = true)]
    public bool CancellaRevenueMeseRecord(string sRevenueMese_id )
    {
        string sDelete = "DELETE RevenueMese " +
                         " WHERE RevenueMese_id = '" + sRevenueMese_id + "'";

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

    // crea il record RevenueMese
    [WebMethod(EnableSession = true)]
    public bool CreaRevenueMese(string Persons_id, string Projects_id, string RevenueVersionCode, string AnnoMese, string TipoRecord)
    {

        // recupera i dati obbligatori per il popolamento del record.
        DataRow drPrj = Database.GetRow("SELECT a.ProjectCode as CodiceProgetto, a.Name as NomeProgetto, B.Descrizione as TipoProgetto, ClientManager_id, CodiceCliente as CodiceCliente FROM Projects as a " +
                                         "LEFT JOIN TipoContratto as b ON b.TipoContratto_id = a.TipoContratto_id " +
                                         "WHERE Projects_id = " + ASPcompatility.FormatStringDb(Projects_id), null);

        DataRow drPer = Database.GetRow("SELECT a.Name as NomePersona, B.Name as NomeSocieta, a.ConsultantType_id FROM Persons as a " +
                                         "INNER JOIN Company as b ON b.Company_id = a.Company_id " +
                                         "WHERE Persons_id = " + ASPcompatility.FormatStringDb(Persons_id), null);

        if (drPer == null || drPrj == null )
            return false;

        DataRow drCli = Database.GetRow("SELECT Nome1 as NomeCliente FROM Customers " +
                                         "WHERE CodiceCliente = " + ASPcompatility.FormatStringDb(drPrj["CodiceCliente"].ToString()), null);

        string sDrCli = drCli != null ? drCli["NomeCliente"].ToString() : "";

        DataRow drMgr = Database.GetRow("SELECT Name as NomeManager FROM Persons " +
                                         "WHERE Persons_id = " + ASPcompatility.FormatStringDb(drPrj["ClientManager_id"].ToString()), null);

        string sDrMgr = drMgr != null ? drMgr["NomeManager"].ToString() : "";

        DataRow drTpCons = Database.GetRow("SELECT  ConsultantTypeName as TipoConsulente FROM ConsultantType " +
                                         "WHERE ConsultantType_id = " + ASPcompatility.FormatStringDb(drPer["ConsultantType_id"].ToString()), null);

        string sCommento = "inserito il: " + DateTime.Now.ToString() + " da " + Session["userid"];

        string sInsert = "INSERT INTO RevenueMese " +
                         "(Persons_id, Projects_id, RevenueVersionCode, TipoRecord, AnnoMese, NomePersona, TipoConsulente, CodiceProgetto, NomeProgetto, NomeSocieta, TipoProgetto, ClientManager_id, NomeManager, NomeCliente, Comment) " +
                          "VALUES ( " + ASPcompatility.FormatStringDb(Persons_id) + " , " +
                          ASPcompatility.FormatStringDb(Projects_id) + " , " +
                          ASPcompatility.FormatStringDb(RevenueVersionCode) + " , " +
                          ASPcompatility.FormatStringDb(TipoRecord) + " , " +
                          ASPcompatility.FormatStringDb(AnnoMese) + " , " +
                          ASPcompatility.FormatStringDb(drPer["NomePersona"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(drTpCons["TipoConsulente"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(drPrj["CodiceProgetto"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(drPrj["NomeProgetto"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(drPer["NomeSocieta"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(drPrj["TipoProgetto"].ToString()) +" , " +
                          ASPcompatility.FormatStringDb(drPrj["ClientManager_id"].ToString()) + " , " +
                          ASPcompatility.FormatStringDb(sDrMgr) + " , " +
                          ASPcompatility.FormatStringDb(sDrCli) + " , " +
                          ASPcompatility.FormatStringDb(sCommento) +
        " )";

        bool bResult = Database.ExecuteSQL(sInsert, null);

        return bResult;

    }

}