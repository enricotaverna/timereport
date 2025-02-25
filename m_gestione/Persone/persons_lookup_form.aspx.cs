using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class persons_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "PERSONE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];
        FVMode.Value = FVPersone.CurrentMode.ToString();

        if (!IsPostBack)
        {
            Session["PrevPage"] = Request.UrlReferrer.ToString();
            if (Request.QueryString["Persons_Id"] != null)
            {
                FVPersone.ChangeMode(FormViewMode.Edit);
                FVPersone.DefaultMode = FormViewMode.Edit;
            }

            // Populate DDLEmployeeNumber
            PopulateDDLEmployeeNumber();

        }
    }

    private void PopulateDDLEmployeeNumber()
    {
        DropDownList ddlEmployeeNumber = (DropDownList)FVPersone.FindControl("DDLEmployeeNumber");

        foreach (DataRow drRow in CurrentSession.dtPersonale.Rows)
        {
            ListItem liItem = new ListItem(drRow["EmployeeNumber"].ToString() + " " + drRow["Consulente"].ToString(), drRow["EmployeeNumber"].ToString());
            ddlEmployeeNumber.Items.Add(liItem);
        }
        ddlEmployeeNumber.DataTextField = "Consulente"; // Adjust this to the correct column name
        ddlEmployeeNumber.DataValueField = ""; // Adjust this to the correct column name
        ddlEmployeeNumber.DataBind();

        // settare il valore di default
    }

    protected void FVPersone_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        FVMode.Value = e.NewMode.ToString();
        if (e.CancelingEdit)
            Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void FVPersone_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void FVPersone_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void DSpersons_Insert(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
    }

    protected void DSpersons_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
    }
}