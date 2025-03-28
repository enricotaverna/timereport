﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
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

        // se non ADMIN o MANAGER spegne il tasto Chargeable e selezioni per società/cliente/manager
        if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            //btChargeable.Visible = false;
            DivOpportunitaSpese.Visible = false;
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
        //btChargeAll.CssClass = "btn btn-primary";
        //btCharge.CssClass = "btn btn-outline-secondary";

        CBLProgetti_Load();
        CBLPersone_Load();
        CBLOpportunita_Load();

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

    public class WhereClause
    {
        public string WhereClauseDays { get; set; }
        public string WhereClauseMonths { get; set; }
    }

    // Costruisce condizione Where
    protected WhereClause Build_where(string selType) // selType = "1" ore, "2" spese
    {
        WhereClause wc = new WhereClause();
        wc.WhereClauseDays = "";

        string sListaProgettiSel = Utilities.ListSelections(CBLProgetti);
        string sListaProgettiAll = Utilities.ListSelections(CBLProgetti, true);
        string sListaPersoneSel = Utilities.ListSelections(CBLPersone);
        string sListaOpportunitaSel = Utilities.ListSelections(CBLOpportunita);
        string sListaTipoSpesaSel = Utilities.ListSelections(CBLTipoSpese);

        bool bProgettiSelezionati = !string.IsNullOrEmpty(sListaProgettiSel);
        bool bPersoneSelezionate = !string.IsNullOrEmpty(sListaPersoneSel);
        bool bOpportunitaSelezionati = !string.IsNullOrEmpty(sListaOpportunitaSel);
        bool bTipoSpesaSelezionati = !string.IsNullOrEmpty(sListaTipoSpesaSel);

        if (bOpportunitaSelezionati)
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "Opportunityid IN (" + sListaOpportunitaSel + " )");

        if (bTipoSpesaSelezionati && selType == "2")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "ExpenseType_id IN (" + sListaTipoSpesaSel + " )");

        // *** ADMIN
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL") && Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            if (bProgettiSelezionati) // sono stati selezionati dei progetti e non è il tipo export Not Chargable
                wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "Projects_id IN (" + sListaProgettiSel + " )");

            if (bPersoneSelezionate)
                wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "Persons_id IN (" + sListaPersoneSel + " )");
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
            // deve selezionare tutte le persone su progetti chargable e solo se stessi su progetti non chargable
            // altrimenti tutti vedono spese e ore di progetti BD e INFRASTRUTTURALI a cui sono assegnati

            //if (bPersoneSelezionate)
            //    sWhereClause =
            //        "   Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
            //        "   AND Persons_id IN (" + sListaPersoneSel + ")";
            //else // persone non selezionate estrare solo le ore non chargable delle persone associate al manager

            // se progetto selezionato estrae solo quello
            if (bProgettiSelezionati)
                wc.WhereClauseDays =
                    "  Projects_id IN ( " + sListaProgettiSel + " ) ";

            if (!bProgettiSelezionati)
            {
                wc.WhereClauseDays = " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    "   AND Projects_id IN ( " + sListaProgettiAll + " )  ) ";

                if ((bool)Session["bChargeableAndOthers"])
                    wc.WhereClauseDays += " OR  ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    " AND ( Persons_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
                    " OR Manager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + ")" +
                    " ) ) ";
                else
                    wc.WhereClauseDays += " ) ";
            }

            if (bPersoneSelezionate)
                wc.WhereClauseDays = wc.WhereClauseDays + " AND Persons_id IN(" + sListaPersoneSel + ")";

        } // *** MANAGER / TEAM LEADER

        if (DDLClienti.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "CodiceCliente = " + ASPcompatility.FormatStringDb(DDLClienti.SelectedValue));

        if (DDLsocieta.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "company_id = " + ASPcompatility.FormatStringDb(DDLsocieta.SelectedValue));

        if (DDLManager.SelectedValue != "")
            wc.WhereClauseDays = Addclause(wc.WhereClauseDays, "( Manager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR AccountManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) +
                                                   " OR ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + " )");

        if (!string.IsNullOrEmpty(wc.WhereClauseDays))
            wc.WhereClauseDays = wc.WhereClauseDays + " AND ";

        string meseDa = DDLFromMonth.SelectedValue;
        string meseA = DDLToMonth.SelectedValue;
        string annoDa = DDLFromYear.SelectedValue;
        string annoA = DDLToYear.SelectedValue;

        string fd = ASPcompatility.FormatDateDb(ASPcompatility.FirstDay(Convert.ToInt16(meseDa), Convert.ToInt16(annoDa)));
        string ld = ASPcompatility.FormatDateDb(ASPcompatility.LastDay(Convert.ToInt16(meseA), Convert.ToInt16(annoA)));

        wc.WhereClauseMonths = wc.WhereClauseDays + " AnnoMese >= '" + annoDa + "-" + meseDa + "' AND AnnoMese  <= '" + annoA + "-" + meseA + "'";
        wc.WhereClauseDays = wc.WhereClauseDays + " date >= " + fd + " AND date <= " + ld;

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

        }

        // ricarica i progetti e persone
        CBLProgetti_Load();
        CBLPersone_Load();
        CBLOpportunita_Load();

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
        WhereClause wc = new WhereClause();

        string sWhereClause = "";

        // salva i valori in variabili di sessione per non doverli reinserire
        SaveSelectionsValue();

        wc = Build_where(RBTipoExport.SelectedValue);

        switch (RBTipoExport.SelectedValue)
        {
            case "1":
                Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese, WorkedInRemote, LocationDescription, NomeAccountManager, PreinvoiceNum, CTMPreinvoiceNum, OpportunityId, LOBCode, SFContractType from v_ore where " + wc.WhereClauseDays);
                //Response.Redirect("/timereport/esporta.aspx");
                break;
            case "2":
                Utilities.ExportXls("Select Expenses_Id, Persona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, TipoProgetto, Manager, fDate, AnnoMese, ExpenseCode, DescSpesa, CreditCardPayed, CompanyPayed, flagstorno, Invoiceflag,KM, Importo, Comment, AccountingDateAnnoMese, '', AdditionalCharges, PreinvoiceNum, CTMPreinvoiceNum, OpportunityId, LOBCode, SFContractType from v_spese where " + wc.WhereClauseDays);
                //Response.Redirect("/timereport/esporta.aspx");
                break;
                //case "3":
                //    Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese from v_ore where " + sWhereClause);
                //    break;
        }

        switch (RBTipoReport.SelectedValue)
        {
            case "3":
                Session["SQL"] = "SELECT NomePersona, NomeProgetto, Giorni, NomeCliente, AnnoMese FROM v_SummaryHours WHERE " + wc.WhereClauseMonths;
                Session["ReportPath"] = "OrePerMese.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "4":
                Session["SQL"] = "SELECT persona, nomeprogetto, nomeCliente, DescSpesa, importo, annomese FROM v_SummaryExpenses WHERE " + wc.WhereClauseMonths;
                Session["ReportPath"] = "SpesePerMese.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "5":
                Session["SQL"] = "SELECT  * FROM v_ore WHERE " + wc.WhereClauseDays;
                Session["ReportPath"] = "DettaglioOre.rdlc";
                Response.Redirect("report/rdlc/ReportExecute.aspx");
                break;
            case "6":
                Session["SQL"] = "SELECT  * FROM v_spese WHERE " + wc.WhereClauseDays;
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
        DataTable dtProjectsDDL = new DataTable();
        DataTable dtMerged = new DataTable();

        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            dtMerged = Database.GetData("SELECT Projects_id, ProjectCode + ' ' + Name AS DescProgetto FROM Projects " +
                                            ((bool)Session["bProgettiAll"] == false ? " WHERE Active = 1 " : "") +
                                            " ORDER BY DescProgetto");
        }
        else
        // i progetti assegnati + quelli di cui è manager 
        //if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            // carica progetti di cui la persone è manager o account
            dtProjectsDDL = Database.GetData("SELECT Projects_id, ProjectCode + ' ' + Name AS DescProgetto FROM Projects " +
                                             " WHERE AccountManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) + " OR ClientManager_id = " + ASPcompatility.FormatNumberDB(CurrentSession.Persons_id) +
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

        // Ordina la lista dei progetti per ProjectCode
        var sortedRows = dtMerged.AsEnumerable().OrderBy(r => r.Field<string>("DescProgetto"));

        // Assegna i progetti al controllo CBLProgetti
        CBLProgetti.Items.Clear();
        foreach (var row in sortedRows)
        {
            CBLProgetti.Items.Add(new ListItem(row["DescProgetto"].ToString(), row["Projects_id"].ToString()));
        }
    }

    protected void CBLOpportunita_Load()
    {
        ListBox DDLOpportunity;
        List<Opportunity> ListaOpportunita = new List<Opportunity>();

        //valorizzazione con valore default
        DDLOpportunity = CBLOpportunita;

        //DDLOpportunity = (DropDownList)FVore.FindControl("DDLOpportunity");
        DDLOpportunity.Items.Clear();
        DDLOpportunity.Items.Add(new ListItem("seleziona una opportunit&agrave", ""));

        //if (FVore.CurrentMode == FormViewMode.Insert | FVore.CurrentMode == FormViewMode.Edit)
        //    ListaOpportunita = CurrentSession.ListaOpenOpportunity;
        //else
        ListaOpportunita = CurrentSession.ListaAllOpportunity;

        // carica progetti forzati in insert e change, tutti i progetti in display per evitare problemi in caso
        // di progetti chiusi
        foreach (Opportunity opp in ListaOpportunita)
        {
            ListItem liItem = new ListItem(opp.OpportunityAccount.AccountName + " - " + opp.OpportunityName, opp.OpportunityCode);
            DDLOpportunity.Items.Add(liItem);
        }

        DDLOpportunity.DataTextField = "OpportunityName";
        DDLOpportunity.DataValueField = "OpportunityId";
        DDLOpportunity.DataBind();

        //if (FVore.CurrentMode == FormViewMode.Insert)
        //    DDLOpportunity.SelectedValue = (string)Session["OpportunityDefault"];
        //else
        //    DDLOpportunity.SelectedValue = OpportunityId;
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