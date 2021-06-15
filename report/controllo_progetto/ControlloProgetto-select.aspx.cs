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

public partial class report_ControlloProgettoSelect : System.Web.UI.Page
{
    // attivata MARS 
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT", "ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Popola Drop Down con lista progetti
        if (!IsPostBack) {
            // Popola dropdown con i valori          
            Bind_DDLProgetti();
            Bind_DDLAttivita();
            // recupera valori selezioni
            RipristinaControlli();
        }

        // Default data
        if (TBDataReport.Text == "")
            TBDataReport.Text = DateTime.Now.ToString("dd/MM/yyyy");
   
    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        // salva data report utilizzata nella gridview per il drill sulle revenue
        Session["TBDataReport"] = TBDataReport.Text;

        LanciaReport(EstraiDSRevenue("SPcontrolloProgetti"));           
    }

    DataSet EstraiDSRevenue(string strStoredProcedure)
    {

        DataSet ds = new DataSet("Export");

        // Lancia stored procedure che popola la tabella "Export" nel dataset ds
        // Projects_Id, Codice+Nome progetto, Activity_id, Codice + Nome attività, ImportoRevenue (da progetto o attività), Importo spese (solo da progetto)
        // DataFine (da progetto o attività), DataInizio (da progetto o attività), Nome manager,
        // TotaleOre = Somma Ore
        // TotaleRevenue = Somma Revenue (NULL se manca qualche CostRate)
        // PrimaDataCarico = data primo carico ore
        // TotaleSpese= Somma Spese 

        ds = EstraiStoreProcedure(strStoredProcedure); 
         
        // Aggiunge colonne calcolate
        ds.Tables["Export"].Columns.Add("BurnRate", typeof(Double));
        ds.Tables["Export"].Columns.Add("MesiCopertura", typeof(Double));
        ds.Tables["Export"].Columns.Add("WriteUp", typeof(Double));
        ds.Tables["Export"].Columns.Add("Status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("ImgUrl", typeof(string)); // Url Immagine
        ds.Tables["Export"].Columns.Add("ToolTip", typeof(string)); // Commento
        ds.Tables["Export"].Columns.Add("ColoreDataFine", typeof(string)); // Colore sfondo data fine
        ds.Tables["Export"].Columns.Add("TooltipDataFine", typeof(string)); // ToolTip sfondo data fine
        ds.Tables["Export"].Columns.Add("BudgetNetto", typeof(Double)); // Budget revenue al netto del budget ABAP

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
            float dRevenueActual = dr["RevenueActual"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueActual"]);
            float dRevenueBudget = dr["RevenueBudget"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["RevenueBudget"]);
           
            // netto budget ABAP
            float dBudgetABAP = dr["BudgetABAP"] == DBNull.Value ? 0 : (float)Convert.ToDouble(dr["BudgetABAP"]);


            float dRevenueBudgetNet = RBTipoCalcolo.SelectedValue == "1" ? (float)dRevenueBudget - (float)dBudgetABAP : (float)dRevenueBudget;
            
            
            dr["BudgetNetto"] = dRevenueBudgetNet; // Budget revenue al netto del budget ABAP

            DateTime dtTBDataReport = Convert.ToDateTime(TBDataReport.Text);
            DateTime dtDataFine = dr["DataFine"] != DBNull.Value ? (DateTime)dr["DataFine"] : new DateTime(2001, 1, 1);
            DateTime dtPrimaDataCarico = dr["PrimaDataCarico"] != DBNull.Value ? (DateTime)dr["PrimaDataCarico"] : new DateTime(2001, 1, 1);


            // se manca qualche dato obbligatorio mette a warning la colonna e salta i conti
            if (dr["PrimaDataCarico"] == DBNull.Value || dr["DataFine"] == DBNull.Value ||
                dRevenueBudget == 0) 
            {
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/warning_icon.png";
                dr["ToolTip"] = "Controllare dati del progetto/attività (date, budget)";
                continue;
            }

            // se manca qualche dato obbligatorio mette a warning la colonna e salta i conti
            if (dRevenueActual == 0)
            {
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/warning_icon.png";
                dr["ToolTip"] = "Impossibile valorizzare actual, controllare FLC e margine progetto";
                continue;
            }

            // se le revenue sono > 10.000.000 la stored procedure ha forzato il valore in assenza di qualche dato di costo
            if (dRevenueActual > 10000000 )
            {
                dr["RevenueActual"] = 9999999; // forzo 99999 se mancano degli FLC e la query mi risponde un actual fuori scala
                dr["Status"] = "O";
                dr["ImgUrl"] = "/timereport/images/icons/other/warning_icon.png";
                dr["ToolTip"] = "Impossibile valorizzare actual, controllare FLC delle persone";
                continue;
            } 


            // Burn Rate = Revenue Actual / Giorni lavorativi da inizio progetto a data report
            // WriteUp/Off = Revenue Budget - Revenue Actual - (data fine - data report ) * BurnRate
           // mesi copertura =  (Revenue Budget - Revenue Actual ) / burnrate / 20
            //
  
            dr["BurnRate"] = Math.Round( dRevenueActual /
                             CommonFunction.NumeroGiorniLavorativi(dtPrimaDataCarico, Convert.ToDateTime(TBDataReport.Text)), 2); 
            
            // se la data fine è nel futuro proietta writeup e mesi di copertura
            if (dtTBDataReport < (DateTime)dr["DataFine"]) 
            {
                dr["WriteUp"] = Math.Round(dRevenueBudgetNet - dRevenueActual - CommonFunction.NumeroGiorniLavorativi(dtTBDataReport, (DateTime)dr["DataFine"]) * Convert.ToDouble(dr["BurnRate"]), 2);
                //dr["COloreDataFine"] = "#FFCC00";
                //dr["TooltipDataFine"] = "Data fine progetto nel futuro";
            }
                else 
            {
            // calcola writeup/off senza proiezione
                dr["WriteUp"] = Math.Round(dRevenueBudgetNet - dRevenueActual, 2);
            // mette in arancione lo sfondo
                dr["ColoreDataFine"] = "#FFCC00";
                dr["TooltipDataFine"] = "Progetto terminato";
            }

            // Se writeup positivo calcola mesi di copertura altrimenti li forza a zero
            if ( (double)dr["WriteUp"] > 0)
                dr["MesiCopertura"] = Math.Round(((dRevenueBudgetNet - dRevenueActual) / Convert.ToDouble(dr["BurnRate"])) / 20, 2);
            else
                dr["MesiCopertura"] = 0;

             if (Convert.ToDouble(dr["WriteUp"]) > 0){
                 dr["status"] = "G";
                 dr["ImgUrl"] = "/timereport/images/icons/other/ok_icon.png";
                 dr["ToolTip"] = "Writeup positivo!";
                 }
             else { 
                 dr["status"] = "R";
                 dr["ImgUrl"] = "/timereport/images/icons/other/ko_icon.png";
                 dr["ToolTip"] = "Writeoff negativo!";
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
            sqlComm.Parameters.AddWithValue("@DataReport", Convert.ToDateTime(TBDataReport.Text));

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLProgetti.SelectedValue != "0")
                 sqlComm.Parameters.AddWithValue("@Project_id",  Convert.ToInt16(DDLProgetti.SelectedValue));
            else
                sqlComm.Parameters.AddWithValue("@Project_id", Utilities.ListDDL(DDLProgetti, true) );

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLAttivita.SelectedValue != "0")
                 sqlComm.Parameters.AddWithValue("@Activity_id", Convert.ToInt16(DDLAttivita.SelectedValue));

            // Se DDL non valorizzata passa NULL al parametro
            if (DDLManager.SelectedValue != "0")
                sqlComm.Parameters.AddWithValue("@Manager_id", Convert.ToInt16(DDLManager.SelectedValue));

            // Tipo Calcolo
            sqlComm.Parameters.AddWithValue("@TipoCalcolo", Convert.ToInt16(RBTipoCalcolo.SelectedValue));

            // esecuzione
            sqlComm.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = sqlComm;

            da.Fill(ds, "Export");
        }

        return (ds);

    }    
    
    // Lancia Pagina con GridView per visualizzazione report
    protected void LanciaReport( DataSet ds) {

        // salva valori dei controlli 
        SalvaControlli();

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        Cache.Insert("Export", ds);
        Response.Redirect("ControlloProgetto-list.aspx");

    }     

    // salva valori dei controlli
    protected void SalvaControlli() 
    {
        Session["DDLCpProgetti"] = DDLProgetti.SelectedIndex;
        Session["DDLCpAttivita"] = DDLAttivita.SelectedIndex;
        Session["DDLCpManager"] = DDLManager.SelectedIndex;
        Session["TBCpDataReport"] = TBDataReport.Text;
        Session["RBCpTipoCalcolo"] = RBTipoCalcolo.SelectedIndex;    
    }

    // salva valori dei controlli
    protected void RipristinaControlli()
    {
        if (Session["DDLCpProgetti"] != null) DDLProgetti.SelectedIndex = (int)Session["DDLCpProgetti"];
        if (Session["DDLCpAttivita"] != null) DDLAttivita.SelectedIndex = (int)Session["DDLCpAttivita"];
        if (Session["DDLCpManager"] != null) DDLManager.SelectedIndex = (int)Session["DDLCpManager"];
        if (Session["TBCpDataReport"] != null) TBDataReport.Text = Session["TBCpDataReport"].ToString();
        if (Session["RBCpTipoCalcolo"] != null) RBTipoCalcolo.SelectedIndex = (int)Session["RBCpTipoCalcolo"];
    }

    protected void Bind_DDLProgetti()
    {

        conn.Open();

        SqlCommand cmd = null;
        
        // Se manager imposta tutti i progetti di tipo FIXED di cui è responsabile
        if (Auth.ReturnPermission("REPORT","PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            cmd = new SqlCommand("SELECT a.Projects_Id, a.ProjectCode + ' ' + left(a.Name,20) AS Descrizione FROM Projects as a" +
                                 " INNER JOIN ForcedAccounts as b ON b.Projects_id = a.Projects_id " + 
                                 " WHERE a.active = 'true' AND a.TipoContratto_id=" + ConfigurationManager.AppSettings["CONTRATTO_FIXED"] +
                                 "  AND  b.Persons_id = " + CurrentSession.Persons_id + 
                                 " ORDER BY a.ProjectCode", conn);

        // Se ADMIN imposta tutti i progetti di tipo FIXED 
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
             cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS Descrizione FROM Projects WHERE active = 'true' AND TipoContratto_id=" + ConfigurationManager.AppSettings["CONTRATTO_FIXED"] + " ORDER BY ProjectCode", conn);

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

        // Cancellata, la selezione viene fatta in base ai progetti forzati

    }

}