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
            popolaPeriodo(ref DDLPeriodo);

            /* default */
            if (Session["SelectedPeriod"] != null) { 
                DDLPeriodo.SelectedIndex = Convert.ToInt16(Session["SelectedPeriod"].ToString());
                DDLProgetto.SelectedIndex = Convert.ToInt16(Session["SelectedProject"].ToString());
                DDLManager.SelectedIndex = Convert.ToInt16(Session["SelectedManager"].ToString());
                DDLCliente.SelectedIndex = Convert.ToInt16(Session["SelectedCliente"].ToString());
            }
        }
    }

    protected void popolaPeriodo(ref DropDownList DDL)
    {

        DataTable dt;
        ListItem lItem;

        // seleziona tutti i periodi dell'anno corrente e del precedente
        dt = Database.GetData("SELECT DISTINCT AnnoMese FROM RevenueMese WHERE AnnoMese >= CAST(YEAR(GETDATE()) - 1 AS varchar) ORDER by AnnoMese", null);

        foreach (DataRow dr in dt.Rows) {
            lItem = new ListItem(dr[0].ToString(), dr[0].ToString());
            DDL.Items.Add(lItem);
        }

        DDL.SelectedIndex = DDL.Items.Count-1;

    }

    protected string addclause(string strInput , string toAdd)  
    {
        if (strInput != "")
            strInput = strInput + " AND ";

        return (strInput + toAdd);

   }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        string sAnnoMeseA = DDLPeriodo.SelectedValue;
        string sAnnoMeseDa = DDLPeriodo.SelectedValue.Substring(0,4) + "-01";

        Session["SelectedPeriod"] = DDLPeriodo.SelectedIndex;
        Session["SelectedProject"] = DDLProgetto.SelectedIndex;
        Session["SelectedManager"] = DDLManager.SelectedIndex;
        Session["SelectedCliente"] = DDLCliente.SelectedIndex;
        Session["RevenueVersion"] = DDLRevenueVersion.SelectedItem.Text;

        //        case 1:     // **** DETTAGLIO PROGETTO

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
                    Session["SQL"] = Session["SQL"] +   " AND ( ClientManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) + " OR AccountManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) + ")";
                    Session["SQL2"] = Session["SQL2"] + " AND ( ClientManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) + " OR AccountManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue) + ")";
        }

                if (DDLProgetto.SelectedIndex != 0) { 
                        Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                        Session["SQL2"] = Session["SQL2"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";
                }

                if (DDLCliente.SelectedIndex != 0) {
                    Session["SQL"] = Session["SQL"] + " AND NomeCliente = '" + DDLCliente.SelectedValue + "' ";
                    Session["SQL2"] = Session["SQL2"] + " AND NomeCliente = '" + DDLCliente.SelectedValue + "' ";
                }

                Session["SQL"] = Session["SQL"] + " ORDER BY AnnoMese, CodiceProgetto";
                Session["SQL2"] = Session["SQL2"] + " ORDER BY AnnoMese, CodiceProgetto";

                Session["ReportPath"] = "REV_RevenueProgettoYTD.rdlc";
                Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");

                //break;
//       }
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

    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        // se manager forza ai soli progetti intestati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {
            DDLManager.ClearSelection();
            DDLManager.Items.FindByValue(Session["Persons_id"].ToString()).Selected = true;
            DDLManager.Enabled = false;
        }
    }
}