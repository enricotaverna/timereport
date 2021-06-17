using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public partial class report_esportaAttivita : System.Web.UI.Page
{
    // attivata MARS 
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            /* Popola dropdown con i valori        */
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectYears(ref DDLToYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth);
            ASPcompatility.SelectMonths(ref DDLToMonth);

            Bind_DDLProgetti();
            Bind_DDLFasi();
            Bind_DDLAttivita();
        }
    }

    protected string addclause(string strInput, string toAdd)
    {
        if (strInput != "")
            strInput = strInput + " AND ";

        return (strInput + toAdd);

    }

    protected void sottometti_Click(object sender, System.EventArgs e)
    {

        Button bt = (Button)sender;

        if (bt.CommandName == "report")
        {
            {
                switch (RBTipoReport.SelectedIndex)
                {
                    case 0:
                        LanciaReport(EstraiDSAttivitaTotale("SPattivitaTotale"));
                        break;
                    case 1:
                        LanciaReport(EstraiDSAttivitaTotale("SPattivitaPersone"));
                        break;
                }
            }
        }
    }

    DataSet EstraiDSAttivitaTotale(string strStoredProcedure)
    {

        /* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */

        DataSet ds = new DataSet("Export");
        DateTime DateFrom = new DateTime(Convert.ToInt16(DDLFromYear.SelectedValue), Convert.ToInt16(DDLFromMonth.SelectedValue), 1);
        DateTime DateTo = new DateTime(Convert.ToInt16(DDLToYear.SelectedValue), Convert.ToInt16(DDLToMonth.SelectedValue), ASPcompatility.DaysInMonth(Convert.ToInt16(DDLToMonth.SelectedValue), Convert.ToInt16(DDLToYear.SelectedValue)));

        conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        using (conn)
        {
            SqlCommand sqlComm = new SqlCommand(strStoredProcedure, conn);

            // valorizza parametri della query
            sqlComm.Parameters.AddWithValue("@startdate", DateFrom);
            sqlComm.Parameters.AddWithValue("@enddate", DateTo);

            sqlComm.Parameters.AddWithValue("@sprojects_id", Convert.ToInt16(DDLProgetti.SelectedValue));
            sqlComm.Parameters.AddWithValue("@sphase_id", Convert.ToInt16(DDLFasi.SelectedValue));
            sqlComm.Parameters.AddWithValue("@sactivity_id", Convert.ToInt16(DDLAttivita.SelectedValue));

            // esecuzione
            sqlComm.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = sqlComm;

            da.Fill(ds, "export");
        }

        return (ds);
    }

    protected void LanciaReport(DataSet ds)
    {

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */

        Cache.Insert("export", ds);
        Response.Redirect("ReportAttivita-list.aspx");

    }

    protected void Bind_DDLProgetti()
    {

        conn.Open();

        SqlCommand cmd;

        // imposta selezione progetti in base all'utente

        if (!CurrentSession.ForcedAccount)
            cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects WHERE active = 'true' AND activityOn = 'true' ORDER BY ProjectCode", conn);
        else
            cmd = new SqlCommand("SELECT Projects.Projects_Id, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects " +
                                       " INNER JOIN ForcedAccounts ON Projects.Projects_id = ForcedAccounts.Projects_id " +
                                       " WHERE ForcedAccounts.Persons_id=" + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
                                       " AND active = 'true' AND activityOn = 'true' ORDER BY Projects.ProjectCode", conn);

        SqlDataReader dr = cmd.ExecuteReader();

        DDLProgetti.DataSource = dr;
        DDLProgetti.Items.Clear();
        DDLProgetti.Items.Add(new ListItem("--seleziona progetto--", "0"));
        DDLProgetti.DataTextField = "Descrizione";
        DDLProgetti.DataValueField = "Projects_Id";
        DDLProgetti.DataBind();

        conn.Close();
    }

    public void Bind_DDLAttivita()
    {
        conn.Open();
        SqlCommand cmd;

        if (DDLFasi.SelectedValue != "")
            cmd = new SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS Descrizione FROM Activity where Phase_id='" + DDLFasi.SelectedValue + "' AND active = 'true' ORDER BY ActivityCode", conn);
        else
            cmd = new SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS Descrizione FROM Activity where Projects_id='" + DDLProgetti.SelectedValue + "' AND active = 'true' ORDER BY ActivityCode", conn);

        SqlDataReader dr = cmd.ExecuteReader();

        DDLAttivita.DataSource = dr;
        DDLAttivita.Items.Clear();
        DDLAttivita.Items.Add(new ListItem("--seleziona attività--", "0"));
        DDLAttivita.DataTextField = "Descrizione";
        DDLAttivita.DataValueField = "Activity_id";
        DDLAttivita.DataBind();

        conn.Close();
    }

    public void Bind_DDLFasi()
    {
        conn.Open();

        SqlCommand cmd = new SqlCommand("select Phase_id, PhaseCode + '  ' + left(Name,20) AS Descrizione FROM Phase where Projects_id='" + DDLProgetti.SelectedValue + "' ORDER BY PhaseCode", conn);
        SqlDataReader dr = cmd.ExecuteReader();

        DDLFasi.DataSource = dr;
        DDLFasi.Items.Clear();
        DDLFasi.Items.Add(new ListItem("--seleziona fase--", "0"));
        DDLFasi.DataTextField = "Descrizione";
        DDLFasi.DataValueField = "Phase_id";
        DDLFasi.DataBind();

        conn.Close();
    }

    protected void DDLProgetti_SelectedIndexChanged(object sender, EventArgs e)
    {
        Bind_DDLFasi();
        Bind_DDLAttivita();
    }
    protected void DDLFasi_SelectedIndexChanged(object sender, EventArgs e)
    {
        Bind_DDLAttivita();
    }

}