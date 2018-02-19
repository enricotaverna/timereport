using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading;

public partial class Esporta : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //           Popola dropdown con i valori          
            ASPcompatility.SelectYears(ref DDLFromYear);
            ASPcompatility.SelectYears(ref DDLToYear);
            ASPcompatility.SelectMonths(ref DDLFromMonth, Session["lingua"].ToString());
            ASPcompatility.SelectMonths(ref DDLToMonth, Session["lingua"].ToString());
        
            //if (Session["debug"].ToString() == "11") {
            //    string sWhereClause = sWhereClause = Build_where();
            //    Response.Write(sWhereClause);
            //}

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

        //// se progetti selezionati imposta la where sui codici della listbox
        //if (bProgettiSelezionati)
        //    sWhereClause = "ProjectCode IN (" + sListaProgettiSel + " )";
        //else // se nessun progetto selezionato e non ho le autorizzazioni limito i progetti a quelli che posso vedere
        //    if ( !Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        //            sWhereClause = "ProjectCode IN (" + sListaProgettiAll + " )";

        //if (!string.IsNullOrEmpty(Utilities.ListSelections(CBLPersone)))
        //    sWhereClause = Addclause(sWhereClause, "Persons_id IN (" + Utilities.ListSelections(CBLPersone) + " )");
        //else if (!Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        //    sWhereClause = Addclause(sWhereClause, "Persons_id = " + Session["persons_id"].ToString());

        // *** ADMIN
        if (Auth.ReturnPermission("REPORT", "PROJECT_ALL") && Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            if (bProgettiSelezionati) // sono stati selezionati dei progetti
                sWhereClause = "ProjectCode IN (" + sListaProgettiSel + " )";

            if (bPersoneSelezionate)
                sWhereClause = "Persons_id IN (" + sListaPersoneSel + " )";
        } // *** ADMIN

        // *** CONSULENTE / ESTERNO
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            !Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {

        // solo sue ore e spese su progetti abilitati
        sWhereClause = "ProjectCode IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )";
        sWhereClause = Addclause(sWhereClause, "Persons_id = " + Session["persons_id"]);

        } // *** CONSULENTE / ESTERNO

        // *** MANAGER / TEAM LEADER
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL") &&
            Auth.ReturnPermission("REPORT", "PROJECT_FORCED") &&
            Auth.ReturnPermission("REPORT", "PEOPLE_ALL"))
        {
            // deve selezionare tutte le persone su progetti chargable e solo se stessi su progetti non chargable
            // altrimenti tutti vedono spese e ore di progetti BD e INFRASTRUTTURALI a cui sono assegnati

            if (bPersoneSelezionate)
                sWhereClause = 
                    " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + 
                    "   AND ProjectCode IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
                    "   AND Persons_id IN (" + sListaPersoneSel + ")" +
                    " ) OR " +
                    " ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + 
                    "   AND ProjectCode IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
                    "   AND Persons_id = " + Session["persons_id"] +
                    " ) ) ";
            else
                sWhereClause = 
                    " ( ( ProjectType_id = " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + 
                    "   AND ProjectCode IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
                    " ) OR " +
                    " ( ProjectType_id <> " + ConfigurationManager.AppSettings["PROGETTO_CHARGEABLE"] + 
                    "   AND ProjectCode IN (" + (bProgettiSelezionati ? sListaProgettiSel : sListaProgettiAll) + " )" +
                    "   AND Persons_id = " + Session["persons_id"] +
                    " ) ) ";

        } // *** MANAGER / TEAM LEADER

        if (mieore.Checked)
            sWhereClause = Addclause(sWhereClause, "Persons_id = " + Session["persons_id"]);

        if (DDLClienti.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "CodiceCliente = " + ASPcompatility.FormatStringDb(DDLClienti.SelectedValue));

        if (DDLsocieta.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "company_id = " + ASPcompatility.FormatStringDb(DDLsocieta.SelectedValue));

        if (DDLManager.SelectedValue != "")
            sWhereClause = Addclause(sWhereClause, "idManager = " + ASPcompatility.FormatStringDb(DDLManager.SelectedValue));

        if (!string.IsNullOrEmpty(sWhereClause))
            sWhereClause = sWhereClause + " AND ";

        sWhereClause = sWhereClause + " date >= " + ASPcompatility.FormatDateDb(ASPcompatility.FirstDay(Convert.ToInt16(DDLFromMonth.SelectedValue), Convert.ToInt16(DDLFromYear.SelectedValue))) + " AND date <= " + ASPcompatility.FormatDateDb(ASPcompatility.LastDay(Convert.ToInt16(DDLToMonth.SelectedValue), Convert.ToInt16(DDLToYear.SelectedValue)));

        return sWhereClause;

    }

    // Lancia report
    protected void sottometti_Click(object sender, System.EventArgs e)
    {
        string sWhereClause = "";

        sWhereClause = Build_where();

        //Response.Write(sWhereClause);

        //Response.End();
  
        if (Request.Params["download"] != null)
        {
            switch (RBTipoReport.SelectedIndex)
            {

                case 0:
                case 2:
                case 4:
                    Utilities.ExportXls("Select Hours_Id, NomePersona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, ActivityCode, ActivityName, DescTipoProgetto, " + "NomeManager, fDate, AnnoMese, flagstorno, Hours, Giorni, Comment, AccountingDateAnnoMese from v_ore where " + sWhereClause);
                    break;
                case 1:
                case 3:
                case 5:
                    ScaricaSpese("Select Expenses_Id, Persona, NomeSocieta, CodiceCliente, NomeCliente, ProjectCode, NomeProgetto, TipoProgetto, " + "Manager, fDate, AnnoMese, ExpenseCode, DescSpesa, CreditCardPayed, CompanyPayed, flagstorno, Invoiceflag,KM, Importo, Comment, AccountingDateAnnoMese, '' from v_spese where " + sWhereClause);
                    break;
            }

        }
        else
        {
            switch (RBTipoReport.SelectedIndex)
            {

                case 0:
                    Response.Redirect("/timereport/report/generated/EstraiOresmry.asp?reset=1&whereclause=" + sWhereClause);
                    break;
                case 1:
                    Response.Redirect("/timereport/report/generated/EstraiSpesesmry.asp?reset=1&whereclause=" + sWhereClause);
                    break;
                case 2:
                    Response.Redirect("/timereport/report/generated/TotaliOresmry.asp?reset=1&whereclause=" + sWhereClause);
                    break;
                case 3:
                    Response.Redirect("/timereport/report/generated/TotaliSpesesmry.asp?reset=1&whereclause=" + sWhereClause);
                    break;
                case 4:
                    Response.Redirect("/timereport/report/generated/CrossGiorniMesectb.asp?reset=1&whereclause=" + sWhereClause);
                    break;
                case 5:
                    Response.Redirect("/timereport/report/generated/CrossSpeseMesectb.asp?reset=1&whereclause=" + sWhereClause);
                    break;
            }
        }
    }

    // Carica Dataset, verifica presenza giustificativi, scarica excel
    protected void ScaricaSpese(string sqlCommand)
    {

        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        using (conn)
        {
            /* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */
            SqlDataAdapter da = new SqlDataAdapter(sqlCommand, conn);
            SqlCommandBuilder builder = new SqlCommandBuilder(da);

            DataSet ds = new DataSet("export");
            da.Fill(ds, "export");

            int iUltimaColonna = ds.Tables["export"].Columns.Count - 1;

            // Verifica per ogni dato estratto se ci sono giustificativi
            foreach (DataRow row in ds.Tables["export"].Rows)
                row[iUltimaColonna] = "PROVA";

            // scarica il dataset in formato XLS
            Utilities.EsportaDataSetExcel(ds);
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
            DSPersone.SelectCommand = "SELECT [Persons_id], [Name] FROM [Persons] WHERE Persons_id = " + Session["persons_id"] + " ORDER BY [Name]";
            //CBLPersone.Visible = false;
            CBPersoneDisattive.Visible = false;
            DivPersone.Visible = false;
            DivProgetti.Visible = false;
        }

    }

    // Carica DDL progetti
    protected void CBLProgetti_Load(object sender, System.EventArgs e)
    {

        if ( Auth.ReturnPermission("REPORT","PROJECT_ALL") )
            DSProgetti.SelectCommand = "SELECT ProjectCode, ProjectCode + ' ' + Name AS txtcodes FROM Projects " + (CBProgettiDisattivi.Checked == false ? " WHERE Active = 1 " : "") + " ORDER BY ProjectCode";

        if (Auth.ReturnPermission("REPORT", "PROJECT_FORCED") && !Auth.ReturnPermission("REPORT", "PROJECT_ALL") )
            DSProgetti.SelectCommand = "SELECT DISTINCT a.ProjectCode, a.ProjectCode + ' ' + a.Name AS txtcodes FROM Projects AS a" +
                                       " INNER JOIN ForcedAccounts as b ON a.Projects_id = b.Projects_id " +
                                       " WHERE b.persons_id = " + Session["persons_id"] +
                                       (CBProgettiDisattivi.Checked == false ? " AND a.Active = 1 " : "") + " ORDER BY ProjectCode";
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}