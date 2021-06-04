using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class m_gestione_Activity_activity_lookup_form : System.Web.UI.Page
{

    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
    static string prevPage = String.Empty;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack )
        {

            prevPage = Request.UrlReferrer.ToString();

            if (Request.QueryString["Activity_id"] != null )
            {
                FVattivita.ChangeMode(FormViewMode.Edit);
                FVattivita.DefaultMode = FormViewMode.Edit;
            }
//          popola dropdownlist progetto
            LoadDDLprogetto();

            Bind_ddlFase();

        }

    }  
  
    protected void LoadDDLprogetto()
    {

            conn.Open();

            SqlCommand cmd = new SqlCommand("Select Projects_id, ProjectCode + ' ' + left(Name,20) as iProgetto from Projects where ActivityOn = 1 AND ClientManager_id = " + CurrentSession.Persons_id + " ORDER BY iProgetto", conn);
        
            SqlDataReader dr = cmd.ExecuteReader();
            DropDownList ddlList = (DropDownList)FVattivita.FindControl("DDLprogetto");

            ddlList.DataSource = dr;
            ddlList.Items.Clear();
            ddlList.Items.Add(new ListItem("--Seleziona progetto--", ""));
            
            ddlList.DataTextField = "iProgetto";
            ddlList.DataValueField = "Projects_Id";
            if ( Request.QueryString["Projects_id"] != null ) // in caso di update seleziona il valore nella dropdown list
                ddlList.SelectedValue = Request.QueryString["Projects_id"].ToString();
            ddlList.DataBind();
            conn.Close();
            
    }

    public void Bind_ddlFase()
    {
        conn.Open();

        DropDownList ddlprogetto = (DropDownList)FVattivita.FindControl("DDLProgetto");

        SqlCommand cmd = new SqlCommand("select Phase_id, PhaseCode + '  ' + left(Name,20) AS iFase FROM Phase where Projects_id='" + ddlprogetto.SelectedValue + "' ORDER BY iFase", conn);
        SqlDataReader dr = cmd.ExecuteReader();

        DropDownList ddlList = (DropDownList)FVattivita.FindControl("DDLFase");
        ddlList.DataSource = dr;
        ddlList.Items.Clear();
        ddlList.Items.Add(new ListItem("--Seleziona fase--", ""));
        ddlList.DataTextField = "iFase";
        ddlList.DataValueField = "Phase_id";
        if ( Request.QueryString["Phase_Id"] != null && !IsPostBack ) // in caso di update seleziona il valore nella dropdown list
            ddlList.SelectedValue = Request.QueryString["Phase_Id"];
        ddlList.DataBind();
        conn.Close();
    }


    protected void DDLProgetto_SelectedIndexChanged(object sender, EventArgs e)
    {

        Bind_ddlFase();
    }

    protected void ItemUpdating_FVattivita(object sender, FormViewUpdateEventArgs e)
    {
        //      Forza i valori da passare alla select di insert. essendo le dropdown in
        //      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVattivita.FindControl("DDLprogetto");
        e.NewValues["Projects_id"] = ddlList.SelectedValue;

        DropDownList ddlList1 = (DropDownList)FVattivita.FindControl("DDLFase");
        e.NewValues["Phase_id"] = ddlList1.SelectedValue;

    }

    protected void ItemInserting_FVattivita(object sender, FormViewInsertEventArgs e)
    {
//      Forza i valori da passare alla select di insert. essendo le dropdown in
//      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVattivita.FindControl("DDLprogetto");
        e.Values["Projects_id"] = ddlList.SelectedValue;
        
        DropDownList ddlList1 = (DropDownList)FVattivita.FindControl("DDLFase");
        e.Values["Phase_id"] = ddlList1.SelectedValue;
    }

    protected void ItemInserted_FVattivita(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("activity_lookup_list.aspx");
    }
    protected void ItemUpdated_FVattivita(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect(prevPage);
    }
    protected void ItemModeChanging_FVattivita(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit )
            Response.Redirect(prevPage);        
    }
    protected void ValidaAttivita_ServerValidate(object source, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();
        //      true se non esiste già il record 
        args.IsValid = !c.CheckExistence("ActivityCode", args.Value, "Activity");

        //      cambia colore del campo in errore
        c.SetErrorOnField(args.IsValid, FVattivita, "ActivityCodeTextBox");

    }
}

