using Microsoft.SqlServer.Server;
using Syncfusion.XlsIO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Web.DynamicData;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    public EconomicsProgetto ProgettoCorrente;

    private string prevPage = String.Empty;
    public List<SqlParameter> parametersList = new List<SqlParameter>();

    public string columnNamesJson;
    public string columnSumsJson;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            prevPage = Request.UrlReferrer.ToString();

            LoadFormData();

            Session["ProgettoCorrente"] = ProgettoCorrente;

        }
    }

    protected void LoadFormData()
    {

        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");

        // calcola i dati actual del progetto e popola l'oggeto EconomicsProgettoCorrente
        // La data di cutoff viene letta automaticamente dalla sessione all'interno del costruttore
        ProgettoCorrente = new EconomicsProgetto(TProjects_Id.Value);

        // DATA PRIMO CARICO
        TextBox TBAttivoDa = (TextBox)FVProgetto.FindControl("TBAttivoDa");
        TBAttivoDa.Text = ProgettoCorrente.PrimaDataCarico.ToString("dd/MM/yyyy");

        // REVENUE 
        OutputLabel("lbRevenueBDG", ProgettoCorrente.RevenueBDG.ToString("#,###;0"));
        OutputLabel("lbRevenueACT", ProgettoCorrente.RevenueACT.ToString("#,###;0"));
        OutputLabel("lbRevenueEAC", ProgettoCorrente.RevenueEAC.ToString("#,###;0"));

        // COSTI
        OutputLabel("lbCostiBDG", ProgettoCorrente.CostiBDG.ToString("#,###;0"));
        OutputLabel("lbCostiACT", ProgettoCorrente.CostiACT.ToString("#,###;0"));
        OutputLabel("lbCostiEAC", ProgettoCorrente.CostiEAC.ToString("#,###;0"));

        // SPESE 
        OutputLabel("lbSpeseBDG", ProgettoCorrente.SpeseBDG.ToString("#,###;0"));
        OutputLabel("lbSpeseACT", ProgettoCorrente.SpeseACT.ToString("#,###;0"));
        OutputLabel("lbSpeseEAC", ProgettoCorrente.SpeseEAC.ToString("#,###;0"));

        // MARGINE
        OutputLabel("lbMargineBDG", ProgettoCorrente.MargineBDG.ToString("#.#%;-#.#%;"));
        OutputLabel("lbMargineACT", ProgettoCorrente.MargineACT.ToString("#.#%;-#.#%;"));
        OutputLabel("lbMargineEAC", ProgettoCorrente.MargineEAC.ToString("#.#%;-#.#%;"));

        // WRITEUP
        OutputLabel("lbWriteUpACT", ProgettoCorrente.WriteUpACT.ToString("#,###;-#,###;"));
        OutputLabel("lbWriteUpEAC", ProgettoCorrente.WriteUpEAC.ToString("#,###;-#,###;"));

        Label lbWriteUpEAC = (Label)FVProgetto.FindControl("lbWriteUpEAC");
        Label lbWriteUpACT = (Label)FVProgetto.FindControl("lbWriteUpACT");

        if (ProgettoCorrente.WriteUpEAC < 0)
            lbWriteUpEAC.ForeColor = Color.Red;

        if (ProgettoCorrente.WriteUpACT < 0)
            lbWriteUpACT.ForeColor = Color.Red;

        // MESI COPERTURA
        TextBox TBMesiCopertura = (TextBox)FVProgetto.FindControl("TBMesiCopertura");
        TBMesiCopertura.Text = ProgettoCorrente.MesiCopertura.ToString("#,##0.#;-#,##0.#;0");
           
        // popola tabella costi e billrate            
        GridView GVConsulenti = (GridView)FVProgetto.FindControl("GVConsulenti");

        // Usa la data di cutoff dalla sessione
        GVConsulenti.DataSource = Database.GetData("SELECT DISTINCT Consulente, YEAR(Data) as Anno ,FORMAT(SUM(giorni) , 'N1', 'it-IT') as Giorni, FORMAT(CostRate, 'N0') + ' €' as CostRate , FORMAT(BillRate, 'N0') + ' €' as BillRate FROM v_oreWithCost " +
                                                   "WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) +
                                                   " AND Data <= " + ASPcompatility.FormatDatetimeDb(CurrentSession.dCutoffDate)  +
                                                   " GROUP BY Consulente, YEAR(Data), CostRate, BillRate", null);

         GVConsulenti.DataBind();

        CalcolaActuals( TProjects_Id.Value);
    }

    private void OutputLabel(string controllo, string testo ) {
        Label label = (Label)FVProgetto.FindControl(controllo);
        label.Text = testo;
    }

    // Actual
    private void CalcolaActuals(string Projects_id)
    {
        // popola tabella gg actuals          
        GridView GVGGActuals = (GridView)FVProgetto.FindControl("GVGGActuals");

        parametersList.Add(new SqlParameter("@Project_id", Projects_id));
        // Usa la data di cutoff dalla sessione invece di DateTime.Now
        parametersList.Add(new SqlParameter("@DataReport", CurrentSession.dCutoffDate));
        SqlParameter[] param = parametersList.ToArray();

        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        DataSet ds = Database.ExecuteStoredProcedure("SPcontrolloprogetti_giorniACT", param);

        GVGGActuals.DataSource = ds;
        GVGGActuals.DataBind();

        // Elenco intestazioni della tabella
        DataTable tabData = ds.Tables[0];
        string[] columnNames = new string[tabData.Columns.Count];
        for (int i = 1; i < tabData.Columns.Count; i++) // salta la prima colonna in cui ci sono i nomi dei consulenti
        {
            columnNames[i] = tabData.Columns[i].ColumnName;
        }
       
        // somma per mesi
        decimal[] columnSums = new decimal[tabData.Columns.Count];
        // Itera su ogni riga del DataTable per calcolare le somme totali
        foreach (DataRow row in tabData.Rows)
        {
            for (int i = 1; i < tabData.Columns.Count; i++)  // salta la prima colonna in cui ci sono i nomi dei consulenti
            {
                // Aggiungi il valore della cella alla somma corrispondente nella colonna
                if (!Convert.IsDBNull(row[i]))
                    columnSums[i] += Convert.ToDecimal(row[i]);
            }
        }

        Session["columnNamesJson"] = Newtonsoft.Json.JsonConvert.SerializeObject(columnNames);
        Session["columnSumsJson"] = Newtonsoft.Json.JsonConvert.SerializeObject(columnSums);

    }

    // Scarica dettaglio ore
    protected void Download_ore_costi(object sender, EventArgs e)
    {
        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");
        DataTable dtDettaglio = Database.GetData("SELECT * FROM v_oreWithCost  WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) + " ORDER BY Data, Consulente", null);
        bool ret = Utilities.ExporXlsxWorkbook(dtDettaglio,"export.xlsx");
        // Avvio download dopo che è stato prodotto il file
        if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('export.xlsx'); };", true);
    }

    protected void Download_GGActuals(object sender, EventArgs e)
    {
        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");

        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2013;
            IWorkbook workbook = application.Workbooks.Create(0);
            IWorksheet wsSintesi = workbook.Worksheets.Create("Sintesi Progetto");
            IWorksheet wsDettaglio = workbook.Worksheets.Create("Dettaglio Ore");

            //*** Worksheet con sintesi progetti
            parametersList.Add(new SqlParameter("@Project_id", TProjects_Id.Value));
            // Usa la data di cutoff dalla sessione
            parametersList.Add(new SqlParameter("@DataReport", CurrentSession.dCutoffDate));
            SqlParameter[] parameters = parametersList.ToArray();
            // Esecuzione della stored procedure e ottenimento del risultato come DataSet
            DataTable dtSintesi = Database.ExecuteStoredProcedure("SPcontrolloprogetti_giorniACT", parameters).Tables[0];
            wsSintesi.ImportDataTable(dtSintesi, true, 1, 1);

            //*** Worksheet con dettaglio ore progetti
            DataTable dtDettaglio = Database.GetData("SELECT Consulente, ProjectCode, NomeProgetto, TipoContratto, Director, AccountManager, CONVERT(varchar, Data, 103) as Date, AnnoMese, Hours, Giorni, CostRate, BillRate, OreRicavi, CostAmount, RevenueAmount, Comment FROM v_oreWithCost  WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) + " ORDER BY Data, Consulente", null);
            wsDettaglio.ImportDataTable(dtDettaglio, true, 1, 1);

            // Formatta il foglio excel con le intestazioni
            Utilities.FormatWorkbook(ref workbook);

            bool ret = Utilities.ExporXlsxWorkbook(workbook, "export.xlsx");
            // Avvio download dopo che è stato prodotto il file
            if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('export.xlsx'); };", true);
        }
    }

    protected void DSprojects_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
    }

    protected void FVProgetto_ItemUpdated(Object sender, System.Web.UI.WebControls.FormViewUpdatedEventArgs e)
    {
        Response.Redirect("ControlloProgetto-list.aspx");
    }

    protected void FormattaTabellaOutput(GridViewRowEventArgs tab, string formato) 
    {

        decimal value;

        if (tab.Row.RowType == DataControlRowType.DataRow)
        {
            //** formattazione **/
            // Itera attraverso le celle della riga
            foreach (TableCell cell in tab.Row.Cells)
            {
                // Controlla se il valore della cella può essere convertito in un numero
                if (decimal.TryParse(cell.Text, out value))
                {
                    // Formatta il valore con due decimali
                    cell.Text = value.ToString(formato);
                }
                else if (cell.Text == "0") // Se il valore è zero
                {
                    // Imposta il testo della cella a uno spazio
                    cell.Text = "&nbsp;";
                }
            }
        }

    }

    protected void GVConsulenti_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            FormattaTabellaOutput(e, "#.#");

            // formattazione campo
            //string costrate = e.Row.Cells[2].Text == "0" || e.Row.Cells[2].Text == "&nbsp;" ? "" : e.Row.Cells[2].Text;
            //string billrate = e.Row.Cells[3].Text == "0,0000" || e.Row.Cells[3].Text == "&nbsp;" ? "" : e.Row.Cells[3].Text;
            string costrate = e.Row.Cells[3].Text;
            string billrate = e.Row.Cells[4].Text;


            // se costo o bill rate sono a zero
            if (ProgettoCorrente.TipoContratto == "FORFAIT" && costrate == "0 €" || ProgettoCorrente.TipoContratto == "T&M" && (costrate == "0 €" || billrate == "0 €"))
            {
                e.Row.Cells[0].ForeColor = e.Row.Cells[1].ForeColor = e.Row.Cells[2].ForeColor = e.Row.Cells[3].ForeColor = System.Drawing.Color.Red; // Cambia il colore della cella in rosso                                                          
            }
        }       
    }

    protected void GVGGActuals_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        FormattaTabellaOutput(e, "0.##");
    }

    // ** Avvia la procedura di ricalcolo Costi
    protected void btn_calc_Click(object sender, EventArgs e)
    {
        // imposta sessione
        EconomicsProgetto ProgettoCorrente = (EconomicsProgetto)Session["ProgettoCorrente"];

        // calcola costi per tutti i progetti del mese da chiudere
        ControlloProgetto.CalcolaCosti(ProgettoCorrente.PrimaDataCarico, ProgettoCorrente.Projects_Id, 1);  // data, progetto, overwrite

        Response.Redirect("/timereport/report/controllo_progetto/ControlloProgetto-form.aspx?ProjectCode=" + ProgettoCorrente.ProjectCode);
    }

}