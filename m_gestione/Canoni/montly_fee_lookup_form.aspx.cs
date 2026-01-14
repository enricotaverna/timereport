using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class m_gestione_Canoni_montly_fee_lookup_form : System.Web.UI.Page
{

    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
    
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack )
        {

            // Memorizza l'URL di provenienza nel ViewState
            if (Request.UrlReferrer != null)
                ViewState["prevPage"] = Request.UrlReferrer.ToString();
            else
                ViewState["prevPage"] = "montly_fee_lookup_list.aspx"; // Ritorno di sicurezza

            // Logica per il cambio modalità (Insert/Edit)
            if (!string.IsNullOrEmpty(Request.QueryString["Monthly_Fee_id"]))
                FVCanoni.DefaultMode = FormViewMode.Edit;
            else
                FVCanoni.DefaultMode = FormViewMode.Insert;

        }

        //popola dropdownlist progetto
        LoadDDLprogetto();
    }

    protected void FVCanoni_DataBound(object sender, EventArgs e)
    {
        // 1. Cerchiamo la DropDown in qualsiasi modalità (Insert o Edit)
        DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");

        if (ddlList != null)
        {
            // 1. Pulizia totale per evitare duplicati
            ddlList.Items.Clear();

            // 2. Carichiamo i dati dal Database
            conn.Open();
            string sqlCmd;

            if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
                sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Projects.Name,20) as iProgetto from Projects " +
                        "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = Projects.ProjectType_Id " +
                        "LEFT JOIN TipoContratto ON TipoContratto.TipoContratto_id = Projects.TipoContratto_id " +
                        "WHERE active = 1 AND TipoContratto.Descrizione = 'FORFAIT' AND ProjectType.Name = 'Resale' AND ClientManager_id = " + CurrentSession.Persons_id + " ORDER BY iProgetto";
            else
                sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Projects.Name,20) as iProgetto from Projects " +
                        "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = Projects.ProjectType_Id " +
                        "LEFT JOIN TipoContratto ON TipoContratto.TipoContratto_id = Projects.TipoContratto_id " +
                        "where active = 1 AND TipoContratto.Descrizione = 'FORFAIT' AND ProjectType.Name = 'Resale' ORDER BY iProgetto";

            SqlCommand cmd = new SqlCommand(sqlCmd, conn);
            SqlDataReader dr = cmd.ExecuteReader();

            // 3. Popoliamo la lista
            ddlList.DataSource = dr;
            ddlList.DataTextField = "iProgetto";
            ddlList.DataValueField = "Projects_id";
            ddlList.DataBind();
            conn.Close();

            // 4. Inseriamo l'elemento vuoto in posizione 0 (SOLO UNA VOLTA)
            ddlList.Items.Insert(0, new ListItem("--Seleziona progetto--", ""));

            // 5. Gestione selezione in modalità Edit
            if (FVCanoni.CurrentMode == FormViewMode.Edit)
            {
                DataRowView drv = (DataRowView)FVCanoni.DataItem;
                if (drv != null && drv["Projects_id"] != DBNull.Value)
                {
                    string currentProjectId = drv["Projects_id"].ToString();
                    if (ddlList.Items.FindByValue(currentProjectId) != null)
                    {
                        ddlList.SelectedValue = currentProjectId;
                    }
                }
            }
        }
    }

    protected void LoadDDLprogetto()
    {
        //    conn.Open();
        //string sqlCmd;

        //    // visualizza solo progetti del manager
        //    if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        //        sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Projects.Name,20) as iProgetto from Projects " +
        //        "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = Projects.ProjectType_Id " +
        //        "LEFT JOIN TipoContratto ON TipoContratto.TipoContratto_id = Projects.TipoContratto_id " +
        //        "WHERE active = 1 AND TipoContratto.Descrizione = 'FORFAIT' AND ProjectType.Name = 'Resale' AND ClientManager_id = " + CurrentSession.Persons_id + " ORDER BY iProgetto";
        //    else
        //        sqlCmd = "Select Projects_id, ProjectCode + ' ' + left(Projects.Name,20) as iProgetto from Projects " +
        //        "LEFT JOIN ProjectType ON ProjectType.ProjectType_Id = Projects.ProjectType_Id " +
        //        "LEFT JOIN TipoContratto ON TipoContratto.TipoContratto_id = Projects.TipoContratto_id " +
        //        "where active = 1 AND TipoContratto.Descrizione = 'FORFAIT' AND ProjectType.Name = 'Resale' ORDER BY iProgetto";

        //    SqlCommand cmd = new SqlCommand(sqlCmd, conn);
        
        //    SqlDataReader dr = cmd.ExecuteReader();
        //    DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");

        //    ddlList.DataSource = dr;
        //    ddlList.Items.Clear();
        //    ddlList.Items.Add(new ListItem("--Seleziona progetto--", ""));
            
        //    ddlList.DataTextField = "iProgetto";
        //    ddlList.DataValueField = "Projects_id";
        //    if ( Request.QueryString["Projects_id"] != null ) // in caso di update seleziona il valore nella dropdown list
        //        ddlList.SelectedValue = Request.QueryString["Projects_id"].ToString();
        //    ddlList.DataBind();
        //    conn.Close();
            
    }

    protected void ItemUpdating_FVCanoni(object sender, FormViewUpdateEventArgs e)
    {
        //      Forza i valori da passare alla select di insert. essendo le dropdown in
        //      dipendenza non si riesce a farlo tramite un normale bind del controllo

        DropDownList ddlList = (DropDownList)FVCanoni.FindControl("DDLprogetto");
        e.NewValues["Projects_id"] = ddlList.SelectedValue;

        // 2. Inserisci il valore della persona loggata nella collezione dei parametri
        // Assumendo che la tua proprietà sia CurrentSession.UserName
        DSCanoni.UpdateParameters["CreatedBy"].DefaultValue = CurrentSession.UserName;
    }

    protected void ItemInserting_FVCanoni(object sender, FormViewInsertEventArgs e)
    {
        // 1. Recupero riferimenti ai controlli nel template
        DropDownList ddl = (DropDownList)FVCanoni.FindControl("DDLprogetto");
        TextBox txtYear = (TextBox)FVCanoni.FindControl("YearUPD");
        TextBox txtMonth = (TextBox)FVCanoni.FindControl("MonthUPD");

        if (ddl != null && ddl.SelectedIndex > 0)
        {
            // 2. Estrazione ProjectCode dal testo della DropDownList (es: "PRJ001 - Nome Progetto")
            string fullText = ddl.SelectedItem.Text;
            string projectCode = fullText.Split('-')[0].Trim();
            e.Values["ProjectCode"] = projectCode; // Valorizza la nuova colonna ProjectCode

            // 3. Determinazione Anno e Mese (se non inseriti dall'utente)
            string yearStr = !string.IsNullOrEmpty(txtYear.Text) ? txtYear.Text : DateTime.Now.Year.ToString();
            string monthStr = !string.IsNullOrEmpty(txtMonth.Text) ? txtMonth.Text : DateTime.Now.Month.ToString();

            // Assegnazione valori puliti per il database
            e.Values["Year"] = Convert.ToInt32(yearStr);
            e.Values["Month"] = Convert.ToInt32(monthStr);
            e.Values["Projects_id"] = ddl.SelectedValue;

            // 4. Calcolo del progressivo per Monthly_Fee_Code
            // Chiama la funzione GetNextProgressivo (definita sotto)
            int progressivo = GetNextProgressivo(ddl.SelectedValue, yearStr);

            // Composizione finale: PRJ001-2026-001
            e.Values["Monthly_Fee_Code"] = string.Format("{0}_{1}_{2}", projectCode.Split(' ')[0], yearStr, progressivo.ToString());
        }
        CheckBox chk = (CheckBox)FVCanoni.FindControl("CheckBox1");
        e.Values["active"] = (chk != null) ? chk.Checked : true;

        e.Values["CreatedBy"] = CurrentSession.UserId;

        // 5. Gestione dei campi decimali con maschera (1.250,00 -> 1250.00)
        HandleDecimalFields(e);
    }

    // Funzione di supporto per il calcolo del progressivo
    private int GetNextProgressivo(string projectId, string year)
    {
        int nextId = 1;
        string connString = ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            // Conta i record esistenti per quel progetto e anno per generare il progressivo
            string sql = "SELECT COUNT(*) + 1 FROM Monthly_Fee WHERE Projects_id = @pid AND Year = @year";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@pid", projectId);
            cmd.Parameters.AddWithValue("@year", year);

            conn.Open();
            nextId = (int)cmd.ExecuteScalar();
        }
        return nextId;
    }

    // Funzione di supporto per la pulizia dei decimali
    private void HandleDecimalFields(FormViewInsertEventArgs e)
    {
        string[] monetaryFields = { "Revenue", "Cost" };
        foreach (string field in monetaryFields)
        {
            if (e.Values[field] != null && !string.IsNullOrEmpty(e.Values[field].ToString()))
            {
                string cleanValue = e.Values[field].ToString().Replace(".", "").Replace(",", ".");
                e.Values[field] = Convert.ToDecimal(cleanValue, System.Globalization.CultureInfo.InvariantCulture);
            }
            else
            {
                e.Values[field] = 0m;
            }
        }
    }

    protected void ItemInserted_FVCanoni(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception == null)
        {
            // Se arrivi qui, la INSERT è partita ed è andata a buon fine
            Response.Redirect("montly_fee_lookup_list.aspx");
        }
        else
        {
            // Se arrivi qui, la INSERT è partita ma il DATABASE ha dato errore
            // Questo scriverà l'errore SQL nella parte alta della pagina
            Response.Write("<script>alert('Errore SQL: " + e.Exception.Message.Replace("'", "") + "');</script>");
            e.ExceptionHandled = true;
        }

        //Response.Redirect("montly_fee_lookup_list.aspx");
    }
    protected void ItemUpdated_FVCanoni(object sender, FormViewUpdatedEventArgs e)
    {
        // 1. Controlla se ci sono state eccezioni (errori SQL) durante l'update
        if (e.Exception == null)
        {
            // 2. Recupera l'URL dal ViewState. Se è nullo, usa la pagina della lista come default
            string targetUrl = ViewState["prevPage"] != null ? ViewState["prevPage"].ToString() : "montly_fee_lookup_list.aspx";

            // 3. Esegui il redirect
            Response.Redirect(targetUrl);
        }
        else
        {
            // Se c'è un errore, l'utente resta sulla pagina per vedere il messaggio
            // Impedisce che l'eccezione blocchi l'applicazione
            e.ExceptionHandled = true;
        }
    }
    protected void ItemModeChanging_FVCanoni(object sender, FormViewModeEventArgs e)
    {
        if (e.CancelingEdit)
        {
            string targetUrl = ViewState["prevPage"] != null ? ViewState["prevPage"].ToString() : "montly_fee_lookup_list.aspx";

            // Se targetUrl è la pagina stessa, forza il ritorno alla lista per evitare loop
            if (targetUrl.Contains(Request.Url.AbsolutePath))
            {
                targetUrl = "montly_fee_lookup_list.aspx";
            }

            Response.Redirect(targetUrl);
        }
    }

    protected void ItemDeleted_FVCanoni(object sender, FormViewDeletedEventArgs e)
    {
        if (e.Exception == null)
        {
            // Successo: torna alla lista
            Response.Redirect("montly_fee_lookup_list.aspx");
        }
        else
        {
            // Errore (ad esempio se il record è collegato ad altre tabelle)
            Response.Write("<script>alert('Errore durante l'eliminazione: " + e.Exception.Message.Replace("'", "") + "');</script>");
            e.ExceptionHandled = true;
        }
    }

}

