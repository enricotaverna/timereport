using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class mass_insert_hours : System.Web.UI.Page
{
    public TRSession CurrentSession;

    protected void DDLTipoOraFt_DataBound(object sender, EventArgs e)
    {
        // Imposta valore di default
        ((DropDownList)sender).Items.FindByText("STD001 Standard").Selected = true;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string currentDate = DateTime.Now.ToString("dd/MM/yyyy");
            TB_Datada.Text = currentDate;
        }

        string sWhere = "";

        Auth.CheckPermission("ADMIN", "MASSCHANGE");
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (DDL_Persona_Sel.SelectedValue != "all" || (Session["DDL_Persona_Sel"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ?
                " WHERE Hours.Persons_id = @DDL_Persona_Sel" :
                sWhere + " AND Hours.Persons_id = @DDL_Persona_Sel";
        }

        if (DDL_Progetti_Sel.SelectedValue != "all" || (Session["DDL_Progetti_Sel"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ?
                " WHERE Hours.Projects_id = @DDL_Progetti_Sel" :
                sWhere + " AND Hours.Projects_id = @DDL_Progetti_Sel";
        }

        if (!string.IsNullOrEmpty(TB_Datada.Text) || (Session["TB_Datada"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ?
                " WHERE Hours.Date >= @TB_Datada" :
                sWhere + " AND Hours.Date >= @TB_Datada";
        }

        if (!string.IsNullOrEmpty(TB_DataA.Text) || (Session["TB_DataA"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ?
                " WHERE Hours.Date <= @TB_DataA" :
                sWhere + " AND Hours.Date <= @TB_DataA";
        }

        DShours.SelectCommand = "SELECT TOP(50) Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.AccountingDate, Hours.LocationKey, Hours.LocationType, Hours.LocationDescription, Hours.SalesforceTaskId, Hours.CancelFlag, Hours.Comment, Persons.Name AS NomePersona, " +
                                " Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto, Activity.Activity_Id , Activity.ActivityCode + ' ' + Activity.Name AS NomeAttivita, OpportunityId FROM Hours INNER JOIN Projects ON Hours.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id" +
                                " LEFT JOIN Activity ON Activity.Activity_id = Hours.Activity_id " + sWhere + " ORDER BY Hours.Date, Hours.Projects_ID, Hours.Persons_Id";

    }

    protected void DDL_Persona_Sel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DDL_Persona_Sel"] = ((DropDownList)sender).SelectedValue != "all" ? ((DropDownList)sender).SelectedValue : null;
    }

    protected void DDL_Persona_Sel_DataBound(object sender, EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DDL_Persona_Sel"] != null)
        {
            DDL_Persona_Sel.SelectedValue = Session["DDL_Persona_Sel"].ToString();
        }
    }

    protected void DDL_Progetti_Sel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DDL_Progetti_Sel"] = ((DropDownList)sender).SelectedValue != "all" ? ((DropDownList)sender).SelectedValue : null;
    }

    protected void DDL_Progetti_Sel_DataBound(object sender, EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DDL_Progetti_Sel"] != null)
        {
            DDL_Progetti_Sel.SelectedValue = Session["DDL_Progetti_Sel"].ToString();
        }
    }

    protected void TB_Datada_TextChanged(object sender, EventArgs e)
    {
        Session["TB_DataDa"] = ((TextBox)sender).Text;
    }

    protected void TB_Datada_Load(object sender, EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["TB_DataDa"] != null)
        {
            TB_Datada.Text = Session["TB_DataDa"].ToString();
        }
    }

    protected void TB_DataA_Load(object sender, EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["TB_DataA"] != null)
        {
            TB_DataA.Text = Session["TB_DataA"].ToString();
        }
    }

    protected void TB_DataA_TextChanged(object sender, EventArgs e)
    {
        Session["TB_DataA"] = ((TextBox)sender).Text;
    }

    protected void GV_Ore_OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (!(e.Row.RowState == DataControlRowState.Edit || e.Row.RowState == (DataControlRowState.Alternate | DataControlRowState.Edit)))
        {
            return;
        }

        DropDownList DDLProjects_Id = (DropDownList)e.Row.FindControl("DDLProjects_Id");
        DropDownList DDLActivity_id = (DropDownList)e.Row.FindControl("DDLActivity_Id");

        var dataItem = e.Row.DataItem as DataRowView;
        if (dataItem != null && !string.IsNullOrEmpty(dataItem["Activity_id"].ToString()))
        {
            // id progetto, controll DDL attività, indice attività          
            BindDDL(DDLProjects_Id.SelectedValue, DDLActivity_id, Convert.ToInt32(dataItem["Activity_id"]));
        }
        else
        {
            DDLActivity_id.Enabled = false;
            DDLActivity_id.Visible = false;
        }
    }

    protected void BindDDL(string iProject_id, DropDownList DDLActivity_Id, int iActivity_Id)
    {
        // recupera valore ore                        
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            conn.Open();

            SqlCommand cmd = new SqlCommand("select Activity_id, ActivityCode + '  ' + left(Name,20) AS iActivity FROM Activity where Projects_id='" + iProject_id + "' AND active = 'true' ORDER BY ActivityCode", conn);
            SqlDataReader dr = cmd.ExecuteReader();

            DDLActivity_Id.DataSource = dr;
            DDLActivity_Id.Items.Clear();
            DDLActivity_Id.DataTextField = "iActivity";
            DDLActivity_Id.DataValueField = "Activity_id";
            DDLActivity_Id.DataBind();

            if (iActivity_Id != 0)
            {
                DDLActivity_Id.SelectedValue = iActivity_Id.ToString();
            }

            DDLActivity_Id.Visible = true;

            // Se il progetto prevede attività rende il controllo visibile 
            if (!dr.HasRows)
            {
                DDLActivity_Id.Enabled = false;
                DDLActivity_Id.Visible = false;
            }
            else
            {
                DDLActivity_Id.Enabled = true;
                DDLActivity_Id.Visible = true;
            }
        }
    }

    protected void DDLProjects_Id_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridViewRow gvrow = (GridViewRow)((DropDownList)sender).NamingContainer;
        DropDownList DDLProjects_Id = (DropDownList)gvrow.FindControl("DDLProjects_Id");
        DropDownList DDLActivity = (DropDownList)gvrow.FindControl("DDLActivity_Id");

        // aggiorna attività collegate al progetto
        BindDDL(DDLProjects_Id.SelectedValue, DDLActivity, 0);
    }
}

