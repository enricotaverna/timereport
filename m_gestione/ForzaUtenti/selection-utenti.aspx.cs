using System;

public partial class m_gestione_ForzaUtenti_selection_utenti : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        //	Authorization level 3 needed for this function
        Auth.CheckPermission("MASTERDATA", "PERSONE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack && Session["SelectedPersons_id"] != null)
            IdPersonaSelezionata.SelectedValue = Session["SelectedPersons_id"].ToString();

        if (Request["cancel_from_list"] == "Cancel")
            Response.Redirect("/timereport/menu.aspx");
    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

    protected void Submit_Click(object sender, EventArgs e)
    {
        // Memorizza l'ultimo valore selezionato nella sessione
        Session["SelectedPersons_id"] = IdPersonaSelezionata.SelectedValue;
        Response.Redirect("/timereport/m_gestione/ForzaUtenti/ForcedAccounts.aspx");
    }

}