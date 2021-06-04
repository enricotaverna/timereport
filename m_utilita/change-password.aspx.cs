using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;

public partial class Templates_TemplateForm : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("BASE", "MENU");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"]; 
    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        { 
         // se arriva qui le validazioni sono ok
         Database.ExecuteSQL("UPDATE Persons SET password = '" + TBNewPwd1.Text + "' WHERE persons_id=" + CurrentSession.Persons_id, this.Page);
        
        // imposta il messaggio che verrò dato sulla pagina di menu
        Response.Redirect("/timereport/menu.aspx?msgno=400&msgtype=I");

        }
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}