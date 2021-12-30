using System;
using System.Collections.Generic;
using System.Data;

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

public class TRSession
{
    // bufferizza la lista delle location selezionabili in input_spese.aspx
    public List<LocationRecord> LocationList = new List<LocationRecord>();
    // Progetti disponibili per la persona
    public DataTable dtProgettiForzati;
    public DataTable dtSpeseForzate;
    public DataTable dtProgettiTutti;
    public DataTable dtSpeseTutte;
    // personal setting
    public int Persons_id;
    public int Company_id;
    public int ContractHours;
    public string UserName;
    public string UserId;
    public string Language; // it or en
    public int UserLevel;
    public string sCutoffDate;
    public DateTime dCutoffDate;
    public Boolean ForcedAccount;
    public string BackgroundColor;
    public string BackgroundImage;
    public int Calendar_id;

    public TRSession(int inputPersons_id) {
        Persons_id = inputPersons_id;

        LoadLocationList();

        LoadPersonsRecord();

        LoadProgettieSpese();

        LoadOptions();

        LoadPersonalSetting();
    }

    public void LoadProgettieSpese()
    {
        if (ForcedAccount)
        {
            //** A.1 Carica progetti possibili
            dtProgettiForzati = Database.GetData("SELECT DISTINCT v_Projects.Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType,ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM ForcedAccounts RIGHT JOIN v_Projects ON ForcedAccounts.Projects_id = v_Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" + ASPcompatility.FormatNumberDB(Persons_id) + " OR v_Projects.Always_available = 1 ) AND v_Projects.active = 1 )  ORDER BY v_Projects.ProjectCode", null);

            //** A.2 Carica spese possibili				
            //** A.2.1 Prima verifica se il cliente ha un profilo di spesa	
            // carica spese forzate per persona                
            dtSpeseForzate = Database.GetData("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ForcedExpensesPers.Persons_id = " + ASPcompatility.FormatNumberDB(Persons_id) + " ORDER BY ExpenseType.ExpenseCode", null);
        }
        else
        {
            //** B.1 tutti i progetti attivi con flag di obbligatorietà messaggio		
            dtProgettiForzati = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM v_Projects WHERE active = 1 ORDER BY ProjectCode", null);
            //** B.2 tutte le spese attive 							
            dtSpeseForzate = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode", null);
        }

        //  tutti i progetti, anche inattivi
        dtProgettiTutti = Database.GetData("SELECT DISTINCT Projects_Id, ProjectCode, ProjectCode + ' ' + left(ProjectName,20) AS DescProgetto, TestoObbligatorio, MessaggioDiErrore, BloccoCaricoSpese, ActivityOn, WorkflowType, ProjectType_Id, CodiceCliente, ClientManager_id, AccountManager_id  FROM v_Projects ORDER BY ProjectCode", null);
        dtSpeseTutte = Database.GetData("SELECT ExpenseType_Id, ExpenseCode, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione, TestoObbligatorio, MessaggioDiErrore, TipoBonus_Id, AdditionalCharges, ConversionRate FROM ExpenseType ORDER BY ExpenseCode", null);
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
        UserLevel = Convert.ToInt16(rdr["UserLevel_ID"].ToString());
        ForcedAccount = rdr["ForcedAccount"].ToString() == "True" ? true : false;
        Language = rdr["Lingua"].ToString();
        Calendar_id = Convert.ToInt16(rdr["calendar_id"].ToString());
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
        if (BkgImg != "") { 
            BackgroundColor = "";
            BackgroundImage = BkgImg;
        }

    }

}