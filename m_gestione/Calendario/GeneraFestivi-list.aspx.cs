using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;

public partial class calendario_festiviList: System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Festivi");

        Auth.CheckPermission("REPORT","ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            GVAttivita.DataSource = ds;
            GVAttivita.DataBind();

            // Valorizza indirizzo pagina chiamante
            btn_back.OnClientClick = "window.location='" + Request.UrlReferrer.ToString() + "'; return(false);";

        }
    }

    // gestisce paginazione
    protected void GVAttivita_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Festivi");

        GVAttivita.PageIndex = e.NewPageIndex;
        GVAttivita.DataSource = ds;
        GVAttivita.DataBind();
    }

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        DataSet ds = (DataSet)Cache.Get("Festivi");

        Response.ClearContent();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "TRexport.xls"));
        Response.ContentType = "application/ms-excel";
        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);

        GVAttivita.AllowPaging = false;
        GVAttivita.DataSource = ds;
        GVAttivita.DataBind();

        GVAttivita.RenderControl(htw);
        Response.Write(sw.ToString());
        Response.End();
    }

    // richiesta da export in excel
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Verifies that the control is rendered */
    }
}