using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Threading;
using System.Web.Script.Serialization;
using System.Web.UI;

public partial class m_utilita_upload_expenses_xls1 : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object source, EventArgs e)
    {
        Auth.CheckPermission("DATI", "UPLOAD");

        CurrentSession = (TRSession)Session["CurrentSession"]; // recupera oggetto con variabili di sessione

        messaggio.Text = "";
        recordOK.Text = "";
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        // record layout
        // Risorsa (0); Data (1);Progetto (2); Tipo Spesa (3);Valore (4);Pagato (5);Storno (6); Note (7)

        int DATA = 0; // formato campo, data oltre cutt-off
        int PROGETTO = 1; // codice ammesso
        int TIPOSPESA = 2; // codice ammesso
        int VALORE = 3; // valore numerico > 0
        int CCREDITO = 4; // o X o blank
        int PAGATO = 5; // o X o blank
        int STORNO = 6; // o X o blank
        int FATTURA = 7; // o X o blank
        int NOTA = 8;

        var c = new ValidationClass();
        var dt = new DataTable();

        // ****************** FINE IMPORT da EXCEL in DATASET ******************

        int iTipoBonus_id;
        var aDateBonus = new ArrayList(); // usato per verificare doppi bonus su stesso giorno

        int i, f;
        int idProgetto;
        int idSpesa;

        if (!FUFile.HasFile)
        {
            return;
        }

        string errorMessage = "";
        Page lPage = this.Page;
        dt = Utilities.ImportExcel(FUFile, ref errorMessage);

        if (dt == null)
        {
            Utilities.CreateMessageAlert(ref lPage, "Errore in caricamento file: " + errorMessage, "");
            return;
        }

        if (dt.Rows.Count == 0)
        {
            Utilities.CreateMessageAlert(ref lPage, "Errore in caricamento file: " + errorMessage, "");
            return;
        }

        foreach (DataRow dr in dt.Rows)
        {
            // indice
            i = dt.Rows.IndexOf(dr) + 1;

            if (i == 1)
            {
                continue;
            }

            // inizializza tipo bonus che verrà poi letto da DB
            iTipoBonus_id = 0;
            idProgetto = 0;
            idSpesa = 0;

            // Verifica formato data
            DateTime data;
            string dataString = dr[DATA] != null ? dr[DATA].ToString() : string.Empty;
            if (!DateTime.TryParse(dataString, out data))
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg1").ToString(); // data non valida
                continue;
            }

            // importo non numerico 
            double dout;
            if (!double.TryParse(dr[VALORE].ToString(), out dout))
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg2").ToString(); // ": importo spesa deve essere un numero"
                continue;
            }

            // importo numerico non negativo
            if (!double.TryParse(dr[VALORE].ToString(), out dout) || Convert.ToDouble(dr[VALORE]) <= 0)
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg3").ToString(); // ": importo spesa non può essere negativo"
                continue;
            }

            // valori flag                               
            if (!string.IsNullOrEmpty(dr[CCREDITO].ToString().Trim()) && dr[CCREDITO].ToString() != "X" && dr[CCREDITO].ToString() != "x")
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg16").ToString(); // ": valore flag 'Carta di Credito' non riconosciuto"
                continue;
            }

            // valori flag                               
            if (!string.IsNullOrEmpty(dr[PAGATO].ToString().Trim()) && dr[PAGATO].ToString() != "X" && dr[PAGATO].ToString() != "x")
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg4").ToString(); // ": valore flag 'PAGATO con cc' non riconosciuto"
                continue;
            }

            // valori flag                               
            if (!string.IsNullOrEmpty(dr[STORNO].ToString()) && dr[STORNO].ToString() != "X" && dr[STORNO].ToString() != "x")
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg5").ToString(); // ": valore flag 'STORNO' non riconosciuto"
                continue;
            }

            // valori flag                               
            if (!string.IsNullOrEmpty(dr[FATTURA].ToString().Trim()) && dr[FATTURA].ToString() != "X" && dr[FATTURA].ToString() != "x")
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg6").ToString(); // ": valore flag 'FATTURA' non riconosciuto"
                continue;
            }

            // data oltre cutoff
            if (Convert.ToDateTime(dr[DATA].ToString()) <= CurrentSession.dCutoffDate)
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg7").ToString(); // ": data del file antecedente al cut-off"
                continue;
            }

            // tipo spesa aperta per persona
            DataTable aSpeseForzate = CurrentSession.dtSpeseForzate;

            for (f = 0; f < aSpeseForzate.Rows.Count; f++)
            {
                if (aSpeseForzate.Rows[f][1].ToString().Trim() == dr[TIPOSPESA].ToString().Trim())
                {
                    idSpesa = Convert.ToInt32(aSpeseForzate.Rows[f][0]);
                    break;
                }
            }

            if (idSpesa == 0)
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg8").ToString() + dr[TIPOSPESA].ToString().Trim(); // ": Codice spesa non ammesso, "
                continue;
            }

            // 08/2014 Valorizza tipo Bonus se il tipo spesa è di tipo bonus
            DataRow drExpenseType = Database.GetRow("Select TipoBonus_id, AdditionalCharges from ExpenseType where ExpenseType_id=" + idSpesa.ToString(), this.Page);
            iTipoBonus_id = Convert.ToInt32(drExpenseType["TipoBonus_id"]);

            // Se la spesa è un tickets la quantità deve essere uno
            if (iTipoBonus_id > 0 && Convert.ToDouble(dr[VALORE]) != 1)
            {
                messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg9").ToString() + dr[TIPOSPESA].ToString().Trim(); // ": Bonus/ticket con quantità diversa da 1 non ammesso "
                continue;
            }

            // Se la spesa è il ticket restaurant il progetto viene impostato di default
            if (idSpesa == Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_EXPENSE"]))
            {
                idProgetto = Convert.ToInt32(ConfigurationManager.AppSettings["TICKET_REST_PROJECT"]);
            }

            if (iTipoBonus_id > 0)
            {
                // Se sullo stesso giorno esiste già una spesa "tickets" da errore
                if (Database.RecordEsiste("Select Expenses_Id from Expenses INNER JOIN ExpenseType ON ExpenseType.ExpenseType_id = Expenses.ExpenseType_id where ( persons_id = " + CurrentSession.Persons_id + " AND Expenses.Date = " + ASPcompatility.FormatDateDb(dr[DATA].ToString()) + " And ExpenseType.TipoBonus_id > 0 )"))
                {
                    messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg10").ToString() + dr[TIPOSPESA].ToString().Trim() + " - " + dr[DATA].ToString().Substring(1, 10); // ": Bonus/ticket già presente nel DB per lo stesso giorno "
                    continue;
                }

                // esegue il check sulle righe non ancora caricate                    
                if (aDateBonus.Contains(dr[DATA]))
                {
                    messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg11").ToString() + dr[TIPOSPESA].ToString().Trim() + " - " + dr[DATA].ToString().Substring(1, 10); // ": Bonus/ticket ripetuto nel file per lo stesso giorno "
                    continue;
                }
                else
                {
                    aDateBonus.Add(dr[DATA]);
                }

                // se il tipo spesa è un rimborso travel verifica presenza del testo con il luogo di trasferta
                if (iTipoBonus_id == Convert.ToInt32(ConfigurationManager.AppSettings["TIPO_BONUS_TRAVEL"]) && string.IsNullOrEmpty(dr[NOTA].ToString().Trim()))
                {
                    messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg12").ToString() + dr[TIPOSPESA].ToString().Trim() + " - " + dr[DATA].ToString().Substring(1, 10); // ": specificare luogo in caso di rimborso trasferta "
                    continue;
                }
            } // if iTipoBonus_id > 0

            // Fine                                      

            DataTable aProgettiForzati;
            if (idProgetto == 0) // non precedentemente impostato In caso di ticket restaurant
            {
                aProgettiForzati = CurrentSession.dtProgettiForzati;

                for (f = 0; f < aProgettiForzati.Rows.Count; f++)
                {
                    if (aProgettiForzati.Rows[f][1].ToString().Trim() == dr[PROGETTO].ToString().Trim())
                    {
                        idProgetto = Convert.ToInt32(aProgettiForzati.Rows[f][0]);
                        break;
                    }
                }

                if (idProgetto == 0)
                {
                    messaggio.Text += "\r\nRow " + i + GetLocalResourceObject("msg13").ToString() + dr[PROGETTO].ToString().Trim(); // ": Codice progetto non ammesso, " 
                    continue;
                }
            }

            // successo 
            if (!simulazione.Checked)
            {
                string url = "http://localhost/timereport/webservices/WS_DBUpdates.asmx/SaveExpenses";
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Method = "POST";
                request.ContentType = "application/json; charset=utf-8";

                var postData = new Dictionary<string, object>
                {
                    { "Expenses_Id", 0 },
                    { "Date", DateTime.Parse(dr[DATA].ToString()).ToString("dd/MM/yyyy") },
                    { "ExpenseAmount", Convert.ToDouble(dr[VALORE]) },
                    { "Person_Id", CurrentSession.Persons_id },
                    { "Project_Id", idProgetto },
                    { "ExpenseType_Id", idSpesa },
                    { "Comment", dr[NOTA].ToString() },
                    { "CreditCardPayed", !string.IsNullOrEmpty(dr[CCREDITO].ToString().Trim()) },
                    { "CompanyPayed", !string.IsNullOrEmpty(dr[PAGATO].ToString().Trim()) },
                    { "CancelFlag", !string.IsNullOrEmpty(dr[STORNO].ToString().Trim()) },
                    { "InvoiceFlag", !string.IsNullOrEmpty(dr[FATTURA].ToString().Trim()) },
                    { "strFileName", "" },
                    { "strFileData", "" },
                    { "OpportunityId", "" },
                    { "AccountingDate", "" },
                    { "UserId", CurrentSession.UserId }
                };

                string json = new JavaScriptSerializer().Serialize(postData);
                byte[] byteArray = Encoding.UTF8.GetBytes(json);

                using (Stream dataStream = request.GetRequestStream())
                {
                    dataStream.Write(byteArray, 0, byteArray.Length);
                }

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    string responseText = reader.ReadToEnd();

                    if (responseText.Contains("true"))
                    {
                        recordOK.Text += "\r\nRow " + i + " " + GetLocalResourceObject("msg14").ToString() + " " + dr[PROGETTO] + " - " + dr[TIPOSPESA] + " - " + DateTime.Parse(dr[DATA].ToString()).ToString("dd/MM/yyyy") + " - " + dr[VALORE]; // " caricata. "
                    }
                    else
                    {
                        recordOK.Text += "\r\nRow " + i + " in errore: " + dr[PROGETTO] + " - " + dr[TIPOSPESA] + " - " + DateTime.Parse(dr[DATA].ToString()).ToString("dd/MM/yyyy") + " - " + dr[VALORE]; // " in errore. "
                    }
                }
            }
            else
            {
                recordOK.Text += "\r\nRow " + i + " " + GetLocalResourceObject("msg15").ToString() + " " + dr[PROGETTO] + " - " + dr[TIPOSPESA] + " - " + DateTime.Parse(dr[DATA].ToString()).ToString("dd/MM/yyyy") + " - " + dr[VALORE]; // " caricata (in simulazione): "
            }
        } // foreach (DataRow dr in dt.Rows)
    }

    protected override void InitializeCulture()
    {
        // Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture();
    }
}