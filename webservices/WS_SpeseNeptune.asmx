<%@ WebService Language="C#" Class="WS_SpeseNeptune" %>

using System;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_SpeseNeptune  : System.Web.Services.WebService {

    [WebMethod(EnableSession = true)]
    public string SpesaGetList(int persons_id, string DateFrom, string DateTo)
    {

        DataTable dt = new DataTable();
        String query = "";
        DateTime dNow = DateTime.Now;

        if (DateFrom == "")
            DateFrom = (dNow.AddDays(-30)).ToShortDateString();

        if (DateTo == "")
            DateTo = dNow.ToShortDateString();

        query = "SELECT Persona, ProjectCode, Date, Importo FROM v_spese WHERE persons_id = " + ASPcompatility.FormatNumberDB(persons_id) +  " AND Date >= " + ASPcompatility.FormatDateDb(DateFrom) + " AND Date <= "  +  ASPcompatility.FormatDateDb(DateTo) + " ORDER BY CourseCode";

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

}