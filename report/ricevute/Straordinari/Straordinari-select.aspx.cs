using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.IO;

public partial class straordinari_select : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        
        string sAnnoCorrente;

        // autority check in funzione del tipo chiamata della pagina
            Auth.CheckPermission("REPORT", "ADMIN");

        // se premuto CancelButton torna indietro
        if (Request.Form["CancelButton"] != null)
            Response.Redirect("/timereport/menu.aspx");

        // se parametro di chiamata è vuoto mette default l'anno corrent
        if (String.IsNullOrEmpty(Request.QueryString["anno"]))
            sAnnoCorrente = DateTime.Now.Year.ToString();
        else
            sAnnoCorrente = Request.QueryString["anno"];

        // valorizza testo e riferimenti sui tasti di navigazione in testata del box con i mesi
        btNext.NavigateUrl = "/timereport/report/Straordinari/Straordinari-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) + 1).ToString();
        btPrev.NavigateUrl = "/timereport/report/Straordinari/Straordinari-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) - 1).ToString();

        AnnoCorrente.Text = sAnnoCorrente;

        // disegna la tabella dei mesi
        CostruisciTabellaMesi(sAnnoCorrente);

    }

    // Costruisce tabella dei mese, se mode = admin carica tutti i file
    protected void CostruisciTabellaMesi(string sAnno)
    {

        // init
        DateTime mese = new DateTime(2014, 1, 1);
 
        // cicla per dodici mesi
        for (int i = 0; i < 12; i++)
        {
                       
            HtmlTableRow row = new HtmlTableRow();
            HtmlTableCell cell1 = new HtmlTableCell();

            if ((DateTime.Now.Month - 1 < mese.Month & DateTime.Now.Year == Convert.ToInt16(sAnno) ) || DateTime.Now.Year < Convert.ToInt16(sAnno) )
            {    
                // > mese attuale
                cell1.InnerHtml = mese.ToString("MMMM");
                cell1.Align = "center";
                cell1.Attributes.Add("class", "cella");
                row.Cells.Add(cell1);
            }
            else  {
                // se esistono file aggiunge cella con nome mese e link alla pagina
                cell1.InnerHtml = "<input type='button' onClick=\"location.href = '/timereport/report/Straordinari/Straordinari-list.aspx?anno=" + sAnno + "&mese=" + mese.ToString("MM") + "'\" class='bottone_lista' value=" + mese.ToString("MMMM") + " />";

                cell1.Align = "center";
                cell1.Attributes.Add("class", "cella");
                row.Cells.Add(cell1);
            }

            TabellaMesi.Rows.Add(row);
            mese = mese.AddMonths(1);

        } // for (int i = 0; i < 12; i++)

        // fine
        return;

    }

}