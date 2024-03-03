using System;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    public EconomicsProgetto ProgettoCorrente;

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
            //if (Request.QueryString["Projectcode"] != null)
            //{
            //    FVProgetto.ChangeMode(FormViewMode.Edit);
            //    FVProgetto.DefaultMode = FormViewMode.Edit;
            //}
            prevPage = Request.UrlReferrer.ToString();

            LoadFormData();                 
        }
    }

    protected void LoadFormData() {

        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");

        // calcola i dati actual del progetto e popola l'oggeto EconomicsProgettoCorrente
        ProgettoCorrente = new EconomicsProgetto(Session["DataReport"].ToString(), TProjects_Id.Value );

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
        GVConsulenti.DataSource = Database.GetData("SELECT DISTINCT Consulente, FORMAT(SUM(giorni) , 'N2')as Giorni, FORMAT(CostRate, 'N0') + ' €' as CostRate , FORMAT(BillRate, 'N0') + ' €' as BillRate FROM v_oreWithCost WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) +
                                                   " GROUP BY Consulente, CostRate, BillRate", null);
        GVConsulenti.DataBind();

    }

    // Bottoni
    protected void Download_ore_costi(object sender, EventArgs e)
    {
        HiddenField TProjects_Id = (HiddenField)FVProgetto.FindControl("TBProjects_id");
        Utilities.ExportXls("SELECT * FROM v_oreWithCost  WHERE Projects_id = " + ASPcompatility.FormatStringDb(TProjects_Id.Value) + " ORDER BY Data, Consulente");
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

    protected void GVConsulenti_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            string costrate = e.Row.Cells[2].Text == "0,0000" || e.Row.Cells[2].Text == "&nbsp;" ? "" : e.Row.Cells[2].Text;
            string billrate = e.Row.Cells[3].Text == "0,0000" || e.Row.Cells[3].Text == "&nbsp;" ? "" : e.Row.Cells[3].Text;

            // se costo o bill rate sono a zero
            if (ProgettoCorrente.TipoContratto == "FORFAIT" &&  costrate == "" || ProgettoCorrente.TipoContratto == "T&M" && (costrate == "" || billrate== "" ))
            {
                e.Row.Cells[0].ForeColor = e.Row.Cells[1].ForeColor = e.Row.Cells[2].ForeColor = e.Row.Cells[3].ForeColor = System.Drawing.Color.Red; // Cambia il colore della cella in rosso                                                          
            }
        }
        }

    }