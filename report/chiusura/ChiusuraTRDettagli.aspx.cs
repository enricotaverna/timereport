using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Templates_TemplateForm : System.Web.UI.Page
{

    const string RQS_TICKET = "01";

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "CLOSETR");

        DataTable dt = new DataTable();
        List<CheckChiusura.CheckAnomalia> ListaAnomalie = new List<CheckChiusura.CheckAnomalia> { };

        dt.Columns.Add("Data");
        dt.Columns.Add("Descrizione");

        // in base al tipo di chiamata ricostruisce anomalie e le riporta in tabella
        if (Request.QueryString["type"] == RQS_TICKET)
            CheckChiusura.CheckTicket(Session["Month"].ToString(),
                                                       Session["Year"].ToString(),
                                                       Session["persons_id"].ToString(),
                                                       ref ListaAnomalie);

        foreach (CheckChiusura.CheckAnomalia curr in ListaAnomalie)
        {
            DataRow dr = dt.NewRow();
            dr["Data"] = curr.Data.ToShortDateString();
            dr["Descrizione"] = curr.Descrizione.ToString();
            dt.Rows.Add(dr);
        }

        GV_anomalie.DataSource = dt;
        GV_anomalie.DataBind();

    }

}