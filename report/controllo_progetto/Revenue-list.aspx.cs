using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

public partial class report_ReportRevenue : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        if (!Page.IsPostBack)
        {

            GVAttivita.DataSource = ds;
            GVAttivita.DataBind();
        }
    }

    // gestisce paginazione
    protected void GVAttivita_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Export");

        GVAttivita.PageIndex = e.NewPageIndex;
        GVAttivita.DataSource = ds;
        GVAttivita.DataBind();
    }
}