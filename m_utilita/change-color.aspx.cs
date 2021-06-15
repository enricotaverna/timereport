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

        if (!IsPostBack) {
            BackgroundColor.Value = CurrentSession.BackgroundColor;
            BackgroundImg.Value = CurrentSession.BackgroundImage;
        }

    }

    protected void ButtonClick(object sender, EventArgs e)
    {
            // imposta cookie se settato colore sfondo
            if (BackgroundColor.Value != "")
            {
                Utilities.SetCookie("background-color", BackgroundColor.Value);
                CurrentSession.BackgroundColor = BackgroundColor.Value;
            }
            else { 
                CurrentSession.BackgroundColor = "";
                Utilities.SetCookie("background-color", "");
            }

            // imposta cookie se settato image
            if (BackgroundImg.Value != "")
            {
                Utilities.SetCookie("background-image", BackgroundImg.Value.Replace("\"", "'"));
                CurrentSession.BackgroundImage = BackgroundImg.Value.Replace("\"", "'");
            }
            else { 
                CurrentSession.BackgroundImage = "";
                Utilities.SetCookie("background-image", "");
            }

            // imposta il messaggio che verrò dato sulla pagina di menu
            Response.Redirect("/timereport/menu.aspx");
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}