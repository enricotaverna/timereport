using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public partial class Templates_TemplateForm : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // calcola record non valorizzati
        Label lbDaCalcolare = (Label)FVMain.FindControl("lbDaCalcolare");
        lbDaCalcolare.Text = ControlloProgetto.NumeroRecorSenzaCosti(CurrentSession.dCutoffDate, 0).ToString("#,###0") + " records";
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

    protected void DownloadButton_Click(object sender, EventArgs e)
    {

        string sQuery;

        /* scarica record con ore non valorizzate */
        sQuery = "SELECT DISTINCT Consulente, ProjectCode, NomeProgetto, TipoContratto, Director, AnnoMese, CostRate, BillRate, OreRicavi FROM v_oreWithCost WHERE Data >= " + ASPcompatility.FormatDatetimeDb(CurrentSession.dCutoffDate) +
                                         " AND ( OreRicavi = 0 or OreRicavi is null ) AND ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"];

        Utilities.ExportXls(sQuery);
    }

    protected void CalcolaButton_Click(object sender, EventArgs e)
    {
        // imposta sessione
        DateTime oldCutoffDate = CurrentSession.dCutoffDate;
        
        // calcola costi per tutti i progetti del mese da chiudere
        ControlloProgetto.CalcolaCosti(oldCutoffDate , 0, 0);

        Response.Redirect("/timereport/m_gestione/Cutoff/cutoff.aspx");
    }

    protected void dsOptions_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {

        DropDownList DDLPeriodo = (DropDownList)FVMain.FindControl("DDLPeriodo");
        DropDownList DDLMese = (DropDownList)FVMain.FindControl("DDLMese");
        TextBox TBanno = (TextBox)FVMain.FindControl("TBAnno");

        CurrentSession.dCutoffDate = Utilities.GetCutoffDate(DDLPeriodo.SelectedValue.ToString(), DDLMese.SelectedValue.ToString(), TBanno.Text, "end");
        CurrentSession.sCutoffDate = CurrentSession.dCutoffDate.ToString("d");
        Session["CurrentSession"] = CurrentSession;

        // imposta il messaggio che verrò dato sulla pagina di menu
        Response.Redirect("/timereport/menu.aspx?msgno=200&msgtype=I");
    }
}