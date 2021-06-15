using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class report_chiusura_Amm_chiusureTR : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // valorizza DDL e mette default
        if (!IsPostBack) { 
            DDLAnno_DataBinding();
            DDLMese_DataBinding();

            // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
            if (Session["DDLPersona"] != null)
                DDLPersona.SelectedValue = Session["DDLPersona"].ToString();
        }
    }

    // al cambio di DDL salva il valore 
    protected void DDLAnno_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLAnno"] = ddl.SelectedIndex;
    }


    // al cambio di DDL salva il valore 
    protected void DDLMese_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLMese"] = ddl.SelectedIndex;
    }

    // al cambio di DDL salva il valore 
    protected void DDLPersona_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLPersona"] = ddl.SelectedValue;
    }

    // popola DDL Mese
    protected void DDLMese_DataBinding()
    {

        DropDownList DDLMese = (DropDownList)FVForm.FindControl("DDLMese");

        // Popola dropdown Anno
        for (int i = 1; i <= 12 ; i++)
            DDLMese.Items.Add(new ListItem(i.ToString(), i.ToString()));

        // imposta di default mese corrente
        if (Session["DDLMese"] != null)
            DDLMese.Items[Convert.ToInt16(Session["DDLMese"])].Selected = true;
        else
            DDLMese.Items[DateTime.Now.Month - 1].Selected = true;

    }

    // popola DDL Anno
    protected void DDLAnno_DataBinding()
    {

        DropDownList DDLAnno = (DropDownList)FVForm.FindControl("DDLAnno");
        
        // Popola dropdown Anno
        for (int i = DateTime.Now.Year + 1; i > (DateTime.Now.Year - 5); i--)
            DDLAnno.Items.Add(new ListItem(i.ToString(), i.ToString()));

        // imposta di default anno corrente
        if (Session["DDLAnno"] != null)
            DDLAnno.Items[Convert.ToInt16(Session["DDLAnno"])].Selected = true;
        else
            DDLAnno.Items[1].Selected = true;

    }

    protected void GVLogTR_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        Page lPage = this.Page;

        if (e.CommandName == "lock" || e.CommandName == "unlock")
        {
            // Retrieve the row index stored in the 
            // CommandArgument property.
            int index = Convert.ToInt32(e.CommandArgument);

            // Retrieve the row that contains the button 
            // from the Rows collection.
            GridViewRow row = GVLogTR.Rows[index]; 

            // controlli passati, cancella il record
            if (e.CommandName == "lock" )
                Database.ExecuteSQL("UPDATE LOGTR SET Stato ='1', LastModifiedBy = '" + CurrentSession.UserName + "', LastModificationDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + "  WHERE LOGTR_id=" + row.Cells[0].Text, lPage);
            else
                Database.ExecuteSQL("UPDATE LOGTR SET Stato ='0', LastModifiedBy = '" + CurrentSession.UserName + "', LastModificationDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + "  WHERE LOGTR_id=" + row.Cells[0].Text, lPage);

            // forza refresh
            GVLogTR.DataBind();
        }

    }

    protected void GVLogTR_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        // salta l'intestazione
        if (e.Row.RowType != DataControlRowType.DataRow)
            return;
        
        // mette descrizione stato chiusura


        // nasconde lucchetto in base allo stato del record
        if (e.Row.Cells[4].Text == "0" ) 
        {
            e.Row.Cells[4].Text = "aperto";
            e.Row.Cells[10].Visible = false;
        }
        else 
        {
            e.Row.Cells[4].Text = "chiuso";
            e.Row.Cells[9].Visible = false;
        }
    }
}