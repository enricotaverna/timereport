using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


public partial class Calendario_lookup_form : System.Web.UI.Page
{
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
            
    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("CONFIG", "TABLE");

        // Imposta modalità display
        SetDisplayMode();

        // imposta default sede
        if (!IsPostBack && Session["DDLSede"] != null) {
            DropDownList DDLSede = (DropDownList)FVForm.FindControl("DDLSede");
            DDLSede.SelectedValue = Session["DDLSede"].ToString();
        }

    }  
      
   // Imposta modalità display, utilizzo template unico per create/edit
    protected void SetDisplayMode()
    {
        // Se richiamato con parametro imposta la modalità Edit e cambia il CommandNae del tasto "Salva"
        // Usato per non duplicate i template nella FormView a fronte degli stessi controlli
        if (!IsPostBack && Request.QueryString["CalendarHolidays_id"] != null && FVForm.CurrentMode == FormViewMode.Insert)
        {
            FVForm.ChangeMode(FormViewMode.Edit);
            FVForm.DefaultMode = FormViewMode.Edit;

            Button btn = (Button)FVForm.FindControl("UpdateButton");

            if (btn != null)
                btn.CommandName = "Update";
        }

    }

    // torna a lista principale dopo creazione
    protected void FVForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("Calendario_list.aspx");
    }

    // torna a lista principale dopo aggiornamento
    protected void FVForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Calendario_list.aspx");
    }

    // torna a lista principale quando si prene Cancel
    protected void ItemModeChanging_FVForm(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            Response.Redirect("Calendario_list.aspx");
    }

    protected void DSCalendarHolidays_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {

        TextBox TBDate = (TextBox)FVForm.FindControl("TBCalDay");
        e.Command.Parameters["@CalYear"].Value = TBDate.Text.Substring(6,4);

    }
}

