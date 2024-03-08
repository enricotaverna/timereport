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
        Auth.CheckPermission("TRAINING", "CHANGE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {

            /* Popola dropdown con i valori        */
            ASPcompatility.SelectAnnoMese(ref DDLAnnoMese, 6, 0);

        }


    }
}