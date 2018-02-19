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
    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "PERSONE");

        Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "val", "fnOnUpdateValidators();");

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

    protected void ValidaUserid_ServerValidate(object sender, ServerValidateEventArgs args)
    {

        ValidationClass c = new ValidationClass();
  
        // verifica che il codice persona non sia già stato usato
        args.IsValid = !(c.CheckExistence("UserId", args.Value, "Persons"));
        c.SetErrorOnField(args.IsValid, FVPersone, "TBUserid");

    }

    protected void ValidaLingua_ServerValidate(object sender, ServerValidateEventArgs args)
    {

        ValidationClass c = new ValidationClass();
        DropDownList dl = (DropDownList)FVPersone.FindControl("DDLLivelloUtente");

        // Solo utenti esterni possono avere lingua diversa da italiano
        if (Convert.ToInt16(dl.SelectedValue) != MyConstants.AUTH_EXTERNAL && args.Value != "it")
        {
            args.IsValid = false;
            c.SetErrorOnField(args.IsValid, FVPersone, "DDLLingua");
        }

    }

    protected void FVPersone_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {

        //if (e.Exception != null) NESSUN ERROR HANDLING
        //{
        //    Response.Write("Oops: " + e.Exception.Message);
        //    e.ExceptionHandled = true;
        //}

        // Recupera identificativo appena creato e lancia procedura per creazione automatica festivi
        int newIdentity;

        Database.OpenConnection();

        using (SqlConnection c = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            c.Open();
            SqlCommand cmd = new SqlCommand("SELECT MAX(Persons_id) from Persons", c);
            newIdentity = (int)cmd.ExecuteScalar();
        }

        // CommonFunction.CreaFestiviAutomatici( Convert.ToInt16(newIdentity.ToString()) ); DA TESTARE !!!

        Database.CloseConnection();

        Response.Redirect("Persons_lookup_list.aspx?messaggio=yes");
    }


    protected void FVPersone_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx?messaggio=yes");
    }

}