using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    private string prevPage = String.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            if (Request.QueryString["Projectcode"] != null)
            {
                FVProgetto.ChangeMode(FormViewMode.Edit);
                FVProgetto.DefaultMode = FormViewMode.Edit;
            }
            prevPage = Request.UrlReferrer.ToString();
        }
    }

    protected void FVProgetto_ItemUpdated(Object sender, System.Web.UI.WebControls.FormViewUpdatedEventArgs e)
    {
        Response.Redirect("projects_lookup_list.aspx");
    }

    protected void FVProgetto_ItemInserted(Object sender, System.Web.UI.WebControls.FormViewInsertedEventArgs e)
    {
        Response.Redirect("projects_lookup_list.aspx");
    }

    protected void FVProgetto_ModeChanging(Object sender, System.Web.UI.WebControls.FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("projects_lookup_list.aspx");
    }

    protected void ValidaProgetto_ServerValidate(Object sender, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();

        // true se non esiste già il record
        args.IsValid = !c.CheckExistence("ProjectCode", args.Value, "Projects");

        // Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, FVProgetto, "TBProgetto");
    }

}