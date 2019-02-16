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
            ASPcompatility.SelectYears(ref DDLToYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth);
            ASPcompatility.SelectMonths(ref DDLToMonth);

        }
    }


    protected string addclause(string strInput , string toAdd)  
    {
        if (strInput != "")
            strInput = strInput + " AND ";

        return (strInput + toAdd);

   }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        string sAnnoMeseDa = DDLFromYear.Text + "-" + DDLFromMonth.Text;
        string sAnnoMeseA = DDLToYear.Text + "-" + DDLToMonth.Text;

        //Button bt = (Button) sender;
        switch (RBTipoReport.SelectedIndex)
                {
                case 0:     // report Revenue Mese

                Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese >= '" + sAnnoMeseDa + 
                                                                        "' AND AnnoMese <= '" + sAnnoMeseA + "')";
                                if (DDLManager.SelectedIndex != 0)
                    Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                    Session["ReportPath"] = "RevenuePerMese.rdlc";
                    Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                break;

                case 1:     // report KPI Mese

                Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese >= '" + sAnnoMeseDa +
                                                                                       "' AND AnnoMese <= '" + sAnnoMeseA + "')";
                if (DDLManager.SelectedIndex != 0)
                    Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                Session["ReportPath"] = "KPIPerMese.rdlc";
                Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                break;

                case 2:     // report Revenue Totali
                      Session["SQL"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMeseCalcolo = '" + sAnnoMeseDa +  "')";

                    if (DDLManager.SelectedIndex != 0)
                        Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                    Session["ReportPath"] = "RevenueProgetto.rdlc";
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