using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

public partial class m_gestione_ForzaUtenti_imposta_valori_utenti : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    // id della persona
    public static string sPersonaSelezionata;
    public static string sNomeConsulente;

    public static string progettiArray;

    protected void Page_Load(object sender, EventArgs e)
    {

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {

            sPersonaSelezionata = Session["SelectedPersons_id"].ToString();

            if (sPersonaSelezionata.Length > 0)
            {
                LBPersone.SelectedValue = sPersonaSelezionata;
                LBPersone2.SelectedValue = sPersonaSelezionata;
                // recupera nome                        
                DataRow drPersons = Database.GetRow("Select Name from Persons where Persons_id=" + sPersonaSelezionata, this.Page);
                //progettiArray = JsonConvert.SerializeObject(ConvertDataTableToArray(CurrentSession.dtProgettiTutti));
                sNomeConsulente = drPersons["name"].ToString();
            }

        }

        Auth.CheckPermission("MASTERDATA", "PERSONE");

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

}