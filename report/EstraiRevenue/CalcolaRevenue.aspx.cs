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
            /* Popola dropdown con i valori        */  
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth);
        }

        if (!IsPostBack || RBTipoReport.SelectedValue != "2")
        {
            // cancella lo script per il messaggio popup di conferma cancellazione
           // ClientScript.RegisterStartupScript(this.GetType(), "Popup", "", true);

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
                  CalcolaRevenueMese(DDLFromMonth.Text, DDLFromYear.Text) ;                 
                  Session["SQL"] = "SELECT * FROM RevenueMese WHERE ( AnnoMese = '" + sAnnoMese + "')";
                  Session["ReportPath"] = "REV_RevenueDettaglioPerMese.rdlc";
                  //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "", true);
                  Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
                  break;

                case 1:     // Cancella
                Database.ExecuteSQL("DELETE TABLE RevenueMese WHERE  AnnoMese = '" + sAnnoMese + "',)", null);
                // emette messaggio di conferma salvataggio
                string message = "Cancellazione effettuata";
                //ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('" + message + "');", true);

                break;

                case 2:     // report Revenue Totali
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