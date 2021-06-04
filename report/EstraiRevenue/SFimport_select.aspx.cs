using System;
using System.Data;
using System.Configuration;
using System.IO;
using ExcelDataReader;
using System.Text.RegularExpressions;
using System.Linq;

public partial class SFimport_select : System.Web.UI.Page
{
    static int TrProjectIdIndex;
    static int OpportunityIdIndex;
    static int OpportunityNameIndex;
    static int EngagementTypeIndex;
    static int AmountIndex;
    static int ExpectedMarginIndex;
    static int ExpectedFulfillmentDateIndex;
    static DataTable dtFiltraMese;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];
    }

    //
    // Richiamato dal bottone "Esegui"
    // 1. LeggiFileExcel: Legge file
    // 2. ConfigReportColumns: Determina le colonne da estrarre in base al nome dell'intestazione
    // 3. CreateDataTable: Crea la tabella per contenere risultato del confronto
    // 4. CheckSFData: Loop sulle righe e confronta i risultati
    //                 --- > richiama FillTRData dove esegue confronti riga x riga sul TR
    //
    protected void Sottometti_Click(object sender , System.EventArgs e ) {

        DataTable dtSFdata = null;
        DataTable dtResult;

        if (!FileUpload.HasFile)
            return;
        else
            dtSFdata = LeggiFileExcel();

        // Inizializza valori colonne in base al nome dei campi
        ConfigReportColumns(dtSFdata);

        // Crea tabella per memorizzare confronto
        dtResult = CreateDataTable();

        // carica tabella per filtrare record con carichi
        if (DDLImport.SelectedValue != "0")
            dtFiltraMese = CaricaFiltraMese(DDLImport.SelectedValue);

        // Check data: verifica dati
        // A* Dati da aggiornare
        // B* Dati allineati
        // E* Errore
        dtResult  = CheckSFData(dtSFdata, dtResult);

        // sort
        DataView dv = dtResult.DefaultView;
        dv.Sort = "ProcessingStatus ASC, ProjectCode ";
        DataTable dtResultSorted = dv.ToTable();

        // salva i risultati e chiama la pagina di display
        Session["dtResult"] = dtResultSorted;
        Response.Redirect("/timereport/report/EstraiRevenue/SFimport_list.aspx");

        }

    //
    // Loop sulle righe e confronta i dati SF con quelli TR
    //
    protected DataTable CheckSFData(DataTable dt, DataTable dtResult) {

        DataRow drCheck;
        double price;
        bool isDouble;
        Regex rgx = new Regex(@"^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$");

        // loop dalla 2 riga in avanti
        for (int i=1; i < dt.Rows.Count; i++)
        {

            string sProjectCode = (string)dt.Rows[i][TrProjectIdIndex];

            if (sProjectCode == "")
                continue;

            // popola la riga con i dati SF
            drCheck = dtResult.NewRow();
            drCheck["ProjectCode"] = dt.Rows[i][TrProjectIdIndex];
            drCheck["OpportunityId"] = dt.Rows[i][OpportunityIdIndex];
            drCheck["OpportunityName"] = dt.Rows[i][OpportunityNameIndex];

            // controllo che tipo progetto sia T&M o Forfait
            drCheck["SFEngagementType"] = dt.Rows[i][EngagementTypeIndex].ToString().Replace("&", "");
            if (drCheck["SFEngagementType"].ToString() != "TM" && drCheck["SFEngagementType"].ToString() != "Forfait")
            {
                drCheck["ProcessingStatus"] = "E921";
                drCheck["ProcessingMessage"] = "Tipo progetto SF non T&M o Forfait";
            }

            // controllo che Amount sia un numero
            drCheck["SFAmount"] = dt.Rows[i][AmountIndex];

            // verifica se il campo margine SF è di formato corretto
            isDouble = Double.TryParse(drCheck["SFAmount"].ToString(), out price);
            if (!isDouble)
            {
                drCheck["ProcessingStatus"] = "E922";
                drCheck["ProcessingMessage"] = "Importo SF non corretto";
            }
            else
                drCheck["SFAmount"] = price.ToString("N0");

            // verifica se il campo margine SF sia un numero
            drCheck["SFExpectedMargin"] = dt.Rows[i][ExpectedMarginIndex];           
            isDouble = Double.TryParse(drCheck["SFExpectedMargin"].ToString(), out price);
            if (!isDouble)
            {
                drCheck["ProcessingStatus"] = "E923";
                drCheck["ProcessingMessage"] = "Valore margine SF non corretto";
            }

            drCheck["SFExpectedFulfillmentDate"] = dt.Rows[i][ExpectedFulfillmentDateIndex].ToString().Substring(0,10);
            if (!rgx.IsMatch(drCheck["SFExpectedFulfillmentDate"].ToString()) )
            {
                drCheck["ProcessingStatus"] = "E924";
                drCheck["ProcessingMessage"] = "Data SF di fine progetto non corretto";
            }

            // Confrona valori con dati TR
            drCheck = FillTRData(drCheck, sProjectCode);

            if (drCheck["ProcessingStatus"].ToString() != "" )
                dtResult.Rows.Add(drCheck);
        }    

        return dtResult;
    }

    //
    // Confronta i dati SF con quelli del TR
    //
    protected DataRow FillTRData( DataRow drCheck, string sProjectCode)
    {

        DataRow drTR;
        double price;

        drTR = Database.GetRow("SELECT A.Projects_id, A.ProjectCode, A.ProjectType_Id, B.Descrizione as ProjectTypeDesc, A.RevenueBudget, A.DataFine, A.MargineProposta, A.active " +
                           "FROM Projects AS A " +
                           "INNER JOIN TipoContratto as B ON b.TipoContratto_id = A.TipoContratto_id " +
                           "WHERE A.ProjectCode = " + ASPcompatility.FormatStringDb(sProjectCode), null);

        // aggiunge riga con errore
        if (drTR == null)
        {
            drCheck["ProcessingStatus"] = "E900";
            drCheck["ProcessingMessage"] = "Codice progetto non trovato";
            return drCheck;
        }

        // se il progetto è chiuso lo scarta senza ulteriori controlli
        if (drTR["active"].ToString() == "False")
        {
            drCheck["ProcessingStatus"] = "E910";
            drCheck["ProcessingMessage"] = "Progetto TR Chiuso";
            return drCheck;
        }

        // filtra progetti in base al parametro selezionato
        if (DDLImport.SelectedValue != "0") {
            DataRow[] drRow = dtFiltraMese.Select("[projects_id] = " + ASPcompatility.FormatStringDb(drTR["Projects_id"].ToString()));

            if ( drRow.Count() == 0 ) // nessun record trovato, esce con stato blank che non fa accodare il record
                return drCheck;

        }

        // Carica dati TR
        drCheck["TRProjectsId"] = drTR["Projects_id"];

        drCheck["TREngagementType"] = drTR["ProjectTypeDesc"].ToString().Replace("&", "");

        if (drTR["RevenueBudget"].ToString() != "")
        {
            Double.TryParse(drTR["RevenueBudget"].ToString(), out price);
            drCheck["TRAmount"] = price.ToString("N0");
        }

        if (drTR["MargineProposta"].ToString() != "")
            drCheck["TRExpectedMargin"] = Convert.ToDouble(drTR["MargineProposta"]) * 100;
        else
            drCheck["TRExpectedMargin"] = 0;

        if (drTR["DataFine"].ToString() != "")
            drCheck["TRExpectedFulfillmentDate"] = drTR["DataFine"].ToString().Substring(0, 10);
        else
            drCheck["TRExpectedFulfillmentDate"] = "";

        // controlla i dati
        if (drCheck["ProcessingStatus"].ToString() == "")
            if (drCheck["TREngagementType"].ToString() == drCheck["SFEngagementType"].ToString() &&
             drCheck["TRAmount"].ToString() == drCheck["SFAmount"].ToString() &&
             drCheck["TRExpectedMargin"].ToString() == drCheck["SFExpectedMargin"].ToString() &&
             drCheck["TRExpectedFulfillmentDate"].ToString() == drCheck["SFExpectedFulfillmentDate"].ToString())
            {
                drCheck["ProcessingStatus"] = "B000";
                drCheck["ProcessingMessage"] = "Valori coincidono";
            }
            else
            {
                drCheck["ProcessingStatus"] = "A000";
                drCheck["ProcessingMessage"] = "Alcuni valori non coincidono";
            }

        return drCheck;
    }

    //
    // In base al parametro della DDL filtra i progetti che hanno carichi nel mese corrente o precedente
    //
    protected DataTable CaricaFiltraMese(string param ) {

        string DataDa ="", DataA="";
        DateTime today = DateTime.Now;

        if (param == "1")
        { // mese corrente
            DataDa = "01/" + today.Month + "/" + today.Year;
            DataA = DateTime.DaysInMonth(today.Year, today.Month) + "/" + today.Month + "/" + today.Year;
        }

        if (param == "2")
        { // mese precedente
            DateTime LastDateLastMonth = DateTime.Today.AddDays(0 - DateTime.Today.Day);
            DateTime FirstDateLastMonth = LastDateLastMonth.AddDays(1 - LastDateLastMonth.Day);

            DataDa = FirstDateLastMonth.ToString().Substring(0, 10);
            DataA = LastDateLastMonth.ToString().Substring(0, 10);
        }

        DataTable dt = Database.GetData("SELECT projects_id FROM Hours " +
                                        "WHERE date >= " + ASPcompatility.FormatDateDb(DataDa) +
                                        " AND date <= " + ASPcompatility.FormatDateDb(DataA) +
                                        " GROUP BY projects_id " , null);
        return dt;
    }

    //
    // Crea la tabella risultato
    //
    protected DataTable CreateDataTable() {

        DataTable dt = new DataTable("Results");

        // Codice Errore
        dt.Columns.Add(CreateColumn("string", "ProcessingStatus", "Processing Status"));

        // Colonne Excel
        dt.Columns.Add(CreateColumn("string","ProjectCode","Project Code") );
        dt.Columns.Add(CreateColumn("string", "TRProjectsId", "TR Project ID"));
        dt.Columns.Add(CreateColumn("string", "OpportunityId", "Opportunity ID"));
        dt.Columns.Add(CreateColumn("string", "OpportunityName", "Opportunity Name"));
        dt.Columns.Add(CreateColumn("string", "SFEngagementType", "SF Engagement Type"));
        dt.Columns.Add(CreateColumn("string", "TREngagementType", "TR Tipo progetto"));

        dt.Columns.Add(CreateColumn("double", "SFAmount", "SF Amount"));
        dt.Columns.Add(CreateColumn("double", "TRAmount", "TR Amount"));

        dt.Columns.Add(CreateColumn("double", "SFExpectedMargin", "SF Expected Margin"));
        dt.Columns.Add(CreateColumn("double", "TRExpectedMargin", "TR Expected Margin"));

        dt.Columns.Add(CreateColumn("string", "SFExpectedFulfillmentDate", "SF Expected fulfillment date"));
        dt.Columns.Add(CreateColumn("string", "TRExpectedFulfillmentDate", "TR Expected fulfillment date"));

        dt.Columns.Add(CreateColumn("string", "ProcessingMessage", "Processing Message"));

        return dt;
    }

    //
    // Aggiunge una colonna
    //
    protected DataColumn CreateColumn( string sType, string sField, string sName) {

        DataColumn dtColumn;
        dtColumn = new DataColumn();
        switch (sType) {
            case "int":
                dtColumn.DataType = typeof(int);
                break;

            case "string":
                dtColumn.DataType = typeof(string);
                break;

            case "float":
                dtColumn.DataType = typeof(float);
                break;
        }

        dtColumn.ColumnName = sField;
        dtColumn.Caption = sName;

        return dtColumn;
    }

    //  
    // valorizza indici delle colonne per evitare che una modifica del layout
    // del report cambi l'ordine delle colonne
    //
    protected void ConfigReportColumns(DataTable dt)   {

        for (int i = 0; i < dt.Columns.Count ; i++)
            {
            if ( (string)dt.Rows[0][i] == "TR Project ID" )
                TrProjectIdIndex = i;
            if ((string)dt.Rows[0][i] == "Opportunity ID")
                OpportunityIdIndex = i;
            if ((string)dt.Rows[0][i] == "Opportunity Name")
                OpportunityNameIndex = i;
            if ((string)dt.Rows[0][i] == "Engagement Type")
                EngagementTypeIndex = i;
            if ((string)dt.Rows[0][i] == "Amount")
                AmountIndex  = i;
            if ((string)dt.Rows[0][i] == "Expected Margin")
                ExpectedMarginIndex = i;
            if ((string)dt.Rows[0][i] == "Expected fulfillment date")
                ExpectedFulfillmentDateIndex = i;
        }
    }

    // Lettura file excel
    // Richiede installazione del paccheto ExcelDataReader.DataSet
    // VS Package Manager Console Install-Package <package>
    // https://github.com/ExcelDataReader/ExcelDataReader
    protected DataTable LeggiFileExcel()
    {

        DataTable dtResult= null;

        try
        {
            string FileName = Path.GetFileName(FileUpload.PostedFile.FileName);
            string Extension = Path.GetExtension(FileUpload.PostedFile.FileName);
            string FolderPath = ConfigurationManager.AppSettings["FolderPath"];
            string FilePath = Server.MapPath(FolderPath + FileName);
            FileUpload.SaveAs(FilePath);

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
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(Page.GetType(), "ErrorMessage", "<script language=JavaScript>alert('" + ex.Message + "');</script>", true);
        }

        return dtResult;
    }




}