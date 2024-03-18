using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.ComponentModel;
using System.IO;
using System.Data.OleDb;
using System.Globalization;
using System.Threading;
using System.Activities.Expressions;
using Xceed.Document.NET;

public partial class report_PresenzeSpese : System.Web.UI.Page
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

        //// valorizza testo e riferimenti sui tasti di navigazione in testata del box con i mesi
        //btNext.NavigateUrl = "/timereport/report/checkInput/check-input-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) + 1).ToString();
        //btPrev.NavigateUrl = "/timereport/report/checkInput/check-input-select.aspx?anno=" + (Convert.ToInt16(sAnnoCorrente) - 1).ToString();

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
            //ListaMesi.InnerHtml = ListaMesi.InnerHtml + "  <a onclick= \"return estrai()\" class='bottone-mese'>" + mfi.GetAbbreviatedMonthName(i + 1) + "</a>";

            //< asp:Button ID="BTexec" runat = "server" Text = "<%$ Resources:timereport,EXEC_TXT%>" CssClass = "orangebutton" PostBackUrl = "/timereport/esporta.aspx" OnClick = "Sottometti_Click" CausesValidation = "False" />
            mese = mese.AddMonths(1);

        } // for (int i = 0; i < 12; i++)

        // fine
        return;

    }

    protected void Sottometti_Click(object sender, System.EventArgs e)
    {

        Label dtProgettiInDDL = null;

        dtProgettiInDDL = (Label)FVMain.FindControl("AnnoCorrente");

        string sWhereClause = dtProgettiInDDL.Text.ToString();
        
        //switch (RBTipoExport.SelectedValue)
        //{
        //    case "1":
        //        Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, DescLob, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese, WorkedInRemote, LocationDescription, NomeAccountManager, PreinvoiceNum, CTMPreinvoiceNum, OpportunityId from v_ore where " + sWhereClause);
        //        //Response.Redirect("/timereport/esporta.aspx");
        //        break;
        //    case "2":
        //        Utilities.ExportXls("Select Expenses_Id, Persona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, TipoProgetto, DescLob, " + "Manager, fDate, AnnoMese, ExpenseCode, DescSpesa, CreditCardPayed, CompanyPayed, flagstorno, Invoiceflag,KM, Importo, Comment, AccountingDateAnnoMese, '', AdditionalCharges, PreinvoiceNum, CTMPreinvoiceNum, OpportunityId from v_spese where " + sWhereClause);
        //        //Response.Redirect("/timereport/esporta.aspx");
        //        break;
        //        //case "3":
        //        //    Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese from v_ore where " + sWhereClause);
        //        //    break;
        //}

        //switch (RBTipoReport.SelectedValue)
        //{
        //    case "3":
        //        Session["SQL"] = "SELECT nomepersona, nomeprogetto, giorni, annomese FROM v_ore WHERE " + sWhereClause;
        //        Session["ReportPath"] = "OrePerMese.rdlc";
        //        Response.Redirect("report/rdlc/ReportExecute.aspx");
        //        break;
        //    case "4":
        //        Session["SQL"] = "SELECT persona, nomeprogetto, DescSpesa, importo, annomese FROM v_spese WHERE " + sWhereClause;
        //        Session["ReportPath"] = "SpesePerMese.rdlc";
        //        Response.Redirect("report/rdlc/ReportExecute.aspx");
        //        break;
        //    case "5":
        //        Session["SQL"] = "SELECT  * FROM v_ore WHERE " + sWhereClause;
        //        Session["ReportPath"] = "DettaglioOre.rdlc";
        //        Response.Redirect("report/rdlc/ReportExecute.aspx");
        //        break;
        //    case "6":
        //        Session["SQL"] = "SELECT  * FROM v_spese WHERE " + sWhereClause;
        //        Session["ReportPath"] = "DettaglioSpese.rdlc";
        //        Response.Redirect("report/rdlc/ReportExecute.aspx");
        //        break;

        //}
    }


}