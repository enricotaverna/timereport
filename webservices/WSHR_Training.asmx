<%@ WebService Language="C#" Class="WSHR_Training" %>

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

// definisce la struttura  da ritornare con GetCourse
public class Course
{
    public int Course_id { get; set; }
    public string CourseCode { get; set; }
    public string CourseName { get; set; }
    public string Description { get; set; }
    public int CourseType_id { get; set; }
    public int Product_id { get; set; }
    public string Area { get; set; }
    public bool Active { get; set; }
    public int CourseVendor_id { get; set; }
    public int DurationDays { get; set; }
    public float Cost { get; set; }
    public string ValidFrom { get; set; }
    public string ValidTo { get; set; }
}

// definisce la struttura  da ritornare con GetCoursePlanItem
public class CoursePlanItem
{
    public int CoursePlan_id { get; set; }
    public string Comment { get; set; }
}

/// <summary>
/// Summary description for WStimereport
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WSHR_Training : System.Web.Services.WebService {

    public WSHR_Training () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(EnableSession = true)]
    public bool UpdateTrainingPlanRecord(string sCoursePlan_id, string sFieldToUpdate, string sValue )
    {
        bool ret = false;

        if (sFieldToUpdate == "CourseStatusName") {
            sFieldToUpdate = "CourseStatus_id";
            sValue = Database.ExecuteScalar("SELECT CourseStatus_id from HR_CourseStatus WHERE CourseStatusName ='" + sValue + "'", null ).ToString();
        }

        if (sFieldToUpdate == "CourseDate") // formatta data
            sValue = ASPcompatility.FormatDateDb(sValue);
        else
            sValue = ASPcompatility.FormatStringDb(sValue);

        // aggiorna record del trainig plan
        if ( Convert.ToInt16(sCoursePlan_id) > 0)
            ret = Database.ExecuteSQL("Update HR_CoursePlan SET " + sFieldToUpdate + " = " + sValue + " WHERE CoursePlan_id='" + sCoursePlan_id + "'", null );

        return ret;

    }

    [WebMethod(EnableSession = true)]
    public int CreaTrainingPlanRecord(string sAnno, string sPersons_id, string sCourse_id )
    {

        int newIdentity = 0;

        string sInsert = "INSERT INTO HR_CoursePlan (Anno, Persons_id, Course_id, CourseStatus_id, Score ) " +
                         " VALUES (" + sAnno + ", " + sPersons_id + ", " + sCourse_id + ", 1 , 0 )";


        bool bResult = Database.ExecuteSQL(sInsert, null);

        if (bResult) {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(CoursePlan_id) from HR_CoursePlan where Persons_Id='" + sPersons_id +"'");
        }

        return newIdentity;

    }

    [WebMethod(EnableSession = true)]
    public bool CancellaTrainingPlanRecord(string sCoursePlan_id )
    {


        string sDelete = "DELETE HR_CoursePlan " +
                         " WHERE CoursePlan_id = '" + sCoursePlan_id + "'";


        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

    [WebMethod(EnableSession = true)]
    public string GetCourseCatalog(bool bActive, string sAnno)
    {

        DataTable dt = new DataTable();
        String query = "";

        if ( bActive )
            query = "SELECT * FROM v_course WHERE active = 'true' ORDER BY CourseCode";
        else
            query = "SELECT * FROM v_course  ORDER BY CourseCode";

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
    public string GetTrainingPlan(string Persons_id, string Anno, string Mode)
    {

        DataTable dt = new DataTable();

        // Smode
        // CREATE: Anno non seleziona, Persona deve essere valorizzata
        // SCHEDULE: Anno seleziona, Persona può sia essere selezionata che no (torna tutto)
        string sFilter = "";

        if (Mode == "CREATE")
        {
            sFilter = " WHERE A.Persons_id =  '" + Persons_id + "' ";
        }
        else if (Mode == "SCHEDULE") {
            sFilter = " WHERE Anno = " + Anno;
            sFilter = Persons_id == "0" ? sFilter : sFilter + " AND A.Persons_id =  '" + Persons_id + "' "; // se senza persona resituisce tutto il piano corsi
        }

        String query = "SELECT A.CoursePlan_id,A.Course_id, A.Anno, A.Comment, CONVERT(VARCHAR(10),A.CourseDate, 103) as CourseDate, E.CourseCode, E.CourseName, B.CourseTypeName, C.ProductName, E.Area, D.VendorName, F.CourseStatus_id, F.CourseStatusName, A.Score, G.Name as PersonName FROM HR_CoursePlan AS A " +
                                "JOIN HR_Course AS E ON E.Course_id = A.Course_id " +
                                "LEFT JOIN HR_CourseType AS B ON B.CourseType_id = E.CourseType_id " +
                                "LEFT JOIN HR_Product AS C ON C.Product_id= E.Product_id " +
                                "LEFT JOIN HR_CourseVendor AS D ON D.CourseVendor_id = E.CourseVendor_id " +
                                "JOIN HR_CourseStatus AS F ON F.CourseStatus_id = A.CourseStatus_id " +
                                "JOIN Persons AS G ON G.Persons_id = A.Persons_id " +
                                sFilter +
                                "ORDER BY A.Anno DESC, G.Persons_id, E.CourseCode ASC ";

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
    public int CreateUpdateCourse( int Course_id, string CourseName,
                           string Description, string CourseType_id,
                           string Product_id, string Area, string Active,
                           string CourseVendor_id, string  DurationDays,
                           string Cost, string ValidFrom, string ValidTo )
    {

        int newIdentity = 0;
        string sSQL = "";

        // formatta campi numerici
        if (DurationDays == null)
            DurationDays = "0";

        if (Cost == null)
            Cost = "0";

        if (Active == null)
            Active  = "false";

        //      genera il codice corso
        object obj = Database.ExecuteScalar("SELECT MAX(CourseCode) FROM HR_Course", null );
        int counter = Convert.ToInt32( obj.ToString().Substring(2, 4) );
        counter++;
        string CourseCode = "TR" + counter.ToString("0000");

        if (Course_id > 0)
            sSQL = "UPDATE HR_Course SET " +
                  "CourseCode = " + ASPcompatility.FormatStringDb(CourseCode) + " , " +
                  "CourseName = " + ASPcompatility.FormatStringDb(CourseName) + " , " +
                  "Description = " + ASPcompatility.FormatStringDb(Description) + " , " +
                  "CourseType_id = " + ASPcompatility.FormatStringDb(CourseType_id) + " , " +
                  "Product_id = " + ASPcompatility.FormatStringDb(Product_id) + " , " +
                  "Area = " + ASPcompatility.FormatStringDb(Area) + " , " +
                  "Active = " + ASPcompatility.FormatStringDb(Active) + " , " +
                  "CourseVendor_id = " + ASPcompatility.FormatStringDb(CourseVendor_id) + " , " +
                  "DurationDays = " + ASPcompatility.FormatStringDb(DurationDays) + " , " +
                  "Cost = " + ASPcompatility.FormatStringDb(Cost) + " , " +
                  "ValidFrom = " + ASPcompatility.FormatDateDb(ValidFrom) + " , " +
                  "ValidTo = " + ASPcompatility.FormatDateDb(ValidTo) +
                  " WHERE Course_id = " + ASPcompatility.FormatNumberDB(Course_id) ;
        else
            sSQL= "INSERT INTO HR_Course (CourseCode, CourseName, Description, CourseType_id, Product_id, Area, Active, CourseVendor_id, DurationDays, Cost, ValidFrom, ValidTo  ) " +
                            " VALUES (" + ASPcompatility.FormatStringDb(CourseCode) + ", " +
                                          ASPcompatility.FormatStringDb(CourseName) + ", " +
                                          ASPcompatility.FormatStringDb(Description) + ", " +
                                          ASPcompatility.FormatStringDb(CourseType_id) + ", " +
                                          ASPcompatility.FormatStringDb(Product_id) + ", " +
                                          ASPcompatility.FormatStringDb(Area) + ", " +
                                          ASPcompatility.FormatStringDb(Active.ToString()) + ", " +
                                          ASPcompatility.FormatStringDb(CourseVendor_id)  + ", " +
                                          ASPcompatility.FormatStringDb(DurationDays) + ", " +
                                          ASPcompatility.FormatStringDb(Cost) + ", " +
                                          ASPcompatility.FormatDateDb(ValidFrom) + ", " +
                                          ASPcompatility.FormatDateDb(ValidTo) + " )";

        bool bResult = Database.ExecuteSQL(sSQL, null);

        if (bResult) {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(Course_id) from HR_Course");
        }

        return newIdentity;

    }

    [WebMethod(EnableSession = true)]
    public bool DeleteCourse(string sCourse_id )
    {

        string sDelete = "DELETE HR_Course " +
                         " WHERE Course_Id = '" + sCourse_id + "'";


        if ( Database.RecordEsiste("SELECT * FROM HR_CoursePlan WHERE Course_Id =" + ASPcompatility.FormatStringDb(sCourse_id) ) )
            return false;

        bool bResult = Database.ExecuteSQL(sDelete, null);

        return bResult;

    }

    [WebMethod(EnableSession = true)]
    public Course GetCourse(string sCourse_id )
    {

        Course rc = new Course();

        DataTable dt = Database.GetData("SELECT * FROM HR_Course where Course_Id = " + sCourse_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.Course_id = 0;
        }
        else
        {
            rc.Course_id = Convert.ToInt32(dt.Rows[0]["Course_id"].ToString());
            rc.CourseCode = dt.Rows[0]["CourseCode"].ToString();
            rc.CourseName = dt.Rows[0]["CourseName"].ToString();
            rc.Description = dt.Rows[0]["Description"].ToString();
            rc.CourseType_id = Convert.ToInt32(dt.Rows[0]["CourseType_id"].ToString());
            rc.Product_id = Convert.ToInt32(dt.Rows[0]["Product_id"].ToString());
            rc.Area = dt.Rows[0]["Area"].ToString();
            rc.Active = Convert.ToBoolean(dt.Rows[0]["Active"].ToString());
            rc.CourseVendor_id = Convert.ToInt32(dt.Rows[0]["CourseVendor_id"].ToString());
            rc.DurationDays = Convert.ToInt32(dt.Rows[0]["DurationDays"].ToString());
            rc.Cost = (float)Convert.ToDouble(dt.Rows[0]["Cost"].ToString());
            rc.ValidFrom = dt.Rows[0]["ValidFrom"].ToString().Substring(0, 10);
            rc.ValidFrom = rc.ValidFrom == "01/01/1900"? "" : rc.ValidFrom;
            rc.ValidTo = dt.Rows[0]["ValidTo"].ToString().Substring(0, 10);
            rc.ValidTo = rc.ValidTo == "01/01/1900" ? "" : rc.ValidTo;

        }


        return rc;

    }

    [WebMethod(EnableSession = true)]
    public CoursePlanItem GetCoursePlanItem(string sCoursePlan_id )
    {

        CoursePlanItem rc = new CoursePlanItem();

        DataTable dt = Database.GetData("SELECT * FROM HR_CoursePlan where CoursePlan_Id = " + sCoursePlan_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.CoursePlan_id = 0;
        }
        else
        {
            rc.CoursePlan_id = Convert.ToInt32(dt.Rows[0]["CoursePlan_id"].ToString());
            rc.Comment = dt.Rows[0]["Comment"].ToString();
        }


        return rc;

    }

    [WebMethod(EnableSession = true)]
    public int CreateUpdateCoursePlanItem( int CoursePlan_id, string Comment )
    {
        int newIdentity = 0;
        string sSQL = "";

        sSQL = "UPDATE HR_CoursePlan SET " +
                  "Comment = " + ASPcompatility.FormatStringDb(Comment) +
                  " WHERE CoursePlan_id = " + ASPcompatility.FormatNumberDB(CoursePlan_id) ;

        bool bResult = Database.ExecuteSQL(sSQL, null);

        if (bResult) {
            // recupera record Id creato 
            newIdentity = Database.GetLastIdInserted("SELECT MAX(Course_id) from HR_Course");
        }

        return newIdentity;

    }


}
    