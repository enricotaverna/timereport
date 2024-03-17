using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    public EconomicsProgetto ProgettoCorrente;

    private string prevPage = String.Empty;
    public List<SqlParameter> parametersList = new List<SqlParameter>();

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            //if (Request.QueryString["Projectcode"] != null)
            //{
            //    FVProgetto.ChangeMode(FormViewMode.Edit);
            //    FVProgetto.DefaultMode = FormViewMode.Edit;
            //}
            prevPage = Request.UrlReferrer.ToString();

            LoadFormData();

            Session["ProgettoCorrente"] = ProgettoCorrente;

        }
    }

    protected void LoadFormData()
    {

        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");

        // calcola i dati actual del progetto e popola l'oggeto EconomicsProgettoCorrente
        ProgettoCorrente = new EconomicsProgetto(Session["DataReport"].ToString(), TProjects_Id.Value);

        // DATA PRIMO CARICO
        TextBox TBAttivoDa = (TextBox)FVProgetto.FindControl("TBAttivoDa");
        TBAttivoDa.Text = ProgettoCorrente.PrimaDataCarico.ToString("dd/MM/yyyy");

        // REVENUE ACTUAL 
        TextBox TBRevenueActual = (TextBox)FVProgetto.FindControl("TBRevenueActual");
        TBRevenueActual.Text = ProgettoCorrente.RevenueActual.ToString("#,###;0");

        // SPESEACTUAL 
        TextBox TBSpeseActual = (TextBox)FVProgetto.FindControl("TBSpeseActual");
        TBSpeseActual.Text = ProgettoCorrente.SpeseActual.ToString("#,###;0");

        // GIORNI ACTUAL 
        TextBox TBGiorniActual = (TextBox)FVProgetto.FindControl("TBGiorniActual");
        TBGiorniActual.Text = ProgettoCorrente.GiorniActual.ToString("#,###;0");

        // WRITEUP
        TextBox TBWriteUp = (TextBox)FVProgetto.FindControl("TBWriteUp");
        TBWriteUp.Text = ProgettoCorrente.WriteUp.ToString("#,###;-#,###;0");

        // MESI COPERTURA
        TextBox TBMesiCopertura = (TextBox)FVProgetto.FindControl("TBMesiCopertura");
        TBMesiCopertura.Text = ProgettoCorrente.MesiCopertura.ToString("#,###.##;0");

        // popola tabella costi e billrate            
        GridView GVConsulenti = (GridView)FVProgetto.FindControl("GVConsulenti");

        DataTable dt = Database.GetData("SELECT DISTINCT Consulente, YEAR(Data) as Anno ,FORMAT(SUM(giorni) , 'N1', 'it-IT') as Giorni, FORMAT(CostRate, 'N0') + ' €' as CostRate , FORMAT(BillRate, 'N0') + ' €' as BillRate FROM v_oreWithCost " +
                                                   "WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) +
                                                   " AND Data <= " + ASPcompatility.FormatDateDb(Session["DataReport"].ToString())  +
                                                   " GROUP BY Consulente, YEAR(Data), CostRate, BillRate", null);

        GVConsulenti.DataSource = dt;
        GVConsulenti.DataBind();

        CalcolaActuals( TProjects_Id.Value);
    }

    // Actual
    private void CalcolaActuals(string Projects_id)
    {
        // popola tabella gg actuals          
        GridView GVGGActuals = (GridView)FVProgetto.FindControl("GVGGActuals");

        parametersList.Add(new SqlParameter("@Project_id", Projects_id));
        parametersList.Add(new SqlParameter("@DataReport", DateTime.Now));
        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        GVGGActuals.DataSource = Database.ExecuteStoredProcedure("SPcontrolloprogetti_giorniACT", parameters);
        GVGGActuals.DataBind();
    }

    // Bottoni
    protected void Download_ore_costi(object sender, EventArgs e)
    {
        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");
        Utilities.ExportXls("SELECT * FROM v_oreWithCost  WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) + " ORDER BY Data, Consulente");
    }

    protected void Download_GGActuals(object sender, EventArgs e)
    {
        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");

        parametersList.Add(new SqlParameter("@Project_id", TProjects_Id.Value));
        parametersList.Add(new SqlParameter("@DataReport", Convert.ToDateTime(Session["DataReport"].ToString())));
        SqlParameter[] parameters = parametersList.ToArray();

        // Esecuzione della stored procedure e ottenimento del risultato come DataSet
        Utilities.StreamOut(Database.ExecuteStoredProcedure("SPcontrolloprogetti_giorniACT", parameters));

    }

    protected void DSprojects_Insert(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
    }

    protected void DSprojects_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
    }

    protected void FVProgetto_ItemUpdated(Object sender, System.Web.UI.WebControls.FormViewUpdatedEventArgs e)
    {
        Response.Redirect("ControlloProgetto-list.aspx");
    }

    protected void FVProgetto_ModeChanging(Object sender, System.Web.UI.WebControls.FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("ControlloProgetto-list.aspx");
    }

    protected void ValidaProgetto_ServerValidate(Object sender, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();

        // true se non esiste già il record
        args.IsValid = !c.CheckExistence("ProjectCode", args.Value, "Projects");

        // Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, FVProgetto, "TBProgetto");
    }

    protected void FormattaTabellaOutput(GridViewRowEventArgs tab, string formato) 
    {

        decimal value;

        if (tab.Row.RowType == DataControlRowType.DataRow)
        {
            //** formattazione **/
            // Itera attraverso le celle della riga
            foreach (TableCell cell in tab.Row.Cells)
            {
                // Controlla se il valore della cella può essere convertito in un numero
                if (decimal.TryParse(cell.Text, out value))
                {
                    // Formatta il valore con due decimali
                    cell.Text = value.ToString(formato);
                }
                else if (cell.Text == "0") // Se il valore è zero
                {
                    // Imposta il testo della cella a uno spazio
                    cell.Text = "&nbsp;";
                }
            }
        }

    }

    protected void GVConsulenti_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            FormattaTabellaOutput(e, "#.#");

            // formattazione campo
            //string costrate = e.Row.Cells[2].Text == "0" || e.Row.Cells[2].Text == "&nbsp;" ? "" : e.Row.Cells[2].Text;
            //string billrate = e.Row.Cells[3].Text == "0,0000" || e.Row.Cells[3].Text == "&nbsp;" ? "" : e.Row.Cells[3].Text;
            string costrate = e.Row.Cells[3].Text;
            string billrate = e.Row.Cells[4].Text;


            // se costo o bill rate sono a zero
            if (ProgettoCorrente.TipoContratto == "FORFAIT" && costrate == "0 €" || ProgettoCorrente.TipoContratto == "T&M" && (costrate == "0 €" || billrate == "0 €"))
            {
                e.Row.Cells[0].ForeColor = e.Row.Cells[1].ForeColor = e.Row.Cells[2].ForeColor = e.Row.Cells[3].ForeColor = System.Drawing.Color.Red; // Cambia il colore della cella in rosso                                                          
            }
        }
    }

    protected void GVGGActuals_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        FormattaTabellaOutput(e, "0.##");
    }

    protected void btn_calc_Click(object sender, EventArgs e)
    {
        // imposta sessione
        EconomicsProgetto ProgettoCorrente = (EconomicsProgetto)Session["ProgettoCorrente"];

        // calcola costi per tutti i progetti del mese da chiudere
        ControlloProgetto.CalcolaCosti(ProgettoCorrente.PrimaDataCarico, ProgettoCorrente.Projects_Id, 1);  // data, progetto, overwrite

        Response.Redirect("/timereport/report/controllo_progetto/ControlloProgetto-form.aspx?ProjectCode=" + ProgettoCorrente.ProjectCode);
    }

}