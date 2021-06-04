using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Activity_activity_lookup_list : System.Web.UI.Page
{
    public string strMessage;
    string strQueryOrdering = " ORDER BY Activity.ActivityCode ";

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        string sC1;
        string sWhere = "";

        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        sWhere = "WHERE Projects.clientmanager_id = " + CurrentSession.Persons_id;

        // Imposta il SelectCommand in base al contenuto della lista dropdown
        if ( DL_flattivo.SelectedValue != "all" || (Session["DL_flattivo_val_att"] != null && !IsPostBack))
            sWhere = sWhere == "" ? " WHERE Activity.Active IN (@DL_flattivo) AND Projects.Active IN (@DL_flattivo)" : sWhere + " AND Activity.Active IN (@DL_flattivo) AND Projects.Active IN (@DL_flattivo)";

        if ( DL_progetto.SelectedValue != "all" || (Session["DL_progetto"] != null && !IsPostBack))
            sWhere = sWhere == "" ? " WHERE Projects.Projects_id = (@DL_progetto)" : sWhere + " AND Projects.Projects_id = (@DL_progetto)";

        if ( TB_Codice.Text != "" || (Session["TB_ActivityCode"] != null && !IsPostBack))
        { 
            sC1 = sWhere == "" ? " WHERE " : " AND ";
            sWhere = sWhere + sC1 + "Activity.ActivityCode LIKE '%' + (@TB_Codice) + '%' ";
        }

        DSAttivita.SelectCommand = "SELECT Activity.ActivityCode, Activity.Name, Activity.Active, Activity.Projects_id as Projectsid, Activity.Phase_id as Phaseid, Projects.ProjectCode + '  ' + Projects.Name AS NomeProgetto, Phase.PhaseCode + '  ' + Phase.name AS Fase, Activity.Activity_id, Activity.RevenueBudget, Activity.MargineProposta FROM Activity " +
                                   "INNER JOIN Projects ON Activity.Projects_id = Projects.Projects_Id " +
                                   "LEFT OUTER JOIN Phase ON Activity.Phase_id = Phase.Phase_id " + sWhere + strQueryOrdering;

        if (!IsPostBack && Session["GridActivityPageNumber"]  != null) {
            // Imposta indice di aginazione
            GridView1.PageIndex = Convert.ToInt32(Session["GridActivityPageNumber"].ToString());
        }

    }

    // invia all form attività, progetto e fase. progetto e fase verranno utiizzati per inizializzare
    //  la fropdonwlist che essendo a cascata non riesce ad utilizzare le normali logiche di binding
    protected void GridView1_SelectedIndexChanged(Object sender , System.EventArgs e)
    {
    var ActivityId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[0];
    var ProjectsId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[1];
    var PhaseId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[2];

    Response.Redirect("activity_lookup_form.aspx?Activity_id=" + ActivityId + "&Projects_Id=" + ProjectsId + "&Phase_Id=" + PhaseId);
    }

    protected void DL_progetto_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_progetto"] = DL_progetto.SelectedValue != "all" ? DL_progetto.SelectedValue : "";
    }

    protected void DL_flattivo_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_flattivo_val_att"] = DL_flattivo.SelectedValue != "all" ? DL_flattivo.SelectedValue : "";
    }

    protected void TB_Codice_TextChanged(Object sender, System.EventArgs e)
    {
        Session["TB_ActivityCode"] = TB_Codice.Text;
    }

    protected void TB_Codice_Load(Object sender, System.EventArgs e)
    {
        // Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["TB_ActivityCode"] != null)
            TB_Codice.Text = Session["TB_ActivityCode"].ToString();
    }

    protected void DL_progetto_DataBound(Object sender, System.EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DL_progetto"] != null)
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();
    }

    protected void DL_flattivo_Load(Object sender, System.EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DL_flattivo_val_att"]  != null)
            DL_flattivo.SelectedValue = Session["DL_flattivo_val_att"].ToString();
    }

    protected void GridView1_RowDeleting(Object sender, GridViewDeleteEventArgs e)
    {
        ValidationClass c = new ValidationClass();

        //  verifica integrità database        
        if (c.CheckExistence("Activity_id", e.Keys[0].ToString(), "Hours")) { 
            e.Cancel = true;
            // Call separate class, passing page reference, to register Client Script:
            Page lPage = this.Page;
            Utilities.CreateMessageAlert(ref lPage, "Cancellazione non possibile, attività già utilizzata su tabella ore", "strKey1");
        }
    }

    protected void GridView1_PageIndexChanging(Object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        Session["GridActivityPageNumber"] = e.NewPageIndex;
    }

}