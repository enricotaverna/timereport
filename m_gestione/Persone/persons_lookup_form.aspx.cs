using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
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

        if (!IsPostBack)
            if (Request.QueryString["Persons_Id"] != null)
            {
                FVPersone.ChangeMode(FormViewMode.Edit);
                FVPersone.DefaultMode = FormViewMode.Edit;
            }
    }

    protected void FVPersone_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void FVPersone_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx?messaggio=yes");
    }

    protected void FVPersone_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx?messaggio=yes");
    }


    protected void DSPersone_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {

    }
}