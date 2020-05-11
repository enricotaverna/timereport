using System;
using System.Configuration;

public partial class m_gestione_Location_ProjectLocation : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {
        //	Autorizzazione di display o creazione
        Auth.CheckPermission("CONFIG", "TABLE");

        // imposta la selezione della DDL progettlo
        if (!IsPostBack)
            DSProgetto.SelectCommand = "SELECT Projects_id, ProjectCode + ' ' + Name as ProjectName FROM Projects WHERE Active = 1 AND ( ProjectType_Id='" + ConfigurationManager.AppSettings["PROGETTO_INTERNAL_INVESTMENT"] + "'" +
                                       "OR ProjectType_Id='" + ConfigurationManager.AppSettings["PROGETTO_BUSINESS_DEVELOPMENT"] + "'" +
                                       "OR ProjectType_Id='" + ConfigurationManager.AppSettings["PROGETTO_INFRASTRUCTURE"] + "' ) " +
                                       " ORDER BY ProjectCode";

    }


}