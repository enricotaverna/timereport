using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {

        // richima storage procedure per popolare la tabella con i valori degli economics di peogetto
        DataSet ds = ControlloProgetto.PopolaDataset(Session["DataReport"].ToString(), Session["ProgettoReport"].ToString(), Session["ManagerReport"].ToString());

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            // Imposta indice di paginazione
            if (Session["ContrPrgPageNumber"] != null)
            {
                GVAttivita.PageIndex = (int)Session["ContrPrgPageNumber"];
            }

            GVAttivita.DataSource = ds;
            GVAttivita.DataBind();

            // Valorizza indirizzo pagina chiamante
            btn_back.OnClientClick = "window.location='/timereport/report/controllo_progetto/ControlloProgetto-select.aspx'; return(false);";
        }
    }

    // gestisce paginazione
    protected void GVAttivita_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        GVAttivita.PageIndex = e.NewPageIndex;
        GVAttivita.DataSource = ds;
        GVAttivita.DataBind();

        Session["ContrPrgPageNumber"] = e.NewPageIndex;

    }

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        Utilities.EsportaDataSetExcel(ds);
    }

    protected void BtnExport_Detail_Click(object sender, System.EventArgs e)
    {

        string sQuery;

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        sQuery = "SELECT * FROM v_oreWithCost WHERE Active = 1 AND Data <= " + ASPcompatility.FormatDatetimeDb(Convert.ToDateTime(Session["DataReport"].ToString())) +
                                         " AND ProjectType_id = '" + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + "'";

        if ( Session["ProgettoReport"].ToString() != "0")
            sQuery += " AND Projects_id = " + Session["ProgettoReport"].ToString();

        if ( Session["ManagerReport"].ToString() != "0")
            sQuery += " AND ( ClientManager_id = " + Session["ManagerReport"].ToString() + " OR AccountManager_id = " + Session["ManagerReport"].ToString() + ")";

        sQuery += " ORDER BY Consulente, Data";

        Utilities.ExportXls(sQuery);
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

}
