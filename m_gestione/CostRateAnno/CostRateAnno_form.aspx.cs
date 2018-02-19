using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


public partial class CostRateAnno_lookup_form : System.Web.UI.Page
{
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
            
    protected void Page_Load(object sender, EventArgs e)
    {

        //	Deve avere almeno il reporting economics per visualizzare
        //  Se ha Masterdata Costrate può anche modificar
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
            Auth.CheckPermission("REPORT", "ECONOMICS");

        // Evidenzia campi form in errore
        Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "val", "fnOnUpdateValidators();");

        // Inizializza
        InitForm();

        // Imposta modalità display
        SetDisplayMode();

    }  
      
    // Inizializza form
    protected void InitForm()
    {

     }

    // Imposta modalità display, utilizzo template unico per create/edit
    protected void SetDisplayMode()
    {
        // Se richiamato con parametro imposta la modalità Edit e cambia il CommandNae del tasto "Salva"
        // Usato per non duplicate i template nella FormView a fronte degli stessi controlli
        if (!IsPostBack && Request.QueryString["PersonsCostRate_id"] != null && FVForm.CurrentMode == FormViewMode.Insert)
        {
            FVForm.ChangeMode(FormViewMode.Edit);
            FVForm.DefaultMode = FormViewMode.Edit;

            Button btn = (Button)FVForm.FindControl("UpdateButton");
            if (btn != null)
                btn.CommandName = "Update";
        }

        // Se manager cancella bottone crea
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
        {
            FVForm.ChangeMode(FormViewMode.ReadOnly);
            FVForm.DefaultMode = FormViewMode.ReadOnly;

            Button btn = (Button)FVForm.FindControl("UpdateButton");
            if (btn != null)
                btn.Enabled = false;
        }
    }

    // Popola automatica la DDL dell'anno
    protected void DDLAnno_DataBinding(object sender, EventArgs e)
    {
        DropDownList DDLAnno = (DropDownList)FVForm.FindControl("DDLAnno");

        // Popola dropdown Anno
        for (int i = DateTime.Now.Year + 1; i > (DateTime.Now.Year - 5); i--)
            DDLAnno.Items.Add(new ListItem(i.ToString(), i.ToString()));
        
        // imposta di default anno corrente
        DDLAnno.Items[1].Selected=true;
    }

    // torna a lista principale dopo creazione
    protected void FVForm_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("CostRateAnno_list.aspx");
    }

    // torna a lista principale dopo aggiornamento
    protected void FVForm_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("CostRateAnno_list.aspx");
    }

    // torna a lista principale quando si prene Cancel
    protected void ItemModeChanging_FVForm(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
            Response.Redirect("CostRateAnno_list.aspx");
    }
}

