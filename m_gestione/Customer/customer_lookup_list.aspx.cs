using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Customer_customer_lookup_list : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "CUSTOMER");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();
    }

    // Imposta query selezione
    protected void ImpostaQuery()
    {
        DSCustomer.SelectCommand = "SELECT Persons.Name, Customers.* FROM Customers LEFT OUTER  JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id WHERE " +
                                       " ( [flagAttivo] = @DL_flattivo OR @DL_flattivo = '99' ) AND " +
                                       " ( [ClientManager_id] = @DL_manager OR @DL_manager = '0' ) ";

        DSCustomer.SelectCommand += " ORDER BY CodiceCliente";
    }

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm() {

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_manager_val"] != null)
            DL_manager.SelectedValue = Session["DL_manager_val"].ToString();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_flattivo_val"] != null)
            DL_flattivo.SelectedValue = Session["DL_flattivo_val"].ToString();

        // Imposta indice di aginazione
        if (Session["GVCustomersPageNumber"] != null)
        {
            GVCustomers.PageIndex = (int)Session["GVCustomersPageNumber"];
        }
    }

        protected void GVCustomers_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        Response.Redirect("customer_lookup_form.aspx?CodiceCliente=" + GVCustomers.SelectedValue);
    }

    protected void DL_manager_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DL_manager_val"] = ddl.SelectedValue;
    }

    protected void DL_flattivo_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DL_flattivo_val"] = ddl.SelectedValue;
    }

    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        Utilities.ExportXls("SELECT Customers.*, Persons.Name FROM Customers LEFT OUTER  JOIN Persons ON Customers.ClientManager_id = Persons.Persons_id");
    }

    protected void GVCustomers_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        ValidationClass c = new ValidationClass();

        //  verifica integrità database        
        if (c.CheckExistence("CodiceCliente", e.Keys[0].ToString(), "Projects"))
        {
            e.Cancel = true;
            // Call separate class, passing page reference, to register Client Script:
            Page lPage = this.Page;
            Utilities.CreateMessageAlert(ref lPage, "Cancellazione non possibile, cliente utilizzato su tabella progetti", "strKey1");
        }

    }

    // Salva indice della pagina
    protected void GVCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GVCustomers.PageIndex = e.NewPageIndex;
        Session["GVCustomersPageNumber"] = e.NewPageIndex;
    }








}