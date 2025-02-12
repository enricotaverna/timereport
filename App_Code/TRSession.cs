using classiStandard;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Globalization;
using System.Web;
using System.Web.Configuration;

/// <summary>
/// Descrizione di riepilogo per TRSession
/// Richiamare con CurrentSession = (TRSession)Session["CurrentSession"]; 
/// </summary>
/// 

public class LocationRecord
{
    public string ParentKey { get; set; }
    public string LocationKey { get; set; }
    public string LocationType { get; set; } // P = Project C = Client
    public string LocationDescription { get; set; }
}

public class Opportunity
{
    //[JsonProperty("Account.Name")]
    //public string AccountName { get; set; }

    public class Account
    {
        [JsonProperty("Name")]
        public string AccountName { get; set; }
    }

    [JsonProperty("Code__c")]
    public string OpportunityCode { get; set; }
    [JsonProperty("Name")]
    public string OpportunityName { get; set; }
    [JsonProperty("Account")]
    public Account OpportunityAccount { get; set; }
    [JsonProperty("Open_date__c")]
    public string OpenDate { get; set; }
    [JsonProperty("StageName")]
    public string StageName { get; set; }
}

public class TRSession
{
    // bufferizza la lista delle location selezionabili in input_spese.aspx
    public List<LocationRecord> LocationList = new List<LocationRecord>();
    // Progetti disponibili per la persona
    public DataTable dtProgettiForzati;
    public DataTable dtSpeseForzate;
    public DataTable dtProgettiTutti;
    public DataTable dtSpeseTutte;
    public List<TaskRay> ListaTask = new List<TaskRay>();
    public List<Opportunity> ListaOpenOpportunity = new List<Opportunity>();
    public List<Opportunity> ListaAllOpportunity = new List<Opportunity>();
    // personal setting
    public int Persons_id;
    public int Company_id;
    public int ContractHours;
    public string UserName;
    public string UserId;
    public string UserMail;
    public string Language; // it or en
    public int UserLevel;
    public string sCutoffDate;
    public DateTime dCutoffDate;
    public Boolean ForcedAccount;
    public string BackgroundColor;
    public string BackgroundImage;
    public int Calendar_id;
    public string SalesforceAccount;
    public CultureInfo defaultCulture;

    public TRSession(int inputPersons_id)
    {
        Persons_id = inputPersons_id;

        LoadLocationList();

        LoadPersonsRecord();

        LoadOptions();

        LoadProgettieSpese();

        LoadPersonalSetting();

        if (SalesforceAccount != "")
        {
            LoadSFTask();
        }

        LoadSFOpportunity();

    }

    public void LoadProgettieSpese()
    {
        if (ForcedAccount)
        {
            LoadProgettiForzati(Persons_id);
            //** A.1 Carica progetti possibili
            // 04/10/24 filtra progetti con data fine > data cutoff

            //** A.2 Carica spese possibili				
            //** A.2.1 Prima verifica se il cliente ha un profilo di spesa	
            // carica spese forzate per persona
            dtSpeseForzate = Database.GetData("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ForcedExpensesPers.Persons_id = " + ASPcompatility.FormatNumberDB(Persons_id) + " ORDER BY ExpenseType.ExpenseCode", null);
        }
        else
        {
            //** B.1 tutti i progetti attivi con flag di obbligatorietà messaggio		
            // 04/10/24 filtra progetti con data fine > data cutoff
            dtProgettiForzati = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM v_Projects WHERE active = 1 AND v_Projects.DataFine > " + ASPcompatility.FormatDatetimeDb(dCutoffDate) + " ORDER BY ProjectCode", null);
            //** B.2 tutte le spese attive 							
            dtSpeseForzate = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode", null);
        }

        //  tutti i progetti, anche inattivi
        dtProgettiTutti = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id, active  FROM v_Projects ORDER BY ProjectCode", null);
        dtSpeseTutte = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ExpenseType ORDER BY ExpenseCode", null);
    }

    public void LoadProgettiForzati(int Persons_id)
    {
        if (!ForcedAccount)
            return;

        string dataOggiDb = ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy"));

        dtProgettiForzati = Database.GetData(
        "SELECT DISTINCT PV.Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id " +
        "FROM ForcedAccounts AS FA " +
        "RIGHT JOIN v_Projects AS PV ON FA.Projects_id = PV.Projects_Id " +
        "WHERE " +
        "( " +
            // progetti della persona o sempre disponibili
            "( FA.Persons_id=" + ASPcompatility.FormatNumberDB(Persons_id) + " OR PV.Always_available = 1 ) " +
            "AND " +
            // progetti attivi e con data fine > data cutoff
            "( PV.active = 1 AND PV.DataFine > " + ASPcompatility.FormatDatetimeDb(dCutoffDate) + ") " +
            "AND " +
            // progetto senza budget o con budget disponibile
            "(" +
                "( FA.DaysBudget IS NULL OR FA.DaysBudget = 0  ) OR " +
                "( FA.DataDa <= " + dataOggiDb + " AND FA.DataA >= " + dataOggiDb + " AND FA.DaysBudget > FA.DaysActual ) " +
            ") " +
        ")  " +
        "ORDER BY PV.ProjectCode", null);
    }

    public void LoadLocationList()
    {

        DataTable dt = new DataTable();

        // Carica Location
        dt = Database.GetData("select * from LOC_ClientLocation", null);

        // carica Dictionary
        foreach (DataRow dr in dt.Rows)
        {
            LocationRecord item = new LocationRecord();
            item.ParentKey = dr["CodiceCliente"].ToString().TrimEnd();
            item.LocationKey = dr["ClientLocation_id"].ToString().TrimEnd();
            item.LocationDescription = dr["LocationDescription"].ToString();
            item.LocationType = "C"; // customer, usato su input.aspx.cs
            LocationList.Add(item);
        }

        // Carica Location
        dt = Database.GetData("select * from LOC_ProjectLocation", null);

        // carica Dictionary
        foreach (DataRow dr in dt.Rows)
        {
            LocationRecord item = new LocationRecord();
            item.ParentKey = dr["Projects_id"].ToString();
            item.LocationKey = dr["ProjectLocation_id"].ToString().TrimEnd();
            item.LocationDescription = dr["LocationDescription"].ToString();
            item.LocationType = "P"; // Project, usato su input.aspx.cs
            LocationList.Add(item);
        }

    }

    public void LoadPersonsRecord()
    {
        DataRow rdr = Database.GetRow("SELECT * from Persons WHERE persons_id= " + ASPcompatility.FormatNumberDB(Persons_id), null);
        ContractHours = Convert.ToInt16(rdr["ContractHours"].ToString());
        Company_id = Convert.ToInt16(rdr["Company_id"].ToString());
        UserName = rdr["Name"].ToString();
        UserId = rdr["UserId"].ToString();
        UserMail = rdr["Mail"].ToString();
        UserLevel = Convert.ToInt16(rdr["UserLevel_ID"].ToString());
        ForcedAccount = rdr["ForcedAccount"].ToString() == "True" ? true : false;
        Language = rdr["Lingua"].ToString();
        Calendar_id = Convert.ToInt16(rdr["calendar_id"].ToString());
        SalesforceAccount = rdr["SaleforceEmail"].ToString();
    }

    public void LoadOptions()
    {
        DataRow rdr = Database.GetRow("SELECT * from Options", null);
        dCutoffDate = Utilities.GetCutoffDate(rdr["cutoffPeriod"].ToString(), rdr["cutoffMonth"].ToString(), rdr["cutoffYear"].ToString(), "end");
        sCutoffDate = dCutoffDate.ToString("d");
    }

    public void LoadPersonalSetting()
    {
        // colore background
        string BkgColor = Utilities.GetCookie("background-color");
        if (BkgColor != "")
            BackgroundColor = BkgColor;
        else
            BackgroundColor = MyConstants.BACKGROUND_COLOR_DEFAULT;

        // colore background
        string BkgImg = Utilities.GetCookie("background-image");
        if (BkgImg != "")
        {
            BackgroundColor = "";
            BackgroundImage = BkgImg;
        }

        // culture
        defaultCulture = CultureInfo.GetCultureInfo("it-IT");
    }

    public void LoadSFTask()
    {
        try
        {
            string serviceURL = "";

            string SFconnect = WebConfigurationManager.AppSettings["SALESFORCE"];
            string[] Splitted = SFconnect.ToString().Split(';');

            clsParametri.Parametri.clientID = Splitted[0].ToString().Split('=')[1];
            clsParametri.Parametri.ClientSecret = Splitted[1].ToString().Split('=')[1];
            clsParametri.Parametri.refresh_token = Splitted[2].ToString().Replace("refresh_token=", "");
            clsParametri.Parametri.EndpointSF = Splitted[3].ToString().Split('=')[1];
            clsParametri.Parametri.SFVersione = Splitted[4].ToString().Split('=')[1];

            string SFtoken = clsUtility.GetTokenSF();

            serviceURL += string.Format("SELECT+id,Name,TASKRAY__Project__r.Name,TASKRAY__Project__r.Contratto__r.Commessa_Aeonvis__c,Owner.Name,Owner.Email,Codice_Progetto_TR__c+" +
                                            "FROM+TASKRAY__Project_Task__c+WHERE+TASKRAY__Project__r.Contratto__r.Commessa_Aeonvis__c!=null+AND+TASKRAY__trCompleted__c=false" +
                                            "+AND+TASKRAY__Project__r.Contratto__r.Commessa_Aeonvis__c!=null+AND+Owner.Email='{0}'" +
                                            "+AND+Milestone_Senza_peso__c=False+AND+TASKRAY__trIsMilestone__c=False+AND+TASKRAY__List__c+!='Finished'+AND+TASKRAY__List__c+!='To Be Confirmed'" +
                                            "+order+by+TASKRAY__Project__r.Name", SalesforceAccount);


            string JSON_TOT = "";
            clsStandard.GetAllRecord AllRecord = new clsStandard.GetAllRecord();
            clsUtility.GetPagedData(serviceURL, ref JSON_TOT, ref AllRecord);
            ListaTask.Clear();
            if (AllRecord.records != null)
            {
                //ciclo tutti i record di ritorno 
                for (int i = 0; i <= AllRecord.records.Count - 1; i++)
                {
                    TaskRay Newrec = new TaskRay();
                    Newrec = JsonConvert.DeserializeObject<TaskRay>(AllRecord.records[i].ToString());
                    ListaTask.Add(Newrec);
                }
            }
        }
        catch (Exception ex)
        {
            var st = new StackTrace(ex, true);
            var sf = st.GetFrame(st.FrameCount - 1);
            string ErrorLine = clsUtility.NullToString(sf.GetFileLineNumber()).ToString();
            string MethodName = clsUtility.NullToString(sf.GetMethod().Name).ToString();
            string FileSource = clsUtility.NullToString(sf.GetFileName()).ToString();
            string Description = String.Format("Method Name: {0} - Error Line: {1} - FileSource: {2}", MethodName, ErrorLine, FileSource);
            clsLog.WriteErrLog("0", ex.Message, Description.ToString());
        }

    }

    //** Carica elenco opportunità da SF Aeonvis **//
    public void LoadSFOpportunity()
    {

        // selezione solo opportunità aperte non più vecchie di 2 anni
        string sAnnoPrima = (DateTime.Now.Year - 4).ToString() + "-01-01";
        int maxLung;

        try
        {
            string serviceURL = "";

            string SFconnect = WebConfigurationManager.AppSettings["TRSALESFORCE"];
            string[] Splitted = SFconnect.ToString().Split(';');

            clsParametri.Parametri.clientID = Splitted[0].ToString().Split('=')[1];
            clsParametri.Parametri.ClientSecret = Splitted[1].ToString().Split('=')[1];
            clsParametri.Parametri.refresh_token = Splitted[2].ToString().Replace("refresh_token=", "");
            clsParametri.Parametri.EndpointSF = Splitted[3].ToString().Split('=')[1];
            clsParametri.Parametri.SFVersione = Splitted[4].ToString().Split('=')[1];

            string SFtoken = clsUtility.GetTokenSF();

            serviceURL += string.Format("SELECT Code__c, Name, Account.Name, Open_date__c, StageName FROM Opportunity ORDER BY Account.Name, Name", SalesforceAccount);

            string JSON_TOT = "";
            clsStandard.GetAllRecord AllRecord = new clsStandard.GetAllRecord();
            clsUtility.GetPagedData(serviceURL, ref JSON_TOT, ref AllRecord);

            ListaOpenOpportunity.Clear();
            ListaAllOpportunity.Clear();

            if (AllRecord.records != null)
            {
                //ciclo     tutti i record di ritorno 
                for (int i = 0; i <= AllRecord.records.Count - 1; i++)
                {
                    Opportunity newRec = new Opportunity();
                    newRec = JsonConvert.DeserializeObject<Opportunity>(AllRecord.records[i].ToString());

                    maxLung = newRec.OpportunityAccount.AccountName.Length > 12 ? 12 : newRec.OpportunityAccount.AccountName.Length;

                    // se tronca mette i puntini al nome Account
                    if (maxLung < newRec.OpportunityAccount.AccountName.Length)
                        newRec.OpportunityAccount.AccountName = newRec.OpportunityAccount.AccountName.Substring(0, maxLung) + "..";
                    else
                        newRec.OpportunityAccount.AccountName = newRec.OpportunityAccount.AccountName.Substring(0, maxLung);

                    // evita problemi con caratteri speciali
                    newRec.OpportunityName = HttpUtility.HtmlEncode(newRec.OpportunityName);
                    newRec.OpportunityAccount.AccountName = HttpUtility.HtmlEncode(newRec.OpportunityAccount.AccountName);

                    ListaAllOpportunity.Add(newRec);

                    if (newRec.StageName != "Closed Won" && newRec.StageName != "Closed Lost" && newRec.StageName != "Closed Archived" && string.Compare(newRec.OpenDate, sAnnoPrima) == 1)
                        ListaOpenOpportunity.Add(newRec);
                }
            }
        }
        catch (Exception ex)
        {
            //* gestione errore **//
        }

    }
}