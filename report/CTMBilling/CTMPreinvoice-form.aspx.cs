using System;
using System.Threading;
using System.Data;
using System.Web;
using Xceed.Words.NET;
using System.Configuration;

public class PreInvoiceData
{
    public string Id { get; set; }
    public string Number { get; set; }
    public string Date { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string CodiceCliente { get; set; }
    public string ProjectsIdList { get; set; }
//    public string PersonsIdList { get; set; }
    public string NomeCliente { get; set; }
    public string DirectorsName { get; set; }
    public string ProjectsNameList { get; set; }
    public string PersonsNameList { get; set; }
    public float TotalDays { get; set; }
    public float TotalDaysCost { get; set; }
    public float TotalRates { get; set; }
    public float TotalRatesCost { get; set; }
    public float TotalExpenses { get; set; } // Spese da fatturare
    public float TotalExpensesCost { get; set; } // Spese caricate a TR
    public float TotalPreinvoiceAmount { get; set; }
    public string AllDaysQuery { get; set; }
    public string AllExpenseQuery { get; set; } // Spese da fatturare
    public string SubtotalAmountQuery { get; set; }
    public string SubtotalAmountCostQuery { get; set; }
    public string SubtotalExpensesQuery { get; set; } // Spese da fatturare
    public string SubtotalExpensesCostQuery { get; set; } // Spese caricate a TR
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

    public string GetStartDate() {
        return preInv.DataDa;
    }

    public string GetEndDate()
    {
        return preInv.DataA;
    }

    public void CreatePreinvoice(PreInvoiceData preInv)
    {
        int loopIndex = 0;
        const int HoursTableIndex = 0;
        const int ExpensesTableIndex = 1;

        // utilizzo pacchetto nuget DOCX - https://github.com/xceedsoftware/DocX
        // https://xceed.com/documentation-center/

        // costruisce il nome del file "template" + "-" + EN/IT + ".docx"
        string WordTemplate = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "TemplateConsuntivo-IT.docx";
        using (var document = DocX.Load(WordTemplate))
        {
            document.ReplaceText("<intestatario>", preInv.NomeCliente);
            document.ReplaceText("<numero>", preInv.Number);
            document.ReplaceText("<data>", preInv.Date);
            document.ReplaceText("<dataDa>", preInv.DataDa);
            document.ReplaceText("<dataA>", preInv.DataA);
            document.ReplaceText("<importoTotaleOre>", preInv.TotalRates.ToString("#,0.00"));
            document.ReplaceText("<importoTotaleSpese>", preInv.TotalExpenses.ToString("#,0.00"));
            document.ReplaceText("<importoTotalePrefattura>", preInv.TotalPreinvoiceAmount.ToString("#,0.00"));
            document.ReplaceText("<signed_by>", CurrentSession.UserName);
            document.ReplaceText("<mail>", CurrentSession.UserMail);

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
            string UrlWordSaved = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "consuntivi-" + preInv.CodiceCliente.TrimEnd() + "-" + preInv.Date.ToString().Replace("/","") + ".docx";
            document.SaveAs(UrlWordSaved);
        }
        return;

    }

    protected void CalculateTotalsFromDB(PreInvoiceData preInv)
    {
        // **** FEES ***
        // totale importi da fattura
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

        dr = Database.GetRow("SELECT SUM(Days), SUM(TotalCost) FROM (" + preInv.SubtotalAmountCostQuery + ") AS TAB", null);

        if (dr != null)
        {
            if (dr[0].ToString() != "")
            {
                preInv.TotalDaysCost = (float)Convert.ToDouble(dr[0]);
                Math.Round(preInv.TotalDays, 2);
                preInv.TotalRatesCost = (float)Convert.ToDouble(dr[1]);
                Math.Round(preInv.TotalRates, 2);
            }
        }

        // **** SPESE ***
        // totale spese da fatturare
        dr = Database.GetRow("SELECT SUM(Importo) FROM (" + preInv.SubtotalExpensesQuery + ") AS TAB", null);

        if (dr != null)
        {
            if (dr[0].ToString() != "")
            {
                preInv.TotalExpenses = (float)Convert.ToDouble(dr[0]);
                Math.Round(preInv.TotalExpenses, 2);
            }
        }

        // totale spese caricate a TR
        dr = Database.GetRow(preInv.SubtotalExpensesCostQuery, null);

        if (dr != null)
        {
            if (dr[0].ToString() != "")
            {
                preInv.TotalExpensesCost = (float)Convert.ToDouble(dr[0]);
                Math.Round(preInv.TotalExpensesCost, 2);
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

        DataRow dr = Database.GetRow("SELECT Preinvoice_id, Date, DataDa, DataA, CodiceCliente, ProjectsSelection, PersonsSelection, NumberOfDays, TotalAmount, TotalRates, TotalExpenses, TotalExpensesCost, Description, DirectorsName, NumberOfDaysCost,TotalRatesCost, PreinvoiceNum  FROM Preinvoice " +
                                     "WHERE Preinvoice_id=" + ASPcompatility.FormatStringDb(preinvoiceId), null);

        preInv.Number = dr[16].ToString();
        preInv.Id = dr[0].ToString();
        preInv.Date = ((DateTime)dr[1]).ToString("dd/MM/yyyy");
        preInv.DataDa = ((DateTime)dr[2]).ToString("dd/MM/yyyy");
        preInv.DataA = ((DateTime)dr[3]).ToString("dd/MM/yyyy");
        preInv.CodiceCliente = dr[4].ToString();
        preInv.ProjectsIdList = dr[5].ToString();
        preInv.TotalDays = (float)Convert.ToDouble(dr[7].ToString());
        preInv.TotalDaysCost = (float)Convert.ToDouble(dr[14].ToString());
        preInv.TotalPreinvoiceAmount = (float)Convert.ToDouble(dr[8].ToString());
        preInv.TotalRates = (float)Convert.ToDouble(dr[9].ToString());
        preInv.TotalRatesCost = (float)Convert.ToDouble(dr[15].ToString());
        preInv.TotalExpenses = (float)Convert.ToDouble(dr[10].ToString());
        preInv.TotalExpensesCost = (float)Convert.ToDouble(dr[11].ToString());
        preInv.Description = dr[12].ToString();
        preInv.DirectorsName = dr[13].ToString();
        SetQueryCommands(preInv);

    }

    protected void LoadFromSessions(PreInvoiceData preInv)
    {
        preInv.Number = "nr";
        preInv.Date = (string)Session["PreinvDocDate"];
        preInv.DataDa = (string)Session["PreinvDataDa"];
        preInv.DataA = (string)Session["PreinvDataA"];
        preInv.CodiceCliente = (string)Session["PreinvCodiceCliente"];
        preInv.ProjectsIdList = (string)Session["PreinvProjectsId"];
        preInv.Description = "";
        SetQueryCommands(preInv);
        CalculateTotalsFromDB(preInv); // calcola i totali
    }

    protected void SetQueryCommands(PreInvoiceData preInv)
    {
        preInv.SubtotalAmountQuery = "SELECT Cliente, D.name as NomeConsulente, Progetto, Days, t.BillRate 'BillRate', Days * BillRate as 'TotalCost', t.CTMPreinvoiceNum " +
                                   "FROM( SELECT E.Nome1 as 'Cliente', C.projectcode + ' ' + C.name as 'Progetto', E.CodiceCliente, SUM( IIF(Hours > 8 AND c.NoOvertime = 1, 8, Hours ) ) / 8 as 'Days', persons_id, a.projects_id, CTMPreinvoiceNum, [MSSql12155].FCT_DeterminaBillRate(persons_id, a.projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as 'BillRate' " + 
                                   "FROM hours as a " +
                                   "INNER JOIN projects as C ON c.projects_id = a.projects_id " +
                                   "INNER JOIN customers as E ON E.CodiceCliente = C.CodiceCliente " +
                                   "WHERE date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA) + " AND E.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " " +
                                   "GROUP by persons_Id, a.projects_id, CTMPreinvoiceNum, E.Nome1, C.projectcode, C.name,  E.CodiceCliente ) AS T " +
                                   "INNER JOIN persons as D ON D.persons_id = t.persons_id ";

        preInv.SubtotalAmountCostQuery = "SELECT D.name as NomeConsulente, Days, t.BillRate 'BillRate', Days * BillRate as 'TotalCost', t.CTMPreinvoiceNum " +
                           "FROM( SELECT E.Nome1 as 'Cliente', C.projectcode + ' ' + C.name as 'Progetto', E.CodiceCliente, SUM(Hours / 8) as 'Days', persons_id, a.projects_id, CTMPreinvoiceNum, [MSSql12155].FCT_DeterminaBillRate(persons_id, a.projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as 'BillRate' " +
                           "FROM hours as a " +
                           "INNER JOIN projects as C ON c.projects_id = a.projects_id " +
                           "INNER JOIN customers as E ON E.CodiceCliente = C.CodiceCliente " +
                           "WHERE date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA) + " AND E.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " " +
                           "GROUP by persons_Id, a.projects_id, CTMPreinvoiceNum, E.Nome1, C.projectcode, C.name,  E.CodiceCliente ) AS T " +
                           "INNER JOIN persons as D ON D.persons_id = t.persons_id ";


        if (preInv.ProjectsIdList != "") { 
            preInv.SubtotalAmountQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
            preInv.SubtotalAmountCostQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
        }

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.SubtotalAmountQuery += " AND T.CTMPreinvoiceNum IS NULL";
        else
            preInv.SubtotalAmountQuery += " AND t.CTMPreinvoiceNum = " + preInv.Number;

        preInv.AllDaysQuery = "SELECT CTMPreinvoiceNum as Prefattura, '" + preInv.Date + "' as DataPrefattura, " + "b.Nome1 as 'Cliente', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', E.name as 'Director' ,CONVERT(VARCHAR(10),Date, 103) as Data , IIF(Hours > 8 AND c.NoOvertime = 1, 8, Hours ) as 'Ore', " +
                                     "fn.Tariffa, fn.Tariffa * IIF(Hours > 8 AND c.NoOvertime = 1, 8, Hours ) / 8 as Importo, " +
                                     "locationdescription as 'Location', Comment as 'Nota' " +
                                     "FROM hours as T " +
                                     "CROSS APPLY ( SELECT [MSSql12155].FCT_DeterminaBillRate(T.persons_id, T.projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as Tariffa  ) fn " +
                                     "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                     "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                                     "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                     "INNER JOIN persons as E ON E.persons_id = t.ClientManager_id " +
                                     "WHERE B.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                                     "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "")
            preInv.AllDaysQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.AllDaysQuery += " AND T.CTMPreinvoiceNum IS NULL";
        else
            preInv.AllDaysQuery += " AND t.CTMPreinvoiceNum = " + preInv.Number;

        // l'importo è calcolato con il conversione rate delle spese TM e sono incluse solo le spese fatturabili
        preInv.AllExpenseQuery = "SELECT CTMPreinvoiceNum as Prefattura, '" + preInv.Date + "' as DataPrefattura, " + " b.Nome1 as 'Cliente', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', F.name as 'Director', COALESCE(G.TMDescription, E.name) as 'TipoSpesa' , CONVERT(VARCHAR(10),Date, 103) as Data , COALESCE(G.TMConversionRate, E.ConversionRate) * t.Amount as Importo " +
                                   "FROM expenses as T " +
                                   "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                   "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                                   "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                   "INNER JOIN ExpenseType as E ON E.ExpenseType_id = t.ExpenseType_id " +
                                   "INNER JOIN persons as F ON F.persons_id = t.ClientManager_id " +
                                   "LEFT JOIN ExpensesTM as G ON ( G.Projects_Id = t.projects_id AND G.ExpenseType_Id = t.ExpenseType_id ) " +
                                   "WHERE c.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                                   "G.ExcludeBilling = 0 AND " +
                                   "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        // l'importo è calcolato con il conversione rate delle spese e sono incluse tutte le spese
        preInv.SubtotalExpensesCostQuery = "SELECT SUM(E.ConversionRate * t.Amount) as ImportoCosto " +
                                   "FROM expenses as t " +
                                   "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                   "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                                   "INNER JOIN ExpenseType as E ON E.ExpenseType_id = t.ExpenseType_id " +
                                   "WHERE c.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                                   "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "") {
            preInv.AllExpenseQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
            preInv.SubtotalExpensesCostQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
        }

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            {
            preInv.AllExpenseQuery += " AND T.CTMPreinvoiceNum IS NULL";
            preInv.SubtotalExpensesCostQuery += " AND T.CTMPreinvoiceNum IS NULL";
        }
        else {
            preInv.AllExpenseQuery += " AND T.CTMPreinvoiceNum = " + preInv.Number;
            preInv.SubtotalExpensesCostQuery += " AND T.CTMPreinvoiceNum = " + preInv.Number;
        }

        preInv.SubtotalExpensesQuery = "SELECT Cliente, NomeConsulente, Progetto, TipoSpesa, SUM(Importo) as 'Importo' FROM (" +
                                       preInv.AllExpenseQuery +
                                       " ) AS TAB GROUP BY Cliente, NomeConsulente, Progetto, TipoSpesa";
        
    }

    protected void LoadNamesFromId(PreInvoiceData preInv)
    {
        //DataTable dtb;
        DataRow dr;

        // Cliente
        dr = Database.GetRow("Select Nome1 from customers where CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente), null);
        if (dr != null)
            preInv.NomeCliente = (string)dr[0];

    }

    protected void DisplayPage(PreInvoiceData preInv)
    {
        LBPreinvoiceNum.Text = preInv.Number + " del " + preInv.Date;
        LBPeriodo.Text = preInv.DataDa + " a " + preInv.DataA;
        LBCliente.Text = preInv.NomeCliente;
        LBDirector.Text = preInv.DirectorsName;
        LBDays.Text = preInv.TotalDays.ToString("#,0.00");
        LBTotalRates.Text = preInv.TotalRates.ToString("#,0.00") + " €";
        LBDaysCost.Text = preInv.TotalDaysCost.ToString("#,0.00");
        LBTotalRatesCost.Text = preInv.TotalRatesCost.ToString("#,0.00") + " €";
        LBTotalExpenses.Text = preInv.TotalExpenses.ToString("#,0.00") + " €";
        LBTotalExpensesCost.Text = preInv.TotalExpensesCost.ToString("#,0.00") + " €";
        LBTotalAmount.Text = preInv.TotalPreinvoiceAmount.ToString("#,0.00") + " €";
        TBDescription.Text = preInv.Description;
        TBCodiceCliente.Text = preInv.CodiceCliente;
        TBDataA.Text = preInv.DataA;
        TBDataDa.Text = preInv.DataDa;
        TBPreinvoiceNumber.Text = preInv.Number;
        TBDataPrefattura.Text = preInv.Date;
    }

    // Bottoni
    protected void Download_Preinvoice(object sender, EventArgs e)
    {
        // aggiorna data se inserita direttamente nel form
        if (TBDataPrefattura.Text != preInv.Date) { 
            Session["PreinvDocDate"] = TBDataPrefattura.Text;
            preInv.Date = TBDataPrefattura.Text;
        }

        CalculateTotalsFromDB(preInv); // ri-calcola i totali
        CreatePreinvoice(preInv);
        // crea documento Word
        
        Response.Redirect("/public/TR-PREINVOICE/consuntivi-" + preInv.CodiceCliente.TrimEnd() + "-" + preInv.Date.ToString().Replace("/", "") + ".docx");
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
        Response.Redirect("/timereport/report/CTMBilling/CTMpreinvoice-list.aspx");
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {

        int PreinvoiceNum = 0;
        string queryToUpdate = "";
        
        PreinvoiceNum = Database.GetLastIdInserted("SELECT MAX(PreinvoiceNum) from Preinvoice WHERE Tipo ='CLI'");
        PreinvoiceNum = PreinvoiceNum == 0 ? 1 : PreinvoiceNum + 1;

        Boolean insertOk = Database.ExecuteSQL("INSERT INTO Preinvoice (PreinvoiceNum, Tipo, CodiceCliente, Date, DataDa, DataA, CreatedBy, CreationDate, NumberOfDays, NumberOfDaysCost, TotalRates, TotalRatesCost, TotalExpenses, TotalExpensesCost, TotalAmount, ProjectsSelection, Description, DirectorsName ) VALUES ( " +
                             ASPcompatility.FormatNumberDB(PreinvoiceNum) + " , " +
                             "'CLI' , " +                            
                             ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " , " +
                             ASPcompatility.FormatDateDb(TBDataPrefattura.Text) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataDa) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataA) + " , " +
                             ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                             ASPcompatility.FormatDateDb(DateTime.Today.ToString("dd/MM/yyyy")) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalDays) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalDaysCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalRates) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalRatesCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalExpenses) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalExpensesCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalPreinvoiceAmount) + " , " +
                             ASPcompatility.FormatStringDb(preInv.ProjectsIdList) + " , " +
                             ASPcompatility.FormatStringDb(TBDescription.Text) + " , " +
                             ASPcompatility.FormatStringDb(preInv.DirectorsName) + " )"
                , null); ;

        if (insertOk) {

            queryToUpdate = "UPDATE hours SET CTMPreinvoiceNum = '" + PreinvoiceNum.ToString()  + "' FROM Hours " +
                             "INNER JOIN Projects AS B ON B.Projects_id = hours.Projects_id " +
                             "WHERE B.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                             "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

            if (preInv.ProjectsIdList != "")
                queryToUpdate += " AND B.projects_id IN ( " + preInv.ProjectsIdList + " )";

            Database.ExecuteSQL(queryToUpdate, null); // aggiorna ore

            queryToUpdate = "UPDATE Expenses SET CTMPreinvoiceNum = '" + PreinvoiceNum.ToString() + "' FROM Expenses " +
                            "INNER JOIN Projects AS B ON B.Projects_id = Expenses.Projects_id " +
                            "WHERE B.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                            "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

                if (preInv.ProjectsIdList != "")
                queryToUpdate += " AND B.projects_id IN ( " + preInv.ProjectsIdList + " )";

            Database.ExecuteSQL(queryToUpdate, null); // aggiorna spese

        }

        Response.Redirect("/timereport/report/CTMBilling/CTMpreinvoice-list.aspx");
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}