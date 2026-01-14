using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class input_spese : System.Web.UI.Page
{
    // attivata MARS .
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    public string lProject_id, lExpenseType_id, OpportunityId;
    public int lTipoBonus_id;
    public string lDataSpesa, lExpense_id;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "SPESE");
        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        //      Modo di default è insert, se richiamata con id va in change / display
        if (IsPostBack)
        {
            if (Request.QueryString["action"].ToString() != "new")
            {
                // recupera record per settare default sulle DDL al momento del Bind
                Get_record(Request.QueryString["expenses_id"].ToString());
                Trova_ricevute(Request.QueryString["expenses_id"]);
            }

            return;
        }

        // di default il box revicevute non è visibile
        BoxRicevute.Visible = false;

        //      in caso di update recupera il valore del progetto e attività
        if (Request.QueryString["expenses_id"] != null)
        {
            // recupera record per settare default sulle DDL al momento del Bind
            Get_record(Request.QueryString["expenses_id"].ToString());

            //              disabilita form in caso di cutoff
            Label LBdate = (Label)FVSpese.FindControl("LBdate");
            DateTime dateRecord = Convert.ToDateTime(LBdate.Text);

            // verifica se TR della persona è chiuso
            var trChiuso = Database.RecordEsiste("SELECT * FROM logtr WHERE persons_id=" + CurrentSession.Persons_id + " AND stato=1 AND mese=" + dateRecord.Month.ToString() + " AND anno=" + dateRecord.Year.ToString());

            if (dateRecord < CurrentSession.dCutoffDate || trChiuso || lTipoBonus_id > 0)
                FVSpese.ChangeMode(FormViewMode.ReadOnly);
            else
                FVSpese.ChangeMode(FormViewMode.Edit);

            // recupera immagini Ricevute e visualizza box se ce ne sono
            Trova_ricevute(Request.QueryString["expenses_id"]);

        }
        else // insert
        {
            FVSpese.ChangeMode(FormViewMode.Insert);

            Label LBdate = (Label)FVSpese.FindControl("LBdate");
            LBdate.Text = Request.QueryString["date"];

            Label LBperson = (Label)FVSpese.FindControl("LBperson");
            LBperson.Text = (string)CurrentSession.UserName;

            TextBox TBAmount = (TextBox)FVSpese.FindControl("TBAmount");
            if (Convert.ToInt16(Session["TipoBonus_IdDefault"]) > 0)
            {
                TBAmount.Enabled = false;
                TBAmount.Text = "1";
            }
            else
            {
                TBAmount.Enabled = true;
                TBAmount.Text = "";
            }
        }

    }

    // *** TROVA RICEVUTE ****
    // Legge la directory nel formato ANNO/MESE/NOTE UTENTE e elenca tutte le ricevute il cui nome file
    // inizia con l'Id della spesa visualizzate 
    protected void Trova_ricevute(string strExpenses_Id)
    {

        // rende visibile il box
        BoxRicevute.Visible = true;

        // se display rende non visibile il bottone
        if (FVSpese.CurrentMode == FormViewMode.ReadOnly)
            divBottoni.Visible = false;

        // restituisce array con nome dei file o null se non si sono ricevute
        string[] filePaths = TrovaRicevuteLocale(Convert.ToInt32(strExpenses_Id), CurrentSession.UserName, lDataSpesa);

        // Se non esistono immagini torna indietro
        if (filePaths == null || filePaths.Length == 0)
            return;

        // loop per stampare immagini
        string stWebPath = ConfigurationSettings.AppSettings["PATH_RICEVUTE"] + lDataSpesa.Substring(0, 4) + "/" + lDataSpesa.Substring(4, 2) + "/" + CurrentSession.UserName + "/";
        string stFile = "";

        for (int i = 0; i < filePaths.Length; i++)
        {
            stFile = stWebPath + Path.GetFileName(filePaths[i]);

            // aggiunge riga    
            HtmlTableRow row = new HtmlTableRow();
            row.ID = stFile;

            // aggiunge le tre celle : immagine + tasto download + tasto cancella
            HtmlTableCell cell1 = new HtmlTableCell();
            HtmlTableCell cell2 = new HtmlTableCell();
            HtmlTableCell cell3 = new HtmlTableCell();

            // se PDF o TIFF mette icona corrispondente
            string stFileimg;
            if (filePaths[i].EndsWith("pdf"))
                stFileimg = "/timereport/images/icons/other/pdf.png";
            else
                stFileimg = stFile;

            cell1.InnerHtml = "<a  href='" + stFile + "' download='" + Path.GetFileName(filePaths[i]) + "'><img height=45 src='" + stFileimg + "' /></a>";
            cell1.Width = "50px";
            cell1.Align = "center";
            row.Cells.Add(cell1);

            cell2.InnerHtml = "<a href='" + stFile + "' download='" + Path.GetFileName(filePaths[i]) + "'><img height=20 src='/timereport/images/icons/other/download-50.png' /></a>";
            cell2.Width = "40px";
            row.Cells.Add(cell2);

            cell3.InnerHtml = "<a href='#' onclick='cancella_ricevuta(\"" + stFile + "\");'><img height=20 src='/timereport/images/icons/other/empty_trash-50.png' /></a>";
            cell3.Width = "40px";
            row.Cells.Add(cell3);

            TabellaRicevute.Rows.Add(row);

        } //  next 

    }

    // riceve in input id spesa, nome user, data spesa (YYYYMMGG) e restutuisce array con nome file
    // Se id spesa = -1 allora estrae tutte le spese del mese per l'utente
    public static string[] TrovaRicevuteLocale(int iId, string sUserName, string sData)
    {

        string[] filePaths = null;

        try
        {
            // costruisci il pach di ricerca: public + anno + mese + nome persona 
            string TargetLocation = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sData.Substring(0, 4) + "\\" + sData.Substring(4, 2) + "\\" + sUserName + "\\";
            // carica immagini
            filePaths = Directory
                .GetFiles(TargetLocation, "fid-" + (iId == -1 ? "" : iId.ToString()) + "*.*")
                                .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                                .ToArray();
            return (filePaths);
        }
        catch (Exception e)
        {
            //non fa niente ma evita il dump
            return (null);
        }

    }

    protected void Get_record(string strExpenses_Id)
    {

        DataRow dr = Database.GetRow("SELECT Expenses.Expenses_Id, Expenses.Projects_Id, Expenses.ExpenseType_id, Expenses.TipoBonus_id, Expenses.Date, OpportunityId FROM Expenses where expenses_id = " + strExpenses_Id, null);

        lProject_id = dr["Projects_id"].ToString(); // projects_id - usata per dare default a DDL
        lExpenseType_id = dr["ExpenseType_id"].ToString(); // ExpenseType_id - - usata per dare default a DDL
        lTipoBonus_id = Convert.ToInt16(dr["TipoBonus_id"].ToString());  // usata per dare gestire stato/valore campo Amount
        lExpense_id = dr["Expenses_Id"].ToString();
        lDataSpesa = ((DateTime)dr["date"]).ToString("yyyyMMdd");
        OpportunityId = dr["OpportunityId"].ToString(); // activity_id

    }

    protected void Bind_DDLprogetto()
    {
        DataTable dtProgettiInDDL = null;
        DropDownList ddlProject = (DropDownList)FVSpese.FindControl("DDLprogetto");

        ddlProject.Items.Clear();
        ddlProject.Items.Add(new ListItem(GetLocalResourceObject("DDLprogetto.testo").ToString(), ""));

        switch (FVSpese.CurrentMode)
        {
            case FormViewMode.Insert:
            case FormViewMode.Edit:
                dtProgettiInDDL = CurrentSession.dtProgettiForzati.Copy();
                break;

            case FormViewMode.ReadOnly:
                dtProgettiInDDL = CurrentSession.dtProgettiTutti.Copy();
                break;
        }

        // cancella le righe soggette a Workflow
        // in caso di display cancella tutti i progetto a parte quello non selezionato
        foreach (DataRow row in dtProgettiInDDL.Rows)
        {
            if (row["WorkflowType"].ToString() != "") // gestito con WF -> cancella
                row.Delete();

            if (FVSpese.CurrentMode == FormViewMode.ReadOnly && row["Projects_id"].ToString() != lProject_id)
                row.Delete();
        }
        dtProgettiInDDL.AcceptChanges();

        // Aggiunge gli attributi agli item della DDL per controllare l'input in funzione del progetto selezionato
        foreach (DataRow drRow in dtProgettiInDDL.Rows)
        {
            ListItem liItem = new ListItem(drRow["DescProgetto"].ToString(), drRow["Projects_Id"].ToString());

            if (drRow["ProjectType_Id"].ToString() == ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"]) // Gestione opportunity su progetti BD
                liItem.Attributes.Add("data-OpportunityIsRequired", "True");

            if (drRow["BloccoCaricoSpese"].ToString() != "True") // solo se carico spese è ammesso
                ddlProject.Items.Add(liItem);
        }

        ddlProject.DataTextField = "DescProgetto";
        ddlProject.DataValueField = "Projects_Id";
        ddlProject.DataBind();

        if (lProject_id != null)
            ddlProject.SelectedValue = lProject_id;

        // se in creazione imposta il default di progetto 
        if (FVSpese.CurrentMode == FormViewMode.Insert && lProject_id == null)
        {
            // prima cerca progetto sul giorno, se non lo trova mette ultimo default
            DataRow drRecord = Database.GetRow("SELECT Projects_id FROM Hours WHERE persons_id = " + CurrentSession.Persons_id + " AND date = " + ASPcompatility.FormatDateDb(Request["date"]), this.Page);

            if (drRecord != null)
                ddlProject.SelectedValue = drRecord["Projects_id"].ToString();
            else
                ddlProject.SelectedValue = (string)Session["ProjectCodeDefault"];
        }
    }

    protected void Bind_DDLTipoSpesa()
    {

        DataTable dtSpeseForzate = CurrentSession.dtSpeseForzate;
        DropDownList ddlTipoSpesa = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");
        String sTipoBonus_sel = "";

        // 08/2014 se viene richiamato da pagina bonus cambia il flag per il biding
        if (lTipoBonus_id > 0)
            sTipoBonus_sel = "";
        else
            sTipoBonus_sel = " AND TipoBonus_Id = 0 ";

        ddlTipoSpesa.Items.Clear();

        // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
        foreach (DataRow drRow in dtSpeseForzate.Rows)
        {

            // in INSERT e EDIT non aggiunge le spese di tipo bonus
            if (drRow["TipoBonus_id"].ToString() == "0" || FVSpese.CurrentMode == FormViewMode.ReadOnly)
            {
                ListItem liItem = new ListItem(drRow["descrizione"].ToString(), drRow["ExpenseType_Id"].ToString());
                liItem.Attributes.Add("data-desc-obbligatorio", drRow["TestoObbligatorio"].ToString());
                if (drRow["TestoObbligatorio"].ToString() == "True")
                    liItem.Attributes.Add("data-desc-message", drRow["MessaggioDiErrore"].ToString());
                else
                    liItem.Attributes.Add("data-desc-message", "");

                ddlTipoSpesa.Items.Add(liItem);
            }

        }

        ddlTipoSpesa.DataTextField = "descrizione";
        ddlTipoSpesa.DataValueField = "ExpenseType_Id";
        ddlTipoSpesa.DataBind();

        if (FVSpese.CurrentMode == FormViewMode.Insert)
            ddlTipoSpesa.SelectedValue = (string)Session["ExpenseDefault"];
        else
            ddlTipoSpesa.SelectedValue = lExpenseType_id;

    }

    //valorizzazione della DDL delle opportunità
    protected void Bind_DDLOpportunita()
    {
        DropDownList DDLOpportunity;
        List<Opportunity> ListaOpportunita = new List<Opportunity>();

        //valorizzazione con valore default
        DDLOpportunity = (DropDownList)FVSpese.FindControl("DDLOpportunity");
        DDLOpportunity.Items.Clear();
        DDLOpportunity.Items.Add(new ListItem("seleziona una opportunit&agrave", ""));

        if (FVSpese.CurrentMode == FormViewMode.Insert | FVSpese.CurrentMode == FormViewMode.Edit)
            ListaOpportunita = CurrentSession.ListaOpenOpportunity;
        else
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

        if (FVSpese.CurrentMode == FormViewMode.Insert)
            DDLOpportunity.SelectedValue = (string)Session["OpportunityDefault"];
        else
            DDLOpportunity.SelectedValue = OpportunityId;
    }

    protected void FVSpese_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("input.aspx");
    }

    protected void FVSpese_DataBound(object sender, EventArgs e)
    {

        //      formattta il campo numerico delle spese, nel DB le spese stornate sono negative
        if (Request.QueryString["action"] == "fetch")
        {
            TextBox TBSpese = (TextBox)FVSpese.FindControl("TBAmount");
            double SpeseValue = Math.Abs(Convert.ToDouble(TBSpese.Text));
            TBSpese.Text = SpeseValue.ToString();
        }

        Bind_DDLprogetto();
        Bind_DDLTipoSpesa();
        Bind_DDLOpportunita();

        //      se livello autorizzativo è inferiore a 4 spegne il campo competenza
        if (!Auth.ReturnPermission("ADMIN", "CUTOFF"))
        {
            Label LBAccountingDate = (Label)FVSpese.FindControl("LBAccountingDate");
            TextBox TBAccountingDate = (TextBox)FVSpese.FindControl("TBAccountingDate");
            Label LBCancel = (Label)FVSpese.FindControl("LBcancel");
            CheckBox TBCancel = (CheckBox)FVSpese.FindControl("CBcancel");

            // se display
            LBAccountingDate.Visible = false;
            TBAccountingDate.Visible = false;
            if (LBCancel != null)
                LBCancel.Visible = false;
            if (TBCancel != null)
                TBCancel.Visible = false;
        }

    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }

}
