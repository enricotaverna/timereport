<%@ WebService Language="C#" Class="WS_PersonsCostRate" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

// definisce la struttura  da ritornare con GetCourse
public class PersonsCostRate
{
    public int PersonsCostRate_id { get; set; }
    public int Persons_id { get; set; }
    public float CostRate { get; set; }
    public string DataDa { get; set; }
    public string DataA{ get; set; }
    public string Comment { get; set; }

}

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_PersonsCostRate : System.Web.Services.WebService {

    public WS_PersonsCostRate () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public string GetPersonsCostRateTable(string sAnno)
    {

        DataTable dt = new DataTable();

        String query =  "SELECT A.PersonsCostRate_id, A.Persons_id, A.CostRate, A.Comment, CONVERT(VARCHAR(10),A.DataDa, 103) as DataDa, CONVERT(VARCHAR(10),A.DataA, 103) as DataA, B.Name as PersonName, C.Name as CompanyName FROM PersonsCostRate as A " +
                        " JOIN Persons as B ON B.Persons_id = A.Persons_id " +
                        " JOIN Company as C ON C.Company_id = B.Company_id " +
                        " WHERE active = 'true' ORDER BY A.DataDa DESC, PersonName";
        string sRet;

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
                        row.Add(col.ColumnName, dr[col]);
                    }
                    rows.Add(row);
                }
                sRet = serializer.Serialize(rows);
                return sRet;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public int CreateUpdatePersonsCostRate(int PersonsCostRate_id, string Persons_id,
                           string CostRate, string Comment, string DataDa,
                           string DataA)
    {

        int newIdentity = 0;
        string sSQL = "";

        // formatta campi numerici
        if (CostRate == null)
            CostRate = "0";

        if (PersonsCostRate_id > 0)
            sSQL = "UPDATE PersonsCostRate SET " +
                  "Persons_id = " + ASPcompatility.FormatStringDb(Persons_id) + " , " +
                  "Comment = " + ASPcompatility.FormatStringDb(Comment) + " , " +
                  "CostRate = " + ASPcompatility.FormatStringDb(CostRate) + " , " +
                  "DataDa = " + ASPcompatility.FormatDateDb(DataDa) + " , " +
                  "DataA = " + ASPcompatility.FormatDateDb(DataA) +
                  " WHERE PersonsCostRate_id = " + ASPcompatility.FormatNumberDB(PersonsCostRate_id);
        else
            sSQL = "INSERT INTO PersonsCostRate (Persons_id, CostRate, Comment, DataDa, DataA ) " +
                            " VALUES (" + ASPcompatility.FormatStringDb(Persons_id) + ", " +
                                          ASPcompatility.FormatStringDb(CostRate) + ", " +
                                          ASPcompatility.FormatStringDb(Comment) + ", " +
                                          ASPcompatility.FormatDateDb(DataDa) + ", " +
                                          ASPcompatility.FormatDateDb(DataA) + " )";

        bool bResult = Database.ExecuteSQL(sSQL, null);

        if (bResult)
        {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(PersonsCostRate_id) from PersonsCostRate_id");
        }

        return newIdentity;

    }

    [WebMethod(EnableSession = true)]
    public bool DeletePersonsCostRate(string PersonsCostRate_id)
    {

        string sDelete = "DELETE PersonsCostRate " +
                         " WHERE PersonsCostRate_id = '" + PersonsCostRate_id + "'";


        //  if ( *** Controllo per evitare cancellazione ***)
        //    return false;

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

    [WebMethod(EnableSession = true)]
    public PersonsCostRate GetPersonsCostRate(string sPersonsCostRate_id)
    {

        PersonsCostRate rc = new PersonsCostRate();

        DataTable dt = Database.GetData("SELECT * FROM PersonsCostRate where PersonsCostRate_id = " + sPersonsCostRate_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.PersonsCostRate_id = 0;
        }
        else
        {
            rc.PersonsCostRate_id = Convert.ToInt32(dt.Rows[0]["PersonsCostRate_id"].ToString());
            rc.Persons_id = Convert.ToInt32(dt.Rows[0]["Persons_id"].ToString());
            rc.CostRate = (float)Convert.ToDouble(dt.Rows[0]["CostRate"].ToString());
            rc.DataA = dt.Rows[0]["DataA"].ToString().Substring(0, 10);
            rc.DataA = rc.DataA == "01/01/1900" ? "" : rc.DataA;
            rc.DataDa = dt.Rows[0]["DataDa"].ToString().Substring(0, 10);
            rc.DataDa = rc.DataDa == "01/01/1900" ? "" : rc.DataDa;
            rc.Comment = dt.Rows[0]["Comment"].ToString();

        }


        return rc;

    }

    [WebMethod(EnableSession = true)]
    public string CheckDate(string Persons_id, string PersonsCostRate_id, string DataDa, string DataA)
    {

        DateTime dMaxDBData;

        if ( PersonsCostRate_id == "0")
        {
            // se primo inserimento per la persona ok
            if (!Database.RecordEsiste("SELECT * FROM PersonsCostRate WHERE Persons_id =" + ASPcompatility.FormatStringDb(Persons_id)))
                return "true";

            dMaxDBData = (DateTime)Database.ExecuteScalar("SELECT MAX(DataA) FROM PersonsCostRate WHERE Persons_id ='" + Persons_id + "'", null);
        }
        else {

            // se primo inserimento per la persona ok
            if (!Database.RecordEsiste("SELECT * FROM PersonsCostRate WHERE Persons_id =" + ASPcompatility.FormatStringDb(Persons_id)  + " AND  PersonsCostRate_id <> '" + PersonsCostRate_id + "'" ) )
                return "true";

            dMaxDBData = (DateTime)Database.ExecuteScalar("SELECT MAX(DataA) FROM PersonsCostRate WHERE Persons_id ='" + Persons_id + "' AND PersonsCostRate_id <> '" + PersonsCostRate_id + "'", null);
        }

        string sDataFinePiuUNo = dMaxDBData.AddDays(1).ToString("dd/MM/yyyy");

        if (DataDa == sDataFinePiuUNo)
            return "true";
        else
            return sDataFinePiuUNo;

    }

}
    