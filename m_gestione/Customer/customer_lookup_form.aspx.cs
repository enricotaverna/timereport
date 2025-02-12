using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class m_gestione_Customer_customer_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("MASTERDATA", "CUSTOMER");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {

            if (Request.QueryString["CodiceCliente"] != null)
            {
                FVCustomer.ChangeMode(FormViewMode.Edit);
                FVCustomer.DefaultMode = FormViewMode.Edit;
            }

            // Popola DDLManager
            PopolaDDLManager();
        }
    }

    private void PopolaDDLManager()
    {
        DropDownList DDLManager = (DropDownList)FVCustomer.FindControl("DDLManager");
        DDLManager.Items.Clear();

        // *** Popola il DDLManager e DDLAccountManager  ***
        DataTable dt = Database.GetData("SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name");

        // Loop attraverso i dati della DataTable
        foreach (DataRow row in dt.Rows)
        {
            string nome = row["Name"].ToString();
            string id = row["Persons_id"].ToString();
            DDLManager.Items.Add(new ListItem(nome, id));
            DDLManager.Items.Add(new ListItem(nome, id));
        }

        // Aggiunge un'opzione predefinita in cima alla lista
        DDLManager.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));

        DDLManager.DataTextField = "Name";
        DDLManager.DataValueField = "Persons_id";
        DDLManager.DataBind();

        // Imposta il valore predefinito
        DataRowView dataRow = (DataRowView)FVCustomer.DataItem;

        if (dataRow != null)
        {
            string managerId = dataRow["ClientManager_id"].ToString();
            if (managerId != "" && DDLManager.Items.FindByValue(managerId) != null)
                DDLManager.SelectedValue = managerId;
        }
    }

    protected void BackToList(object sender, EventArgs e)
    {
        Response.Redirect("customer_lookup_list.aspx");
    }

    protected void SchedaClienteForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("customer_lookup_list.aspx");
    }

    protected void FVCustomer_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.NewValues["ClientManager_id"] = ((DropDownList)FVCustomer.FindControl("DDLManager")).SelectedValue;
    }

    protected void FVCustomer_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.Values["ClientManager_id"] = ((DropDownList)FVCustomer.FindControl("DDLManager")).SelectedValue;
    }

}