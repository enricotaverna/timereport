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
    string strQueryOrdering = " ORDER BY Projects.ProjectCode, Activity.ActivityCode ";

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();

    }

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DDLManager"] != null)
            DDLManager.SelectedValue = Session["DDLManager"].ToString();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_flattivo_val_att"] != null)
            DL_flattivo.SelectedValue = Session["DL_flattivo_val_att"].ToString();

        // Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["TB_ActivityCode"] != null)
            TB_Codice.Text = Session["TB_ActivityCode"].ToString();

        // Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_progetto"] != null)
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();

        if (!IsPostBack && Session["GridActivityPageNumber"] != null)
        {
            // Imposta indice di aginazione
            GridView1.PageIndex = Convert.ToInt32(Session["GridActivityPageNumber"].ToString());
        }
    }

    // Imposta query selezione
    protected void ImpostaQuery()
    {
        string sWhere = "";

        // limita ai suoi progetti in caso di manager
        //if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        //  sWhere = "WHERE Projects.clientmanager_id = " + CurrentSession.Persons_id;    

        sWhere = " WHERE ( Projects.ClientManager_id = @Persons_id OR @Persons_id = '0'  ) " +
                 " AND ( Activity.Active = @DL_flattivo OR @DL_flattivo = '99' ) AND ( Projects.Active = @DL_flattivo OR @DL_flattivo = '99' ) " +
                 " AND ( Projects.Projects_id = (@DL_progetto) OR @DL_progetto = '0' ) AND Activity.ActivityCode LIKE '%' + (@TB_Codice) + '%' ";

        DSAttivita.SelectCommand = "SELECT Activity.ActivityCode, Activity.Name, Activity.Active, Activity.Projects_id as Projectsid, c.name as NomeManager, Activity.Phase_id as Phaseid, Projects.ProjectCode + '  ' + Projects.Name AS NomeProgetto, Phase.PhaseCode + '  ' + Phase.name AS Fase, Activity.Activity_id, Activity.RevenueBudget, Activity.MargineProposta FROM Activity " +
                                   "INNER JOIN Projects ON Activity.Projects_id = Projects.Projects_Id " +
                                   "INNER JOIN Persons as c ON c.persons_id = Projects.ClientManager_id " +
                                   "LEFT OUTER JOIN Phase ON Activity.Phase_id = Phase.Phase_id " + sWhere + strQueryOrdering;

    }

    // invia all form attività, progetto e fase. progetto e fase verranno utiizzati per inizializzare
    //  la fropdonwlist che essendo a cascata non riesce ad utilizzare le normali logiche di binding
    protected void GridView1_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        var ActivityId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[0];
        var ProjectsId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[1];
        var PhaseId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[2];

        Response.Redirect("activity_lookup_form.aspx?Activity_id=" + ActivityId + "&Projects_Id=" + ProjectsId + "&Phase_Id=" + PhaseId);
    }

    protected void DL_progetto_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_progetto"] = DL_progetto.SelectedValue;
    }

    protected void DL_flattivo_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_flattivo_val_att"] = DL_flattivo.SelectedValue;
    }

    protected void TB_Codice_TextChanged(Object sender, System.EventArgs e)
    {
        Session["TB_ActivityCode"] = TB_Codice.Text;
    }

    protected void DL_progetto_DataBound(Object sender, System.EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DL_progetto"] != null)
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();
    }

    protected void GridView1_RowDeleting(Object sender, GridViewDeleteEventArgs e)
    {
        ValidationClass c = new ValidationClass();

        //  verifica integrità database        
        if (c.CheckExistence("Activity_id", e.Keys[0].ToString(), "Hours"))
        {
            e.Cancel = true;
            // Call separate class, passing page reference, to register Client Script:
            Page lPage = this.Page;
            Utilities.CreateMessageAlert(ref lPage, "Cancellazione non possibile, attività già utilizzata su tabella ore", "strKey1");
        }
    }

    protected void DSprogetti_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        // visualizza solo progetti del manager
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {
            e.Command.Parameters["@managerid"].Value = CurrentSession.Persons_id;
            e.Command.Parameters["@selAll"].Value = 0;
        }
        else
        { // admin
            e.Command.Parameters["@managerid"].Value = "";
            e.Command.Parameters["@selAll"].Value = 1;
        }

    }

    protected void GridView1_PageIndexChanging(Object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        Session["GridActivityPageNumber"] = e.NewPageIndex;
    }

    // al cambio di DDL salva il valore 
    protected void DDLManager_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLManager"] = ddl.SelectedValue;
    }

    // Forza il valore della DDL se è un manager
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {

            DDLManager.ClearSelection();
            DDLManager.Items.FindByValue(CurrentSession.Persons_id.ToString()).Selected = true;
            DDLManager.Enabled = false;
        }
    }

}