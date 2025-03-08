using System;
using System.Data;

public partial class Templates_TemplateForm :  System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            if (Request.QueryString["Project_id"] != null)
            {
                DataRow dr = Database.GetRow("SELECT ProjectCode + ' - ' + Name FROM Projects WHERE Projects_id = " + Request.QueryString["Project_id"]);
                ProjectFrom.Text = dr[0].ToString();
            }
        }

    }

    protected void BTCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("Projects_lookup_form.aspx?ProjectCode=" + Request.QueryString["ProjectCode"]);
    }
}