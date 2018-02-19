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
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    public string lProject_id, lActivity_id;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "ORE");

        // Evidenzia campi form in errore
        Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "val", "fnOnUpdateValidators();");
      
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

        SqlCommand cmd = new SqlCommand("SELECT Hours.Projects_Id, Hours.Activity_id, Activity.Name AS NomeAttivita, Projects.Name AS NomeProgetto, Hours.LastModificationDate, Hours.CreationDate, Hours.LastModifiedBy, Hours.CreatedBy, Hours.AccountingDate FROM Hours LEFT OUTER JOIN Activity ON Hours.Activity_id = Activity.Activity_id INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id where hours_id = " + strHours_Id, conn);

        conn.Open();

        SqlDataReader dr = cmd.ExecuteReader();
        dr.Read();

        lProject_id = dr["Projects_id"].ToString(); // projects_id
        lActivity_id = dr["Activity_id"].ToString(); // activity_id

        conn.Close();
    }

    protected void Bind_DDLprogetto()
    {

        conn.Open();

        SqlCommand cmd;
        
        // imposta selezione progetti in base all'utente

        if (Convert.ToInt32(Session["ForcedAccount"]) != 1)
            cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto FROM Projects WHERE active = 'true' ORDER BY ProjectCode", conn);
        else
            cmd = new SqlCommand("SELECT DISTINCT Projects.Projects_Id, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto, ProjectCode FROM Projects " +
                                       " INNER JOIN ForcedAccounts ON Projects.Projects_id = ForcedAccounts.Projects_id " +
                                       " WHERE ( ForcedAccounts.Persons_id=" + Session["persons_id"] + " OR Projects.Always_available = 'true')" +
                                       " AND active = 'true' ORDER BY Projects.ProjectCode", conn);

        SqlDataReader dr = cmd.ExecuteReader();
        ddlProject = (DropDownList)FVore.FindControl("DDLprogetto");

        ddlProject.DataSource = dr;
        ddlProject.Items.Clear();
        ddlProject.Items.Add(new ListItem(GetLocalResourceObject("DDLprogetto.testo").ToString(), "0"));             
        ddlProject.DataTextField = "iProgetto";
        ddlProject.DataValueField = "Projects_Id";
        ddlProject.DataBind();
        if (lProject_id != "")
            ddlProject.SelectedValue = lProject_id;

        // se in creazione imposta il default di progetto 
        if (FVore.CurrentMode == FormViewMode.Insert)
            ddlProject.SelectedValue = (string)Session["ProjectCodeDefault"];

        conn.Close();
    }

    public void Bind_DDLAttivita()
    {
        conn.Open();

        DropDownList ddlprogetto = (DropDownList)FVore.FindControl("DDLProgetto");

        SqlCommand cmd = new SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS iActivity FROM Activity where Projects_id='" + ddlprogetto.SelectedValue + "' AND active = 'true' ORDER BY ActivityCode", conn);
        SqlDataReader dr = cmd.ExecuteReader();

        ddlActivity = (DropDownList)FVore.FindControl("DDLAttivita");
        ddlActivity.DataSource = dr;
        ddlActivity.Items.Clear();
        ddlActivity.Items.Add(new ListItem(GetLocalResourceObject("DDLAttivita.testo").ToString(), ""));   
        ddlActivity.DataTextField = "iActivity";
        ddlActivity.DataValueField = "Activity_id";
        ddlActivity.DataBind();

        if (lActivity_id != "")
            ddlActivity.SelectedValue = lActivity_id;
        else
            ddlActivity.SelectedValue = "";

        ddlActivity.Visible = true;

        // Se il progetto prevede attività rende il controllo visibile 
        if (!dr.HasRows)
            ddlActivity.Enabled = false;
        else
            ddlActivity.Enabled = true;

        // se in creazione imposta il default di progetto 
        if (FVore.CurrentMode == FormViewMode.Insert & dr.HasRows)
            ddlActivity.SelectedValue = (string)Session["ActivityDefault"];

        conn.Close();
    }

    protected void DDLProgetto_SelectedIndexChanged(object sender, EventArgs e)
    {
        Bind_DDLAttivita();
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
            Label LBAccountingDateDisplay = (Label)FVore.FindControl("LBAccountingDateDisplay");

            // se display
            LBAccountingDate.Visible = false;

            if (TBAccountingDate != null)
                TBAccountingDate.Visible = false;

            if (LBAccountingDateDisplay != null)
                LBAccountingDateDisplay.Visible = false;
        }     
    }

    protected void CV_TBComment_ServerValidate(object source, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();
        TextBox TBtoValidate = (TextBox)FVore.FindControl("TBComment");
        DropDownList DDLprogetto = (DropDownList)FVore.FindControl("DDLprogetto");
        CustomValidator CV_TBComment = (CustomValidator)FVore.FindControl("CV_TBComment");

        Boolean bTestoObbligatorio = false;
        string sMessaggioDiErrore = "";

        // Legge il flag di commento obbligatorio su tipo spesa
        using (SqlDataReader rdr = Database.GetReader("Select TestoObbligatorio, MessaggioDiErrore from Projects where Projects_Id = " + DDLprogetto.SelectedValue, this.Page))
        {
            if (rdr != null)
                while (rdr.Read())
                {
                    bTestoObbligatorio = (rdr["TestoObbligatorio"] == DBNull.Value) ? false : Convert.ToBoolean(rdr["TestoObbligatorio"]);
                    sMessaggioDiErrore = rdr["MessaggioDiErrore"].ToString();
                } // endwhile
        }  // using

        if (TBtoValidate.Text.Trim().Length == 0 && bTestoObbligatorio)
        {
            args.IsValid = false;

            // imposta il messaggio di errore letto dal tipo spesa
            CV_TBComment.ErrorMessage = sMessaggioDiErrore;

            //      cambia colore del campo in errore
            c.SetErrorOnField(args.IsValid, FVore, "TBComment");
        }
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}