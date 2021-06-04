using System;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Globalization;
using System.Collections.Generic;

public partial class calendario_generaFestivi : System.Web.UI.Page
{
    // attivata MARS 
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("CONFIG", "TABLE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Popola Drop Down con lista progetti
        if (!IsPostBack)
        {
            // Popola dropdown con i valori          
            Bind_DDLMesi();
            Bind_DDLAnni();
        }
        else
        {
            // salva default di selezione
            SaveSelections();
        }
    }

    protected void SaveSelections()
    {
        List<string> lsValoriSelezionati = new List<string>();
        List<string> lsLivelliSelezionati = new List<string>();

        lsValoriSelezionati.Clear();
        foreach (ListItem i in LBPersone.Items) {
            if (i.Selected)
                lsValoriSelezionati.Add(i.Value.ToString());
        }
        Session["ValoriSelezionati"] = lsValoriSelezionati;

        lsLivelliSelezionati.Clear();
        foreach (ListItem i in LBLivello.Items)
        {
            if (i.Selected)
                lsLivelliSelezionati.Add(i.Value.ToString());
        }
        Session["LivelliSelezionati"] = lsLivelliSelezionati;

    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {        
        Button bt = (Button) sender;

        if (bt.CommandName == "report")
            LanciaReport(Elabora());           
    }

    DataSet Elabora()
    {

        string dataA, dataDa;
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        // crea dataset export per risultati della procedura
        DataSet ds = new DataSet("Export");
        DataTable dtExport = new DataTable("Export");

        ds.Tables.Add(dtExport);
        ds.Tables["Export"].Columns.Add("status", typeof(Char)); // G = Green R = Red O = Orange
        ds.Tables["Export"].Columns.Add("imgUrl", typeof(string)); // Url Immagine
        ds.Tables["Export"].Columns.Add("message", typeof(string)); // Messaggio

        // calcola intervallo date
        if (DDLMese.SelectedValue != "")
        {
            dataDa = "01/" + DDLMese.SelectedValue + "/" + DDLAnno.SelectedValue;
            dataA = ASPcompatility.LastDay(Convert.ToInt32(DDLMese.SelectedValue), Convert.ToInt32(DDLAnno.SelectedValue)) + "/" + DDLMese.SelectedValue + "/" + DDLAnno.SelectedValue;
        }
        else
        {
            dataDa = "01/01/" + DDLAnno.SelectedValue;
            dataA = "31/12/" + DDLAnno.SelectedValue;
        }

        // carica la tabella con i giorni festivi (per tutti i calendari)
         string cmd = "SELECT Calendar_id, FORMAT(calDay,'dd/MM/yyyy') as CalDay " +
                      " FROM calendarHolidays " +
                      " WHERE calDay >= " + ASPcompatility.FormatDateDb(dataDa) +
                      " AND calDay <= " + ASPcompatility.FormatDateDb(dataA);
        DataTable dtFestivi = Database.GetData(cmd, null);

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            connection.Open();

            // loop sulle persone
            foreach (ListItem itPersona in LBPersone.Items )
            {

            if (!itPersona.Selected)
                continue;

            // recupera il calendario associtato alla persona
            DataRow drCal = Database.GetRow("SELECT calendar_id, name,userLevel_id, contractHours FROM Persons WHERE persons_id=" + ASPcompatility.FormatStringDb(itPersona.Value.ToString()), null);
            string sCal = drCal["calendar_id"].ToString();
            string iUserLevel = drCal["userLevel_id"].ToString();
            int iContractHours = (int)drCal["contractHours"];

            bool bSkip = false;                
            foreach ( ListItem i in LBLivello.Items)
            {
                    if (i.Value == iUserLevel && !i.Selected)
                    {
                        bSkip = true;
                        continue;
                    }
            }

            if (bSkip)
                {
                    addRecord(ds, drCal["name"] + ": non selezionato per update.", "O");
                    continue;
                }

            // carica tutte i record della persona nel periodo
            cmd = "SELECT FORMAT(date,'dd/MM/yyyy') as date FROM Hours AS a " +
                  "INNER JOIN calendarHolidays AS b ON b.calDay = a.date " +
                    "WHERE calendar_id = '" + sCal + "'" +
                    " AND persons_id = " + ASPcompatility.FormatStringDb(itPersona.Value.ToString()) +
                    " AND projects_id = '" + ConfigurationManager.AppSettings["FESTIVI_PROJECT"] + "' " +
                    " AND date >= " + ASPcompatility.FormatDateDb(dataDa) +
                    " AND date <= " + ASPcompatility.FormatDateDb(dataA);
            DataTable dtOre = Database.GetData(cmd, null);

            // loop sui record della festivi
            int iRec = 0;
            int iTot = 0;
            bool bErr = false;

                foreach (DataRow drFestivo in dtFestivi.Rows)
                {

                    DataRow[] drResults;

                    if (drFestivo["calendar_id"].ToString() == sCal)
                    {
                        iTot++;
                        drResults = dtOre.Select("date = '" + drFestivo["calDay"].ToString()+"'");
                        if (drResults.Length == 0)
                        {
                            // not found -> create record
                            iRec++;

                            // trova la società legata all'utente
                            DataRow dr = Database.GetRow("SELECT company_id FROM Persons WHERE Persons_id = " + ASPcompatility.FormatStringDb(ConfigurationManager.AppSettings["FESTIVI_PROJECT"]), null);
                            var result = Utilities.GetManagerAndAccountId(Convert.ToInt32(ConfigurationManager.AppSettings["FESTIVI_PROJECT"]));

                            using (SqlCommand cmdsql = new SqlCommand("INSERT INTO Hours (persons_id, projects_id, HourType_Id, date, hours,createdBy, creationDate, ClientManager_id, AccountManager_id, Company_id) " + 
                                                                       "VALUES ('" + itPersona.Value.ToString() + "', '" + 
                                                                       ConfigurationManager.AppSettings["FESTIVI_PROJECT"]  + 
                                                                       "', '1'," + 
                                                                       ASPcompatility.FormatDateDb(drFestivo["calDay"].ToString()) + 
                                                                       " , " + ASPcompatility.FormatNumberDB(iContractHours) + " ," +
                                                                       ASPcompatility.FormatStringDb(Session["UserId"].ToString()) + " , " + 
                                                                       ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"),true) + " , " +
                                                                       ASPcompatility.FormatNumberDB(result.Item1) + " , " + // ClientManager_Id
                                                                       ASPcompatility.FormatNumberDB(result.Item2) + " , " + // AccountManager_Id
                                                                       ASPcompatility.FormatStringDb(dr["Company_id"].ToString()) + 
                                                                       ")", connection))
                                {
                                try
                                {
                                    cmdsql.ExecuteNonQuery();
                                }
                                catch (Exception ex)
                                {
                                    bErr = true;
                                }
                            }
                        }
                    }    // endloop festivi                 
                }

                if (bErr)
                    addRecord(ds, drCal["name"] + ": errore in creazione dei record.", "O");
                else if (iTot == 0)
                    addRecord(ds, drCal["name"] + ": nessun festivo nel calendario.", "O");
                else if (iRec == iTot)
                    addRecord(ds, drCal["name"] + ": sono stati creati " + iRec.ToString() + " record.", "G");
                else
                    addRecord(ds, drCal["name"] + ": festivi già caricati.", "O");

            } // foreach Persons
            }   // using connection

        // torna il dataset completo    
        return (ds);

    }

    // Calcola colonne aggiuntive report non valorizzate dalla storage procedure
    DataSet addRecord(DataSet ds, string message, string status)
    {
        DataRow drRow = ds.Tables["Export"].NewRow();
    
        drRow["message"] = message;
        drRow["status"] = status;

        if (status == "G")
            drRow["imgUrl"] = "/timereport/images/icons/other/ok_icon.png";
        else
            drRow["imgUrl"] = "/timereport/images/icons/other/warning_icon.png";

        ds.Tables["Export"].Rows.Add(drRow);

        return (ds);
    }

    /* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */
    protected void CreaRecord( string persons_id, string dateToInsert)
    {

        // inserisce spese
        //Database.ExecuteSQL();

    }

    // Lancia Pagina con GridView per visualizzazione report
    protected void LanciaReport( DataSet ds) {

        /* Salva dataset in cache e lancia pagina con ListView per visualizzare risultati */
        Cache.Insert("Festivi", ds);
        // salva valori controlli 
        //SalvaControlli();
        Response.Redirect("GeneraFestivi-list.aspx");

    }

    // Popola controllo Mesi
    protected void Bind_DDLMesi()
    {

        DDLMese.Items.Clear();

        DDLMese.Items.Add(new ListItem("-- tutti i mesi --", ""));

        for (int i = 1; i <= 12; i++)
        {
            string monthName = new DateTime(2016, i, 1).ToString("MMMM", CultureInfo.CreateSpecificCulture("it"));
            DDLMese.Items.Add(new ListItem(monthName, i.ToString("00")));
        }

        // default
        if (Session["DDLMesi"] == null) DDLMese.SelectedValue = DateTime.Now.Month.ToString();
    }

    // Popola controllo Anni
    public void Bind_DDLAnni()
    {
        DDLAnno.Items.Clear();

        for (int i = MyConstants.Last_year-1; i <= MyConstants.Last_year+1; i++)
            DDLAnno.Items.Add(new ListItem(i.ToString(), i.ToString()));

        // default
        if (Session["DDLAnno"] == null) DDLAnno.SelectedValue = MyConstants.Last_year.ToString();
    }

    // salva valori dei controlli
    protected void SalvaControlli()
    {
        Session["DDLAnno"] = DDLAnno.SelectedIndex;
        Session["DDLMese"] = DDLMese.SelectedIndex;
    }

    // salva valori dei controlli
    protected void RipristinaControlli()
    {
        if (Session["DDLAnno"] != null) DDLAnno.SelectedIndex = (int)Session["DDLAnno"];
        if (Session["DDLMese"] != null) DDLMese.SelectedIndex = (int)Session["DDLMese"];
    }


    protected void LBPersone_DataBinding(object sender, EventArgs e)
    {

        int i, i2;
        List<string> lsValoriSelezionati;

        lsValoriSelezionati = (List<string>)Session["ValoriSelezionati"];

        if (lsValoriSelezionati != null )
            for (i = 0; i < LBPersone.Items.Count; i++)
                for (i2 = 0; i2 < lsValoriSelezionati.Count; i2++)
                    if (LBPersone.Items[i].Value == lsValoriSelezionati[i2])
                        LBPersone.Items[i].Selected = true;

    }
    protected void LBLivello_DataBinding(object sender, EventArgs e)
    {

        int i, i2;
        List<string> lsValoriSelezionati;

        lsValoriSelezionati = (List<string>)Session["LivelliSelezionati"];

        if (lsValoriSelezionati != null)
            for (i = 0; i < LBLivello.Items.Count; i++)
                for (i2 = 0; i2 < lsValoriSelezionati.Count; i2++)
                    if (LBLivello.Items[i].Value == lsValoriSelezionati[i2])
                        LBLivello.Items[i].Selected = true;

    }

}