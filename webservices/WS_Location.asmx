<%@ WebService Language="C#" Class="WS_Location" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

// definisce la struttura  da ritornare con GetRecord
//public class LocationRecord
//{
//    public int Location_id { get; set; }
//    public string CodiceCliente { get; set; }
//    public int Projects_id { get; set; }
//    public string LocationDescription { get; set; }
//}

// definisce la struttura  da ritornare con GetRecord
public class ClientLocationRecord
{
    public int ClientLocation_id { get; set; }
    public string CodiceCliente { get; set; }
    public string LocationDescription { get; set; }
}

// definisce la struttura  da ritornare con GetRecord
public class ProjectLocationRecord
{
    public int ProjectLocation_id { get; set; }
    public string Projects_id { get; set; }
    public string LocationDescription { get; set; }
}


/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_Location : System.Web.Services.WebService
{

    public WS_Location()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    //[WebMethod(EnableSession = true)]
    //public string GetLocationList(bool onlyActiveProjects)
    //{

    //    DataTable dt = new DataTable();
    //    string query = "";
    //    string sRet="";

    //    if (onlyActiveProjects)
    //        query = "SELECT * FROM v_location WHERE (active = 'true' or active is null) ORDER BY CodiceCliente, ProjectCode, LocationDescription";
    //    else
    //        query = "SELECT * FROM v_location ORDER BY CodiceCliente, ProjectCode, LocationDescription";

    //    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
    //    {
    //        using (SqlCommand cmd = new SqlCommand(query, con))
    //        {
    //            con.Open();
    //            SqlDataAdapter da = new SqlDataAdapter(cmd);
    //            da.Fill(dt);

    //            sRet = Database.FromDatatableToJson(dt);
    //        }
    //    }

    //    return sRet;
    //}

    [WebMethod(EnableSession = true)]
    public string GetProjectLocation(bool onlyActiveProjects)
    {

        DataTable dt = new DataTable();
        string query = "";
        string sRet = "";

        if (onlyActiveProjects)
            query = "SELECT * FROM LOC_v_ProjectLocation WHERE active = 'true' ORDER BY ProjectCode, LocationDescription";
        else
            query = "SELECT * FROM LOC_v_ProjectLocation ORDER BY ProjectCode, LocationDescription";

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);

                sRet = Database.FromDatatableToJson(dt);
            }
        }

        return sRet;
    }

    [WebMethod(EnableSession = true)]
    public string GetClientLocation()
    {

        DataTable dt = new DataTable();
        string query = "";
        string sRet = "";

        query = "SELECT * FROM LOC_v_ClientLocation ORDER BY CodiceCliente, LocationDescription";

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);

                sRet = Database.FromDatatableToJson(dt);
            }
        }

        return sRet;
    }

    [WebMethod(EnableSession = true)]
    public int CreateUpdateCLientRecord(string ClientLocation_id, string CodiceCliente,
                                        string LocationDescription)
    {

        int newIdentity = 0;
        string sSQL = "";

        if (ClientLocation_id != "")
            sSQL = "UPDATE LOC_ClientLocation SET " +
                  "CodiceCliente = " + ASPcompatility.FormatStringDb(CodiceCliente) + " , " +
                  "LocationDescription = " + ASPcompatility.FormatStringDb(LocationDescription) +
                  " WHERE ClientLocation_id = " + ASPcompatility.FormatStringDb(ClientLocation_id);
        else
            sSQL = "INSERT INTO LOC_ClientLocation (CodiceCliente, LocationDescription) " +
                            " VALUES (" + ASPcompatility.FormatStringDb(CodiceCliente) + ", " +
                                          ASPcompatility.FormatStringDb(LocationDescription) + " )";

        bool bResult = Database.ExecuteSQL(sSQL, null);

        if (bResult)
        {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(Location_id) from Location");
        }

        return newIdentity;

    }

    [WebMethod(EnableSession = true)]
    public int CreateUpdateProjectRecord(string ProjectLocation_id, string Projects_id,
                                   string LocationDescription)
    {

        int newIdentity = 0;
        string sSQL = "";

        if (ProjectLocation_id != "")
            sSQL = "UPDATE LOC_ProjectLocation SET " +
                  "Projects_id = " + ASPcompatility.FormatStringDb(Projects_id) + " , " +
                  "LocationDescription = " + ASPcompatility.FormatStringDb(LocationDescription) +
                  " WHERE ProjectLocation_id = " + ASPcompatility.FormatStringDb(ProjectLocation_id);
        else
            sSQL = "INSERT INTO LOC_ProjectLocation (Projects_id, LocationDescription) " +
                            " VALUES (" + ASPcompatility.FormatStringDb(Projects_id) + ", " +
                                          ASPcompatility.FormatStringDb(LocationDescription) + " )";

        bool bResult = Database.ExecuteSQL(sSQL, null);

        if (bResult)
        {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(ProjectLocation_id) from Location");
        }

        return newIdentity;

    }

    [WebMethod(EnableSession = true)]
    public ClientLocationRecord GetClientRecord(string ClientLocation_id)
    {

        ClientLocationRecord rc = new ClientLocationRecord();
        DataTable dt = Database.GetData("SELECT * FROM LOC_ClientLocation where ClientLocation_id = " + ClientLocation_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.ClientLocation_id = 0;
        }
        else
        {
            rc.ClientLocation_id = Convert.ToInt32(dt.Rows[0]["ClientLocation_id"].ToString());
            rc.CodiceCliente = dt.Rows[0]["CodiceCliente"].ToString();
            rc.LocationDescription = dt.Rows[0]["LocationDescription"].ToString();
        }
        return rc;
    }

    [WebMethod(EnableSession = true)]
    public ProjectLocationRecord GetProjectRecord(string ProjectLocation_id)
    {

        ProjectLocationRecord rc = new ProjectLocationRecord();
        DataTable dt = Database.GetData("SELECT * FROM LOC_ProjectLocation where ProjectLocation_id = " + ProjectLocation_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.ProjectLocation_id = 0;
        }
        else
        {
            rc.ProjectLocation_id = Convert.ToInt32(dt.Rows[0]["ProjectLocation_id"].ToString());
            rc.Projects_id = dt.Rows[0]["Projects_id"].ToString();
            rc.LocationDescription = dt.Rows[0]["LocationDescription"].ToString();
        }
        return rc;
    }

    [WebMethod(EnableSession = true)]
    public bool DeleteClientRecord(string ClientLocation_id)
    {

        string sDelete = "DELETE LOC_ClientLocation " +
                         " WHERE ClientLocation_id = '" + ClientLocation_id + "'";

        // cerca se esiste l'ID tra le ore di progetti chargable    
        if (Database.RecordEsiste("SELECT * FROM Hours as a INNER JOIN Project as b ON b.Projects_id = a.Projects_id WHERE b.ProjectType_Id='" +  ConfigurationManager.AppSettings["PROGETTO_CHARGABLE"]  + "' AND a.Location_id =" + ASPcompatility.FormatStringDb(ClientLocation_id)))
            return false;

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

    [WebMethod(EnableSession = true)]
    public bool DeleteProjectRecord(string ProjectLocation_id)
    {

        string sDelete = "DELETE LOC_ProjectLocation " +
                         " WHERE ProjectLocation_id = '" + ProjectLocation_id + "'";

        // cerca se esiste l'ID tra le ore di progetti internal investment o infrastructure
        if (Database.RecordEsiste("SELECT * FROM Hours as a INNER JOIN Project as b ON b.Projects_id = a.Projects_id WHERE (b.ProjectType_Id='" + ConfigurationManager.AppSettings["PROGETTO_INTERNAL_INVESTMENT"] + "' OR b.ProjectType_Id='" + ConfigurationManager.AppSettings["PROGETTO_INFRASTRUCTURE"] + "') AND a.Location_id =" + ASPcompatility.FormatStringDb(ProjectLocation_id)))
            return false;

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

}    