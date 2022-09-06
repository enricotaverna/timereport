using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.IO;
using System.Globalization;

public partial class report_ricevute_ricevute_select : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        string sAnnoCorrente;

        // autority check in funzione del tipo chiamata della pagina
        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // se premuto CancelButton torna indietro
        if (Request.Form["CancelButton"] != null)
            Response.Redirect("/timereport/menu.aspx");

        // se parametro di chiamata è vuoto mette default l'anno corrent
        if (String.IsNullOrEmpty(Request.QueryString["anno"]))
            sAnnoCorrente = DateTime.Now.Year.ToString();
        else
            sAnnoCorrente = Request.QueryString["anno"];

        // valorizza testo e riferimenti sui tasti di navigazione in testata del box con i mesi
        btNext.NavigateUrl = "/timereport/report/checkInput/check-input-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) + 1).ToString();
        btPrev.NavigateUrl = "/timereport/report/checkInput/check-input-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) - 1).ToString();

        AnnoCorrente.Text = sAnnoCorrente;

        // disegna la tabella dei mesi
        CostruisciTabellaMesi(sAnnoCorrente);

    }

    // Costruisce tabella dei mese, se mode = admin carica tutti i file
    protected void CostruisciTabellaMesi(string sAnno)
    {

        // init
        DateTime mese = new DateTime(2014, 1, 1);
        var urlBottone = "";

        CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(CurrentSession.Language);
        DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

        // cicla per dodici mesi
        for (int i = 0; i < 12; i++)
        {

            urlBottone = "'/timereport/report/checkInput/check-input-list.aspx?anno=" + sAnno + "&mese=" + mese.ToString("MM") + "'";
            ListaMesi.InnerHtml = ListaMesi.InnerHtml + "<a  class='bottone-mese'  href = " + urlBottone + ">" + mfi.GetAbbreviatedMonthName(i + 1) + "</a>";
            mese = mese.AddMonths(1);

        } // for (int i = 0; i < 12; i++)

        // fine
        return;

    }

}