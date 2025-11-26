using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class m_gestione_Canoni_montly_fee_lookup_form : System.Web.UI.Page
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

            if (Request.QueryString["Monthly_Fee_id"] != null )
            {
                FVCanoni.ChangeMode(FormViewMode.Edit);
                FVCanoni.DefaultMode = FormViewMode.Edit;
            }
//          popola dropdownlist progetto
            LoadDDLprogetto();

        }

    }  
  
    protected void LoadDDLprogetto()
    {
            conn.Open();
        string sqlCmd;

            // visualizza solo progetti del manager
            if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
                sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Name,20) as iProgetto from Projects where active = 1 AND ClientManager_id = " + CurrentSession.Persons_id + " ORDER BY iProgetto";
            else
                sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Name,20) as iProgetto from Projects where active = 1  ORDER BY iProgetto";

            SqlCommand cmd = new SqlCommand(sqlCmd, conn);
        
            SqlDataReader dr = cmd.ExecuteReader();
            DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");

            ddlList.DataSource = dr;
            ddlList.Items.Clear();
            ddlList.Items.Add(new ListItem("--Seleziona progetto--", ""));
            
            ddlList.DataTextField = "iProgetto";
            ddlList.DataValueField = "Projects_id";
            if ( Request.QueryString["Projects_id"] != null ) // in caso di update seleziona il valore nella dropdown list
                ddlList.SelectedValue = Request.QueryString["Projects_id"].ToString();
            ddlList.DataBind();
            conn.Close();
            
    }

    protected void ItemUpdating_FVCanoni(object sender, FormViewUpdateEventArgs e)
    {
        //      Forza i valori da passare alla select di insert. essendo le dropdown in
        //      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");
        e.NewValues["Projects_id"] = ddlList.SelectedValue;

        // 2. Inserisci il valore della persona loggata nella collezione dei parametri
        // Assumendo che la tua proprietà sia CurrentSession.UserName
        DSCanoni.UpdateParameters["persons_Name"].DefaultValue = CurrentSession.UserName;
    }

    protected void ItemInserting_FVCanoni(object sender, FormViewInsertEventArgs e)
    {
//      Forza i valori da passare alla select di insert. essendo le dropdown in
//      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");
        e.Values["Projects_id"] = ddlList.SelectedValue;        
    }

    protected void ItemInserted_FVCanoni(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("montly_fee_lookup_list.aspx");
    }
    protected void ItemUpdated_FVCanoni(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect(prevPage);
    }
    protected void ItemModeChanging_FVCanoni(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit )
            Response.Redirect(prevPage);        
    }   
}

