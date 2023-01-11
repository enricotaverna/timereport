<%@ WebService Language="C#" Class="WS_Caricatore" %>

/*
    Per aggiungere un caricatore:
    - aggiungere una struttura come ProjectInput corrispondente dalla tabella passata dalla chiamata ajax
    - aggiungere una strutrura come ProjecToUpdate corrispondente ai campi da aggiornare 
    - aggiungere switch case nella funzione UpdateTable

*/

using System;
using System.Web.Services;
using System.Data;
using System.Web.Script.Serialization;
using System.Data.SqlClient;
using System.Configuration;
using System.Reflection;
using System.Collections.Generic;

// Dati ricevuti da chiamate ajax
public class ProjectInput // 
{
    public string ProcessingStatus { get; set; }
    public string ProjectCode { get; set; }
    public string Name { get; set; }
    public string ClientManager { get; set; }
    public string ClientManager_id { get; set; }
    public string AccountManager { get; set; }
    public string AccountManager_id { get; set; }
    public string CodiceCliente { get; set; }
    public string ProjectType { get; set; }
    public string ProjectType_id { get; set; }
    public string Channels { get; set; }
    public string Channels_id { get; set; }
    public string Company { get; set; }
    public string Company_id { get; set; }
    public string TipoContratto { get; set; }
    public string TipoContratto_id { get; set; }
    public string RevenueBudget { get; set; }
    public string MargineProposta { get; set; }
    public string DataInizio { get; set; }
    public string DataFine { get; set; }
    public string ProcessingMessage { get; set; }
}

public class FLCInput // 
{
    public string ProcessingStatus { get; set; }
    public string Consulente { get; set; }
    public string Persons_id { get; set; }
    public string CostRate { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string Comment { get; set; }
    public string ProcessingMessage { get; set; }
}

public class BillRateInput // 
{
    public string ProcessingStatus { get; set; }
    public string Consulente { get; set; }
    public string Persons_id { get; set; }
    public string ProjectCode { get; set; }
    public string Projects_id { get; set; }
    public string CostRate { get; set; }
    public string BillRate{ get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string Comment { get; set; }
    public string ProcessingMessage { get; set; }
}

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_Caricatore : System.Web.Services.WebService
{

    public class Record {
        public string Campo  { get; set; }
        public string Tipo  { get; set; }
        public string Default  { get; set; }

        public Record(string campoIn, string tipoIn, string defaultIn)
        {
            Campo = campoIn;
            Tipo = tipoIn;
            Default = defaultIn;
        }
    }

    /* nome campo da aggiornare, tipo, default */
    List<Record> ProjecToUpdate = new List<Record> { new Record("ProjectCode", "string", null ),
                                           new Record("Name", "string", null ),
                                           new Record("ClientManager_id", "int", null ),
                                           new Record("AccountManager_id", "int", null ),
                                           new Record("CodiceCliente", "string", null ),
                                           new Record("ProjectType_id", "int", null ),
                                           new Record("Channels_id", "int", null ),
                                           new Record("Company_id", "int", null ),
                                           new Record("TipoContratto_id", "float", null ),
                                           new Record("RevenueBudget", "float", null ),
                                           new Record("MargineProposta", "percent", null ),
                                           new Record("DataInizio", "date", null ),
                                           new Record("DataFine", "date", null ),
                                           new Record("SpeseForfait", "boolean", "true" ),
                                           new Record("Active", "boolean", "true" ),
                                           new Record("NoOvertime", "boolean", "false" ),
                                           new Record("TestoObbligatorio", "boolean", "false" ),
                                           new Record("BloccoCaricoSpese", "boolean", "false" ),
                                           new Record("ActivityOn", "boolean", "false" ),
                                           new Record("Always_available", "boolean", "false" ),
                                           new Record("CreationDate", "date", null ), // gestite automaticamente
                                           new Record("CreatedBy", "string", null ) // gestite automaticamente
                        };

    /* nome campo da aggiornare, tipo, default */
    List<Record> FLCToUpdate = new List<Record> {
                                           new Record("Persons_id", "int", null ),
                                           new Record("CostRate", "float", null ),
                                           new Record("DataDa", "date", null ),
                                           new Record("DataA", "date", null ),
                                           new Record("Comment", "string", null ),
                                           new Record("CreationDate", "date", null ), // gestite automaticamente
                                           new Record("CreatedBy", "string", null ) // gestite automaticamente
                        };

    /* nome campo da aggiornare, tipo, default */
    List<Record> BillRateToUpdate = new List<Record> {
                                           new Record("Persons_id", "int", null ),
                                           new Record("Projects_id", "int", null ),
                                           new Record("CostRate", "float", null ),
                                           new Record("BillRate", "float", null ),
                                           new Record("DataDa", "date", null ),
                                           new Record("DataA", "date", null ),
                                           new Record("Comment", "string", null ),
                                           new Record("CreationDate", "date", null ), // gestite automaticamente
                                           new Record("CreatedBy", "string", null ) // gestite automaticamente
                        };

    public WS_Caricatore()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string GetDataTable(string type)
    {
        DataTable dtResults = (DataTable)Session["dtResult"]; // caricato dalla pagina Caricatore_select
        //dtResults.DefaultView.Sort = "ProcessingStatus DESC"; // ordina per stato in modo che errore compare prima
        //dtResults = dtResults.DefaultView.ToTable();

        string sRet;

        JavaScriptSerializer serializer = new JavaScriptSerializer();
        List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        Dictionary<string, object> row;
        foreach (DataRow dr in dtResults.Rows)
        {
            row = new Dictionary<string, object>();
            foreach (DataColumn col in dtResults.Columns)
            {
                row.Add(col.ColumnName, dr[col]);
            }
            rows.Add(row);
        }
        sRet = serializer.Serialize(rows);
        return sRet;
    }

    // Aggiorna progetti dopo upload SF
    [WebMethod(EnableSession = true)]
    public bool UpdateTable(string type, string[] arr)
    {

        bool ret = true;
        JavaScriptSerializer js = new JavaScriptSerializer();
        List<Record> RowsToUpdate = new List<Record>();
        string TableToUpdate = "";
        Type tipoStruttura = null;
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        switch (type) {
            case "PROJECT":
                RowsToUpdate = ProjecToUpdate;
                TableToUpdate = "Projects";
                tipoStruttura = Type.GetType("ProjectInput");
                break;

            case "FLC":
                RowsToUpdate = FLCToUpdate;
                TableToUpdate = "PersonsCostRate";
                tipoStruttura = Type.GetType("FLCInput");
                break;

            case "BILLRATE":
                RowsToUpdate = BillRateToUpdate;
                TableToUpdate = "ProjectCostRate";
                tipoStruttura = Type.GetType("BillRateInput");
                break;

            default:
                return false; // tipo aggiornamento non gestito
                break;
        };

        object r = null;

        // aggiorna dati TR con valori di SF
        for ( int i = 0; i < arr.Length; i++ )
        {

            r = js.Deserialize(arr[i], tipoStruttura);

            //double dMargine = Convert.ToDouble(r.sfexpectedmargin) / 100;
            //string sTipoContratto_id = r.sfengagementtype == "TM" ? "1" : "2";

            string SQLInsert = "INSERT INTO " + TableToUpdate + " (";

            foreach (Record rec in RowsToUpdate) {
                SQLInsert += rec.Campo + ",";
            }
            SQLInsert = SQLInsert.Substring(0, SQLInsert.Length - 1) + " ) VALUES (";

            Type tipo = r.GetType();

            foreach (Record rec in RowsToUpdate) {
                PropertyInfo prop = tipo.GetProperty(rec.Campo);
                object valore;

                if (rec.Default == null) // valore di default
                    if (rec.Campo == "CreationDate")
                        valore = DateTime.Now.ToString("dd/MM/yyyy");
                    else if (rec.Campo == "CreatedBy")
                        valore = CurrentSession.UserName;
                    else
                    valore = prop.GetValue(r);
                else
                    valore = rec.Default ;

                switch (rec.Tipo) {

                    case "date":
                        SQLInsert += ASPcompatility.FormatDateDb(valore.ToString()) + ",";
                        break;

                    case "percent":
                        SQLInsert += ASPcompatility.FormatNumberDB((Convert.ToDouble(valore.ToString().Replace('.',',')) / 100)) + ",";
                        break;

                    default:
                        SQLInsert += ASPcompatility.FormatStringDb(valore.ToString())+ ",";
                        break;
                }
            }

            SQLInsert = SQLInsert.Substring(0, SQLInsert.Length - 1) + ")";

            ret = Database.ExecuteSQL(SQLInsert, null);

            if (ret == false)
                break;
        }

        return ret;

    }

}
    