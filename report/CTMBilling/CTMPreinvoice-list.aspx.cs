using System;

public partial class m_preinvoice_preinvoicelist : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT", "ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // usati per disattivare cancellazione record consuntivi
        TBUserName.Text = CurrentSession.UserName;
        TBUserLevel.Text = CurrentSession.UserLevel.ToString();

    }

    protected void btn_create_Click(object sender, EventArgs e)
    {
        // reset date creazione prefattura
        Session["PrefatturaDataDa"] = "";
        Session["PrefatturaDataA"] = "";

        Response.Redirect("/timereport/report/CTMBilling/CTMPreinvoice-select.aspx");

    }
}