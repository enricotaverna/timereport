using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Configuration;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            // Imposta indice di aginazione
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

    // richiesta da export in excel
    //public override void VerifyRenderingInServerForm(Control control)
    //{
    //    /* Verifies that the control is rendered */
    //}

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        Utilities.EsportaDataSetExcel(ds);
    }

    protected void BtnExport_Detail_Click(object sender, System.EventArgs e)
    {
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

    // gestisce click su codice attività per vedere dettaglio  
    //protected void LkAttivita_Click(object sender, EventArgs e)
    //{

    //    // recupera i parametri dal linkbutton premuto
    //    string[] arg = new string[3];
    //    LinkButton LkBt = (LinkButton)sender;
    //    arg = LkBt.CommandArgument.ToString().Split(';');

    //    Response.Redirect("/timereport/m_gestione/activity/activity_lookup_form.aspx?Activity_id=" + arg[0] + "&Projects_Id=" + arg[2] + "&Phase_Id=" + arg[1]);

    //}

    // gestisce click su codice progetto per vedere dettaglio valorizzazione renvenue
    //protected void LkRevenue_Click(object sender, EventArgs e)
    //{

    //    // Popola parametri query
    //    DataSet ds = new DataSet("Export");

    //    SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    //    // recupera i parametri dal linkbutton premuto
    //    string[] arg = new string[3];
    //    LinkButton LkBt = (LinkButton)sender;
    //    arg = LkBt.CommandArgument.ToString().Split(';');

    //    // se data primo carico non valorizzata esce
    //    if (arg[2].Trim().Length == 0)
    //        return;

    //    // chiama stored procedure e riempie dataset
    //    using (conn)
    //    {
    //        SqlCommand sqlComm = new SqlCommand("SPestraiRevenue", conn);

    //        // valorizza parametri della query
    //        sqlComm.Parameters.AddWithValue("@DataA", Convert.ToDateTime(Session["TBDataReport"])); // salvata nello screen selection

    //        sqlComm.Parameters.AddWithValue("@DataDA", Convert.ToDateTime(arg[2])); // Data primo carico

    //        if (arg[1].Trim().Length != 0)
    //            sqlComm.Parameters.AddWithValue("@Activity_id", Convert.ToInt16(arg[1])); // codice attività

    //        sqlComm.Parameters.AddWithValue("@Project_id", Convert.ToInt16(arg[0])); // codice progetto

    //        // esecuzione
    //        sqlComm.CommandType = CommandType.StoredProcedure;

    //        SqlDataAdapter da = new SqlDataAdapter();
    //        da.SelectCommand = sqlComm;
    //        // aumenta il timeout del comando
    //        sqlComm.CommandTimeout = 180;

    //        da.Fill(ds, "Export");

    //    }

        // Aggiunge colonne
    //    ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
    //    ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine

    //    // Calcola indicatori di stato
    //    ds = CalcolaColonne(ds);

    //    Utilities.EsportaDataSetExcel(ds);

    //    /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
    //    //Cache.Insert("ExportRevenue", ds);
    //    //Response.Redirect("/timereport/report/EstraiRevenue/EstraiRevenue-list.aspx");
    //}

    //// Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    //DataSet CalcolaColonne(DataSet ds)
    //{

    //    foreach (DataRow dr in ds.Tables["Export"].Rows)
    //    {
    //        double dRevenueActual = dr["RevenueActual"] == DBNull.Value ? 0 : Convert.ToDouble(dr["RevenueActual"]);
    //        double dGiorniActual = dr["GiorniActual"] == DBNull.Value ? 0 : Convert.ToDouble(dr["GiorniActual"]);
    //        double RecordWithoutCost = dr["RecordWithoutCost"] == DBNull.Value ? 0 : Convert.ToDouble(dr["RecordWithoutCost"]);

    //        // se manca qualche dato obbligatorio mette a warning la colonna e salta i conti
    //        if (RecordWithoutCost == 0)
    //        {
    //            dr["Status"] = "O";
    //            dr["ImgUrl"] = "/timereport/images/icons/other/warning_icon.png";
    //            continue;
    //        }
    //        else
    //        {
    //            dr["status"] = "G";
    //            dr["ImgUrl"] = "/timereport/images/icons/other/ok_icon.png";
    //        }

    //    }

    //    return (ds);
    //}

    //// disabilita bottone drill down su progetto se non ci sono carichi
    //protected void GVAttivita_RowDataBound(object sender, GridViewRowEventArgs e)
    //{

    //    LinkButton lkbt = (LinkButton)e.Row.FindControl("LkRevenue");

    //    if (lkbt != null)
    //    {

    //        // recupera i parametri dal linkbutton premuto
    //        string[] arg = new string[2];
    //        arg = lkbt.CommandArgument.ToString().Split(';');

    //        // se prima data carico blank disabilita il link
    //        if (arg[1].Trim().Length == 0)
    //            lkbt.Enabled = false;
    //    }
    //}
}
