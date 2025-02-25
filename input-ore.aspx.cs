using classiStandard;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading;
using System.Web.UI.WebControls;

public partial class input_ore : System.Web.UI.Page
{

    private DropDownList ddlProject;
    private DropDownList DDLTaskName;
    private List<TaskRay> ListaTaskTotale = new List<TaskRay>();
    //private DropDownList ddlActivity;

    public string lProject_id, lActivity_id, lLocationKey, SalesforceTaskID, OpportunityId;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "ORE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        //      Modo di default è insert, se richiamata con id va in change / display
        if (IsPostBack)
        {
            return;
        }

        //      in caso di update recupera il valore del progetto e attività
        if (Request.QueryString["hours_id"] != null)
        {

            Get_record(Request.QueryString["hours_id"]);

            // disabilita form in caso di cutoff
            Label LBdate = (Label)FVore.FindControl("LBdate");
            DateTime dateRecord = Convert.ToDateTime(LBdate.Text);

            // verifica se TR della persona è chiuso
            var trChiuso = Database.RecordEsiste("SELECT * FROM logtr WHERE persons_id=" + CurrentSession.Persons_id + " AND stato=1 AND mese=" + dateRecord.Month.ToString() + " AND anno=" + dateRecord.Year.ToString());

            if (dateRecord < CurrentSession.dCutoffDate || trChiuso)
                FVore.ChangeMode(FormViewMode.ReadOnly);
            else
                FVore.ChangeMode(FormViewMode.Edit);

        }
        else // insert
        {
            FVore.ChangeMode(FormViewMode.Insert);

            Label LBdate = (Label)FVore.FindControl("LBdate");
            LBdate.Text = Request.QueryString["date"];

            Label LBperson = (Label)FVore.FindControl("LBperson");
            LBperson.Text = (string)CurrentSession.UserName;

        }
    }

    protected void Get_record(string strHours_Id)
    {

        DataRow drRecord = Database.GetRow("SELECT Hours.Projects_Id, Hours.Activity_id, Activity.Name AS NomeAttivita, Projects.Name AS NomeProgetto, Hours.LastModificationDate, Hours.CreationDate, Hours.LastModifiedBy, " + "" +
            "Hours.CreatedBy, Hours.AccountingDate, LocationKey, LocationType,SalesforceTaskID, OpportunityId " +
            "FROM Hours " + "" +
            "LEFT OUTER JOIN Activity ON Hours.Activity_id = Activity.Activity_id " +
            "INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id where hours_id = " + strHours_Id, null);

        lProject_id = drRecord["Projects_id"].ToString(); // projects_id
        lActivity_id = drRecord["Activity_id"].ToString(); // activity_id
        lLocationKey = drRecord["LocationType"].ToString() + ":" + drRecord["LocationKey"].ToString(); // LocationKey
        SalesforceTaskID = drRecord["SalesforceTaskID"].ToString(); // activity_id
        OpportunityId = drRecord["OpportunityId"].ToString(); // activity_id

    }

    protected void Bind_DDLprogetto()
    {
        DataTable dtProgettiInDDL = null;

        ddlProject = (DropDownList)FVore.FindControl("DDLprogetto");
        ddlProject.Items.Clear();
        ddlProject.Items.Add(new ListItem(GetLocalResourceObject("DDLprogetto.testo").ToString(), ""));

        // carica progetti forzati in insert e change, tutti i progetti in display per evitare problemi in caso
        // di progetti chiusi
        switch (FVore.CurrentMode)
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

            if (FVore.CurrentMode == FormViewMode.ReadOnly && row["Projects_id"].ToString() != lProject_id)
                row.Delete();
        }
        dtProgettiInDDL.AcceptChanges();

        // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
        foreach (DataRow drRow in dtProgettiInDDL.Rows)
        {
            ListItem liItem = new ListItem(drRow["DescProgetto"].ToString(), drRow["Projects_Id"].ToString());
            liItem.Attributes.Add("data-ActivityOn", drRow["ActivityOn"].ToString());
            if (drRow["ProjectType_Id"].ToString() == ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"]) // Gestione opportunity su progetti BD
                liItem.Attributes.Add("data-OpportunityIsRequired", "True");
            liItem.Attributes.Add("data-desc-obbligatorio", drRow["TestoObbligatorio"].ToString());

            // dati per messaggio di errore
            if (drRow["TestoObbligatorio"].ToString() == "True")
                liItem.Attributes.Add("data-desc-message", drRow["MessaggioDiErrore"].ToString());
            else
                liItem.Attributes.Add("data-desc-message", "");

            // se chargable filtro per cliente, altrimenti per progetto
            string prjType = drRow["ProjectType_Id"].ToString();
            if (prjType == ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"])
                liItem.Attributes.Add("data-filterlocation", drRow["CodiceCliente"].ToString().TrimEnd());
            else if (prjType == ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"] ||
                     prjType == ConfigurationManager.AppSettings["PROGETTO_INTERNAL_INVESTMENT"] ||
                     prjType == ConfigurationManager.AppSettings["PROGETTO_INFRASTRUCTURE"])
                liItem.Attributes.Add("data-filterlocation", drRow["Projects_id"].ToString());

            ddlProject.Items.Add(liItem);
        }

        ddlProject.DataTextField = "DescProgetto";
        ddlProject.DataValueField = "Projects_Id";
        ddlProject.DataBind();
        if (lProject_id != "")
            ddlProject.SelectedValue = lProject_id;

        // se in creazione imposta il default di progetto 
        if (FVore.CurrentMode == FormViewMode.Insert)
            ddlProject.SelectedValue = (string)Session["ProjectCodeDefault"];

    }

    //valorizzazione della DDL delle task di Salesforce
    protected void Bind_DDLTaskSF()
    {
        if (CurrentSession.SalesforceAccount == "")
        {
            return;
        }
        DataTable dtListaTask;

        //valorizzazione con valore default
        DDLTaskName = (DropDownList)FVore.FindControl("DDLTaskName");
        DDLTaskName.Items.Clear();
        DDLTaskName.Items.Add(new ListItem(GetLocalResourceObject("DDLTaskName.testo").ToString(), ""));

        // carica progetti forzati in insert e change, tutti i progetti in display per evitare problemi in caso
        // di progetti chiusi
        switch (FVore.CurrentMode)
        {
            case FormViewMode.Insert:
            case FormViewMode.Edit:
                ListaTaskTotale = CurrentSession.ListaTask;
                //raggruppo tutti codici commessa per poter eseguire la query sul DB
                //var ListaCommesseAE = ListaTaskTotale.GroupBy(u => u.TASKRAY__Project__r.Contratto__r.Commessa_Aeonvis__c).ToList();

                // 18-12-2024 modifica per selezionare correttamente la commessa ferie e permessi
                var ListaCommesseAE = ListaTaskTotale.GroupBy(u => u.Codice_Progetto_TR__c.ToNullToString()).ToList();

                //preparo la variabile per eseguire la select con IN, in questo modo eseguo una sola select
                string Commesse = "";
                for (int i = 0; i < ListaCommesseAE.Count; i++)
                {
                    Commesse += string.Format("'{0}'", ListaCommesseAE[i].Key).ToString() + ",";
                }
                //tolgo ultima virgola alla variabile
                if (clsUtility.NullToString(Commesse) != "")
                {
                    Commesse = Commesse.Substring(0, Commesse.Length - 1);
                }

                //selezioni dal database tutti i progetti contenutio nelle task di SF
                DataTable dtAct = Database.GetData(string.Format("SELECT [Projects_Id],[ProjectCode] FROM [Projects] WHERE [ProjectCode] in ({0}) ", Commesse), null);

                // aggiunge gli item con l'attributo project_id per valorizzare automaticamente la DDL dei preogetti
                foreach (TaskRay Task in CurrentSession.ListaTask)
                {
                    ListItem liItem = new ListItem(Task.TASKRAY__Project__r.Name.ToString() + " - " + Task.Name.ToString(), Task.Id.ToString());
                    //string ProjectCode = Task.TASKRAY__Project__r.Contratto__r.Commessa_Aeonvis__c.ToString();

                    // 18-12-2024 modifica per selezionare correttamente la commessa ferie e permessi
                    string ProjectCode = Task.Codice_Progetto_TR__c.ToNullToString();
                    //controllo se esiste dai progetti ricercati precedentemente
                    if (dtAct.Select(string.Format("ProjectCode='{0}'", ProjectCode)).Count() == 1)
                    {
                        //se esiste aggiungo attrib
                        liItem.Attributes.Add("data-Projects_Id", dtAct.Select(string.Format("ProjectCode='{0}'", ProjectCode))[0]["Projects_Id"].ToString());
                        //se esiste aggiungo attrib
                        liItem.Attributes.Add("data-Projects_Name", ProjectCode);
                    }

                    DDLTaskName.Items.Add(liItem);
                }

                break;

            case FormViewMode.ReadOnly:

                DDLTaskName.DataSource = CurrentSession.ListaTask;
                break;
        }

        DDLTaskName.DataTextField = "Name";
        DDLTaskName.DataValueField = "id";
        DDLTaskName.DataBind();
        //se presente valore preso dal calendario valorizzo
        if (SalesforceTaskID != "")
            DDLTaskName.SelectedValue = SalesforceTaskID;

    }

    protected void Bind_DDLOpportunita()
    {
        DropDownList DDLOpportunity;
        List<Opportunity> ListaOpportunita = new List<Opportunity>();

        //valorizzazione con valore default
        DDLOpportunity = (DropDownList)FVore.FindControl("DDLOpportunity");
        DDLOpportunity.Items.Clear();
        DDLOpportunity.Items.Add(new ListItem("seleziona una opportunit&agrave", ""));

        if (FVore.CurrentMode == FormViewMode.Insert | FVore.CurrentMode == FormViewMode.Edit)
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

        if (FVore.CurrentMode == FormViewMode.Insert)
            DDLOpportunity.SelectedValue = (string)Session["OpportunityDefault"];
        else
            DDLOpportunity.SelectedValue = OpportunityId;
    }

    public void Bind_DDLAttivita()
    {
        DropDownList ddlActivity = (DropDownList)FVore.FindControl("DDLHidden");
        DropDownList ddlLocation = (DropDownList)FVore.FindControl("DDLHiddenLocation");

        DropDownList ddlActivity_temp = (DropDownList)FVore.FindControl("DDLAttivita");
        DropDownList ddlLocation_temp = (DropDownList)FVore.FindControl("DDLLocation");

        DataTable dtAct;

        // se display carica tutte le attività, altrimenti solo quelle attive
        if (FVore.CurrentMode != FormViewMode.ReadOnly)
            dtAct = Database.GetData("select Activity_id, ActivityCode + '  ' + left(a.Name,20) AS DescActivity, a.Projects_id FROM Activity as a JOIN Projects as b ON b.Projects_id = a.Projects_id where b.active = 'true' AND a.active = 'true' ORDER BY ActivityCode", null);
        else
            dtAct = Database.GetData("select Activity_id, ActivityCode + '  ' + left(a.Name,20) AS DescActivity, a.Projects_id FROM Activity as a JOIN Projects as b ON b.Projects_id = a.Projects_id ORDER BY ActivityCode", null);

        // ** carica location in DDLHiddenLocation
        ddlLocation.Items.Clear();
        ddlLocation_temp.Items.Clear();

        ListItem liEmpty = new ListItem("-- selezionare un valore --", "");
        ddlLocation.Items.Add(liEmpty);
        ddlLocation_temp.Items.Add(liEmpty);

        // loop su tutte le location bufferizzate e carica elemento della DDL
        foreach (LocationRecord rec in CurrentSession.LocationList)
        {
            ListItem liItem = new ListItem(rec.LocationDescription, rec.LocationType + ":" + rec.LocationKey); // chiave dell'item DDL fatta da "P/C" + ":" + Location_id
            // chiave codice cliente o Projects_id, usato per filtrare con jquery le opzioni
            liItem.Attributes.Add("data-filterlocation", rec.ParentKey);
            ddlLocation.Items.Add(liItem);
            ddlLocation_temp.Items.Add(liItem);
        }

        ListItem liEmpty3 = new ListItem("-- Testo Libero --", "T:99999");
        ddlLocation.Items.Add(liEmpty3);
        ddlLocation_temp.Items.Add(liEmpty3);

        ddlLocation.DataTextField = "LocationDescription";
        ddlLocation.DataValueField = "LocationKey";
        ddlLocation.DataBind();

        ddlLocation_temp.DataTextField = "LocationDescription";
        ddlLocation_temp.DataValueField = "LocationKey";
        ddlLocation_temp.DataBind();

        // ** carica Attività in DDLHidden **
        ddlActivity.Items.Clear();
        ddlActivity_temp.Items.Clear();

        ListItem liEmpty2 = new ListItem("-- selezionare un valore --", "");
        ddlActivity.Items.Add(liEmpty2);
        ddlActivity_temp.Items.Add(liEmpty2);

        foreach (DataRow drRow in dtAct.Rows)
        {
            ListItem liItem = new ListItem(drRow["DescActivity"].ToString(), drRow["Activity_id"].ToString());
            liItem.Attributes.Add("data-projects_id", drRow["Projects_id"].ToString());
            ddlActivity.Items.Add(liItem);
            ddlActivity_temp.Items.Add(liItem);
        }

        ddlActivity.DataTextField = "iActivity";
        ddlActivity.DataValueField = "Activity_id";
        ddlActivity.DataBind();

        ddlActivity_temp.DataTextField = "iActivity";
        ddlActivity_temp.DataValueField = "Activity_id";
        ddlActivity_temp.DataBind();

        ddlActivity.SelectedValue = lActivity_id != "" ? lActivity_id : "";
        ddlLocation.SelectedValue = lLocationKey != "" ? lLocationKey : "";

        // se in creazione imposta il default di progetto 
        if (FVore.CurrentMode == FormViewMode.Insert & dtAct.Rows.Count > 0)
        {
            ddlActivity.SelectedValue = (string)Session["ActivityDefault"];
            //ddlLocation.SelectedValue = (string)Session["LocationDefault"]; non vogliamo default sulla location
        }
    }

    protected void FVore_modechanging(object sender, FormViewModeEventArgs e)
    {
        //      se premuto tasto cancel torna indietro
        if (e.CancelingEdit)
            Response.Redirect("input.aspx");
    }

    protected void FVore_DataBound(object sender, EventArgs e)
    {
        //      formattta il campo numerico delle ore, nel DB le ore stornate sono negative
        if (Request.QueryString["action"] == "fetch")
        {
            TextBox TBHours1 = (TextBox)FVore.FindControl("HoursTextBox");
            double HoursValue = Math.Abs(Convert.ToDouble(TBHours1.Text));
            TBHours1.Text = HoursValue.ToString();
        }

        if (Request.QueryString["hours_id"] != null)
        {
            //              Valorizza progetto e attività
            Bind_DDLprogetto();
            Bind_DDLAttivita();
            Bind_DDLTaskSF();
            Bind_DDLOpportunita();
        }
        else // insert
        {
            Bind_DDLprogetto();
            Bind_DDLAttivita();
            Bind_DDLTaskSF();
            Bind_DDLOpportunita();
        }

        //      se livello autorizzativo è inferiore a 4 spegne il campo competenza
        if (!Auth.ReturnPermission("ADMIN", "CUTOFF"))
        {
            Label LBAccountingDate = (Label)FVore.FindControl("LBAccountingDate");
            TextBox TBAccountingDate = (TextBox)FVore.FindControl("TBAccountingDate");
            Label LBCancel = (Label)FVore.FindControl("CancelFlagLabel");
            CheckBox TBCancel = (CheckBox)FVore.FindControl("CancelFlagCheckBox");

            // se display
            LBAccountingDate.Visible = false;
            TBAccountingDate.Visible = false;
            LBCancel.Visible = false;
            TBCancel.Visible = false;

        }
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }

    /// <summary>
    /// rfresh delle task di salesforce
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        DDLTaskName = (DropDownList)FVore.FindControl("DDLTaskName");
        DDLTaskName.Items.Clear();
        //DDLTaskName.Items.Add(new ListItem(GetLocalResourceObject("DDLTaskName.testo").ToString(), ""));
        CurrentSession.LoadSFTask();
        Bind_DDLTaskSF();
    }
}