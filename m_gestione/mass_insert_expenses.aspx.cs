using System;
using System.Web.UI;

public partial class mass_insert_expenses : System.Web.UI.Page
{
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("ADMIN", "MASSCHANGE");
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!Page.IsPostBack)
        {
            string currentDate = DateTime.Now.ToString("dd/MM/yyyy");
            TB_Datada.Text = currentDate;
        }
        BuildWhere();
    }

    protected void BuildWhere()
    {
        string sWhere = "";

        if (DDL_Persona_Sel.SelectedValue != "all" || (Session["DDL_Persona_Sel"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ? " WHERE Expenses.Persons_id = (@DDL_Persona_Sel)" : sWhere + " AND Expenses.Persons_id = (@DDL_Persona_Sel)";
        }

        if (DDL_Progetti_Sel.SelectedValue != "all" || (Session["DDL_Progetti_Sel"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ? " WHERE Expenses.Projects_id = (@DDL_Progetti_Sel)" : sWhere + " AND Expenses.Projects_id = (@DDL_Progetti_Sel)";
        }

        if (DDL_Spesa_Sel.SelectedValue != "all" || (Session["DDL_Spesa_Sel"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ? " WHERE Expenses.ExpenseType_id = (@DDL_Spesa_Sel)" : sWhere + " AND Expenses.ExpenseType_id = (@DDL_Spesa_Sel)";
        }

        if (!string.IsNullOrEmpty(TB_Datada.Text) || (Session["TB_Datada"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ? " WHERE Expenses.Date >= (@TB_Datada)" : sWhere + " AND Expenses.Date >= (@TB_Datada)";
        }

        if (!string.IsNullOrEmpty(TB_DataA.Text) || (Session["TB_DataA"] != null && !IsPostBack))
        {
            sWhere = string.IsNullOrEmpty(sWhere) ? " WHERE Expenses.Date <= (@TB_DataA)" : sWhere + " AND Expenses.Date <= (@TB_DataA)";
        }

        DSExpenses.SelectCommand = "SELECT TOP(50) Expenses.Expenses_Id, Expenses.Projects_Id, Expenses.Persons_id, Expenses.Date, Expenses.amount, Expenses.ExpenseType_Id, Expenses.CancelFlag, Expenses.creditcardpayed, Expenses.CompanyPayed, Expenses.invoiceFlag, Expenses.Comment, Expenses.AccountingDate, Persons.Name AS NomePersona, Projects.ProjectCode + ' ' + Projects.Name AS NomeProgetto, ExpenseType.ExpenseCode + ' ' + ExpenseType.Name AS TipoSpesa, OpportunityId FROM Expenses INNER JOIN Projects ON Expenses.Projects_Id = Projects.Projects_Id INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id INNER JOIN ExpenseType ON Expenses.ExpenseType_Id = ExpenseType.ExpenseType_Id " + sWhere + " ORDER BY Expenses.Date, Expenses.Projects_ID, Expenses.Persons_Id";
    }

    protected void DDL_Persona_Sel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DDL_Persona_Sel"] = DDL_Persona_Sel.SelectedValue != "all" ? DDL_Persona_Sel.SelectedValue : null;
    }

    protected void DDL_Persona_Sel_DataBound(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["DDL_Persona_Sel"] != null)
        {
            DDL_Persona_Sel.SelectedValue = Session["DDL_Persona_Sel"].ToString();
        }
    }

    protected void DDL_Progetti_Sel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DDL_Progetti_Sel"] = DDL_Progetti_Sel.SelectedValue != "all" ? DDL_Progetti_Sel.SelectedValue : null;
    }

    protected void DDL_Spesa_Sel_SelectedIndexChanged(object sender, EventArgs e)
    {
        Session["DDL_Spesa_Sel"] = DDL_Spesa_Sel.SelectedValue != "all" ? DDL_Spesa_Sel.SelectedValue : null;
    }

    protected void DDL_Spesa_Sel_DataBound(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["DDL_Spesa_Sel"] != null)
        {
            DDL_Spesa_Sel.SelectedValue = Session["DDL_Spesa_Sel"].ToString();
        }
    }

    protected void DDL_Progetti_Sel_DataBound(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["DDL_Progetti_Sel"] != null)
        {
            DDL_Progetti_Sel.SelectedValue = Session["DDL_Progetti_Sel"].ToString();
        }
    }

    protected void TB_Datada_TextChanged(object sender, EventArgs e)
    {
        Session["TB_DataDa"] = TB_Datada.Text;
    }

    protected void TB_Datada_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["TB_DataDa"] != null)
        {
            TB_Datada.Text = Session["TB_DataDa"].ToString();
        }
    }

    protected void TB_DataA_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["TB_DataA"] != null)
        {
            TB_DataA.Text = Session["TB_DataA"].ToString();
        }
    }

    protected void TB_DataA_TextChanged(object sender, EventArgs e)
    {
        Session["TB_DataA"] = TB_DataA.Text;
    }


}
