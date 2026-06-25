using Amazon;
using Syncfusion.XlsIO;
using System;
using System.Configuration;
using System.Data;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        var filtri = ControlloProgettoFiltri.FromSession(Session);

        if (!filtri.IsValid())
        {
            Response.Redirect("/timereport/menu.aspx");
            return;
        }

        DataSet ds = ControlloProgetto.PopolaDataset(filtri);
        Session["dataset"] = ds;

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            GVAttivita.DataSource = ds;
            Session["dsGVAttivita"] = ds;
            GVAttivita.DataBind();

            // Ripristina eventuale ordinamento salvato in sessione
            if (Session["GVAttivita_SortExpression"] != null && Session["GVAttivita_SortDirection"] != null)
            {
                DataView dv = ds.Tables[0].DefaultView;
                dv.Sort = Session["GVAttivita_SortExpression"] + " " + Session["GVAttivita_SortDirection"];
                GVAttivita.DataSource = dv;
                GVAttivita.DataBind();
            }

            // Valorizza indirizzo pagina chiamante
            btn_back.OnClientClick = "window.location='/timereport/report/controllo_progetto/ControlloProgetto-select.aspx'; return(false);";
        }
    }

    // gestisce click su codice progetto per vedere dettaglio  
    protected void LkProgetto_Click(object sender, EventArgs e)
    {

        // recupera i parametri dal linkbutton premuto
        LinkButton LkBt = (LinkButton)sender;
        string arg = LkBt.CommandArgument.ToString();

        Response.Redirect("/timereport/m_gestione/Project/Projects_lookup_form.aspx?ProjectCode=" + arg);

    }

    protected void GVAttivita_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        decimal value;

        // se costo o bill rate sono a zero
        if (e.Row.RowType == DataControlRowType.DataRow)

            if (decimal.TryParse(e.Row.Cells[9].Text, out value)) {
                
                if(value < 0)
                    e.Row.Cells[9].ForeColor = System.Drawing.Color.Red; // Cambia il colore di sfondo della cella in rosso
            }

    }

    // Export in excel la lista delle ore
    protected void BtnExport_Click(object sender, EventArgs e)
    {
        bool ret;

        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2013;
            IWorkbook workbook = application.Workbooks.Create(0);
            IWorksheet wsSintesi = workbook.Worksheets.Create("Sintesi Progetti");
            IWorksheet wsDettaglio = workbook.Worksheets.Create("Dettaglio Ore");

            //*** Worksheet con sintesi progetti
            DataSet ds = (DataSet)Session["dataset"];
            DataTable dtSintesi = ds.Tables[0];
            wsSintesi.ImportDataTable(dtSintesi, true, 1, 1);

            //*** Worksheet con dettaglio ore progetti
            var filtri = ControlloProgettoFiltri.FromSession(Session);
            DataTable dtDettaglio = ControlloProgetto.EstraiGiorniCosti(filtri);
            wsDettaglio.ImportDataTable(dtDettaglio, true, 1, 1);

            // Formatta il foglio excel con le intestazioni
            Utilities.FormatWorkbook(ref workbook);

            ret =  Utilities.ExporXlsxWorkbook(workbook, "export.xlsx");

        }

        // Avvio download dopo che è stato prodotto il file
        if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('export.xlsx'); };", true);

    }

    // Export in excel la lista delle ore
    protected void BtnExportHistory_Click(object sender, EventArgs e)
    {
        bool ret;

        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2013;
            IWorkbook workbook = application.Workbooks.Create(0);
            IWorksheet wsEconomics = workbook.Worksheets.Create("Storico Economics");

            //*** Recupera il dataset dalla sessione
            DataSet ds = (DataSet)Session["dataset"];
            DataTable dtProgetti = ds.Tables[0];

            // Estrae gli ID progetti unici dal dataset
            var projectIds = dtProgetti.AsEnumerable()
                .Select(row => row.Field<int>("projects_id")) // o il tipo corretto della colonna
                .Distinct()
                .ToList();

            // Crea la condizione IN per la query
            string projectIdsList = string.Join(",", projectIds);

            //*** Worksheet con storico economics filtrato per i progetti estratti
            DataTable dtSintesi = Database.GetData(
                "SELECT * FROM v_ProjectEconomicsReport " +
                "WHERE projects_id IN (" + projectIdsList + ") " );

            wsEconomics.ImportDataTable(dtSintesi, true, 1, 1);

            // Formatta il foglio excel con le intestazioni
            Utilities.FormatWorkbook(ref workbook);

            ret = Utilities.ExporXlsxWorkbook(workbook, "export.xlsx");
        }

        // Avvio download dopo che è stato prodotto il file
        if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('export.xlsx'); };", true);
    }

    protected void GVAttivita_Sorting(object sender, GridViewSortEventArgs e)
    {
        DataSet ds = (DataSet)Session["dataset"];
        DataView dv = ds.Tables[0].DefaultView;

        // Gestisce l'alternanza ASC/DESC
        string currentExpression = ViewState["SortExpression"] as string;
        string currentDirection = ViewState["SortDirection"] as string ?? "ASC";

        string sortDirection = (currentExpression == e.SortExpression && currentDirection == "ASC") ? "DESC" : "ASC";

        dv.Sort = e.SortExpression + " " + sortDirection;
        ViewState["SortExpression"] = e.SortExpression;
        ViewState["SortDirection"] = sortDirection;

        // Persistenza ordinamento tra navigazioni
        Session["GVAttivita_SortExpression"] = e.SortExpression;
        Session["GVAttivita_SortDirection"] = sortDirection;

        GVAttivita.DataSource = dv;
        GVAttivita.DataBind();
    }

}
