using Amazon.EC2.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;
using Xceed.Document.NET;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    // Variabili per i totali del Footer
    private decimal TotalRevenue = 0.00M;

    // Date correnti del progetto - usate per filtrare GridView1 (Tab Monthly Fee)
    private DateTime? _currentProjectDataInizio = null;
    private DateTime? _currentProjectDataFine = null;
    private decimal TotalCost = 0.00M;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // =========================================================
        // CARICA SUBITO LE DATE CORRENTI DEL PROGETTO DAL DB
        // (necessarie per filtrare GridView1 in RowDataBound)
        // =========================================================
        string projectCodeForDates = Request.QueryString["ProjectCode"] ?? Request.QueryString["Projectcode"];
        if (!string.IsNullOrEmpty(projectCodeForDates))
        {
            try
            {
                using (SqlConnection connDates = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
                {
                    connDates.Open();
                    using (SqlCommand cmdDates = new SqlCommand("SELECT DataInizio, DataFine FROM Projects WHERE ProjectCode = @pc", connDates))
                    {
                        cmdDates.Parameters.AddWithValue("@pc", projectCodeForDates);
                        using (SqlDataReader rdr = cmdDates.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                if (rdr["DataInizio"] != DBNull.Value)
                                    _currentProjectDataInizio = Convert.ToDateTime(rdr["DataInizio"]);
                                if (rdr["DataFine"] != DBNull.Value)
                                    _currentProjectDataFine = Convert.ToDateTime(rdr["DataFine"]);
                            }
                        }
                    }
                }
            }
            catch
            {
                // In caso di errore, le date restano null e il filtro non viene applicato
            }
        }
        // =========================================================

        if (!IsPostBack)
        {
            // Mostra messaggio di successo se arriva da un rinnovo
            if (Request.QueryString["success"] == "1")
            {
                string count = Request.QueryString["count"] ?? "0";
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaSuccessMsg",
                    "alert('Progetto rinnovato con successo! Generati " + count + " nuovi Monthly Fee.');", true);
            }

            if (Request.QueryString["Projectcode"] != null)
            {
                FVProgetto.ChangeMode(FormViewMode.Edit);
                FVProgetto.DefaultMode = FormViewMode.Edit;

                // INIZIO CORREZIONE: Logica Apertura Tab con Ritardo JS
                string tabParam = Request.QueryString["tab"];
                if (tabParam != null)
                {
                    // Dichiarazione C# compatibile
                    int tabIndex = 0;

                    if (int.TryParse(tabParam, out tabIndex))
                    {
                        // NUOVO SCRIPT: Aggiunto setTimeout per risolvere il problema di layout.
                        // Il ritardo (100ms) garantisce che jQuery UI Tabs abbia finito di inizializzare l'HTML.
                        string script = String.Format("$(function() {{ setTimeout(function() {{ $(\"#tabs\").tabs(\"option\", \"active\", {0}); }}, 100); }});", tabIndex);

                        // Gestione del fallback per ScriptManager NULL (dopo Response.Redirect)
                        if (ScriptManager.GetCurrent(this) != null)
                        {
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "AutoOpenTab", script, true);
                        }
                        else
                        {
                            // Fallback robusto con Page.ClientScript
                            Page.ClientScript.RegisterStartupScript(this.GetType(), "AutoOpenTab", script, true);
                        }
                    }
                }
            }
            else
            {
                // Set default value for DDLVisibility
                DropDownList ddlVisibility = (DropDownList)FVProgetto.FindControl("DDLVisibility");
                ddlVisibility.SelectedValue = ConfigurationManager.AppSettings["SOLO_AUTORIZZATI"];
                ((CheckBox)FVProgetto.FindControl("ActiveCheckBox")).Checked = true;
            }
        }
    }

    // esegue il Bind nel codebehind per evitare problemi con il DDLManager quando un Manager è disattivato
    protected void Bind_DDL(object sender, EventArgs e)
    {
        DropDownList DDLManager = (DropDownList)FVProgetto.FindControl("DDLManager");
        DDLManager.Items.Clear();

        DropDownList DDLAccountManager = (DropDownList)FVProgetto.FindControl("DDLAccountManager");
        DDLAccountManager.Items.Clear();

        // *** Popola il DDLManager e DDLAccountManager  ***
        DataTable dt = Database.GetData("SELECT Persons_id, Name FROM Persons WHERE (Active = 1) ORDER BY Name");

        // Loop attraverso i dati della DataTable
        foreach (DataRow row in dt.Rows)
        {
            string nome = row["Name"].ToString();
            string id = row["Persons_id"].ToString();
            DDLManager.Items.Add(new ListItem(nome, id));
            DDLAccountManager.Items.Add(new ListItem(nome, id));
        }

        // Aggiunge un'opzione predefinita in cima alla lista
        DDLManager.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));
        DDLAccountManager.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));

        // *** Popola il DDLCliente  ***
        DropDownList DDLCliente = (DropDownList)FVProgetto.FindControl("DDLCliente");
        DDLCliente.Items.Clear();
        dt = Database.GetData("SELECT Nome1, CodiceCliente FROM Customers ORDER BY Nome1");

        // Loop attraverso i dati della DataTable
        foreach (DataRow row in dt.Rows)
        {
            string nome = row["Nome1"].ToString();
            string id = row["CodiceCliente"].ToString();
            DDLCliente.Items.Add(new ListItem(nome, id));
        }

        DDLCliente.Items.Insert(0, new ListItem("-- Seleziona un valore --", ""));

        DDLManager.DataTextField = "Name";
        DDLManager.DataValueField = "Persons_id";
        DDLManager.DataBind();

        DDLAccountManager.DataTextField = "Name";
        DDLAccountManager.DataValueField = "Persons_id";
        DDLAccountManager.DataBind();

        DDLCliente.DataTextField = "Nome1";
        DDLCliente.DataValueField = "CodiceCliente";
        DDLCliente.DataBind();

        // Imposta il valore predefinito
        DataRowView dataRow = (DataRowView)FVProgetto.DataItem;

        if (dataRow != null)
        {
            string managerId = dataRow["ClientManager_id"].ToString();
            if (managerId != "")
                DDLManager.SelectedValue = managerId;

            string accountmanagerId = dataRow["AccountManager_id"].ToString();
            if (accountmanagerId != "")
                DDLAccountManager.SelectedValue = accountmanagerId;

            string cliente = dataRow["CodiceCliente"].ToString();
            if (cliente != "")
                DDLCliente.SelectedValue = cliente;

            // =========================================================
            // SALVA LE DATE CORRENTI DEL PROGETTO PER FILTRARE GridView1
            // (usate in GridView1_RowDataBound per nascondere i Monthly Fee storici)
            // =========================================================
            if (dataRow.Row.Table.Columns.Contains("DataInizio") && dataRow["DataInizio"] != DBNull.Value)
                _currentProjectDataInizio = Convert.ToDateTime(dataRow["DataInizio"]);
            if (dataRow.Row.Table.Columns.Contains("DataFine") && dataRow["DataFine"] != DBNull.Value)
                _currentProjectDataFine = Convert.ToDateTime(dataRow["DataFine"]);
            // =========================================================

            // =========================================================
            // NUOVA LOGICA: INIEZIONE SCRIPT VISIBILITÀ CAMPI
            // =========================================================
            DropDownList ddlTipoProgetto = (DropDownList)FVProgetto.FindControl("DDLTipoProgetto");

            // Assumiamo che il valore di DDLTipoProgetto sia stato caricato
            // tramite <%# Bind("TipoProgetto") %> nel FormView.
            if (ddlTipoProgetto != null)
            {
                // Legge il testo attualmente selezionato (es. "Resale")
                string selectedText = ddlTipoProgetto.SelectedItem.Text;

                // Determina se siamo in Edit mode
                bool isEditMode = (FVProgetto.CurrentMode == FormViewMode.Edit);

                // Script per chiamare la funzione JS checkFieldsVisibility() con il valore iniziale e la modalità.
                // Si usa un piccolo ritardo (100ms) per garantire che il DOM e jQuery siano pronti.
                // Il valore viene passato come stringa per essere usato dal JS.
                string script = String.Format("$(function() {{ setTimeout(function() {{ checkFieldsVisibility('{0}', {1}); }}, 100); }});",
                    selectedText.Replace("'", "\\'"),
                    isEditMode.ToString().ToLower());

                // Inietta lo script. Usiamo una chiave univoca.
                Page.ClientScript.RegisterStartupScript(this.GetType(), "InitialFieldsVisibility", script, true);

                // =========================================================
                // NUOVA LOGICA RESALE: Gestione lato server SOLO IN EDIT MODE
                // =========================================================
                // IMPORTANTE: Applica la logica SOLO se siamo in modalità Edit
                if (FVProgetto.CurrentMode == FormViewMode.Edit &&
                    selectedText.Equals("Resale", StringComparison.OrdinalIgnoreCase))
                {
                    // 1. Blocca il campo Tipo Progetto (solo in modifica)
                    ddlTipoProgetto.Enabled = false;

                    // 2. Rendi readonly i campi Revenue e Costi nel tab Budget (solo in modifica)
                    System.Web.UI.WebControls.TextBox tbRevenueBudget = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBRevenueBudget");
                    System.Web.UI.WebControls.TextBox tbSpeseBudget = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("SpeseBudgetTextBox");

                    if (tbRevenueBudget != null)
                        tbRevenueBudget.ReadOnly = true;

                    if (tbSpeseBudget != null)
                        tbSpeseBudget.ReadOnly = true;

                    // 3. Nascondi definitivamente il pulsante Rinnova per progetti RESALE
                    Button btnRinnova = (Button)FVProgetto.FindControl("btnRinnova");
                    if (btnRinnova != null)
                        btnRinnova.Visible = false;
                }
            }
            // =========================================================
            // FINE NUOVA LOGICA
            // =========================================================

            // Esegui la logica solo se la FormView è in modalità Edit (o in una modalità in cui i dati sono vincolati)
            if (FVProgetto.CurrentMode == FormViewMode.Edit && FVProgetto.DataItem != null)
            {
                // 1. Trova il bottone "Rigenera"
                Button btnRigenera = (Button)FVProgetto.FindControl("btnRigenera");

                if (btnRigenera != null)
                {
                    try
                    {
                        DataRowView rowView = (DataRowView)FVProgetto.DataItem;
                        System.Web.UI.WebControls.TextBox txtDataInizio = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBAttivoDa");

                        // 2. RECUPERA LA DATA INIZIO PROGETTO DAL DATAITEM
                        // *** IMPORTANTE: Sostituisci "StartDate" se il tuo campo ha un nome diverso
                        DateTime startDate = txtDataInizio.Text != "" ? DateTime.Parse(txtDataInizio.Text) : DateTime.MinValue;

                        // 3. Calcola la data limite per la rigenerazione: Data Inizio + 1 mese
                        DateTime regenerationDeadline = startDate.AddMonths(1);

                        // 4. Esegui la comparazione
                        // Se la data odierna (DateTime.Now) è successiva alla scadenza, nascondi il bottone.
                        if (DateTime.Now > regenerationDeadline)
                        {
                            // 5. Nascondi il bottone
                            btnRigenera.Visible = false;
                        }
                        else
                        {
                            // Se la data odierna è entro 1 mese dalla Data Inizio, il bottone rimane visibile.
                            btnRigenera.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        // In caso di errore (es. campo StartDate non trovato o non valido), nascondi il bottone per sicurezza
                        btnRigenera.Visible = false;
                        // Qui potresti anche loggare l'errore: LogError(ex);
                    }
                }

                // =========================================================
                // LOGICA VISIBILITÀ BOTTONE "RINNOVA"
                // Visibile SOLO per progetti RESALE scaduti (DataFine < oggi)
                // =========================================================
                Button btnRinnova = (Button)FVProgetto.FindControl("btnRinnova");

                if (btnRinnova != null)
                {
                    try
                    {
                        DropDownList ddlTipo = (DropDownList)FVProgetto.FindControl("DDLTipoProgetto");
                        System.Web.UI.WebControls.TextBox txtDataFine = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBAttivoA");

                        bool isResale = ddlTipo != null && ddlTipo.SelectedItem != null
                            && ddlTipo.SelectedItem.Text.Equals("Resale", StringComparison.OrdinalIgnoreCase);

                        if (isResale && txtDataFine != null && !string.IsNullOrEmpty(txtDataFine.Text))
                        {
                            // Verifica se il progetto è scaduto
                            DateTime dataFine;
                            if (DateTime.TryParse(txtDataFine.Text, out dataFine))
                            {
                                // Mostra il pulsante SOLO se DataFine < oggi (progetto scaduto)
                                btnRinnova.Visible = (dataFine < DateTime.Now.Date);
                            }
                            else
                            {
                                btnRinnova.Visible = false;
                            }
                        }
                        else
                        {
                            // Non è RESALE o mancano dati → nascondi
                            btnRinnova.Visible = false;
                        }
                    }
                    catch
                    {
                        btnRinnova.Visible = false;
                    }
                }
                // =========================================================
                // FINE LOGICA VISIBILITÀ BOTTONE "RINNOVA"
                // =========================================================

                // =========================================================
                // LOGICA TAB STORICO - Solo per progetti RESALE con storico
                // =========================================================
                DropDownList ddlTipoPerStorico = (DropDownList)FVProgetto.FindControl("DDLTipoProgetto");
                bool isResalePerStorico = ddlTipoPerStorico != null && ddlTipoPerStorico.SelectedItem != null
                    && ddlTipoPerStorico.SelectedItem.Text.Equals("Resale", StringComparison.OrdinalIgnoreCase);

                if (isResalePerStorico && FVProgetto.CurrentMode == FormViewMode.Edit)
                {
                    try
                    {
                        // Recupera Projects_id - prova diverse varianti del nome
                        int projectId = 0;
                        if (dataRow.Row.Table.Columns.Contains("Projects_id"))
                            projectId = Convert.ToInt32(dataRow["Projects_id"]);
                        else if (dataRow.Row.Table.Columns.Contains("Projects_Id"))
                            projectId = Convert.ToInt32(dataRow["Projects_Id"]);

                        if (projectId == 0)
                        {
                            // Tenta di recuperare dal DataKey
                            if (FVProgetto.DataKey != null && FVProgetto.DataKey.Value != null)
                                projectId = Convert.ToInt32(FVProgetto.DataKey.Value);
                        }

                        // Recupera le date correnti del progetto
                        DateTime? dataInizioCorrente = null;
                        DateTime? dataFineCorrente = null;

                        if (dataRow.Row.Table.Columns.Contains("DataInizio") && dataRow["DataInizio"] != DBNull.Value)
                            dataInizioCorrente = Convert.ToDateTime(dataRow["DataInizio"]);
                        if (dataRow.Row.Table.Columns.Contains("DataFine") && dataRow["DataFine"] != DBNull.Value)
                            dataFineCorrente = Convert.ToDateTime(dataRow["DataFine"]);

                        // Query per recuperare i periodi storici (escluso il periodo corrente)
                        string queryStorico = @"
                            SELECT 
                                DataInizio,
                                DataFine,
                                SUM(Revenue) as TotRevenue,
                                SUM(Cost) as TotCost
                            FROM Monthly_Fee
                            WHERE Projects_id = " + projectId + @"
                                AND Active = 1
                                AND NOT (
                                    (DataInizio = @DataInizioCorrente OR (DataInizio IS NULL AND @DataInizioCorrente IS NULL))
                                    AND 
                                    (DataFine = @DataFineCorrente OR (DataFine IS NULL AND @DataFineCorrente IS NULL))
                                )
                            GROUP BY DataInizio, DataFine
                            ORDER BY DataInizio DESC";

                        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString))
                        {
                            conn.Open();
                            using (SqlCommand cmd = new SqlCommand(queryStorico, conn))
                            {
                                // Gestione parametri NULL
                                cmd.Parameters.AddWithValue("@DataInizioCorrente",
                                    dataInizioCorrente.HasValue ? (object)dataInizioCorrente.Value : DBNull.Value);
                                cmd.Parameters.AddWithValue("@DataFineCorrente",
                                    dataFineCorrente.HasValue ? (object)dataFineCorrente.Value : DBNull.Value);

                                DataTable dtStorico = new DataTable();
                                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                                {
                                    adapter.Fill(dtStorico);
                                }

                                // Prepara i dati per la visualizzazione
                                DataTable dtDisplay = new DataTable();
                                dtDisplay.Columns.Add("Periodo", typeof(string));
                                dtDisplay.Columns.Add("Revenue", typeof(decimal));
                                dtDisplay.Columns.Add("Cost", typeof(decimal));
                                dtDisplay.Columns.Add("Margine", typeof(string));

                                foreach (DataRow row in dtStorico.Rows)
                                {
                                    string periodo;
                                    if (row["DataInizio"] != DBNull.Value && row["DataFine"] != DBNull.Value)
                                    {
                                        DateTime dtInizio = Convert.ToDateTime(row["DataInizio"]);
                                        DateTime dtFine = Convert.ToDateTime(row["DataFine"]);
                                        periodo = dtInizio.ToString("dd/MM/yyyy") + " - " + dtFine.ToString("dd/MM/yyyy");
                                    }
                                    else
                                    {
                                        periodo = "Periodo non definito";
                                    }

                                    decimal revenue = row["TotRevenue"] != DBNull.Value ? Convert.ToDecimal(row["TotRevenue"]) : 0;
                                    decimal cost = row["TotCost"] != DBNull.Value ? Convert.ToDecimal(row["TotCost"]) : 0;

                                    string margine = "0,00";
                                    if (revenue > 0)
                                    {
                                        decimal marginRatio = (revenue - cost) / revenue * 100;
                                        margine = marginRatio.ToString("0.00", new CultureInfo("it-IT"));
                                    }

                                    dtDisplay.Rows.Add(periodo, revenue, cost, margine);
                                }

                                // Popola SEMPRE la GridView (anche se vuota)
                                System.Web.UI.WebControls.GridView gvStorico = (System.Web.UI.WebControls.GridView)FVProgetto.FindControl("GridViewStorico");
                                if (gvStorico != null)
                                {
                                    gvStorico.DataSource = dtDisplay;
                                    gvStorico.DataBind();
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Mostra l'errore reale all'utente per debug
                        ClientScript.RegisterStartupScript(this.GetType(), "StoricoError",
                            "alert('Errore caricamento storico: " + ex.Message.Replace("'", "`").Replace("\r", " ").Replace("\n", " ") + "');", true);
                    }
                }
                // =========================================================
                // FINE LOGICA TAB STORICO
                // =========================================================
            }

        }

        // usato per valorizzare la chiave del log modifiche
        if (Request.QueryString["Projectcode"] != null)
            Session["Projects_Id"] = FVProgetto.DataKey["Projects_Id"].ToString();

    }

    protected void DSprojects_Insert(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
    }

    protected void DSprojects_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
    }

    protected void BackToList(Object sender, EventArgs e)
    {

        if (FVProgetto.CurrentMode == FormViewMode.Insert)
        {
            string projectCode = GetProjectCodeFromForm();
            System.Web.UI.WebControls.CheckBox chkAttivo = (System.Web.UI.WebControls.CheckBox)FVProgetto.FindControl("ActiveCheckBox");
            // DDL deve essere accessibile per controllare il tipo di progetto
            DropDownList ddlTipoProgetto = (DropDownList)FVProgetto.FindControl("DDLTipoProgetto");

            // DDL deve essere accessibile per controllare il tipo di progetto
            DropDownList DDLTipoContratto = (DropDownList)FVProgetto.FindControl("DDLTipoContratto");

            // Se il progetto è attivo, esegue il calcolo e l'inserimento dei ratei
            if (chkAttivo.Checked)
            {
                // 1. Recupera il codice appena inserito
                projectCode = GetProjectCodeFromForm();
            }

            // INIZIO MODIFICA: Logica Redirect condizionale
            if (ddlTipoProgetto != null && ddlTipoProgetto.SelectedItem.Text == "Resale" && DDLTipoContratto.SelectedItem.Text.ToLower() == "forfait")
            {
                // 2. Esegue il calcolo e ottiene la lista dei ratei
                List<AccrualResult> accrualList = eseguiCalcoloCanone();

                // 3. Salva i ratei nel DB, PASSANDO L'ID
                InserisciAccrualNelDB(projectCode, accrualList);

                // Indice fisso del tab Monthly Fee (0-based, quindi 4 per il 5° tab)
                const int MONTHLY_FEE_TAB_INDEX = 3;

                // Reindirizza alla pagina di EDIT del progetto appena creato,
                // passando il codice e l'indice del tab nella QueryString
                Response.Redirect(String.Format("Projects_lookup_form.aspx?Projectcode={0}&tab={1}", projectCode, MONTHLY_FEE_TAB_INDEX));
                return; // Interrompe l'esecuzione e previene il redirect standard
            }
        }

        Response.Redirect("projects_lookup_list.aspx");
    }

    protected void FVProgetto_ModeChanging(Object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit == true)
            Response.Redirect("projects_lookup_list.aspx");
    }

    protected void ValidaProgetto_ServerValidate(Object sender, ServerValidateEventArgs args)
    {
        ValidationClass c = new ValidationClass();

        // true se non esiste già il record
        args.IsValid = !c.CheckExistence("ProjectCode", args.Value, "Projects");

        // Evidenzia campi form in errore
        c.SetErrorOnField(args.IsValid, FVProgetto, "TBProgetto");
    }

    protected void FVProgetto_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.NewValues["CodiceCliente"] = ((DropDownList)FVProgetto.FindControl("DDLCliente")).SelectedValue;
        e.NewValues["ClientManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLManager")).SelectedValue;
        e.NewValues["AccountManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLAccountManager")).SelectedValue;
    }

    protected void FVProgetto_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        // Preserva i valori selezionati nei DropDownList
        e.Values["CodiceCliente"] = ((DropDownList)FVProgetto.FindControl("DDLCliente")).SelectedValue;
        e.Values["ClientManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLManager")).SelectedValue;
        e.Values["AccountManager_id"] = ((DropDownList)FVProgetto.FindControl("DDLAccountManager")).SelectedValue;
    }

    protected void CloneButton_Click(object sender, EventArgs e)
    {
        int projectsId = (int)FVProgetto.DataKey["Projects_Id"];
        Response.Redirect("CloneProject.aspx?Project_id=" + projectsId + "&ProjectCode=" + Request.QueryString["Projectcode"]);
    }

    #region GridView Canoni Mensili e gestione ratei

    // Gestisce il cambio di pagina nella GridView dei canoni mensili
    // Salva l'indice di pagina in Session e ricarica i dati
    // per mantenere la pagina selezionata dopo il postback
    protected void GridView1_PageIndexChanging(Object sender, GridViewPageEventArgs e)
    {
        System.Web.UI.WebControls.GridView gridCanoni = (System.Web.UI.WebControls.GridView)sender;

        // 2. Impostiamo il nuovo indice di pagina
        gridCanoni.PageIndex = e.NewPageIndex;

        // 3. Salviamo l'indice in Session (come stavi facendo)
        Session["GridCanoniPageNumber"] = e.NewPageIndex;

        // 4. Ri-effettua il data binding della GridView.
        //    Devi chiamare il metodo che popola la GridView per applicare il cambio di pagina.
        //    Se il tuo GridView carica i dati nel FVProgetto_DataBound, probabilmente
        //    dovrai chiamare il tuo metodo di bind, ad esempio:
        //    BindMonthlyFees(Convert.ToInt32(FVProgetto.DataKey.Value));

        //    Alternativa (se usi un DataSource collegato al FormView):
        gridCanoni.DataBind();
    }

    // Gestisce la selezione di una riga nella GridView dei canoni mensili
    // Reindirizza alla pagina di dettaglio del canone mensile selezionato
    // con i parametri Monthly_Fee_id e Projects_Id
    // ottenuti dai DataKeys della GridView
    protected void GridView1_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        System.Web.UI.WebControls.GridView gridCanoni = (System.Web.UI.WebControls.GridView)sender;

        var dataKeys = gridCanoni.DataKeys[gridCanoni.SelectedRow.RowIndex].Values;

        var Monthly_Fee_id = dataKeys["Monthly_Fee_id"];
        var ProjectsId = dataKeys["Projects_id"];

        Response.Redirect("../Canoni/montly_fee_lookup_form.aspx?Monthly_Fee_id=" + Monthly_Fee_id + "&Projects_Id=" + ProjectsId);
    }

    // Gestisce il calcolo e la visualizzazione dei totali nella GridView dei canoni mensili    
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // =========================================================
        // FILTRO: Nascondi le righe Monthly Fee con periodo diverso da quello corrente
        // (mostra solo i Monthly Fee del periodo attuale del progetto RESALE)
        // =========================================================
        if (e.Row.RowType == DataControlRowType.DataRow && _currentProjectDataInizio.HasValue && _currentProjectDataFine.HasValue)
        {
            DataRowView drvFilter = (DataRowView)e.Row.DataItem;

            DateTime? rowDataInizio = drvFilter["DataInizio"] != DBNull.Value ?
                (DateTime?)Convert.ToDateTime(drvFilter["DataInizio"]) : null;
            DateTime? rowDataFine = drvFilter["DataFine"] != DBNull.Value ?
                (DateTime?)Convert.ToDateTime(drvFilter["DataFine"]) : null;

            // Se la riga ha date diverse dal periodo corrente, nascondila
            bool sameInizio = rowDataInizio.HasValue && rowDataInizio.Value == _currentProjectDataInizio.Value;
            bool sameFine = rowDataFine.HasValue && rowDataFine.Value == _currentProjectDataFine.Value;

            if (!sameInizio || !sameFine)
            {
                e.Row.Visible = false;
                return; // Esci subito, non accumulare i totali per questa riga nascosta
            }
        }
        // =========================================================
        // FINE FILTRO
        // =========================================================

        // Variabili per il parsing dei valori di riga
        decimal monthlyRevenue = 0.00M;
        decimal monthlyCost = 0.00M;

        // Variabili per i budget parsati (valori di riferimento)
        decimal budgetRevenue = 0.00M;
        decimal budgetCost = 0.00M;

        // Colori da usare
        System.Drawing.Color colorIfMismatch = System.Drawing.Color.Red;
        System.Drawing.Color colorIfCorrect = System.Drawing.ColorTranslator.FromHtml("#228B22");

        // Cultura italiana per il parsing e la formattazione
        CultureInfo italianCulture = new CultureInfo("it-IT");

        // Costante di tolleranza per i confronti
        const decimal TOLERANCE = 0.005M;

        // --- 1. ACCUMULO DEI TOTALI (RowType.DataRow) ---
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView drv = (DataRowView)e.Row.DataItem;

            // Accumulo Ricavo
            if (decimal.TryParse(drv["Revenue"].ToString(), out monthlyRevenue))
            {
                TotalRevenue += monthlyRevenue;
            }

            // Accumulo Costo
            if (decimal.TryParse(drv["Cost"].ToString(), out monthlyCost))
            {
                TotalCost += monthlyCost;
            }
        }

        // --- 2. CALCOLO, CONFRONTO E FORMATTAZIONE (RowType.Footer) ---
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            // A. RECUPERO DEI BUDGET E DELLE LABEL

            // Recupero Budget e Label Ricavo
            System.Web.UI.WebControls.TextBox txtRevenue =
                (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBRevenueBudget");
            System.Web.UI.WebControls.Label lblRevenueAlert =
                (System.Web.UI.WebControls.Label)FVProgetto.FindControl("LblRevenueAlert");

            if (txtRevenue != null)
            {
                decimal.TryParse(txtRevenue.Text.Replace(".", ""), NumberStyles.Currency, italianCulture, out budgetRevenue);
            }
            if (lblRevenueAlert != null)
            {
                lblRevenueAlert.Text = string.Empty;
            }

            // Recupero Budget e Label Costo
            System.Web.UI.WebControls.TextBox txtCost =
                (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("SpeseBudgetTextBox");
            System.Web.UI.WebControls.Label lblCostAlert =
                (System.Web.UI.WebControls.Label)FVProgetto.FindControl("LblCostAlert");

            if (txtCost != null)
            {
                decimal.TryParse(txtCost.Text.Replace(".", ""), NumberStyles.Currency, italianCulture, out budgetCost);
            }
            if (lblCostAlert != null)
            {
                lblCostAlert.Text = string.Empty;
            }


            // B. CONFRONTI E APPLICAZIONE DEI COLORI E MESSAGGI DI AVVISO (C# 5 COMPATIBILE)

            // --- RICAVO ---
            decimal revenueDifference = TotalRevenue - budgetRevenue;
            bool revenueMismatch = Math.Abs(revenueDifference) > TOLERANCE;
            System.Drawing.Color revenueColor = revenueMismatch ? colorIfMismatch : colorIfCorrect;

            if (revenueMismatch)
            {
                string signPrefix;
                string discrepancyText = string.Format(italianCulture, "{0:N2}", Math.Abs(revenueDifference));

                // Logica per determinare se è in positivo o negativo
                if (revenueDifference > 0)
                {
                    signPrefix = "+ ";
                }
                else
                {
                    signPrefix = "- ";
                }

                if (lblRevenueAlert != null)
                {
                    // Concatenazione standard (C# 5)
                    lblRevenueAlert.Text = "ATTENZIONE: Discrepanza Ricavi " + signPrefix + " € " + discrepancyText;
                    lblRevenueAlert.ForeColor = colorIfMismatch;
                }
            }

            // --- COSTO ---
            decimal costDifference = TotalCost - budgetCost;
            bool costMismatch = Math.Abs(costDifference) > TOLERANCE;
            System.Drawing.Color costColor = costMismatch ? colorIfMismatch : colorIfCorrect;

            if (costMismatch)
            {
                string signPrefix;
                string discrepancyText = string.Format(italianCulture, "{0:N2}", Math.Abs(costDifference));

                // Logica per determinare se è in positivo o negativo
                if (costDifference > 0)
                {
                    signPrefix = "+ ";
                }
                else
                {
                    signPrefix = "- ";
                }

                if (lblCostAlert != null)
                {
                    // Concatenazione standard (C# 5)
                    lblCostAlert.Text = "ATTENZIONE: Discrepanza Costi " + signPrefix + " € " + discrepancyText;
                    lblCostAlert.ForeColor = colorIfMismatch;
                }
            }


            // C. VISUALIZZAZIONE E FORMATTAZIONE DEI TOTALI NELLA GRIDVIEW (Footer)

            e.Row.Cells[0].Text = "TOTALE:";
            e.Row.Cells[0].Font.Bold = true;

            // Colonna Ricavo (Indice 3)
            if (e.Row.Cells.Count > 3)
            {
                e.Row.Cells[3].Text = string.Format(italianCulture, "{0:N2} €", TotalRevenue);
                e.Row.Cells[3].Font.Bold = true;
                e.Row.Cells[3].ForeColor = revenueColor;
            }

            // Colonna Costo (Indice 4)
            if (e.Row.Cells.Count > 4)
            {
                e.Row.Cells[4].Text = string.Format(italianCulture, "{0:N2} €", TotalCost);
                e.Row.Cells[4].Font.Bold = true;
                e.Row.Cells[4].ForeColor = costColor;
            }
        }
    }

    /// <summary>
    /// Gestisce il click sul pulsante "Rigenera Canoni"
    /// </summary>
    protected void btnRigenera_Click(object sender, EventArgs e)
    {
        // Passaggio A: Recupera il codice del progetto dal FormView
        System.Web.UI.WebControls.TextBox txtProjectCode = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBProgetto");

        if (txtProjectCode == null)
        {
            // Gestisci l'errore se la TextBox non è stata trovata
            return;
        }

        string projectCode = txtProjectCode.Text;

        if (!string.IsNullOrEmpty(projectCode))
        {
            try
            {
                // Passaggio B: Esegue il calcolo dei ratei
                List<AccrualResult> accrualList = eseguiCalcoloCanone();

                // Passaggio C: Inserisce i nuovi ratei nel DB (che include DELETE dei vecchi)
                InserisciAccrualNelDB(projectCode, accrualList);

                // 1. Ricarica l'origine dati (SqlDataSource)
                DSCanoni.DataBind();

                // 2. Ricarica la GridView
                System.Web.UI.WebControls.GridView gridCanoni = (System.Web.UI.WebControls.GridView)FVProgetto.FindControl("GridView1");
                gridCanoni.DataBind();

            }
            catch (Exception ex)
            {
                // Gestione e log dell'errore
                string errorMessage = "Errore durante la rigenerazione: " + ex.Message.Replace("'", "`"); // Sostituisci l'apice per JS safety

                // Mostra l'errore all'utente
                ClientScript.RegisterStartupScript(
                    this.GetType(),
                    "ErrorScript",
                    "alert('" + errorMessage + "');",
                    true);
            }
        }
    }


    /// <summary>
    /// Gestisce il click sul pulsante "Rinnova".
    /// Calcola e inserisce SOLO i monthly fee del periodo di proroga (delta),
    /// senza toccare i record esistenti.
    /// </summary>
    /// <summary>
    /// Rinnova un progetto RESALE scaduto con nuove date e budget.
    /// Aggiorna il progetto E genera automaticamente i nuovi Monthly Fee per il nuovo periodo.
    /// I Monthly Fee vecchi rimangono come storico.
    /// </summary>
    protected void btnRinnova_Click(object sender, EventArgs e)
    {
        // Dichiarazione variabile fuori dal blocco using per poterla usare nell'alert finale
        List<AccrualResult> nuoviRatei = new List<AccrualResult>();

        try
        {
            // 1. Recupera i valori dagli hidden fields popolati dal modal
            // IMPORTANTE: Gli hidden fields sono FUORI dal FormView, quindi usare this (la pagina)
            HiddenField hdnDataInizio = (HiddenField)this.FindControl("hdnNuovaDataInizio");
            HiddenField hdnDataFine = (HiddenField)this.FindControl("hdnNuovaDataFine");
            HiddenField hdnRevenue = (HiddenField)this.FindControl("hdnNuovoRevenue");
            HiddenField hdnCost = (HiddenField)this.FindControl("hdnNuovoCost");

            if (hdnDataInizio == null || hdnDataFine == null || hdnRevenue == null || hdnCost == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                    "alert('Errore: campi hidden non trovati');", true);
                return;
            }

            string nuovaDataInizioStr = hdnDataInizio.Value;
            string nuovaDataFineStr = hdnDataFine.Value;
            string nuovoRevenueStr = hdnRevenue.Value;
            string nuovoCostStr = hdnCost.Value;

            if (string.IsNullOrEmpty(nuovaDataInizioStr) || string.IsNullOrEmpty(nuovaDataFineStr) ||
                string.IsNullOrEmpty(nuovoRevenueStr) || string.IsNullOrEmpty(nuovoCostStr))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                    "alert('Errore: dati mancanti dal modal');", true);
                return;
            }

            // 2. Parse dei valori
            CultureInfo italianCulture = new CultureInfo("it-IT");

            DateTime nuovaDataInizio;
            DateTime nuovaDataFine;
            decimal nuovoRevenue;
            decimal nuovoCost;

            if (!DateTime.TryParse(nuovaDataInizioStr, italianCulture, DateTimeStyles.None, out nuovaDataInizio) ||
                !DateTime.TryParse(nuovaDataFineStr, italianCulture, DateTimeStyles.None, out nuovaDataFine))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                    "alert('Date non valide');", true);
                return;
            }

            // Parse dei decimali (formato italiano: 1.000,00)
            nuovoRevenueStr = nuovoRevenueStr.Replace(".", "").Replace(",", ".");
            nuovoCostStr = nuovoCostStr.Replace(".", "").Replace(",", ".");

            if (!decimal.TryParse(nuovoRevenueStr, NumberStyles.Any, CultureInfo.InvariantCulture, out nuovoRevenue) ||
                !decimal.TryParse(nuovoCostStr, NumberStyles.Any, CultureInfo.InvariantCulture, out nuovoCost))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                    "alert('Importi non validi');", true);
                return;
            }

            // 3. Recupera il ProjectCode dal QueryString (più affidabile del FormView)
            string projectCode = Request.QueryString["ProjectCode"];

            if (string.IsNullOrEmpty(projectCode))
            {
                // Fallback: prova dal FormView
                System.Web.UI.WebControls.TextBox txtProjectCode = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBProgetto");
                if (txtProjectCode != null)
                    projectCode = txtProjectCode.Text;
            }

            if (string.IsNullOrEmpty(projectCode))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                    "alert('Codice progetto non trovato');", true);
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;
            int projectId = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Recupera Projects_id
                string selectIdQuery = "SELECT Projects_id FROM Projects WHERE ProjectCode = @ProjectCode";
                using (SqlCommand cmdId = new SqlCommand(selectIdQuery, conn))
                {
                    cmdId.Parameters.AddWithValue("@ProjectCode", projectCode);
                    object result = cmdId.ExecuteScalar();
                    if (result != null)
                        projectId = Convert.ToInt32(result);
                }

                if (projectId == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                        "alert('Progetto non trovato');", true);
                    return;
                }

                // 4. Aggiorna il progetto nel database
                string updateQuery = @"
                    UPDATE Projects 
                    SET DataInizio = @DataInizio,
                        DataFine = @DataFine,
                        RevenueBudget = @Revenue,
                        SpeseBudget = @Cost,
                        LastModifiedBy = @ModifiedBy,
                        LastModificationDate = GETDATE()
                    WHERE Projects_id = @ProjectId";

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@DataInizio", nuovaDataInizio);
                    cmd.Parameters.AddWithValue("@DataFine", nuovaDataFine);
                    cmd.Parameters.AddWithValue("@Revenue", nuovoRevenue);
                    cmd.Parameters.AddWithValue("@Cost", nuovoCost);
                    cmd.Parameters.AddWithValue("@ModifiedBy", CurrentSession.UserName);
                    cmd.Parameters.AddWithValue("@ProjectId", projectId);

                    cmd.ExecuteNonQuery();
                }

                // 5. Calcola i ratei per il nuovo periodo
                nuoviRatei = CalculateMonthlyAccrual(nuovaDataInizio, nuovaDataFine, nuovoRevenue, nuovoCost);

                if (nuoviRatei.Count == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "RinnovaWarning",
                        "alert('Progetto rinnovato ma nessun rateo generato per il periodo indicato');", true);
                    return;
                }

                // 6. Inserisci i nuovi Monthly Fee (senza eliminare i vecchi)
                string insertQuery = @"
                    INSERT INTO Monthly_Fee 
                    (Projects_id, ProjectCode, Monthly_Fee_Code, Year, Month, Revenue, Cost, Days, 
                     Day_Revenue, Day_Cost, DataInizio, DataFine, 
                     CreatedBy, CreationDate, LastModifiedBy, LastModificationDate, Active) 
                    VALUES 
                    (@ProjectId, @ProjectCode, @MonthlyFeeCode, @Year, @Month, @Revenue, @Cost, @Days,
                     @DayRevenue, @DayCost, @DataInizio, @DataFine,
                     @CreatedBy, GETDATE(), @LastModifiedBy, GETDATE(), 1)";

                foreach (var rateo in nuoviRatei)
                {
                    using (SqlCommand cmdInsert = new SqlCommand(insertQuery, conn))
                    {
                        cmdInsert.Parameters.AddWithValue("@ProjectId", projectId);
                        cmdInsert.Parameters.AddWithValue("@ProjectCode", projectCode);
                        cmdInsert.Parameters.AddWithValue("@MonthlyFeeCode",
                            projectCode + "_" + rateo.Year + "_" + rateo.Month);
                        cmdInsert.Parameters.AddWithValue("@Year", rateo.Year);
                        cmdInsert.Parameters.AddWithValue("@Month", rateo.Month);
                        cmdInsert.Parameters.AddWithValue("@Revenue", rateo.Revenue);
                        cmdInsert.Parameters.AddWithValue("@Cost", rateo.Cost);
                        cmdInsert.Parameters.AddWithValue("@Days", rateo.AccrualDays);
                        cmdInsert.Parameters.AddWithValue("@DayRevenue", rateo.DailyRevenueRate);
                        cmdInsert.Parameters.AddWithValue("@DayCost", rateo.DailyCostRate);

                        // IMPORTANTE: Popola DataInizio e DataFine del NUOVO periodo
                        cmdInsert.Parameters.AddWithValue("@DataInizio", nuovaDataInizio);
                        cmdInsert.Parameters.AddWithValue("@DataFine", nuovaDataFine);

                        cmdInsert.Parameters.AddWithValue("@CreatedBy", CurrentSession.UserName);
                        cmdInsert.Parameters.AddWithValue("@LastModifiedBy", CurrentSession.UserName);

                        cmdInsert.ExecuteNonQuery();
                    }
                }
            }

            // Successo! Redirect alla stessa pagina per mostrare i dati aggiornati
            // Usa Response.Redirect per evitare loop infiniti
            Response.Redirect("Projects_lookup_form.aspx?ProjectCode=" + projectCode + "&success=1&count=" + nuoviRatei.Count, false);
        }
        catch (Exception ex)
        {
            string errorMessage = "Errore durante il rinnovo: " + ex.Message.Replace("'", "`");
            ClientScript.RegisterStartupScript(this.GetType(), "RinnovaError",
                "alert('" + errorMessage + "');", true);
        }
    }

    /// <summary>
    /// Inserisce nel DB i ratei del periodo di proroga (INSERT ONLY, senza DELETE).
    /// </summary>
    private void AppendAccrualNelDB(string projectCode, List<AccrualResult> accrualList)
    {
        string connectionStringName = "MSSql12155ConnectionString";
        string tableName = "Monthly_Fee";
        string createdBy = CurrentSession.UserId.ToString();

        System.Configuration.ConnectionStringSettings connectionSection =
            ConfigurationManager.ConnectionStrings[connectionStringName];

        string connectionString = (connectionSection != null) ? connectionSection.ConnectionString : null;

        if (string.IsNullOrEmpty(connectionString))
            throw new ConfigurationErrorsException("La stringa di connessione '" + connectionStringName + "' non e' stata trovata.");

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            // Recupera Projects_id dal ProjectCode
            int projectsId = 0;
            using (SqlCommand cmdSelect = new SqlCommand("SELECT Projects_id FROM Projects WHERE ProjectCode = @ProjectCode", conn))
            {
                cmdSelect.Parameters.AddWithValue("@ProjectCode", projectCode);
                object result = cmdSelect.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    projectsId = Convert.ToInt32(result);
            }

            if (projectsId <= 0)
                return;

            // INSERT ONLY - nessuna DELETE
            string insertQuery = string.Format(
                @"INSERT INTO {0} 
                (Projects_id, [ProjectCode], [Monthly_Fee_Code], [Year], [Month], Revenue, Cost, [Days], Day_Revenue, Day_Cost, 
                 CreatedBy, CreationDate, LastModifiedBy, LastModificationDate, Active) 
                SELECT 
                 @ProjectsId, @ProjectCode,
                 @ProjectCode + '_' + CAST(@Year AS VARCHAR) + '_' + CAST(@Month AS VARCHAR) + '_' + 
                 CAST((SELECT ISNULL(COUNT(*), 0) + 1 FROM {0} 
                       WHERE ProjectCode = @ProjectCode AND [Year] = @Year AND [Month] = @Month) AS VARCHAR),
                 @Year, @Month, @Revenue, @Cost, @Days, @Day_Revenue, @Day_Cost,
                 @CreatedBy, GETDATE(), @LastModifiedBy, GETDATE(), 1", tableName);

            foreach (var accrual in accrualList)
            {
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@ProjectsId", projectsId);
                    cmd.Parameters.AddWithValue("@ProjectCode", projectCode);
                    cmd.Parameters.AddWithValue("@Year", accrual.Year);
                    cmd.Parameters.AddWithValue("@Month", accrual.Month);
                    cmd.Parameters.AddWithValue("@Revenue", accrual.Revenue);
                    cmd.Parameters.AddWithValue("@Cost", accrual.Cost);
                    cmd.Parameters.AddWithValue("@Days", accrual.AccrualDays);
                    cmd.Parameters.AddWithValue("@Day_Revenue", accrual.DailyRevenueRate);
                    cmd.Parameters.AddWithValue("@Day_Cost", accrual.DailyCostRate);
                    cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
                    cmd.Parameters.AddWithValue("@LastModifiedBy", createdBy);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    /// <summary>
    /// Calcola i ratei mensili per un progetto in base ai ricavi, ai costi e all’intervallo di date forniti.
    /// </summary>
    /// <remarks>
    /// Questo metodo recupera i valori di input dai controlli del form, li converte nei tipi di dato appropriati
    /// e calcola i ratei mensili utilizzando il metodo <see cref="AccrualCalculator.CalculateMonthlyAccrual"/>.
    /// I valori di input devono rispettare il formato italiano (ad esempio, date in formato "dd/MM/yyyy"
    /// e numeri decimali con la virgola come separatore).
    /// </remarks>
    private List<AccrualResult> eseguiCalcoloCanone()
    {
        // *** 1. RECUPERO CONTROLLI DAL FORMVIEW ***

        System.Web.UI.WebControls.TextBox txtProjectCode = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBProgetto");

        // TextBox per gli importi (RevenueTxt e CostTxt sono nel FormView FVCanoni o FVProgetto, 
        // userò FVProgetto come nei tuoi file caricati)
        System.Web.UI.WebControls.TextBox txtRevenue = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBRevenueBudget");
        System.Web.UI.WebControls.TextBox txtCost = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("SpeseBudgetTextBox");

        // Campi Data (Questi ID sono un'assunzione basata sul contesto, potrebbero essere diversi)
        System.Web.UI.WebControls.TextBox txtDataInizio = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBAttivoDa");
        System.Web.UI.WebControls.TextBox txtDataFine = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBAttivoA");

        // *** 2. PARSING E CONVERSIONE DEI VALORI ***

        DateTime dataInizio;
        DateTime dataFine;
        decimal importoTotale;
        decimal costoTotale;

        // Per gestire il formato italiano (virgola come separatore decimale)
        // Se usi la proprietà .Text del controllo, il formato è quello della UI
        CultureInfo italianCulture = new CultureInfo("it-IT");

        string dataInizioText = (txtDataInizio != null) ? txtDataInizio.Text : string.Empty;
        // Converto la data. Uso TryParse per sicurezza
        if (!DateTime.TryParse(dataInizioText, italianCulture, DateTimeStyles.None, out dataInizio))
        {
            // Gestione se il parsing fallisce (es. campo vuoto o formato errato)
            dataInizio = DateTime.MinValue; // Assegna un valore di default o lancia un errore
        }

        string dataFineText = (txtDataFine != null) ? txtDataFine.Text : string.Empty;

        if (!DateTime.TryParse(dataFineText, italianCulture, DateTimeStyles.None, out dataFine))
        {
            // Gestione se il parsing fallisce
            dataFine = DateTime.MinValue; // Assegna un valore di default o lancia un errore
        }

        // Converto l'importo. Uso TryParse per sicurezza (gestisce la maschera JS che lascia il formato italiano)       
        string revenueText = (txtRevenue != null) ? txtRevenue.Text : "0";
        if (!decimal.TryParse(revenueText.Replace(".", ""), NumberStyles.Currency, italianCulture, out importoTotale))
        {
            importoTotale = 0.00M;
        }

        string costText = (txtCost != null) ? txtCost.Text : "0";
        // 2. Rimuove il separatore delle migliaia (punto) e tenta la conversione.
        // Se la conversione fallisce (es. stringa non valida), costoTotale sarà 0.00M
        if (!decimal.TryParse(costText.Replace(".", ""), NumberStyles.Currency, italianCulture, out costoTotale))
        {
            // Se la conversione fallisce, usa 0 (questo è un fallback aggiuntivo, 
            // ma TryParse gestisce già l'assegnazione se il campo iniziale è "0" o vuoto).
            costoTotale = 0.00M;
        }

        List<AccrualResult> accrualList = CalculateMonthlyAccrual(
            dataInizio,
            dataFine,
            importoTotale,
            costoTotale
        );

        return accrualList;
    }

    /// <summary>
    /// Represents the financial accrual results for a specific year and month, including revenue and cost data.
    /// </summary>
    /// <remarks>This class is typically used to store and transfer financial data for a given period. The
    /// <see cref="Year"/> and <see cref="Month"/> properties identify the period, while <see cref="Revenue"/> and <see
    /// cref="Cost"/> provide the corresponding financial figures.</remarks>
    public class AccrualResult
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public decimal Revenue { get; set; }
        public decimal Cost { get; set; }
        /// <summary>Costo distribuito per singolo giorno (€/giorno).</summary>
        public decimal DailyRevenueRate { get; set; }
        /// <summary>Ricavo distribuito per singolo giorno (€/giorno).</summary>
        public decimal DailyCostRate { get; set; }
        /// <summary>Numero di giorni effettivi del mese su cui è stato calcolato il rateo.</summary>
        public int AccrualDays { get; set; }
    }

    public static List<AccrualResult> CalculateMonthlyAccrual(
    DateTime startDate,
    DateTime endDate,
    decimal totalRevenue,
    decimal totalCost)
    {
        var results = new List<AccrualResult>();

        int totalContractDays = (int)(endDate - startDate).TotalDays + 1;
        if (totalContractDays <= 0) return results;

        // Calcolo tassi giornalieri ad alta precisione
        double dailyRevenueRateDouble = (double)totalRevenue / totalContractDays;
        double dailyCostRateDouble = (double)totalCost / totalContractDays;

        // Soglia: inizio del mese corrente
        DateTime today = DateTime.Today;
        DateTime currentMonthThreshold = new DateTime(today.Year, today.Month, 1);

        decimal remainingRevenue = totalRevenue;
        decimal remainingCost = totalCost;

        // Accumulo per il pregresso
        decimal accumulatedRevenue = 0;
        decimal accumulatedCost = 0;

        DateTime currentMonthStart = new DateTime(startDate.Year, startDate.Month, 1);

        while (currentMonthStart <= endDate)
        {
            DateTime accrualStart = (currentMonthStart > startDate) ? currentMonthStart : startDate;
            DateTime naturalMonthEnd = currentMonthStart.AddMonths(1).AddDays(-1);
            DateTime accrualEnd = (naturalMonthEnd < endDate) ? naturalMonthEnd : endDate;

            int monthlyAccrualDays = (int)(accrualEnd - accrualStart).TotalDays + 1;

            if (monthlyAccrualDays > 0)
            {
                decimal theoreticalMonthlyRevenue;
                decimal theoreticalMonthlyCost;

                // 1. Calcolo del valore TEORICO del mese
                if (currentMonthStart.Year == endDate.Year && currentMonthStart.Month == endDate.Month)
                {
                    theoreticalMonthlyRevenue = remainingRevenue;
                    theoreticalMonthlyCost = remainingCost;
                }
                else
                {
                    theoreticalMonthlyRevenue = Math.Round((decimal)(monthlyAccrualDays * dailyRevenueRateDouble), 2);
                    theoreticalMonthlyCost = Math.Round((decimal)(monthlyAccrualDays * dailyCostRateDouble), 2);
                }

                // 2. Gestione visualizzazione vs accumulo
                if (currentMonthStart < currentMonthThreshold)
                {
                    // Accumulo ma non aggiungo alla lista
                    accumulatedRevenue += theoreticalMonthlyRevenue;
                    accumulatedCost += theoreticalMonthlyCost;

                    // Sottraggo comunque dal residuo per mantenere il calcolo sincronizzato
                    remainingRevenue -= theoreticalMonthlyRevenue;
                    remainingCost -= theoreticalMonthlyCost;
                }
                else
                {
                    decimal displayRevenue = theoreticalMonthlyRevenue;
                    decimal displayCost = theoreticalMonthlyCost;

                    // Se è la prima riga visibile, aggiungo l'accumulato
                    if (results.Count == 0)
                    {
                        displayRevenue += accumulatedRevenue;
                        displayCost += accumulatedCost;
                    }

                    results.Add(new AccrualResult
                    {
                        Year = currentMonthStart.Year,
                        Month = currentMonthStart.Month,
                        Revenue = displayRevenue,
                        Cost = displayCost,
                        DailyRevenueRate = Math.Round((decimal)dailyRevenueRateDouble, 4),
                        DailyCostRate = Math.Round((decimal)dailyCostRateDouble, 4),
                        AccrualDays = monthlyAccrualDays
                    });

                    // Sottraggo dal residuo il valore teorico (l'accumulato è già stato sottratto prima)
                    remainingRevenue -= theoreticalMonthlyRevenue;
                    remainingCost -= theoreticalMonthlyCost;
                }
            }
            currentMonthStart = currentMonthStart.AddMonths(1);
        }

        return results;
    }

    ///// <summary>
    ///// Provides methods for calculating monthly accruals of revenue and cost over a specified date range.
    ///// </summary>
    ///// <remarks>This class is designed to calculate monthly accruals by distributing the total revenue and
    ///// cost  proportionally across the days in the specified date range. The calculation accounts for partial  months
    ///// at the start and end of the range, ensuring accurate allocation.</remarks>
    //public static class AccrualCalculator
    //{
    //    public static List<AccrualResult> CalculateMonthlyAccrual(
    //    DateTime startDate,
    //    DateTime endDate,
    //    decimal totalRevenue,
    //    decimal totalCost)
    //    {
    //        var results = new List<AccrualResult>();
    //        // ... (Calcolo totalContractDays e tassi giornalieri, rimasto invariato) ...

    //        int totalContractDays = (int)(endDate - startDate).TotalDays + 1;
    //        if (totalContractDays <= 0) return results;

    //        double dailyRevenueRateDouble = (double)totalRevenue / totalContractDays;
    //        double dailyCostRateDouble = (double)totalCost / totalContractDays;

    //        decimal dailyRevenueRate = Math.Round((decimal)dailyRevenueRateDouble, 4);
    //        decimal dailyCostRate = Math.Round((decimal)dailyCostRateDouble, 4);

    //        DateTime currentMonthStart = new DateTime(startDate.Year, startDate.Month, 1);
    //        decimal remainingRevenue = totalRevenue;
    //        decimal remainingCost = totalCost;
    //        int remainingDays = totalContractDays;

    //        while (currentMonthStart <= endDate)
    //        {
    //            // 3. Calcolo Finestra Temporale del Mese Corrente

    //            // Data di inizio dell'accrual del mese: MAX tra la data di inizio contratto e l'inizio del mese
    //            DateTime accrualStart = (currentMonthStart > startDate) ? currentMonthStart : startDate;

    //            // Data di fine naturale del MESE (es. 30/11/2025)
    //            // Uso AddDays(0) per gestire l'inizio/fine mese correttamente.
    //            DateTime naturalMonthEnd = currentMonthStart.AddMonths(1).AddDays(-1);

    //            // Data di fine dell'accrual del mese: MIN tra la fine del contratto e la fine naturale del mese
    //            DateTime accrualEnd = (naturalMonthEnd < endDate) ? naturalMonthEnd : endDate;

    //            // 4. Calcolo Giorni Effettivi di Accrual per il Mese
    //            // Se accrualStart > accrualEnd, il risultato è 0
    //            int monthlyAccrualDays = (int)(accrualEnd - accrualStart).TotalDays + 1;

    //            // ... (resto del ciclo e assegnazione dei risultati, rimasto invariato) ...

    //            if (monthlyAccrualDays > 0)
    //            {
    //                decimal monthlyRevenue;
    //                decimal monthlyCost;

    //                // Logica per Bilanciare l'Errore di Arrotondamento all'Ultimo Mese
    //                if (currentMonthStart.Year == endDate.Year && currentMonthStart.Month == endDate.Month)
    //                {
    //                    monthlyRevenue = remainingRevenue;
    //                    monthlyCost = remainingCost;
    //                }
    //                else
    //                {
    //                    monthlyRevenue = Math.Round((decimal)(monthlyAccrualDays * dailyRevenueRateDouble), 2);
    //                    monthlyCost = Math.Round((decimal)(monthlyAccrualDays * dailyCostRateDouble), 2);

    //                    remainingRevenue -= monthlyRevenue;
    //                    remainingCost -= monthlyCost;
    //                    remainingDays -= monthlyAccrualDays;
    //                }

    //                results.Add(new AccrualResult
    //                {
    //                    Year = currentMonthStart.Year,
    //                    Month = currentMonthStart.Month,
    //                    Revenue = monthlyRevenue,
    //                    Cost = monthlyCost,

    //                    DailyRevenueRate = dailyRevenueRate,
    //                    DailyCostRate = dailyCostRate,
    //                    AccrualDays = monthlyAccrualDays
    //                });
    //            }

    //            // Passa al mese successivo
    //            currentMonthStart = currentMonthStart.AddMonths(1);
    //        }

    //        return results;
    //    }
    //}

    /// <summary>
    /// Recupera il ProjectCode dalla TextBox nel FormView
    /// </summary>
    /// <returns></returns>
    private string GetProjectCodeFromForm()
    {
        // Cerca la TextBox del ProjectCode
        System.Web.UI.WebControls.TextBox txtProjectCode = (System.Web.UI.WebControls.TextBox)FVProgetto.FindControl("TBProgetto");

        // Recupera il valore, usando sintassi compatibile C# 5
        string projectCode = (txtProjectCode != null) ? txtProjectCode.Text : string.Empty;

        return projectCode;
    }

    /// <summary>
    /// inserimento nel DB dei ratei calcolati
    /// </summary>
    /// <param name="projectsId"></param>
    /// <param name="accrualList"></param>
    /// <exception cref="ConfigurationErrorsException"></exception>
    private void InserisciAccrualNelDB(string projectCode, List<AccrualResult> accrualList)
    {
        // ... (Logica di recupero Connection String, compatibile C# 5) ...s
        string connectionStringName = "MSSql12155ConnectionString";
        string tableName = "Monthly_Fee";
        string createdBy = CurrentSession.UserId.ToString();

        System.Configuration.ConnectionStringSettings connectionSection =
            ConfigurationManager.ConnectionStrings[connectionStringName];

        string connectionString = (connectionSection != null)
                                  ? connectionSection.ConnectionString
                                  : null;

        if (string.IsNullOrEmpty(connectionString))
        {
            throw new ConfigurationErrorsException("La stringa di connessione '" + connectionStringName + "' non è stata trovata.");
        }

        using (SqlConnection conn = new SqlConnection(connectionString))
        {
            conn.Open();

            // *** A. RETRIEVE Projects_id, DataInizio, DataFine DAL DB USANDO ProjectCode ***
            string selectQuery = "SELECT Projects_id, DataInizio, DataFine FROM Projects WHERE ProjectCode = @ProjectCode";
            int projectsId = 0;
            // Uso nullable DateTime per gestire correttamente i NULL
            DateTime? dataInizio = null;
            DateTime? dataFine = null;

            using (SqlCommand cmdSelect = new SqlCommand(selectQuery, conn))
            {
                cmdSelect.Parameters.AddWithValue("@ProjectCode", projectCode);

                using (SqlDataReader reader = cmdSelect.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        projectsId = Convert.ToInt32(reader["Projects_id"]);

                        // Recupera le date del progetto (potrebbero essere NULL)
                        if (reader["DataInizio"] != DBNull.Value)
                            dataInizio = Convert.ToDateTime(reader["DataInizio"]);

                        if (reader["DataFine"] != DBNull.Value)
                            dataFine = Convert.ToDateTime(reader["DataFine"]);
                    }
                }
            }

            // Se l'ID non è stato trovato, usciamo (non dovrebbe accadere dopo un insert/update)
            if (projectsId <= 0)
            {
                // Potresti voler loggare questo errore
                return;
            }

            // *** B. ELIMINAZIONE DEI VECCHI RATEI (Usando projectsId) ***
            string deleteQuery = string.Format("DELETE FROM {0} WHERE Projects_id = @ProjectsId", tableName);

            using (SqlCommand cmdDelete = new SqlCommand(deleteQuery, conn))
            {
                cmdDelete.Parameters.AddWithValue("@ProjectsId", projectsId);
                cmdDelete.ExecuteNonQuery();
            }

            // *** C. INSERIMENTO DEI NUOVI RATEI (Usando projectsId) ***
            string insertQuery = string.Format(
                @"INSERT INTO {0} 
                (Projects_id, [ProjectCode], [Monthly_Fee_Code], [Year], [Month], Revenue, Cost, [Days], Day_Revenue, Day_Cost, 
                 DataInizio, DataFine, CreatedBy, CreationDate, LastModifiedBy, LastModificationDate, Active) 
                SELECT 
                 @ProjectsId, 
                 @ProjectCode, 
                 -- Generazione dinamica del codice con suffisso progressivo
                 @ProjectCode + '_' + CAST(@Year AS VARCHAR) + '_' + CAST(@Month AS VARCHAR) + '_' + 
                 CAST((SELECT ISNULL(COUNT(*), 0) + 1 
                       FROM {0} 
                       WHERE ProjectCode = @ProjectCode AND [Year] = @Year AND [Month] = @Month) AS VARCHAR),
                 @Year, 
                 @Month, 
                 @Revenue, 
                 @Cost, 
                 @Days, 
                 @Day_Revenue, 
                 @Day_Cost, 
                 @DataInizio,
                 @DataFine,
                 @CreatedBy, 
                 GETDATE(), 
                 @LastModifiedBy, 
                 GETDATE(), 
                 1", tableName);

            foreach (var accrual in accrualList)
            {
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    // Mappatura con i parametri SQL
                    cmd.Parameters.AddWithValue("@ProjectsId", projectsId); // Usa l'ID recuperato!
                    cmd.Parameters.AddWithValue("@ProjectCode", projectCode); // Usa l'ID recuperato!
                    cmd.Parameters.AddWithValue("@Monthly_Fee_Code", projectCode + "_" + accrual.Year + "_" + accrual.Month);
                    cmd.Parameters.AddWithValue("@Year", accrual.Year);
                    cmd.Parameters.AddWithValue("@Month", accrual.Month);
                    cmd.Parameters.AddWithValue("@Revenue", accrual.Revenue);
                    cmd.Parameters.AddWithValue("@Cost", accrual.Cost);
                    cmd.Parameters.AddWithValue("@Days", accrual.AccrualDays);
                    cmd.Parameters.AddWithValue("@Day_Revenue", accrual.DailyRevenueRate);
                    cmd.Parameters.AddWithValue("@Day_Cost", accrual.DailyCostRate);

                    // NUOVA LOGICA: Popola DataInizio e DataFine dal progetto
                    // Gestione corretta dei NULL per evitare errori SQL Server (DateTime min = 1753)
                    cmd.Parameters.AddWithValue("@DataInizio",
                        dataInizio.HasValue ? (object)dataInizio.Value : DBNull.Value);
                    cmd.Parameters.AddWithValue("@DataFine",
                        dataFine.HasValue ? (object)dataFine.Value : DBNull.Value);

                    cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
                    cmd.Parameters.AddWithValue("@LastModifiedBy", createdBy);

                    cmd.ExecuteNonQuery();
                }
            }
        }
    }


    // adattamento dinamico delle etichette Budget in base al Tipo di Progetto
    protected void DDLTipoProgetto_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Recupera la DDL
        DropDownList ddl = (DropDownList)sender;
        string selectedValue = ddl.SelectedValue;

        // Trova il DIV del header Ricavi usando la classe HtmlGenericControl
        // NOTA: Il DIV deve avere runat="server" nel file .aspx
        System.Web.UI.HtmlControls.HtmlGenericControl divRevenueHeader =
            (System.Web.UI.HtmlControls.HtmlGenericControl)FVProgetto.FindControl("lbRevenueBudgetTextBox");


        // ----------------------------------------------------
        // LOGICA CAMBIO TESTO DIV RICAVI
        // ----------------------------------------------------

        if (divRevenueHeader != null)
        {
            if (selectedValue == "resale")
            {
                // Selezionato "resale", imposta il testo su "Ricavi: "
                divRevenueHeader.InnerText = "Ricavi: ";
            }
            else
            {
                // Altrimenti, imposta il testo su "Revenue: "
                divRevenueHeader.InnerText = "Revenue: ";
            }
        }

        // ----------------------------------------------------
        // LOGICA AGGIUNTIVA PER I COSTI/SPESE (Esempio)
        // ----------------------------------------------------

        // Se devi modificare anche il DIV delle Spese:
        System.Web.UI.HtmlControls.HtmlGenericControl divCostHeader =
            (System.Web.UI.HtmlControls.HtmlGenericControl)FVProgetto.FindControl("lbSpeseBudgetTextBox");

        if (divCostHeader != null)
        {
            if (selectedValue == "resale")
            {
                divCostHeader.InnerText = "Costi Reali: ";
            }
            else
            {
                divCostHeader.InnerText = "Spese: ";
            }
        }

        // NOTA: La logica di blocco campo Tipo Progetto e readonly Revenue/Costi
        // viene gestita solo in Edit mode tramite il metodo Bind_DDL.
        // Durante Insert mode, l'utente deve poter cambiare liberamente il tipo progetto.        
    }
    #endregion
}