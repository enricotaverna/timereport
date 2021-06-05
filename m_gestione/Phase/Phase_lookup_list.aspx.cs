using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Phase_Phase_lookup_list : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        string sWhere = "";

        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DL_progetto"] != null ) {
            DL_progetto.DataBind();
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();
//            sWhere = " AND p.Projects_id = " + Session["DL_progetto"].ToString();
        }

        // Imposta il SelectCommand in base al contenuto della lista dropdown
        if (DL_progetto.SelectedValue != "" )
            sWhere = " AND p.Projects_id = " + ASPcompatility.FormatStringDb(DL_progetto.SelectedValue);

        // admin
        if (Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            DSPhase.SelectCommand = "SELECT Phase_id, Phase.PhaseCode + ' : ' + Phase.Name as NomeFase, c.name as NomeManager, Phase.Projects_id, p.ProjectCode + ' : ' + p.Name AS NomeProgetto FROM Phase INNER JOIN Projects as p ON Phase.Projects_id = p.Projects_Id " +
                                " INNER JOIN Persons as c ON c.persons_id = p.ClientManager_id " +
                                " WHERE p.active = 1 and activityON = 1 " + sWhere +
                                " ORDER BY Phase.Projects_id, Phase.PhaseCode ";
        else // manager
            DSPhase.SelectCommand = "SELECT Phase_id, Phase.PhaseCode + ' : ' + Phase.Name as NomeFase, c.name as NomeManager, Phase.Projects_id, p.ProjectCode + ' : ' + p.Name AS NomeProgetto FROM Phase INNER JOIN Projects as p ON Phase.Projects_id = p.Projects_Id " +
                                " INNER JOIN Persons as c ON c.persons_id = p.ClientManager_id " +
                                " WHERE p.active = 1 and activityON = 1 and p.clientmanager_id = " + CurrentSession.Persons_id + sWhere +
                                " ORDER BY Phase.Projects_id, Phase.PhaseCode ";

        GVList.DataBind();
    }

    protected void DSprogetti_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        // visualizza solo fasi del manager
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {
            e.Command.Parameters["@ClientManager_id"].Value = CurrentSession.Persons_id;
            e.Command.Parameters["@selAll"].Value = 0;
        }
        else
        { // admin
            e.Command.Parameters["@ClientManager_id"].Value = "";
            e.Command.Parameters["@selAll"].Value = 1;
        }

    }

    protected void DL_progetto_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DL_progetto"] = DL_progetto.SelectedValue;
    }

    protected void GVList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

        ValidationClass c = new ValidationClass();
        Page lPage;

        //       verifica integrità database        
        if (c.CheckExistence("Phase_id", (string)e.Keys[0].ToString(), "Activity"))
        {
            e.Cancel = true;
            //          Call separate class, passing page reference, to register Client Script:
            lPage = this.Page;
            Utilities.CreateMessageAlert(ref lPage, "Cancellazione non possibile, fase utilizzata su attività", "strKey1");
        }

    }

    protected void GVList_SelectedIndexChanged(object sender, EventArgs e)
    {
        Response.Redirect("phase_lookup_form.aspx?PhaseId=" + GVList.SelectedValue);
    }
}