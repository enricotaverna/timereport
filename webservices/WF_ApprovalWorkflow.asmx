<%@ WebService Language="C#" Class="WSWF_ApprovalWorkflow" %>

using System;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Web.Script.Serialization;

// definisce la struttura  da ritornare con GetApprovalRecord
public class ApprovalRecord
{
    public int hours_id { get; set; }
    public string CreationDate { get; set; }
    public string Date { get; set; }
    public string PersonName { get; set; }
    public string ProjectCode { get; set; }
    public string ProjectName { get; set; }
    public float hours { get; set; }
    public string Comment { get; set; }
    public string ApprovalText1 { get; set; }
    public string ApprovalStatus { get; set; }
    public string ApprovalDescription { get; set; }
    public string ApprovalDate { get; set; }
}

// Usato per creazione richiesta
public class ApprovalRequest
{
    public int approvalRequest_id { get; set; }
    public string creationDate { get; set; }
    public string changeDate { get; set; }
    public string requestType { get; set; }
    public string fromDate { get; set; }
    public string toDate { get; set; }
    public int persons_id { get; set; }
    public int projects_id { get; set; }
    public string personName { get; set; }
    public string projectCode { get; set; }
    public string projectName { get; set; }
    public float hours { get; set; }
    public string comment { get; set; }
    public string notifyList { get; set; }
    public int approvedBy { get; set; }
    public string managerName { get; set; }
    public string approvalText1 { get; set; }
    public string approvalStatus { get; set; }
    public string approvalStatusDescription { get; set; }
    public string workflowType { get; set; }
}

public class KPISet
{
    public string KPIDescription { get; set; }
    public string KPIValue { get; set; }
    public string CSSClass { get; set; }
}

// Classe Card per Dashboard
public class Card
{
    public string cardName;
    public DateTime lastUpdateTime;
    public int updateRateSec;
    public List<KPISet> KPIList;
    public int persons_id;
    public string cutoffDate;
    private string WF_ApprovalRequest;

    // Constructor
    public Card(string name, int rate)
    {
        cardName = name;
        updateRateSec = rate != 0 ? rate : 30; // default 30 secs
        lastUpdateTime = new DateTime(2001, 01, 01);
        KPIList = new List<KPISet>(); // lista KPI di ritorno
    }

    // UpdateCardKPI()
    // Aggiorna automaticamente i KPI controllando l'intervallo di chiamata
    public void UpdateCardKPI()
    {

        object result;
        string sql;
        string SQLfilterApprovalRequest = "";
        DateTime DateFrom = (DateTime)DateTime.Today; // sottrae i giorni del parametro
        DateTime DateTo = (DateTime)DateTime.Today.AddDays(30); // sottrae i giorni del parametro
        string MonthStartDate = ASPcompatility.FormatDateDb("1/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString());
        KPISet kpi;

        if (DateTime.Now < lastUpdateTime.AddSeconds(updateRateSec)) // non necessario lettura DB
            return;

        lastUpdateTime = DateTime.Now;
        KPIList.Clear();

        switch (cardName)
        {

            case "RichiesteAperte":

                // ** inizializza filtro in base alla autorizzazione        
                if (Auth.ReturnPermission("WORKFLOW", "MANAGER"))
                    SQLfilterApprovalRequest = " and ApprovedBy = " + ASPcompatility.FormatNumberDB(persons_id);
                else if (Auth.ReturnPermission("WORKFLOW", "TOTALE"))
                    SQLfilterApprovalRequest = ""; // tutti
                else // dipendenti
                    SQLfilterApprovalRequest = " and persons_id = " + ASPcompatility.FormatNumberDB(persons_id);

                result = Database.ExecuteScalar("SELECT COUNT(*) FROM WF_ApprovalRequest WHERE ApprovalStatus=" + ASPcompatility.FormatStringDb(MyConstants.WF_REQUEST) + SQLfilterApprovalRequest, null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0" : result.ToString();
                KPIList.Add(kpi);

                break;

            case "GiorniTraining":

                result = Database.ExecuteScalar("SELECT COUNT(*) FROM Hours as a" +
                                            " INNER JOIN Projects as b ON b.projects_id = a.projects_id " +
                                            " INNER JOIN persons as c ON c.persons_id = a.persons_id" +
                                            " WHERE a.date >=" + ASPcompatility.FormatDateDb(DateFrom.ToString("dd/MM/yyyy")) +
                                            " AND a.date <= " + ASPcompatility.FormatDateDb(DateTo.ToString("dd/MM/yyyy")) +
                                            " AND b.ProjectType_Id = '" + ConfigurationManager.AppSettings["CODICI_TRAINING"] + "'" +
                                            " AND c.manager_id = " + ASPcompatility.FormatNumberDB(persons_id),
                                            null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0" : result.ToString();
                kpi.CSSClass = "text-success";
                KPIList.Add(kpi);

                break;

            case "GiorniAssenza":

                result = Database.ExecuteScalar("SELECT COUNT(*) FROM Hours as a" +
                                                " INNER JOIN Projects as b ON b.projects_id = a.projects_id " +
                                                " INNER JOIN persons as c ON c.persons_id = a.persons_id" +
                                                " WHERE a.date >=" + ASPcompatility.FormatDateDb(DateFrom.ToString("dd/MM/yyyy")) +
                                                " AND a.date <= " + ASPcompatility.FormatDateDb(DateTo.ToString("dd/MM/yyyy")) +
                                                " AND b.ProjectType_Id = '" + ConfigurationManager.AppSettings["CODICI_ASSENZE"] + "'" +
                                                " AND c.manager_id = " + ASPcompatility.FormatNumberDB(persons_id),
                                                null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0" : result.ToString();
                kpi.CSSClass = "text-success";
                KPIList.Add(kpi);

                break;

            case "TrainingDaValutare":

                DateTime DateToCheck = (DateTime)DateTime.Today.AddDays(MyConstants.DAYS_TO_EVALUATE * -1); // sottrae i giorni del parametro

                result = Database.ExecuteScalar("SELECT COUNT(*) FROM HR_CoursePlan WHERE Persons_id = " + ASPcompatility.FormatNumberDB(persons_id) +
                                           " AND CourseDate > " + ASPcompatility.FormatDateDb(DateToCheck.ToString("dd/MM/yyyy")) +
                                           " AND Score = 0 " +
                                           " AND CourseStatus_id = " + ASPcompatility.FormatNumberDB(MyConstants.TRAINIG_ATTENDED), null);
                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0" : result.ToString();
                kpi.CSSClass = kpi.KPIValue == "0" ? "text-success" : "text-warning"; ;
                KPIList.Add(kpi);

                break;

            case "ContrattiSubco":

                DateTime SubcoDateToCheck = (DateTime)DateTime.Today.AddDays(MyConstants.SUBCOCONTRACT_DAYS_TO_EVALUATE * -1); // sottrae i giorni del parametro
                String sToday = ASPcompatility.FormatDateDb(DateTime.Today.ToString("dd/MM/yyyy"));
                String sQuery;

                sQuery = "SELECT COUNT(*) FROM ( SELECT B.name FROM hours AS A INNER JOIN persons as B ON b.persons_id = a.persons_id ";

                // se manager aggiunge filtro
                if ( !Auth.ReturnPermission("WORKFLOW", "TOTALE") )
                    sQuery = sQuery + "WHERE A.ClientManager_id = " + ASPcompatility.FormatNumberDB(persons_id) + " AND ";
                else
                    sQuery = sQuery + "WHERE ";

                sQuery = sQuery + "B.userLevel_id = 1 AND A.DATE > " + ASPcompatility.FormatDateDb(SubcoDateToCheck.ToString("dd/MM/yyyy")) + " AND " +
                                                "( NOT( Contratto_da <= " + sToday + " AND Contratto_a >= " + sToday + ") OR Contratto_da IS NULL ) " +
                                                "GROUP BY B.NAME ) AS R";

                result = Database.ExecuteScalar(sQuery, null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == null) ? "0" : result.ToString();
                kpi.CSSClass = kpi.KPIValue == "0" ? "text-success" : "text-warning"; ;
                KPIList.Add(kpi);

                break;

            case "CVdaConfermare":

                CurriculumList list = new CurriculumList();
                list.BuildListFromRagicAPI();

                int count = 0; // numero CV da rivedere a cura del manager
                foreach (Dictionary<string, string> row in list.Data)
                {
                    string CVStatus = "";
                    string manager_id = "";

                    if (row.TryGetValue("CVStatus", out CVStatus) && row.TryGetValue("Manager_Id", out manager_id))
                    {
                        if (CVStatus.Substring(0, 2) == "03" && manager_id == persons_id.ToString()) // manager review
                            count++;
                    }
                }

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = count.ToString(); ;
                kpi.CSSClass = kpi.KPIValue == "0" ? "text-success" : "text-warning";
                KPIList.Add(kpi);
                break;

            case "ListaLocation":
                DataTable data = Database.GetData("SELECT TOP(3) LocationDescription, CAST( SUM(Hours) AS INT) as TotalHours FROM Hours " +
                                             " WHERE Date >= " + MonthStartDate +
                                             " AND Persons_id = " + ASPcompatility.FormatNumberDB(persons_id) +
                                             " AND ( LocationDescription <> '' AND LocationDescription IS NOT NULL )  " +
                                             " GROUP BY LocationDescription " +
                                             " ORDER BY TotalHours DESC", null);
                // popola la lista di ritorno
                foreach (DataRow dr in data.Rows)
                {
                    kpi = new KPISet();
                    kpi.KPIDescription = dr["LocationDescription"].ToString();
                    kpi.KPIValue = dr["TotalHours"].ToString();
                    KPIList.Add(kpi);
                }
                //KPIList.Add(new KPISet { KPIDescription = dr["LocationDescription"].ToString(), KPIValue = dr["TotalHours"].ToString() });

                break;

            case "OreNelMese":

                CommonFunction.CalcolaPercOutput calc;
                calc = CommonFunction.CalcolaPercOre(persons_id, DateTime.Now.Month, DateTime.Now.Year);

                kpi = new KPISet();
                kpi.KPIValue = calc.oreMancanti + "";
                kpi.CSSClass = kpi.KPIValue == "0" ? "text-primary" : "text-warning";
                KPIList.Add(kpi);

                kpi = new KPISet();
                kpi.KPIValue = calc.dOreCaricate.ToString() + " su " + calc.dOreLavorative.ToString();
                KPIList.Add(kpi);

                kpi = new KPISet();
                kpi.KPIValue = calc.sPerc + "%";
                KPIList.Add(kpi);

                break;

            case "SpeseNelMese":
                string sToDate = ASPcompatility.FormatDateDb(DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month).ToString() + "/" + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Year.ToString());

                // spese totali
                sql = "SELECT Round(Sum(Expenses.Amount*ExpenseType.ConversionRate),2) AS TotalAmount " +
                "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " +
                "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " +
                "WHERE Expenses.Date >=" + MonthStartDate + " And Expenses.Date <=" + sToDate + " AND " +
                "Persons.Persons_id = " + ASPcompatility.FormatNumberDB(persons_id);

                result = Database.ExecuteScalar(sql, null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0€" : result.ToString() + "€";
                KPIList.Add(kpi);

                // chilometri     
                sql = "SELECT Round(Sum(Expenses.Amount),2) AS TotalAmount " +
                "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " +
                "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " +
                "WHERE Expenses.Date >=" + MonthStartDate + " And Expenses.Date <=" + sToDate + " AND " +
                "ExpenseType.UnitOfMeasure = 'km' AND " +
                "Persons.Persons_id = " + ASPcompatility.FormatNumberDB(persons_id);

                result = Database.ExecuteScalar(sql, null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "0km" : Convert.ToUInt16(result).ToString() + "km";
                KPIList.Add(kpi);

                // spese da rimborsare
                sql = "SELECT Round(Sum(Expenses.Amount*ExpenseType.ConversionRate),2) AS TotalAmount " +
                "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " +
                "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " +
                "WHERE Expenses.Date >=" + MonthStartDate + " And Expenses.Date <=" + sToDate + " AND " +
                "Persons.Persons_id = " + ASPcompatility.FormatNumberDB(persons_id) + " AND Expenses.CreditCardPayed = 0 AND Expenses.CompanyPayed = 0 ";

                result = Database.ExecuteScalar(sql, null);

                kpi = new KPISet();
                kpi.KPIDescription = "";
                kpi.KPIValue = (result == DBNull.Value) ? "-" : "rimborso: " + result.ToString() + "€";
                KPIList.Add(kpi);

                break;

        }
    }
}

//
// *** INIZIO WEB SERVICE
//
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]

public class WSWF_ApprovalWorkflow : System.Web.Services.WebService
{

    Card RichiesteAperte;
    Card GiorniTraining;
    Card GiorniAssenza;
    Card TrainingDaValutare;
    Card OreNelMese;
    Card SpeseNelMese;
    Card CVdaConfermare;
    Card ListaLocation;
    Card ContrattiSubco;

    List<Card> listaCard = new List<Card>(); // lista oggetti

    public WSWF_ApprovalWorkflow()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 

        RichiesteAperte = Session["RichiesteAperte"] == null ? new Card("RichiesteAperte", 10) : (Card)Session["RichiesteAperte"];
        GiorniTraining = Session["GiorniTraining"] == null ? new Card("GiorniTraining", 10) : (Card)Session["GiorniTraining"];
        TrainingDaValutare = Session["TrainingDaValutare"] == null ? new Card("TrainingDaValutare", 10) : (Card)Session["TrainingDaValutare"];
        OreNelMese = Session["OreNelMese"] == null ? new Card("OreNelMese", 10) : (Card)Session["OreNelMese"];
        GiorniAssenza = Session["GiorniAssenza"] == null ? new Card("GiorniAssenza", 10) : (Card)Session["GiorniAssenza"];
        SpeseNelMese = Session["SpeseNelMese"] == null ? new Card("SpeseNelMese", 10) : (Card)Session["SpeseNelMese"];
        CVdaConfermare = Session["CVdaConfermare"] == null ? new Card("CVdaConfermare", 60) : (Card)Session["CVdaConfermare"]; // aggiornamento 1 minuti
        ListaLocation = Session["ListaLocation"] == null ? new Card("ListaLocation", 10) : (Card)Session["ListaLocation"];
        ContrattiSubco = Session["ContrattiSubco"] == null ? new Card("ContrattiSubco", 10) : (Card)Session["ContrattiSubco"];

        // carica lista oggetti
        listaCard.Add(RichiesteAperte);
        listaCard.Add(GiorniTraining);
        listaCard.Add(TrainingDaValutare);
        listaCard.Add(OreNelMese);
        listaCard.Add(GiorniAssenza);
        listaCard.Add(SpeseNelMese);
        listaCard.Add(CVdaConfermare);
        listaCard.Add(ListaLocation);
        listaCard.Add(ContrattiSubco);
    }

    // UpdateCardKPI()
    // Richiamato dalla pagina ASPX, aggiorna i KPI delle dashboard card 
    // Le card sonon create nel costruttore
    //
    [WebMethod(EnableSession = true)]
    public string UpdateCardKPI(int iPersons_id, string cutoffDate)
    {
        string retJson = "";
        JavaScriptSerializer serializer = new JavaScriptSerializer();

        foreach (Card i in listaCard)
        {
            i.persons_id = iPersons_id;
            i.cutoffDate = cutoffDate;
            i.UpdateCardKPI();
            Session[i.cardName] = i; // memorizza in cache lo stato aggiornato dell'oggetto
        }

        // trasforma la lista in stringa JSON
        retJson = serializer.Serialize(listaCard);

        return retJson;
    }

    [WebMethod(EnableSession = true)]
    public string GetApprovalListTable(string persons_id)  // se richiamato con id manager filtra le richieste
    {

        DataTable dt = new DataTable();
        DateTime DateToCheck = (DateTime)DateTime.Today.AddDays(-90);    // seleziona al max indietro di 3 mesi

        String query = "SELECT A.ApprovalRequest_id, CONVERT(VARCHAR(10),A.CreationDate, 103) as CreationDate, CONVERT(VARCHAR(10),A.FromDate, 103) as FromDate, CONVERT(VARCHAR(10),A.ToDate, 103) as ToDate, A.Hours, A.ApprovalStatus, A.Comment, B.Name as PersonName, C.ProjectCode, C.Name as ProjectName, D.Name as ManagerName " +
                        "FROM WF_ApprovalRequest as A" +
                        " JOIN Persons as B ON B.Persons_id = A.Persons_id " +
                        " JOIN Projects as C ON C.Projects_id = A.Projects_id " +
                        " JOIN Persons as D ON D.Persons_id = A.ApprovedBy " +
                        " WHERE ApprovalStatus IS NOT NULL AND A.FromDate >= " + ASPcompatility.FormatDateDb(DateToCheck.ToString("dd/MM/yyyy"));

        if (!Auth.ReturnPermission("WORKFLOW", "TOTALE")) // se non ha autorizzazione totale
            query = query + " AND A.ApprovedBy =" + ASPcompatility.FormatStringDb(persons_id);

        query = query + " ORDER BY A.CreationDate ASC, PersonName";
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

    // GetContrattiSubco(bool soloContrattiScaduti)
    [WebMethod(EnableSession = true)]
    public string GetContrattiSubco(bool soloSenzaContratto, string persons_id)
    {

        DataTable dt = new DataTable();

        DateTime SubcoDateToCheck = (DateTime)DateTime.Today.AddDays(MyConstants.SUBCOCONTRACT_DAYS_TO_EVALUATE * -1); // sottrae i giorni del parametro
        String sToday = ASPcompatility.FormatDateDb(DateTime.Today.ToString("dd/MM/yyyy"));

        // recupera oggetto sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];

        String query = "SELECT B.name AS SubcoName, D.Name as CompanyName, C.name AS ManagerName, B.Contratto_da, B.Contratto_a, SUM(A.hours/8) as Days, IIF( NOT( B.Contratto_da <= '1-7-2022' AND B.Contratto_a >= '1-7-2022') OR B.Contratto_da IS NULL , 'false' , 'true' ) AS ContractStatus FROM hours AS A " +
                "INNER JOIN persons as B ON B.persons_id = A.persons_id " +
                "LEFT JOIN persons as C ON C.persons_id = A.ClientManager_id " +
                "LEFT JOIN Company as D ON D.Company_id = A.Company_id ";

        // se manager aggiunge filtro
        if (CurrentSession.UserLevel != MyConstants.AUTH_ADMIN)
            query = query + "WHERE A.clientManager_id = " + ASPcompatility.FormatStringDb(persons_id) + " AND ";
        else
            query = query + "WHERE ";

        query = query + "B.userLevel_id = 1 AND A.DATE > " + ASPcompatility.FormatDateDb(SubcoDateToCheck.ToString("dd/MM/yyyy")) + " AND " +
        "( NOT( B.Contratto_da <= " + sToday + " AND B.Contratto_a >= " + sToday + ") OR B.Contratto_da IS NULL ) " +
        "GROUP BY B.NAME, C.name, B.Contratto_da,  B.Contratto_a, D.Name";

        // esegue select e costruisce la stringa JSON
        return BuildJSONReturn(query);

    }

    // GetHouraListTable(string persons_id, string tipoOre, int giorniInAvanti)
    // persons_id -> estrae tutte le ore delle persone legate al manager
    // tipoOre -> Training o Assenze
    //
    [WebMethod(EnableSession = true)]
    public string GetHoursListTable(string persons_id, string tipoOre, int giorniInAvanti)
    {

        DataTable dt = new DataTable();
        DateTime DateFrom = (DateTime)DateTime.Today;
        DateTime DateTo = (DateTime)DateTime.Today.AddDays(giorniInAvanti);

        String query = "SELECT a.persons_id, d.name as ManagerName, c.name as PersonName, CONVERT(VARCHAR(10),a.date, 103) as Date, a.Hours as Hours, b.projectcode as Codice, b.name as Descrizione FROM Hours as a" +
                                                " INNER JOIN Projects as b ON b.projects_id = a.projects_id " +
                                                " INNER JOIN persons as c ON c.persons_id = a.persons_id" +
                                                " INNER JOIN persons as d ON d.persons_id = c.manager_id" +
                                                " WHERE a.date >=" + ASPcompatility.FormatDateDb(DateFrom.ToString("dd/MM/yyyy")) +
                                                " AND a.date <= " + ASPcompatility.FormatDateDb(DateTo.ToString("dd/MM/yyyy")) +
                                                " AND b.ProjectType_Id = " + ASPcompatility.FormatStringDb(tipoOre) +
                                                " AND c.manager_id = " + ASPcompatility.FormatStringDb(persons_id);


        query = query + " ORDER BY a.date ASC, PersonName";
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
    public bool UpdateApprovalRecord(int ApprovalRequest_id, string UpdateMode, string ApprovalText1)
    {

        string sSQL = "";
        bool bResult = false;
        string approvalStatusDescription = "";
        string subject = "";
        List<TipoParametri> param = new List<TipoParametri>();
        DataRow dr = null;

        // se DELE -> cancella RICHIESTE e ORE collegate      
        if (UpdateMode == MyConstants.WF_DELETED)
        {
            // legge i dati per popolare la mail
            dr = Database.GetRow("SELECT *, b.Name as personName, B.mail as PersonMail, D.Name AS ManagerName, E.Name AS ProjectName, E.ProjectCode, E.WorkflowType FROM WF_ApprovalRequest AS a" +
                                            " JOIN Persons AS B ON b.persons_id = a.persons_id " +
                                            " JOIN Persons AS D ON D.persons_id = a.ApprovedBy" +
                                            " JOIN Projects AS E ON E.projects_id = A.projects_id " +
                                            " WHERE ApprovalRequest_id = " + ApprovalRequest_id, null);

            // cancella richiesta
            sSQL = "DELETE FROM Hours WHERE ApprovalRequest_id=" + ASPcompatility.FormatNumberDB(ApprovalRequest_id);
            bResult = Database.ExecuteSQL(sSQL, null);

            sSQL = "DELETE FROM WF_ApprovalRequest " +
                   " WHERE ApprovalRequest_id = " + ASPcompatility.FormatNumberDB(ApprovalRequest_id);
            bResult = Database.ExecuteSQL(sSQL, null);

            approvalStatusDescription = "Deleted";
            subject = "Richiesta cancellata";
        }

        // se APPR -> Aggiorno RICHIESTE e ORE collegate      
        if (UpdateMode == MyConstants.WF_APPROVED)
        {

            // aggiorna stato richiesta
            sSQL = "UPDATE WF_ApprovalRequest SET " +
                       "ApprovalText1 = " + ASPcompatility.FormatStringDb(ApprovalText1) + " , " +
                       "ApprovalStatus = " + ASPcompatility.FormatStringDb(UpdateMode) + " , " +
                       "ChangeDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy")) +
                       " WHERE ApprovalRequest_id = " + ASPcompatility.FormatNumberDB(ApprovalRequest_id);

            bResult = Database.ExecuteSQL(sSQL, null);

            sSQL = "UPDATE Hours SET " +
                    "ApprovalStatus = " + ASPcompatility.FormatStringDb("APPR") +
                   " WHERE ApprovalRequest_id = " + ASPcompatility.FormatNumberDB(ApprovalRequest_id);
            bResult = Database.ExecuteSQL(sSQL, null);

            // recupera descrizione dello stato
            DataRow dr1 = Database.GetRow("SELECT description FROM WF_ApprovalStatus " +
                                " WHERE ApprovalStatus = " + ASPcompatility.FormatStringDb(UpdateMode), null);

            approvalStatusDescription = dr1["description"].ToString();
            subject = "Richiesta Approvata";

        }

        // se REJE -> Aggiorno RICHIESTE e cancello ORE collegate  
        if (UpdateMode == MyConstants.WF_REJECTED)
        {

            // aggiorna stato richiesta
            sSQL = "UPDATE WF_ApprovalRequest SET " +
                       "ApprovalText1 = " + ASPcompatility.FormatStringDb(ApprovalText1) + " , " +
                       "ApprovalStatus = " + ASPcompatility.FormatStringDb(UpdateMode) + " , " +
                       "ChangeDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy")) +
                       " WHERE ApprovalRequest_id = " + ASPcompatility.FormatNumberDB(ApprovalRequest_id);

            bResult = Database.ExecuteSQL(sSQL, null);

            sSQL = "DELETE FROM Hours " +
                   " WHERE ApprovalRequest_id = " + ASPcompatility.FormatNumberDB(ApprovalRequest_id);
            bResult = Database.ExecuteSQL(sSQL, null);

            approvalStatusDescription = "Deleted";
            subject = "Richiesta annullata";

        }

        // legge i dati per popolare la mail (se è in cancellazione gli ha già letti prima)
        if (UpdateMode != MyConstants.WF_DELETED)
            dr = Database.GetRow("SELECT *, b.Name as personName, B.mail as PersonMail, D.Name AS ManagerName, E.Name AS ProjectName, E.ProjectCode, E.WorkflowType FROM WF_ApprovalRequest AS a" +
                                   " JOIN Persons AS B ON b.persons_id = a.persons_id " +
                                   " JOIN Persons AS D ON D.persons_id = a.ApprovedBy" +
                                   " JOIN Projects AS E ON E.projects_id = A.projects_id " +
                                   " WHERE ApprovalRequest_id = " + ApprovalRequest_id, null);

        // **
        // ** Invia la mail
        // **
        if (bResult)
        {

            string sToDate = dr["ToDate"].ToString().Length == 0 ? "" : dr["ToDate"].ToString().Substring(0, 10);

            param.Add(new TipoParametri("creationDate", dr["CreationDate"].ToString().Substring(0, 10)));
            param.Add(new TipoParametri("personName", dr["PersonName"].ToString()));
            param.Add(new TipoParametri("subject", subject));
            param.Add(new TipoParametri("approvalStatusDescription", approvalStatusDescription));
            param.Add(new TipoParametri("manager", dr["ManagerName"].ToString()));
            param.Add(new TipoParametri("mailLista", dr["ApprovalNotifyList"].ToString().Replace(",", ",<br>"))); // aggiunge new line per formattazione

            // formatta il periodo
            string periodo = dr["RequestType"].ToString() == "RG" ? "da " + dr["FromDate"].ToString().Substring(0, 10) + " a " + dr["ToDate"].ToString().Substring(0, 10) : dr["FromDate"].ToString().Substring(0, 10);
            param.Add(new TipoParametri("periodo", periodo));

            param.Add(new TipoParametri("ore", dr["Hours"].ToString()));
            param.Add(new TipoParametri("causale", dr["ProjectName"].ToString()));
            param.Add(new TipoParametri("comment", dr["comment"].ToString()));
            param.Add(new TipoParametri("ApprovalText1", dr["ApprovalText1"].ToString()));
            param.Add(new TipoParametri("approvalRequest_id", ApprovalRequest_id.ToString()));
            param.Add(new TipoParametri("approvalText1", dr["ApprovalText1"].ToString()));


            bResult = CommonFunction.WF_SendMail(dr["PersonMail"].ToString(), dr["ApprovalNotifyList"].ToString(), dr["ApprovalStatus"].ToString(), dr["WorkflowType"].ToString(), param);
        }

        return bResult;
    }

    [WebMethod(EnableSession = true)]
    public bool CreateApprovalRequest(string approvalRequest)
    {

        int newIdentity = 0;
        int iNumWorkingDays = 0;
        string sSQL = "";
        JavaScriptSerializer js = new JavaScriptSerializer();
        ApprovalRequest appr = js.Deserialize<ApprovalRequest>(approvalRequest);

        // recupera oggetto sessione
        TRSession CurrentSession = (TRSession)Session["CurrentSession"];
        var result = Utilities.GetManagerAndAccountId(appr.projects_id);

        // ** 1 ** Crea la richiesta
        sSQL = "INSERT INTO WF_ApprovalRequest (Persons_id, Projects_id , RequestType, FromDate, ToDate, Hours, Comment, ApprovalStatus, ApprovedBy, ApprovalNotifyList, CreationDate, ClientManager_id, AccountManager_id, Company_id )" +
              "VALUES (" +
              ASPcompatility.FormatNumberDB(appr.persons_id) + "," +
              ASPcompatility.FormatNumberDB(appr.projects_id) + "," +
              ASPcompatility.FormatStringDb(appr.requestType) + "," +
              ASPcompatility.FormatDateDb(appr.fromDate) + "," +
              ASPcompatility.FormatDateDb(appr.toDate) + "," +
              ASPcompatility.FormatNumberDB(appr.hours) + "," +
              ASPcompatility.FormatStringDb(appr.comment) + "," +
              ASPcompatility.FormatStringDb(appr.approvalStatus) + "," +
              ASPcompatility.FormatNumberDB(appr.approvedBy) + "," +
              ASPcompatility.FormatStringDb(appr.notifyList) + "," +
              ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy")) +
              ASPcompatility.FormatNumberDB(result.Item1) + "," +
              ASPcompatility.FormatNumberDB(result.Item2) + "," +
              ASPcompatility.FormatNumberDB(CurrentSession.Company_id) +
              ")";

        bool bResult = Database.ExecuteSQL(sSQL, null);

        // ** 2 ** aggiorna stato delle Hours legate 
        newIdentity = Database.GetLastIdInserted("SELECT MAX(ApprovalRequest_id) from WF_ApprovalRequest");

        // ** Crea i record sulla Hours
        double nDays = 0;
        if (appr.toDate != "")
            nDays = (Convert.ToDateTime(appr.toDate) - Convert.ToDateTime(appr.fromDate)).TotalDays;
        else
            nDays = 1;

        if (appr.requestType == "RG") // più date, default le ore ad ore contratto
            appr.hours = CurrentSession.ContractHours;

        DateTime currDate = Convert.ToDateTime(appr.fromDate);
        for (int i = 0; i <= nDays; i++)
        {
            if ((currDate.DayOfWeek >= DayOfWeek.Monday) && (currDate.DayOfWeek <= DayOfWeek.Friday))
            {
                sSQL = "INSERT INTO Hours (Persons_id, Projects_id , Date, Hours, HourType_Id, ApprovalStatus, ApprovalRequest_id, CreatedBy, CreationDate)" +
                "VALUES (" +
                ASPcompatility.FormatNumberDB(appr.persons_id) + "," +
                ASPcompatility.FormatNumberDB(appr.projects_id) + "," +
                ASPcompatility.FormatDateDb(currDate.ToString("dd/MM/yyyy")) + "," +
                ASPcompatility.FormatNumberDB(appr.hours) + "," +
                "'1', " +
                ASPcompatility.FormatStringDb(appr.approvalStatus) + "," +
                ASPcompatility.FormatNumberDB(newIdentity) + "," +
                ASPcompatility.FormatNumberDB(appr.persons_id) + "," +
                ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy")) +
                ")";

                bResult = Database.ExecuteSQL(sSQL, null);

                iNumWorkingDays++;
            }
            currDate = currDate.AddDays(1);
        }

        // calcola il numero di ore = giorni lavorativi * ore contratto
        if (appr.hours == 0)
            appr.hours = CurrentSession.ContractHours * iNumWorkingDays;

        // ** 3 ** Se tutto ok invia la mail
        if (bResult)
        {
            List<TipoParametri> param = new List<TipoParametri>();

            param.Add(new TipoParametri("creationDate", currDate.ToString("dd/MM/yyyy")));
            param.Add(new TipoParametri("personName", appr.personName));
            param.Add(new TipoParametri("subject", appr.approvalStatus == "REQU" ? "Richiesta Approvazione" : "Notifica"));
            param.Add(new TipoParametri("approvalStatusDescription", appr.approvalStatusDescription));
            param.Add(new TipoParametri("manager", appr.managerName));
            param.Add(new TipoParametri("mailLista", appr.notifyList.Replace(",", ",<br>")));

            // formatta il periodo
            string periodo = appr.requestType == "RG" ? "da " + appr.fromDate.Substring(0, 10) + " a " + appr.toDate.Substring(0, 10) : appr.fromDate.Substring(0, 10);
            param.Add(new TipoParametri("periodo", periodo));

            param.Add(new TipoParametri("ore", appr.hours.ToString()));
            param.Add(new TipoParametri("causale", appr.projectName));
            param.Add(new TipoParametri("comment", appr.comment));
            param.Add(new TipoParametri("approvalText1", ""));
            param.Add(new TipoParametri("approvalRequest_id", newIdentity.ToString()));

            bResult = CommonFunction.WF_SendMail(Session["ApprovalManagerMail"].ToString(), appr.notifyList, appr.approvalStatus, appr.workflowType, param);
        }

        return bResult;

    }

    [WebMethod(EnableSession = true)]
    public ApprovalRequest GetApprovalRequest(string ApprovalRequest_id)
    {

        ApprovalRequest rc = new ApprovalRequest();

        DataTable dt = Database.GetData("SELECT *, b.Name as personName, c.Description as approvalStatusDescription, D.Name AS ManagerName, E.Name AS ProjectName, E.ProjectCode FROM WF_ApprovalRequest AS a" +
                                        " JOIN Persons AS B ON b.persons_id = a.persons_id " +
                                        " JOIN WF_ApprovalStatus AS c ON c.ApprovalStatus = a.ApprovalStatus " +
                                        " JOIN Persons AS D ON D.persons_id = a.ApprovedBy" +
                                        " JOIN Projects AS E ON E.projects_id = A.projects_id " +
                                        " WHERE ApprovalRequest_id = " + ApprovalRequest_id, null);

        // valorizza flag che dice se testo commento è obbligatorio
        if (dt == null || dt.Rows.Count == 0)
        {
            rc.approvalRequest_id = 0;
        }
        else
        {
            rc.approvalRequest_id = Convert.ToInt32(dt.Rows[0]["approvalRequest_id"].ToString());
            rc.persons_id = Convert.ToInt32(dt.Rows[0]["Persons_id"].ToString());
            rc.projects_id = Convert.ToInt32(dt.Rows[0]["Projects_id"].ToString());
            rc.creationDate = dt.Rows[0]["CreationDate"].ToString().Substring(0, 10);
            rc.personName = dt.Rows[0]["PersonName"].ToString();
            rc.projectName = dt.Rows[0]["ProjectName"].ToString();
            rc.projectCode = dt.Rows[0]["ProjectCode"].ToString();

            rc.changeDate = dt.Rows[0]["ChangeDate"].ToString();
            rc.changeDate = rc.changeDate.Length == 0 ? "" : rc.changeDate.Substring(0, 10);

            rc.fromDate = dt.Rows[0]["FromDate"].ToString();
            rc.fromDate = rc.fromDate.Length == 0 ? "" : rc.fromDate.Substring(0, 10);

            rc.toDate = dt.Rows[0]["ToDate"].ToString();
            rc.toDate = rc.toDate.Length == 0 ? "" : rc.toDate.Substring(0, 10);

            rc.hours = (float)Convert.ToDouble(dt.Rows[0]["Hours"].ToString());
            rc.comment = dt.Rows[0]["Comment"].ToString();
            rc.approvedBy = Convert.ToInt32(dt.Rows[0]["ApprovedBy"].ToString());
            rc.approvalStatus = dt.Rows[0]["ApprovalStatus"].ToString();
            rc.approvalText1 = dt.Rows[0]["ApprovalText1"].ToString();
            rc.notifyList = dt.Rows[0]["ApprovalNotifyList"].ToString();
            rc.managerName = dt.Rows[0]["ManagerName"].ToString(); ;
            rc.approvalStatusDescription = dt.Rows[0]["approvalStatusDescription"].ToString().Trim();

        }

        return rc;

    }

    // Utility per formattare ritorno della SELECT sui dati
    private string BuildJSONReturn(string query)
    {

        DataTable dt = new DataTable();
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
    