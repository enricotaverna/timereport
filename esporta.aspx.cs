using System;
using System.Configuration;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;

public partial class Esporta : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // se non ADMIN o MANAGER spegne il tasto Chargeable
        if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
            btChargeable.Visible = false;

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
        Session["bPersoneAll"] = true;
        Session["bChargeableAndOthers"] = true;

        //mantiene valore DDL
        //if ( Session["CBLProgettiSelectedValue"] != null ) 
        //    CBLProgetti.SelectedValue = Session["CBLProgettiSelectedValue"].ToString();

        // stile bottoni
        btPrjAll.CssClass = "btn btn-primary";
        btPrjAttivi.CssClass = "btn btn-outline-secondary";
        btPerAll.CssClass = "btn btn-primary";
        btPerAttivi.CssClass = "btn btn-outline-secondary";
        btChargeAll.CssClass = "btn btn-primary";
        btCharge.CssClass = "btn btn-outline-secondary";

        CBLProgetti_Load();
        CBLPersone_Load();

        // Popola dropdown con i valori          
        ASPcompatility.SelectYears(ref DDLFromYear);
        ASPcompatility.SelectYears(ref DDLToYear);
        ASPcompatility.SelectMonths(ref DDLFromMonth, CurrentSession.Language);
        ASPcompatility.SelectMonths(ref DDLToMonth, CurrentSession.Language);

        // default RadioButton
        if (RBTipoExport.SelectedValue == "" && RBTipoReport.SelectedValue == "")
            RBTipoExport.SelectedValue = "1";
    }

    // Costruisce segmento Where
    protected string Addclause(string strInput, string toAdd)
    {

        if (!string.IsNullOrEmpty(strInput))
            strInput = strInput + " AND ";

        return strInput + toAdd;
    }

    // Costruisce condizione Where
    protected string Build_where()
    {
        string sWhereClause = "";

        string sListaProgettiSel = Utilities.ListSelections(CBLProgetti);
        string sListaProgettiAll = Utilities.ListSelections(CBLProgetti, true);
        string sListaPersoneSel = Utilities.ListSelections(CBLPersone);

        bool bProgettiSelezionati = !string.IsNullOrEmpty(sListaProgettiSel);
        bool bPersoneSelezionate = !string.IsNullOrEmpty(sListaPersoneSel);

        // *** ADMIN
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL") && Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            if (bProgettiSelezionati) // sono stati selezionati dei progetti e non è il tipo export Not Chargable
                sWhereClause = Addclause(sWhereClause, "Projects_id IN (" + sListaProgettiSel + " )");

            if (bPersoneSelezionate)
                sWhereClause = Addclause(sWhereClause, "Persons_id IN (" + sListaPersoneSel + " )");
        } // *** ADMIN

        // *** CONSULENTE / ESTERNO
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            !Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {

            // solo sue ore e spese su progetti abilitati
            sWhereClause = "Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )";
            sWhereClause = Addclause(sWhereClause, "Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id));

        } // *** CONSULENTE / ESTERNO

        // *** MANAGER / TEAM LEADER
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            // deve selezionare tutte le persone su progetti chargable e solo se stessi su progetti non chargable
            // altrimenti tutti vedono spese e ore di progetti BD e INFRASTRUTTURALI a cui sono assegnati

            //if (bPersoneSelezionate)
            //    sWhereClause =
            //        "   Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
            //        "   AND Persons_id IN (" + sListaPersoneSel + ")";
            //else // persone non selezionate estrare solo le ore non chargable delle persone associate al manager

            // se progetto selezionato estrae solo quello
            if (bProgettiSelezionati)
                sWhereClause =
                    "  Projects_id IN ( " + sListaProgettiSel + " ) ";

            if (!bProgettiSelezionati)
            {
                sWhereClause = " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    "   AND Projects_id IN ( " + sListaProgettiAll + " )  ) ";

                if ((bool)Session["bChargeableAndOthers"])
                    sWhereClause += " OR  ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    " AND ( Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + 
                    " OR Manager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + ")" +
                    " ) ) ";
                else
                    sWhereClause += " ) ";
            }

            if (bPersoneSelezionate)
                sWhereClause = sWhereClause + " AND Persons_id IN(" + sListaPersoneSel + ")";

        } // *** MANAGER / TEAM LEADER

        if (DDLClienti.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "CodiceCliente = " + ASPcompatility.FormatStringDb(DDLClienti.SelectedValue));

        if (DDLsocieta.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "company_id = " + ASPcompatility.FormatStringDb(DDLsocieta.SelectedValue));

        if (DDLManager.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "( Manager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR AccountManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + " )" ) ;

        if (!string.IsNullOrEmpty(sWhereClause))
            sWhereClause = sWhereClause + " AND ";

        string fd = ASPcompatility.FormatDateDb(ASPcompatility.FirstDay(Convert.ToInt16(DDLFromMonth.SelectedValue), Convert.ToInt16(DDLFromYear.SelectedValue)));
        string ld = ASPcompatility.FormatDateDb(ASPcompatility.LastDay(Convert.ToInt16(DDLToMonth.SelectedValue), Convert.ToInt16(DDLToYear.SelectedValue)));

        sWhereClause = sWhereClause + " date >= " + fd + " AND date <= " + ld;

        return sWhereClause;

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

            case "btPerAll":
                Session["bPersoneAll"] = true;
                btPerAll.CssClass = "btn btn-primary";
                btPerAttivi.CssClass = "btn btn-outline-secondary";
                break;

            case "btPerAttivi":
                Session["bPersoneAll"] = false;
                btPerAttivi.CssClass = "btn btn-primary";
                btPerAll.CssClass = "btn btn-outline-secondary";
                break;

            case "btCharge":
                Session["bChargeableAndOthers"] = false;
                btCharge.CssClass = "btn btn-primary";
                btChargeAll.CssClass = "btn btn-outline-secondary";
                break;

            case "btChargeAll":
                Session["bChargeableAndOthers"] = true;
                btChargeAll.CssClass = "btn btn-primary";
                btCharge.CssClass = "btn btn-outline-secondary";
                break;

        }

        // ricarica i progetti e persone
        CBLProgetti_Load();
        CBLPersone_Load();

        return;
    }

    // salva i valori delle selezioni
    protected void SaveSelectionsValue() {
        Session["DDLManagerValue"] = DDLManager.SelectedValue;
        Session["DDLFromMonthValue"] = DDLFromMonth.SelectedValue;
        Session["DDLToMonthValue"] = DDLToMonth.SelectedValue;
        Session["DDLFromYearValue"] = DDLFromYear.SelectedValue;
        Session["DDLToYearValue"] = DDLToYear.SelectedValue;
        Session["DDLClientiValue"] = DDLClienti.SelectedValue;
        Session["DDLsocietaValue"] = DDLsocieta.SelectedValue;
        Session["RBTipoExportValue"] = RBTipoExport.SelectedValue;
       

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
        RBTipoExport.SelectedValue = Session["RBTipoExportValue"] != null ? Session["RBTipoExportValue"].ToString() : "";
    }

    // Lancia report
    protected void Sottometti_Click(object sender, System.EventArgs e)
    {
        string sWhereClause = "";

        // salva i valori in variabili di sessione per non doverli reinserire
        SaveSelectionsValue();

        sWhereClause = Build_where();

        switch (RBTipoExport.SelectedValue)
        {
            case "1":
                Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese, WorkedInRemote, LocationDescription, NomeAccountManager, Preinvoice_id, OpportunityId from v_ore where " + sWhereClause);
                //Response.Redirect("/timereport/esporta.aspx");
                break;
            case "2":
                Utilities.ExportXls("Select Expenses_Id, Persona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, TipoProgetto, " + "Manager, fDate, AnnoMese, ExpenseCode, DescSpesa, CreditCardPayed, CompanyPayed, flagstorno, Invoiceflag,KM, Importo, Comment, AccountingDateAnnoMese, '', AdditionalCharges, Preinvoice_id, OpportunityId from v_spese where " + sWhereClause);
                //Response.Redirect("/timereport/esporta.aspx");
                break;
                //case "3":
                //    Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese from v_ore where " + sWhereClause);
                //    break;
        }

        switch (RBTipoReport.SelectedValue)
        {
            case "3":
                Session["SQL"] = "SELECT nomepersona, nomeprogetto, giorni, annomese FROM v_ore WHERE " + sWhereClause;
                Session["ReportPath"] = "OrePerMese.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "4":
                Session["SQL"] = "SELECT persona, nomeprogetto, DescSpesa, importo, annomese FROM v_spese WHERE " + sWhereClause;
                Session["ReportPath"] = "SpesePerMese.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "5":
                Session["SQL"] = "SELECT  * FROM v_ore WHERE " + sWhereClause;
                Session["ReportPath"] = "DettaglioOre.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "6":
                Session["SQL"] = "SELECT  * FROM v_spese WHERE " + sWhereClause;
                Session["ReportPath"] = "DettaglioSpese.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;

        }
    }

    // Carica DDL persone - Chiamato da evento OnLoad del DDL
    protected void CBLPersone_Load()
    {

        // Admin, Manager, Reporter : tutte le persone
        // Emplyee, Esterno: solo se stessi
        // Il reporter può essere unemployee

        if (Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
            DSPersone.SelectCommand = "SELECT [Persons_id], [Name] FROM [Persons] " + ((bool)Session["bPersoneAll"] == false ? " WHERE Active = 1 " : "") + " ORDER BY [Name]";
        else
        {
            DSPersone.SelectCommand = "SELECT [Persons_id], [Name] FROM [Persons] WHERE Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + " ORDER BY [Name]";
            CBLPersone.Visible = false;
            btPerAll.Visible = false;
            btPerAttivi.Visible = false;
            //DivPersone.Visible = false;
            //DivProgetti.Visible = false;
        }

    }

    // Carica DDL progetti - Chiamato da evento OnLoad del DDL
    protected void CBLProgetti_Load()
    {
        string whereClause = "";

        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL")) {
            
            if ((bool) Session["bProgettiAll"] == false)
                whereClause = Addclause(whereClause,  "Active = 1");

            if ((bool)Session["bChargeableAndOthers"] == false)
                whereClause = Addclause(whereClause, "ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] );

            DSProgetti.SelectCommand = "SELECT Projects_id, ProjectCode, ProjectCode + ' ' + Name AS txtcodes FROM Projects " +
                                        ( whereClause != "" ? ( "WHERE " + whereClause ) : "" ) +
                                        " ORDER BY ProjectCode";
        }

        // i progetti assegnati + quelli di cui è manager
        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            DSProgetti.SelectCommand = "SELECT DISTINCT a.Projects_id, a.ProjectCode, a.ProjectCode + ' ' + a.Name AS txtcodes FROM Projects AS a" +
                                       " INNER JOIN ForcedAccounts as b ON a.Projects_id = b.Projects_id " +
                                       " WHERE b.persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
                                       ((bool)Session["bProgettiAll"] == false ? " AND a.Active = 1 " : "") +
                                       ((bool)Session["bChargeableAndOthers"] == false ? " AND a.ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] : "") +

                                       " UNION " +
                                       " SELECT DISTINCT a.Projects_id, a.ProjectCode, a.ProjectCode + ' ' + a.Name AS txtcodes FROM Projects AS a " +
                                       " WHERE ( a.clientmanager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + " OR a.Accountmanager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + ") " +
                                       ((bool)Session["bProgettiAll"] == false ? " AND a.Active = 1 " : "") +
                                        " ORDER BY ProjectCode";
    }        

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

    // mantiene valore DDL
    //protected void CBLProgetti_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    Session["CBLProgettiSelectedValue"] = CBLProgetti.SelectedValue;
    //}
}