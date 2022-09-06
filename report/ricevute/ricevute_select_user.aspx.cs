using System;
using System.Linq;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.IO;
using System.Globalization;
using System.Threading;

public partial class report_ricevute_ricevute_select : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        string sAnnoCorrente;

        // autority check in funzione del tipo chiamata della pagina
        if (Request.QueryString["mode"] == "admin")
            Auth.CheckPermission("REPORT", "TICKET_ALL");
        else
            Auth.CheckPermission("REPORT", "TICKET_USER");

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
        btNext.NavigateUrl = "/timereport/report/ricevute/ricevute_select_user.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) + 1).ToString();
        btPrev.NavigateUrl = "/timereport/report/ricevute/ricevute_select_user.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) - 1).ToString();

        if (Request.QueryString["mode"] == "admin") 
        {
            btNext.NavigateUrl = btNext.NavigateUrl + "&mode=admin";
            btPrev.NavigateUrl = btPrev.NavigateUrl + "&mode=admin";
        }

        AnnoCorrente.Text = sAnnoCorrente;

        // disegna la tabella dei mesi
        CostruisciTabellaMesi(sAnnoCorrente, Request.QueryString["mode"]);

    }

    // Costruisce tabella dei mese, se mode = admin carica tutti i file
    protected void CostruisciTabellaMesi(string sAnno, string mode)
    {
        // init
        DateTime mese = new DateTime(2014, 1, 1);

        CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(CurrentSession.Language);
        DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

        // cicla per dodici mesi
        for (int i = 0; i < 12; i++)
        {
                       
            var urlBottone = "" ;
            if (!EsisteFile(sAnno, mese.ToString("MM"), mode))
            {
                // se non esistono aggiunge cella con nome mese
                ListaMesi.InnerHtml = ListaMesi.InnerHtml + "<a class='bottone-mese disabled' href = '#'>" + mfi.GetAbbreviatedMonthName(i + 1) + " </a>";
            }
            else  {
                // se esistono file aggiunge cella con nome mese e link alla pagina
                if (mode == "admin") { 
                    urlBottone = "'/timereport/report/ricevute/ricevute_list.aspx?anno=" + sAnno + "&mese=" + mese.ToString("MM") + "'";
                    ListaMesi.InnerHtml = ListaMesi.InnerHtml + "<a href = " + urlBottone + "  class='bottone-mese'" + mfi.GetAbbreviatedMonthName(i + 1) + "</a>";
                }
                //cell1.InnerHtml = "<input type='button' class='bottone_lista grande' value=" + mfi.GetMonthName(i+1) + " onclick=window.open(" + "'/timereport/report/ricevute/ricevute_list.aspx?anno=" + sAnno + "&mese=" + mese.ToString("MM") + "&mode=admin') />";
                else {
                    urlBottone = "'/timereport/report/ricevute/ricevute_list.aspx?anno=" + sAnno + "&mese=" + mese.ToString("MM") + "'"; 
                    ListaMesi.InnerHtml = ListaMesi.InnerHtml + "<a  class='bottone-mese'  href = " + urlBottone + ">" + mfi.GetAbbreviatedMonthName(i + 1) + "</a>";
                }
            }

            mese = mese.AddMonths(1);

        } // for (int i = 0; i < 12; i++)

        // fine
        return;

    }

    // Controlla se esiste almeno un file ricevuta per la persona/mese e restituisce ok / ko
    private bool EsisteFile(string sAnno, string sMese, string mode)
    {
        
        string[] filePaths = null;

        try
        {
            string TargetLocation = "";
            if (mode == "admin")
                // costruisci il pach di ricerca: public + anno + mese 
                TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sAnno + "\\" + sMese + "\\";
            else
                // costruisci il pach di ricerca: public + anno + mese + nome persona 
                TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sAnno + "\\" + sMese + "\\" + CurrentSession.UserName + "\\";

            // carica immagini, se solo mese è ricorsivo sulle subdirectories
            filePaths = Directory
                                .GetFiles(TargetLocation, "*.*", SearchOption.AllDirectories)
                                .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                                .ToArray();
        }
        catch (Exception e)
        {
            //non fa niente ma evita il dump
            return (false);
        }

        // trovato almeno un file
        if (filePaths == null || filePaths.Length == 0)
            return(false);
        else
            return(true);

}

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }

}