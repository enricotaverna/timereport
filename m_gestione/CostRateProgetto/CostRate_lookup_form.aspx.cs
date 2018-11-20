using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_CostRate_lookup_list : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //	Deve avere almeno il reporting economics per visualizzare
        //  Se ha Masterdata Costrate può anche modificar
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
            Auth.CheckPermission("REPORT", "ECONOMICS");

        // Imposta query progetti
        ImpostaQuery();

        // Imposta modalità display
        SetDisplayMode();

    }

     // Imposta dinamicamente query selezione
    protected void ImpostaQuery()
    {
      
        // Se Manager posso visualizzare solo i miei progetti
        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED"))
            DSProgetti.SelectCommand = "SELECT Projects_Id, ProjectCode + N'  ' + Name AS NomeProgetto, ClientManager_id, Active FROM Projects WHERE Projects.Active = 1 AND ClientManager_id = @clientmanager_id ORDER BY NomeProgetto";
        else
            DSProgetti.SelectCommand = "SELECT Projects_Id, ProjectCode + N'  ' + Name AS NomeProgetto, ClientManager_id, Active FROM Projects WHERE Projects.Active = 1 ORDER BY NomeProgetto";       

    } 
 
    // Imposta modalità display
    protected void SetDisplayMode()
    {
        // Se richiamato con parametro imposta la modalità Edit e cambia il CommandNae del tasto "Salva"
        // Usato per non duplicate i template nella FormView a fronte degli stessi controlli
        if (!IsPostBack && Request.QueryString["ForcedAccounts_id"] != null && SchedaCostRate.CurrentMode == FormViewMode.Insert)
        {
            SchedaCostRate.ChangeMode(FormViewMode.Edit);
            SchedaCostRate.DefaultMode = FormViewMode.Edit;

            Button btn = (Button)SchedaCostRate.FindControl("UpdateButton");
            if (btn != null)
                btn.CommandName = "Update";
        }

        // Se manager cancella bottone crea
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
        {
            SchedaCostRate.ChangeMode(FormViewMode.ReadOnly);
            SchedaCostRate.DefaultMode = FormViewMode.ReadOnly;

            Button btn = (Button)SchedaCostRate.FindControl("UpdateButton");
            if (btn != null)
                btn.Enabled = false;
        }
    }

    protected void DSProject_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        e.Command.Parameters[0].Value = Session["persons_id"];
    }

    protected void SchedaCostRate_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("CostRate_list.aspx?messaggio=yes");
    }
    protected void SchedaCostRate_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("CostRate_list.aspx?messaggio=yes");
    }
    protected void SchedaCostRate_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            Response.Redirect("CostRate_list.aspx");        
    }

}