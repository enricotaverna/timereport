using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
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
            if ( Request.QueryString["CodiceCliente"] != null ) {
                SchedaClienteForm.ChangeMode(FormViewMode.Edit);
                SchedaClienteForm.DefaultMode = FormViewMode.Edit;
            }
    }

    protected void SchedaClienteForm_ItemInserted(object sender, System.EventArgs e)
    {
        Response.Redirect("customer_lookup_list.aspx");
    }

    protected void SchedaClienteForm_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("customer_lookup_list.aspx");
    }

    protected void SchedaClienteForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("customer_lookup_list.aspx");
    }
}