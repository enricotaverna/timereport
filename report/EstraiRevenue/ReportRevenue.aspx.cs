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

        string sAnnoMeseDa = DDLFromYear.Text + "-" + DDLFromMonth.Text;

        Session["SelectedMonth"] = DDLFromMonth.SelectedIndex;
        Session["SelectedYear"] = DDLFromYear.SelectedIndex;
        Session["SelectedProject"] = DDLProgetto.SelectedIndex;
        Session["SelectedManager"] = DDLManager.SelectedIndex;

        //Button bt = (Button) sender;
        switch (RBTipoReport.SelectedIndex)
                {
                case 0:     // report Revenue Persona/Progetto

                    
                    if ( RBTipoEstrazione.SelectedIndex == 0 ) // Puntuale
                        Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMeseDa + "')";          
                    else // Cumulato
                        Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese <= '" + sAnnoMeseDa + "')";

                    if (DDLManager.SelectedIndex != 0)
                            Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                    if (DDLProgetto.SelectedIndex != 0)
                            Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";

                        Session["ReportPath"] = "REV_RevenueDettaglioPerMese.rdlc";
                            Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                        break;

                case 1:     // report KPI Mese

                if (RBTipoEstrazione.SelectedIndex == 0)
                { // Puntuale 
                    Session["SQL"] = "SELECT CodiceProgetto, NomeProgetto, NomeCliente, TipoProgetto, NomeSocieta, SUM(GiorniCosti) as GiorniCosti , " +
                                 "SUM(GiorniRevenue) as GiorniRevenue, SUM(RevenueProposta) as RevenueProposta,  SUM(Costo) as Costo, SUM(CostoSpese) as CostoSpese " +
                                 "FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMeseDa + "') ";

                    if (DDLManager.SelectedIndex != 0)
                        Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "'";

                    if (DDLProgetto.SelectedIndex != 0)
                        Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";

                    Session["SQL"] = Session["SQL"] + " GROUP BY CodiceProgetto, NomeProgetto, NomeCliente, TipoProgetto, NomeSocieta";

                    Session["ReportPath"] = "REV_KPIPerMese.rdlc";
                    Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                }
                else
                { // YTD
                    Session["SQL"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMeseCalcolo = '" + sAnnoMeseDa + "')";

                    if (DDLManager.SelectedIndex != 0)
                        Session["SQL"] = Session["SQL"] + " AND ClientManager_id = '" + DDLManager.SelectedValue + "' ";


                    if (DDLProgetto.SelectedIndex != 0)
                        Session["SQL"] = Session["SQL"] + " AND Projects_id = '" + DDLProgetto.SelectedValue + "' ";

                    Session["ReportPath"] = "REV_RevenueProgettoYTD.rdlc";
                    Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                }


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