using System;
using System.Collections.Generic;
using System.Threading;

public partial class report_chiusura_ChiusuraTRCheck : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "CLOSETR");

        // ********* Check ore ************* 
        CommonFunction.CalcolaPercOutput ret = CommonFunction.CalcolaPercOre(Convert.ToInt16(Session["persons_id"]),
                                                                             Convert.ToInt16(Session["Month"]),
                                                                             Convert.ToInt16(Session["Year"]));

        CheckOre.Text = GetLocalResourceObject("orecaricate").ToString() + ret.dOreCaricate.ToString() + GetLocalResourceObject("su").ToString() + ret.dOreLavorative.ToString();
        CheckOreImg.ImageUrl = Convert.ToInt16(ret.sPerc) >= 100 ? "/timereport/images/icons/50x50/icon-ok.png" : "/timereport/images/icons/50x50/icon-alert.png";
        CheckOrePerc.Text = "&nbsp" + ret.sPerc + "%";
        pbarIEesque.PercentComplete = ret.dOreCaricate > ret.dOreLavorative ? 100 : ((float)ret.dOreCaricate / (float)ret.dOreLavorative) * 100;

        // ********* Check Ticket *************
        CheckChiusura.CheckAnomalia oAnomalia = new CheckChiusura.CheckAnomalia();
        List<CheckChiusura.CheckAnomalia> ListaAnomalie = new List<CheckChiusura.CheckAnomalia> { };

        // ** Inizio Check: se esterno il check non è rilevante **
        if (!Auth.ReturnPermission("DATI", "BUONI")) 
            { 
            CheckTicket.Text = GetLocalResourceObject("ticket_msg1").ToString();  // "Ticket: Non rilevante";
            CheckTicketImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
            }
            else
        // se interno chiama la funzione che esegue il check
        	{
                switch (CheckChiusura.CheckTicket(Session["Month"].ToString(), 
                                                   Session["Year"].ToString(),
                                                   Session["persons_id"].ToString(),  
                                                   ref ListaAnomalie)) 
                {
                    case 0:
                        CheckTicket.Text = GetLocalResourceObject("ticket_msg2").ToString();  // "Ticket: Controllo ok";
                        CheckTicketImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
                        break;
                    case 1:
                        CheckTicket.Text = "Ticket: alcuni ticket assenti";
                        CheckTicketImg.ImageUrl = "/timereport/images/icons/50x50/icon-alert.png";
                        CheckTicketDettagli.NavigateUrl = "/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=01";
                        CheckTicketDettagli.Text = "[dettagli]";
                        break;
                    case 2:
                        // non usato
                    break;
                }

	        } // ** Fine Check **

        // ********* Check Spese ************* 
        int bCheckResult = CheckChiusura.CheckSpese(Session["Month"].ToString(),
                                                     Session["Year"].ToString(),
                                                     Session["persons_id"].ToString(),
                                                     ref ListaAnomalie);

        CheckSpese.Text = bCheckResult == 0 ? "Carichi spese controllati" : "Spesa caricata su commessa non presente nella giornata";
        CheckSpeseImg.ImageUrl = bCheckResult == 0 ? "/timereport/images/icons/50x50/icon-ok.png" : "/timereport/images/icons/50x50/icon-alert.png";

        if (bCheckResult != 0) {
            CheckSpeseDettagli.NavigateUrl = "/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=02";
            CheckSpeseDettagli.Text = "[dettagli]";
            }

        // imposta indirizzo stampa ricevute
        btStampaRicevute.OnClientClick = "window.open('/timereport/report/ricevute/ricevute_list.aspx?mese=" + Session["Month"] + "&anno=" + Session["Year"] + "')";

    } // Page_Load()      


    protected bool ControllaSpese(int persons_id, int month, int year)
    {

        // loop su tutte le spese del mese, se trovo spese senza che nel giorno sia caricato il progetto 
        // emetto un warning



        return true;
    }

        protected void InsertButton_Click(object sender, EventArgs e)
    {
        Database.OpenConnection();

        string cmd;	   
    
        // verifica se esiste record per mese e persona
        if (Database.RecordEsiste("SELECT * FROM logtr WHERE persons_id=" + Session["persons_id"] + " AND mese=" + Session["month"] + " AND anno=" + Session["year"]))
        {
            // update record x chiusura TR    
            cmd = "UPDATE LogTr SET stato='1', LastModifiedBy = '" + Session["UserId"] +
                  "', LastModificationDate=" + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + 
                  " WHERE persons_id=" + 
                  Session["persons_id"] + " AND mese=" + Session["month"] + " AND anno=" + Session["year"];                
        }
        else 
        { 
            // inserisce record x chiusura TR
            cmd = "INSERT INTO LogTr (Persons_Id, Mese, Anno, Stato, CreatedBy, CreationDate) " +
                    "values ( '" +
                    Session["persons_id"] + "' , '" + 
                    Session["month"] + "' , '" +
                    Session["year"] + "' ," +
                    "'1'" + " , '" +
                    Session["UserId"] + "' , " +
                    ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + " )";
        }

        Database.ExecuteSQL(cmd, this.Page);

        Database.CloseConnection();

        Response.Redirect("/timereport/input.aspx");

    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}