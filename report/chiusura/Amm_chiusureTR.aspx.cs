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

        // Imposta query selezione
        ImpostaQuery();
    }

    protected void ImpostaQuery() {

        string primoDelMese = ASPcompatility.FormatDateDb( ASPcompatility.FirstDay(int.Parse(DDLMese.SelectedValue), int.Parse(DDLAnno.SelectedValue)) );
        string ultimoDelMese = ASPcompatility.FormatDateDb( ASPcompatility.LastDay(int.Parse(DDLMese.SelectedValue), int.Parse(DDLAnno.SelectedValue)) );

        // la SQL è una UNION dei record presenti sulla LOGTR + di quelli, per cui la persons_id non è già presente sulla prima query, che hanno 
        // almeno un carico Hours nel mese
        DSLogTR.SelectCommand = "SELECT LogTR.LogTR_id, LogTR.Persons_id as Persons_id, LogTR.Mese as Mese, LogTR.Anno as Anno, C.Name as Name, LogTR.Stato, LogTR.CreationDate, LogTR.CreatedBy, LogTR.LastModifiedBy, LogTR.LastModificationDate FROM LogTR " + 
                                " INNER JOIN Persons as C ON LogTR.Persons_id = C.Persons_id " + 
                                " WHERE LogTR.Mese =  @Mese AND (LogTR.Anno = @Anno) AND (LogTR.Persons_id = @persona OR @persona='0')" +
                                " UNION " +
                                " SELECT '', hours.persons_id as Persons_id, MONTH(date) as Mese, YEAR(date) as Anno, B.name as Name, '0' as 'Stato', '', '', '', '' FROM Hours " +
                                " INNER JOIN Persons as B ON B.persons_id = hours.Persons_id" + 
                                " WHERE date >= " + primoDelMese + " AND date <= " + ultimoDelMese + " AND " +
                                " ( Hours.Persons_id = @persona OR @persona = '0' ) AND " +
                                " ( hours.Persons_id NOT IN ( SELECT Persons_id FROM LogTR WHERE LogTR.Mese =  @Mese AND (LogTR.Anno = @Anno) ) )" +
                                " GROUP BY hours.persons_id, date, Name" +
                                " ORDER BY Anno, Mese, Name";

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
            string Persons_id = GVLogTR.DataKeys[index].Value.ToString(); // persons_id in quanto dichiarato DataKeyName nella gridview


            // Retrieve the row that contains the button 
            // from the Rows collection.
            GridViewRow row = GVLogTR.Rows[index];

            // controlli passati, cancella il record
            if (e.CommandName == "lock")
                if (row.Cells[0].Text == "0") // record non esistente
                    Database.ExecuteSQL("INSERT INTO LOGTR (persons_id, mese, anno, stato, CreatedBy, CreationDate) VALUES ( " +
                        Persons_id + " , " + // 
                        row.Cells[2].Text + " , " + // mese
                        row.Cells[1].Text + " , " + // anno
                        "'1' , " + // stato chgiuso
                        ASPcompatility.FormatStringDb(CurrentSession.UserId) + " , " +
                        ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) +   // creationDate
                        " )"
                        , lPage); 
                else
                    Database.ExecuteSQL("UPDATE LOGTR SET Stato ='1', LastModifiedBy = '" + CurrentSession.UserId + "', LastModificationDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + "  WHERE LOGTR_id=" + row.Cells[0].Text, lPage);
            else
                Database.ExecuteSQL("UPDATE LOGTR SET Stato ='0', LastModifiedBy = '" + CurrentSession.UserId + "', LastModificationDate = " + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + "  WHERE LOGTR_id=" + row.Cells[0].Text, lPage);

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
            e.Row.Cells[11].Visible = false;
        }
        else 
        {
            e.Row.Cells[4].Text = "chiuso";
            e.Row.Cells[10].Visible = false;
        }
    }
}