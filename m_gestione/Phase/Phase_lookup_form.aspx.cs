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

        // Evidenzia campi form in errore
        Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "val", "fnOnUpdateValidators();");

        Auth.CheckPermission("MASTERDATA", "WBS");

        if (!IsPostBack) 
            if (Request.QueryString["PhaseId"] != null) {
                SchedaFase.ChangeMode(FormViewMode.Edit);
                SchedaFase.DefaultMode = FormViewMode.Edit;
            }
    }

    protected void DSProject_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        // visualizza solo progetti del manager
        e.Command.Parameters[0].Value = Session["persons_id"];
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
    protected void ValidaFase_ServerValidate(object source, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();
        //      true se non esiste già il record
        args.IsValid = !c.CheckExistence("PhaseCode", args.Value, "Phase");

        //      cambia colore del campo in errore
        c.SetErrorOnField(args.IsValid, SchedaFase, "PhaseCodeTextBox");
    }
}