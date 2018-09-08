using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class m_gestione_ForzaUtenti_imposta_valori_utenti : System.Web.UI.Page
{

    // id della persona
    private static string sPersonaSelezionata;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            // salva l'id della persona
            sPersonaSelezionata = Request["IdPersonaSelezionata"];

            // recupera nome                        
            DataRow drPersons = Database.GetRow("Select Name from Persons where Persons_id=" + sPersonaSelezionata, this.Page);
            lbNome.Text = lbNome.Text + drPersons["name"];

        }

        Auth.CheckPermission("MASTERDATA", "PERSONE");

    }

    // Aggiorna valori in tabella ProjectReporter
    protected void InsertButton_Click(object sender, EventArgs e)
    {

        // cancella precedenti assegnazioni
        Database.ExecuteScalar("DELETE FROM ForcedAccounts WHERE Persons_Id=" + sPersonaSelezionata, this);

        // loop sugli elementi selezionati - SALVA PROGETTI
        foreach (ListItem item in LBProgetti.Items)
        {
            if (item.Selected)
            {
                // update
                Database.ExecuteScalar("INSERT INTO ForcedAccounts (Projects_id, Persons_id) " +
                                       "VALUES ( '" + item.Value + "' , '" + sPersonaSelezionata + "')", this);
            }
        }

        Database.ExecuteScalar("DELETE FROM ForcedExpensesPers WHERE Persons_Id=" + sPersonaSelezionata, this);

        // loop sugli elementi selezionati - SALVA SPESE
        foreach (ListItem item in LBSpese.Items)
        {
            if (item.Selected)
            {
                // update
                Database.ExecuteScalar("INSERT INTO ForcedExpensesPers (ExpenseType_id, Persons_id) " +
                                       "VALUES ( '" + item.Value + "' , '" + sPersonaSelezionata + "')", this);
            }
        }

        // emette messaggio di conferma salvataggio
        string message = "Salvataggio effettuato";
        ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('" + message + "');", true);

    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/m_gestione/ForzaUtenti/selection-utenti.aspx");
    }


    protected void LBSpese_DataBound(object sender, EventArgs e)
    {

        // imposta default
        DataTable dtForcedExpenses = Database.GetData("Select * from ForcedExpensesPers where persons_id=" + sPersonaSelezionata, this.Page);

        foreach (ListItem li in LBSpese.Items)
        {
            DataRow[] drRow = dtForcedExpenses.Select("ExpenseType_id = " + li.Value.ToString());
            
            if (drRow.Count() > 0)
                li.Selected = true;
        }
    }

    protected void LBProgetti_DataBound(object sender, EventArgs e)
    {
        // imposta default
        DataTable dtForcedAccounts = Database.GetData("Select * from ForcedAccounts where persons_id=" + sPersonaSelezionata, this.Page);

        foreach (ListItem li in LBSpese.Items)
        {
            DataRow[] drRow = dtForcedAccounts.Select("projects_id = " + li.Value.ToString());

            if (drRow.Count() > 0)
                li.Selected = true;
        }

    }

    protected void aprogetti_Click(object sender, EventArgs e)
    {
        // reset i valori selezionati
        foreach (ListItem li in LBProgetti.Items)
                li.Selected = false;
    }

    protected void aspese_Click(object sender, EventArgs e)
    {
        // reset i valori selezionati
        foreach (ListItem li in LBSpese.Items)
            li.Selected = false;
    }
}