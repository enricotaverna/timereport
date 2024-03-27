<%@ WebService Language="C#" Class="WS_SheetJS" %>

using System;
using System.Web.Services;
using System.Configuration;
using System.Data;


/// <summary>
/// 
/// Utility da utilizzare con add SheetJS per upload/download/edit file excel
/// 
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_SheetJS : System.Web.Services.WebService
{

    public WS_SheetJS()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string GetJsonFromQuery(string query)
    {
        return Database.FromSQLSelectToJson(query);
    }

    // richiamata da ControlloProgetto-list.aspx
    // Restituisce in formato JSON la tabella con ore e costi per il progetto
    // o il responsabile selezionato
    [WebMethod(EnableSession = true)]
    public string ControlloProgetto_ExportDetailHoursWithCost()
    {
        string sQuery;

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        sQuery = "SELECT * FROM v_oreWithCost WHERE Active = 1 AND Data <= " + ASPcompatility.FormatDatetimeDb(Convert.ToDateTime(Session["DataReport"].ToString())) +
                                         " AND ProjectType_id = '" + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + "'";

        if (Session["ProgettoReport"].ToString() != "0")
            sQuery += " AND Projects_id = " + Session["ProgettoReport"].ToString();

        if (Session["ManagerReport"].ToString() != "0")
            sQuery += " AND ( ClientManager_id = " + Session["ManagerReport"].ToString() + " OR AccountManager_id = " + Session["ManagerReport"].ToString() + ")";

        sQuery += " ORDER BY Consulente, Data";

        string Json = Database.FromSQLSelectToJson(sQuery);

        return (Json);

    }

    // richiamata da ControlloProgetto-list.aspx
    // Restituisce in formato JSON la tabella con ore e costi per il progetto
    // o il responsabile selezionato
    [WebMethod(EnableSession = true)]
    public string ControlloProgetto_ExportSintesi()
    {
        DataSet ds = (DataSet)Session["dsGVAttivita"];

        string Json = Database.FromDatatableToJson(ds.Tables[0]);

        return (Json);

    }

}
    