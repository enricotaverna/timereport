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

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT","ECONOMICS");

        // Popola Drop Down con lista progetti
        if (!IsPostBack) {
            // Popola dropdown con i valori          
            Bind_DDLProgetti();
            Bind_DDLAttivita();
            // recupera valori controlli
            RipristinaControlli();
        }

        // Default data
        if (TBDataA.Text == "")
            TBDataA.Text = DateTime.Now.ToString("dd/MM/yyyy");

        // Default data
        if (TBDataDA.Text == "")
            TBDataDA.Text = DateTime.Today.AddDays(1 - DateTime.Today.Day).ToString("dd/MM/yyyy");

    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {        
        Button bt = (Button) sender;

        if (bt.CommandName == "report")
            LanciaReport(EstraiDSRevenue("SPestraiRevenue"));           
    }

    DataSet EstraiDSRevenue(string strStoredProcedure)
    {

        DataSet ds = new DataSet("Export");

        // Lancia stored procedure che popola la tabella "Export" nel dataset ds
        ds = EstraiStoreProcedure(strStoredProcedure);

        // Aggiunge colonne
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine

        // Calcola colonne
        ds = CalcolaColonne(ds); 

        // torna il dataset completo    
        return (ds);

    }

    // Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    DataSet CalcolaColonne(DataSet ds)
    {

        foreach (DataRow dr in ds.Tables["Export"].Rows)
        {
            double dRevenueActual = dr["RevenueActual"] == DBNull.Value ? 0 : Convert.ToDouble(dr["RevenueActual"]);
            double dGiorniActual = dr["GiorniActual"] == DBNull.Value ? 0 : Convert.ToDouble(dr["GiorniActual"]);

            // se manca qualche dato obbligatorio mette a warning la colonna e salta i conti
            if (dRevenueActual == 0 && dGiorniActual != 0)
            {
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/warning_icon.png";
                continue;
            }
            else
            {
                dr["status"] = "G";
                dr["ImgUrl"] = "/timereport/images/icons/other/ok_icon.png";
            }

        }

        return (ds);
    }

    /* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */
    DataSet EstraiStoreProcedure(string strStoredProcedure)
    {

        DataSet ds = new DataSet("Export");

        conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        using (conn)
        {
            SqlCommand sqlComm = new SqlCommand(strStoredProcedure, conn);

            // valorizza parametri della query
            sqlComm.Parameters.AddWithValue("@DataA", Convert.ToDateTime(TBDataA.Text));
            sqlComm.Parameters.AddWithValue("@DataDA", Convert.ToDateTime(TBDataDA.Text));

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLProgetti.SelectedValue != "0")
                 sqlComm.Parameters.AddWithValue("@Project_id",  Convert.ToInt16(DDLProgetti.SelectedValue));

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLAttivita.SelectedValue != "0")
                 sqlComm.Parameters.AddWithValue("@Activity_id", Convert.ToInt16(DDLAttivita.SelectedValue));

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLManager.SelectedValue != "0")
                sqlComm.Parameters.AddWithValue("@Manager_id", Convert.ToInt16(DDLManager.SelectedValue));

            // esecuzione
            sqlComm.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = sqlComm;
            // aumenta il timeout del comando
            sqlComm.CommandTimeout = 180;

            da.Fill(ds, "Export");
        }

        return (ds);

    }    
    
    // Lancia Pagina con GridView per visualizzazione report
    protected void LanciaReport( DataSet ds) {

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        Cache.Insert("ExportRevenue", ds);
        // salva valori controlli 
        SalvaControlli();
        Response.Redirect("EstraiRevenue-list.aspx");

    }

    // salva valori dei controlli
    protected void SalvaControlli()
    {
        Session["DDLErProgetti"] = DDLProgetti.SelectedIndex;
        Session["DDLErAttivita"] = DDLAttivita.SelectedIndex;
        Session["DDLErManager"] = DDLManager.SelectedIndex;
        Session["TBErTBDataDA"] = TBDataDA.Text;
        Session["TBErTBDataA"] = TBDataA.Text;
    }


    // salva valori dei controlli
    protected void RipristinaControlli()
    {
        if (Session["DDLErProgetti"] != null) DDLProgetti.SelectedIndex = (int)Session["DDLErProgetti"];
        if (Session["DDLErAttivita"] != null) DDLAttivita.SelectedIndex = (int)Session["DDLErAttivita"];
        if (Session["DDLErManager"] != null) DDLManager.SelectedIndex = (int)Session["DDLErManager"];
        if (Session["TBErTBDataDA"] != null) TBDataDA.Text = Session["TBErTBDataDA"].ToString();
        if (Session["TBErTBDataA"] != null) TBDataA.Text = Session["TBErTBDataA"].ToString();
    }

    protected void Bind_DDLProgetti()
    {

        conn.Open();

        SqlCommand cmd;
        
        // Se manager imposta tutti i progetti di tipo FIXED di cui è responsabile
        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects WHERE ProjectType_Id=1 and active = 'true' AND ClientManager_id=" + Session["persons_id"].ToString() + " ORDER BY ProjectCode", conn);
        else
            cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects WHERE ProjectType_Id=1 and active = 'true' ORDER BY ProjectCode", conn);

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
        Bind_DDLAttivita();
    }

    // Estrae attività legate al progetto e fa il bind con la DDL
    public void Bind_DDLAttivita()
    {
        conn.Open();
        SqlCommand cmd;

        cmd = new SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS Descrizione FROM Activity where Projects_id='" + DDLProgetti.SelectedValue + "' AND active = 'true' ORDER BY ActivityCode", conn);

        SqlDataReader dr = cmd.ExecuteReader();

        DDLAttivita.DataSource = dr;
        DDLAttivita.Items.Clear();
        DDLAttivita.Items.Add(new ListItem("--Tutte le attività--", "0"));
        DDLAttivita.DataTextField = "Descrizione";
        DDLAttivita.DataValueField = "Activity_id";
        DDLAttivita.DataBind();

        conn.Close();
    }
    
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        // Se manager forza la DDL al solo valore del manager
        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            DDLManager.Items.Clear();
            DDLManager.Items.Add(new ListItem(Session["UserName"].ToString(), Session["Persons_id"].ToString()));
            DDLManager.SelectedValue = Session["Persons_id"].ToString();
        }
    }

}