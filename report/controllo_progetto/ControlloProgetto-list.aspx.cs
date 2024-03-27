using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class report_ControlloProgettoList : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {

        // richima storage procedure per popolare la tabella con i valori degli economics di peogetto
        DataSet ds = ControlloProgetto.PopolaDataset(Session["DataReport"].ToString(), Session["ProgettoReport"].ToString(), Session["ManagerReport"].ToString());

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {

            GVAttivita.DataSource = ds;
            Session["dsGVAttivita"] = ds;
            GVAttivita.DataBind();

            // Valorizza indirizzo pagina chiamante
            btn_back.OnClientClick = "window.location='/timereport/report/controllo_progetto/ControlloProgetto-select.aspx'; return(false);";
        }
    }

    // gestisce click su codice progetto per vedere dettaglio  
    protected void LkProgetto_Click(object sender, EventArgs e)
    {

        // recupera i parametri dal linkbutton premuto
        LinkButton LkBt = (LinkButton)sender;
        string arg = LkBt.CommandArgument.ToString();

        Response.Redirect("/timereport/m_gestione/Project/Projects_lookup_form.aspx?ProjectCode=" + arg);

    }

    protected void GVAttivita_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        decimal value;

        // se costo o bill rate sono a zero
        if (e.Row.RowType == DataControlRowType.DataRow)

            if (decimal.TryParse(e.Row.Cells[10].Text, out value)) {
                
                if(value < 0)
                    e.Row.Cells[10].ForeColor = System.Drawing.Color.Red; // Cambia il colore della cella in rosso 
            }

    }

}
