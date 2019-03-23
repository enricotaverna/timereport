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

public partial class report_ControlloProgettoSelect : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("TRAINING", "PLAN");

        if (!IsPostBack) {
            /* Popola dropdown con i valori        */
            ASPcompatility.SelectYears(ref DDLAnno);
            DDLAnno.SelectedIndex = 0;
        }
   
    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        // salva data report utilizzata nella gridview per il drill sulle revenue
        Session["Path"] = "";

        if ( DDLAnno.SelectedValue == "0" )
            Session["SQL"] = "SELECT * FROM V_TRAININGPLAN";
        else
            Session["SQL"] = "SELECT * FROM V_TRAININGPLAN WHERE Anno='" + DDLAnno.SelectedValue + "'";

        Session["ReportPath"] = "/timereport/report/Rdlc/HR_TrainingPlan.rdlc"; 

        Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
    }

}