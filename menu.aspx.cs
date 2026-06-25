using Amazon.Util.Internal.PlatformServices;
using System;
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

        if (Request.QueryString["goto"] == "ControlloProgettoList")
        {
            // se clicca la card di completa ETC va al report con i valori impostati
            Session["DDLCpProgetto"] = "0";
            Session["DDLCpManager"] = CurrentSession.Persons_id.ToString();
            Session["DDLCpLOB"] = "0";
            Session["DDLCpSFContractType"] = ConfigurationManager.AppSettings["SYSTEM_INTEGRATION"];
            Session["DDLCpTipoContratto"] = ConfigurationManager.AppSettings["CONTRATTO_FIXED"]; // FIXED

            Response.Redirect("/timereport/report/controllo_progetto/ControlloProgetto-list.aspx");
            return;
        }

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

        // spegne box ETC da aggiornare in assenza di autorizzazioni
        if (!Auth.ReturnPermission("REPORT", "ECONOMICS") || CurrentSession.Practice != ConfigurationManager.AppSettings["PR. ERP"])
        {
            ETCdaAggiornare.Visible = false;
            DivPlaceholder.Visible = true;
        }
        else {
            ETCdaAggiornare.Visible = true;
            DivPlaceholder.Visible = false;
        }


        // spegne box Feedback training in assenza di autorizzazioni
        //if (!Auth.ReturnPermission("TRAINING", "RATE"))
        //    TrainingDaValutare.Visible = false;

        // spegne box Assenze da approvare in assenza di autorizzazioni
        //if (!Auth.ReturnPermission("DATI", "ASSENZE"))
        //row1.Visible = false;

    }
}