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

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("TRAINING", "REPORT");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack) {
            /* Popola dropdown con i valori        */
            ASPcompatility.SelectYears(ref DDLAnno);
            DDLAnno.SelectedIndex = 0;
        }
   
    }

    protected void sottometti_Click(object sender , System.EventArgs e ) {

        // salva data report utilizzata nella gridview per il drill sulle revenue
        Session["Path"] = "";
        string sCondition = "";

        if ( DDLAnno.SelectedValue != "0" )
            sCondition = " WHERE Anno = '" + DDLAnno.SelectedValue + "' ";

        if (DDLManager.SelectedValue != "0")
            sCondition = sCondition == "" ? " WHERE Manager_id = '" + DDLManager.SelectedValue + "' " : sCondition + " AND Manager_id = '" + DDLManager.SelectedValue + "' ";

        if (DDLPersons.SelectedValue != "0")
            sCondition = sCondition == "" ? " WHERE Persons_id = '" + DDLPersons.SelectedValue + "' " : sCondition + " AND Persons_id = '" + DDLPersons.SelectedValue + "' ";


        Session["SQL"] = "SELECT * FROM V_TRAININGPLAN " + sCondition;

        Session["ReportPath"] = "/timereport/report/Rdlc/HR_TrainingPlan.rdlc"; 

        Response.Redirect("/timereport/report/rdlc/ReportExecute.aspx");
    }

}