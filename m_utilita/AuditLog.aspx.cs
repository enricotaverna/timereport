using System;

public partial class AuditLog : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        switch (Request.QueryString["TableName"])
        {

            case "Expenses":
                CancelButton.PostBackUrl = "/timereport/input-spese.aspx?action=fetch&expenses_id=" + Request.QueryString["RecordId"];
                break;

            case "Hours":
                CancelButton.PostBackUrl = "/timereport/input-ore.aspx?action=fetch&Hours_id=" + Request.QueryString["RecordId"];
                break;

            case "Projects":
                CancelButton.PostBackUrl = "/timereport/m_gestione/Project/Projects_lookup_form.aspx?ProjectCode=" + Request.QueryString["ProjectCode"];
                break;

        }
    }
}
