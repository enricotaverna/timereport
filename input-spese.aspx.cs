using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;  
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Threading;

public partial class input_spese : System.Web.UI.Page
{
	// attivata MARS .
	private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);

	public string lProject_id, lExpenseType_id;
	public int lTipoBonus_id;
	public string lDataSpesa, lExpense_id;

	protected void Page_Load(object sender, EventArgs e)
	{

		Auth.CheckPermission("DATI", "SPESE");

		// Evidenzia campi form in errore
		Page.ClientScript.RegisterOnSubmitStatement(this.GetType(), "val", "fnOnUpdateValidators();");

		//      Modo di default è insert, se richiamata con id va in change / display
		if (IsPostBack)
		{
			if (Request.QueryString["action"].ToString() != "new") 
			{ 
				// recupera record per settare default sulle DDL al momento del Bind
				Get_record(Request.QueryString["expenses_id"].ToString());   
				Trova_ricevute(Request.QueryString["expenses_id"]);
			}

			return;
		}

		// di default il box revicevute non è visibile
		BoxRicevute.Visible = false;

		//      in caso di update recupera il valore del progetto e attività
		if (Request.QueryString["expenses_id"] != null)
		{
			// recupera record per settare default sulle DDL al momento del Bind
			Get_record(Request.QueryString["expenses_id"].ToString());

			//              disabilita form in caso di cutoff
			Label LBdate = (Label)FVSpese.FindControl("LBdate");

			// spegne/accende capo amount in base al valore di TipoBpnus_id
			TextBox TBAmount = (TextBox)FVSpese.FindControl("TBAmount");
			DropDownList DDLprogetto = (DropDownList)FVSpese.FindControl("DDLprogetto");
			DropDownList DDLTipoSpesa = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");
			CheckBox CBInvoice = (CheckBox)FVSpese.FindControl("CBInvoice");
			CheckBox CBCompanyPayed = (CheckBox)FVSpese.FindControl("CBCompanyPayed");
			Label LBInvoice = (Label)FVSpese.FindControl("LBInvoice");
			Label LBCompanyPayed = (Label)FVSpese.FindControl("LBCompanyPayed");
  
			if (lTipoBonus_id > 0) {
				TBAmount.Enabled = false;
				DDLprogetto.Enabled = false;
				DDLTipoSpesa.Enabled = false;
				CBInvoice.Visible = false;
				CBCompanyPayed.Visible = false;
				LBInvoice.Visible = false;
				LBCompanyPayed.Visible = false;
				
				// spegne carta credito su spesa bonus
				SpegniCartaCredito();
			}

			if (Convert.ToDateTime(LBdate.Text) < Convert.ToDateTime(Session["CutoffDate"]))
				FVSpese.ChangeMode(FormViewMode.ReadOnly);
			else
				FVSpese.ChangeMode(FormViewMode.Edit);

			// recupera immagini Ricevute e visualizza box se ce ne sono
			Trova_ricevute(Request.QueryString["expenses_id"]);

		}
		else // insert
		{
			FVSpese.ChangeMode(FormViewMode.Insert);
			
			Label LBdate = (Label)FVSpese.FindControl("LBdate");
			LBdate.Text = Request.QueryString["date"];

			Label LBperson = (Label)FVSpese.FindControl("LBperson");
			LBperson.Text = (string)Session["UserName"];

			TextBox TBAmount = (TextBox)FVSpese.FindControl("TBAmount");
			if (Convert.ToInt16(Session["TipoBonus_IdDefault"]) > 0) {
				TBAmount.Enabled = false;
				TBAmount.Text = "1"; }
			else {
				TBAmount.Enabled = true;
				TBAmount.Text = "";}
		}

	}

	// SPEGNE IL CONTROLLO CARTA CREDITO - NON PIU' NECESSARIO
	protected void SpegniCartaCredito()
	{
		Label LBCBCreditCard = (Label)FVSpese.FindControl("LBCBCreditCard");
		CheckBox CBCreditCard = (CheckBox)FVSpese.FindControl("CBCreditCard");

		CBCreditCard.Visible = false;
		LBCBCreditCard.Visible = false;
	}

	// *** TROVA RICEVUTE ****
	// Legge la directory nel formato ANNO/MESE/NOTE UTENTE e elenca tutte le ricevute il cui nome file
	// inizia con l'Id della spesa visualizzate 
	protected void Trova_ricevute(string strExpenses_Id)
	{

		// rende visibile il box
		BoxRicevute.Visible = true;

		// se display rende non visibile il bottone
		if (FVSpese.CurrentMode == FormViewMode.ReadOnly)
			divBottoni.Visible = false;

		// restituisce array con nome dei file o null se non si sono ricevute
		string[] filePaths = TrovaRicevuteLocale(Convert.ToInt32(strExpenses_Id), Session["UserName"].ToString().Trim(), lDataSpesa);
		
		// Se non esistono immagini torna indietro
		if (filePaths==null || filePaths.Length == 0)
			return;

		// loop per stampare immagini
		string stWebPath = ConfigurationSettings.AppSettings["PATH_RICEVUTE"] + lDataSpesa.Substring(0, 4) + "/" + lDataSpesa.Substring(4, 2) + "/" + Session["UserName"].ToString().Trim() + "/";
		string stFile="";
		
		for (int i=0;i < filePaths.Length; i++) {
			stFile = stWebPath + Path.GetFileName(filePaths[i]);

			// aggiunge riga    
			HtmlTableRow row = new HtmlTableRow();
			row.ID = stFile;

			// aggiunge le tre celle : immagine + tasto download + tasto cancella
			HtmlTableCell cell1 = new HtmlTableCell();
			HtmlTableCell cell2 = new HtmlTableCell();
			HtmlTableCell cell3 = new HtmlTableCell();
			
			// se PDF o TIFF mette icona corrispondente
			string stFileimg;
			if (filePaths[i].EndsWith("pdf"))
				stFileimg = "/timereport/images/icons/other/pdf.png";
			else
				stFileimg = stFile;

			cell1.InnerHtml = "<a  href='" + stFile + "' download='" + Path.GetFileName(filePaths[i]) + "'><img height=45 src='" + stFileimg + "' /></a>";
			cell1.Width = "50px";
			cell1.Align = "center";
			row.Cells.Add(cell1);

			cell2.InnerHtml = "<a href='" + stFile + "' download='" + Path.GetFileName(filePaths[i]) + "'><img height=20 src='/timereport/images/icons/other/download-50.png' /></a>";
			cell2.Width = "40px";
			row.Cells.Add(cell2);

			cell3.InnerHtml = "<a href='#' onclick='cancella_ricevuta(\"" + stFile + "\");'><img height=20 src='/timereport/images/icons/other/empty_trash-50.png' /></a>";
			cell3.Width = "40px";
			row.Cells.Add(cell3);

			TabellaRicevute.Rows.Add(row);

		} //  next 

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

	protected void Get_record(string strExpenses_Id)
	{

		SqlCommand cmd = new SqlCommand("SELECT Expenses.Expenses_Id, Expenses.Projects_Id, Expenses.ExpenseType_id, Expenses.TipoBonus_id, Expenses.Date FROM Expenses where expenses_id = " + strExpenses_Id, conn);

		conn.Open();

		using (SqlDataReader dr = cmd.ExecuteReader()) 
		{         
			dr.Read();

			lProject_id = dr["Projects_id"].ToString(); // projects_id - usata per dare default a DDL
			lExpenseType_id = dr["ExpenseType_id"].ToString(); // ExpenseType_id - - usata per dare default a DDL
			lTipoBonus_id = Convert.ToInt16(dr["TipoBonus_id"].ToString());  // usata per dare gestire stato/valore campo Amount
			lExpense_id = dr["Expenses_Id"].ToString();
			lDataSpesa = ((DateTime)dr["date"]).ToString("yyyyMMdd");
		}

		conn.Close();
	}

	protected void Bind_DDLprogetto()
	{

		DropDownList ddlProject;

		conn.Open();

		SqlCommand cmd;

		// imposta selezione progetti in base all'utente

		if (Convert.ToInt32(Session["ForcedAccount"]) != 1)
			cmd = new SqlCommand("SELECT Projects_Id, ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto FROM Projects WHERE active = 'true' ORDER BY ProjectCode", conn);
		else
			cmd = new SqlCommand("SELECT DISTINCT Projects.Projects_Id, Projects.ProjectCode + ' ' + left(Projects.Name,20) AS iProgetto, ProjectCode FROM Projects " +
									   " INNER JOIN ForcedAccounts ON Projects.Projects_id = ForcedAccounts.Projects_id " +
									   " WHERE ( ForcedAccounts.Persons_id=" + Session["persons_id"] + " OR Projects.Always_available = 'true')" +
									   " AND active = 'true' ORDER BY Projects.ProjectCode", conn);

		using (SqlDataReader dr = cmd.ExecuteReader()) {
		ddlProject = (DropDownList)FVSpese.FindControl("DDLprogetto");

		ddlProject.DataSource = dr;
		ddlProject.Items.Clear();
		ddlProject.DataTextField = "iProgetto";
		ddlProject.DataValueField = "Projects_Id";
		ddlProject.DataBind();
		
		if (lProject_id != "")
			ddlProject.SelectedValue = lProject_id;

		// se in creazione imposta il default di progetto 
		if (FVSpese.CurrentMode == FormViewMode.Insert)
			ddlProject.SelectedValue = (string)Session["ProjectCodeDefault"];
		}

		conn.Close();
	}

	protected void Bind_DDLTipoSpesa()
	{

		string sTipoBonus_sel;

		DropDownList ddlTipoSpesa;

		conn.Open();

		SqlCommand cmd;

		// 08/2014 se viene richiamato da pagina bonus cambia il flag per il biding
		if (lTipoBonus_id > 0) 
			sTipoBonus_sel = "";
		else
			sTipoBonus_sel = " AND TipoBonus_Id = 0 ";

		// imposta selezione progetti in base all'utente

		if (Convert.ToInt32(Session["ForcedAccount"]) != 1)
			cmd = new SqlCommand("SELECT ExpenseType_Id, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione FROM ExpenseType WHERE active = 'true' AND TipoBonus_Id = 0 ORDER BY ExpenseCode", conn);
		else
			cmd = new SqlCommand("SELECT ExpenseType.ExpenseType_Id, ExpenseCode + ' ' + left(ExpenseType.Name,20) AS descrizione  FROM ExpenseType " +
									   " INNER JOIN ForcedExpensesPers ON ExpenseType.ExpenseType_id = ForcedExpensesPers.ExpenseType_id " +
									   " WHERE ForcedExpensesPers.Persons_id=" + Session["persons_id"] +
									   " AND active = 'true' " + sTipoBonus_sel + " ORDER BY ExpenseType.ExpenseCode", conn);

		using (SqlDataReader dr = cmd.ExecuteReader()) 
		{ 
			ddlTipoSpesa = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");

			ddlTipoSpesa.DataSource = dr;
			ddlTipoSpesa.Items.Clear();
			ddlTipoSpesa.DataTextField = "descrizione";
			ddlTipoSpesa.DataValueField = "ExpenseType_Id";
			ddlTipoSpesa.DataBind();

			if (lExpenseType_id != "")
				ddlTipoSpesa.SelectedValue = lExpenseType_id;

			// se in creazione imposta il default di progetto 
			if (FVSpese.CurrentMode == FormViewMode.Insert)
				ddlTipoSpesa.SelectedValue = (string)Session["ExpenseTypeDefault"];
		}

		conn.Close();
	}

	protected void DSSpese_Insert_Update(object sender, SqlDataSourceCommandEventArgs e)
	{
		//      Chiamato in aggiornamento e inserimento record rende negativo il valore delle ore
		//      nel caso sia valorizzato il flag storno         
		double iCalc = 0;

		CheckBox CBcancel = (CheckBox)FVSpese.FindControl("CBcancel");

		if (CBcancel.Checked)
		{
			iCalc = Convert.ToDouble(e.Command.Parameters["@Amount"].Value) * (-1);
			e.Command.Parameters["@Amount"].Value = iCalc;
		}
		else
		{
			e.Command.Parameters["@Amount"].Value = Convert.ToDouble(e.Command.Parameters["@Amount"].Value);
		}

		//      Forza i valori da passare alla select di insert. essendo le dropdown in
		//      dipendenza non si riesce a farlo tramite un normale bind del controllo

		DropDownList ddlList = (DropDownList)FVSpese.FindControl("DDLprogetto");
		e.Command.Parameters["@Projects_id"].Value = ddlList.SelectedValue;

		DropDownList ddlList1 = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");
		if (ddlList1.SelectedValue != null)
			e.Command.Parameters["@ExpenseType_id"].Value = ddlList1.SelectedValue;

		// Valorizza tipo Bonus se il tipo spesa è di tipo bonus
		Database.OpenConnection();

		using (SqlDataReader rdr = Database.GetReader("Select TipoBonus_id from ExpenseType where ExpenseType_id=" + ddlList1.SelectedValue, this.Page)) 
		{ 
		
			if (rdr != null)  {
			rdr.Read();
			e.Command.Parameters["@TipoBonus_id"].Value = rdr["TipoBonus_id"];
			}

			// salva default per select list
			Session["ProjectCodeDefault"] = ddlList.SelectedValue;
			Session["ExpenseTypeDefault"] = ddlList1.SelectedValue;
			Session["TipoBonus_IdDefault"] = rdr["TipoBonus_id"]; // usato per spegnere/accendere il campo in insert
		}

		Database.CloseConnection();

		// solo insert
		if (FVSpese.CurrentMode == FormViewMode.Insert)
		{
			e.Command.Parameters["@persons_id"].Value = Session["persons_id"];
			Label LBdate = (Label)FVSpese.FindControl("LBdate");
			e.Command.Parameters["@Date"].Value = Convert.ToDateTime(LBdate.Text);
			// Audit
			e.Command.Parameters["@CreatedBy"].Value = Session["UserId"];
			e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
		}

		// if in change
		if (FVSpese.CurrentMode == FormViewMode.Edit)
		{
			// Audit
			e.Command.Parameters["@LastModifiedBy"].Value = Session["UserId"];
			e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
		}
	}

	protected void FVSpese_modechanging(object sender, FormViewModeEventArgs e)
	{
		//      se premuto tasto cancel torna indietro
		if (e.CancelingEdit)
			Response.Redirect("input.aspx");
	}

	protected void FVSpese_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
	{
		Response.Redirect("input.aspx");
	}

	protected void FVSpese_DataBound(object sender, EventArgs e)
	{

		// Attiva bottone ricevute solo per beta tester
		//if ( !Convert.ToBoolean(Session["BetaTester"]) && FVSpese.CurrentMode == FormViewMode.Insert)
		//    ((Button)FVSpese.FindControl("RicevuteButton")).Visible = false;

		//      formattta il campo numerico delle spese, nel DB le spese stornate sono negative
		if (Request.QueryString["action"] == "fetch")
		{
			TextBox TBSpese = (TextBox)FVSpese.FindControl("TBAmount");
			double SpeseValue = Math.Abs(Convert.ToDouble(TBSpese.Text));
			TBSpese.Text = SpeseValue.ToString();
		}

		if (Request.QueryString["expenses_id"] != null)
		{
			//              Valorizza progetto e attività
			Bind_DDLprogetto();
			Bind_DDLTipoSpesa();

		}
		else // insert
		{
			Bind_DDLprogetto();
			Bind_DDLTipoSpesa();
		}
			
		//      se livello autorizzativo è inferiore a 4 spegne il campo competenza
		if (!Auth.ReturnPermission("ADMIN", "CUTOFF"))
		{
			Label LBAccountingDate = (Label)FVSpese.FindControl("LBAccountingDate");
			TextBox TBAccountingDate = (TextBox)FVSpese.FindControl("TBAccountingDate");
			Label LBAccountingDateDisplay = (Label)FVSpese.FindControl("LBAccountingDateDisplay");

			// se display
			LBAccountingDate.Visible = false;

			if (TBAccountingDate != null)
				TBAccountingDate.Visible = false;

			if (LBAccountingDateDisplay != null)
				LBAccountingDateDisplay.Visible = false;
		}

	}

	protected void DDLTipoSpesa_SelectedIndexChanged(object sender, EventArgs e)
	{
		TextBox TBAmount = (TextBox)FVSpese.FindControl("TBAmount");
		DropDownList DDlspesa = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");

		// se la spesa è di tipo bonus mette 1 di default alla quantità e spegne il campo
		// Valorizza tipo Bonus se il tipo spesa è di tipo bonus
		Database.OpenConnection();

		using (SqlDataReader rdr = Database.GetReader("Select TipoBonus_id from ExpenseType where ExpenseType_id=" + DDlspesa.SelectedValue, this.Page)) 
		{
			if (rdr == null)
				return;                

			rdr.Read();
		
			if (Convert.ToInt16(rdr["TipoBonus_id"]) != 0)
			{
				TBAmount.Text = "1";
				TBAmount.Enabled = false;
			}
			else if (!TBAmount.Enabled)  {
				TBAmount.Text = "";
				TBAmount.Enabled = true;
			}
		}

		Database.CloseConnection();
	}

	// recupera la chiave primaria inserita e richiama la pagina in modifica
	protected void DSSpese_Inserted(object sender, SqlDataSourceStatusEventArgs e)
	{
		int newIdentity;

		// se aggiornamento ha avuto luogo recupera l'ultimo Id della spesa inserita e richiama la pagina in aggiornamento per
		// consentire il caricamento delle spese
		if (e.Exception == null)
		{

		// se premuto il tasto "Ricevute" rimanda sulla stessa pagina aprendola in modifica in modo da poter caricare le rivevute   
			if (!String.IsNullOrEmpty(Request.Form["FVSpese$RicevuteButton"])) 
			{ 
			using (SqlConnection c = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
				{
				c.Open();
				SqlCommand cmd = new SqlCommand("SELECT MAX(Expenses_id) from Expenses where Persons_Id=" + e.Command.Parameters["@Persons_id"].Value, c);
				newIdentity = (int)cmd.ExecuteScalar();
				}
				 Response.Redirect("input-spese.aspx?action=fetch&expenses_id=" + newIdentity.ToString() );
			}
			else
				Response.Redirect("input.aspx");
		}
		else
			Response.Redirect("input.aspx");
	} // DSSpese_Inserted

	protected void CV_DDLprogetto_ServerValidate(object source, ServerValidateEventArgs args)
	{
		ValidationClass c = new ValidationClass();
		DropDownList DDLtoValidate = (DropDownList)FVSpese.FindControl("DDLprogetto");

		Boolean bBloccoCaricoSpese = false;
		string sMessaggioDiErrore = "";

		// Legge il flag di spesa bloccata su anagrafica progetto
		using (SqlDataReader rdr = Database.GetReader("Select BloccoCaricoSpese from Projects where Projects_Id = " + DDLtoValidate.SelectedValue, this.Page))
		{
			if (rdr != null)
				while (rdr.Read())
				{
					bBloccoCaricoSpese = (rdr["BloccoCaricoSpese"] == DBNull.Value) ? false : Convert.ToBoolean(rdr["BloccoCaricoSpese"]);
				} // endwhile
		}  // using

		if (bBloccoCaricoSpese) 
			{ 
			// errore
			args.IsValid = false;

			//      cambia colore del campo in errore
			c.SetErrorOnField(args.IsValid, FVSpese, "DDLprogetto");
			}
	}

	protected void CV_TBComment_ServerValidate(object source, ServerValidateEventArgs args)
	{
		ValidationClass c = new ValidationClass();
		TextBox TBtoValidate = (TextBox)FVSpese.FindControl("TBComment");
		DropDownList DDLTipoSpesa = (DropDownList)FVSpese.FindControl("DDLTipoSpesa");
		CustomValidator CV_TBComment = (CustomValidator)FVSpese.FindControl("CV_TBComment");
	   
		Boolean bTestoObbligatorio = false;
		string sMessaggioDiErrore = "";

		// Legge il flag di commento obbligatorio su tipo spesa
		using (SqlDataReader rdr = Database.GetReader("Select TestoObbligatorio, MessaggioDiErrore from ExpenseType where ExpenseType_Id = " + DDLTipoSpesa.SelectedValue, this.Page))
		{
			if (rdr != null)
				while (rdr.Read())
				{
					bTestoObbligatorio =  ( rdr["TestoObbligatorio"] == DBNull.Value  ) ? false : Convert.ToBoolean(rdr["TestoObbligatorio"]);
					sMessaggioDiErrore = rdr["MessaggioDiErrore"].ToString();
				} // endwhile
		}  // using

		if (TBtoValidate.Text.Trim().Length == 0 && bTestoObbligatorio) 
			{ 
			args.IsValid = false;

			// imposta il messaggio di errore letto dal tipo spesa
			CV_TBComment.ErrorMessage = sMessaggioDiErrore;

			//      cambia colore del campo in errore
			c.SetErrorOnField(args.IsValid, FVSpese, "TBComment");
			}
	}

	protected override void InitializeCulture()
	{
		// Imposta la lingua della pagina
		Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
	}

	protected void DDLprogetto_SelectedIndexChanged(object sender, EventArgs e)
	{

        Label LBdate = (Label)FVSpese.FindControl("LBdate");

        DropDownList DDLprogetto = (DropDownList)FVSpese.FindControl("DDLprogetto");

        if ( !Database.RecordEsiste("Select hours_id , projects_id from Hours where projects_id= " + DDLprogetto.SelectedValue + " AND date = " + ASPcompatility.FormatDateDb(LBdate.Text), this.Page) )
            // non ci sono ore caricate sul progetto, cerca se ci sono altri progetti
            if (!Database.RecordEsiste("Select hours_id , projects_id from Hours where date = " + ASPcompatility.FormatDateDb(LBdate.Text), this.Page))
                ClientScript.RegisterStartupScript(Page.GetType(), "Popup", "ShowPopup('Su questo giorno non esistono progetti caricati');", true);
            else
                ClientScript.RegisterStartupScript(Page.GetType(), "Popup", "ShowPopup('Su questo giorno sono caricati altri progetti');", true);
          
    }
}
