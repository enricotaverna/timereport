<%@ WebService Language="C#" Class="RP_Preinvoice" %>

using System;
using System.Web.Services;
using System.Data;

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class RP_Preinvoice : System.Web.Services.WebService
{

    public RP_Preinvoice()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    // GetListaChiusure(string Mese, string Anno, )
    // meseLista, annoLista -> Situazione chiusura nel mese / anno
    //
    [WebMethod(EnableSession = true)]
    public string GetPreinvoiceList()
    {
        String query =  "SELECT Preinvoice_id, Description, CONVERT(VARCHAR(10), DataDa, 103) as DataDa, CONVERT(VARCHAR(10), DataA, 103) as DataA, CreatedBy, CONVERT(VARCHAR(10), CreationDate, 103) as CreationDate, NumberOfDays, TotalAmount, TotalExpenses, TotalRates, B.Name as CompanyName, DirectorsName " +
                        "FROM Preinvoice " +
                        "INNER JOIN Company as B ON B.Company_id = Preinvoice.Company_id " +
                        "ORDER BY CreationDate DESC, CreatedBy";
        return Database.FromSQLSelectToJson(query);
    }

    [WebMethod(EnableSession = true)]
    public bool DeletePreinvoice(string PreInvoice_id)
    {

        // cancella riferimenti da tabella ore e spese
        Boolean result = Database.ExecuteSQL("UPDATE Hours SET Preinvoice_id = NULL WHERE Preinvoice_id = " + PreInvoice_id, null);

        if (!result)
            return false;

        result = Database.ExecuteSQL("UPDATE Expenses SET Preinvoice_id = NULL WHERE Preinvoice_id = " + PreInvoice_id, null);
        if (!result)
            return false;

        string sDelete = "DELETE Preinvoice " +
                         " WHERE Preinvoice_id = " + PreInvoice_id;

        result = Database.ExecuteSQL(sDelete, null);

        return result;

    }

    [WebMethod(EnableSession = true)]
    public string CheckFLC(string company_id, string dataDa, string dataA)
    {

        string bResult = "  ";
        string query = "SELECT DISTINCT B.Name " +
                        "FROM hours as T " +
                        "INNER JOIN Persons as B on B.Persons_id = T.Persons_id " +
                        "WHERE t.Company_id = " + ASPcompatility.FormatStringDb(company_id) + " AND date >= " + ASPcompatility.FormatDateDb(dataDa) + " AND date <= " + ASPcompatility.FormatDateDb(dataA) + " AND  [MSSql12155].FCT_DeterminaCostRate(t.persons_id, t.projects_id, t.date) = 0";

        DataTable dt = Database.GetData(query, null);

        foreach (DataRow dr in dt.Rows) {
            bResult += dr[0].ToString() + ", ";
        }
        bResult = bResult.Substring(0, bResult.Length - 2);

        return bResult;

    }

}
    