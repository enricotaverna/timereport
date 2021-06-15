using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.Threading;

public partial class input_ore : System.Web.UI.Page
{

    private DropDownList ddlProject;
    //private DropDownList ddlActivity;

    public string lProject_id, lActivity_id, lLocationKey;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "ORE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        //      Modo di default è insert, se richiamata con id va in change / display
        if (IsPostBack)
            return;

        //      in caso di update recupera il valore del progetto e attività
        if (Request.QueryString["hours_id"] != null)
        {

            Get_record(Request.QueryString["hours_id"]);

            //              disabilita form in caso di cutoff
            Label LBdate = (Label)FVore.FindControl("LBdate");

            if (Convert.ToDateTime(LBdate.Text) < CurrentSession.dCutoffDate)
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

        DataRow drRecord = Database.GetRow("SELECT Hours.Projects_Id, Hours.Activity_id, Activity.Name AS NomeAttivita, Projects.Name AS NomeProgetto, Hours.LastModificationDate, Hours.CreationDate, Hours.LastModifiedBy, Hours.CreatedBy, Hours.AccountingDate, LocationKey, LocationType FROM Hours LEFT OUTER JOIN Activity ON Hours.Activity_id = Activity.Activity_id INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id where hours_id = " + strHours_Id, null);

        lProject_id = drRecord["Projects_id"].ToString(); // projects_id
        lActivity_id = drRecord["Activity_id"].ToString(); // activity_id
        lLocationKey = drRecord["LocationType"].ToString() + ":" + drRecord["LocationKey"].ToString(); // LocationKey

    }

    protected void Bind_DDLprogetto()
    {
        DataTable dtProgettiForzati;

        ddlProject = (DropDownList)FVore.FindControl("DDLprogetto");
        ddlProject.Items.Clear();
        ddlProject.Items.Add(new ListItem(GetLocalResourceObject("DDLprogetto.testo").ToString(), ""));

        // carica progetti forzati in insert e change, tutti i progetti in display per evitare problemi in caso
        // di progetti chiusi
        switch (FVore.CurrentMode)
        {
            case FormViewMode.Insert:
            case FormViewMode.Edit:
                dtProgettiForzati = CurrentSession.dtProgettiForzati;

                // cancella le righe soggette a Workflow
                //var rows = dtProgettiForzati.Select("WorkflowType != null");
                foreach (DataRow row in dtProgettiForzati.Rows)
                {
                    if (row["WorkflowType"].ToString() != "") // gestito con WF -> cancella
                        row.Delete();
                }
                dtProgettiForzati.AcceptChanges();

                // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
                foreach (DataRow drRow in dtProgettiForzati.Rows)
                {
                    ListItem liItem = new ListItem(drRow["DescProgetto"].ToString(), drRow["Projects_Id"].ToString());
                    liItem.Attributes.Add("data-ActivityOn", drRow["ActivityOn"].ToString());
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

                break;

            case FormViewMode.ReadOnly:

                ddlProject.DataSource = CurrentSession.dtProgettiTutti;
                break;
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

    public void Bind_DDLAttivita()
    {
        DropDownList ddlActivity = (DropDownList)FVore.FindControl("DDLHidden");
        DropDownList ddlLocation = (DropDownList)FVore.FindControl("DDLHiddenLocation");

        DropDownList ddlActivity_temp = (DropDownList)FVore.FindControl("DDLAttivita");
        DropDownList ddlLocation_temp = (DropDownList)FVore.FindControl("DDLLocation");

        DataTable dtAct = Database.GetData("select Activity_id, ActivityCode + '  ' + left(a.Name,20) AS DescActivity, a.Projects_id FROM Activity as a JOIN Projects as b ON b.Projects_id = a.Projects_id where b.active = 'true' AND a.active = 'true' ORDER BY ActivityCode", null);

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

    protected void FVore_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {

        Response.Redirect("input.aspx");
    }

    protected void FVore_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("input.aspx");
    }

    protected void DSore_Insert_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        //      Chiamato in aggiornamento e inserimento record rende negativo il valore delle ore
        //      nel caso sia valorizzato il flag storno         
        decimal iCalc = 0;

        CheckBox CBcancel = (CheckBox)FVore.FindControl("CancelFlagCheckBox");
        TextBox TBAccountingDate = (TextBox)FVore.FindControl("TBAccountingDate");

        if (CBcancel.Checked)
        {
            iCalc = Convert.ToDecimal(e.Command.Parameters["@Hours"].Value) * (-1);
            e.Command.Parameters["@Hours"].Value = iCalc;
        }
        else
        {
            e.Command.Parameters["@Hours"].Value = Convert.ToDecimal(e.Command.Parameters["@Hours"].Value);
        }

        //      Forza i valori da passare alla select di insert. essendo le dropdown in
        //      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVore.FindControl("DDLprogetto");
        e.Command.Parameters["@Projects_id"].Value = ddlList.SelectedValue;

        DropDownList ddlList1 = (DropDownList)FVore.FindControl("DDLAttivita");
        if (ddlList1.SelectedValue != null)
            e.Command.Parameters["@Activity_id"].Value = ddlList1.SelectedValue;

        // Se valorizzato la DDL
        DropDownList ddlList2 = (DropDownList)FVore.FindControl("DDLLocation");
        if (ddlList2.SelectedValue != "")
        {
            e.Command.Parameters["@LocationKey"].Value = ddlList2.SelectedValue.Substring(2); // chiave della location
            e.Command.Parameters["@LocationType"].Value = ddlList2.SelectedValue.Substring(0, 1); // tipo C o P della location
            e.Command.Parameters["@LocationDescription"].Value = ddlList2.SelectedItem.Text;
        }

        // Se valorizzato il testo libero
        TextBox TBLocation = (TextBox)FVore.FindControl("TBLocation");
        if (TBLocation.Text != "")
        {
            e.Command.Parameters["@LocationDescription"].Value = TBLocation.Text;
            e.Command.Parameters["@LocationType"].Value = "T";
            e.Command.Parameters["@LocationKey"].Value = "99999";
        }

        // salva default per select list
        Session["ProjectCodeDefault"] = ddlList.SelectedValue;
        Session["ActivityDefault"] = ddlList1.SelectedValue;
        Session["LocationDefault"] = ddlList2.SelectedValue;

        // solo insert
        if (FVore.CurrentMode == FormViewMode.Insert)
        {
            e.Command.Parameters["@Persons_id"].Value = CurrentSession.Persons_id;
            Label LBdate = (Label)FVore.FindControl("LBdate");
            e.Command.Parameters["@Date"].Value = Convert.ToDateTime(LBdate.Text);
            // Audit
            e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserName;
            e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
            // valori manager e società
            e.Command.Parameters["@Company_id"].Value = CurrentSession.Company_id;
            var result = Utilities.GetManagerAndAccountId(Convert.ToInt32(ddlList.SelectedValue));
            e.Command.Parameters["@ClientManager_id"].Value = result.Item1; // ClientManager_id
            e.Command.Parameters["@AccountManager_id"].Value = result.Item2; // AccountManager_id
        }

        // if in change
        if (FVore.CurrentMode == FormViewMode.Edit)
        {
            // Audit
            e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserName;
            e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
        }
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
        }
        else // insert
        {
            Bind_DDLprogetto();
            Bind_DDLAttivita();
        }

        //      se livello autorizzativo è inferiore a 4 spegne il campo competenza
        if (!Auth.ReturnPermission("ADMIN", "CUTOFF"))
        {
            Label LBAccountingDate = (Label)FVore.FindControl("LBAccountingDate");
            TextBox TBAccountingDate = (TextBox)FVore.FindControl("TBAccountingDate");

            // se display
            LBAccountingDate.Visible = false;
            TBAccountingDate.Visible = false;

        }
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}