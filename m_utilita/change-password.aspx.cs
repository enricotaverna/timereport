using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Threading;

public partial class Templates_TemplateForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void ValidaOldPwd(object source, ServerValidateEventArgs args)
    {
            if ( !Database.RecordEsiste("SELECT * FROM Persons WHERE Persons_id = " + Session["persons_id"] + " AND password='" + TBOldPwd.Text +"'"))
            args.IsValid = false;
        else
            args.IsValid = true;
    }

    protected void ValidaNewPwd(object source, ServerValidateEventArgs args)
    {
        args.IsValid = true;

        if ( TBNewPwd1.Text != TBNewPwd2.Text)
        {
            CV_NewPwd.ErrorMessage = GetLocalResourceObject("ErroreMatch").ToString();
            args.IsValid = false;
        }

        if (TBNewPwd1.Text.Length < 4 )
        {
            CV_NewPwd.ErrorMessage = GetLocalResourceObject("Errorelunghezza").ToString();
            args.IsValid = false;
        }

    }

    protected void InsertButton_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        { 
         // se arriva qui le validazioni sono ok
         Database.ExecuteSQL("UPDATE Persons SET password = '" + TBNewPwd1.Text + "' WHERE persons_id=" + Session["persons_id"], this.Page);
        
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