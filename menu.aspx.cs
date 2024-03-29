﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class menu : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "MENU");
        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione
        
        // disattiva box Richiesta Assenza
        if (ConfigurationManager.AppSettings["LEAVE_ON"] == "false")
            RichiesteAperte.Visible = false;

        //if (Session["TrainingCheckSecondCall"] == null)
        //    Session["TrainingCheckSecondCall"] = "false";
        //else
        //    Session["TrainingCheckSecondCall"] = "true";

        // spegne box GiorniTraining e GiorniAssenza in assenza di autorizzazioni
        if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL")) { 
            //GiorniTraining.Visible = false;
            GiorniAssenza.Visible = false;
        }

        // spegne box controllo CV in assenza di autorizzazioni
        if (!Auth.ReturnPermission("REPORT", "CURRICULA"))
            CVdaConfermare.Visible = false;

        // spegne box Feedback training in assenza di autorizzazioni
        //if (!Auth.ReturnPermission("TRAINING", "RATE"))
        //    TrainingDaValutare.Visible = false;

        // spegne box Assenze da approvare in assenza di autorizzazioni
        //if (!Auth.ReturnPermission("DATI", "ASSENZE"))
        //row1.Visible = false;

    }
}