using System;
using System.Collections.Generic;
using System.Threading;

public partial class report_chiusura_ChiusuraTRCheck : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("BASE", "CLOSETR");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // ********* Check ore ************* 
        CommonFunction.CalcolaPercOutput ret = CommonFunction.CalcolaPercOre(Convert.ToInt16(CurrentSession.Persons_id),
                                                                             Convert.ToInt16(Session["Month"]),
                                                                             Convert.ToInt16(Session["Year"]));

        CheckOre.Text = GetLocalResourceObject("orecaricate").ToString() + ret.dOreCaricate.ToString() + GetLocalResourceObject("su").ToString() + ret.dOreLavorative.ToString();
        CheckOreImg.ImageUrl = Convert.ToInt16(ret.sPerc) >= 100 ? "/timereport/images/icons/50x50/icon-ok.png" : "/timereport/images/icons/50x50/icon-alert.png";
        CheckOrePerc.Text = "&nbsp" + ret.sPerc + "%";

        if (ret.dOreLavorative > 0)
            divbar.Style.Add("width", (Math.Round(ret.dOreCaricate / ret.dOreLavorative * 100).ToString() + "%"));

        // ********* Check Ticket *************
        CheckChiusura.CheckAnomalia oAnomalia = new CheckChiusura.CheckAnomalia();
        List<CheckChiusura.CheckAnomalia> ListaAnomalie = new List<CheckChiusura.CheckAnomalia> { };

        // ** Inizio Check: se esterno il check non è rilevante **
        if (!Auth.ReturnPermission("DATI", "BUONI"))
        {
            CheckTicketAssenti.Text = GetLocalResourceObject("ticket_msg1").ToString();  // "Ticket: Non rilevante";
            CheckTicketAssentiImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
            CheckTicketHomeOffice.Text = GetLocalResourceObject("ticket_msg3").ToString();  // "Ticket: Non rilevante";
            CheckTicketHomeOfficeImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
        }
        else
        // se interno chiama la funzione che esegue il check
        {
            switch (CheckChiusura.CheckTicketAssenti(Session["Month"].ToString(),
                                               Session["Year"].ToString(),
                                               CurrentSession.Persons_id.ToString(),
                                               ref ListaAnomalie))
            {
                case 0:
                    CheckTicketAssenti.Text = GetLocalResourceObject("ticket_msg2").ToString();  // "Ticket: Controllo ok";
                    CheckTicketAssentiImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
                    break;
                case 1:
                    CheckTicketAssenti.Text = "<a style='text-decoration: underline' href='/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=01'>" + ListaAnomalie.Count + " ticket o rimborsi</a>" + " travel assenti";
                    CheckTicketAssentiImg.ImageUrl = "/timereport/images/icons/50x50/icon-alert.png";
                    break;
                case 2:
                    // non usato
                    break;
            }

            switch (CheckChiusura.CheckTicketHomeOffice(Session["Month"].ToString(),
                                   Session["Year"].ToString(),
                                   CurrentSession.Persons_id.ToString(),
                                   ref ListaAnomalie))
            {
                case 0:
                    CheckTicketHomeOffice.Text = GetLocalResourceObject("ticket_msg4").ToString();  // "Ticket: Controllo ok";
                    CheckTicketHomeOfficeImg.ImageUrl = "/timereport/images/icons/50x50/icon-ok.png";
                    break;
                case 1:
                    CheckTicketHomeOffice.Text = "<a style='text-decoration: underline' href='/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=04'>" + ListaAnomalie.Count + " ticket</a>" + " caricati su giornate Home Office";
                    CheckTicketHomeOfficeImg.ImageUrl = "/timereport/images/icons/50x50/icon-alert.png";
                    break;
                case 2:
                    // non usato
                    break;
            }

        } // ** Fine Check **

        // ********* Check Spese ************* 
        int bCheckResult = CheckChiusura.CheckSpese(Session["Month"].ToString(),
                                                     Session["Year"].ToString(),
                                                     CurrentSession.Persons_id.ToString(),
                                                     ref ListaAnomalie);

        CheckSpese.Text = bCheckResult == 0 ? "Carichi spese controllati" : "<a style='text-decoration: underline' href='/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=02'>" + ListaAnomalie.Count + " spese caricate</a> su commessa non presente nella giornata";
        CheckSpeseImg.ImageUrl = bCheckResult == 0 ? "/timereport/images/icons/50x50/icon-ok.png" : "/timereport/images/icons/50x50/icon-alert.png";

        // imposta indirizzo stampa ricevute
        btStampaRicevute.OnClientClick = "window.open('/timereport/report/ricevute/ricevute_list.aspx?mese=" + Session["Month"] + "&anno=" + Session["Year"] + "')";

        // ********* Check Assenze ************* 
        int iCheckAssenze = CheckChiusura.CheckAssenze(Session["Month"].ToString(),
                                                     Session["Year"].ToString(),
                                                     CurrentSession.Persons_id.ToString(),
                                                     ref ListaAnomalie);
        if (iCheckAssenze > 0)
        {
            CheckAssenze.Text = "<a style='text-decoration: underline' href='/timereport/report/chiusura/ChiusuraTRDettagli.aspx?type=03'>" + ListaAnomalie.Count + " richieste</a> in attesa di conferma";
            CheckAssenzeImg.ImageUrl = "/timereport/images/icons/50x50/icon-alert.png";
        }

    } // Page_Load()      

    protected void InsertButton_Click(object sender, EventArgs e)
    {
        string cmd;

        // verifica se esiste record per mese e persona
        if (Database.RecordEsiste("SELECT * FROM logtr WHERE persons_id=" + CurrentSession.Persons_id + " AND mese=" + Session["month"] + " AND anno=" + Session["year"]))
        {
            // update record x chiusura TR    
            cmd = "UPDATE LogTr SET stato='1', LastModifiedBy = '" + Session["UserId"] +
                  "', LastModificationDate=" + ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) +
                  " WHERE persons_id=" +
                  CurrentSession.Persons_id + " AND mese=" + Session["month"] + " AND anno=" + Session["year"];
        }
        else
        {
            // inserisce record x chiusura TR
            cmd = "INSERT INTO LogTr (Persons_Id, Mese, Anno, Stato, CreatedBy, CreationDate) " +
                    "values ( '" +
                    CurrentSession.Persons_id + "' , '" +
                    Session["month"] + "' , '" +
                    Session["year"] + "' ," +
                    "'1'" + " , '" +
                    Session["UserId"] + "' , " +
                    ASPcompatility.FormatDateDb(DateTime.Now.ToShortDateString(), false) + " )";
        }

        Database.ExecuteSQL(cmd, this.Page);

        Response.Redirect("/timereport/input.aspx");

    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}