using System;
using System.Web.UI;
using System.Threading;
using System.Data;
using System.Web;
using Xceed.Words.NET;
using System.Configuration;

public class PreInvoiceData
{
    public string Number { get; set; }
    public string Date { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string CompanyId { get; set; }
    public string ProjectsIdList { get; set; }
    public string PersonsIdList { get; set; }
    public string CompanyName { get; set; }
    public string DirectorsName { get; set; }
    public string ProjectsNameList { get; set; }
    public string PersonsNameList { get; set; }
    public float TotalDays { get; set; }
    public float TotalRates { get; set; }
    public float TotalExpenses { get; set; }
    public float TotalPreinvoiceAmount { get; set; }
    public string AllDaysQuery { get; set; }
    public string AllExpenseQuery { get; set; }
    public string SubtotalAmountQuery { get; set; }
    public string SubtotalExpensesQuery { get; set; }
    public string Description { get; set; }
}

public partial class Preinvoice_form : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    // per i dati necessari al display ed elaborazioni
    static PreInvoiceData preInv = new PreInvoiceData();
    public PreInvoiceData emptyPreInv = new PreInvoiceData();

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("REPORT", "ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (Request.QueryString["Preinvoice_id"] != null)
        {
            TBDescription.Enabled = false;
        }

        if (!IsPostBack && Request.Form.Count == 0)
        {
            preInv = emptyPreInv;
            if (Request.QueryString["Preinvoice_id"] != null)
                LoadFromDB(preInv, Request.QueryString["Preinvoice_id"]);
            else
                LoadFromSessions(preInv);

            LoadNamesFromId(preInv);
            DisplayPage(preInv);
        }
    }

    public void CreatePreinvoice(PreInvoiceData preInv)
    {
        int loopIndex = 0;
        const int HoursTableIndex = 0;
        const int ExpensesTableIndex = 1;

        // utilizzo pacchetto nuget DOCX - https://github.com/xceedsoftware/DocX
        // https://xceed.com/documentation-center/

        // costruisce il nome del file "template" + "-" + EN/IT + ".docx"
        string WordTemplate = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "TemplatePreinvoice-IT.docx";
        using (var document = DocX.Load(WordTemplate))
        {
            document.ReplaceText("<societa>", preInv.CompanyName);
            document.ReplaceText("<numero>", preInv.Number);
            document.ReplaceText("<data>", preInv.Date);
            document.ReplaceText("<dataDa>", preInv.DataDa);
            document.ReplaceText("<dataA>", preInv.DataA);
            document.ReplaceText("<importoTotaleOre>", preInv.TotalRates.ToString("#,0.00"));
            document.ReplaceText("<importoTotaleSpese>", preInv.TotalExpenses.ToString("#,0.00"));
            document.ReplaceText("<importoTotalePrefattura>", preInv.TotalPreinvoiceAmount.ToString("#,0.00"));

            // Importo 
            var HoursTable = document.Tables[HoursTableIndex];

            DataTable dt = Database.GetData(preInv.SubtotalAmountQuery + " ORDER BY NomeConsulente, Progetto", null);

            loopIndex = 1;
            for (int i = 1; i < dt.Rows.Count; i++) // compia la prima riga per N-1 volte
                HoursTable.InsertRow(HoursTable.Rows[1], loopIndex, true);

            loopIndex = 1;
            foreach (DataRow dr in dt.Rows)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                HoursTable.Rows[loopIndex].ReplaceText("<consulente>", dr[1].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<progetto>", dr[2].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<giorni>", Convert.ToDouble(dr[3]).ToString("#,0.000"));
                HoursTable.Rows[loopIndex].ReplaceText("<FLC>", dr[4].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<Importo>", Convert.ToDouble(dr[5]).ToString("#,0.00"));
                loopIndex++;
            }

            // Spese 
            var ExpensesTable = document.Tables[ExpensesTableIndex];

            dt = Database.GetData(preInv.SubtotalExpensesQuery + " ORDER BY NomeConsulente, Progetto" , null);

            loopIndex = 1;
            for (int i = 1; i < dt.Rows.Count; i++) // compia la prima riga per N-1 volte
                ExpensesTable.InsertRow(ExpensesTable.Rows[1], loopIndex, true);

            loopIndex = 1;
            foreach (DataRow dr in dt.Rows)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                ExpensesTable.Rows[loopIndex].ReplaceText("<consulente>", dr[1].ToString());
                ExpensesTable.Rows[loopIndex].ReplaceText("<progetto>", dr[2].ToString());
                ExpensesTable.Rows[loopIndex].ReplaceText("<tipospesa>", dr[3].ToString());
                ExpensesTable.Rows[loopIndex].ReplaceText("<Importo>", Convert.ToDouble(dr[4]).ToString("#,0.00"));
                loopIndex++;
            }

            // Save this document to disk.
            string UrlWordSaved = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "preinvoice-" + CurrentSession.UserId + ".docx";
            document.SaveAs(UrlWordSaved);
        }
        return;

    }

    protected void CalculateTotalsFromDB(PreInvoiceData preInv)
    {

        // totale importi
        DataRow dr = Database.GetRow("SELECT SUM(Days), SUM(TotalCost) FROM (" + preInv.SubtotalAmountQuery + ") AS TAB", null);

        if (dr != null)
        {
            if (dr[0].ToString() != "")
            {
                preInv.TotalDays = (float)Convert.ToDouble(dr[0]);
                Math.Round(preInv.TotalDays, 2);
                preInv.TotalRates = (float)Convert.ToDouble(dr[1]);
                Math.Round(preInv.TotalRates, 2);
            }
        }

        // totale spese
        dr = Database.GetRow("SELECT SUM(Importo) FROM (" + preInv.SubtotalExpensesQuery + ") AS TAB", null);

        if (dr != null)
        {
            if (dr[0].ToString() != "")
            {
                preInv.TotalExpenses = (float)Convert.ToDouble(dr[0]);
                Math.Round(preInv.TotalExpenses, 2);
            }
        }

        preInv.TotalPreinvoiceAmount = preInv.TotalRates + preInv.TotalExpenses;

        // nome direttori
        preInv.DirectorsName = "";
        DataTable dtb = Database.GetData("SELECT DISTINCT(Director)  FROM (" + preInv.AllDaysQuery + ") AS TAB", null);
        if (dtb != null)
        {
            foreach (DataRow drb in dtb.Rows) {
                preInv.DirectorsName += drb[0].ToString() + ",";
            }
        }

        if (preInv.DirectorsName != "")
            preInv.DirectorsName = preInv.DirectorsName.Substring(0, preInv.DirectorsName.Length - 1);

        return;
    }

    protected void LoadFromDB(PreInvoiceData preInv, string preinvoiceId)
    {

        DataRow dr = Database.GetRow("SELECT Preinvoice_id, Date, DataDa, DataA, Company_id, ProjectsSelection, PersonsSelection, NumberOfDays, TotalAmount, TotalRates, TotalExpenses, Description, DirectorsName FROM Preinvoice " +
                                     "WHERE Preinvoice_id=" + ASPcompatility.FormatStringDb(preinvoiceId), null);

        preInv.Number = dr[0].ToString();
        preInv.Date = ((DateTime)dr[1]).ToString("dd/MM/yyyy");
        preInv.DataDa = ((DateTime)dr[2]).ToString("dd/MM/yyyy");
        preInv.DataA = ((DateTime)dr[3]).ToString("dd/MM/yyyy");
        preInv.CompanyId = dr[4].ToString();
        preInv.ProjectsIdList = dr[5].ToString();
        preInv.PersonsIdList = dr[6].ToString();
        preInv.TotalDays = (float)Convert.ToDouble(dr[7].ToString());
        preInv.TotalPreinvoiceAmount = (float)Convert.ToDouble(dr[8].ToString());
        preInv.TotalRates = (float)Convert.ToDouble(dr[9].ToString());
        preInv.TotalExpenses = (float)Convert.ToDouble(dr[10].ToString());
        preInv.Description = dr[11].ToString();
        preInv.DirectorsName = dr[12].ToString();
        SetQueryCommands(preInv);

    }

    protected void LoadFromSessions(PreInvoiceData preInv)
    {
        preInv.Number = "nr";
        preInv.Date = DateTime.Today.ToString("dd/MM/yyyy");
        preInv.DataDa = (string)Session["PreinvDataDa"];
        preInv.DataA = (string)Session["PreinvDataA"];
        preInv.CompanyId = (string)Session["PreinvSocieta"];
        preInv.ProjectsIdList = (string)Session["PreinvProjectsId"];
        preInv.PersonsIdList = (string)Session["PreinvPersonsId"];
        preInv.Description = "";
        SetQueryCommands(preInv);
        CalculateTotalsFromDB(preInv); // calcola i totali
    }

    protected void SetQueryCommands(PreInvoiceData preInv)
    {
        preInv.SubtotalAmountQuery = "SELECT b.Name as 'Societa', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', Days, t.FLC 'FLC', Days* FLC as 'TotalCost', t.Preinvoice_id " +
                                   "FROM( SELECT SUM(Hours) / 8 as 'Days', company_id, persons_id, projects_id, Preinvoice_id, [MSSql12155].FCT_DeterminaCostRate(persons_id, projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as 'FLC' FROM hours " +
                                   "WHERE date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA) + " group by persons_Id, projects_id, company_id, Preinvoice_id ) AS T " +
                                   "INNER JOIN company as B ON b.Company_id = t.Company_id " +
                                   "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                   "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                   "WHERE t.Company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId);                                  

        if (preInv.ProjectsIdList != "")
            preInv.SubtotalAmountQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

        if (preInv.PersonsIdList != "")
            preInv.SubtotalAmountQuery += " AND T.persons_id IN ( " + preInv.PersonsIdList + " )";

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.SubtotalAmountQuery += " AND T.Preinvoice_id IS NULL";
        else
            preInv.SubtotalAmountQuery += " AND t.Preinvoice_id = " + preInv.Number;

        preInv.AllDaysQuery = "SELECT Preinvoice_id as Prefattura, '" + preInv.Date + "' as DataPrefattura, " + "b.Name as 'Societa', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', E.name as 'Director' ,CONVERT(VARCHAR(10),Date, 103) as Data , Hours as 'Ore', locationdescription  " +
                                     "FROM hours as T " +
                                     "INNER JOIN company as B ON b.Company_id = t.Company_id " +
                                     "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                     "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                     "INNER JOIN persons as E ON E.persons_id = t.ClientManager_id " +
                                     "WHERE t.Company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId) + " AND " +
                                     "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "")
            preInv.AllDaysQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

        if (preInv.PersonsIdList != "")
            preInv.AllDaysQuery += " AND T.persons_id IN ( " + preInv.PersonsIdList + " )";

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.AllDaysQuery += " AND T.Preinvoice_id IS NULL";
        else
            preInv.AllDaysQuery += " AND t.Preinvoice_id = " + preInv.Number;

        preInv.AllExpenseQuery = "SELECT Preinvoice_id as Prefattura, '" + preInv.Date + "' as DataPrefattura, " + " b.Name as 'Societa', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', F.name as 'Director', E.name as 'TipoSpesa' , CONVERT(VARCHAR(10),Date, 103) as Data , AmountInCurrency as Importo " +
                                   "FROM expenses as T " +
                                   "INNER JOIN company as B ON b.Company_id = t.Company_id " +
                                   "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                   "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                   "INNER JOIN ExpenseType as E ON E.ExpenseType_id = t.ExpenseType_id " +
                                   "INNER JOIN persons as F ON F.persons_id = t.ClientManager_id " +
                                   "WHERE t.Company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId) + " AND " +
                                   "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "")
            preInv.AllExpenseQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

        if (preInv.PersonsIdList != "")
            preInv.AllExpenseQuery += " AND T.persons_id IN ( " + preInv.PersonsIdList + " )";

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.AllExpenseQuery += " AND T.Preinvoice_id IS NULL";
        else
            preInv.AllExpenseQuery += " AND T.Preinvoice_id = " + preInv.Number;

        preInv.SubtotalExpensesQuery = "SELECT Societa, NomeConsulente, Progetto, TipoSpesa, SUM(Importo) as 'Importo' FROM (" +
                                       preInv.AllExpenseQuery +
                                       " ) AS TAB GROUP BY Societa, NomeConsulente, Progetto, TipoSpesa"; 
    }

    protected void LoadNamesFromId(PreInvoiceData preInv)
    {
        //DataTable dtb;
        DataRow dr;

        // società
        dr = Database.GetRow("Select Name from Company where company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId), null);
        if (dr != null)
            preInv.CompanyName = (string)dr[0];

    }

    protected void DisplayPage(PreInvoiceData preInv)
    {
        LBPreinvoiceNum.Text = preInv.Number + " del " + preInv.Date;
        LBPeriodo.Text = preInv.DataDa + " a " + preInv.DataA;
        LBCompany.Text = preInv.CompanyName;
        LBDirector.Text = preInv.DirectorsName;
        LBDays.Text = preInv.TotalDays.ToString("#,0.00");
        LBTotalRates.Text = preInv.TotalRates.ToString("#,0.00") + " €";
        LBTotalExpenses.Text = preInv.TotalExpenses.ToString("#,0.00") + " €";
        LBTotalAmount.Text = preInv.TotalPreinvoiceAmount.ToString("#,0.00") + " €";
        TBDescription.Text = preInv.Description;
        TBcompanyId.Text = preInv.CompanyId;
        TBDataA.Text = preInv.DataA;
        TBDataDa.Text = preInv.DataDa;
        TBPreinvoiceNumber.Text = preInv.Number;
    }

    // Bottoni
    protected void Download_Preinvoice(object sender, EventArgs e)
    {
        CalculateTotalsFromDB(preInv); // ri-calcola i totali
        CreatePreinvoice(preInv);
        // crea documento Word
        Response.Redirect("/public/TR-PREINVOICE/preinvoice-" + CurrentSession.UserId + ".docx");
    }

    // Bottoni
    protected void Download_AllRatesQuery(object sender, EventArgs e)
    {
        Utilities.ExportXls(preInv.AllDaysQuery + " ORDER BY NomeConsulente, Data");
    }

    protected void Download_AllExpenseQuery(object sender, EventArgs e)
    {
        Utilities.ExportXls(preInv.AllExpenseQuery  + " ORDER BY NomeConsulente, Data");
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/report/preinvoice/preinvoice-list.aspx");
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {

        int Preinvoice_id = 0;
        string queryToUpdate = "";

        Boolean insertOk = Database.ExecuteSQL("INSERT INTO Preinvoice (company_id, Date, DataDa, DataA, CreatedBy, CreationDate, NumberOfDays, TotalRates, TotalExpenses, TotalAmount, ProjectsSelection, PersonsSelection, Description, DirectorsName ) VALUES ( " +
                             ASPcompatility.FormatStringDb(preInv.CompanyId) + " , " +
                             ASPcompatility.FormatDateDb(preInv.Date) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataDa) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataA) + " , " +
                             ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                             ASPcompatility.FormatDateDb(preInv.Date) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalDays) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalRates) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalExpenses) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalPreinvoiceAmount) + " , " +
                             ASPcompatility.FormatStringDb(preInv.ProjectsIdList) + " , " +
                             ASPcompatility.FormatStringDb(preInv.PersonsIdList) + " , " +
                             ASPcompatility.FormatStringDb(TBDescription.Text) + " , " +
                             ASPcompatility.FormatStringDb(preInv.DirectorsName) + " )"
                , null); ;

        if (insertOk) { 
            Preinvoice_id = Database.GetLastIdInserted("SELECT MAX(Preinvoice_id) from Preinvoice");

            queryToUpdate = "UPDATE hours SET Preinvoice_id = '" + Preinvoice_id.ToString()  + "' " + 
                             "WHERE Company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId) + " AND " +
                             "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

            if (preInv.ProjectsIdList != "")
                queryToUpdate += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

            if (preInv.PersonsIdList != "")
                queryToUpdate += " AND T.persons_id IN ( " + preInv.PersonsIdList + " )";

            Database.ExecuteSQL(queryToUpdate, null); // aggiorna ore

            queryToUpdate = "UPDATE Expenses SET Preinvoice_id = '" + Preinvoice_id.ToString() + "' " +
                             "WHERE Company_id = " + ASPcompatility.FormatStringDb(preInv.CompanyId) + " AND " +
                             "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

            if (preInv.ProjectsIdList != "")
                queryToUpdate += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

            if (preInv.PersonsIdList != "")
                queryToUpdate += " AND T.persons_id IN ( " + preInv.PersonsIdList + " )";

            Database.ExecuteSQL(queryToUpdate, null); // aggiorna spese

        }

        Response.Redirect("/timereport/report/preinvoice/preinvoice-list.aspx");
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}