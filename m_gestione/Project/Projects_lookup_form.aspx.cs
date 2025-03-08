using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            if (Request.QueryString["Projectcode"] != null)
            {
                FVProgetto.ChangeMode(FormViewMode.Edit);
                FVProgetto.DefaultMode = FormViewMode.Edit;
            }
            else
            {
                // Set default value for DDLVisibility
                DropDownList ddlVisibility = (DropDownList)FVProgetto.FindControl("DDLVisibility");
                ddlVisibility.SelectedValue = ConfigurationManager.AppSettings["SOLO_AUTORIZZATI"];
            }
        }
    }

    // esegue il Bind nel codebehind per evitare problemi con il DDLManager quando un Manager è disattivato
    protected void Bind_DDL(object sender, EventArgs e)
    {
        DropDownList DDLManager = (DropDownList)FVProgetto.FindControl("DDLManager");
        DDLManager.Items.Clear();

        DropDownList DDLAccountManager = (DropDownList)FVProgetto.FindControl("DDLAccountManager");
        DDLAccountManager.Items.Clear();

        // *** Popola il DDLManager e DDLAccountManager  ***
        DataTable dt = Database.GetData("SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name");

        // Loop attraverso i dati della DataTable
        foreach (DataRow row in dt.Rows)
        {
            string nome = row["Name"].ToString();
            string id = row["Persons_id"].ToString();
            DDLManager.Items.Add(new ListItem(nome, id));
            DDLAccountManager.Items.Add(new ListItem(nome, id));
        }

        // Aggiunge un'opzione predefinita in cima alla lista
        DDLManager.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));
        DDLAccountManager.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));

        // *** Popola il DDLCliente  ***
        DropDownList DDLCliente = (DropDownList)FVProgetto.FindControl("DDLCliente");
        DDLCliente.Items.Clear();
        dt = Database.GetData("SELECT Nome1, CodiceCliente FROM Customers ORDER BY Nome1");

        // Loop attraverso i dati della DataTable
        foreach (DataRow row in dt.Rows)
        {
            string nome = row["Nome1"].ToString();
            string id = row["CodiceCliente"].ToString();
            DDLCliente.Items.Add(new ListItem(nome, id));
        }

        DDLCliente.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));

        DDLManager.DataTextField = "Name";
        DDLManager.DataValueField = "Persons_id";
        DDLManager.DataBind();

        DDLAccountManager.DataTextField = "Name";
        DDLAccountManager.DataValueField = "Persons_id";
        DDLAccountManager.DataBind();

        DDLCliente.DataTextField = "Nome1";
        DDLCliente.DataValueField = "CodiceCliente";
        DDLCliente.DataBind();

        // Imposta il valore predefinito
        DataRowView dataRow = (DataRowView)FVProgetto.DataItem;

        if (dataRow != null)
        {
            string managerId = dataRow["ClientManager_id"].ToString();
            if (managerId != "")
                DDLManager.SelectedValue = managerId;

            string accountmanagerId = dataRow["AccountManager_id"].ToString();
            if (accountmanagerId != "")
                DDLAccountManager.SelectedValue = accountmanagerId;

            string cliente = dataRow["CodiceCliente"].ToString();
            if (cliente != "")
                DDLCliente.SelectedValue = cliente;

        }

        // usato per valorizzare la chiave del log modifiche
        if (Request.QueryString["Projectcode"] != null)
            Session["Projects_Id"] = FVProgetto.DataKey["Projects_Id"].ToString();

    }

    protected void DSprojects_Insert(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
    }

    protected void DSprojects_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
    }

    protected void BackToList(Object sender, EventArgs e)
    {
        Response.Redirect("projects_lookup_list.aspx");
    }

    protected void FVProgetto_ModeChanging(Object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("projects_lookup_list.aspx");
    }

    protected void ValidaProgetto_ServerValidate(Object sender, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();

        // true se non esiste già il record
        args.IsValid = !c.CheckExistence("ProjectCode", args.Value, "Projects");

        // Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, FVProgetto, "TBProgetto");
    }

    protected void FVProgetto_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.NewValues["CodiceCliente"] = ((DropDownList)FVProgetto.FindControl("DDLCliente")).SelectedValue;
        e.NewValues["ClientManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLManager")).SelectedValue;
        e.NewValues["AccountManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLAccountManager")).SelectedValue;
    }

    protected void FVProgetto_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.Values["CodiceCliente"] = ((DropDownList)FVProgetto.FindControl("DDLCliente")).SelectedValue;
        e.Values["ClientManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLManager")).SelectedValue;
        e.Values["AccountManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLAccountManager")).SelectedValue;
    }

    protected void CloneButton_Click(object sender, EventArgs e)
    {
        int projectsId = (int)FVProgetto.DataKey["Projects_Id"];
        Response.Redirect("CloneProject.aspx?Project_id=" + projectsId + "&ProjectCode=" + Request.QueryString["Projectcode"]);
    }
}