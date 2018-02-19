using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Phase_Phase_lookup_list : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        String strQueryOrdering = " ORDER BY Phase.Projects_id, Phase.PhaseCode ";

        Auth.CheckPermission("MASTERDATA", "WBS");

    // solo attività di progetti di cui si è manager
        string sWhere = "WHERE active = 1 and activityON =1 and Projects.clientmanager_id = " + Session["persons_id"];
        
    // Imposta il SelectCommand in base al contenuto della lista dropdown
        if ( DL_progetto.SelectedValue != "all" || (Session["DL_progetto"] != null && !IsPostBack  ) )
            sWhere = sWhere + " AND Projects.Projects_id = (@DL_progetto)";        
                
        DSPhase.SelectCommand = "SELECT Phase_id, Phase.PhaseCode + ' : ' + Phase.Name as NomeFase, Phase.Projects_id, Projects.ProjectCode + ' : ' + Projects.Name AS NomeProgetto FROM Phase INNER JOIN Projects ON Phase.Projects_id = Projects.Projects_Id "  + sWhere + strQueryOrdering;    
    
    }

protected void  DL_progetto_SelectedIndexChanged1(object sender, EventArgs e)
{
    if ( DL_progetto.SelectedValue != "all")  
        Session["DL_progetto"] = DL_progetto.SelectedValue;
    else
         Session["DL_progetto"] = null;

}
protected void  DL_progetto_DataBound(object sender, EventArgs e)
{
// Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
   if ( !IsPostBack && Session["DL_progetto"] != null )
        DL_progetto.SelectedValue = Session["DL_progetto"].ToString();
}


protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
{

    ValidationClass c = new ValidationClass();
    Page lPage;     

//       verifica integrità database        
        if ( c.CheckExistence("Phase_id", (string)e.Keys[0].ToString(), "Activity") ) {
            e.Cancel = true;
//          Call separate class, passing page reference, to register Client Script:
            lPage = this.Page;
            Utilities.CreateMessageAlert(ref lPage, "Cancellazione non possibile, fase utilizzata su attività", "strKey1");
        }

}

protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
{
    Response.Redirect("phase_lookup_form.aspx?PhaseId=" + GridView1.SelectedValue);     
}
}