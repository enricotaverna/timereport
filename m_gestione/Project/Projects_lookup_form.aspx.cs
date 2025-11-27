using Amazon.EC2.Model;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Project_Projects_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Autorizzazione su tutti o sui progetti assegnati
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
            Auth.CheckPermission("MASTERDATA", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            if (Request.QueryString["Projectcode"] != null)
            {
                FVProgetto.ChangeMode(FormViewMode.Edit);
                FVProgetto.DefaultMode = FormViewMode.Edit;
            }
            else
            {
                // Set default value for DDLVisibility
                DropDownList ddlVisibility = (DropDownList)FVProgetto.FindControl("DDLVisibility");
                ddlVisibility.SelectedValue = ConfigurationManager.AppSettings["SOLO_AUTORIZZATI"];
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
            // 1. Recupera il codice appena inserito
            string projectCode = GetProjectCodeFromForm();

            // 2. Esegue il calcolo e ottiene la lista dei ratei
            List<AccrualResult> accrualList = eseguiCalcoloCanone();

            // 3. Salva i ratei nel DB, PASSANDO L'ID
            InserisciAccrualNelDB(projectCode, accrualList);

            //Response.Redirect("projects_lookup_list.aspx");

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

    #region GridView Canoni Mensili


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

    protected void GridView1_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        System.Web.UI.WebControls.GridView gridCanoni = (System.Web.UI.WebControls.GridView)sender;
        var Monthly_Fee_id = gridCanoni.DataKeys[gridCanoni.SelectedRow.RowIndex].Values[0];
        var ProjectsId = gridCanoni.DataKeys[gridCanoni.SelectedRow.RowIndex].Values[1];

        // Mostra l'errore all'utente
        ClientScript.RegisterStartupScript(
            this.GetType(),
            "ErrorScript",
            "alert('" + errorMessage + "');",
            true);

        Response.Redirect("../Canoni/montly_fee_lookup_form.aspx?Monthly_Fee_id=" + Monthly_Fee_id + "&Projects_Id=" + ProjectsId);
    }

    // Nel tuo file Projects_lookup_form.aspx.cs
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

        List<AccrualResult> accrualList = AccrualCalculator.CalculateMonthlyAccrual(
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

    /// <summary>
    /// Provides methods for calculating monthly accruals of revenue and cost over a specified date range.
    /// </summary>
    /// <remarks>This class is designed to calculate monthly accruals by distributing the total revenue and
    /// cost  proportionally across the days in the specified date range. The calculation accounts for partial  months
    /// at the start and end of the range, ensuring accurate allocation.</remarks>
    public static class AccrualCalculator
    {
        public static List<AccrualResult> CalculateMonthlyAccrual(
        DateTime startDate,
        DateTime endDate,
        decimal totalRevenue,
        decimal totalCost)
        {
            var results = new List<AccrualResult>();
            // ... (Calcolo totalContractDays e tassi giornalieri, rimasto invariato) ...

            int totalContractDays = (int)(endDate - startDate).TotalDays + 1;
            if (totalContractDays <= 0) return results;

            double dailyRevenueRateDouble = (double)totalRevenue / totalContractDays;
            double dailyCostRateDouble = (double)totalCost / totalContractDays;

            decimal dailyRevenueRate = Math.Round((decimal)dailyRevenueRateDouble, 4);
            decimal dailyCostRate = Math.Round((decimal)dailyCostRateDouble, 4);

            DateTime currentMonthStart = new DateTime(startDate.Year, startDate.Month, 1);
            decimal remainingRevenue = totalRevenue;
            decimal remainingCost = totalCost;
            int remainingDays = totalContractDays;

            while (currentMonthStart <= endDate)
            {
                // 3. Calcolo Finestra Temporale del Mese Corrente

                // Data di inizio dell'accrual del mese: MAX tra la data di inizio contratto e l'inizio del mese
                DateTime accrualStart = (currentMonthStart > startDate) ? currentMonthStart : startDate;

                // Data di fine naturale del MESE (es. 30/11/2025)
                // Uso AddDays(0) per gestire l'inizio/fine mese correttamente.
                DateTime naturalMonthEnd = currentMonthStart.AddMonths(1).AddDays(-1);

                // Data di fine dell'accrual del mese: MIN tra la fine del contratto e la fine naturale del mese
                DateTime accrualEnd = (naturalMonthEnd < endDate) ? naturalMonthEnd : endDate;

                // 4. Calcolo Giorni Effettivi di Accrual per il Mese
                // Se accrualStart > accrualEnd, il risultato è 0
                int monthlyAccrualDays = (int)(accrualEnd - accrualStart).TotalDays + 1;

                // ... (resto del ciclo e assegnazione dei risultati, rimasto invariato) ...

                if (monthlyAccrualDays > 0)
                {
                    decimal monthlyRevenue;
                    decimal monthlyCost;

                    // Logica per Bilanciare l'Errore di Arrotondamento all'Ultimo Mese
                    if (currentMonthStart.Year == endDate.Year && currentMonthStart.Month == endDate.Month)
                    {
                        monthlyRevenue = remainingRevenue;
                        monthlyCost = remainingCost;
                    }
                    else
                    {
                        monthlyRevenue = Math.Round((decimal)(monthlyAccrualDays * dailyRevenueRateDouble), 2);
                        monthlyCost = Math.Round((decimal)(monthlyAccrualDays * dailyCostRateDouble), 2);

                        remainingRevenue -= monthlyRevenue;
                        remainingCost -= monthlyCost;
                        remainingDays -= monthlyAccrualDays;
                    }

                    results.Add(new AccrualResult
                    {
                        Year = currentMonthStart.Year,
                        Month = currentMonthStart.Month,
                        Revenue = monthlyRevenue,
                        Cost = monthlyCost,

                        DailyRevenueRate = dailyRevenueRate,
                        DailyCostRate = dailyCostRate,
                        AccrualDays = monthlyAccrualDays
                    });
                }

                // Passa al mese successivo
                currentMonthStart = currentMonthStart.AddMonths(1);
            }

            return results;
        }
    }

    /// <summary>
    /// 
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

            // *** A. RETRIEVE Projects_id DAL DB USANDO ProjectCode ***
            string selectQuery = "SELECT Projects_id FROM Projects WHERE ProjectCode = @ProjectCode";
            int projectsId = 0;

            using (SqlCommand cmdSelect = new SqlCommand(selectQuery, conn))
            {
                cmdSelect.Parameters.AddWithValue("@ProjectCode", projectCode);
                object result = cmdSelect.ExecuteScalar();

                if (result != null && result != DBNull.Value)
                {
                    projectsId = Convert.ToInt32(result);
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
               (Projects_id,[ProjectCode], [Year], [Month], Revenue, Cost, [Days], Day_Revenue, Day_Cost, 
                CreatedBy, CreationDate, LastModifiedBy, LastModificationDate, Active) 
             VALUES 
               (@ProjectsId,@ProjectCode, @Year, @Month, @Revenue, @Cost, @Days, @Day_Revenue, @Day_Cost, 
                @CreatedBy, GETDATE(), @LastModifiedBy, GETDATE(), 1)", tableName);

            foreach (var accrual in accrualList)
            {
                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    // Mappatura con i parametri SQL
                    cmd.Parameters.AddWithValue("@ProjectsId", projectsId); // Usa l'ID recuperato!
                    cmd.Parameters.AddWithValue("@ProjectCode", projectCode); // Usa l'ID recuperato!
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
    #endregion
}