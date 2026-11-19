using System;
using System.Web.UI;

public partial class m_gestione_CostRateAnno_CustomerBillRate_list : System.Web.UI.Page
{
    // Permessi riusati dalle pagine Cost Rate.
    // DA SOSTITUIRE se in futuro vengono introdotti permessi dedicati per i Bill Rate
    // (mantenere allineati con le costanti omonime in webservices/WS_BillRate.asmx).
    private const string AUTH_TASK = "MASTERDATA";
    private const string AUTH_DISPLAY = "COSTRATE_DISPLAY";
    private const string AUTH_UPDATE = "COSTRATE_UPDATE";

    // recupera oggetto sessione
    public TRSession CurrentSession;

    // usato dal markup per generare la colonna con l'icona di modifica
    protected bool CanUpdate;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Autorizzazione di display: redirect standard se negata
        Auth.CheckPermission(AUTH_TASK, AUTH_DISPLAY);

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        CanUpdate = Auth.ReturnPermission(AUTH_TASK, AUTH_UPDATE);
        btn_crea.Visible = CanUpdate;
    }
}
