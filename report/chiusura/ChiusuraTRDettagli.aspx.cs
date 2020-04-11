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
    const string RQS_SPESA = "02";
    const string RQS_ASSENZA = "03";

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "CLOSETR");

        DataTable dt = new DataTable();
        List<CheckChiusura.CheckAnomalia> ListaAnomalie = new List<CheckChiusura.CheckAnomalia> { };

        // in base al tipo di chiamata ricostruisce anomalie e le riporta in tabella

        if (Request.QueryString["type"] == RQS_TICKET) // check ticket
        {
            CheckChiusura.CheckTicket(Session["Month"].ToString(),
                                                       Session["Year"].ToString(),
                                                       Session["persons_id"].ToString(),
                                                               ref ListaAnomalie);

            //  popola grid di visualizzazione
            dt.Reset();
            // costruisce la struttura della tabella di output
            dt.Columns.Add("Data");
            dt.Columns.Add("Descrizione");

            foreach (CheckChiusura.CheckAnomalia curr in ListaAnomalie)
            {
                // popola la tabella
                DataRow dr = dt.NewRow();
                dr["Data"] = curr.Data.ToShortDateString();
                dr["Descrizione"] = curr.Descrizione.ToString();
                dt.Rows.Add(dr);
            }
        }
    
        if (Request.QueryString["type"] == RQS_SPESA) // check spese 
        {
            CheckChiusura.CheckSpese(Session["Month"].ToString(),
                                                       Session["Year"].ToString(),
                                                       Session["persons_id"].ToString(),
                                                       ref ListaAnomalie);

            // costruisce la struttura della tabella di output
            dt.Reset();
            dt.Columns.Add("Data");
            dt.Columns.Add("Descrizione");
            dt.Columns.Add("Codice Progetto");
            dt.Columns.Add("Codice Spesa");
            dt.Columns.Add("Importo");
            dt.Columns.Add("Unita");

            // popola la tabella
            foreach (CheckChiusura.CheckAnomalia curr in ListaAnomalie)
            {
                DataRow dr = dt.NewRow();
                dr["Data"] = curr.Data.ToShortDateString();
                dr["Codice Progetto"] = curr.ProjectCode.ToString();
                dr["Codice Spesa"] = curr.ExpenseCode.ToString();
                dr["Importo"] = curr.Amount;
                dr["Unita"] = curr.UnitOfMeasure.ToString();
                dr["Descrizione"] = curr.Descrizione.ToString();
                dt.Rows.Add(dr);

            }

        }

        if (Request.QueryString["type"] == RQS_ASSENZA) // check assenze
        {
            CheckChiusura.CheckAssenze(Session["Month"].ToString(),
                                                       Session["Year"].ToString(),
                                                       Session["persons_id"].ToString(),
                                                               ref ListaAnomalie);

            //  popola grid di visualizzazione
            dt.Reset();
            // costruisce la struttura della tabella di output
            dt.Columns.Add("Data");
            dt.Columns.Add("Causale");
            dt.Columns.Add("Nota");

            foreach (CheckChiusura.CheckAnomalia curr in ListaAnomalie)
            {
                // popola la tabella
                DataRow dr = dt.NewRow();
                dr["Data"] = curr.Data.ToShortDateString();
                dr["Causale"] = curr.ProjectName;
                dr["Nota"] = curr.Descrizione;
                dt.Rows.Add(dr);
            }
        }

        GV_anomalie.DataSource = dt;
        GV_anomalie.DataBind();

    }

}