using Amazon.EC2.Model;
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
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
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
        //aggiungi colonne delle spese al datatable presenze
        AggiungiColonne(ref dsPresenze);
        //lavorazione del dt presenze aggiungengo le spese
        LavoraDataset(dsPresenze, dsSpese);
        //estrazione e download del foglio excel
        EstraiEformattaExcel(dsPresenze, NomePresenze);

    }

    /// <summary>
    /// eliminazione degli utenti con sole festivita inserite
    /// </summary>
    /// <param name="dsPresenze"></param>
    private void EliminaInattivi(DataSet dsPresenze) {

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
        if (listaPersoneDaEliminare != "" )
        {
            listaPersoneDaEliminare.Substring(0, listaPersoneDaEliminare.Length - 1);

            //listaPersoneDaEliminare
            DataTable filtered = dsPresenze.Tables[0].Select(string.Format("Persons_id NOT IN ({0})", listaPersoneDaEliminare)).CopyToDataTable();
            dsPresenze.Tables.RemoveAt(0);
            dsPresenze.Tables.Add(filtered);
        }        

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

            //DataColumn NrAltreSpese = dsPresenze.Tables[0].Columns.Add("NrAltreSpese", typeof(decimal));
            //NrAltreSpese.AllowDBNull = true;
            //NrAltreSpese.Unique = false;
            //NrAltreSpese.ColumnName = "Nr. Altre Spese";

            //DataColumn AltreSpese = dsPresenze.Tables[0].Columns.Add("AltreSpese", typeof(decimal));
            //AltreSpese.AllowDBNull = true;
            //AltreSpese.Unique = false;
            //AltreSpese.ColumnName = "Altre Spese";

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

                    Presenze.Select(string.Format("Persons_id = {0}", personID));


                    //totale rimborso spese
                    if (sum != null)
                    {
                        rows[0]["Somma Totale"] = sum;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "Altre Spese")
                    {
                        rows[0]["Rimborso Spese"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                        //rows[0]["Nr. Altre Spese"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        //rows[0]["Altre Spese"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "BUONI PASTO")
                    {
                        rows[0]["N. BUONI"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Tot. Buoni"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "TRASFERTA ESTERO")
                    {
                        rows[0]["N. Tras ESTERO"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Spese Tras ESTERO"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "TRASFERTA ITALIA")
                    {
                        rows[0]["N. Tras ITALIA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Spese Tras ITALIA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "indennità USA")
                    {
                        rows[0]["Inden. USA"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Inden. € USA"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "AMS Rep. Settimanale")
                    {
                        rows[0]["Nr. Reperibilità AMS settimanale"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Reperibilità AMS settimanale"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
                    }

                    if (Spesa["Descrizione"].ToNullToString() == "Reperibilità")
                    {
                        rows[0]["Nr. Reperibilità diurna"] = (Spesa["Quantita"].ToNullToString() != "") ? Spesa["Quantita"].ToNullToString() : null;
                        rows[0]["Reperibilità diurna"] = (Spesa["Totale"].ToNullToString() != "") ? Spesa["Totale"].ToNullToString() : null;
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

    protected void EstraiEformattaExcel(DataSet dsPresenze, string fileName)
    {
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

            //Iterate the rows in the used range
            //foreach (Syncfusion.XlsIO.IRange row in usedRange.Rows)
            for (int a= 0; a < usedRange.Rows.Count(); a++)
            {
                Syncfusion.XlsIO.IRange row = usedRange.Rows[a];
                
                if (a == 0)
                {
                    row.CellStyle.Color = Color.Yellow;
                    row.CellStyle.Font.Bold = true;
                    row.CellStyle.Font.Size = 12;
                }

                String[] rowData = new String[row.Columns.Count()];

                for (int i = 0; i < row.Columns.Count(); i++)
                {                   
                    if (row.Columns[3].Value.ToNullToString() == "Total")
                    {
                        row.CellStyle.Color = Color.LightGreen;
                        row.CellStyle.Font.Bold = true;
                    }
                }
            }

            sheet.UsedRange.AutofitColumns();

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", string.Format("attachment;filename={0}.xlsx", fileName));
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                workbook.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                //Response.Redirect("/timereport/report/Presenze/PresenzeSpese.aspx");
                Response.End();
            }
        }
    }
}