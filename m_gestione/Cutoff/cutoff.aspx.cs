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
        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

    protected void dsOptions_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {

        DropDownList DDLPeriodo = (DropDownList)FVMain.FindControl("DDLPeriodo");
        DropDownList DDLMese = (DropDownList)FVMain.FindControl("DDLMese");
        TextBox TBanno = (TextBox)FVMain.FindControl("TBAnno");

        // imposta sessione
        Session["CutOffDate"] = Utilities.GetCutoffDate(DDLPeriodo.SelectedValue.ToString(), DDLMese.SelectedValue.ToString(), TBanno.Text, "end");

        // imposta il messaggio che verrò dato sulla pagina di menu
        Response.Redirect("/timereport/menu.aspx?msgno=200&msgtype=I");
    }
}