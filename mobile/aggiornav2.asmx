<%@ WebService Language="C#" Class="Aggiorna" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.IO;

// definisce la struttura della lista progetti da ritornare con GetProjectsList
public class Projects
{
    public int ProjectId { get; set; }
    public string ProjectName { get; set; }
}

public class Activity
{
    public int ActivityId { get; set; }
    public string ActivityName { get; set; }
}

public class Spese
{
    public int SpeseId { get; set; }
    public string SpeseName { get; set; }
}

public class TipoOre
{
    public int TipoOreId { get; set; }
    public string TipoOreName { get; set; }
}

// classe usata da validatore per formattare la risposta
public class TipoSpesa
{
    public string NomeSpesa { get; set; }
    public Boolean TestoObbligatorio { get; set; }
    public string MessaggioDiErrore { get; set; }
}

// classe usata da validatore per formattare la risposta
public class Progetto
{
    //    public string NomeSpesa { get; set; }
    public Boolean TestoObbligatorio { get; set; }
    public string MessaggioDiErrore { get; set; }
}

public class VerificaBloccoSpese
{
    public Boolean BloccoCaricoSpese { get; set; }
}

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class Aggiorna : System.Web.Services.WebService
{

    // recuperare il tipo progetto per attivare il campo opportunità
    [WebMethod]
    public int GetProjectTypeId(int Projects_id)
    {
        DataTable dt = Database.GetData("Select ProjectType_Id from Projects where Projects_id=" + Projects_id, null);
        // ritorna un solo record
        return Convert.ToInt16(dt.Rows[0]["ProjectType_Id"].ToString());
    }

    // Validatore custom obbligatorietà campo note su form spese
    [WebMethod]
    public TipoSpesa GetTipoSpesaPerValidatore(int ExpenseType_id)
    {
        TipoSpesa rc = new TipoSpesa();
        DataTable dt = Database.GetData("SELECT Name, TestoObbligatorio, MessaggioDiErrore FROM ExpenseType where ExpenseType_Id = " + ExpenseType_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.TestoObbligatorio = false;
            rc.MessaggioDiErrore = "";
            rc.NomeSpesa = "not found";
        }
        else
        {
            // ritorna un solo record 
            rc.TestoObbligatorio = (dt.Rows[0]["TestoObbligatorio"] == DBNull.Value) ? false : Convert.ToBoolean(dt.Rows[0]["TestoObbligatorio"]);
            rc.MessaggioDiErrore = dt.Rows[0]["MessaggioDiErrore"].ToString();
            rc.NomeSpesa = dt.Rows[0]["Name"].ToString();
        }

        return rc;

    } // GetTipoSpesa


    // Validatore custom obbligatorietà campo note su form Ore
    [WebMethod]
    public Progetto ValidatoreCommentiProgetto(int Projects_Id)
    {
        Progetto rc = new Progetto();
        // legge il record tipo spesa
        DataTable dt = Database.GetData("SELECT TestoObbligatorio, MessaggioDiErrore FROM Projects where Projects_Id = " + Projects_Id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.TestoObbligatorio = false;
            rc.MessaggioDiErrore = "";
        }
        else
        {
            rc.TestoObbligatorio = (dt.Rows[0]["TestoObbligatorio"] == DBNull.Value) ? false : Convert.ToBoolean(dt.Rows[0]["TestoObbligatorio"]);
            rc.MessaggioDiErrore = dt.Rows[0]["MessaggioDiErrore"].ToString();
        }

        return rc;

    } // ValidatoreCommentiProgetto


    // Leggi BloccoCaricoSpese
    [WebMethod]
    public VerificaBloccoSpese BloccoCaricoSpeseValidatore(int Projects_Id)
    {
        VerificaBloccoSpese rc = new VerificaBloccoSpese();
        // legge il record tipo spesa
        DataTable dt = Database.GetData("SELECT BloccoCaricoSpese FROM Projects where Projects_Id = " + Projects_Id, null);

        if (dt == null || dt.Rows.Count == 0)
        {
            rc.BloccoCaricoSpese = false;
        }
        else
        {
            rc.BloccoCaricoSpese = (dt.Rows[0]["BloccoCaricoSpese"] == DBNull.Value) ? false : Convert.ToBoolean(dt.Rows[0]["BloccoCaricoSpese"]);
        }

        return rc;

    } // BloccoCaricoSpese

    //  ***** Leggi Spese ****   
    [WebMethod(EnableSession = true)] // per avere variabili di sessione 
    public List<Spese> GetSpeseList(int Person_id)
    {
        var ReturnList = new List<Spese>();
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        foreach (DataRow rs in CurrentSession.dtSpeseForzate.Rows)
        {
            var emp = new Spese
            {
                SpeseId = (int)rs["ExpenseType_Id"],
                SpeseName = rs["descrizione"].ToString()
            };
            ReturnList.Add(emp);
        }

        return ReturnList;

    } // GetSpesaList

    //  ***** Leggi progetti ****   
    [WebMethod(EnableSession = true)] // per avere variabili di sessione 
    public List<Projects> GetProjectsList(int Person_id)
    {
        var ReturnList = new List<Projects>();
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        foreach (DataRow rs in CurrentSession.dtProgettiForzati.Rows)
        {
            var emp = new Projects
            {
                ProjectId = (int)rs["Projects_Id"],
                ProjectName = rs["DescProgetto"].ToString()
            };
            ReturnList.Add(emp);
        }

        return ReturnList;
    } // GetProjectsList

    //  ***** Leggi attività ****   
    [WebMethod]
    public List<Activity> GetActivityList(int Projects_id)
    {

        var ReturnList = new List<Activity>();
        DataTable dt = Database.GetData("SELECT activity_id, ([ActivityCode] + ' ' + [Name]) as ActivityNames FROM Activity WHERE ( Projects_id = " + Projects_id.ToString() + " )  ORDER BY ActivityCode", null);

        foreach (DataRow rs in dt.Rows)
        {
            var emp = new Activity
            {
                ActivityId = (int)rs[0],
                ActivityName = rs[1].ToString()
            };
            ReturnList.Add(emp);
        }

        return ReturnList;
    } // GetProjectsList

    //  ***** Leggi e filtra location in base al progetto o cliente ****   
    [WebMethod(EnableSession = true)] // per avere variabili di sessione 
    public List<LocationRecord> GetLocationList(int Projects_id)
    {
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];
        List<LocationRecord> retList = new List<LocationRecord>();

        // recupera cliente associato al progetto
        DataRow dr = Database.GetRow("SELECT CodiceCliente FROM Projects WHERE Projects_id =  " + ASPcompatility.FormatNumberDB(Projects_id), null);

        // Filtra elenco location
        foreach (LocationRecord lr in CurrentSession.LocationList)
        {
            if (lr.ParentKey == Projects_id.ToString() || lr.ParentKey == dr["CodiceCliente"].ToString())
                retList.Add(lr);
        }
        return retList;
    } // GetLocationList

    //  ***** Aggiorna Ore ****   
    [WebMethod(EnableSession = true)] // per avere variabili di sessione 
    public string salvaore(string TbdateForHours, int TbHours, int Person_id, int Projects_Id, int Activity_Id, int HourType_Id, string comment, bool CancelFlag, string LocationKey, string LocationType, string LocationDescription, string OpportunityId)
    {
        string sResult;
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        try
        {
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT top 1 * FROM Hours", conn);
            SqlCommandBuilder builder = new SqlCommandBuilder(adapter);

            // Create a dataset object
            DataSet ds = new DataSet("DSHours");
            adapter.Fill(ds, "Hours");

            // Create a data table object and add a new row
            DataTable HoursTable = ds.Tables["Hours"];
            DataRow row = HoursTable.NewRow();

            // recupera società e manager
            DataRow drPerson = Database.GetRow("SELECT company_id FROM Persons WHERE Persons_id = " + ASPcompatility.FormatNumberDB(Person_id), null);
            // recupera anagrafica progetto
            DataRow drProject = Database.GetRow("SELECT ClientManager_id, AccountManager_id  FROM Projects WHERE Projects_id = " + ASPcompatility.FormatNumberDB(Projects_Id), null);

            // recupera dati relativi alla location da salvare sul record ore
            //LocationRecord lr = CurrentSession.LocationList.Find(x => x.LocationKey == LocationKey);
            //if (lr == null)
            //    lr = new LocationRecord();

            row["Date"] = TbdateForHours;
            row["Projects_Id"] = Projects_Id;
            row["Activity_Id"] = Activity_Id;
            row["Persons_Id"] = Person_id;
            row["HourType_Id"] = HourType_Id;
            row["Hours"] = (CancelFlag == true ? -1 : 1) * TbHours;
            row["comment"] = comment.ToString();
            row["CancelFlag"] = CancelFlag;
            row["Company_id"] = Convert.ToInt32(drPerson["Company_id"]);
            row["AccountManager_id"] = Convert.ToInt32(drProject["AccountManager_id"]);
            row["ClientManager_id"] = Convert.ToInt32(drProject["ClientManager_id"]);
            row["CreationDate"] = DateTime.Now;
            row["CreatedBy"] = get_userid(Person_id);
            row["LocationKey"] = LocationKey;
            row["LocationType"] = LocationType;
            row["LocationDescription"] = LocationDescription;
            row["CreatedBy"] = get_userid(Person_id);
            row["OpportunityId"] = OpportunityId;
                
            HoursTable.Rows.Add(row);

            // Update data adapter
            adapter.Update(ds, "Hours");
        }
        catch (Exception exp)
        {
            //    Console.WriteLine("Error: " + exp);
            sResult = exp.ToString();
        }
        finally
        {
            conn.Close();
            sResult = "true";
        }
        return (sResult);
    }

    //  ***** Aggiorna Spese ****   
    [WebMethod]
    public string salvaspese(string Tbdate, string TbExpenseAmount, int Person_id, string UserName, int Projects_Id, int ExpenseType_Id, 
                             string comment, bool CreditCardPayed, bool CompanyPayed, bool CancelFlag, bool InvoiceFlag, string strFileName, 
                             string strFileData, string OpportunityId)
    {
        string sResult;
        // inizializzazione
        int newIdentity = 0;

        // ** SALVA IL RECORD **
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        try
        {
            conn.Open();
            SqlDataAdapter adapter = new SqlDataAdapter("SELECT top 1 * FROM Expenses", conn);
            SqlCommandBuilder builder = new SqlCommandBuilder(adapter);

            // recupera nome 


            // Create a dataset object
            DataSet ds = new DataSet("DSExpenses");
            adapter.Fill(ds, "Expenses");

            // Create a data table object and add a new row
            DataTable ExpensesTable = ds.Tables["Expenses"];
            DataRow row = ExpensesTable.NewRow();

            TbExpenseAmount = TbExpenseAmount.Replace('.', ',');

            // recupera flag AdditionalCharges
            DataRow dr = Database.GetRow("SELECT AdditionalCharges, ConversionRate FROM ExpenseType WHERE ExpenseType_id  = " + ASPcompatility.FormatNumberDB(ExpenseType_Id), null);
            DataRow dr1 = Database.GetRow("SELECT ClientManager_id, AccountManager_id FROM Projects WHERE Projects_id  = " + ASPcompatility.FormatNumberDB(Projects_Id), null);
            DataRow dr2 = Database.GetRow("SELECT Company_id FROM Persons WHERE Persons_id  = " + ASPcompatility.FormatNumberDB(Person_id), null);

            row["Date"] = Tbdate;
            row["Projects_Id"] = Projects_Id;
            row["Persons_Id"] = Person_id;
            row["ExpenseType_Id"] = ExpenseType_Id;
            row["AdditionalCharges"] = dr["AdditionalCharges"];
            row["TipoBonus_Id"] = 0; // solo tipo bonus
            row["amount"] = (CancelFlag == true ? -1 : 1) * Convert.ToSingle(TbExpenseAmount);
            row["comment"] = comment.ToString();
            row["CreditCardPayed"] = CreditCardPayed;
            row["CompanyPayed"] = CompanyPayed;
            row["CancelFlag"] = CancelFlag;
            row["InvoiceFlag"] = InvoiceFlag;
            row["ClientManager_id"] = dr1["ClientManager_id"];
            row["AccountManager_id"] = dr1["AccountManager_id"];
            row["Company_id"] = dr2["Company_id"];
            row["CreationDate"] = DateTime.Now;
            row["CreatedBy"] = get_userid(Person_id);
            row["AmountInCurrency"] = Convert.ToDouble(row["amount"].ToString()) * Convert.ToDouble(dr["ConversionRate"].ToString()) ;
            row["OpportunityId"] = OpportunityId;

            ExpensesTable.Rows.Add(row);

            // Update data adapter
            newIdentity = adapter.Update(ds, "Expenses");
            ds.AcceptChanges();

            // recupera chiave inserita 
            SqlCommand sc = new SqlCommand("SELECT MAX(Expenses_id) from Expenses where Persons_Id=" + Person_id, conn);
            newIdentity = (int)sc.ExecuteScalar();

        }
        catch (Exception exp)
        {
            //    Console.WriteLine("Error: " + exp);
            sResult = exp.ToString();
            return (sResult);
        }
        finally
        {
            conn.Close();
        }

        if (strFileName.Trim() == "")
            return ("true");

        // *** SALVA IMMAGINE ***
        try
        {
            // costruisce il nome directory, formato data da chiamata WS AAAA-MM-GG    
            string TargetLocation = Server.MapPath(ConfigurationManager.AppSettings["PATH_RICEVUTE"]) + Tbdate.Substring(0, 4) + "\\" + Tbdate.Substring(5, 2) + "\\" + UserName.Trim() + "\\";


            // se non esiste la directory la crea
            DirectoryInfo DITargetLocation = new DirectoryInfo(TargetLocation);
            if (!DITargetLocation.Exists)
                DITargetLocation.Create();

            // costruisce il nome file     
            string ext = Path.GetExtension(strFileName);
            string FilePath = TargetLocation + "fid-" + (string)newIdentity.ToString() + "-" + DateTime.Now.ToString("yyyyMMddHHmmss") + ext;

            using (FileStream fs = new FileStream(FilePath, FileMode.Create))
            {
                using (BinaryWriter bw = new BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(strFileData);
                    bw.Write(data);
                    bw.Close();
                }
            }
        }
        catch (Exception exp)
        {
            //    Console.WriteLine("Error: " + exp);
            sResult = exp.ToString();
            return (sResult);
        }
        finally
        {
            sResult = "true";
        }

        return (sResult);
    }

    // recuperare lo userid da scrivere nel log di modifica
    protected string get_userid(int Persons_id)
    {

        DataTable dt = Database.GetData("Select userid from Persons where Persons_id=" + Persons_id, null);
        // ritorna un solo record
        return dt.Rows[0]["userid"].ToString();

    }

}