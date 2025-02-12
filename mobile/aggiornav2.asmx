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

public class Opportunita
{
    public string OpportunityId { get; set; }
    public string OpportunityName { get; set; }
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

    //  ***** Leggi Opportunità ****   
    [WebMethod(EnableSession = true)] // per avere variabili di sessione 
    public List<Opportunita> GetOpportunityList()
    {
        var ReturnList = new List<Opportunita>();
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        foreach (Opportunity rs in CurrentSession.ListaOpenOpportunity)
        {
            var emp = new Opportunita
            {
                OpportunityId = rs.OpportunityCode,
                OpportunityName = rs.OpportunityAccount.AccountName + " - " + rs.OpportunityName
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

       // recuperare lo userid da scrivere nel log di modifica
    protected string get_userid(int Persons_id)
    {

        DataTable dt = Database.GetData("Select userid from Persons where Persons_id=" + Persons_id, null);
        // ritorna un solo record
        return dt.Rows[0]["userid"].ToString();

    }

}