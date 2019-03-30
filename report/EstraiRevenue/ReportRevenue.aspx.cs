using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using Microsoft.Reporting.WebForms;

public partial class report_esportaAttivita : System.Web.UI.Page
{
    // attivata MARS 
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        if (!IsPostBack) {
            DDLManager.SelectedIndex = 0;

            /* Popola dropdown con i valori        */  
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth);

            /* default */
            if (Session["SelectedMonth"] != null) { 
                DDLFromMonth.SelectedIndex = Convert.ToInt16(Session["SelectedMonth"].ToString());
                DDLFromYear.SelectedIndex = Convert.ToInt16(Session["SelectedYear"].ToString());
                DDLProgetto.SelectedIndex = Convert.ToInt16(Session["SelectedProject"].ToString());
                DDLManager.SelectedIndex = Convert.ToInt16(Session["SelectedManager"].ToString());
            }
        }
    }


    protected string addclause(string strInput , string toAdd)  
    {
        if (strInput != "")
            strInput = strInput + " AND ";

        return (strInput + toAdd);

   }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        string sAnnoMeseA = DDLFromYear.Text + "-" + DDLFromMonth.Text;
        string sAnnoMeseDa = DDLFromYear.Text + "-01";

        Session["SelectedMonth"] = DDLFromMonth.SelectedIndex;
        Session["SelectedYear"] = DDLFromYear.SelectedIndex;
        Session["SelectedProject"] = DDLProgetto.SelectedIndex;
        Session["SelectedManager"] = DDLManager.SelectedIndex;
        Session["RevenueVersion"] = DDLRevenueVersion.SelectedItem.Text;

        // *** TIPO REPORT  ****
        switch (RBTipoReport.SelectedIndex)
                {
                case 0:     // **** DETTAGLIO PERSONA/PROGETTO

                if (RBTipoEstrazione.SelectedIndex == 0)
                {
                    Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                    Session["SQL2"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMese = '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                }
                else
                {
                    Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese >= '" + sAnnoMeseDa + "' AND AnnoMese <= '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                    Session["SQL2"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMese >= '" + sAnnoMeseDa + "' AND AnnoMese <= '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                }

                // *** parametri addizionali: manager
                if (DDLManager.SelectedIndex != 0) { 
                            Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";
                            Session["SQL2"] = Session["SQL2"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                }

                // *** parametri addizionali: progetto
                if (DDLProgetto.SelectedIndex != 0) { 
                            Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                            Session["SQL2"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                }

                // ** ordinamento                    
                Session["SQL"] = Session["SQL"]+ " ORDER BY AnnoMese, NomePersona, CodiceProgetto";
                Session["SQL2"] = Session["SQL2"] + " ORDER BY AnnoMese, CodiceProgetto";

                Session["ReportPath"] = "REV_RawData.rdlc";
                Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                        break;

                case 1:     // **** DETTAGLIO PROGETTO

                if (RBTipoEstrazione.SelectedIndex == 0)
                { // mese selezionato
                    Session["SQL"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMese = '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                    Session["SQL2"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                }
                else
                {// YTD
                    Session["SQL"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMese >= '" + sAnnoMeseDa + "' AND AnnoMese <= '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                    Session["SQL2"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese >= '" + sAnnoMeseDa + "' AND AnnoMese <= '" + sAnnoMeseA + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue);
                }

                if (DDLManager.SelectedIndex != 0) { 
                        Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";
                        Session["SQL2"] = Session["SQL2"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";
                }

                if (DDLProgetto.SelectedIndex != 0) { 
                        Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                        Session["SQL2"] = Session["SQL2"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                }

                Session["SQL"] = Session["SQL"] + " ORDER BY AnnoMese, CodiceProgetto";
                Session["SQL2"] = Session["SQL2"] + " ORDER BY AnnoMese, CodiceProgetto";

                Session["ReportPath"] = "REV_RevenueProgettoYTD.rdlc";
                Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");

                break;
       }
    }

    protected void CalcolaRevenueMese(string sMese, string sAnno) {

        var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("SPcalcolaRevenueMese", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@Mese", SqlDbType.NVarChar).Value = sMese;
                cmd.Parameters.Add("@Anno", SqlDbType.NVarChar).Value = sAnno;

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

  

}