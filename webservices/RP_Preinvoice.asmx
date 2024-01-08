<%@ WebService Language="C#" Class="RP_Preinvoice" %>

using System;
using System.Web.Services;
using System.Data;
using System.Configuration;

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
    public string GetPreinvoiceList(string tipoFattura) // CLI x clienti, FOR x fornitori
    {
        String query =  "SELECT A.Preinvoice_id, A.PreinvoiceNum, A.Description, CONVERT(VARCHAR(10), A.DataDa, 103) as DataDa, CONVERT(VARCHAR(10), A.DataA, 103) as DataA, A.CreatedBy, CONVERT(VARCHAR(10), A.Date, 103) as DocumentDate, A.NumberOfDays, A.TotalAmount, A.TotalExpenses, A.TotalRates, B.Name as CompanyName, C.Nome1 as CustomerName, DirectorsName " +
                        "FROM Preinvoice AS A " +
                        "LEFT JOIN Company as B ON B.Company_id = A.Company_id " +
                        "LEFT JOIN Customers as C ON C.CodiceCliente = A.CodiceCliente " +
                        "WHERE A.Tipo = " + ASPcompatility.FormatStringDb(tipoFattura) +
                        " ORDER BY Preinvoice_id DESC";
        return Database.FromSQLSelectToJson(query);
    }

    [WebMethod(EnableSession = true)]
    public bool DeletePreinvoice(string PreInvoiceNum, string TipoFattura)
    {

        Boolean result;

        // cancella riferimenti da tabella ore e spese
        if (TipoFattura == "FOR")
            result = Database.ExecuteSQL("UPDATE Hours SET PreinvoiceNum = NULL WHERE PreinvoiceNum = " + PreInvoiceNum, null);
        else
            result = Database.ExecuteSQL("UPDATE Hours SET CTMPreinvoiceNum = NULL WHERE CTMPreinvoiceNum = " + PreInvoiceNum, null);

        if (!result)
            return false;

        if (TipoFattura == "FOR")
            result = Database.ExecuteSQL("UPDATE Expenses SET PreinvoiceNum = NULL WHERE PreinvoiceNum = " + PreInvoiceNum, null);
        else
            result = Database.ExecuteSQL("UPDATE Expenses SET CTMPreinvoiceNum = NULL WHERE CTMPreinvoiceNum = " + PreInvoiceNum, null);

        if (!result)
            return false;

        string sDelete = "DELETE Preinvoice " +
                         " WHERE Tipo = '" + TipoFattura  + "' AND PreInvoiceNum     = " + PreInvoiceNum;

        result = Database.ExecuteSQL(sDelete, null);

        return result;

    }

    [WebMethod(EnableSession = true)]
    public string CheckConsuntivi(string company_id, string ProjectsIdList, string CodiceCliente, string dataDa, string dataA, string TipoFattura)
    {
        string query;
        string bResult = "  ";

        if (TipoFattura == "FOR")
            query = "SELECT DISTINCT B.Name " +
                            "FROM hours as T " +
                            "INNER JOIN Persons as B on B.Persons_id = T.Persons_id " +
                            "WHERE t.Company_id = " + ASPcompatility.FormatStringDb(company_id) + 
                            " AND date >= " + ASPcompatility.FormatDateDb(dataDa) + 
                            " AND date <= " + ASPcompatility.FormatDateDb(dataA) + 
                            " AND  [MSSql12155].FCT_DeterminaCostRate(t.persons_id, t.projects_id, t.date) = 0";
        else
            query = "SELECT DISTINCT B.Name " +
                            "FROM hours as T " +
                            "INNER JOIN Persons as B on B.Persons_id = T.Persons_id " +
                            "INNER JOIN Projects as C on C.Projects_id = T.Projects_id " +
                            " WHERE C.CodiceCliente = "  + ASPcompatility.FormatStringDb(CodiceCliente) + 
                            " AND date >= " + ASPcompatility.FormatDateDb(dataDa) + 
                            " AND date <= " + ASPcompatility.FormatDateDb(dataA) + 
                            " AND C.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' " +
                            " AND  [MSSql12155].FCT_DeterminaBillRate(t.persons_id, t.projects_id, t.date) = 0";

        if (ProjectsIdList != "") 
            query+= " AND T.projects_id IN ( " + ProjectsIdList + " )";
        
        DataTable dt = Database.GetData(query, null);

        foreach (DataRow dr in dt.Rows) {
            bResult += dr[0].ToString() + ", ";
        }
bResult = bResult.Substring(0, bResult.Length - 2);

return bResult;

    }

}
    