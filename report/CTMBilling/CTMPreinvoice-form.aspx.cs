﻿using System;
using System.Threading;
using System.Data;
using System.Web;
using Xceed.Words.NET;
using System.Configuration;
using System.Activities.Expressions;
using System.Text.RegularExpressions;
using Xceed.Document.NET;
using System.Collections.Generic;
using Syncfusion.XlsIO;
using System.Data.SqlClient;
using System.Web.UI;
using System.Drawing;
using Microsoft.IdentityModel.Tokens;

public class PreInvoiceData
{
    public string Id { get; set; }
    public string Number { get; set; }
    public string Date { get; set; }
    public string DataDa { get; set; }
    public string DataA { get; set; }
    public string CodiceCliente { get; set; }
    public string ProjectsIdList { get; set; }
    public bool WBS { get; set; }
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
    //public string SubtotalAmountQuery { get; set; }
    public string SubtotalAmountCostQuery { get; set; }
    public string SubtotalExpensesQuery { get; set; } // Spese da fatturare
    public string SubtotalExpensesCostQuery { get; set; } // Spese caricate a TR
    public string Description { get; set; }
    public string CreatedBy { get; set; }
    public string CreationDate { get; set; }
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

    public string GetStartDate()
    {
        return preInv.DataDa;
    }

    public string GetEndDate()
    {
        return preInv.DataA;
    }

    public void CreatePreinvoice(PreInvoiceData preInv)
    {
        int loopIndex = 0;
        const int ProjectsTableIndex = 0;
        const int HoursTableIndex = 1;
        const int ExpensesTableIndex = 2;

        // utilizzo pacchetto nuget DOCX - https://github.com/xceedsoftware/DocX
        // https://xceed.com/documentation-center/

        // costruisce il nome del file "template" + "-" + EN/IT + ".docx"
        string WordTemplate = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "TemplateConsuntivo-IT.docx";
        using (var document = DocX.Load(WordTemplate))
        {

            // rimuove la colonna WBS se non richiesta
            if (preInv.WBS)
            {
                document.Tables[0].Remove(); // cancella le tabelle senza la colonna WBS
                document.Tables[1].Remove();
            }
            else
            {
                document.Tables[1].Remove(); // cancella le tabelle con la colonna WBS
                document.Tables[2].Remove();
            }

            // Spese 
            var ExpensesTable = document.Tables[ExpensesTableIndex];
            var ProjectsTable = document.Tables[ProjectsTableIndex];
            var HoursTable = document.Tables[HoursTableIndex];

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


            DataTable dt;

            if (!preInv.WBS)
                dt = Database.GetData("SELECT Progetto, SUM(Importo) as importo FROM ( SELECT Progetto, SUM(Importo) as importo FROM ( " +
                                            preInv.AllDaysQuery +
                                            " ) AS T GROUP BY Progetto UNION SELECT Progetto, SUM(Importo) as importo FROM ( " +
                                            preInv.AllExpenseQuery +
                                            " )   AS T GROUP BY Progetto )   AS T GROUP BY Progetto ", null);
            else
                dt = Database.GetData("SELECT progetto, SUM(Importo) as importo, Attivita  FROM ( SELECT progetto, SUM(Importo) as importo, Attivita  FROM (" +
                                                preInv.AllDaysQuery +
                                                " )   AS T GROUP BY Progetto, Attivita UNION SELECT Progetto, SUM(Importo) as importo, Attivita FROM ( " +
                                                preInv.AllExpenseQuery +
                                                " )   AS T GROUP BY Progetto, Attivita )   AS T GROUP BY Progetto, Attivita ", null);

            loopIndex = 1;
            for (int i = 1; i < dt.Rows.Count; i++) // compia la prima riga per N-1 volte
                ProjectsTable.InsertRow(ProjectsTable.Rows[1], loopIndex, true);

            loopIndex = 1;
            foreach (DataRow dr in dt.Rows)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                ProjectsTable.Rows[loopIndex].ReplaceText("<progetto>", dr[0].ToString());
                ProjectsTable.Rows[loopIndex].ReplaceText("<Importo>", Convert.ToDouble(dr[1]).ToString("#,0.00"));

                if (preInv.WBS)
                    ProjectsTable.Rows[loopIndex].ReplaceText("<WBS>", dr[2].ToString());
                else
                    ProjectsTable.Rows[loopIndex].ReplaceText("<WBS>", "");

                loopIndex++;
            }

            // dt = Database.GetData(preInv.SubtotalAmountQuery + " ORDER BY NomeConsulente, Progetto", null);
            if (!preInv.WBS)
                dt = Database.GetData("SELECT NomeConsulente, progetto, SUM(ore)/8 as giorni, tariffa, SUM(Importo) as importo FROM ( " + preInv.AllDaysQuery +
                                                " ) AS T GROUP BY NomeConsulente, Progetto, tariffa ", null);
            else
                dt = Database.GetData("SELECT NomeConsulente, progetto, SUM(ore)/8 as giorni, tariffa, SUM(Importo) as importo, Attivita FROM ( " +
                                                preInv.AllDaysQuery +
                                                " ) AS T GROUP BY NomeConsulente, Progetto, Attivita, tariffa ", null);

            loopIndex = 1;
            for (int i = 1; i < dt.Rows.Count; i++) // compia la prima riga per N-1 volte
                HoursTable.InsertRow(HoursTable.Rows[1], loopIndex, true);

            loopIndex = 1;
            foreach (DataRow dr in dt.Rows)
            {
                // popola le celle della tabella, loopIndex = 0 è la prima riga
                HoursTable.Rows[loopIndex].ReplaceText("<consulente>", dr[0].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<progetto>", dr[1].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<giorni>", Convert.ToDouble(dr[2]).ToString("#,0.000"));
                HoursTable.Rows[loopIndex].ReplaceText("<FLC>", dr[3].ToString());
                HoursTable.Rows[loopIndex].ReplaceText("<Importo>", Convert.ToDouble(dr[4]).ToString("#,0.00"));

                if (preInv.WBS)
                    HoursTable.Rows[loopIndex].ReplaceText("<WBS>", dr[5].ToString());
                else
                    HoursTable.Rows[loopIndex].ReplaceText("<WBS>", "");

                loopIndex++;
            }

            dt = Database.GetData("SELECT Cliente, NomeConsulente, Progetto, TipoSpesa, SUM(Importo) as 'Importo' FROM (" +
                                  preInv.AllExpenseQuery +
                                  " ) AS TAB GROUP BY Cliente, NomeConsulente, Progetto, TipoSpesa", null);

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

            // se non ci sono spese
            if (dt.Rows.Count == 0)
            {
                ExpensesTable.Remove();
                document.ReplaceText("Rimborso spese", ""); ;
            }

            // Save this document to disk.
            string UrlWordSaved = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PREINVOICE_PATH"]) + "Prospetto-Consuntivi-" + preInv.CodiceCliente.TrimEnd() + "-" + preInv.Date.ToString().Replace("/", "") + ".docx";
            document.SaveAs(UrlWordSaved);
        }
        return;

    }

    protected void CalculateTotalsFromDB(PreInvoiceData preInv)
    {
        // **** FEES ***
        // totale importi da fattura
        DataRow dr = Database.GetRow("SELECT SUM(Ore)/8, SUM(Importo) FROM (" + preInv.AllDaysQuery + ") AS TAB", null);

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
        DataTable dtb = Database.GetData("SELECT DISTINCT(Responsabile)  FROM (" + preInv.AllDaysQuery + ") AS TAB", null);
        if (dtb != null)
        {
            foreach (DataRow drb in dtb.Rows)
            {
                preInv.DirectorsName += drb[0].ToString() + ",";
            }
        }

        if (preInv.DirectorsName != "")
            preInv.DirectorsName = preInv.DirectorsName.Substring(0, preInv.DirectorsName.Length - 1);

        return;
    }

    protected void LoadFromDB(PreInvoiceData preInv, string preinvoiceId)
    {

        DataRow dr = Database.GetRow("SELECT Preinvoice_id, Date, DataDa, DataA, CodiceCliente, ProjectsSelection, PersonsSelection, NumberOfDays, TotalAmount, TotalRates, TotalExpenses, TotalExpensesCost, Description, DirectorsName, NumberOfDaysCost,TotalRatesCost, PreinvoiceNum, CreatedBy, CreationDate, DettaglioWBS  FROM Preinvoice " +
                                     "WHERE Preinvoice_id=" + ASPcompatility.FormatStringDb(preinvoiceId), null);

        preInv.Number = dr[16].ToString();
        preInv.Id = dr[0].ToString();
        preInv.Date = ((DateTime)dr[1]).ToString("dd/MM/yyyy");
        preInv.DataDa = ((DateTime)dr[2]).ToString("dd/MM/yyyy");
        preInv.DataA = ((DateTime)dr[3]).ToString("dd/MM/yyyy");
        preInv.WBS = Convert.ToBoolean(dr[19]);
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
        preInv.CreatedBy = dr[17].ToString();
        preInv.CreationDate = ((DateTime)dr[18]).ToString();
        SetQueryCommands(preInv);

    }

    protected void LoadFromSessions(PreInvoiceData preInv)
    {
        preInv.Number = "nr";
        preInv.Date = (string)Session["PreinvDocDate"];
        preInv.DataDa = (string)Session["PreinvDataDa"];
        preInv.DataA = (string)Session["PreinvDataA"];
        preInv.WBS = (bool)Session["PreinvWBS"];
        preInv.CodiceCliente = (string)Session["PreinvCodiceCliente"];
        preInv.ProjectsIdList = (string)Session["PreinvProjectsId"];
        preInv.Description = "";
        SetQueryCommands(preInv);
        CalculateTotalsFromDB(preInv); // calcola i totali
    }

    protected void SetQueryCommands(PreInvoiceData preInv)
    {

        preInv.SubtotalAmountCostQuery = "SELECT D.name as NomeConsulente, Days, t.BillRate 'BillRate', Days * BillRate as 'TotalCost', t.CTMPreinvoiceNum " +
                           "FROM( SELECT E.Nome1 as 'Cliente', C.projectcode + ' ' + C.name as 'Progetto', E.CodiceCliente, SUM(Hours / 8) as 'Days', persons_id, a.projects_id, CTMPreinvoiceNum, [MSSql12155].FCT_DeterminaBillRate(persons_id, a.projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as 'BillRate' " +
                           "FROM hours as a " +
                           "INNER JOIN projects as C ON c.projects_id = a.projects_id " +
                           "INNER JOIN customers as E ON E.CodiceCliente = C.CodiceCliente " +
                           "WHERE date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) +
                           " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA) +
                           " AND E.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " " +
                           " AND C.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' " +
                           "GROUP by persons_Id, a.projects_id, CTMPreinvoiceNum, E.Nome1, C.projectcode, C.name,  E.CodiceCliente ) AS T " +
                           "INNER JOIN persons as D ON D.persons_id = t.persons_id ";


        if (preInv.ProjectsIdList != "")
        {
            //preInv.SubtotalAmountQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
            preInv.SubtotalAmountCostQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
        }

        preInv.AllDaysQuery = "SELECT CTMPreinvoiceNum as Consuntivo, '" + preInv.Date + "' as DataConsuntivo, " + "b.Nome1 as 'Cliente', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', F.Name as Attivita, E.name as 'Responsabile' ,CONVERT(VARCHAR(10),Date, 103) as Data , OreRicavi as 'Ore', " +
                                 "fn.Tariffa, fn.Tariffa * OreRicavi / 8 as Importo, " +
                                 "locationdescription as 'Sede', t.Comment as 'Nota' " +
                                 "FROM hours as T " +
                                 "CROSS APPLY ( SELECT [MSSql12155].FCT_DeterminaBillRate(T.persons_id, T.projects_id, " + ASPcompatility.FormatDateDb(preInv.DataDa) + ") as Tariffa  ) fn " +
                                 "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                 "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                                 "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                                 "INNER JOIN persons as E ON E.persons_id = t.ClientManager_id " +
                                 "LEFT  JOIN activity as F ON F.activity_id = t.activity_id " +
                                 "WHERE B.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) +
                                 " AND c.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' AND " +
                                 "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "")
            preInv.AllDaysQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
            preInv.AllDaysQuery += " AND T.CTMPreinvoiceNum IS NULL";
        else
            preInv.AllDaysQuery += " AND t.CTMPreinvoiceNum = " + preInv.Number;

        // l'importo è calcolato con il conversione rate delle spese TM e sono incluse solo le spese fatturabili
        preInv.AllExpenseQuery = "SELECT CTMPreinvoiceNum as Consuntivo, '" + preInv.Date + "' as DataConsuntivo, " + " b.Nome1 as 'Cliente', D.name as NomeConsulente, c.projectcode + ' ' + c.name as 'Progetto', NULL as Attivita, F.name as 'Responsabile', COALESCE(G.TMDescription, E.name) as 'TipoSpesa' , CONVERT(VARCHAR(10),Date, 103) as Data , COALESCE(G.TMConversionRate, E.ConversionRate) * t.Amount as Importo, Comment as Note " +
                               "FROM expenses as T " +
                               "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                               "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                               "INNER JOIN persons as D ON D.persons_id = t.persons_id " +
                               "INNER JOIN ExpenseType as E ON E.ExpenseType_id = t.ExpenseType_id " +
                               "INNER JOIN persons as F ON F.persons_id = t.ClientManager_id " +
                               "LEFT JOIN ExpensesTM as G ON ( G.Projects_Id = t.projects_id AND G.ExpenseType_Id = t.ExpenseType_id ) " +
                               "WHERE c.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                               " ( G.ExcludeBilling IS NULL OR G.ExcludeBilling = 0 ) AND " + // spesa non da escludere o spesa standard
                               "c.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' AND " +
                               "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);


        // l'importo è calcolato con il conversione rate delle spese e sono incluse tutte le spese
        preInv.SubtotalExpensesCostQuery = "SELECT SUM(E.ConversionRate * t.Amount) as ImportoCosto " +
                                   "FROM expenses as t " +
                                   "INNER JOIN projects as c ON c.projects_id = t.projects_id " +
                                   "INNER JOIN customers as B ON b.CodiceCliente = c.CodiceCliente " +
                                   "INNER JOIN ExpenseType as E ON E.ExpenseType_id = t.ExpenseType_id " +
                                   "WHERE c.CodiceCliente = " + ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " AND " +
                                   "c.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' AND " +
                                   "date >= " + ASPcompatility.FormatDateDb(preInv.DataDa) + " AND date <= " + ASPcompatility.FormatDateDb(preInv.DataA);

        if (preInv.ProjectsIdList != "")
        {
            preInv.AllExpenseQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
            preInv.SubtotalExpensesCostQuery += " AND T.projects_id IN ( " + preInv.ProjectsIdList + " )";
        }

        if (preInv.Number == "nr") // in creazione il campo prefattura non deve essere valorizzato
        {
            preInv.AllExpenseQuery += " AND T.CTMPreinvoiceNum IS NULL";
            preInv.SubtotalExpensesCostQuery += " AND T.CTMPreinvoiceNum IS NULL";
        }
        else
        {
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
        TBProjectsIdList.Text = preInv.ProjectsIdList;
        LBCreatedBy.Text = preInv.CreatedBy;
        LBCreationDate.Text = preInv.CreationDate;
    }

    // Bottoni
    protected void Download_Preinvoice(object sender, EventArgs e)
    {
        // aggiorna data se inserita direttamente nel form
        if (TBDataPrefattura.Text != preInv.Date)
        {
            Session["PreinvDocDate"] = TBDataPrefattura.Text;
            preInv.Date = TBDataPrefattura.Text;
        }

        CalculateTotalsFromDB(preInv); // ri-calcola i totali
        CreatePreinvoice(preInv);
        // crea documento Word

        Response.Redirect("/public/TR-PREINVOICE/Prospetto-Consuntivi-" + preInv.CodiceCliente.TrimEnd() + "-" + preInv.Date.ToString().Replace("/", "") + ".docx");
    }

    // Export di excel con ore e spese dei consuntivi
    protected void Download_Query(object sender, EventArgs e)
    {

        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2013;
            IWorkbook workbook = application.Workbooks.Create(0);
            IWorksheet wsOre = workbook.Worksheets.Create("Ore");
            IWorksheet wsSpese = workbook.Worksheets.Create("Spese");

            //*** Worksheet con sintesi progetti
            // Esecuzione della stored procedure e ottenimento del risultato come DataSet
            DataTable dtOre = Database.GetData(preInv.AllDaysQuery + " ORDER BY NomeConsulente, Data", null);
            wsOre.ImportDataTable(dtOre, true, 1, 1);

            //*** Worksheet con dettaglio ore progetti
            DataTable dtSpese = Database.GetData(preInv.AllExpenseQuery + " ORDER BY NomeConsulente, Data", null);
            wsSpese.ImportDataTable(dtSpese, true, 1, 1);

            // Formatta il foglio excel con le intestazioni
            Utilities.FormatWorkbook(ref workbook);

            string filename = "Consuntivi-" + preInv.CodiceCliente.TrimEnd() + "-" + preInv.Date.ToString().Replace("/", "") + ".xlsx";
            bool ret = Utilities.ExporXlsxWorkbook(workbook, filename);
            // Avvio download dopo che è stato prodotto il file
            if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('" + filename + "'); };", true);
        }
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

        Boolean insertOk = Database.ExecuteSQL("INSERT INTO Preinvoice (PreinvoiceNum, Tipo, CodiceCliente, Date, DataDa, DataA, CreatedBy, CreationDate, NumberOfDays, NumberOfDaysCost, TotalRates, TotalRatesCost, TotalExpenses, TotalExpensesCost, TotalAmount, ProjectsSelection, Description, DettaglioWBS ,DirectorsName ) VALUES ( " +
                             ASPcompatility.FormatNumberDB(PreinvoiceNum) + " , " +
                             "'CLI' , " +
                             ASPcompatility.FormatStringDb(preInv.CodiceCliente) + " , " +
                             ASPcompatility.FormatDateDb(TBDataPrefattura.Text) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataDa) + " , " +
                             ASPcompatility.FormatDateDb(preInv.DataA) + " , " +
                             ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                             ASPcompatility.FormatDatetimeDb(DateTime.Now, true) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalDays) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalDaysCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalRates) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalRatesCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalExpenses) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalExpensesCost) + " , " +
                             ASPcompatility.FormatNumberDB(preInv.TotalPreinvoiceAmount) + " , " +
                             ASPcompatility.FormatStringDb(preInv.ProjectsIdList) + " , " +
                             ASPcompatility.FormatStringDb(TBDescription.Text) + " , '" +
                             preInv.WBS + "' , " +
                             ASPcompatility.FormatStringDb(preInv.DirectorsName) + " )"
                , null); ;

        if (insertOk)
        {

            queryToUpdate = "UPDATE hours SET CTMPreinvoiceNum = '" + PreinvoiceNum.ToString() + "' FROM Hours " +
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