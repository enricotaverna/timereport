using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.IO;
using System.Globalization;
using System.Threading;

public partial class input : System.Web.UI.Page
{   
    public int intMonth;
    public bool bTRChiuso;
    public DataTable dtHours;
    public DataTable dtenses;
    public DataTable dtAssenze;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("DATI", "ORE");
        Auth.CheckPermission("DATI", "SPESE");

        // imposta session variables
        SetVariables();

        // Cambia inpostazioni controlli su schermo;
        ChangeScreen();

        // gestisce creazione record per drag&drop
        if (Request["__EVENTTARGET"] == "drag&drop")
        {
            ProcessDragDrop(Request["__EVENTARGUMENT"]);
        }

        if ((string)Session["type"] == "bonus")
            BindDDLProjects();
    }

    //   ********************************************************************************************
    //   ProcessDragDrop() 
    //      01/2014
    //      La funzione legge i paramentri di input (id record da copiare, data in cui copiarlo)
    //      quindi in base al tipo sessione legge il record originale e effettua una INSERT
    //      alla data specificata
    //   *********************************************************************************************
    protected void ProcessDragDrop(string input)
    {
        string[] param = input.Split(new Char[] { ';' });

        // se TR è chiuso esce
        if (!Convert.ToBoolean(Session["InputScreenChangeMode"]))
            return;

        if ((string)Session["type"] == "hours")
        {

            DataTable dt = Database.GetData("Select projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment from hours where hours_id=" + param[1], this.Page);

                if (dt.Rows.Count > 0)
                {
 
                    // formata alcuni campi per successiva scrittura                            
                    Double iHours = Convert.ToDouble(dt.Rows[0]["hours"]);
                    string strAccountingDate = dt.Rows[0]["AccountingDate"].ToString() == "" ? "null" : ASPcompatility.FormatDateDb(dt.Rows[0]["AccountingDate"].ToString(), false);

                    // scrive il record copia!
                    Database.ExecuteSQL("INSERT INTO hours (date, projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, createdBy, creationDate) VALUES(" +
                                         ASPcompatility.FormatDateDb(param[0], false) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["projects_id"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()) + " , " +
                                         ASPcompatility.FormatNumberDB(iHours) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["hourType_id"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["CancelFlag"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["TransferFlag"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["Activity_id"].ToString()) + " , " +
                                         strAccountingDate + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["comment"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(Session["UserId"].ToString()) + " , " +
                                         ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) +
                                         " )"
                                        , this.Page);
                }

            CaricaBufferOre(); // refresh ore

        } // Session["type"] == "hours")

        if ((string)Session["type"] == "expenses" || (string)Session["type"] == "bonus")
        {

            // leggi record da copiare
            DataTable dt = Database.GetData("Select projects_id, persons_id, Amount, ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, TipoBonus_id, AccountingDate, comment from Expenses where Expenses_id=" + param[1], this.Page);

            if (dt.Rows.Count > 0)    
                {
                    // formata alcuni campi per successiva scrittura                            
                    double iAmount = Convert.ToDouble(dt.Rows[0]["Amount"]);

                    string strAccountingDate = dt.Rows[0]["AccountingDate"].ToString() == "" ? "null" : ASPcompatility.FormatDateDb(dt.Rows[0]["AccountingDate"].ToString(), false);

                    // scrive il record copia!
                    Database.ExecuteSQL("INSERT INTO Expenses (date, projects_id, persons_id, Amount, ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, TipoBonus_id,AccountingDate, comment, createdBy, creationDate) VALUES(" +
                                         ASPcompatility.FormatDateDb(param[0], false) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["projects_id"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["persons_id"].ToString()) + " , " +
                                         ASPcompatility.FormatNumberDB(iAmount) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["ExpenseType_id"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["CancelFlag"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["CreditCardPayed"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["CompanyPayed"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["InvoiceFlag"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["TipoBonus_id"].ToString()) + " , " +
                                         strAccountingDate + " , " +
                                         ASPcompatility.FormatStringDb(dt.Rows[0]["comment"].ToString()) + " , " +
                                         ASPcompatility.FormatStringDb(Session["UserId"].ToString()) + " , " +
                                         ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) +
                                         " )"
                                        , this.Page);
                }

            CaricaBufferSpese(); // refresh spese

        } // Session["type"] == "hours")

        if ((string)Session["type"] == "leave")
        {
            // **** drag & drop non abilitato su richieste assenza **
        }
    }
  
    //   ****************************************
    //   BindDDLProjects() 
    //   ****************************************
    protected void BindDDLProjects()
    {

        DataTable dtProgettiForzati = (DataTable)Session["dtProgettiForzati"];

        DDLProgetto.DataSource = dtProgettiForzati;
        DDLProgetto.DataTextField = "DescProgetto";
        DDLProgetto.DataValueField = "Projects_Id";
        DDLProgetto.DataBind();

        // se in creazione imposta il default di progetto 
        if (Session["ProjectCodeDefault"] != null)
            DDLProgetto.SelectedValue = Session["ProjectCodeDefault"].ToString();
    }

    //   ****************************************
    //   ChangeScreen
    //   ****************************************
    protected void ChangeScreen()
    {

        // se TR chiuso spegne il bottone e mette la scrita
        if (bTRChiuso)
        {
            btChiudiTR.Visible = false; lbTRChiuso.Visible = true;
        }
        else
        {
            btChiudiTR.Visible = true; lbTRChiuso.Visible = false;
        }

        //// se non Beta Tester non fa comparire bottone
        //    if (!Convert.ToBoolean(Session["BetaTester"]))
        //        { btChiudiTR.Visible = false; lbTRChiuso.Visible = false; } 
    }

    //   ****************************************
    //   SetVariables
    //   ****************************************
    protected void SetVariables()
    {

        
        // *** Imposta default dei form *****
        DSBonus.SelectParameters["TipoBonus_Id"].DefaultValue = ConfigurationManager.AppSettings["TIPO_BONUS_TRAVEL"];

        if (Request.QueryString["type"] != null)
            Session["type"] = Request.QueryString["type"];

        // se è cambiato il mese/anno il parametro response è valorizzato per forzare il refresh del buffer
        if ((string)Session["type"] != "hours" && !String.IsNullOrEmpty((string)Request.QueryString["refresh"]))
            Session["RefreshRicevuteBuffer"] = "refresh";

        if (Session["SedeViaggio"] != null)
            SedeViaggio.Text = Session["SedeViaggio"].ToString();

        if (Session["TipoBonus"] != null)
            DDLBonus.SelectedValue = Session["TipoBonus"].ToString();

        if (Request.QueryString["year"] != null)
            Session["year"] = Request.QueryString["year"];

        if (Request.QueryString["month"] != null)
            Session["month"] = Request.QueryString["month"].PadLeft(2, '0');

        if (Session["year"] == null)
            Session["year"] = DateTime.Now.Year;

        if (Session["month"] == null)
            Session["month"] = DateTime.Now.Month.ToString().PadLeft(2, '0');

        // se sulla vista spese ed è forzato un refresh bufferizza l'elenco delle ricevute
        if ((string)Session["type"] != "hours" && !String.IsNullOrEmpty((string)Session["RefreshRicevuteBuffer"]))
            Session["RicevuteBuffer"] = CaricaBufferRicevute();

        // carica in memoria le ore del mese per l'utente
        CaricaBufferOre();
        CaricaBufferSpese();
        CaricaBufferAssenze();

        intMonth = Convert.ToUInt16(Session["month"].ToString());

        // se il cutoff non è passato controlla che il TR non sia chiuso
        string sCmd = "SELECT * from logTR Where persons_id='" + Session["persons_id"] + "' AND stato=1 AND Mese='" + Session["month"] + "' AND Anno='" + Session["Year"] + "'";

        if (Database.RecordEsiste(sCmd, this.Page))
            bTRChiuso = true;
        else
            bTRChiuso = false;

        // calcola se la pagina è modificabile o no controllando data cutoff e chiusura TR
        if (Convert.ToDateTime(Session["CutoffDate"]) > Convert.ToDateTime("01" + "/" + Session["month"] + "/" + Session["year"]) || bTRChiuso == true)
            Session["InputScreenChangeMode"] = false;
        else
            Session["InputScreenChangeMode"] = true;
    }

    // Legge tutte le ricevute del mese per l'utente e costruisce una lista di interi con gli id spesa corrispondenti
    protected List<int> CaricaBufferRicevute()
    {

        List<int> iList = new List<int>();
        int iStart;
 
        // legge i file nel mese / utente
        string[] filePaths = TrovaRicevuteLocale(-1, Session["username"].ToString(), Session["year"].ToString() + Session["month"].ToString() + "01");

        // azzera il buffer
        Session["RicevuteBuffer"] = null;

        try
        {
            // carica il buffer estraendo l'ID della nome del file
            for (int i = 0; i < filePaths.Length; i++)
            {
                iStart = filePaths[i].IndexOf("fid-") + 4;
                iList.Add(Convert.ToInt32(filePaths[i].Substring(iStart, filePaths[i].LastIndexOf("-") - iStart)));
            }
        }
        catch
        {

        }

        // avedo caricato il buffer spese il flag di refresh
        Session["RefreshRicevuteBuffer"] = "";

        // ritorna la lista di interi che contiene tutti gli Id spese che hanno una ricevuta
        return (iList);
    }

    // Carica buffer Ore in dtHours
    protected void CaricaBufferOre()
    {

        string sLastDay = ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])).ToString();

        // seleziona tutte le ore da primo a ultimo del mese
        string sQuery = "SELECT hours.projects_id, Projects.ProjectCode, hours.hours, hours.Hours_id, Projects.name, hours.date, hours.comment, Activity.ActivityCode + ' ' + Activity.Name as ActivityName, CreatedBy, CreationDate, ApprovalStatus, ApprovalRequest_Id " +
                        " FROM Hours INNER JOIN projects ON hours.projects_id=projects.projects_id LEFT OUTER JOIN Activity ON Activity.Activity_id = Hours.Activity_id " +
                        " WHERE hours.Persons_id=" + Session["Persons_id"] +
                        " AND hours.date >= " + ASPcompatility.FormatDateDb("01/" + Session["month"] + "/" + Session["year"], false) +
                        " AND hours.date <= " + ASPcompatility.FormatDateDb(sLastDay + "/" + Session["month"] + "/" + Session["year"], false);

        dtHours = Database.GetData(sQuery, this.Page);

    }

    // Carica buffer assenze
    protected void CaricaBufferAssenze()
    {

        string sLastDay = ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])).ToString();

        // seleziona tutte le ore da primo a ultimo del mese
        string sQuery = "SELECT *, b.Name as ProjectName" +
                        " FROM WF_ApprovalRequest AS a INNER JOIN projects as b ON a.projects_id=b.projects_id " +
                        " WHERE a.Persons_id=" + Session["Persons_id"] +
                        " AND a.FromDate >= " + ASPcompatility.FormatDateDb("01/" + Session["month"] + "/" + Session["year"], false) +
                        " AND a.FromDate <= " + ASPcompatility.FormatDateDb(sLastDay + "/" + Session["month"] + "/" + Session["year"], false);

        dtAssenze = Database.GetData(sQuery, this.Page);

    }

    // Carica buffer Ore in dtHours
    protected void CaricaBufferSpese()
    {

        string sLastDay = ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])).ToString();
        string sQuery="";

        // Estrae i record di spesa o bonus a seconda del tipo scheda
        if ((string)Session["type"] == "expenses")
            sQuery = "SELECT Projects.ProjectCode, expenses.amount, expenses.expenses_id, ExpenseType.ExpenseCode, ExpenseType.UnitOfMeasure, Projects.Name, ExpenseType.Name as NomeSpesa, expenses.date, expenses.comment, expenses.TipoBonus_id, CancelFlag, InvoiceFlag, CreditCardPayed, CompanyPayed FROM (expenses INNER JOIN projects ON expenses.projects_id=projects.projects_id) INNER JOIN ExpenseType ON  ExpenseType.ExpenseType_id=Expenses.ExpenseType_id WHERE expenses.Persons_id=" + Session["Persons_id"] + " AND expenses.TipoBonus_id = 0 " +
                     " AND expenses.date >= " + ASPcompatility.FormatDateDb("01/" + Session["month"] + "/" + Session["year"], false) +
                     " AND expenses.date <= " + ASPcompatility.FormatDateDb(sLastDay + "/" + Session["month"] + "/" + Session["year"], false);
        else if ((string)Session["type"] == "bonus")
            sQuery = "SELECT Projects.ProjectCode, expenses.amount, expenses.expenses_id, ExpenseType.ExpenseCode, ExpenseType.UnitOfMeasure, Projects.Name, ExpenseType.Name as NomeSpesa, expenses.date, expenses.comment, expenses.TipoBonus_id, CancelFlag, InvoiceFlag, CreditCardPayed, CompanyPayed FROM (expenses INNER JOIN projects ON expenses.projects_id=projects.projects_id) INNER JOIN ExpenseType ON  ExpenseType.ExpenseType_id=Expenses.ExpenseType_id WHERE expenses.Persons_id=" + Session["Persons_id"] + " AND expenses.TipoBonus_id <> 0 " +
                     " AND expenses.date >= " + ASPcompatility.FormatDateDb("01/" + Session["month"] + "/" + Session["year"], false) +
                     " AND expenses.date <= " + ASPcompatility.FormatDateDb(sLastDay + "/" + Session["month"] + "/" + Session["year"], false);

        if (sQuery!="") // chiamata da scheda spese
            dtenses = Database.GetData(sQuery, this.Page);

    }

    // riceve in input id spesa, nome user, data spesa (YYYYMMGG) e restutuisce array con nome file
    // Se id spesa = -1 allora estrae tutte le spese del mese per l'utente
    public static string[] TrovaRicevuteLocale(int iId, string sUserName, string sData)
    {

        string[] filePaths = null;

        try
        {
            // costruisci il pach di ricerca: public + anno + mese + nome persona 
            string TargetLocation = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings["PATH_RICEVUTE"]) + sData.Substring(0, 4) + "\\" + sData.Substring(4, 2) + "\\" + sUserName + "\\";
            // carica immagini
            filePaths = Directory
                .GetFiles(TargetLocation, "fid-" + (iId == -1 ? "" : iId.ToString()) + "*.*")
                                .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                                .ToArray();
            return (filePaths);
        }
        catch (Exception e)
        {
            //non fa niente ma evita il dump
            return (null);
        }

    }

    protected void FindHours(int intDayNumber)
    {

        string strTooltip = "";
        string sDate, sISODate;
        float iOre = 0;
        string WFIcon = "";

        if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
        {

            sDate = intDayNumber.ToString().PadLeft(2, '0') + "/" + Session["month"] + "/" + Session["year"];
            sISODate = Session["year"].ToString() + Session["month"].ToString() + intDayNumber.ToString().PadLeft(2, '0'); // YYYYYMMDD

                Response.Write("<td class=hours id='TDitm" + sISODate + "'>");
            //else
            //    Response.Write("<td id='TDitm" + sISODate + "'>");

            DataRow[] drRow = dtHours.Select("[date] = '" + sDate + "'");

            // cerca sulla versione bufferizzate dtHours
            foreach (DataRow rdr in drRow)
            {

                iOre = Convert.ToSingle(rdr["hours"]);
                strTooltip = "Data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["date"]) +
                             "<br>Progetto:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + HttpUtility.HtmlEncode(rdr["name"]) +
                             "<br>Attività:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + rdr["ActivityName"] +
                             "<br>Ore:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + iOre.ToString("G") +
                             "<br>Creato da:&nbsp;&nbsp;&nbsp;" + rdr["CreatedBy"] +
                              "<br>Creato il:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["CreationDate"]) +
                             "<br><br>" + rdr["comment"];

                // imposta icona di workflow
                WFIcon = "";

                if (rdr["ApprovalStatus"].ToString() == MyConstants.WF_REQUEST)
                    WFIcon = "<img align = left src ='/timereport/images/icons/16x16/warning.png' width = 14 height = 14 border = 0 >";

                // l'id viene messo uguale al numero record per essere poi usato nel drag&drop

                if (rdr["ApprovalStatus"].ToString().Length == 0) { 
                    Response.Write("<div class=TRitem id=TRitm" + rdr["Hours_id"] + ">");
                    Response.Write("<a id=" + rdr["Hours_id"] + " title=' " + strTooltip + "' class=hours href=input-ore.aspx?action=fetch&hours_id=" + rdr["Hours_id"] + " >" + rdr["ProjectCode"] + " : " + iOre.ToString("G")  + " " + GetLocalResourceObject("oreUOM") + WFIcon + "</a>");
                }
                else { 
                    Response.Write("<div id=TRitm" + rdr["Hours_id"] + ">");
                    Response.Write("<a id=" + rdr["Hours_id"] + " title=' " + strTooltip + "'class=hours href=/timereport/m_gestione/Approval/LeaveRequestCreate.aspx?action=fetch&ApprovalRequest_id=" + rdr["ApprovalRequest_id"] + " >" + rdr["ProjectCode"] + " : " + iOre.ToString("G") + " " + GetLocalResourceObject("oreUOM") + WFIcon + "</a>");
                }

                // cancellazione solo in change e se la riga non è una richiesta assenza
                if (Convert.ToBoolean(Session["InputScreenChangeMode"]) & (rdr["ApprovalStatus"].ToString().Length == 0)) 
                            Response.Write("<a href=# onclick='CancellaId(" + rdr["Hours_id"] + ")' ><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>");

                    Response.Write("</div>"); // TRore
            }

            if (drRow.Count() > 0)
                Response.Write("</td>");   // class=hours
            else
                Response.Write("&nbsp;</td>");

        }
    }

    protected void FindExpenses(int intDayNumber)
    {

        string strTooltip = "";
        string sDate, sISODate;
        float fSpese = 0;
        string strIconaRicevuta;

        // recupera il buffer con le spese che hanno ricevuta
        List<int> iRicevuteBuffer = (List<int>)Session["RicevuteBuffer"];

        if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
        {
            sDate = intDayNumber.ToString().PadLeft(2, '0') + "/" + Session["month"] + "/" + Session["year"];
            sISODate = Session["year"].ToString() + Session["month"].ToString() + intDayNumber.ToString().PadLeft(2, '0'); // YYYYYMMDD

            Response.Write("<td class=hours id='TDitm" + sISODate + "'>");            

            DataRow[] drRow = dtenses.Select("[date] = '" + sDate + "'");

            // cerca sulla versione bufferizzate dtHours
            foreach (DataRow rdr in drRow)
            {
                fSpese = Convert.ToSingle(rdr["amount"]);
                string sFlag = "";
                sFlag = Convert.ToBoolean(rdr["CancelFlag"]) ? " STO " : "";
                sFlag = Convert.ToBoolean(rdr["CreditCardPayed"]) ? sFlag + " CC " : sFlag;
                sFlag = Convert.ToBoolean(rdr["CompanyPayed"]) ? sFlag + " PA " : sFlag;
                sFlag = Convert.ToBoolean(rdr["InvoiceFlag"]) ? sFlag + " FAT " : sFlag;

                strTooltip = "Data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["date"]) +
                             "<br>Progetto:&nbsp;&nbsp;" + HttpUtility.HtmlEncode(rdr["Name"]) +
                             "<br>Spesa:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + rdr["NomeSpesa"] +
                             "<br>Importo:&nbsp;&nbsp;&nbsp;" + fSpese.ToString("G") + " " + rdr["UnitOfMeasure"] +
                             "<br>Flag:&nbsp;&nbsp;&nbsp;" +
                             sFlag +
                             "<br><br>" + HttpUtility.HtmlEncode(rdr["comment"].ToString());

                // se la spesa ha una ricevuta stampa un icona, altrimenti lascia blank
                if (iRicevuteBuffer.Contains(Convert.ToInt32(rdr["expenses_id"])))
                    strIconaRicevuta = " <img src='/timereport/images/icons/other/paperclip.png' alt='giustificativi' height='12' width='12'> ";
                else
                    strIconaRicevuta = "";

                // l'id viene messo uguale al numero record per essere poi usato nel drag&drop
                Response.Write("<div class=TRitem id=TRitm" + rdr["expenses_id"] + ">");

                    Response.Write("<a id=" + rdr["expenses_id"] + " title=' " + strTooltip + "' class=hours href=input-spese.aspx?action=fetch&expenses_id=" + rdr["expenses_id"] + " >" + strIconaRicevuta + rdr["ProjectCode"] + ":" + rdr["ExpenseCode"] + " : " + fSpese.ToString("G") + " " + rdr["UnitOfMeasure"] + "</a>");
                    if (Convert.ToBoolean(Session["InputScreenChangeMode"]))
                        Response.Write("<a  align=right href=# onclick='CancellaId(" + rdr["expenses_id"] +")'><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>");

                Response.Write("</div>"); // TRexp

            }

            if (drRow.Count() > 0)
                Response.Write("</td>");
            else
                Response.Write("&nbsp;</td>");

        }
    }

    protected void FindAssenze(int intDayNumber)
    {

        string strTooltip = "";
        string sDate, sISODate;
        float iOre = 0;
        string WFIcon = "";

        if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
        {

            sDate = intDayNumber.ToString().PadLeft(2, '0') + "/" + Session["month"] + "/" + Session["year"];
            sISODate = Session["year"].ToString() + Session["month"].ToString() + intDayNumber.ToString().PadLeft(2, '0'); // YYYYYMMDD

            Response.Write("<td class=hours id='TDitm" + sISODate + "'>");

            DataRow[] drRow = dtAssenze.Select("[FromDate] = '" + sDate + "'");

            // cerca sulla versione bufferizzate dtHours
            foreach (DataRow rdr in drRow)
            {

                iOre = Convert.ToSingle(rdr["hours"]);
                strTooltip = "Da data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["FromDate"]) +
                             "<br>A data:&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["ToDate"]) +
                             "<br>Progetto:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + HttpUtility.HtmlEncode(rdr["ProjectName"]) +
                             "<br>Ore:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + iOre.ToString("G") +
                             "<br>Stato:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + HttpUtility.HtmlEncode(rdr["ApprovalStatus"]) +
                             "<br>Creato il:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["CreationDate"]) +
                             "<br><br>" + rdr["Comment"];

                // imposta icona di workflow
                WFIcon = "";

                if (rdr["ApprovalStatus"].ToString() == MyConstants.WF_REQUEST)
                    WFIcon = "<img align = left src ='/timereport/images/icons/16x16/warning.png' width = 14 height = 14 border = 0 >";

                if (rdr["ApprovalStatus"].ToString() == MyConstants.WF_APPROVED | rdr["ApprovalStatus"].ToString() == MyConstants.WF_NOTIFIED)
                    WFIcon = "<img align = left src ='/timereport/images/icons/16x16/WF_OK.png' width = 14 height = 14 border = 0 >";

                if (rdr["ApprovalStatus"].ToString() == MyConstants.WF_REJECTED)
                    WFIcon = "<img align = left src ='/timereport/images/icons/16x16/WF_Delete.png' width = 12 height = 12 border = 0 >";


                // l'id viene messo uguale al numero record per essere poi usato nel drag&drop
                Response.Write("<div id=TRitm" + rdr["ApprovalRequest_id"] + ">");

                Response.Write(WFIcon + "<a id=" + rdr["ApprovalRequest_id"] + " title=' " + strTooltip + "' class=hours href=/timereport/m_gestione/Approval/LeaveRequestCreate.aspx?action=fetch&ApprovalRequest_id=" + rdr["ApprovalRequest_id"] + " >" + rdr["ProjectCode"] + " : " + rdr["ProjectName"] + "</a>" );

                if (Convert.ToBoolean(Session["InputScreenChangeMode"]))
                    Response.Write("<a href=# onclick='CancellaAssenza(" + rdr["ApprovalRequest_id"] + ")' ><img align=right src=images/icons/16x16/trash.gif width=16 height=14 border=0></a>");

                Response.Write("</div>"); // TRore
            }

            if (drRow.Count() > 0)
                Response.Write("</td>");   // class=hours
            else
                Response.Write("&nbsp;</td>");

        }
    }

    // carica progetti accessibili all'utente per box spese trasferta
    protected string GetProject(string sDate)
    {

        // 0208 FUNZIONE MIGRATA

        DataRow[] drProgetto = dtHours.Select("Date = '" + Convert.ToDateTime(sDate) +"'");

        if (drProgetto.Count() == 0)
            return "";
        else
            return drProgetto[0][0].ToString();

    }

    protected void OutputColumn(int intDayNumber)
    {

        string sDate, sISODate;
        string strProject;
        int intDayWeek = 0;
        Boolean bHoliday = false;

        sDate = intDayNumber.ToString().PadLeft(2, '0') + "/" + Session["month"] + "/" + Session["year"]; // DD/MM/YYYY
        sISODate = Session["year"].ToString() + Session["month"].ToString() + intDayNumber.ToString().PadLeft(2, '0'); // YYYYYMMDD 

        if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
        {

            intDayWeek = (int)Convert.ToDateTime(sDate).DayOfWeek;
            // look if it's an holiday	
            //if (Database.RecordEsiste("SELECT * FROM Holiday WHERE holiday_date=" + ASPcompatility.FormatDateDb(strDate ))) {
            if (MyConstants.DTHoliday.Rows.Contains(sDate))
            {
                Response.Write("<td id='hdr" + sISODate + "' class=noWorkDays title=" + sDate + " >");
                bHoliday = true;
            }
            else if (intDayWeek == 6 || intDayWeek == 0)
            {
                Response.Write("<td id='hdr" + sISODate + "'class=noWorkDays title=" + sDate + " >");
                bHoliday = true;
            }
            else
            {
                Response.Write("<td id='hdr" + sISODate + "'class=WorkDays title=" + sDate + " >");
                bHoliday = false;
            }

            CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(Session["lingua"].ToString());
            DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;
            Response.Write(mfi.DayNames[intDayWeek] + " " + intDayNumber);
        }
        else
            Response.Write("&nbsp;");

        // se cutoff non è passato si possono creare nuove entries

        if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
            if (Convert.ToBoolean(Session["InputScreenChangeMode"]))
            {

                switch ((string)Session["type"])
                {
                    case "hours":  // CALENDARIO DATE
                        Response.Write("<a  align=right href=input-ore.aspx?action=new&date=" + sDate + "><img align=right src=images/icons/16x16/nuovo.gif width=16 height=16 border=0></a>");
                        break;

                    case "leave":  // CALENDARIO DATE
                        Response.Write("<a  align=right href=/timereport/m_gestione/Approval/LeaveRequestCreate.aspx?action=new&date=" + sDate + "><img align=right src=images/icons/16x16/nuovo.gif width=16 height=16 border=0></a>");
                        break;

                    case "expenses": // CALENDARIO SPESE
                        Response.Write("<a  align=right href=input-spese.aspx?action=new&date=" + sDate + "><img align=right src=images/icons/16x16/nuovo.gif width=16 height=16 border=0></a>");
                        break;

                    case "bonus":  // CALENDARIO SPECIALI
                                   // Stampa ticket solo se non già presente per persona/data un ticket o un buono pasto
                        DataRow[] drFound = dtenses.Select("Date = '" + Convert.ToDateTime(sDate) +"'");

                        //                        if (!Database.RecordEsiste("SELECT * FROM Expenses WHERE Date=" + ASPcompatility.FormatDateDb(strDate, false) + " AND Persons_id = " + Session["Persons_id"] + " AND TipoBonus_id <> '' ", this.Page) & !bHoliday)
                        if ( !bHoliday) // giorno on è un festivo
                        {

                            string sDisplay="";

                            if (drFound.Count() != 0) // se ci sono item le icone viaggio e ticket vengono spente
                                sDisplay = "style='display:none'";

                            // id hdrIcn usato per nascondere le icone
                            Response.Write("<span " + sDisplay + " id='hdrIcon" + sISODate + "'><a href='#' class='tktRest' restDate='" + sISODate + "'><img align=right src=images/icons/16x16/restaurant.png  border=0></a>");

                            strProject = GetProject(sDate);

                            // il titolo del link viene impostato uguale alla data per essere poi impostato da javascript nella finestra modale
                            Response.Write("<a title=" + sDate + ";" + strProject + " href=#dialog name=modal><img align=right src=images/icons/16x16/travel.png border=0></a><span>");
                        }

                        break;
                }

            } //  se entro cutoff

        Response.Write("</td>");

    } // end OutputColum

    protected void InsertButton_Click(object sender, EventArgs e)
    {
        string cmd;

        // inserisce record x trasferta
        cmd = "INSERT INTO expenses (Date, Projects_Id,Persons_Id,ExpenseType_Id,amount,comment,CreditCardPayed, CompanyPayed, CancelFlag,InvoiceFlag,CreatedBy,CreationDate,TipoBonus_id) " +
                "values (" +
                ASPcompatility.FormatDateDb(Request.Form["refDate"], false) + " ," +
                "'" + Request.Form["DDLProgetto"] + "' ," +    // da dropdown
                "'" + Session["persons_id"] + "' ," +
                "'" + Request.Form["DDLBonus"] + "' ," +     // da dropdown
                "'1' ," +
                ASPcompatility.FormatStringDb(Request.Form["SedeViaggio"]) + ", " +
                "'false' ," +
                "'false' ," +
                "'false' ," +
                "'false' ," +
                "'" + Session["userId"] + "' ," +
                ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " ," +
                "'" + ConfigurationManager.AppSettings["TIPO_BONUS_TRAVEL"] + "' )";

        Database.ExecuteSQL(cmd, this.Page);

        // setta default
        Session["SedeViaggio"] = Request.Form["SedeViaggio"];
        Session["ProjectCodeDefault"] = Request.Form["DDLProgetto"];
        Session["TipoBonus"] = Request.Form["DDLBonus"];

        DDLProgetto.SelectedValue = Request.Form["DDLProgetto"];
        DDLBonus.SelectedValue = Request.Form["DDLBonus"];

        // refresh buffer spese
        CaricaBufferSpese();

    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}

