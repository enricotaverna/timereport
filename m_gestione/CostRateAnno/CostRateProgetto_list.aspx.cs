using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Projects_lookup_list : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione di display o creazione
        Auth.CheckPermission("MASTERDATA", "COSTRATE_DISPLAY");

        // recupera oggetto con variabili di sessione

        CurrentSession = (TRSession)Session["CurrentSession"];
        if (!IsPostBack)
            DSPersons.SelectCommand = "SELECT * FROM [Persons] WHERE Active = '" + DDLAttivi.SelectedValue + "' ORDER BY Name";

        if ( !Auth.ReturnPermission("MASTERDATA", "COSTRATE_UPDATE") ) {
            btn_crea.Visible = false;
        }


    }

    protected void SelectChanged(object sender, EventArgs e)
    {
        DSPersons.SelectCommand = "SELECT * FROM [Persons] WHERE Active = '" + DDLAttivi.SelectedValue + "' ORDER BY Name";
    }
}