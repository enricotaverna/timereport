using classiStandard;
//using Microsoft.Office.Interop.Excel;
using Syncfusion.XlsIO;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using Button = System.Web.UI.WebControls.Button;
using DataTable = System.Data.DataTable;
using Label = System.Web.UI.WebControls.Label;

public partial class report_PresenzeSpese : System.Web.UI.Page
{
    private SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        string sAnnoCorrente;

        // autority check in funzione del tipo chiamata della pagina
        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // se premuto CancelButton torna indietro
        if (Request.Form["CancelButton"] != null)
            Response.Redirect("/timereport/menu.aspx");

        // se parametro di chiamata è vuoto mette default l'anno corrent
        if (String.IsNullOrEmpty(AnnoCorrente.Text))
        {
            sAnnoCorrente = DateTime.Now.Year.ToString();
            AnnoCorrente.Text = sAnnoCorrente;
        }


    }

    protected void TogliAnno_Click(object sender, System.EventArgs e)
    {
        int Anno = Convert.ToInt16(AnnoCorrente.Text) - 1;
        AnnoCorrente.Text = Anno.ToString();
    }

    protected void AggiungiAnno_Click(object sender, System.EventArgs e)
    {
        int Anno = Convert.ToInt16(AnnoCorrente.Text) + 1;
        AnnoCorrente.Text = Anno.ToString();
    }

    /// <summary>
    /// estrazione del foglio excel contenente spese e presenze
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void EstraiFile_Click(object sender, System.EventArgs e)
    {
        SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
        Label LabelAnno = null;
        LabelAnno = (Label)FVMain.FindControl("AnnoCorrente");

        Button btnPressed = (Button)sender;

        int AnnoSelezionato = Convert.ToInt16(LabelAnno.Text.ToString());
        int MeseSelezionato = Convert.ToInt16(btnPressed.ID.Replace("M", ""));
        string NomePresenze = string.Format("EstrazioneOre_{0}_{1}", btnPressed.Text.ToString(), AnnoSelezionato);
        string NomeSpese = string.Format("EstrazioneSpese_{0}_{1}", btnPressed.Text.ToString(), AnnoSelezionato);

        ///* Estrae Dataset risultato lanciando stored procedure dopo aver impostato i parametri */

        DataSet dsPresenze = new DataSet(NomePresenze);
        DataSet dsSpese = new DataSet(NomeSpese);

        conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
        conn.Open();
        using (conn)
        {
            SqlCommand sqlComm = new SqlCommand("EstraiPresenze", conn);
            sqlComm.CommandTimeout = 200000;
            // valorizza parametri della query
            sqlComm.Parameters.AddWithValue("@Anno", AnnoSelezionato);
            sqlComm.Parameters.AddWithValue("@Mese", MeseSelezionato);

            // esecuzione
            sqlComm.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = sqlComm;

            da.Fill(dsPresenze, NomePresenze);

            SqlCommand sqlCommSpese = new SqlCommand("EstraiSpese", conn);
            sqlCommSpese.CommandTimeout = 200000;

            // valorizza parametri della query
            sqlCommSpese.Parameters.AddWithValue("@Anno", AnnoSelezionato);
            sqlCommSpese.Parameters.AddWithValue("@Mese", MeseSelezionato);

            // esecuzione
            sqlCommSpese.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter daSpese = new SqlDataAdapter();
            daSpese.SelectCommand = sqlCommSpese;

            daSpese.Fill(dsSpese, NomePresenze);
        }

        //elimina utenti con le sole ore delle festivita (probabilmente sono andati via)
        EliminaInattivi(dsPresenze);
        ////esamina e spalma i straordinari
        //SpalmaStraordinari(ref dsPresenze);
        //aggiungi colonne delle spese al datatable presenze
        AggiungiColonne(ref dsPresenze);
        //lavorazione del dt presenze aggiungengo le spese
        LavoraDataset(dsPresenze, dsSpese);
        //aggiunta della colonna grandTotal generale
        AddGrandTotal(ref dsPresenze, dsSpese);
        //estrazione e download del foglio excel
        EstraiEformattaExcel(dsPresenze, NomePresenze);

    }

    /// <summary>
    /// eliminazione degli utenti con sole festivita inserite
    /// </summary>
    /// <param name="dsPresenze"></param>
    private void EliminaInattivi(DataSet dsPresenze)
    {

        string listaPersoneDaEliminare = "";

        DataView view = new DataView(dsPresenze.Tables[0]);
        DataTable distinctValues = view.ToTable(true, "Persons_id");

        foreach (DataRow Person in distinctValues.Rows)
        {
            DataView FilterPerson = new DataView();
            FilterPerson = dsPresenze.Tables[0].Select(string.Format("Persons_id = {0} AND ProjectCode <> 'Total'", Person["Persons_id"])).CopyToDataTable().AsDataView();
            DataTable distinctOre = FilterPerson.ToTable(true, "ProjectCode");

            if (distinctOre.Rows.Count == 1 && distinctOre.Rows[0]["ProjectCode"].ToString() == "FS")
            {
                listaPersoneDaEliminare += "'" + Person["Persons_id"].ToString() + "',";
            }
        }
        //se ci sono persone con solo festivita le tolgo dal dataset orginale
        if (listaPersoneDaEliminare != "")
        {
            listaPersoneDaEliminare.Substring(0, listaPersoneDaEliminare.Length - 1);

            //listaPersoneDaEliminare
            if (dsPresenze.Tables[0].Select(string.Format("Persons_id NOT IN ({0})", listaPersoneDaEliminare)).Count() > 1)
            {
                DataTable filtered = dsPresenze.Tables[0].Select(string.Format("Persons_id NOT IN ({0})", listaPersoneDaEliminare)).CopyToDataTable();
                dsPresenze.Tables.RemoveAt(0);
                dsPresenze.Tables.Add(filtered);
            }
        }
    }

    /// <summary>
    /// spalma gli straordinari come da specifiche
    /// 1. nei giorni lavorativo max ore straordinario è 2h
    /// 2. nei giorni festivi max ore straordinario è 8h
    /// 3. max ore straordinarie nella settimana lun-ven 8h
    /// 4. spalmatura di ore in più deve essere fatta solo su gg lavorativi
    /// </summary>
    /// <param name="dsPresenze"></param>
    private void SpalmaStraordinari(ref DataSet dsPresenze)
    {
        DataTable dtStraordinari = dsPresenze.Tables[0];
        DataColumnCollection ColonneOre = dtStraordinari.Columns;
        string[] ColonneDaEsludere = { "Persons_id", "Name", "Ruolo", "ProjectCode", "Totale Ore" };
        string[] GiorniFeriali = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday" };
        string[] GiorniFestivi = { "Saturday", "Sunday" };

        DataTable DtDataOre = new DataTable();

        DataColumn Data = DtDataOre.Columns.Add("Data", typeof(DateTime));
        Data.AllowDBNull = true;
        Data.Unique = false;
        Data.ColumnName = "Data";

        DataColumn Ore = DtDataOre.Columns.Add("Ore", typeof(decimal));
        Ore.AllowDBNull = true;
        Ore.Unique = false;
        Ore.ColumnName = "Ore";

        DataColumn OreInEccesso = DtDataOre.Columns.Add("OreInEccesso", typeof(decimal));
        OreInEccesso.AllowDBNull = true;
        OreInEccesso.Unique = false;
        OreInEccesso.ColumnName = "OreInEccesso";

        DataColumn OreStraordinario = DtDataOre.Columns.Add("OreStraordinario", typeof(decimal));
        OreStraordinario.AllowDBNull = true;
        OreStraordinario.Unique = false;
        OreStraordinario.ColumnName = "OreStraordinario";

        DataColumn Persons_id = DtDataOre.Columns.Add("Persons_id", typeof(int));
        Persons_id.AllowDBNull = true;
        Persons_id.Unique = false;
        Persons_id.ColumnName = "Persons_id";

        try
        {
            decimal RestoOre = 0;
            //ciclo tutte le righe delle ore controllando se contengono l'identificativo "S" = straordinario
            foreach (DataRow RowHours in dtStraordinari.Rows)
            {


                if (RowHours["ProjectCode"].ToNullToString().ToUpper() == "S")
                {
                    DtDataOre.Rows.Clear();
                    //se contiene straordinari ciclo tutte le colonne
                    foreach (DataColumn column in ColonneOre)
                    {

                        string NomeColonna = column.ColumnName;
                        //escludo le colonne che non sono data
                        if (ColonneDaEsludere.Contains(NomeColonna) == true)
                        {
                            goto NEXTREC;
                        }

                        DataRow RowDataOre = DtDataOre.NewRow();

                        //controllo se nella giornata LUN-VEN sono stati superate le 2 ore di straordinario
                        if (RowHours[NomeColonna].ToNullToString() != "" &&
                            Convert.ToDecimal(RowHours[NomeColonna]) >= 2 &&
                            GiorniFeriali.Contains(Convert.ToDateTime(NomeColonna).DayOfWeek.ToString()))
                        {
                            RestoOre += Convert.ToDecimal(RowHours[NomeColonna]);
                            RowDataOre[Data] = Convert.ToDateTime(NomeColonna);
                            RowDataOre[Ore] = Convert.ToDecimal(RowHours[NomeColonna]) - (Convert.ToDecimal(RowHours[NomeColonna]) - 2);
                            RowDataOre[OreInEccesso] = Convert.ToDecimal(RowHours[NomeColonna]) - 2;
                            RowDataOre[OreStraordinario] = Convert.ToDecimal(RowHours[NomeColonna]);
                            RowDataOre[Persons_id] = RowHours["Persons_id"].ToNullToString();
                        }//controllo se nei giorni SAB e DOM sono state superate le 8 ore
                        else if (RowHours[NomeColonna].ToNullToString() != "" &&
                            Convert.ToDecimal(RowHours[NomeColonna]) > 8 &&
                            GiorniFestivi.Contains(Convert.ToDateTime(NomeColonna).DayOfWeek.ToString()))
                        {
                            RestoOre += Convert.ToDecimal(RowHours[NomeColonna]);
                            RowDataOre[Data] = Convert.ToDateTime(NomeColonna);
                            RowDataOre[Ore] = Convert.ToDecimal(RowHours[NomeColonna]) - (Convert.ToDecimal(RowHours[NomeColonna]) - 8);
                            RowDataOre[OreInEccesso] = Convert.ToDecimal(RowHours[NomeColonna]) - 8;
                            RowDataOre[OreStraordinario] = Convert.ToDecimal(RowHours[NomeColonna]);
                            RowDataOre[Persons_id] = RowHours["Persons_id"].ToNullToString();
                        }
                        else
                        {
                            RowDataOre[Data] = Convert.ToDateTime(NomeColonna);
                            RowDataOre[Ore] = (RowHours[NomeColonna].ToNullToString() != "") ? Convert.ToDecimal(RowHours[NomeColonna]) : 0;
                            RowDataOre[OreInEccesso] = Convert.ToDecimal(0);
                            RowDataOre[OreStraordinario] = Convert.ToDecimal(0);
                            RowDataOre[Persons_id] = RowHours["Persons_id"].ToNullToString();
                        }

                        DtDataOre.Rows.Add(RowDataOre);

                    NEXTREC:;
                    }


                    foreach (DataRow item in DtDataOre.Rows)
                    {
                        Debug.WriteLine(item[0].ToString() + " -- " + item[1].ToString() + " -- " + item[2].ToString() + " -- " + item[3].ToString());
                    }
                    Debug.WriteLine(RestoOre);

                    DateTimeFormatInfo dfi = DateTimeFormatInfo.CurrentInfo;
                    var week = DtDataOre.AsEnumerable().GroupBy(row =>
                                      dfi.Calendar.GetWeekOfYear(Convert.ToDateTime(row["Data"]), dfi.CalendarWeekRule,
                                                                 dfi.FirstDayOfWeek))
                                  .Select(g => new
                                  {
                                      Date = g.First()["Data"].ToString(),
                                  }).ToList();

                    //mi prendo le righe salvate delle ore in eccesso
                    DataTable DtOreInEccesso = DtDataOre.Select("Ore > 0").CopyToDataTable();
                    foreach (DataRow item in DtOreInEccesso.Rows)
                    {
                        //ricavo id persona e data da modificare
                        int PersonaId = Convert.ToInt16(item["Persons_id"]);
                        string DataStraordinario = Convert.ToDateTime(item["Data"]).ToString("dd-MM-yyyy");

                        //cerco quale settimana puo essere usata per spalmare le ore
                        //facendo la somma per settimana
                        for (int i = 0; i < week.Count(); i++)
                        {
                            if (RestoOre > 0)
                            {
                                DateTime EndDate;
                                //se ultima settimana da cercare trovo la differenza dei giorni e aggiungo
                                if (i == week.Count() - 1)
                                {
                                    int DaysInMonts = System.DateTime.DaysInMonth(Convert.ToDateTime(week[i].Date).Year, Convert.ToDateTime(week[i].Date).Month);
                                    int AddDays = DaysInMonts - Convert.ToDateTime(week[i].Date).Day;
                                    EndDate = Convert.ToDateTime(week[i].Date).AddDays(AddDays);
                                }
                                else
                                {
                                    EndDate = Convert.ToDateTime(week[i].Date).AddDays(+6);
                                }

                                DateTime StartDate = Convert.ToDateTime(week[i].Date);

                                //somma per vedere se la somma settimanale non supera 8 ore
                                decimal oreTotStraordinarioSett = DtDataOre.AsEnumerable().Where(row => row.Field<DateTime>("Data") >= StartDate && row.Field<DateTime>("Data") <= EndDate).Sum(row => row.Field<decimal>("OreStraordinario"));

                                //se nella settimana ci sono meno di 8 ore segnate spalmo e tolgo dal resto
                                if (oreTotStraordinarioSett < 8)
                                {

                                    List<String> SlotLiberi = RicavaSlotLiberi(DtDataOre, StartDate, EndDate);
                                    int NrSlot = SlotLiberi.Count() - 1;
                                    //trovo il record dal dt master delle presenze
                                    DataRow RigaOra = dsPresenze.Tables[0].Select(string.Format("Persons_id={0} AND ProjectCode = 'S'", PersonaId))[0];
                                    while (RestoOre > 0 && NrSlot > 0)
                                    {
                                        if (RigaOra != null)
                                        {
                                            RigaOra[DataStraordinario] = item["Ore"];
                                            RigaOra[SlotLiberi[NrSlot]] = 2;
                                            NrSlot -= 1;
                                            RestoOre -= 2;
                                        }
                                    }
                                }
                                else
                                {
                                    List<String> SlotLiberi = TrovaSlotSettimaneSuccessive(DtDataOre);
                                }
                            }
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            var st = new StackTrace(ex, true);
            var sf = st.GetFrame(st.FrameCount - 1);
            string ErrorLine = clsUtility.NullToString(sf.GetFileLineNumber()).ToString();
            string MethodName = clsUtility.NullToString(sf.GetMethod().Name).ToString();
            string FileSource = clsUtility.NullToString(sf.GetFileName()).ToString();
            string Description = String.Format("Method Name: {0} - Error Line: {1} - FileSource: {2}", MethodName, ErrorLine, FileSource);
            clsLog.WriteErrLog("0", ex.Message, Description.ToString());
        }
    }

    private List<String> RicavaSlotLiberi(DataTable DtDataOre, DateTime StartDate, DateTime EndDate)
    {
        List<string> Slot = new List<string>();
        DataTable SlotLiberi = DtDataOre.AsEnumerable().Where(row => row.Field<DateTime>("Data") >= StartDate && row.Field<DateTime>("Data") <= EndDate && row.Field<Decimal>("Ore") == 0).CopyToDataTable();

        foreach (DataRow item in SlotLiberi.Rows)
        {
            Slot.Add(Convert.ToDateTime(item["Data"]).ToString("dd-MM-yyyy"));
        }

        return Slot;
    }


    private List<String> TrovaSlotSettimaneSuccessive(DataTable DtDataOre)
    {
        List<String> SlotMensili = new List<string>();
        DateTimeFormatInfo dfi = DateTimeFormatInfo.CurrentInfo;
        var week = DtDataOre.AsEnumerable().GroupBy(row =>
                                      dfi.Calendar.GetWeekOfYear(Convert.ToDateTime(row["Data"]), dfi.CalendarWeekRule,
                                                                 dfi.FirstDayOfWeek))
                                  .Select(g => new
                                  {
                                      Date = g.First()["Data"].ToString(),
                                  }).ToList();
        DateTime StartDate;
        DateTime EndDate;
        for (int i = 0; i < week.Count(); i++)
        {
            //se ultima settimana da cercare trovo la differenza dei giorni e aggiungo
            if (i == week.Count() - 1)
            {
                int DaysInMonts = System.DateTime.DaysInMonth(Convert.ToDateTime(week[i].Date).Year, Convert.ToDateTime(week[i].Date).Month);
                int AddDays = DaysInMonts - Convert.ToDateTime(week[i].Date).Day;
                EndDate = Convert.ToDateTime(week[i].Date).AddDays(AddDays);
            }
            else
            {
                EndDate = Convert.ToDateTime(week[i].Date).AddDays(+6);
            }

            StartDate = Convert.ToDateTime(week[i].Date);

            //somma per vedere se la somma settimanale non supera 8 ore
            decimal oreTotStraordinarioSett = DtDataOre.AsEnumerable().Where(row => row.Field<DateTime>("Data") >= StartDate && row.Field<DateTime>("Data") <= EndDate).Sum(row => row.Field<decimal>("OreStraordinario"));

            if (oreTotStraordinarioSett < 8)
            {
                foreach (string a in RicavaSlotLiberi(DtDataOre, StartDate, EndDate))
                {
                    SlotMensili.Add(a);
                }
            }

        }
        return SlotMensili;
    }

    /// <summary>
    ///aggiunta delle colonne per le spese
    /// </summary>
    /// <param name="dsPresenze"></param>
    /// <param name="dsSpese"></param>
    private void AggiungiColonne(ref DataSet dsPresenze)
    {

        try
        {
            DataColumn RimborsoSpese = dsPresenze.Tables[0].Columns.Add("RimborsoSpese", typeof(decimal));
            RimborsoSpese.AllowDBNull = true;
            RimborsoSpese.Unique = false;
            RimborsoSpese.ColumnName = "Rimborso Spese";

            DataColumn NRtrasfItalia = dsPresenze.Tables[0].Columns.Add("NRtrasfItalia", typeof(decimal));
            NRtrasfItalia.AllowDBNull = true;
            NRtrasfItalia.Unique = false;
            NRtrasfItalia.ColumnName = "N. Tras ITALIA";

            DataColumn SpesetrasfItalia = dsPresenze.Tables[0].Columns.Add("SpesetrasfItalia", typeof(decimal));
            SpesetrasfItalia.AllowDBNull = true;
            SpesetrasfItalia.Unique = false;
            SpesetrasfItalia.ColumnName = "Spese Tras ITALIA";

            DataColumn NRtrasfEstero = dsPresenze.Tables[0].Columns.Add("NRtrasfEstero", typeof(decimal));
            NRtrasfEstero.AllowDBNull = true;
            NRtrasfEstero.Unique = false;
            NRtrasfEstero.ColumnName = "N. Tras ESTERO";

            DataColumn SpesetrasfEstero = dsPresenze.Tables[0].Columns.Add("SpesetrasfEstero", typeof(decimal));
            SpesetrasfEstero.AllowDBNull = true;
            SpesetrasfEstero.Unique = false;
            SpesetrasfEstero.ColumnName = "Spese Tras ESTERO";

            DataColumn NRBuoni = dsPresenze.Tables[0].Columns.Add("NRBuoni", typeof(decimal));
            NRBuoni.AllowDBNull = true;
            NRBuoni.Unique = false;
            NRBuoni.ColumnName = "N. BUONI";

            DataColumn SpeseBUONI = dsPresenze.Tables[0].Columns.Add("SpeseBUONI", typeof(decimal));
            SpeseBUONI.AllowDBNull = true;
            SpeseBUONI.Unique = false;
            SpeseBUONI.ColumnName = "Tot. Buoni";

            DataColumn NrIndenUSA = dsPresenze.Tables[0].Columns.Add("NrIndenUSA", typeof(decimal));
            NrIndenUSA.AllowDBNull = true;
            NrIndenUSA.Unique = false;
            NrIndenUSA.ColumnName = "Inden. USA";

            DataColumn IndenUSA = dsPresenze.Tables[0].Columns.Add("IndenUSA", typeof(decimal));
            IndenUSA.AllowDBNull = true;
            IndenUSA.Unique = false;
            IndenUSA.ColumnName = "Inden. € USA";

            DataColumn NrReperibiliadiurna = dsPresenze.Tables[0].Columns.Add("NrReperibiliadiurna", typeof(decimal));
            NrReperibiliadiurna.AllowDBNull = true;
            NrReperibiliadiurna.Unique = false;
            NrReperibiliadiurna.ColumnName = "Nr. Reperibilità diurna";

            DataColumn Reperibiliadiurna = dsPresenze.Tables[0].Columns.Add("Reperibiliadiurna", typeof(decimal));
            Reperibiliadiurna.AllowDBNull = true;
            Reperibiliadiurna.Unique = false;
            Reperibiliadiurna.ColumnName = "Reperibilità diurna";

            DataColumn NrReperibilitaAMSsettimanale = dsPresenze.Tables[0].Columns.Add("NrReperibilitaAMSsettimanale", typeof(decimal));
            NrReperibilitaAMSsettimanale.AllowDBNull = true;
            NrReperibilitaAMSsettimanale.Unique = false;
            NrReperibilitaAMSsettimanale.ColumnName = "Nr. Reperibilità AMS settimanale";

            DataColumn ReperibilitaAMSsettimanale = dsPresenze.Tables[0].Columns.Add("ReperibilitaAMSsettimanale", typeof(decimal));
            ReperibilitaAMSsettimanale.AllowDBNull = true;
            ReperibilitaAMSsettimanale.Unique = false;
            ReperibilitaAMSsettimanale.ColumnName = "Reperibilità AMS settimanale";

            DataColumn Totale = dsPresenze.Tables[0].Columns.Add("Totale", typeof(decimal));
            Totale.AllowDBNull = true;
            Totale.Unique = false;
            Totale.ColumnName = "Somma Totale";
        }
        catch (Exception ex)
        {
            var st = new StackTrace(ex, true);
            var sf = st.GetFrame(st.FrameCount - 1);
            string ErrorLine = clsUtility.NullToString(sf.GetFileLineNumber()).ToString();
            string MethodName = clsUtility.NullToString(sf.GetMethod().Name).ToString();
            string FileSource = clsUtility.NullToString(sf.GetFileName()).ToString();
            string Description = String.Format("Method Name: {0} - Error Line: {1} - FileSource: {2}", MethodName, ErrorLine, FileSource);
            clsLog.WriteErrLog("0", ex.Message, Description.ToString());
        }

    }

    /// <summary>
    /// valorizzazione delle colonne spese
    /// </summary>
    /// <param name="dsPresenze"></param>
    /// <param name="dsSpese"></param>
    private void LavoraDataset(DataSet dsPresenze, DataSet dsSpese)
    {
        try
        {
            string personID = "";
            DataTable Presenze = dsPresenze.Tables[0];

            foreach (DataRow Spesa in dsSpese.Tables[0].Rows)
            {

                personID = Spesa["Persons_id"].ToString();

                DataTable totale = dsSpese.Tables[0].Select(string.Format("Persons_id = {0}", personID)).CopyToDataTable();
                decimal sum = Convert.ToDecimal(totale.Compute("SUM(Totale)", ""));

                //trovo la persona sul folgio presenze
                if (Presenze.Select(string.Format("Persons_id = {0}", personID)).Count() > 0)
                {

                    DataRow[] rows = Presenze.Select(string.Format("Persons_id = {0}", personID));
                    DataRow[] rowsTot = Presenze.Select(string.Format("Persons_id = {0} AND ProjectCode='Total'", personID));

                    Presenze.Select(string.Format("Persons_id = {0}", personID));


                    //totale rimborso spese
                    if (sum != null)
                    {
                        rows[0]["Somma Totale"] = sum;
                        rowsTot[0]["Somma Totale"] = sum;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "Altre Spese")
                    {
                        rows[0]["Rimborso Spese"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["Rimborso Spese"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "BUONI PASTO")
                    {
                        rows[0]["N. BUONI"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Tot. Buoni"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["N. BUONI"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Tot. Buoni"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "TRASFERTA ESTERO")
                    {
                        rows[0]["N. Tras ESTERO"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Spese Tras ESTERO"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["N. Tras ESTERO"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Spese Tras ESTERO"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "TRASFERTA ITALIA")
                    {
                        rows[0]["N. Tras ITALIA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Spese Tras ITALIA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["N. Tras ITALIA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Spese Tras ITALIA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "indennità USA")
                    {
                        rows[0]["Inden. USA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Inden. € USA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["Inden. USA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Inden. € USA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "AMS Rep. Settimanale")
                    {
                        rows[0]["Nr. Reperibilità AMS settimanale"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Reperibilità AMS settimanale"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["Nr. Reperibilità AMS settimanale"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Reperibilità AMS settimanale"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "Reperibilità")
                    {
                        rows[0]["Nr. Reperibilità diurna"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Reperibilità diurna"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        rowsTot[0]["Nr. Reperibilità diurna"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rowsTot[0]["Reperibilità diurna"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                }
            }
        }
        catch (Exception ex)
        {
            var st = new StackTrace(ex, true);
            var sf = st.GetFrame(st.FrameCount - 1);
            string ErrorLine = clsUtility.NullToString(sf.GetFileLineNumber()).ToString();
            string MethodName = clsUtility.NullToString(sf.GetMethod().Name).ToString();
            string FileSource = clsUtility.NullToString(sf.GetFileName()).ToString();
            string Description = String.Format("Method Name: {0} - Error Line: {1} - FileSource: {2}", MethodName, ErrorLine, FileSource);
            //clsLog.WriteErrLog("0", ex.Message, Description.ToString());
        }
    }

    /// <summary>
    /// aggiunta della riga grand totale alla fine del file
    /// </summary>
    /// <param name="dsPresenze"></param>
    /// <param name="dsSpese"></param>
    private void AddGrandTotal(ref DataSet dsPresenze, DataSet dsSpese)
    {
        try
        {
            DataTable Presenze = dsPresenze.Tables[0];
            //riga progetto valorizzo con Grand Total
            DataRow Totale = Presenze.NewRow();
            Totale["ProjectCode"] = "Grand Total";

            DataTable OnlyTotal = Presenze.Select("ProjectCode='Total'").CopyToDataTable();

            for (int x = 4; x < OnlyTotal.Columns.Count; x++)
            {
                decimal Somma = 0;
                try
                {
                    string NomeColonna = OnlyTotal.Columns[x].ColumnName;

                    //totale delle ore
                    if (NomeColonna == "Totale Ore")
                    {
                        Somma = OnlyTotal.AsEnumerable().Sum(r => r.Field<decimal?>(NomeColonna) ?? 0);
                        Totale[OnlyTotal.Columns[x].ColumnName] = Somma;
                    }

                    //totale per ogni giorno
                    Somma = OnlyTotal.AsEnumerable().Sum(r => r.Field<decimal?>(NomeColonna) ?? 0);
                    Totale[OnlyTotal.Columns[x].ColumnName] = Somma;
                }
                catch (Exception)
                {
                }
            }

            dsPresenze.Tables[0].Rows.Add(Totale);

            //DataRow TotaleFormula = Presenze.NewRow();
            //TotaleFormula["ProjectCode"] = "Grand Total Formula";
            //dsPresenze.Tables[0].Rows.Add(TotaleFormula);
        }
        catch (Exception ex)
        {
            var st = new StackTrace(ex, true);
            var sf = st.GetFrame(st.FrameCount - 1);
            string ErrorLine = clsUtility.NullToString(sf.GetFileLineNumber()).ToString();
            string MethodName = clsUtility.NullToString(sf.GetMethod().Name).ToString();
            string FileSource = clsUtility.NullToString(sf.GetFileName()).ToString();
            string Description = String.Format("Method Name: {0} - Error Line: {1} - FileSource: {2}", MethodName, ErrorLine, FileSource);
        }
    }

    protected void EstraiEformattaExcel(DataSet dsPresenze, string fileName)
    {
        bool ret;
        using (ExcelEngine excelEngine = new ExcelEngine())
        {
            IApplication application = excelEngine.Excel;
            application.DefaultVersion = ExcelVersion.Excel2016;

            //Create a new workbook
            IWorkbook workbook = application.Workbooks.Create(1);
            IWorksheet sheet = workbook.Worksheets[0];

            //Create a dataset from XML file
            DataSet customersDataSet = dsPresenze;

            //Create datatable from the dataset
            DataTable dataTable = new DataTable();
            dataTable = customersDataSet.Tables[0];

            //Import data from the data table with column header, at first row and first column, 
            //and by its column type.
            sheet.ImportDataTable(dataTable, true, 1, 1, true);

            //Get the used Range
            Syncfusion.XlsIO.IRange usedRange = sheet.UsedRange;

            ColoraGiallo(ref sheet);
            ColoraVerdeAndHeader(ref sheet);

            sheet.UsedRange.AutofitColumns();

            //Blocco header
            sheet.Range["A2"].FreezePanes();

            //le prime 4 colonne
            sheet.Range["E2"].FreezePanes();

            ret = Utilities.ExporXlsxWorkbook(workbook, string.Format("{0}.xlsx", fileName));

        }

        // Avvio download dopo che è stato prodotto il file
        if (ret) ScriptManager.RegisterStartupScript(this, GetType(), "pushButton", "window.onload = function() { triggeFileExport('" + fileName + ".xlsx'); };", true);
    }

    /// <summary>
    /// colora verde totali e header
    /// </summary>
    /// <param name="usedRange"></param>
    private static void ColoraVerdeAndHeader(ref IWorksheet sheet)
    {
        try
        {
            Syncfusion.XlsIO.IRange usedRange = sheet.UsedRange;
            for (int a = 0; a < usedRange.Rows.Count(); a++)
            {
                Syncfusion.XlsIO.IRange row = usedRange.Rows[a];
                if (row.Columns[3].Value.ToNullToString() == "Total")
                {
                    row.EntireRow.CellStyle.Color = Color.LightGreen;
                    row.EntireRow.CellStyle.Borders.Color = ExcelKnownColors.Grey_25_percent;
                    row.EntireRow.CellStyle.Font.Bold = true;
                    row.EntireRow.Borders.Color = ExcelKnownColors.Grey_25_percent;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeLeft].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeRight].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeTop].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeBottom].LineStyle = ExcelLineStyle.Thin;
                }
                else if (row.Columns[3].Value.ToNullToString() == "Grand Total")
                {
                    row.EntireRow.CellStyle.Color = Color.Orange;
                    row.EntireRow.CellStyle.Borders.Color = ExcelKnownColors.Grey_25_percent;
                    row.EntireRow.CellStyle.Font.Bold = true;
                    row.EntireRow.CellStyle.Font.Size = 12;
                    row.EntireRow.Borders.Color = ExcelKnownColors.Grey_25_percent;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeLeft].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeRight].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeTop].LineStyle = ExcelLineStyle.Thin;
                    row.EntireRow.CellStyle.Borders[ExcelBordersIndex.EdgeBottom].LineStyle = ExcelLineStyle.Thin;

                    //ciclo per inserire la sommatoria di tutte le colonne nel grand total
                    for (int i = 4; i < row.Cells.Count(); i++)
                    {
                        string SummCell = "";
                        string SummCellByPerson = "";
                        //ciclo tutte le righe per prendere solo le righe contenenti i totali
                        for (int y = 0; y < usedRange.Rows.Count(); y++)
                        {

                            IRange rowTot = usedRange.Rows[y];
                            //se è una riga di totale salvo l'indirizzo della cella e inserisco la formula per le singole ore della persona
                            if (rowTot.Columns[3].Value.ToNullToString() == "Total")
                            {
                                //salvo le varie celle da sommare
                                SummCell += rowTot.Cells[i].AddressLocal.ToString() + ";";
                                //assegno la fornula alla cella
                                rowTot.Cells[i].Formula = string.Format("=Sum({0})", SummCellByPerson.Substring(0, SummCellByPerson.Length - 1));

                                SummCellByPerson = "";
                            }
                            else
                            {
                                //se non è riga totali mi salvo l'indirizzo della cella, appena trovo un total inserisco la formula
                                SummCellByPerson += rowTot.Cells[i].AddressLocal.ToString() + ";";
                            }
                        }
                        //assegno la fornula alla cella
                        row.Cells[i].Formula = string.Format("=Sum({0})", SummCell.Substring(0, SummCell.Length - 1));
                    }
                }
            }
        }
        catch (Exception)
        {
        }
    }

    /// <summary>
    /// colorazione giallo colonne sabto e domenica
    /// </summary>
    /// <param name="usedRange"></param>
    private static void ColoraGiallo(ref IWorksheet sheet)
    {
        try
        {
            Syncfusion.XlsIO.IRange usedRange = sheet.UsedRange;
            string[] GiorniFestivi = { "Saturday", "Sunday" };
            Syncfusion.XlsIO.IRange row = usedRange.Rows[0];
            //colore testata
            row.CellStyle.Color = Color.Yellow;
            row.CellStyle.Font.Bold = true;
            row.CellStyle.Font.Size = 12;
            //stile bordi
            row.CellStyle.Borders[ExcelBordersIndex.EdgeLeft].LineStyle = ExcelLineStyle.Thin;
            row.CellStyle.Borders[ExcelBordersIndex.EdgeRight].LineStyle = ExcelLineStyle.Thin;
            row.CellStyle.Borders[ExcelBordersIndex.EdgeTop].LineStyle = ExcelLineStyle.Thin;
            row.CellStyle.Borders[ExcelBordersIndex.EdgeBottom].LineStyle = ExcelLineStyle.Thin;

            row.FreezePanes();

            //colore sabato e domenica
            for (int i = 1; i < row.Columns.Count(); i++)
            {
                try
                {
                    //controllo se SAB o DOM cosi da colorare in giallo la riga
                    if (GiorniFestivi.Contains(Convert.ToDateTime(row.Columns[i].Value.ToNullToString()).DayOfWeek.ToString()))
                    {
                        sheet.Range[row.Columns[i].AddressLocal].EntireColumn.CellStyle.Color = Color.Yellow;
                    }
                }
                catch (Exception)
                {
                }
            }
        }
        catch (Exception)
        {
        }
    }
}