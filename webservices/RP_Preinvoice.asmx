<%@ WebService Language="C#" Class="RP_Preinvoice" %>

using System;
using System.Web.Services;

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
        String query =  "SELECT Preinvoice_id, Description, CONVERT(VARCHAR(10), DataDa, 103) as DataDa, CONVERT(VARCHAR(10), DataA, 103) as DataA, CreatedBy, CONVERT(VARCHAR(10), CreationDate, 103) as CreationDate, NumberOfDays, TotalAmount, TotalExpenses, B.Name as CompanyName " +
                        "FROM Preinvoice " +
                        "INNER JOIN Company as B ON B.Company_id = Preinvoice.Company_id " +
                        "ORDER BY CreationDate DESC, CreatedBy";
        return Database.FromSQLSelectToJson(query);
    }

    [WebMethod(EnableSession = true)]
    public bool DeletePreinvoice(string PreInvoice_id)
    {

        string sDelete = "DELETE Preinvoice " +
                         " WHERE Preinvoice_id = '" + PreInvoice_id + "'";


        //  if ( *** Controllo per evitare cancellazione ***)
        //    return false;

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

}
    