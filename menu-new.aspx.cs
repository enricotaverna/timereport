using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class menu : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "MENU");

        // disattiva box Richiesta Assenza
        if (ConfigurationManager.AppSettings["LEAVE_ON"] == "false")
            RichiesteAperte.Visible = false;

        if (Session["TrainingCheckSecondCall"] == null)
            Session["TrainingCheckSecondCall"] = "false";
        else
            Session["TrainingCheckSecondCall"] = "true";

        // spegne box GiorniTraining e GiorniAssenza in assenza di autorizzazioni
        if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL")) { 
            GiorniTraining.Visible = false;
            GiorniAssenza.Visible = false;
        }

        // spegne box Feedback training in assenza di autorizzazioni
        if (!Auth.ReturnPermission("TRAINING", "RATE"))
            row2.Visible = false;

        // spegne box Assenze da approvare in assenza di autorizzazioni
        if (!Auth.ReturnPermission("DATI", "ASSENZE"))
            row1.Visible = false;

    }
}