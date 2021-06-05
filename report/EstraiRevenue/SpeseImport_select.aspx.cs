using System;
using System.Data;
using System.Configuration;
using System.IO;
using ExcelDataReader;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;

public partial class SFimport_select : System.Web.UI.Page
{
    static int TrProjectIdIndex;
    static int OpportunityIdIndex;
    static int OpportunityNameIndex;
    static int EngagementTypeIndex;
    static int AmountIndex;
    static int ExpectedMarginIndex;
    static int ExpectedFulfillmentDateIndex;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Response.Cache.SetCacheability(HttpCacheability.NoCache); // per evitare ripetizione messaggio popup di cancellazione
        Response.Cache.SetAllowResponseInBrowserHistory(false);

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
            ASPcompatility.SelectAnnoMese(ref DDLAnnoMese, 5, 1);             /* Popola dropdown con i valori        */

    }

    //
    // Richiamato dal bottone "Esegui"
    //
    protected void Sottometti_Click(object sender, EventArgs e)
    {

        DataTable dtImportData = null;
        DataTable dtResult;
        String sErrorMessage = "";

        if (!FileUpload.HasFile)
            return;
        else
        {
            dtImportData = Utilities.ImportExcel(FileUpload, ref sErrorMessage);
            if (dtImportData == null)
            {
                Page lPage = this.Page;
                Utilities.CreateMessageAlert(ref lPage, "Errore in caricamento: " + sErrorMessage, "");
                return;
            }
        }

        // Inizializza valori colonne in base al nome dei campi
        //ConfigReportColumns(dtSFdata);

        // Crea tabella per memorizzare confronto
        dtResult = CreateDataTable();

        // Check data: verifica dati
        // E900 : Progetto TR non trovato
        // E910 : Formato non valido
        // E000 : Tutti i dati coincidono
        dtResult = CheckImportData(dtImportData, dtResult);

        // sort
        DataView dv = dtResult.DefaultView;
        dv.Sort = "ProcessingStatus ASC, ProjectCode ";
        DataTable dtResultSorted = dv.ToTable();

        // salva i risultati e chiama la pagina di display
        Session["dtResult"] = dtResultSorted;
        Response.Redirect("/timereport/report/EstraiRevenue/SpeseImport_list.aspx");

    }

    //
    // Costruisce la tabella risultato
    //
    protected DataTable CheckImportData(DataTable dt, DataTable dtResult)
    {

        DataRow drCheck;
        DataRow drTR;
        int iStartRow = 1;

        double price;
        bool isDouble;
        Regex rgx = new Regex(@"^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$");

        if (CBSkipFirstRow.Checked)
            iStartRow = 1;
        else
            iStartRow = 0;

        for (int i = iStartRow; i < dt.Rows.Count; i++)
        {

            string sProjectCode = (string)dt.Rows[i][0];  // indice 0 c'è il codice progetto

            if (sProjectCode == "")
                continue;

            drCheck = dtResult.NewRow();
            drCheck["RevenueVersionCode"] = DDLRevenueVersion.SelectedValue;
            drCheck["AnnoMese"] = DDLAnnoMese.SelectedValue; ;
            drCheck["ProjectCode"] = sProjectCode;

            // cerca se esiste un codice progetto attivo
            drTR = Database.GetRow("SELECT projects_id, name FROM Projects WHERE ProjectCode = " + ASPcompatility.FormatStringDb(sProjectCode), null);

            if (drTR == null)  // progetto non trovato
            {
                drCheck["ProcessingStatus"] = "E900";
                drCheck["ProcessingMessage"] = "Progetto non trovato";
                dtResult.Rows.Add(drCheck);
                continue;
            }

            drCheck["ProjectsId"] = drTR["projects_id"];
            drCheck["ProjectName"] = drTR["name"];

            // verifica formato spese sia un numero
            drCheck["RevenueSpese"] = dt.Rows[i][1]; // indice 1 del file ci sono le spese
            isDouble = Double.TryParse(drCheck["RevenueSpese"].ToString(), out price);
            if (!isDouble)
            {
                drCheck["ProcessingStatus"] = "E910";
                drCheck["ProcessingMessage"] = "Formato spese non corretto";
            }

            // verifica che non sia già presente una spesa per lo stesso progetto / periodo
            if (Database.RecordEsiste("SELECT * FROM RevenueProgetto WHERE TipoRecord='M' AND CodiceProgetto = " + ASPcompatility.FormatStringDb(sProjectCode) +
                                       " AND RevenueVersionCode = " + ASPcompatility.FormatStringDb(DDLRevenueVersion.SelectedValue) +
                                       " AND AnnoMese=" + ASPcompatility.FormatStringDb(DDLAnnoMese.SelectedValue), null))
            {
                drCheck["ProcessingStatus"] = "E920";
                drCheck["ProcessingMessage"] = "Spesa già caricata per il progetto";
            }


            if (drCheck["ProcessingStatus"].ToString() == "")
            {
                drCheck["RevenueSpese"] = price.ToString("0.00");
                drCheck["ProcessingStatus"] = "W000";
            }

            dtResult.Rows.Add(drCheck);

        }

        return dtResult;
    }

    //
    // Crea la tabella risultato
    //
    protected DataTable CreateDataTable()
    {

        DataTable dt = new DataTable("Results");

        // Codice Errore
        dt.Columns.Add(CreateColumn("string", "ProcessingStatus", "Processing Status"));

        // Colonne Excel
        dt.Columns.Add(CreateColumn("string", "ProjectCode", "Project Code"));
        dt.Columns.Add(CreateColumn("string", "ProjectName", "Description"));
        dt.Columns.Add(CreateColumn("string", "ProjectsId", "TR Project ID"));

        dt.Columns.Add(CreateColumn("string", "AnnoMese", "Periodo"));
        dt.Columns.Add(CreateColumn("string", "RevenueVersionCode", "Versione"));


        dt.Columns.Add(CreateColumn("double", "RevenueSpese", "Revenue Spese"));

        dt.Columns.Add(CreateColumn("string", "ProcessingMessage", "Processing Message"));

        return dt;
    }


    //
    // Aggiunge una colonna
    //
    protected DataColumn CreateColumn(string sType, string sField, string sName)
    {

        DataColumn dtColumn;
        dtColumn = new DataColumn();
        switch (sType)
        {
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

    // Lettura file excel
    // Richiede installazione del paccheto ExcelDataReader.DataSet
    // VS Package Manager Console Install-Package <package>
    // https://github.com/ExcelDataReader/ExcelDataReader
    //protected DataTable LeggiFileExcel()
    //{

    //    DataTable dtResult = null;

    //    try
    //    {
    //        string FileName = Path.GetFileName(FileUpload.PostedFile.FileName);
    //        string Extension = Path.GetExtension(FileUpload.PostedFile.FileName);
    //        string FolderPath = ConfigurationManager.AppSettings["FolderPath"];
    //        string FilePath = Server.MapPath(FolderPath + FileName);
    //        FileUpload.SaveAs(FilePath);

    //        using (var stream = File.Open(FilePath, FileMode.Open, FileAccess.Read))
    //        {
    //            // Auto-detect format, supports:
    //            //  - Binary Excel files (2.0-2003 format; *.xls)
    //            //  - OpenXml Excel files (2007 format; *.xlsx)
    //            using (var reader = ExcelReaderFactory.CreateReader(stream))
    //            {
    //                // Choose one of either 1 or 2:
    //                dtResult = reader.AsDataSet().Tables[0];

    //                // The result of each spreadsheet is in result.Tables
    //            }
    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        ClientScript.RegisterStartupScript(Page.GetType(), "ErrorMessage", "<script language=JavaScript>alert('" + ex.Message + "');</script>", true);
    //    }

    //    return dtResult;
    //}


}