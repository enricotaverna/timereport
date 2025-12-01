using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Net.Sockets;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;

public partial class MonthlyFeeReport : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // se non ADMIN o MANAGER spegne il tasto Chargeable e selezioni per società/cliente/manager
        if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            DivManager.Visible = false;
            DivCliente.Visible = false;
            DivSocieta.Visible = false;
        }

        // inizializza bottoni toggle e DDL Persone e Progetti
        if (!IsPostBack)
        {
            InitPage();
            // Recupera Default
            FetchSelectionsValue();
        }

    }

    // inizializza
    protected void InitPage()
    {

        Session["bProgettiAll"] = true;
        Session["bChargeableAndOthers"] = true;

        // stile bottoni
        btPrjAll.CssClass = "btn btn-primary";
        btPrjAttivi.CssClass = "btn btn-outline-secondary";

        CBLProgetti_Load();

        // Popola dropdown con i valori          
        ASPcompatility.SelectYears(ref DDLFromYear);
        ASPcompatility.SelectYears(ref DDLToYear);
        ASPcompatility.SelectMonths(ref DDLFromMonth, CurrentSession.Language);
        ASPcompatility.SelectMonths(ref DDLToMonth, CurrentSession.Language);
    }

    // Costruisce segmento Where
    protected string Addclause(string strInput, string toAdd)
    {

        if (!string.IsNullOrEmpty(strInput))
            strInput = strInput + " AND ";

        return strInput + toAdd;
    }

    public class WhereClause
    {
        public string WhereClauseDays { get; set; }
        public string WhereClauseMonths { get; set; }
    }

    // Costruisce condizione Where
    protected WhereClause Build_where()
    {
        WhereClause wc = new WhereClause();
        wc.WhereClauseDays = "";

        string sListaProgettiSel = Utilities.ListSelections(CBLProgetti);
        string sListaProgettiAll = Utilities.ListSelections(CBLProgetti, true);

        bool bProgettiSelezionati = !string.IsNullOrEmpty(sListaProgettiSel);

        // *** ADMIN
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL") && Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            if (bProgettiSelezionati) // sono stati selezionati dei progetti e non è il tipo export Not Chargable
                wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "Projects_id IN (" + sListaProgettiSel + " )");

        } // *** ADMIN

        // *** CONSULENTE / ESTERNO
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            !Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {

            // solo sue ore e spese su progetti abilitati
            wc.WhereClauseDays = "Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )";
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id));

        } // *** CONSULENTE / ESTERNO

        // *** MANAGER / TEAM LEADER
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            // se progetto selezionato estrae solo quello
            if (bProgettiSelezionati)
                wc.WhereClauseDays =
                    "  Projects_id IN ( " + sListaProgettiSel + " ) ";

            if (!bProgettiSelezionati)
            {
                wc.WhereClauseDays = " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_RESALE"] +
                    "   AND Projects_id IN ( " + sListaProgettiAll + " )  ) ";

                if ((bool)Session["bChargeableAndOthers"])
                    wc.WhereClauseDays += " OR  ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_RESALE"] +
                    " AND ( Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
                    " OR Manager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + ")" +
                    " ) ) ";
                else
                    wc.WhereClauseDays += " ) ";
            }

        } // *** MANAGER / TEAM LEADER

        if (DDLClienti.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "[Projects].CodiceCliente = " + ASPcompatility.FormatStringDb(DDLClienti.SelectedValue));

        if (DDLsocieta.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "[Projects].company_id = " + ASPcompatility.FormatStringDb(DDLsocieta.SelectedValue));

        if (DDLManager.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "( Manager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR AccountManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR [Projects].ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_RESALE"] + " )");

        if (!string.IsNullOrEmpty(wc.WhereClauseDays))
            wc.WhereClauseDays = wc.WhereClauseDays + " AND ";

        string meseDa = DDLFromMonth.SelectedValue;
        string meseA = DDLToMonth.SelectedValue;
        string annoDa = DDLFromYear.SelectedValue;
        string annoA = DDLToYear.SelectedValue;

        string fd = ASPcompatility.FormatDateDb(ASPcompatility.FirstDay(Convert.ToInt16(meseDa), Convert.ToInt16(annoDa)));
        string ld = ASPcompatility.FormatDateDb(ASPcompatility.LastDay(Convert.ToInt16(meseA), Convert.ToInt16(annoA)));

        wc.WhereClauseMonths = wc.WhereClauseDays + " AnnoMese >= '" + annoDa + "-" + meseDa + "' AND AnnoMese  <= '" + annoA + "-" + meseA + "'";
        wc.WhereClauseDays = wc.WhereClauseDays + " DataInizio >= " + fd + " AND DataFine <= " + ld;

        return wc;

    }

    // cambia stato selezione progetti
    protected void BottoniToggle(object sender, CommandEventArgs e)
    {
        switch (e.CommandName)
        {
            case "btPrjAll":
                Session["bProgettiAll"] = true;
                btPrjAll.CssClass = "btn btn-primary";
                btPrjAttivi.CssClass = "btn btn-outline-secondary";
                break;

            case "btPrjAttivi":
                Session["bProgettiAll"] = false;
                btPrjAttivi.CssClass = "btn btn-primary";
                btPrjAll.CssClass = "btn btn-outline-secondary";
                break;
        }

        // ricarica i progetti e persone
        CBLProgetti_Load();

        return;
    }

    // salva i valori delle selezioni
    protected void SaveSelectionsValue()
    {
        Session["DDLManagerValue"] = DDLManager.SelectedValue;
        Session["DDLFromMonthValue"] = DDLFromMonth.SelectedValue;
        Session["DDLToMonthValue"] = DDLToMonth.SelectedValue;
        Session["DDLFromYearValue"] = DDLFromYear.SelectedValue;
        Session["DDLToYearValue"] = DDLToYear.SelectedValue;
        Session["DDLClientiValue"] = DDLClienti.SelectedValue;
        Session["DDLsocietaValue"] = DDLsocieta.SelectedValue;


    }

    // receuperai valori delle selezioni
    protected void FetchSelectionsValue()
    {
        DDLManager.SelectedValue = Session["DDLManagerValue"] != null ? Session["DDLManagerValue"].ToString() : "";
        DDLFromMonth.SelectedValue = Session["DDLFromMonthValue"] != null ? Session["DDLFromMonthValue"].ToString() : "";
        DDLToMonth.SelectedValue = Session["DDLToMonthValue"] != null ? Session["DDLToMonthValue"].ToString() : "";
        DDLFromYear.SelectedValue = Session["DDLFromYearValue"] != null ? Session["DDLFromYearValue"].ToString() : "";
        DDLToYear.SelectedValue = Session["DDLToYearValue"] != null ? Session["DDLToYearValue"].ToString() : "";
        DDLClienti.SelectedValue = Session["DDLClientiValue"] != null ? Session["DDLClientiValue"].ToString() : "";
        DDLsocieta.SelectedValue = Session["DDLsocietaValue"] != null ? Session["DDLsocietaValue"].ToString() : "";
    }

    // Lancia report
    protected void Sottometti_Click(object sender, System.EventArgs e)
    {
        WhereClause wc = new WhereClause();

        string sWhereClause = "";

        // salva i valori in variabili di sessione per non doverli reinserire
        SaveSelectionsValue();

        wc = Build_where();

        Utilities.ExportXls("SELECT [Monthly_Fee_id],[ProjectCode],[Name],[Monthly_Fee_Code],[Year],[Month],[Revenue] " +
                            ", [Cost], [Days], [Day_Revenue], [Day_Cost], [CodiceCliente], [Nome1], [Societa], [Manager] " +
                            ", [Manager_Id], [Descrizione], [DataInizio], [DataFine] FROM [v_Monthly_Fee] WHERE " + wc.WhereClauseDays);

        

    }

    // Carica DDL progetti - Chiamato da evento OnLoad del DDL
    protected void CBLProgetti_Load()
    {
        DataTable dtProjectsDDL = new DataTable();
        DataTable dtMerged = new DataTable();

        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            dtMerged = Database.GetData("SELECT Projects_id, ProjectCode + ' ' + Projects.Name AS DescProgetto FROM Projects " +
                                        "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = [Projects].ProjectType_Id " +
                                        " WHERE ProjectType.Name = 'Resale' " +
                                        ((bool)Session["bProgettiAll"] == false ? " AND Active = 1 " : "") +                                        
                                        " ORDER BY DescProgetto");
        }
        else
        // i progetti assegnati + quelli di cui è manager 
        //if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            // carica progetti di cui la persone è manager o account
            dtProjectsDDL = Database.GetData("SELECT Projects_id, ProjectCode + ' ' + Projects.Name AS DescProgetto FROM Projects " +
                                            "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = [Projects].ProjectType_Id " +
                                            " WHERE ProjectType.Name = 'Resale' AND (AccountManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + " OR ClientManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + ")"+
                                            ((bool)Session["bProgettiAll"] == false ? " AND Active = 1 " : "") +
                                            " ORDER BY DescProgetto");

            // Unisci dtProjectsDDL con CurrentSession.dtProgettiForzati
            dtMerged = dtProjectsDDL.Clone(); // Crea una nuova DataTable con la stessa struttura

            foreach (DataRow row in CurrentSession.dtProgettiForzati.Rows)
            {
                dtMerged.ImportRow(row);
            }

            foreach (DataRow row in dtProjectsDDL.Rows)
            {
                // Aggiungi solo se non è già presente nella lista
                if (!dtMerged.AsEnumerable().Any(r => r.Field<int>("Projects_id") == row.Field<int>("Projects_id")))
                {
                    dtMerged.ImportRow(row);
                }
            }
        }

        if (dtMerged != null && dtMerged.Rows.Count > 0)
        {
            // Ordina la lista dei progetti per ProjectCode
            var sortedRows = dtMerged.AsEnumerable().OrderBy(r => r.Field<string>("DescProgetto"));

            // Assegna i progetti al controllo CBLProgetti
            CBLProgetti.Items.Clear();
            foreach (var row in sortedRows)
            {
                CBLProgetti.Items.Add(new ListItem(row["DescProgetto"].ToString(), row["Projects_id"].ToString()));
            }
        }
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/report/Canoni/MonthlyFeeReport.aspx");
    }
}