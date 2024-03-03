using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = BuildDataSet();

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

    protected DataSet BuildDataSet() {

        DataSet ds = new DataSet("Export");

        // Lancia stored procedure che popola la tabella "Export" nel dataset ds
        // Projects_Id, Codice+Nome progetto, Activity_id, Codice + Nome attività, ImportoRevenue (da progetto o attività), Importo spese (solo da progetto)
        // DataFine (da progetto o attività), DataInizio (da progetto o attività), Nome manager,
        // TotaleOre = Somma Ore
        // TotaleRevenue = Somma Revenue (NULL se manca qualche CostRate)
        // PrimaDataCarico = data primo carico ore
        // TotaleSpese= Somma Spese 

        ds = ControlloProgetto.EseguiStoredProcedure(Session["DataReport"].ToString(), Session["ProgettoReport"].ToString(), Session["ManagerReport"].ToString());

        // torna il dataset completo    
        return (ds);

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
                                         " ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"];

        if ( Session["ProgettoReport"].ToString() != "0")
            Session["QueryDettaglioCosti"] += " AND Projects_id = " + Session["ProgettoReport"].ToString();

        if ( Session["ManagerReport"].ToString() != "0")
            Session["QueryDettaglioCosti"] += " AND ClientManager_id = " + Session["ManagerReport"].ToString();

        Session["QueryDettaglioCosti"] += " ORDER BY Consulente, Data";


        Utilities.ExportXls(Session["QueryDettaglioCosti"].ToString());
    }

    // gestisce click su codice progetto per vedere dettaglio  
    protected void LkProgetto_Click(object sender, EventArgs e)
    {

        // recupera i parametri dal linkbutton premuto
        LinkButton LkBt = (LinkButton)sender;
        string arg = LkBt.CommandArgument.ToString();

        Response.Redirect("/timereport/m_gestione/Project/Projects_lookup_form.aspx?ProjectCode=" + arg);

    }

}
