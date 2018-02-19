using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;
using System.Windows.Forms;
using System.Globalization;
using System.Threading;

public partial class input : System.Web.UI.Page
{
    public int intMonth;
    public bool bTRChiuso;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd;

        Auth.CheckPermission("DATI", "ORE");
        Auth.CheckPermission("DATI", "SPESE");

        // imposta session variables
        SetVariables();

        // Cambia inpostazioni controlli su schermo;
        ChangeScreen();

        // gestisce creazione record per drag&drop
        if (Request["__EVENTTARGET"] == "drag&drop") {
            ProcessDragDrop(Request["__EVENTARGUMENT"]);
        }

        if ((string)Session["type"]=="bonus")
            BindDDLProjects(); 

        //   Apre connessione per select sui Hours per bottone travel
        Database.OpenConnection();	

	    // delete item
	    if ((string)Request.QueryString["action"]=="delete") 
            {
		    // get the name of the key field
                if ((string)Session["type"] == "hours")
                    Database.ExecuteSQL("DELETE FROM hours WHERE hours_id=" + Request.QueryString["record_Id"], this.Page);
                else if ((string)Session["type"] == "expenses" || (string)Session["type"] == "bonus")
                    CancellaRecordSpese(Request.QueryString["record_Id"]);    
                    
                Response.Redirect("input.aspx");
	        }
    
        // inserisce record x ticket restaurant
        if ((string)Request.QueryString["action"] == "ticket")
        {
            cmd = "INSERT INTO expenses (Date, Projects_Id,Persons_Id,ExpenseType_Id,amount,comment,CreditCardPayed, CompanyPayed, CancelFlag,InvoiceFlag,CreatedBy,CreationDate,TipoBonus_id) " +
                      "values (" +
                      ASPcompatility.FormatDateDb(Request.QueryString["date"],false) + " ," +
                      "'" +  ConfigurationManager.AppSettings["TICKET_REST_PROJECT"] + "' ," +
                      "'" + Session["persons_id"] + "' ," +
                      "'" + ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"] + "' ," +
                      "'1' ," +
                      "'' ," +
                      "'false' ," +
                      "'false' ," +
                      "'false' ," +
                      "'false' ," +
                      "'" + Session["userId"] + "' ," +
                      ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), true) + " ," +
                      "'" + ConfigurationManager.AppSettings["TIPO_BONUS_TKTREST"] + "' )" ;
                Database.ExecuteSQL(cmd, this.Page);
            }

        Database.CloseConnection();
    }

    // CancellaRecordSpese: prende in input l'id della spese, cancella il record e le ricevute allegate
    protected void CancellaRecordSpese(string sId)    {
     
        // cancella record
        Database.ExecuteSQL("DELETE FROM expenses WHERE expenses_id=" + sId, this.Page);

        // chiama web service che cancella tutte le ricevute

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
            DataTable dt = new DataTable();
            
            // se TR è chiuso esce
            if (!Convert.ToBoolean(Session["InputScreenChangeMode"]))
                return;

            if ((string)Session["type"] == "hours") {

                // leggi record da copiare
                Database.OpenConnection();
                using (SqlDataReader rdr = Database.GetReader("Select projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment from hours where hours_id=" + param[1], this.Page))
                {
                    if (rdr != null)
                    {
                        dt.Load(rdr); // carica record

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
                Database.CloseConnection();
                } // using
            } // Session["type"] == "hours")

            if ((string)Session["type"] == "expenses" || (string)Session["type"] == "bonus")
            {

                // leggi record da copiare
                Database.OpenConnection();
                using (SqlDataReader rdr = Database.GetReader("Select projects_id, persons_id, Amount, ExpenseType_id, CancelFlag, CreditCardPayed, CompanyPayed, InvoiceFlag, TipoBonus_id, AccountingDate, comment from Expenses where Expenses_id=" + param[1], this.Page))
                {
                    if (rdr != null)
                    {
                        dt.Load(rdr); // carica record

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
                } // using
                Database.CloseConnection();
            } // Session["type"] == "hours")

        }
         //   ****************************************
         //   BindDDLProjects() 
         //   ****************************************
         protected void  BindDDLProjects() 
         {

            // attivata MARS 
             SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

             SqlCommand cmd;
             conn.Open();

             // imposta selezione progetti in base all'utente
             if (Convert.ToInt32(Session["ForcedAccount"]) != 1)
                 cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto FROM Projects WHERE active = 'true' ORDER BY ProjectCode", conn);
             else
                 cmd = new SqlCommand("SELECT Projects.Projects_Id, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto FROM Projects " +
                                            " INNER JOIN ForcedAccounts ON Projects.Projects_id = ForcedAccounts.Projects_id " +
                                            " WHERE ForcedAccounts.Persons_id=" + Session["persons_id"] +
                                            " AND active = 'true' ORDER BY Projects.ProjectCode", conn);

             using (SqlDataReader dr = cmd.ExecuteReader())
             {

                 DDLProgetto.DataSource = dr;
                 DDLProgetto.Items.Clear();
                 //          DDLProgetto.Items.Add(new ListItem("--seleziona progetto--", "0"));
                 DDLProgetto.DataTextField = "iProgetto";
                 DDLProgetto.DataValueField = "Projects_Id";
                 DDLProgetto.DataBind();
             }

             // se in creazione imposta il default di progetto 
             if (Session["ProjectCodeDefault"] != null)
                 DDLProgetto.SelectedValue = Session["ProjectCodeDefault"].ToString();

             conn.Close();

         }    


         //   ****************************************
         //   ChangeScreen
         //   ****************************************
         protected void  ChangeScreen () {

             // se TR chiuso spegne il bottone e mette la scrita
             if (bTRChiuso) 
             { 
                 btChiudiTR.Visible= false; lbTRChiuso.Visible = true;
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
         protected void  SetVariables () {

             String[] aDaysName = new String[7] { "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato", "Domenica" };

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
                 Session["month"] = Request.QueryString["month"];

             if (Session["year"] == null)
                 Session["year"] = DateTime.Now.Year;

             if (Session["month"] == null)
                 Session["month"] = DateTime.Now.Month;

             // se sulla vista spese ed è forzato un refresh bufferizza l'elenco delle ricevute
             if ((string)Session["type"] != "hours" && !String.IsNullOrEmpty((string)Session["RefreshRicevuteBuffer"]))
                 Session["RicevuteBuffer"] = CaricaBufferRicevute();   

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
             string sMeseFormattato = Session["month"].ToString().Length == 1 ? "0" +  Session["month"].ToString() : Session["month"].ToString();

             // legge i file nel mese / utente
             string[] filePaths = TrovaRicevuteLocale(-1, Session["username"].ToString(), (string)(Session["year"].ToString() + sMeseFormattato + "01"));

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

        // riceve in input id spesa, nome user, data spesa (YYYYMMGG) e restutuisce array con nome file
        // Se id spesa = -1 allora estrae tutte le spese del mese per l'utente
        public static string[] TrovaRicevuteLocale(int iId, string sUserName, string sData)
        {

            string[] filePaths = null;

            try
            {
                // costruisci il pach di ricerca: public + anno + mese + nome persona 
                string TargetLocation = HttpContext.Current.Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + sData.Substring(0, 4) + "\\" + sData.Substring(4, 2) + "\\" + sUserName + "\\";
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

        //   **********
        //   Trova Ore
        //   **********
        protected void  FindHours (int intDayNumber) {
        
            string strTooltip = "";
            string strDate;
            float iOre = 0;

            if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
            {                
                Response.Write("<td class=hours >");
	            strDate = intDayNumber.ToString() + "/" + Session["month"] + "/" + Session["year"];
                // look if there are entry for the date
                Database.OpenConnection();

                using (SqlDataReader rdr = Database.GetReader("SELECT Projects.ProjectCode, hours.hours, hours.Hours_id, Projects.name, hours.date, hours.comment, Activity.ActivityCode + ' ' + Activity.Name as ActivityName, CreatedBy, CreationDate "+ 
                                               " FROM Hours INNER JOIN projects ON hours.projects_id=projects.projects_id LEFT OUTER JOIN Activity ON Activity.Activity_id = Hours.Activity_id " +
                                               " WHERE hours.Persons_id=" + Session["Persons_id"] + " AND hours.date=" + ASPcompatility.FormatDateDb(strDate, false), this.Page)) 
                {
                    if (rdr != null)
                    {

                        Response.Write("<table>");  // si usa tabelle per problemi di formattazione

                        while (rdr.Read())
                        {
                            iOre = Convert.ToSingle(rdr["hours"]);
                            strTooltip = "Data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["date"]) +
                                         "<br>Progetto:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + rdr["name"] +
                                         "<br>Attività:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + rdr["ActivityName"] +
                                         "<br>Ore:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + iOre.ToString("G") +
                                         "<br>Creato da:&nbsp;&nbsp;&nbsp;" + rdr["CreatedBy"] +
                                          "<br>Creato il:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["CreationDate"]) +
                                         "<br><br>" + rdr["comment"];

                            // l'id viene messo uguale al numero record per essere poi usato nel drag&drop
                            Response.Write("<tr><td width=100%><a id=" + rdr["Hours_id"] + " title=' " + strTooltip + "' class=hours href=input-ore.aspx?action=fetch&hours_id=" + rdr["Hours_id"] + " >" + rdr["ProjectCode"] + "</a> : " + iOre.ToString("G") + " " + GetLocalResourceObject("oreUOM") + "</td>");

                            if ( Convert.ToBoolean(Session["InputScreenChangeMode"]) )
                                Response.Write("<td><a href=input.aspx?action=delete&record_id=" + rdr["Hours_id"] + "><img style='padding-right:5px' src=images/icons/16x16/trash.gif width=16 height=14 border=0></a></td></tr>");
                            else
                                Response.Write("</tr>");

                        } // endwhile
                    }
                } // using
                Database.CloseConnection();

                Response.Write("</table></td>");
            }
            else
                Response.Write("<td>&nbsp;</td>");    
        }
    
        //   **********
        //   Trova Spese
        //   **********
        protected void  FindExpenses (int intDayNumber) {
        
            string strTooltip = "";  
            string strDate;
            string strSelect="";
            float fSpese = 0;
            string strIconaRicevuta;

            // recupera il buffer con le spese che hanno ricevuta
            List<int> iRicevuteBuffer = (List<int>)Session["RicevuteBuffer"];

            if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])))
            {                
                Response.Write("<td >");
	            strDate = intDayNumber.ToString() + "/" + Session["month"] + "/" + Session["year"];
                
                // Estrae i record di spesa o bonus a seconda del tipo scheda
                if ((string)Session["type"] == "expenses")
                    strSelect = "SELECT Projects.ProjectCode, expenses.amount, expenses.expenses_id, ExpenseType.ExpenseCode, ExpenseType.UnitOfMeasure, Projects.Name, ExpenseType.Name as NomeSpesa, expenses.date, expenses.comment, expenses.TipoBonus_id, CancelFlag, InvoiceFlag, CreditCardPayed, CompanyPayed FROM (expenses INNER JOIN projects ON expenses.projects_id=projects.projects_id) INNER JOIN ExpenseType ON  ExpenseType.ExpenseType_id=Expenses.ExpenseType_id WHERE expenses.Persons_id=" + Session["Persons_id"] + " AND expenses.TipoBonus_id = 0 AND expenses.date=" + ASPcompatility.FormatDateDb(strDate, false);                    
                else if ((string)Session["type"] == "bonus")
                    strSelect = "SELECT Projects.ProjectCode, expenses.amount, expenses.expenses_id, ExpenseType.ExpenseCode, ExpenseType.UnitOfMeasure, Projects.Name, ExpenseType.Name as NomeSpesa, expenses.date, expenses.comment, expenses.TipoBonus_id, CancelFlag, InvoiceFlag, CreditCardPayed, CompanyPayed FROM (expenses INNER JOIN projects ON expenses.projects_id=projects.projects_id) INNER JOIN ExpenseType ON  ExpenseType.ExpenseType_id=Expenses.ExpenseType_id WHERE expenses.Persons_id=" + Session["Persons_id"] + " AND expenses.TipoBonus_id <> 0 AND expenses.date=" + ASPcompatility.FormatDateDb(strDate, false);

                using (SqlDataReader rdr = Database.GetReader(strSelect, this.Page))
                {
                    if (rdr != null)
                    
                    		Response.Write("<table>");  // si usa tabelle per problemi di formattazione
                    
                        while (rdr.Read())
                        {
                            fSpese = Convert.ToSingle(rdr["amount"]);
                            string sFlag = "";
                            sFlag = Convert.ToBoolean(rdr["CancelFlag"]) ? " STO " : "";
                            sFlag = Convert.ToBoolean(rdr["CreditCardPayed"]) ? sFlag + " CC " : sFlag;
                            sFlag = Convert.ToBoolean(rdr["CompanyPayed"]) ? sFlag + " PA " : sFlag;
                            sFlag = Convert.ToBoolean(rdr["InvoiceFlag"]) ? sFlag + " FAT " : sFlag;

                            strTooltip = "Data:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + String.Format("{0:dd/MM/yyyy}", rdr["date"]) + 
                                         "<br>Progetto:&nbsp;&nbsp;" + rdr["Name"] + 
                                         "<br>Spesa:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + rdr["NomeSpesa"] + 
                                         "<br>Importo:&nbsp;&nbsp;&nbsp;" + fSpese.ToString("G") + " " + rdr["UnitOfMeasure"] + 
                                         "<br>Flag:&nbsp;&nbsp;&nbsp;"  + 
                                         sFlag + 
                                         "<br><br>" + rdr["comment"];

                            // se la spesa ha una ricevuta stampa un icona, altrimenti lascia blank
                            if (iRicevuteBuffer.Contains(Convert.ToInt32(rdr["expenses_id"])))
                                strIconaRicevuta = " <img src='/timereport/images/icons/other/paperclip.png' alt='giustificativi' height='12' width='12'> ";
                            else
                                strIconaRicevuta = "";

                            // l'id viene messo uguale al numero record per essere poi usato nel drag&drop
                            // l'id sull'elemento TR serve per cancellare la riga a seguito chiamata WS, vedi function CancellaSpesa 
                            Response.Write("<tr id=TR" + rdr["expenses_id"] + "><td width=100%><a id=" + rdr["expenses_id"] + " title=' " + strTooltip + "' class=hours href=input-spese.aspx?action=fetch&expenses_id=" + rdr["expenses_id"] + " >" + strIconaRicevuta + rdr["ProjectCode"] + ":" + rdr["ExpenseCode"] + "</a> : " + fSpese.ToString("G") + " " + rdr["UnitOfMeasure"] + "</td>");

                            if (Convert.ToBoolean(Session["InputScreenChangeMode"]) )
                              //  OLD chiamata a input.asp >> Response.Write("<td><a href=input.aspx?action=delete&record_id=" + rdr["expenses_id"] + "><img style='padding-right:5px' src=images/icons/16x16/trash.gif width=16 height=14 border=0></a></td></tr>");
							  //  Chiamata a WS per cancellazione spese e ricevute
                                Response.Write("<td><a href=# onclick='CancellaSpesa(" + rdr["expenses_id"] + ", \""  + ((DateTime)rdr["date"]).ToString("yyyyMMdd") + "\")'><img style='padding-right:5px' src=images/icons/16x16/trash.gif width=16 height=14 border=0></a></td></tr>");     
                            else
                              Response.Write("</tr>");
                            
                        } // endwhile
                }  // using
                Response.Write("</table></td>");
            }
            else
                Response.Write("<td>&nbsp;</td>");    

        }             
          // **********
        //   Recupera Id progetto
        //   **********
        protected string  GetProject (string sDate) {

            using (SqlDataReader rdr = Database.GetReader("SELECT Projects_id FROM hours WHERE persons_id=" + Session["persons_id"] + " AND Date = " + ASPcompatility.FormatDateDb(sDate, false), this.Page))
            {
                if (rdr == null)
                    return "";

                while (rdr.Read())
                    return rdr["Projects_id"].ToString();
            }
            return "";
        }

 		//	----------------------------------------------------
        protected void  OutputColumn(int intDayNumber) {
	
            string strDate=""; 
            string strProject;
            int intDayWeek=0;
            Boolean bHoliday=false;

            if (intDayNumber <= ASPcompatility.DaysInMonth(Convert.ToInt16(Session["month"]), Convert.ToInt16(Session["year"])) )
            {  
            
                strDate = intDayNumber.ToString() + "/" + Session["month"] + "/" + Session["year"];
                intDayWeek = (int)Convert.ToDateTime(strDate).DayOfWeek;
                // look if it's an holiday	
    	        //if (Database.RecordEsiste("SELECT * FROM Holiday WHERE holiday_date=" + ASPcompatility.FormatDateDb(strDate ))) {
                if (MyConstants.DTHoliday.Rows.Contains(strDate)) {
                    Response.Write("<td class=noWorkDays title=" + strDate + " >");   
                       bHoliday = true; }
                else if(intDayWeek==6 || intDayWeek==0) {
                    Response.Write("<td class=noWorkDays title=" + strDate + " >");
                       bHoliday = true; }
                else {
                    Response.Write("<td class=WorkDays title=" + strDate + " >");
                       bHoliday = false; 
                }

            CultureInfo CurrCulture = CultureInfo.CreateSpecificCulture(Session["lingua"].ToString());
            DateTimeFormatInfo mfi = CurrCulture.DateTimeFormat;
            Response.Write(mfi.DayNames[intDayWeek] + " " + intDayNumber );  
            }
            else
                Response.Write( "&nbsp;");

            // se cutoff non è passato si possono creare nuove entries

            if (strDate != "")
                if (Convert.ToBoolean(Session["InputScreenChangeMode"]) )
            {

                switch ((string)Session["type"])
                {
                    case "hours":  // CALENDARIO DATE
                        Response.Write("<a href=input-ore.aspx?action=new&date=" + strDate + "><img align=right src=images/icons/16x16/nuovo.gif width=16 height=16 border=0></a>");
                        break;

                    case "expenses": // CALENDARIO SPESE
                        Response.Write("<a href=input-spese.aspx?action=new&date=" + strDate + "><img align=right src=images/icons/16x16/nuovo.gif width=16 height=16 border=0></a>"); 
                        break;

                    case "bonus":  // CALENDARIO SPECIALI
                        // Stampa ticket solo se non già presente per persona/data un ticket o un buono pasto
                        if (!Database.RecordEsiste("SELECT * FROM Expenses WHERE Date=" + ASPcompatility.FormatDateDb(strDate,false) + " AND Persons_id = " + Session["Persons_id"] + " AND TipoBonus_id <> '' ", this.Page) & !bHoliday)
                        {
                            Response.Write("<a href=input.aspx?action=ticket&date=" + strDate + "><img  align=right src=images/icons/16x16/restaurant.png  border=0></a>");

                            strProject = GetProject(strDate);

                            // il titolo del link viene impostato uguale alla data per essere poi impostato da javascript nella finestra modale
                            Response.Write("<a title=" + strDate + ";" + strProject + " href=#dialog name=modal><img align=right src=images/icons/16x16/travel.png border=0></a>");
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
                    ASPcompatility.FormatDateDb(Request.Form["refDate"],false) + " ," +
                    "'" + Request.Form["DDLProgetto"] + "' ," +    // da dropdown
                    "'" + Session["persons_id"] + "' ," +
                    "'" + Request.Form["DDLBonus"] + "' ," +     // da dropdown
                    "'1' ," +
                    "'" + Request.Form["SedeViaggio"] + "' , " +
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
            Session["TipoBonus"] =  Request.Form["DDLBonus"];      

            DDLProgetto.SelectedValue = Request.Form["DDLProgetto"];
            DDLBonus.SelectedValue = Request.Form["DDLBonus"];     
        }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}

