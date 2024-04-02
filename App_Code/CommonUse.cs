using ExcelDataReader;
using Syncfusion.XlsIO;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
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

        if (drRow != null)
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
    public static void LoadPermission(int persons_id)
    {

        // Carica le permissione dell'utente in una tabella e la memorizza in una variabile di sessione
        DataRowCollection AuthPermission;

        AuthPermission = ASPcompatility.GetRows(" SELECT c.AuthTask, c.AuthActivity from Persons as a " + " INNER JOIN AuthPermission as b ON b.UserLevel_id = a.UserLevel_id " + " INNER JOIN AuthActivity as c ON c.AuthActivity_id = b.AuthActivity_id " + " WHERE a.persons_id = " + ASPcompatility.FormatNumberDB(persons_id));

        HttpContext.Current.Session["AuthPermission"] = AuthPermission;
    }

    // Verifica permission caricate rispetto all'attività chiesta 
    public static bool CheckPermission(string Task, string Actvity)
    {
        DataRowCollection aAuthPermission;
        int f;

        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];

        // sessione scaduta
        if (CurrentSession == null)
            HttpContext.Current.Response.Redirect(ConfigurationManager.AppSettings["LOGIN_PAGE"]);

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

    // Applica alcune formattazioni standard a tutti i worksheet 
    public static void FormatWorkbook(ref IWorkbook wb)
    {

        //Defining header style
        IStyle headerStyle = wb.Styles.Add("HeaderStyle");
        headerStyle.BeginUpdate();
        headerStyle.Color = Color.FromArgb(14, 40, 65); // dark blue
        headerStyle.Font.RGBColor = Color.White;
        headerStyle.Font.Bold = true;
        headerStyle.EndUpdate();

        // formatta i ws contenuti nel wb            
        // dimensiona righe e colonne in base al contenuto
        // applica formattazione alla prima riga di intestazione
        foreach (var ws in wb.Worksheets)
        {
            ws.UsedRange.AutofitColumns();
            ws.UsedRange.AutofitRows();
            ws.Rows[0].CellStyle = headerStyle;
        }
    }

    public static void CheckAutMobile(int UserLevel, int PageLevel)
    {

        // Mancato auth                
        if (UserLevel < PageLevel)
            HttpContext.Current.Response.Redirect("/timereport/mobile/login.aspx");
    }

    public static void CreateMessageAlert(ref Page aspxPage, string strMessage, string strKey)
    {
        string strScript = "<script language=JavaScript>" +
                           " alert('" + strMessage + "') " +
                           " </script>";

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
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Unicode;
        HttpContext.Current.Response.ContentType = "application/vnd.xls";
        HttpContext.Current.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

        // // If you want the option to open the Excel file without saving then
        // // comment out the line below

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

        conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

        Adapter = new SqlDataAdapter(sQuery, conn);
        Adapter.Fill(ds, "export");

        DataGrid GridExp = new DataGrid();

        GridExp.DataSource = ds.Tables["export"].DefaultView;
        GridExp.DataBind();

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=Export.xls");
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Unicode;
        HttpContext.Current.Response.ContentType = "application/vnd.xls";
        HttpContext.Current.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

        // // If you want the option to open the Excel file without saving then
        // // comment out the line below
        // // Response.Cache.SetCacheability(HttpCacheability.NoCache);

        // create a string writer
        System.IO.StringWriter stringWrite = new System.IO.StringWriter();
        // create an htmltextwriter which uses the stringwriter
        System.Web.UI.HtmlTextWriter htmlWrite = new System.Web.UI.HtmlTextWriter(stringWrite);

        GridExp.RenderControl(htmlWrite);

        HttpContext.Current.Response.Write(stringWrite.ToString());
        HttpContext.Current.Response.End();

    }

    // Esporta Xls usando il framework Synfusion, torna false in caso di errore
    // riceve in input un workbook
    public static bool ExporXlsxWorkbook(IWorkbook workbook, string filename ) {

        try
        {
            //Saving the workbook as stream
            string FolderPath = ConfigurationManager.AppSettings["FolderPath"];
            string FilePath = HttpContext.Current.Server.MapPath(FolderPath + filename);

            FileStream stream = new FileStream(FilePath, FileMode.Create, FileAccess.ReadWrite);
            workbook.SaveAs(stream);
            stream.Dispose();
            return true; // successo
        }
        catch {
            return false; // errore
        }
    }

    // Esporta Xls usando il framework Synfusion, torna false in caso di errore
    // riceve in input una datatable
    public static bool ExporXlsxWorkbook(DataTable dt, string filename)
    {
        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2013;
            IWorkbook workbook = application.Workbooks.Create(1);
            IWorksheet worksheet = workbook.Worksheets[0];

            //Import DataTable to the worksheet
            worksheet.ImportDataTable(dt, true, 1, 1);

            return Utilities.ExporXlsxWorkbook(workbook, filename);

        }
    }

    public static DataTable ImportExcel(FileUpload FileUploadControl, ref string ErrorMessage)
    {

        DataTable dtResult = null;
        string FileName = Path.GetFileName(FileUploadControl.PostedFile.FileName);
        //string Extension = Path.GetExtension(FileUpload.PostedFile.FileName);
        string FolderPath = ConfigurationManager.AppSettings["FolderPath"];
        string FilePath = HttpContext.Current.Server.MapPath(FolderPath + FileName);

        try
        {
            FileUploadControl.SaveAs(FilePath);

            using (var stream = File.Open(FilePath, FileMode.Open, FileAccess.Read))
            {
                // Auto-detect format, supports:
                //  - Binary Excel files (2.0-2003 format; *.xls)
                //  - OpenXml Excel files (2007 format; *.xlsx)
                using (var reader = ExcelReaderFactory.CreateReader(stream))
                {
                    // Choose one of either 1 or 2:
                    dtResult = reader.AsDataSet().Tables[0];

                    // The result of each spreadsheet is in result.Tables
                }
            }
            ErrorMessage = "";
        }
        catch (Exception ex)
        {
            ErrorMessage = ex.Message;
        }

        return dtResult;
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

    public static DateTime GetCutoffDate(string strPeriod, string strMonth, string strYear, string strType)
    {
        DateTime ret;

        // calc the cutoff date based on the input parameter
        if (strPeriod == "1")
        {
            if (strType == "end")
                ret = new DateTime(Convert.ToInt16(strYear), Convert.ToInt16(strMonth), 15);
            else
                ret = new DateTime(Convert.ToInt16(strYear), Convert.ToInt16(strMonth), 1);
        }
        else if (strType == "end")
            ret = new DateTime(Convert.ToInt16(strYear), Convert.ToInt16(strMonth), DateTime.DaysInMonth(Convert.ToInt32(strYear), Convert.ToInt32(strMonth)));
        else
            ret = new DateTime(Convert.ToInt16(strYear), Convert.ToInt16(strMonth), 16);

        return ret;
    }

    public static Tuple<int, int> GetManagerAndAccountId(int Projects_id)
    {

        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];

        DataRow[] rows = CurrentSession.dtProgettiForzati.Select("Projects_id = " + Projects_id);

        var tuple = new Tuple<int, int>(0, 0);

        if (rows.Count() == 1)
            tuple = new Tuple<int, int>(Convert.ToInt32(rows[0]["ClientManager_id"]), Convert.ToInt32(rows[0]["AccountManager_id"]));
        else  // il manager non è bufferizzato, va cercato sul db
        {
            DataRow dr = Database.GetRow("select * from Projects where projects_id = " + ASPcompatility.FormatNumberDB(Projects_id) , null);
            if (dr != null)
                tuple = new Tuple<int, int>(Convert.ToInt32(dr["ClientManager_id"]), Convert.ToInt32(dr["AccountManager_id"]));
        }

        return tuple;
    }

    public static void SetCookie(string key, string value)
    {

        HttpCookie myCookie = HttpContext.Current.Request.Cookies["TRdata"];

        if (myCookie == null)
            myCookie = new HttpCookie("TRdata");

        myCookie[key] = value;

        myCookie.Expires = DateTime.Now.AddYears(100);
        HttpContext.Current.Response.Cookies.Add(myCookie);

        return;
    }

    public static string GetCookie(string key)
    {

        HttpCookie myCookie = HttpContext.Current.Request.Cookies["TRdata"];

        if (myCookie == null || myCookie[key] == null)
            return "";
        else
            return myCookie[key];
    }

}

public class CommonFunction
{
    // Classe per definire paramentri di output della procedura CalcolaPercOre
    public class CalcolaPercOutput
    {
        public double dOreLavorative;
        public double dOreCaricate;
        public double oreMancanti; // ore da caricare nel mese
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


        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        object obj = Database.ExecuteScalar("SELECT SUM(hours) as somma FROM Hours WHERE Persons_id = " + Persons_id + " AND Date >= " + sFromDate + " AND Date <= " + sToDate, null );
        if (obj != DBNull.Value)
            iContaOre = Convert.ToInt32(obj);
        else
            iContaOre = 0;

        for (int f = 1; f <= DateTime.DaysInMonth(iAnno, iMese); f++)
        {
            sDate = f + "/" + iMese + "/" + iAnno.ToString();
            if ((int)Convert.ToDateTime(sDate).DayOfWeek != 0 & (int)Convert.ToDateTime(sDate).DayOfWeek != 6)
                iOreLavorative = iOreLavorative + 1;
        }

        iOreLavorative = iOreLavorative * CurrentSession.ContractHours; // ore lavorative nel mese

        ret.dOreLavorative = iOreLavorative;
        ret.dOreCaricate = iContaOre;

        if (iOreLavorative != 0)
            ret.sPerc = (((float)iContaOre / (float)iOreLavorative) * 100).ToString("N0");
        else
            ret.sPerc = "0";

        // calcola Ore lavorative mancanti da inizio mese al oggi - 1
        DateTime yesterday = DateTime.Today.AddDays(-1);
        DateTime firstDayOfMonth = new DateTime(iAnno, iMese, 1);

        int workingHours = 0;
        if (yesterday >= firstDayOfMonth)
        {
            workingHours = NumeroGiorniLavorativi(firstDayOfMonth, yesterday) * CurrentSession.ContractHours;
            var res = Database.ExecuteScalar("SELECT SUM(hours) as somma FROM Hours WHERE Persons_id = " + Persons_id + " AND Date >= " + sFromDate + " AND Date <= " + ASPcompatility.FormatDateDb(yesterday.ToString("dd/MM/yyyy")), null);
            int oreCaricate = res != DBNull.Value ? Convert.ToInt32(res) : 0;
            ret.oreMancanti = workingHours - oreCaricate;
        }

        return ret;
    }

    public static int NumeroGiorniLavorativi(DateTime startdate, DateTime enddate)
    {
        //var days = (enddate - startdate).Days + 1;
        //return workDaysInFullWeeks(days) + workDaysInPartialWeek(startdate.DayOfWeek, days);

        double calcBusinessDays =  1 + ((enddate - startdate).TotalDays * 5 - (startdate.DayOfWeek - enddate.DayOfWeek) * 2) / 7;

        if (enddate.DayOfWeek == DayOfWeek.Saturday)
            calcBusinessDays--;
        if (startdate.DayOfWeek == DayOfWeek.Sunday)
            calcBusinessDays--;

        return Convert.ToInt16(calcBusinessDays);

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

    public static CultureInfo GetCulture()
    {
        // PROVATA IN SOSTITUZIONE DI GLOBAL.ASAX    
        CultureInfo sRet = new CultureInfo("it");

        TRSession CurrentSession = (TRSession)HttpContext.Current.Session["CurrentSession"];

        if (CurrentSession.Language == "en")
            sRet = new CultureInfo("en");

        return sRet;
    }

    /// <summary>
    /// Invia Mail a destinatario ed elenco CC</summary>
    /// 
    /// <param SendtoString> Destinatario</param>
    /// <param approvalStatus> Stato approvazione: REQU, NOTF etc.</param>    
    /// <param WorkflowType> Tipo Workflow 01 Approvazione 02 Notifica </param>  
    /// <param ListaParametri> Lista parametri da sostituire nel corpo della mail </param>
    /// 
    public static Boolean WF_SendMail(string SendtoString, string CCString, string approvalStatus, string WorkflowType, List<TipoParametri> ListaParametri)
    {
        // Sendto indirizzi mail di spedizione separati da virgole es. "nome.cognome1@aeonvis.com, nome.cognome2@aeonvis.com"

        // ** recupera la mail di default associata al WF
        DataRow dr = Database.GetRow("Select DefaultMail FROM WF_WorkflowType WHERE WorkflowType = " + ASPcompatility.FormatStringDb(WorkflowType), null);

        if (dr["DefaultMail"].ToString().Trim().Length > 0)
            CCString = CCString + ", " + dr["DefaultMail"];

        try
        {
            // Get the HTML from an embedded resource.
            string bodyTo = File.ReadAllText(HttpContext.Current.Server.MapPath(MyConstants.MAIL_TEMPLATE_PATH + MyConstants.SMTP_TEMPLATE));

            string bodyCC = bodyTo; // toglie il link per l'approvazione
            bodyCC = bodyCC.Replace("%link%", "");
            bodyTo = bodyTo.Replace("%link%", "<a href='https://www.aeonvis.it/timereport/m_gestione/approval/Approval_request.aspx?approval_id=%approvalRequest_id%'>clicca per vedere la richiesta</a>");

            // sostituisce i parametri variabili
            foreach (TipoParametri p in ListaParametri)
            {
                bodyTo = bodyTo.Replace("%" + p.pKey + "%", p.pValue);
                bodyCC = bodyCC.Replace("%" + p.pKey + "%", p.pValue);
            }

            // Send the email
            SmtpClient smtp = new SmtpClient();
            smtp.Port = MyConstants.SMTP_PORT;
            smtp.EnableSsl = MyConstants.SMTP_SSL;
            smtp.Host = MyConstants.SMTP_HOST; //Or Your SMTP Server Address
            smtp.Credentials = new System.Net.NetworkCredential(MyConstants.SMTP_USER, MyConstants.SMTP_PWD, "aeonvis.com");

            // ** Manda la mail all'approvatore
            // Create an alternate view and add it to the email.
            // Create the message.
            var msgTo = new MailMessage();
            msgTo.From = new MailAddress(MyConstants.MAIL_FROM);

            msgTo.SubjectEncoding = Encoding.UTF8;

            TipoParametri subj = ListaParametri.Find(x => x.pKey == "subject");
            msgTo.Subject = subj.pValue; // soggetto della mail

            var altView = AlternateView.CreateAlternateViewFromString(bodyTo, null, MediaTypeNames.Text.Html);
            msgTo.AlternateViews.Add(altView);
            msgTo.To.Add(SendtoString);

            smtp.Send(msgTo); // ****** INVIO MAIL **********+

            // ** Manda la mail di notifica
            if (CCString.Length > 0)
            {
                var msgCC = new MailMessage();
                msgCC.From = new MailAddress(MyConstants.MAIL_FROM);

                msgCC.SubjectEncoding = Encoding.UTF8;
                msgCC.Subject = subj.pValue; // soggetto della mail

                altView = AlternateView.CreateAlternateViewFromString(bodyCC, null, MediaTypeNames.Text.Html);
                msgCC.AlternateViews.Add(altView);
                msgCC.To.Add(CCString);

                smtp.Send(msgCC); // ****** INVIO MAIL **********+
            }
        }
        finally
        {
        }

        return true;
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
        public string ProjectName;
        public double Amount;
        public string UnitOfMeasure;
    }

    public static int CheckTicketAssenti(string sMese, string sAnno, string persons_id, ref List<CheckAnomalia> ListaAnomalie)
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

        DataTable dtHomeOffice = new DataTable();
        if (ConfigurationManager.AppSettings["CHECK_HOMEOFFICE"] == "true")
            dtHomeOffice = Database.GetData("SELECT FORMAT(date,'dd/MM/yyyy') AS date " +
                                                 " FROM Hours AS a " +
                                                 " WHERE LocationDescription LIKE '%" + ConfigurationManager.AppSettings["HOME_OFFICE"] + "%'  AND " +
                                                 " persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, null);
        else
            dtHomeOffice = Database.GetData("SELECT FORMAT(date,'dd/MM/yyyy') AS date " +
                                                 " FROM Hours AS a " +
                                                 " WHERE date = '01-01-9999'", null); // per riempire lo schema della tabella

        //dtFerie.PrimaryKey = new DataColumn[] { dtFerie.Columns["hours_id"] };

        // cicla sui giorni del mese, controllo giorni senza ticket
        for (f = 1; f <= DateTime.DaysInMonth(Convert.ToInt32(sAnno), Convert.ToInt32(sMese)); f++)
        {
            sDate = f.ToString().PadLeft(2, '0') + "/" + sMese.PadLeft(2, '0') + "/" + sAnno;

            // giorno lavorativo

            if ((int)Convert.ToDateTime(sDate).DayOfWeek != 6 & (int)Convert.ToDateTime(sDate).DayOfWeek != 0)
            {

                // controlla che non sia festivo e non sia una giornata di Smart Working
                if (!MyConstants.DTHoliday.Rows.Contains(sDate) && (dtFerie.Rows.Count == 0 || dtFerie.Select("date = '" + sDate + "'").Length == 0)
                    && (dtHomeOffice.Select("date = '" + sDate + "'").Length == 0))
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

    public static int CheckTicketHomeOffice(string sMese, string sAnno, string persons_id, ref List<CheckAnomalia> ListaAnomalie)
    {
        // Funzione ritorna
        // 0 = nessun problema
        // 1 = warning
        // 2 = errore
        // La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia

        int iRet = 0;
        ListaAnomalie.Clear();

        if (ConfigurationManager.AppSettings["CHECK_HOMEOFFICE"] == "false")
            return 2;

        string dFirst = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, '0') + "/" + sAnno);
        string dLast = ASPcompatility.FormatDateDb(DateTime.DaysInMonth(Convert.ToInt32(sAnno), Convert.ToInt32(sMese)).ToString() + "/" + sMese + "/" + sAnno);

        // carica ticket caricati nel mese
        DataTable dtTicket = Database.GetData("Select FORMAT(date,'dd/MM/yyyy') as date from Expenses where persons_id=" + persons_id + " AND TipoBonus_id<>'0' AND date >= " + dFirst + " AND date <= " + dLast, null/* TODO Change to default(_) if this is not a reference type */);

        DataTable dtHomeOffice = Database.GetData("SELECT FORMAT(date,'dd/MM/yyyy') AS date " +
                                             " FROM Hours AS a " +
                                             " WHERE LocationDescription LIKE '%" + ConfigurationManager.AppSettings["HOME_OFFICE"] + "%'  AND " +
                                             " persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, null);

        // cicla sui ticket, controlla ticket caricati su giorni HOME OFFICE
        foreach (DataRow i in dtTicket.Rows)
        {

            // se il giorno è in Home Office alza un'anomalia
            if (dtHomeOffice.Select("date = '" + i["date"] + "'").Length != 0)
            {
                // Alza anomalia e carica lista
                iRet = 1;

                CheckAnomalia a = new CheckAnomalia();
                a.Data = Convert.ToDateTime(i["date"]);
                a.Tipo = "M";
                a.Descrizione = "Ticket caricato su giornata in HOME OFFICE";

                ListaAnomalie.Add(a);
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

    public static int CheckAssenze(string sMese, string sAnno, string persons_id, ref List<CheckAnomalia> ListaAnomalie)
    {
        // Funzione ritorna
        // 0 = nessun problema
        // 1 = warning
        // 2 = errore
        // La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia        
        int iRet;

        ListaAnomalie.Clear();

        string dFirst = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, '0') + "/" + sAnno);
        string dLast = ASPcompatility.FormatDateDb(DateTime.DaysInMonth(Convert.ToInt32(sAnno), Convert.ToInt32(sMese)).ToString() + "/" + sMese + "/" + sAnno);

        // selezione se ce ne sono le ore di richiesta assenza in stato da approvare
        DataTable dtAssenze = Database.GetData("Select FORMAT(a.date,'dd/MM/yyyy') as date, a.Projects_id, b.ProjectCode, b.Name as ProjectName from Hours as a JOIN Projects as b ON b.Projects_id = a.Projects_id WHERE ApprovalStatus='" + MyConstants.WF_REQUEST + "' AND Persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, null/* TODO Change to default(_) if this is not a reference type */);

        iRet = dtAssenze.Rows.Count; // numero anomalie

        // cicla sulle assenze non approvate
        foreach (DataRow rs in dtAssenze.Rows)
        {
            CheckAnomalia a = new CheckAnomalia();
            a.Data = Convert.ToDateTime(rs["date"].ToString());
            a.Descrizione = "Richiesta assenza da approvare";
            a.ProjectName = rs["ProjectName"].ToString();

            ListaAnomalie.Add(a);
        }
        return iRet;
    }
}
