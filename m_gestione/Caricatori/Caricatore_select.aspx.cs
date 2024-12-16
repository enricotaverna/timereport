using System;
using System.Collections.Generic;
using System.Data;
using System.Text.RegularExpressions;
using System.Web.UI;

/*
 * Per aggiungere un caricatore:
 * - Popolare una nuova struttura simile a ColonneProgetti
 * - Aggiornare lo switch (DDLImport.SelectedValue)
 * - In caso di controlli speciali scrivere una funzione come ControlloFLC
 *
 */

public partial class SFimport_select : System.Web.UI.Page
{

    private class Colonna
    {
        public string valore;
        public string valoreId; // in caso di colonne con tabelle di controllo memorizza il valore del campo chiave
        public string tipo;
        public bool mandatory;
        public string controllo;
        public string tabellaControllo; // formato: tabella controllo; campo di ricerca; valore del campo chiave; nome del campo chiave
    };

    private static List<Colonna> ColonneFileInput;

    private static List<Colonna> ColonneProgetti = new List<Colonna>() {
        new Colonna() { valore = "ProjectCode", tipo = "string", mandatory = true ,controllo = "NOT_EXIST", tabellaControllo = "Projects;ProjectCode;ProjectCode" },
        new Colonna() { valore = "Name", tipo = "string"},
        new Colonna() { valore = "ClientManager", tipo = "string", controllo = "EXIST", tabellaControllo = "Persons;Name;Persons_id;ClientManager_id" },
        new Colonna() { valore = "ClientManager_id"},
        new Colonna() { valore = "AccountManager", tipo = "string", controllo = "EXIST", tabellaControllo = "Persons;Name;Persons_id;AccountManager_id" },
        new Colonna() { valore = "AccountManager_id"},
        new Colonna() { valore = "CodiceCliente", tipo = "string", controllo = "EXIST", tabellaControllo = "Customers;Nome1;CodiceCliente;CodiceCliente" },
        new Colonna() { valore = "CopiaConsulentiDa", tipo = "string", controllo = "EXIST", tabellaControllo = "Projects;ProjectCode;Projects_id;CopiaConsulentiDa_id" },
        new Colonna() { valore = "CopiaConsulentiDa_id"},
        new Colonna() { valore = "ProjectType", tipo = "string", controllo = "EXIST", tabellaControllo = "ProjectType;Name;ProjectType_id" },
        new Colonna() { valore = "ProjectType_id"},
        new Colonna() { valore = "LOB", tipo = "string", controllo = "EXIST", tabellaControllo = "Lob;LobCode;LOB_Id;LOB_Id" },
        new Colonna() { valore = "LOB_id"},
        new Colonna() { valore = "Channels", tipo = "string", controllo = "EXIST", tabellaControllo = "Channels;Name;Channels_Id" },
        new Colonna() { valore = "Channels_Id"},
        new Colonna() { valore = "Company", tipo = "string", controllo = "EXIST", tabellaControllo = "Company;Name;Company_id" },
        new Colonna() { valore = "Company_id"},
        new Colonna() { valore = "TipoContratto", tipo = "string", controllo = "EXIST", tabellaControllo = "TipoContratto;Descrizione;TipoContratto_id" },
        new Colonna() { valore = "TipoContratto_id"},
        new Colonna() { valore = "RevenueBudget", tipo = "float"},
        new Colonna() { valore = "MargineProposta", tipo = "float" },
        new Colonna() { valore = "DataInizio", tipo = "date" },
        new Colonna() { valore = "DataFine", tipo = "date"},
        new Colonna() { valore = "BloccoCaricoSpese", tipo = "boolean" },
        new Colonna() { valore = "ActivityOn", tipo = "boolean" },
    };

    private static List<Colonna> ColonneFLC = new List<Colonna>() {
        new Colonna() { valore = "Consulente", tipo = "string", controllo = "EXIST", tabellaControllo = "Persons;Name;Persons_id;Persons_id" },
        new Colonna() { valore = "Persons_id"},
        new Colonna() { valore = "CostRate",  mandatory = true, tipo = "float"},
        new Colonna() { valore = "DataDa",  mandatory = true, tipo = "date" },
        new Colonna() { valore = "DataA",  mandatory = true, tipo = "date"},
        new Colonna() { valore = "Comment", tipo = "string" },
    };

    private static List<Colonna> ColonneBillRate = new List<Colonna>() {
        new Colonna() { valore = "Consulente", tipo = "string", controllo = "EXIST", tabellaControllo = "Persons;Name;Persons_id;Persons_id" },
        new Colonna() { valore = "Persons_id"},
        new Colonna() { valore = "ProjectCode", tipo = "string", mandatory = true ,controllo = "EXIST", tabellaControllo = "Projects;ProjectCode;Projects_id" },
        new Colonna() { valore = "Projects_id"},
        new Colonna() { valore = "CostRate",  mandatory = true, tipo = "float"},
        new Colonna() { valore = "BillRate",  mandatory = true, tipo = "float"},
        new Colonna() { valore = "DataDa",  mandatory = true, tipo = "date" },
        new Colonna() { valore = "DataA",  mandatory = true, tipo = "date"},
        new Colonna() { valore = "Comment", tipo = "string" },
    };

    public class EsitoControllo
    {
        public string codice;
        public string messaggio;
        public string NomeCampoId;  // nome del campo chiave da popolare sulla tabella in upload
        public string valoreId;     // valore del campo chiave
    };

    // recupera oggetto sessione
    public TRSession CurrentSession;

    // Dichiarazione del dizionario per memorizzare i valori in cache
    private static Dictionary<string, string> DBcache = new Dictionary<string, string>();

    private static DataTable FLCCache;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("ADMIN", "MASSCHANGE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // reinizializzo la cache
        DBcache = new Dictionary<string, string>();
        FLCCache = null;

        if (!IsPostBack)
        {
            DDLImport.SelectedValue = (string)Session["SelectedValue"];
        }

        switch (DDLImport.SelectedValue)
        {
            case "PROJECT":
                HyperLinkFile.NavigateUrl = "/timereport/m_gestione/Caricatori/template/progetti-template.xlsx";
                ColonneFileInput = ColonneProgetti;
                break;

            case "FLC":
                HyperLinkFile.NavigateUrl = "/timereport/m_gestione/Caricatori/template/FLC-template.xlsx";
                ColonneFileInput = ColonneFLC;
                break;

            case "BILLRATE":
                HyperLinkFile.NavigateUrl = "/timereport/m_gestione/Caricatori/template/BillRate-template.xlsx";
                ColonneFileInput = ColonneBillRate;
                break;
        }

    }

    //
    // Richiamato dal bottone "Esegui"
    // 1. LeggiFileExcel: Legge file
    // 2. ConfigReportColumns: Determina le colonne da estrarre in base al nome dell'intestazione
    // 3. CreateDataTable: Crea la tabella per contenere risultato del confronto
    // 4. CheckSFData: Loop sulle righe e confronta i risultati
    //                 --- > richiama FillTRData dove esegue confronti riga x riga sul TR
    //
    protected void Sottometti_Click(object sender, System.EventArgs e)
    {

        Session["SelectedValue"] = DDLImport.SelectedValue;

        DataTable dtInputdata = null;
        DataTable dtResult;
        String sErrorMessage = "";

        if (!FileUpload.HasFile)
            return;
        else
        {
            dtInputdata = Utilities.ImportExcel(FileUpload, ref sErrorMessage);
            if (dtInputdata == null)
            {
                Page lPage = this.Page;
                Utilities.CreateMessageAlert(ref lPage, "Errore in caricamento: " + sErrorMessage, "");
                return;
            }
        }

        // Crea tabella per memorizzare confronto
        dtResult = CreateDataTable();

        // Check data: verifica dati
        // A* Dati da aggiornare
        // E* Errore
        dtResult = CheckData(dtInputdata, dtResult);

        // sort
        DataView dv = dtResult.DefaultView;
        dv.Sort = "ProcessingStatus DESC";
        DataTable dtResultSorted = dv.ToTable();

        // salva i risultati e chiama la pagina di display
        Session["dtResult"] = dtResultSorted;
        Response.Redirect("/timereport/m_gestione/Caricatori/Caricatore_list.aspx?type=" + DDLImport.SelectedValue);

    }

    //
    // Loop sulle righe e confronta i dati SF con quelli TR
    //
    protected DataTable CheckData(DataTable dt, DataTable dtResult)
    {

        DataRow drCheck;
        double floatValue;
        bool isDouble;
        String valoreCellaStr = "";
        Regex rgx = new Regex(@"^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$");
        EsitoControllo ritorno = new EsitoControllo();

        int numberOfColumnsInExcel;

        // loop dalla 2 riga in avanti
        for (int i = 1; i < dt.Rows.Count; i++)
        {

            // popola la riga con i dati SF
            drCheck = dtResult.NewRow();
            numberOfColumnsInExcel = dt.Rows[i].ItemArray.Length;

            int count = 0;
            foreach (Colonna nomeColonna in ColonneFileInput)
            {

                if (count >= numberOfColumnsInExcel | nomeColonna.tipo == null) // file non corretto!
                    continue;

                valoreCellaStr = dt.Rows[i][count].ToString();
                var valoreCella = dt.Rows[i][count];
                count++;

                /* Controllo sui tipi */
                switch (nomeColonna.tipo)
                {

                    case "float":
                        isDouble = Double.TryParse(valoreCellaStr, out floatValue);
                        //    drCheck["SFAmount"] = price.ToString("N0");
                        if (!isDouble)
                        {
                            drCheck["ProcessingStatus"] = "ERR";
                            drCheck["ProcessingMessage"] = "Il valore " + valoreCellaStr + " di " + nomeColonna.valore + " non è un numero!";
                            continue;
                        }
                        drCheck[nomeColonna.valore] = valoreCella;
                        break;

                    case "date":
                        if (valoreCellaStr.Length < 10)
                        {
                            drCheck["ProcessingStatus"] = "ERR";
                            drCheck["ProcessingMessage"] = "Il valore " + valoreCellaStr + " di " + nomeColonna.valore + " non è una data.";
                            continue;
                        }
                        valoreCellaStr = valoreCellaStr.Substring(0, 10);
                        if (!rgx.IsMatch(valoreCellaStr))
                        {
                            drCheck["ProcessingStatus"] = "ERR";
                            drCheck["ProcessingMessage"] = "Il valore " + valoreCellaStr + " di " + nomeColonna.valore + " non è una data.";
                            continue;
                        }
                        drCheck[nomeColonna.valore] = valoreCellaStr;
                        break;

                    case "boolean":
                        if (valoreCellaStr != "" && valoreCellaStr != "X" && valoreCellaStr != "x")
                        {
                            drCheck["ProcessingStatus"] = "ERR";
                            drCheck["ProcessingMessage"] = "Il valore " + valoreCellaStr + " di " + nomeColonna.valore + " non è un flag.";
                            continue;
                        }
                        drCheck[nomeColonna.valore] = valoreCellaStr == "" ? "false" : "true";
                        break;

                    case "string":
                        drCheck[nomeColonna.valore] = valoreCellaStr;
                        break;

                };

                if (nomeColonna.mandatory && valoreCellaStr.Trim().Length == 0)
                {
                    drCheck["ProcessingStatus"] = "ERR";
                    drCheck["ProcessingMessage"] = "Il valore di " + nomeColonna.valore + " non può essere vuoto.";
                    continue;
                }

                // effettua controllo su valore del campo se non nullo
                if (nomeColonna.controllo != null && valoreCellaStr.Trim().Length != 0)
                {
                    ritorno = ControlloCampo(valoreCellaStr, nomeColonna.controllo, nomeColonna.tabellaControllo);
                    drCheck["ProcessingStatus"] = drCheck["ProcessingStatus"].ToString() == "" ? ritorno.codice : drCheck["ProcessingStatus"];
                    drCheck["ProcessingMessage"] = drCheck["ProcessingMessage"].ToString() == "" ? ritorno.messaggio : drCheck["ProcessingMessage"];

                    if (nomeColonna.controllo == "EXIST" && ritorno.NomeCampoId != null)
                    { // valorizza la chiave corrispondente all'attributo se tabellaConttrollo lo richiesde
                        drCheck[ritorno.NomeCampoId] = ritorno.valoreId;
                    }

                };
            }

            /* controlli specializzati */
            if (DDLImport.SelectedValue == "FLC" && drCheck["ProcessingStatus"].ToString() == "")
            {
                ritorno = ControlloFLC(drCheck);
                drCheck["ProcessingStatus"] = drCheck["ProcessingStatus"].ToString() == "" ? ritorno.codice : drCheck["ProcessingStatus"];
                drCheck["ProcessingMessage"] = drCheck["ProcessingMessage"].ToString() == "" ? ritorno.messaggio : drCheck["ProcessingMessage"];
            }

            if (DDLImport.SelectedValue == "BILLRATE" && drCheck["ProcessingStatus"].ToString() == "")
            {
                ritorno = ControlloBillRate(drCheck);
                drCheck["ProcessingStatus"] = drCheck["ProcessingStatus"].ToString() == "" ? ritorno.codice : drCheck["ProcessingStatus"];
                drCheck["ProcessingMessage"] = drCheck["ProcessingMessage"].ToString() == "" ? ritorno.messaggio : drCheck["ProcessingMessage"];
            }

            if (drCheck["ProcessingStatus"].ToString() == "")
            {
                drCheck["ProcessingStatus"] = "OK";
                drCheck["ProcessingMessage"] = "Record corretto per caricamento";
            }

            dtResult.Rows.Add(drCheck);
        }

        return dtResult;
    }

    protected EsitoControllo ControlloFLC(DataRow record)
    {
        EsitoControllo ritorno = new EsitoControllo();
        var dataArray = record.ItemArray;
        /*
         * dataArray[3] persons_id
         * dataArray[5] dataDa
         * dataArray[6] dataA
         */

        // se non è bufferizzato carica i valori in memoria
        if (FLCCache == null)
        {
            FLCCache = Database.GetData("SELECT * from PersonsCostRate", null);
        }

        string recordPersonsid = ASPcompatility.FormatStringDb(dataArray[3].ToString());
        string dataRecordDa = ASPcompatility.FormatDateDb(dataArray[5].ToString()).Replace("'", "");
        string dataRecordA = ASPcompatility.FormatDateDb(dataArray[6].ToString()).Replace("'", "");

        //string filter = " [persons_id] = " + recordPersonsid + " AND ( ( " +
        //                                  " [DataA] > #" + dataRecordDa + "# AND " +
        //                                  " [DataDa] < #" + dataRecordA + "# ) OR ( " +
        //                                  " [DataDa] < #" + dataRecordDa + "# AND " +
        //                                  " [DataA] > #" + dataRecordA + "# ) )";

        // Check o non esiste costo per il consulente o data inizio deve essere successiva 
        string filter = " [persons_id] = " + recordPersonsid;

        DataRow[] drRow = FLCCache.Select(filter);

        if (drRow.Length == 0) // ok, non esiste 
            return ritorno;

        // trova il maggiore
        DateTime maxDateA = DateTime.MinValue;
        foreach (DataRow dr in drRow)
        {
            if (Convert.ToDateTime(dr.ItemArray[5]) > maxDateA)
                maxDateA = Convert.ToDateTime(dr.ItemArray[5]);
        }

        maxDateA = maxDateA.AddDays(1);

        if (maxDateA != Convert.ToDateTime(dataArray[5]))
        {
            ritorno.codice = "ERR";
            ritorno.messaggio = "Record precedente già presente, la data inizio deve essere " + maxDateA.ToString("dd/MM/yy");
        }

        return ritorno;
    }

    protected EsitoControllo ControlloBillRate(DataRow record)
    {
        EsitoControllo ritorno = new EsitoControllo();
        var dataArray = record.ItemArray;
        /*
         * dataArray[3] persons_id
         * dataArray[5] projects_id 
         * dataArray[8] dataDa
         * dataArray[9] dataA
         */

        // se non è bufferizzato carica i valori in memoria
        if (FLCCache == null)
        {
            FLCCache = Database.GetData("SELECT * from ProjectCostRate", null);
        }

        string recordPersonsid = ASPcompatility.FormatStringDb(dataArray[3].ToString());
        string recordProjectsid = ASPcompatility.FormatStringDb(dataArray[5].ToString());
        string dataRecordDa = ASPcompatility.FormatDateDb(dataArray[8].ToString()).Replace("'", "");
        string dataRecordA = ASPcompatility.FormatDateDb(dataArray[9].ToString()).Replace("'", "");

        // Check o non esiste costo per il consulente o data inizio deve essere successiva 
        string filter = " [persons_id] = " + recordPersonsid + " AND [projects_id] = " + recordProjectsid;

        DataRow[] drRow = FLCCache.Select(filter);

        if (drRow.Length == 0) // ok, non esiste 
            return ritorno;

        // trova il maggiore
        DateTime maxDateA = DateTime.MinValue;
        foreach (DataRow dr in drRow)
        {
            if (Convert.ToDateTime(dr.ItemArray[6]) > maxDateA)
                maxDateA = Convert.ToDateTime(dr.ItemArray[6]);
        }

        maxDateA = maxDateA.AddDays(1);

        if (maxDateA != Convert.ToDateTime(dataArray[8]))
        {
            ritorno.codice = "ERR";
            ritorno.messaggio = "Record precedente già presente, la data inizio deve essere " + maxDateA.ToString("dd/MM/yy");
        }

        return ritorno;
    }

    protected EsitoControllo ControlloCampo(string valore, string controllo, string tabellaControllo)
    {

        EsitoControllo ritorno = new EsitoControllo();
        string[] campiTabella = tabellaControllo.Split(';');
        bool found = false;
        DataRow dr;
        string recordFound = "";

        string key = campiTabella[0] + ";" + campiTabella[1] + ";" + valore; // tabella, campo chiave, valore chiave

        // prima prova sulla cache
        if (DBcache.ContainsKey(key))
        {
            found = true;
            recordFound = DBcache[key];
        }
        else // se non trovato accede al DB
        {
            string campoDaEstrarre = campiTabella.Length > 2 ? campiTabella[2] : "*";
            dr = Database.GetRow("SELECT " + campoDaEstrarre + " from " + campiTabella[0] + " WHERE " + campiTabella[1] + "='" + valore + "'", null);

            if (dr != null)
            {
                found = true;
                recordFound = dr[0].ToString();
            }

        }

        if (found && controllo == "NOT_EXIST")
        {
            DBcache[key] = recordFound; // salva in cache
            ritorno.codice = "ERR";
            ritorno.messaggio = "Il valore " + valore + " del campo " + campiTabella[1] + " è già presente sulla tabella " + campiTabella[0];
        }

        if (!found && controllo == "EXIST")
        {
            ritorno.codice = "ERR";
            ritorno.messaggio = "Il valore " + valore + " del campo " + campiTabella[1] + " non è presente sulla tabella " + campiTabella[0];
        }

        if (found && campiTabella.Length > 2) // bisogna valorizzare la chiave corrispondente al valore
        {
            ritorno.valoreId = recordFound;
            DBcache[key] = recordFound;
            ritorno.NomeCampoId = campiTabella.Length == 4 ? campiTabella[3] : campiTabella[2];  // nome della chiave sulla tabella da caricare
        }

        return ritorno;
    }

    // Crea la tabella risultato
    protected DataTable CreateDataTable()
    {

        DataTable dt = new DataTable("Results");

        // Codice Errore
        dt.Columns.Add(CreateColumn("string", "ProcessingStatus", "Processing Status"));
        dt.Columns.Add(CreateColumn("string", "ProcessingMessage", "Processing Message"));

        foreach (Colonna nomeColonna in ColonneFileInput)
        {
            dt.Columns.Add(CreateColumn(nomeColonna.tipo, nomeColonna.valore, nomeColonna.valore));
        };

        return dt;
    }

    // Aggiunge una colonna
    protected DataColumn CreateColumn(string sType, string sField, string sName)
    {

        DataColumn dtColumn;
        dtColumn = new DataColumn();
        switch (sType)
        {
            case "int":
                dtColumn.DataType = typeof(int);
                break;

            case "date":
                dtColumn.DataType = typeof(string);
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
}