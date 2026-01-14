using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Amazon;
using System.IO;
using System.Data.Entity.Infrastructure;
using Syncfusion.XlsIO;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        // recupera il tipo contratto dalla sessione, default "0" se non impostato
        string tipoContratto = Session["DDLCpTipoContratto"] != null ? Session["DDLCpTipoContratto"].ToString() : "0";

        // richima storage procedure per popolare la tabella con i valori degli economics di progetto
        // La data di cutoff viene letta automaticamente dalla sessione all'interno del metodo PopolaDataset
        DataSet ds = ControlloProgetto.PopolaDataset(
            Session["DDLCpProgetto"].ToString(), 
            Session["DDLCpManager"].ToString(),
            tipoContratto);
            
        Session["dataset"] = ds;

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            GVAttivita.DataSource = ds;
            Session["dsGVAttivita"] = ds;
            GVAttivita.DataBind();

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

            if (decimal.TryParse(e.Row.Cells[10].Text, out value)) {
                
                if(value < 0)
                    e.Row.Cells[10].ForeColor = System.Drawing.Color.Red; // Cambia il colore della cella in rosso 
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
            // La data di cutoff viene letta automaticamente dalla sessione all'interno del metodo EstraiGiorniCosti
            DataTable dtDettaglio = ControlloProgetto.EstraiGiorniCosti(Session["ProgettoReport"].ToString(), Session["ManagerReport"].ToString());
            wsDettaglio.ImportDataTable(dtDettaglio, true, 1, 1);

            // Formatta il foglio excel con le intestazioni
            Utilities.FormatWorkbook(ref workbook);

            ret =  Utilities.ExporXlsxWorkbook(workbook, "export.xlsx");

        }

        // Avvio download dopo che è stato prodotto il file
        if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('export.xlsx'); };", true);

    }

}
