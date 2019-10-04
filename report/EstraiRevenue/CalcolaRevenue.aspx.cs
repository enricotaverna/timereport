using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class report_esportaAttivita : System.Web.UI.Page
{
    // attivata MARS 
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        if (!IsPostBack) {
            /* Popola dropdown con i valori        */  
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth);
        }

        if (RBTipoReport.SelectedValue != "2")
        {
            // cancella lo script per il messaggio popup di conferma cancellazione
            //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "", true);

        }
    }

    protected string addclause(string strInput , string toAdd)  
    {
        if (strInput != "")
            strInput = strInput + " AND ";

        return (strInput + toAdd);

   }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        string sAnnoMese = DDLFromYear.Text + "-" + DDLFromMonth.Text;

        //Button bt = (Button) sender;
        switch (RBTipoReport.SelectedIndex)
                {
                 case 0:     // calcolo Revenue Mese
                  CalcolaRevenueMese(DDLFromMonth.Text, DDLFromYear.Text, DDLRevenueVersion.SelectedValue) ;                 
                  Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMese + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue) + " ORDER BY CodiceProgetto, NomePersona";
                  Session["SQL2"] = "SELECT * FROM RevenueProgetto WHERE ( AnnoMese = '" + sAnnoMese + "') AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue) + " ORDER BY CodiceProgetto";
                  Session["ReportPath"] = "REV_RawData.rdlc";
                  Session["RevenueVersion"] = DDLRevenueVersion.SelectedItem.Text;

                  Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                  break;

                  case 1:     // Cancella
                  Database.ExecuteSQL("DELETE FROM RevenueMese WHERE RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue) + " AND TipoRecord='A' AND AnnoMese = '" + sAnnoMese + "'", null);
                  Database.ExecuteSQL("DELETE FROM RevenueProgetto WHERE RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue) + " AND TipoRecord='A' AND AnnoMese = '" + sAnnoMese + "'", null);
                  // emette messaggio di conferma salvataggio
                  string message = "Cancellazione effettuata";
                  // ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('" + message + "');", true); ** cancellata per problema POPUP

                break;

                case 2:     // report Revenue Totali
                break;
        }

    }

    protected void CalcolaRevenueMese(string sMese, string sAnno, string sRevenueVersionCode) {

        var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        using (SqlConnection con = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand("REV_CalcolaRevenueMese", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.Add("@Mese", SqlDbType.NVarChar).Value = sMese;
                cmd.Parameters.Add("@Anno", SqlDbType.NVarChar).Value = sAnno;
                cmd.Parameters.Add("@RevenueVersionCode", SqlDbType.NVarChar).Value = sRevenueVersionCode;

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }

  

}