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
    private DropDownList ddlActivity;
   
    // attivata MARS 

    public string lProject_id, lActivity_id;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "ORE");
      
//      Modo di default è insert, se richiamata con id va in change / display
        if (IsPostBack)
            return;

//      in caso di update recupera il valore del progetto e attività
        if (Request.QueryString["hours_id"] != null)
            {
                Get_record(Request.QueryString["hours_id"]);

//              disabilita form in caso di cutoff
                Label LBdate = (Label)FVore.FindControl("LBdate");

                if (Convert.ToDateTime(LBdate.Text) < Convert.ToDateTime(Session["CutoffDate"]))
                    FVore.ChangeMode(FormViewMode.ReadOnly);
                else
                    FVore.ChangeMode(FormViewMode.Edit);

            } 
            else // insert
            {
                FVore.ChangeMode(FormViewMode.Insert);

                Label LBdate = (Label)FVore.FindControl("LBdate");
                LBdate.Text = Request.QueryString["date"];
            
                Label LBperson =   (Label)FVore.FindControl("LBperson");
                LBperson.Text = (string)Session["UserName"];
        }

    }

    protected void ValidaAttivita(object source, ServerValidateEventArgs args)
    {
        DropDownList ddlActivity = (DropDownList)FVore.FindControl("DDLAttivita");
        ValidationClass c = new ValidationClass();

        if (ddlActivity.Enabled && ddlActivity.SelectedValue == "")
             args.IsValid = false;               
        else
            args.IsValid = true;

        // accende / spegne campo in errore
        c.SetErrorOnField(args.IsValid,FVore,"DDLAttivita");
        
    }

    protected void Get_record(string strHours_Id)
    {

        DataRow drRecord = Database.GetRow("SELECT Hours.Projects_Id, Hours.Activity_id, Activity.Name AS NomeAttivita, Projects.Name AS NomeProgetto, Hours.LastModificationDate, Hours.CreationDate, Hours.LastModifiedBy, Hours.CreatedBy, Hours.AccountingDate FROM Hours LEFT OUTER JOIN Activity ON Hours.Activity_id = Activity.Activity_id INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id where hours_id = " + strHours_Id, null);

        lProject_id = drRecord["Projects_id"].ToString(); // projects_id
        lActivity_id = drRecord["Activity_id"].ToString(); // activity_id
    }

    protected void Bind_DDLprogetto()
    {

        DataTable dtProgettiForzati = (DataTable)Session["dtProgettiForzati"];

        // cancella le righe soggette a Workflow
        //var rows = dtProgettiForzati.Select("WorkflowType != null");
        foreach (DataRow row in dtProgettiForzati.Rows) { 
            if ( row["WorkflowType"].ToString() != "") // gestito con WF -> cancella
                row.Delete();
        }
        dtProgettiForzati.AcceptChanges();

        ddlProject = (DropDownList)FVore.FindControl("DDLprogetto");

        ddlProject.Items.Clear();
        ddlProject.Items.Add(new ListItem(GetLocalResourceObject("DDLprogetto.testo").ToString(), ""));

        // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
        foreach (DataRow drRow in dtProgettiForzati.Rows)
        {
            ListItem liItem = new ListItem(drRow["DescProgetto"].ToString(), drRow["Projects_Id"].ToString());
            liItem.Attributes.Add("data-ActivityOn", drRow["ActivityOn"].ToString());
            liItem.Attributes.Add("data-desc-obbligatorio", drRow["TestoObbligatorio"].ToString());

            if (drRow["TestoObbligatorio"].ToString() == "True")
                liItem.Attributes.Add("data-desc-message", drRow["MessaggioDiErrore"].ToString());
            else
                liItem.Attributes.Add("data-desc-message", "");

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

    public void Bind_DDLAttivita()
    {

        DropDownList ddlActivity = (DropDownList)FVore.FindControl("DDLHidden");

        DropDownList ddlActivity_temp = (DropDownList)FVore.FindControl("DDLAttivita");

        DataTable dtAct = Database.GetData("select Activity_id, ActivityCode + '  ' + left(a.Name,20) AS DescActivity, a.Projects_id FROM Activity as a JOIN Projects as b ON b.Projects_id = a.Projects_id where b.active = 'true' AND a.active = 'true' ORDER BY ActivityCode", null);

        ddlActivity.Items.Clear();
        ddlActivity_temp.Items.Clear();

        ListItem liEmpty = new ListItem("-- selezionare un valore --", "");
        ddlActivity.Items.Add(liEmpty);
        ddlActivity_temp.Items.Add(liEmpty);

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

        if (lActivity_id != "")
            ddlActivity.SelectedValue = lActivity_id;
        else
            ddlActivity.SelectedValue = "";

        //ddlActivity.Visible = true;

        // Se il progetto prevede attività rende il controllo visibile 
        //if (dtAct.Rows.Count > 0 && FVore.CurrentMode != FormViewMode.ReadOnly)
        //    ddlActivity.Enabled = true;
        //else
        //    ddlActivity.Enabled = false;

        // se in creazione imposta il default di progetto 
        if (FVore.CurrentMode == FormViewMode.Insert & dtAct.Rows.Count > 0)
            ddlActivity.SelectedValue = (string)Session["ActivityDefault"];

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
       
        // salva default per select list
        Session["ProjectCodeDefault"] = ddlList.SelectedValue;
        Session["ActivityDefault"] = ddlList1.SelectedValue;

        // solo insert
        if (FVore.CurrentMode == FormViewMode.Insert)
        {
            e.Command.Parameters["@Persons_id"].Value = Session["persons_id"];
            Label LBdate = (Label)FVore.FindControl("LBdate");
            e.Command.Parameters["@Date"].Value = Convert.ToDateTime(LBdate.Text);
            // Audit
            e.Command.Parameters["@CreatedBy"].Value = Session["UserId"];
            e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
        }

        // if in change
        if (FVore.CurrentMode == FormViewMode.Edit)
        {
            // Audit
            e.Command.Parameters["@LastModifiedBy"].Value = Session["UserId"];  
            e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
        }
    }

    protected void FVore_DataBound(object sender, EventArgs e)
    {
//      formattta il campo numerico delle ore, nel DB le ore stornate sono negative
        if (Request.QueryString["action"] == "fetch") {
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
        if ( !Auth.ReturnPermission("ADMIN", "CUTOFF") )
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