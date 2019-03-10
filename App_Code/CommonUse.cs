using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public class ValidationClass
{
    public bool CheckExistence(string sKey, string sValkey, string sTable)
    {

        // verifica che il codice cliente non sia già stato creato
        bool bRet = false;

        DataRow drRow = Database.GetRow("SELECT * FROM " + sTable + " WHERE " + sKey + "='" + sValkey + "'", null);

        if ( drRow != null)
            bRet = true;
        else
            bRet = false;

        return (bRet);

    }

    public void SetErrorOnField(bool bArgs, FormView objForm, string sFieldName)
    {

        // Dim TBcontrol As TextBox = objForm.FindControl(sFieldName)
        System.Web.UI.Control GenericControl = objForm.FindControl(sFieldName);

        if (bArgs != true)
        {
            switch ((GenericControl.GetType().ToString()))
            {
                case "System.Web.UI.WebControls.TextBox":
                    {
                        TextBox TB = (TextBox)GenericControl;
                        TB.Style["background-Color"] = "#FFFFD5";
                        TB.Style["border-Color"] = "#FF5353";
                        break;
                    }

                case "System.Web.UI.WebControls.DropDownList":
                    {
                        DropDownList DDL = (DropDownList)GenericControl;
                        DDL.Style["background-Color"] = "#FFFFD5";
                        DDL.Style["border-Color"] = "#FF5353";
                        break;
                    }
            }
        }
        else
            switch ((GenericControl.GetType().ToString()))
            {
                case "System.Web.UI.WebControls.TextBox":
                    {
                        TextBox TB = (TextBox)GenericControl;
                        TB.Style["background-Color"] = "#FFF";
                        TB.Style["border-Color"] = "#C7C7C7";
                        break;
                    }

                case "System.Web.UI.WebControls.DropDownList":
                    {
                        DropDownList DDL = (DropDownList)GenericControl;
                        DDL.Style["background-Color"] = "#FFF";
                        DDL.Style["border-Color"] = "#C7C7C7";
                        break;
                    }
            }
    }
}

public class Auth
{
    public static void LoadPermission(string persons_id)
    {

        // Carica le permissione dell'utente in una tabella e la memorizza in una variabile di sessione
        DataRowCollection AuthPermission;

        AuthPermission = ASPcompatility.GetRows(" SELECT c.AuthTask, c.AuthActivity from Persons as a " + " INNER JOIN AuthPermission as b ON b.UserLevel_id = a.UserLevel_id " + " INNER JOIN AuthActivity as c ON c.AuthActivity_id = b.AuthActivity_id " + " WHERE a.persons_id = '" + persons_id + "'");

        HttpContext.Current.Session["AuthPermission"] = AuthPermission;
    }

    // Verifica permission caricate rispetto all'attività chiesta 
    public static bool CheckPermission(string Task, string Actvity)
    {
        DataRowCollection aAuthPermission;
        int f;
        
        // sessione scaduta
        if (     HttpContext.Current.Session["persons_id"] == null)
            HttpContext.Current.Response.Redirect("/timereport/default.aspx");

        // carica da memoria
        aAuthPermission = (DataRowCollection)HttpContext.Current.Session["AuthPermission"];

        // Se vuota carica permission
        if (aAuthPermission == null)
            // Messaggio di errore
            HttpContext.Current.Response.Redirect("/timereport/menu.aspx?msgtype=E&msgno=" + System.Configuration.ConfigurationManager.AppSettings["MSGNO_AUTHORIZATION_FAILED"]);

        for (f = 0; f <= (aAuthPermission.Count - 1); f++)
        {
            if ((aAuthPermission[f][0].ToString().Trim() == Task.Trim() & aAuthPermission[f][1].ToString().Trim() == Actvity.Trim()))
                return true;
        }

        // Messaggio di errore
        HttpContext.Current.Response.Redirect("/timereport/menu.aspx?msgtype=E&msgno=" + System.Configuration.ConfigurationManager.AppSettings["MSGNO_AUTHORIZATION_FAILED"]);

        return false;
    }

    // Verifica permission caricate rispetto all'attività chiesta 
    public static bool ReturnPermission(string Task, string Actvity)
    {
        DataRowCollection aAuthPermission;
        int f;

        // carica da memoria
        aAuthPermission = (DataRowCollection)HttpContext.Current.Session["AuthPermission"];

        // Se vuota carica permission
        if (aAuthPermission == null)
        {
        }

        for (f = 0; f <= (aAuthPermission.Count - 1); f++)
        {
            if ((aAuthPermission[f][0].ToString().Trim() == Task.Trim() & aAuthPermission[f][1].ToString().Trim() == Actvity.Trim()))
                return true;
        }

        return false;
    }
}

public class Utilities
{

    public static void CheckAutMobile(int PageLevel)
    {

        // sessione scaduta
        if (HttpContext.Current.Session["userLevel"] == null)
            HttpContext.Current.Response.Redirect("/timereport/mobile/login.aspx");
     
        // Mancato auth        
        
        if (  Int32.Parse(HttpContext.Current.Session["userLevel"].ToString()) < PageLevel)
            HttpContext.Current.Response.Redirect("/timereport/mobile/login.aspx");
    }

    public static void CreateMessageAlert(ref Page aspxPage, string strMessage, string strKey)
    {
        string strScript = "<script language=JavaScript>alert('"
                                            + strMessage + "')</script>";

        if ((!aspxPage.IsStartupScriptRegistered(strKey)))
            aspxPage.RegisterStartupScript(strKey, strScript);
    }

    public static void EsportaDataSetExcel(DataSet ds)
    {

        // /* prende dataset ed espora in excel */

        DataGrid GridExp = new DataGrid();

        GridExp.DataSource = ds.Tables["export"].DefaultView;
        GridExp.DataBind();

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=Export.xls");
        HttpContext.Current.Response.Charset = "";

        // // If you want the option to open the Excel file without saving then
        // // comment out the line below
        HttpContext.Current.Response.ContentType = "application/vnd.xls";
        // //create a string writer
        StringWriter stringWrite = new StringWriter();

        // //create an htmltextwriter which uses the stringwriter
        System.Web.UI.Html32TextWriter htmlWrite = new Html32TextWriter(stringWrite);

        GridExp.RenderControl(htmlWrite);

        HttpContext.Current.Response.Write(stringWrite.ToString());

        HttpContext.Current.Response.End();
    }

    public static void ExportXls(string sQuery)
    {

        // verifica che il codice cliente non sia già stato creato
        SqlConnection conn;
        SqlDataAdapter Adapter;
        DataSet ds = new DataSet();
        DataGrid GridExp = new DataGrid();

        conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        Adapter = new SqlDataAdapter(sQuery, conn);
        Adapter.Fill(ds, "export");

        GridExp.DataSource = ds.Tables["export"].DefaultView;
        GridExp.DataBind();

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=Export.xls");
        HttpContext.Current.Response.Charset = "";

        // // If you want the option to open the Excel file without saving then
        // // comment out the line below
        // // Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.ContentType = "application/vnd.xls";
        // create a string writer
        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        // create an htmltextwriter which uses the stringwriter
        System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);

        GridExp.RenderControl(htmlWrite);

        HttpContext.Current.Response.Write(stringWrite.ToString());
        HttpContext.Current.Response.End();
    }

    public static string CheckboxListSelections(CheckBoxList list)
    {
        ArrayList values = new ArrayList();
        int counter;
        string sRet = "";

        counter = 0;
        while (counter < list.Items.Count)
        {
            if (list.Items[counter].Selected)

                if (sRet == "")
                    sRet = ASPcompatility.FormatStringDb(list.Items[counter].Value);
                else
                    sRet = sRet + ", " + ASPcompatility.FormatStringDb(list.Items[counter].Value);

            counter = counter + 1;
        }

        return (sRet); 
    }

    public static string ListSelections(ListBox list, bool all = false)
    {

        // restituisce elementi all'interno di una lista

        ArrayList values = new ArrayList();
        int counter;
        string sRet = "";

        counter = 0;
        while (counter < list.Items.Count)
        {
            if ((list.Items[counter].Selected | all))
                if (sRet == "")
                    sRet = ASPcompatility.FormatStringDb(list.Items[counter].Value);
                else
                    sRet = sRet + ", " + ASPcompatility.FormatStringDb(list.Items[counter].Value);

            counter = counter + 1;
        }

        return (sRet);
    }

    public static string ListDDL(DropDownList DDLList, bool all = false)
    {

        // restituisce elementi <> 0 all'interno di una lista

        ArrayList values = new ArrayList();
        int counter;
        string sDDLval;
        string sRet = "";

        counter = 0;
        while (counter < DDLList.Items.Count)
        {
            sDDLval = DDLList.Items[counter].Value;

            if (((DDLList.Items[counter].Selected | all) & sDDLval != "0" & sDDLval != ""))
                if (sRet == "")
                    sRet = sDDLval;
                else
                    sRet = sRet + "," + sDDLval;

            counter = counter + 1;
        }

        return sRet;
    }

    public static string GetCutoffDate(string strPeriod, string strMonth, string strYear, string strType)
    {
        string sRet;

        // calc the cutoff date based on the input parameter
        if (strPeriod == "1")
        {
            if (strType == "end")
                sRet =  "15/" + strMonth + "/" + strYear;
            else
                sRet = "1/" + strMonth + "/" + strYear;
        }
        else if (strType == "end")
            sRet = (DateTime.DaysInMonth( Convert.ToInt32(strYear), Convert.ToInt32(strMonth))).ToString() + "/" + strMonth + "/" + strYear;
        else
            sRet = "16" + "/" + strMonth + "/" + strYear;

        return sRet;
    }
}

public class CommonFunction
{

    // Classe per definire paramentri di output della procedura CalcolaPercOre
    public class CalcolaPercOutput
    {
        public double dOreLavorative;
        public double dOreCaricate;
        public string sPerc;
    }

    public static string GetAuthor(int Persons_id, DateTime ldate)
    {
        string connStr, sRet;
        connStr = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        SqlConnection conn;
        conn = new SqlConnection(connStr);

        SqlCommand cmd = new SqlCommand("SELECT Name from Persons where Persons_id = " + Persons_id, conn);

        conn.Open();

        SqlDataReader dr = cmd.ExecuteReader();
        dr.Read();

        if (dr.HasRows)
            sRet = dr["Name"] + " " + string.Format("{0:d/M/yyyy HH:mm}", ldate);
        else
            sRet = "";

        return sRet;
    }

    public static CalcolaPercOutput CalcolaPercOre(int Persons_id, int iMese, int iAnno)
    {
        var ret = new CalcolaPercOutput();
        int iContaOre;
        int iOreLavorative = 0;
        string sDate;
        string sFromDate = ASPcompatility.FormatDateDb("1/" + iMese.ToString() + "/" + iAnno.ToString());
        string sToDate = ASPcompatility.FormatDateDb(DateTime.DaysInMonth(iAnno, iMese) + "/" + iMese.ToString() + "/" + iAnno.ToString());

        object obj = Database.ExecuteScalar("SELECT SUM(hours) as somma FROM Hours WHERE Persons_id = " + Persons_id + " AND Date >= " + sFromDate + " AND Date <= " + sToDate, null );
        if (obj != DBNull.Value)
            iContaOre = Convert.ToInt32(obj);
        else
            iContaOre = 0;
     
        for (int f = 1; f <= DateTime.DaysInMonth(iAnno, iMese); f++)
        {
            sDate = f + "/" + iMese + "/" + iAnno.ToString();
            if ( (int)Convert.ToDateTime(sDate).DayOfWeek  != 0 & (int)Convert.ToDateTime(sDate).DayOfWeek != 6)
                iOreLavorative = iOreLavorative + 1;
        }

        iOreLavorative = iOreLavorative * 8;

        ret.dOreLavorative = iOreLavorative;
        ret.dOreCaricate = iContaOre;

        if (iOreLavorative != 0)
            ret.sPerc = (((float)iContaOre / (float)iOreLavorative) * 100).ToString("N0");
        else
            ret.sPerc = "0";

        return ret;
    }

    public static int NumeroGiorniLavorativi(DateTime startdate, DateTime enddate)
    {
        var days = (enddate - startdate).Days + 1;

        return workDaysInFullWeeks(days) + workDaysInPartialWeek(startdate.DayOfWeek, days);
    }

    public static int workDaysInFullWeeks(int totalDays)
    {
        return (totalDays / 7) * 5;
    }

    public static int workDaysInPartialWeek(DayOfWeek firstDay, int totalDays)
    {
        var remainingDays = totalDays % 7;
        var daysToSaturday = DayOfWeek.Saturday - firstDay;

        if (remainingDays <= daysToSaturday)
            return remainingDays;

        // * daysToSaturday are the days before the weekend,
        // * the rest of the expression computes the days remaining after we
        // * ignore Saturday and Sunday
        // */
        // // Range ends in a Saturday or in a Sunday
        if (remainingDays <= daysToSaturday + 2)
            return daysToSaturday;
        else
            return (remainingDays - 2);
    }

    //public static void CreaFestiviAutomatici(Int16 Persons_id)
    //{
    //    // Richiamata con o senza identificativo della persona
    //    // Crea i festivi automatici a partire dalla data corrente leggendo la tabella Holiday
    //    // Se Persons_id = 0 o null vengono creati per tutte le persone attive
    //    string SQLString;

    //    if (Persons_id != 0)
    //        SQLString = "SELECT Persons_id from Persons where Persons_id = " + Persons_id.ToString();
    //    else
    //        SQLString = "SELECT Persons_id from Persons where active = 1 ";

    //    // 1' step: cancella tutti i festivi automatici (solo quelli dal giorno attuale in avanti !!!)
    //    DataTable dtPersons = Database.GetData(SQLString, null/* TODO Change to default(_) if this is not a reference type */);

    //    foreach (DataRow rdr in dtPersons.Rows)
    //    {
    //        // cancella i record creati automaticamente con data >= data attuale
    //        SQLString = "DELETE FROM hours WHERE FestivoAutomatico = 1 AND Persons_id = " + rdr["Persons_id"].ToString() + " AND Date >= " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy"));
    //        Database.ExecuteSQL(SQLString, null/* TODO Change to default(_) if this is not a reference type */);
    //    }

    //    // 2' step: crea i carichi automatici

    //    // Join tra persone attive e date giorni festivi >= data odierna
    //    if (Persons_id != 0)
    //        SQLString = "SELECT Persons_id, holiday_date from Persons, Holiday where persons.Persons_id = " + Persons_id.ToString() + " AND Holiday.holiday_date >= " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy"));
    //    else
    //        SQLString = "SELECT Persons_id, holiday_date from Persons, Holiday where persons.active = 1 AND Holiday.holiday_date >= " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"));

    //    dtPersons.Clear();
    //    dtPersons = Database.GetData(SQLString, null/* TODO Change to default(_) if this is not a reference type */);

    //    foreach (DataRow rdr in dtPersons.Rows)
    //        // cancella i record creati automaticamente con data >= data attuale
    //        // cancella i record creati automaticamente con data >= data attuale
    //        Database.ExecuteSQL("INSERT INTO hours (date, projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, createdBy, creationDate, FestivoAutomatico) VALUES(" + ASPcompatility.FormatDateDb(rdr["holiday_date"].ToString(), false) + " , " + ASPcompatility.FormatStringDb(ConfigurationManager.AppSettings["FESTIVI_PROJECT"]) + " , " + ASPcompatility.FormatStringDb(rdr["Persons_id"].ToString()) + " , " + ASPcompatility.FormatNumberDB(8) + " , " + ASPcompatility.FormatStringDb("1") + " , " + " '0'  , " + " null  , " + " null  , " + " null , " + " null  , " + ASPcompatility.FormatStringDb(HttpContext.Current.Session["UserId"].ToString()) + " , " + ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + "'1'" + " )", null/* TODO Change to default(_) if this is not a reference type */);
    //}

    public static CultureInfo GetCulture()
    {
        // PROVATA IN SOSTITUZIONE DI GLOBAL.ASAX    
        CultureInfo sRet = new CultureInfo("it");

        try
        {
            // recupera lingua da cookie, le sessioni non sono valorizzate qui
            HttpCookie cCookie = HttpContext.Current.Request.Cookies.Get("lingua");

            if (!(cCookie == null) & cCookie.Value == "en")
                sRet = new CultureInfo("en");
        }
        catch
        {
        }

        return sRet;
    }
}

public class CheckChiusura
{

    // Classe per definire paramentri di output delle procedure di check Anomalie TR
    public class CheckAnomalia
    {
        public string Tipo;
        public DateTime Data;
        public string Descrizione;
        public string ExpenseCode;
        public string ProjectCode;
        public double Amount;
        public string UnitOfMeasure;
    }

    public static int CheckTicket(string sMese, string sAnno, string persons_id, ref List<CheckAnomalia> ListaAnomalie)
    {
        // Funzione ritorna
        // 0 = nessun problema
        // 1 = warning
        // 2 = errore
        // La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia

        int f;
        string sDate;
        DataRow[] drRow;

        int iRet = 0;
        ListaAnomalie.Clear();

        string dFirst = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, '0') + "/" + sAnno);
        string dLast = ASPcompatility.FormatDateDb(DateTime.DaysInMonth(Convert.ToInt32(sAnno), Convert.ToInt32(sMese)).ToString() + "/" + sMese + "/" + sAnno);

        // carica ticket caricati nel mese
        DataTable dtTicket = Database.GetData("Select FORMAT(date,'dd/MM/yyyy') as date from Expenses where persons_id=" + persons_id + " AND TipoBonus_id<>'0' AND date >= " + dFirst + " AND date <= " + dLast, null/* TODO Change to default(_) if this is not a reference type */);

        // carica date in cui sono presenti ferie / malattie / festività
        DataTable dtFerie = Database.GetData("SELECT FORMAT(date,'dd/MM/yyyy') AS date " + 
                                             " FROM Hours AS a " +
                                             " INNER JOIN Projects AS b ON b.projects_id = a.projects_id " +
                                             " WHERE b.ProjectCode IN " + ConfigurationManager.AppSettings["CODICI_FERIE"]  + "  AND " +
                                             " persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, null);
        dtFerie.PrimaryKey = new DataColumn[] { dtFerie.Columns["date"] };

        // cicla sui giorni del mese
        for (f = 1; f <= DateTime.DaysInMonth(Convert.ToInt32(sAnno), Convert.ToInt32(sMese)); f++)
        {
            sDate = f.ToString().PadLeft(2,'0') + "/" + sMese.PadLeft(2, '0') + "/" + sAnno;

            // giorno lavorativo

            if ((int)Convert.ToDateTime(sDate).DayOfWeek != 6 & (int)Convert.ToDateTime(sDate).DayOfWeek != 0)
            {

                // controlla che non sia festivo
                if (!MyConstants.DTHoliday.Rows.Contains(sDate) && (   dtFerie.Rows.Count == 0 ||  !dtFerie.Rows.Contains(sDate) ) )
                {

                    // controlla che sia caricato un ticket
                    drRow = null;
                    drRow = dtTicket.Select("date = '" + sDate + "'");

                    if (drRow.Count() == 0)
                    {

                        // Alza anomalia e carica lista
                        iRet = 1;

                        CheckAnomalia a = new CheckAnomalia();
                        a.Data = Convert.ToDateTime(sDate);
                        a.Tipo = "M";
                        a.Descrizione = "Ticket o rimborso assente";

                        ListaAnomalie.Add(a);
                    }
                }
            }
        }

        return iRet;
    }

    public static int CheckSpese(string sMese, string sAnno, string persons_id, ref List<CheckAnomalia> ListaAnomalie)
    {
        // Funzione ritorna
        // 0 = nessun problema
        // 1 = warning
        // 2 = errore
        // La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia        
        int iRet;

        ListaAnomalie.Clear();

        string dFirst = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, '0') + "/" + sAnno);
        string dLast = ASPcompatility.FormatDateDb(DateTime.DaysInMonth( Convert.ToInt32(sAnno), Convert.ToInt32(sMese)).ToString() + "/" + sMese + "/" + sAnno);

        // carica spese nel mese della persona per il controllo
        DataTable dtProgettiMese = Database.GetData("Select FORMAT(date,'dd/MM/yyyy') as date, Projects_id from Hours WHERE Persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, null/* TODO Change to default(_) if this is not a reference type */);

        // seleziona tutte le spese del mese, considera le spese standard e i rimborsi trasferta
        DataTable dt = Database.GetData("SELECT a.Projects_id, Amount, date, b.ProjectCode, c.ExpenseCode, c.UnitOfMeasure FROM Expenses As a " + " JOIN Projects As b On b.Projects_id  = a.Projects_id " + " JOIN ExpenseType As c On c.ExpenseType_id  = a.ExpenseType_Id " + " WHERE ( a.TipoBonus_Id = 0 Or a.TipoBonus_Id = 1 ) And Persons_id=" + persons_id + " And Date >= " + dFirst + " And Date <= " + dLast + " ORDER BY date", null/* TODO Change to default(_) if this is not a reference type */);

        // se non ci sono stati carichi esce con errore
        if (dtProgettiMese.Rows.Count == 0)
            return (1);

        DataRow[] drRows;
        string sdata;

        if ((dt != null) & dt.Rows.Count > 0)
        {

            // cicla sulla spese del mese
            foreach (DataRow rs in dt.Rows)
            {
                sdata = string.Format("{0:dd/MM/yyyy}", rs["date"]);

                // verifica se esistono ore caricate per lo stesso progetto

                drRows = null;
                drRows = dtProgettiMese.Select("date = '" + sdata + "' AND Projects_id = " + rs["Projects_id"].ToString());

                if (drRows.Count() == 0)
                {
                    CheckAnomalia a = new CheckAnomalia();
                    a.Data = Convert.ToDateTime(rs["date"].ToString());
                    a.Tipo = "M";
                    a.Descrizione = "Spesa caricata su commessa non presente nel giorno";
                    a.ExpenseCode = rs["ExpenseCode"].ToString();
                    a.ProjectCode = rs["ProjectCode"].ToString();
                    a.UnitOfMeasure = rs["UnitOfMeasure"].ToString();
                    a.Amount = Convert.ToDouble(rs["Amount"].ToString());

                    ListaAnomalie.Add(a);
                }
            }
        }

        if (ListaAnomalie.Count > 0)
            iRet = 1;
        else
            iRet = 0;

        return iRet;
    }
}

public class Database
{

    // 02-09-2018 FUNZIONE MIGRATA
    public static object ExecuteScalar(string cmdText, Page mypage)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        object oRet;

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            DataTable dtRecord = new DataTable();
            using (SqlCommand cmd = new SqlCommand(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    oRet = cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteScalar: " + ex.Message + "');", true);
                    oRet = 0;
                }
            }
        }

        return oRet;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool ExecuteSQL(string cmdText, Page mypage)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand cmd = new SqlCommand(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteSQL: " + ex.Message + "');", true);
                    return false; 
                }
            }
        }
        return true;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool RecordEsiste(string cmdText)
    {
        return RecordEsiste(cmdText, null/* TODO Change to default(_) if this is not a reference type */);
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static bool RecordEsiste(string cmdText, Page mypage)
    {
        // 02-09-2018 FUNZIONE MIGRATA
        bool result = false;

        var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            DataTable dtRecord = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter(cmdText, connection))
            {
                try
                {
                    connection.Open(); // Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    da.Fill(dtRecord);

                    if (dtRecord.Rows.Count == 1)
                        result = true;
                    else
                        result = false;
                }
                catch (Exception ex)
                {
                    if (!(mypage == null))
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE RecordEsiste: " + ex.Message + "');", true);
                    result = false;
                }
            }
        }

        return result;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static DataTable GetData(string cmdText, Page mypage)
    {
        DataTable dt = new DataTable();

        using (SqlConnection lCon = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
        {
            using (SqlCommand cmd = lCon.CreateCommand())
            {
                lCon.Open();
                using (var sda = new SqlDataAdapter(cmd))
                {
                    try
                    {
                        cmd.CommandText = cmdText;
                        cmd.CommandType = CommandType.Text;
                        sda.Fill(dt);
                    }
                    catch (Exception ex)
                    {
                        if (!(mypage == null))
                            mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE GetData: " + ex.Message + "');", true);
                    }
                }
            }
        }

        return dt;
    }

    // 02-09-2018 FUNZIONE MIGRATA
    public static DataRow GetRow(string cmdText, Page mypage)
    {
        DataTable dtTable = Database.GetData(cmdText, mypage);
        DataRow drRet;

        if ((dtTable.Rows.Count > 0))
            drRet = dtTable.Rows[0];
        else
            drRet = null/* TODO Change to default(_) if this is not a reference type */;

        return drRet;
    }

    // 30-10-2018: Ritorna ultimo Id Creato
    public static int GetLastIdInserted(string cmd)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        int iNewId = 0;

        try
        {
   
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // recupera nuovo inserimento
                using (SqlCommand cmdId = new SqlCommand(cmd, connection))
                {
                    connection.Open();
                    iNewId = (int)cmdId.ExecuteScalar(); // ultimo id inserito
                }
            }
        }
        catch (Exception e)
        {
        }

        return iNewId;

    }

}

public class ASPcompatility
{
    public static string FormatNumberDB(double InputNumber)
    {
        string sRet = "'" + InputNumber.ToString().Replace(",", ".") + "'";
        return sRet;
    }

    public static string FormatStringDb(string InputString)
    {         
        string sRet = "'" + InputString.Replace("'", "''") + "'";
        return sRet;
    }

    public static void SelectMonths(ref DropDownList DDL, string sLingua = "it")
    {
        int i;
        ListItem lItem;
        CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(sLingua);
        DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;

        // elenco dei mesi con default il corrente
        for (i = 1; i <= 12; i++)
        {
            lItem = new ListItem(mfi.MonthNames[i - 1], i.ToString("D2"));
            DDL.Items.Add(lItem);

            if (DateTime.Now.Month == i)
                DDL.SelectedIndex = i - 1;
        }
    }

    public static void SelectYears(ref DropDownList DDL)
    {
        int i;
        ListItem lItem;

        for (i = MyConstants.First_year; i <= MyConstants.Last_year; i++)
        {

            // elenco di anni con default quello corrente
            lItem = new ListItem(i.ToString(), i.ToString());
            DDL.Items.Add(lItem);

            if (DateTime.Now.Year == i)
                DDL.SelectedIndex = i - MyConstants.First_year;
        }
    }

    public static string LastDay(int Month, int Year)
    {
        string sRet = DateTime.DaysInMonth(Convert.ToInt32(Year), Convert.ToInt32(Month)).ToString();
        return sRet;
    }

    public static int DaysInMonth(int Month, int Year)
    {
        int sRet = DateTime.DaysInMonth(Convert.ToInt32(Year), Convert.ToInt32(Month));
        return sRet;
    }

    public static string FirstDay(int Month, int Year)
    {
        string sRet;

        if (Month > 9)
            sRet = "01" + "/" + Month + "/" + Year;
        else
            sRet = "01" + "/" + "0" + Month + "/" + Year;

        return sRet;
    }

    public static string FormatDateDb(string sDateToConvert, bool timestamp = false)
    {
        int aDay;
        int aMonth;
        int aYear;
        string sRet = "";

        DateTime DateToConvert;

        if (sDateToConvert == "") {
            sRet = "''";
            return sRet;
        } //  init

        if (timestamp)
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy HH.mm.ss", System.Globalization.CultureInfo.InvariantCulture);
        else
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy", System.Globalization.CultureInfo.InvariantCulture);

        aDay =DateToConvert.Day;
        aMonth = DateToConvert.Month;
        aYear = DateToConvert.Year;

        string server =  ConfigurationManager.AppSettings["FORMATODATA"];

        switch (server)
        {
            case "US":
                {
                    sRet = "'" + aMonth + "-" + aDay + "-" + aYear;
                    break;
                }

            case "IT":
                {
                    sRet = "'" + aDay + "-" + aMonth + "-" + aYear;
                    break;
                }
        }

        // se richiamato con parametro opzionale timestamp aggiunge ore:min:sec
        if (timestamp)
            sRet = sRet + " " + DateToConvert.Hour + ":" + DateToConvert.Minute + ":" + DateToConvert.Second + "'";
        else
            sRet = sRet + "'";

        return sRet;
    }

    public static DataRowCollection GetRows(string sSQLstring)
    {
        DataSet ds;
        DataRowCollection drRet;

        var connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlDataAdapter Adapter = new SqlDataAdapter(sSQLstring, connection))
            {
                try
                {
                    ds = new DataSet();
                    Adapter.Fill(ds);

                    if (ds.Tables[0].Rows.Count == 0)
                        drRet = null;
                    else
                        drRet = ds.Tables[0].Rows;
                }
                catch (Exception ex)
                {
                    drRet = null;
                }
            }
        }
        return drRet;
    }
}

