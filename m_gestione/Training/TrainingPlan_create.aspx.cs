using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Projects_lookup_list : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione di display o creazione
        Auth.CheckPermission("TRAINING", "CREATE");

        if (!IsPostBack)
        {

            /* Popola dropdown con i valori        */
            ASPcompatility.SelectYears(ref DDLAnno);

        }

    }
}