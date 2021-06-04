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

        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack) 
            if (Request.QueryString["PhaseId"] != null) {
                SchedaFase.ChangeMode(FormViewMode.Edit);
                SchedaFase.DefaultMode = FormViewMode.Edit;
            }
    }

    protected void DSProject_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        // visualizza solo progetti del manager
        e.Command.Parameters[0].Value = CurrentSession.Persons_id;
    }

    protected void SchedaFase_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("Phase_lookup_list.aspx?messaggio=yes");
    }
    protected void SchedaFase_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Phase_lookup_list.aspx?messaggio=yes");
    }
    protected void SchedaFase_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit) 
            Response.Redirect("Phase_lookup_list.aspx");        
    }

}