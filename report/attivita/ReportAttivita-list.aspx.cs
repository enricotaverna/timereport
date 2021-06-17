using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;

public partial class report_ReportAttivita : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("export");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
            {

            // Imposta indice di aginazione
            if (Session["ContrPrgPageNumber"] != null)
                GVAttivita.PageIndex = (int)Session["ContrPrgPageNumber"];

            GVAttivita.DataSource = ds;
                GVAttivita.DataBind();
            }
    }

    // gestisce paginazione
    protected void GVAttivita_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("export");

        GVAttivita.PageIndex = e.NewPageIndex;
        GVAttivita.DataSource = ds;
        GVAttivita.DataBind();

        Session["ContrPrgPageNumber"] = e.NewPageIndex;
    }

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("export");

        Utilities.EsportaDataSetExcel(ds);

    }
}