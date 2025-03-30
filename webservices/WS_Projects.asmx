<%@ WebService Language="C#" Class="WS_Projects" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.IO;

/// <summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WS_Projects : System.Web.Services.WebService
{

    public TRSession CurrentSession;

    public WS_Projects()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    public class AjaxCallResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
    }

    //  **** CHECK OPPORTUNITY ***** 
    // Richiamata da modifiche massive 
    // controlla che: se progetto BD l'opportunità sia valorizzata e presente in SF
    //                se progetto non BD l'opportunità non è valorizzata
    [WebMethod(EnableSession = true)]
    public AjaxCallResult CheckOpportunity(string OpportunityId, string Project_id)
    {
        TRSession CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        if ( Project_id == "" )
            return new AjaxCallResult { Success = true, Message = "" };

        try
        {

            // Cerca il progetto nella tabella dtProgettiTutti
            DataRow[] projectRows = CurrentSession.dtProgettiTutti.Select("Projects_Id = " + Project_id);

            string projectTypeId;
            if (projectRows.Length > 0)
                projectTypeId = projectRows[0]["ProjectType_Id"].ToString();
            else {
                return new AjaxCallResult { Success = false, Message = "Errore non specificato" };
            }

            if ( projectTypeId != ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"] && OpportunityId != "")
                return new AjaxCallResult { Success = false, Message = "Opportunita solo su progetti BD" };

            if ( projectTypeId == ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"] && OpportunityId == "")
                return new AjaxCallResult { Success = false, Message = "Opportunita obbligatoria su progetti BD" };

            // Check if the OpportunityId exists in the ListaAllOpportunity list
            if (OpportunityId != "")
            {
                bool exists = CurrentSession.ListaAllOpportunity.Exists(opportunity => opportunity.OpportunityCode == OpportunityId);
                if (!exists)
                    return new AjaxCallResult { Success = false, Message = "Opportunita non presente in Salesforce" };
            }

            return new AjaxCallResult { Success = true, Message = "" };
        }
        catch (Exception)
        {
            return new AjaxCallResult { Success = true, Message = "Errore non specificato" };
        }
    }

    //  **** COPIA PROGETTO ***** 
    [WebMethod(EnableSession = true)]
    public AjaxCallResult CopyProject(int Project_Id, string ProjectCode, string ProjectName, bool forceFlag)
    {
        // recupera oggetto con variabili di sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];
        AjaxCallResult result = new AjaxCallResult();

        string SQLProject = " INSERT INTO Projects ( ProjectCode, Name ,ProjectType_Id,Channels_Id,Company_id ,Active ,ProjectVisibility_id " +
                           " ,ClientManager_id,TipoContratto_id,SpeseBudget,SpeseForfait,ImportoSpeseForfait,RevenueFatturate,SpeseFatturate " +
                           " ,Incassato,PianoFatturazione,MetodoPagamento,TerminiPagamento,CodiceCliente,Note,RevenueBudget,ActivityOn,DataInizio " +
                           " ,DataFine,MargineProposta,BudgetABAP,BudgetGGABAP,BloccoCaricoSpese,TestoObbligatorio,MessaggioDiErrore,NoOvertime,AccountManager_id " +
                           " ,WorkflowType, CreationDate ,CreatedBy, LastModificationDate, LastModifiedBy ,LOB_Id, SFContractType_id) " +
                           " SELECT " +
                           ASPcompatility.FormatStringDb(ProjectCode) + " , " +
                           ASPcompatility.FormatStringDb(ProjectName) +
                           " ,ProjectType_Id,Channels_Id,Company_id ,Active ,ProjectVisibility_id " +
                           " ,ClientManager_id,TipoContratto_id,SpeseBudget,SpeseForfait,ImportoSpeseForfait,RevenueFatturate,SpeseFatturate " +
                           " ,Incassato,PianoFatturazione,MetodoPagamento,TerminiPagamento,CodiceCliente,Note,RevenueBudget,ActivityOn,DataInizio " +
                           " ,DataFine,MargineProposta,BudgetABAP,BudgetGGABAP,BloccoCaricoSpese,TestoObbligatorio,MessaggioDiErrore,NoOvertime,AccountManager_id " +
                           " ,WorkflowType," + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " , " +
                           ASPcompatility.FormatStringDb(CurrentSession.UserId) +
                           ", '', '',LOB_Id, SFContractType_id " +
                           " FROM Projects WHERE Projects_id = " + ASPcompatility.FormatNumberDB(Project_Id);

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            conn.Open();
            SqlTransaction transaction = conn.BeginTransaction();

            try
            {
                SqlCommand cmdProject = new SqlCommand(SQLProject, conn, transaction);
                cmdProject.ExecuteNonQuery();

                // Recupera il Project_id all'interno della stessa transazione
                SqlCommand cmdSelect = new SqlCommand("SELECT Projects_id FROM Projects WHERE ProjectCode = " + ASPcompatility.FormatStringDb(ProjectCode), conn, transaction);
                object obj = cmdSelect.ExecuteScalar();

                if (obj == null)
                    throw new Exception("Errore in aggiornamento tabella progetti");

                // se deve copiare le autorizzazioni
                if (!forceFlag)
                {
                    transaction.Commit();
                    result.Success = true;
                    return (result);
                }

                // copia le autorizzazioni
                int Project_id;
                int.TryParse(obj.ToString(), out Project_id);
                string SQLForced = " INSERT INTO ForcedAccounts (Persons_id, Projects_id, CreationDate, CreatedBy) " +
                                           " SELECT Persons_id, " + ASPcompatility.FormatNumberDB(Project_id) + ", " + ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + "," + ASPcompatility.FormatStringDb(CurrentSession.UserId) +
                                           " FROM ForcedAccounts WHERE Projects_id = " + ASPcompatility.FormatNumberDB(Project_Id);

                SqlCommand cmdForced = new SqlCommand(SQLForced, conn, transaction);
                cmdForced.ExecuteNonQuery();

                transaction.Commit();

            }
            catch (Exception)
            {
                transaction.Rollback();
                result.Success = false;
                result.Message = "Errore in aggiornamento";
                return result;
            }

            result.Success = true;
            return (result);
        }

    }
}