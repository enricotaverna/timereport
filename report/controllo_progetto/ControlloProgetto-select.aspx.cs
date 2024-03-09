using System;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

public partial class report_ControlloProgettoSelect : System.Web.UI.Page
{
    // attivata MARS 
    // recupera oggetto sessione
    public TRSession CurrentSession;
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);


    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT", "ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Popola Drop Down con lista progetti
        if (!IsPostBack) {
            // Popola dropdown con i valori          
            Bind_DDLProgetti();
            //Bind_DDLAttivita();
            // recupera valori selezioni
            RipristinaControlli();
        }

        // Default data
        if (TBDataReport.Text == "")
            TBDataReport.Text = CurrentSession.dCutoffDate.ToString("dd/MM/yyyy");
   
    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        // salva data report utilizzata nella gridview per il drill sulle revenue
        Session["DataReport"] = TBDataReport.Text;
        Session["ProgettoReport"] = DDLProgetti.SelectedValue;
        Session["ManagerReport"] = DDLManager.SelectedValue;
        
        Response.Redirect("ControlloProgetto-list.aspx");

    }

    // salva valori dei controlli
    protected void SalvaControlli() 
    {
        Session["DDLCpProgetti"] = DDLProgetti.SelectedIndex;
        Session["DDLCpManager"] = DDLManager.SelectedIndex;
        Session["TBCpDataReport"] = TBDataReport.Text;
    }

    // salva valori dei controlli
    protected void RipristinaControlli()
    {
        if (Session["DDLCpProgetti"] != null) DDLProgetti.SelectedIndex = (int)Session["DDLCpProgetti"];
        //if (Session["DDLCpAttivita"] != null) DDLAttivita.SelectedIndex = (int)Session["DDLCpAttivita"];
        if (Session["DDLCpManager"] != null) DDLManager.SelectedIndex = (int)Session["DDLCpManager"];
        if (Session["TBCpDataReport"] != null) TBDataReport.Text = Session["TBCpDataReport"].ToString();
        //if (Session["RBCpTipoCalcolo"] != null) RBTipoCalcolo.SelectedIndex = (int)Session["RBCpTipoCalcolo"];
    }

    protected void Bind_DDLProgetti()
    {

        conn.Open();

        SqlCommand cmd = null;
        
        // Se manager imposta tutti i progetti di tipo FIXED di cui è responsabile
        if (Auth.ReturnPermission("REPORT","PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL")) { 
            cmd = new SqlCommand("SELECT a.Projects_Id, a.ProjectCode + ' ' + left(a.Name,20) AS Descrizione FROM Projects as a" +               
                                 " WHERE a.active = 'true' " +
                                 " AND a.ClientManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + " OR a.AccountManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
                                 " AND a.ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"]  +
                                 " ORDER BY a.ProjectCode", conn);

            DDLManager.SelectedValue = CurrentSession.Persons_id.ToString();
            DDLManager.Enabled = false;
    }

        // Se ADMIN imposta tutti i progetti di tipo FIXED 
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
             cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects WHERE active = 'true' AND " +
                                  " ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"]   +
                                  " ORDER BY ProjectCode", conn);

        SqlDataReader dr = cmd.ExecuteReader();

        DDLProgetti.DataSource = dr;
        DDLProgetti.Items.Clear();
        DDLProgetti.Items.Add(new ListItem("--Tutti i progetti--", "0"));
        DDLProgetti.DataTextField = "Descrizione";
        DDLProgetti.DataValueField = "Projects_Id";
        DDLProgetti.DataBind();

        conn.Close();
    }

    protected void DDLProgetti_SelectedIndexChanged(object sender, EventArgs e)
    {
        // al cambio di valore del progetto fa il bind con le relative attività
        //Bind_DDLAttivita();
    }
   
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {

        // Cancellata, la selezione viene fatta in base ai progetti forzati

    }

}