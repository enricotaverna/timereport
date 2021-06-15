using System;
using System.Configuration;
using System.Threading;
using System.Web.UI.WebControls;

public partial class Esporta : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        if (!IsPostBack)
        {
            // Popola dropdown con i valori          
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectYears(ref DDLToYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth, CurrentSession.Language);
            ASPcompatility.SelectMonths(ref DDLToMonth, CurrentSession.Language);
 
        }
    }

    // Costruisce segmento Where
    protected string Addclause(string strInput, string toAdd)
    {

        if (!string.IsNullOrEmpty(strInput))
            strInput = strInput + " AND ";

        return strInput + toAdd;
    }

    // Costruisce condizione Where
    protected string Build_where()
    {
        string sWhereClause = "";

        string sListaProgettiSel= Utilities.ListSelections(CBLProgetti);
        string sListaProgettiAll = Utilities.ListSelections(CBLProgetti, true);
        string sListaPersoneSel = Utilities.ListSelections(CBLPersone);

        bool bProgettiSelezionati = !string.IsNullOrEmpty(sListaProgettiSel) ;
        bool bPersoneSelezionate = !string.IsNullOrEmpty(sListaPersoneSel);

        // *** ADMIN
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL") && Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            if (bProgettiSelezionati && RBTipoExport.SelectedValue != "3") // sono stati selezionati dei progetti e non è il tipo export Not Chargable
                sWhereClause = Addclause(sWhereClause, "Projects_id IN (" + sListaProgettiSel + " )" );
            
            if (bPersoneSelezionate)
                sWhereClause = Addclause(sWhereClause, "Persons_id IN (" + sListaPersoneSel + " )");
        } // *** ADMIN

        // *** CONSULENTE / ESTERNO
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            !Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {

        // solo sue ore e spese su progetti abilitati
        sWhereClause = "Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )";
        sWhereClause = Addclause(sWhereClause, "Persons_id = " + CurrentSession.Persons_id);

        } // *** CONSULENTE / ESTERNO

        // *** MANAGER / TEAM LEADER
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            // deve selezionare tutte le persone su progetti chargable e solo se stessi su progetti non chargable
            // altrimenti tutti vedono spese e ore di progetti BD e INFRASTRUTTURALI a cui sono assegnati

            //if (bPersoneSelezionate)
            //    sWhereClause =
            //        "   Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
            //        "   AND Persons_id IN (" + sListaPersoneSel + ")";
            //else // persone non selezionate estrare solo le ore non chargable delle persone associate al manager
                sWhereClause =
                    " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    "   AND Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
                    " ) OR " +
                    " ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] +
                    " AND ( Persons_id = " + CurrentSession.Persons_id + " OR Manager_id = " + CurrentSession.Persons_id + ")" +
                    " ) ) ";

            if (bPersoneSelezionate)
                sWhereClause = sWhereClause + " AND Persons_id IN(" + sListaPersoneSel + ")";

        } // *** MANAGER / TEAM LEADER

        if (DDLClienti.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "CodiceCliente = " + ASPcompatility.FormatStringDb(DDLClienti.SelectedValue));

        if (DDLsocieta.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "company_id = " + ASPcompatility.FormatStringDb(DDLsocieta.SelectedValue));

        if (DDLManager.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "ClientManager_id = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue));

        if (!string.IsNullOrEmpty(sWhereClause))
            sWhereClause = sWhereClause + " AND ";

        string fd = ASPcompatility.FormatDateDb(ASPcompatility.FirstDay(Convert.ToInt16(DDLFromMonth.SelectedValue), Convert.ToInt16(DDLFromYear.SelectedValue)));
        string ld = ASPcompatility.FormatDateDb(ASPcompatility.LastDay(Convert.ToInt16(DDLToMonth.SelectedValue), Convert.ToInt16(DDLToYear.SelectedValue)) +"/" + DDLToMonth.SelectedValue + "/" + DDLToYear.SelectedValue);                     

        sWhereClause = sWhereClause + " date >= " + fd + " AND date <= " + ld ;

        // se tipo export 3 cambia i filtri
        // solo ore NON chargable
        // filtro data
        // su persone o se stesso o persone associate al manager
        //if ( RBTipoExport.SelectedValue == "3")
        //{
        //    sWhereClause = "";
        //    sWhereClause = " Date >= " + fd + " AND Date <= " + ld + " AND " +
        //                   " ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + " AND " +
        //                   " Projects_id IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " ) AND " +

        //}

        return sWhereClause;

    }

    // Lancia report
    protected void Sottometti_Click(object sender, System.EventArgs e)
    {
        string sWhereClause = "";

        sWhereClause = Build_where();

        switch (RBTipoExport.SelectedValue)
        {

            case "1":
                Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese, WorkedInRemote, LocationDescription from v_ore where " + sWhereClause);
                break;
            case "2":
                Utilities.ExportXls("Select Expenses_Id, Persona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, TipoProgetto, " + "Manager, fDate, AnnoMese, ExpenseCode, DescSpesa, CreditCardPayed, CompanyPayed, flagstorno, Invoiceflag,KM, Importo, Comment, AccountingDateAnnoMese, '' from v_spese where " + sWhereClause);
                break;
            //case "3":
            //    Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese from v_ore where " + sWhereClause);
            //    break;
        }

        switch (RBTipoReport.SelectedValue)
        {
                case "3":
                    Session["SQL"] = "SELECT nomepersona, nomeprogetto, giorni, annomese FROM v_ore WHERE " + sWhereClause;
                    Session["ReportPath"] = "OrePerMese.rdlc";
                    Response.Redirect("report/rdlc/ReportExecute.aspx");
                    break;
                case "4":
                    Session["SQL"] = "SELECT persona, nomeprogetto, DescSpesa, importo, annomese FROM v_spese WHERE " + sWhereClause;
                    Session["ReportPath"] = "SpesePerMese.rdlc";
                    Response.Redirect("report/rdlc/ReportExecute.aspx");
                    break;
                case "5":
                    Session["SQL"] = "SELECT  * FROM v_ore WHERE " + sWhereClause;
                    Session["ReportPath"] = "DettaglioOre.rdlc";
                    Response.Redirect("report/rdlc/ReportExecute.aspx");
                    break;
                case "6":
                    Session["SQL"] = "SELECT  * FROM v_spese WHERE " + sWhereClause;
                    Session["ReportPath"] = "DettaglioSpese.rdlc";
                    Response.Redirect("report/rdlc/ReportExecute.aspx");
                    break;

        }
    }
    
    // Carica DDL persone
    protected void CBLPersone_Load(object sender, System.EventArgs e)
    {

        // Admin, Manager, Reporter : tutte le persone
        // Emplyee, Esterno: solo se stessi
        // Il reporter può essere unemployee

         

        if (Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
            DSPersone.SelectCommand = "SELECT [Persons_id], [Name] FROM [Persons] " + (CBPersoneDisattive.Checked == false ? " WHERE Active = 1 " : "") + " ORDER BY [Name]";
        else
        {
            DSPersone.SelectCommand = "SELECT [Persons_id], [Name] FROM [Persons] WHERE Persons_id = " + CurrentSession.Persons_id + " ORDER BY [Name]";
            CBLPersone.Visible = false;
            CBPersoneDisattive.Visible = false;
            //DivPersone.Visible = false;
            //DivProgetti.Visible = false;
        }

    }

    // Carica DDL progetti
    protected void CBLProgetti_Load(object sender, System.EventArgs e)
    {

        if ( Auth.ReturnPermission("REPORT","PROJECT_ALL") )
            DSProgetti.SelectCommand = "SELECT Projects_id, ProjectCode, ProjectCode + ' ' + Name AS txtcodes FROM Projects " + (CBProgettiDisattivi.Checked == false ? " WHERE Active = 1 " : "") + " ORDER BY ProjectCode";

        // i progetti assegnati + quelli di cui è manager
        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL") )
            DSProgetti.SelectCommand = "SELECT DISTINCT a.Projects_id, a.ProjectCode, a.ProjectCode + ' ' + a.Name AS txtcodes FROM Projects AS a" +
                                       " INNER JOIN ForcedAccounts as b ON a.Projects_id = b.Projects_id " +
                                       " WHERE b.persons_id = " + CurrentSession.Persons_id +
                                       (CBProgettiDisattivi.Checked == false ? " AND a.Active = 1 " : "") +
                                        " UNION " +
                                        " SELECT DISTINCT a.Projects_id, a.ProjectCode, a.ProjectCode + ' ' + a.Name AS txtcodes FROM Projects AS a " +
                                        " WHERE ( a.clientmanager_id = " + CurrentSession.Persons_id + " OR a.Accountmanager_id = " + CurrentSession.Persons_id + ")" +
                                       (CBProgettiDisattivi.Checked == false ? " AND a.Active = 1 " : "") +
                                        " ORDER BY ProjectCode";
    }


    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}