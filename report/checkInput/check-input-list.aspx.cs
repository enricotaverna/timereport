using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.ComponentModel;
using System.IO;
using System.Data.OleDb;

public partial class report_checkInput_check_input_list : System.Web.UI.Page
{
    public class CheckGiorni
    {
        public string persons_id;
        public int giorno;
        public int ore;
    }

   // Lista che contiene le giornate caricate da DB
    List<CheckGiorni> lCheckGiorni = new List<CheckGiorni> { };

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("ADMIN", "CUTOFF");

        // Carica la griglia dei risultati
        CostruiciGriglia();
    }

    // Costruisce la griglia
    protected void  CostruiciGriglia()
    {
        string sWhere = "";
        string sSelect = "";

        string sMese = Request.QueryString["mese"].ToString();
        string sAnno = Request.QueryString["anno"].ToString();

        // Calcola mese precedente
        String sAnnoPrec = Convert.ToInt16(sMese) == 1 ? (Convert.ToInt16(sAnno) - 1).ToString() : sAnno;
        String sMesePrec = Convert.ToInt16(sMese) == 1 ? "12" : (Convert.ToInt16(sMese) - 1).ToString();

        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMesePrec + "/" + sAnnoPrec, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnnoPrec), Convert.ToInt16(sMesePrec)) + "/" + sMesePrec + "/" + sAnnoPrec, false);

        // Inizializza tabella DATAGRID
        DataTable dt = new DataTable();
        dt.Columns.Add("Nome");
        dt.Columns.Add("Società");
        dt.Columns.Add("OreContratto");
        dt.Columns.Add("StatoTR");
        dt.Columns.Add("GGmancanti");
        dt.Columns.Add("GGMesePrecedente");
        dt.Columns.Add("Dettagli");

        // init 
        sWhere = " WHERE Persons.active = 1 ";

        // carica tutte le ore del mese da DB
        CaricaOreMese(sMese, sAnno);

        // Seleziona le persone tenendo conto della società
        if (DL_societa.SelectedValue != "all")
            sWhere = sWhere + "AND Company.company_id = " + DL_societa.SelectedValue.ToString();

        sWhere = sWhere + " GROUP BY Persons.Persons_Id,  Persons.Name,  Persons.mail, Company.Name, Persons.ContractHours  ORDER BY Persons.Name";

        sSelect = "SELECT  Persons.Persons_Id,  Persons.Name,  Persons.mail, Company.Name as CName, Persons.ContractHours, " +
                  " ( SELECT  SUM(Hours)  FROM hours where Persons_id =  Persons.Persons_id and hours.date >= " + sDataInizio + " and hours.date <= " + sDataFine + " ) as oreMesePrecedente, " +
                  " ( SELECT stato from logTR Where LogTR.Mese=" + sMese + " AND LogTR.Anno=" + sAnno + " AND persons_id=Persons.Persons_id ) as stato " + 
                  " FROM ( Persons INNER JOIN Company ON Persons.Company_id = Company.Company_id ) " +  
                  sWhere;

        // Esegue Select sulle persone attive
        Database.OpenConnection();

        using (SqlDataReader rdr = Database.GetReader(sSelect, this.Page))
        {

            // Loop sulle persone selezionate
            while (rdr != null && rdr.Read())
            {

                DataRow dr = dt.NewRow();
                dr["Nome"] = rdr["Name"];
                dr["Società"] = rdr["CName"];
                dr["OreContratto"] = rdr["ContractHours"];
                dr["GGmancanti"] = CalcolaGiorni(rdr["persons_id"].ToString(), Convert.ToInt16(rdr["ContractHours"]), sMese, sAnno);

                // mette link in caso di giornate mancanti
                if (dr["GGMancanti"] != "") 
                    dr["Dettagli"] = "<a href=/timereport/report/checkInput/DettaglioOreNonCaricate.aspx?persons_id='" + rdr["persons_id"] + "'&mese=" + sMese + "&anno=" + sAnno + ">[Dettagli]</a>";                          

                if (rdr["oreMesePrecedente"] != DBNull.Value )
                    dr["GGMesePrecedente"] = Convert.ToInt16(rdr["oreMesePrecedente"]) > 0 ? Convert.ToInt16(rdr["oreMesePrecedente"]) / 8 : 0;

                dr["StatoTR"] = rdr["stato"].ToString() == "1" ? "chiuso" : "";

                // filtro sullo stato del TR
                switch (DL_TRChiuso.SelectedValue)
                {
                    // aggiunge sempre record
                    case "all":
                        dt.Rows.Add(dr);
                        break;
                    // aggiunge record se trova il TR chiuso
                    case "1":
                        if (dr["StatoTR"] == "chiuso")
                            dt.Rows.Add(dr);
                        break;
                    // aggiunge record se trova il TR chiuso
                    case "0":
                        if (dr["StatoTR"] != "chiuso")
                            dt.Rows.Add(dr);
                        break;
                }
            }
        }

        // sort
        dt.DefaultView.Sort = "GGMancanti";
        dt.DefaultView.ToTable();

        // Caricamento DataGrid
        GV_ListaOre.DataSource = dt;
        GV_ListaOre.DataBind();
 
    }

    // Calcola Giorni mese precendente
    protected string GGMesePrecedente(string Persons_id, string sMese, string sAnno)
    {

        sMese = Convert.ToInt16(sMese) == 1 ? "12" : (Convert.ToInt16(sMese) - 1).ToString();
        sAnno = Convert.ToInt16(sMese) == 1 ? (Convert.ToInt16(sAnno) - 1).ToString() : sAnno;
        int sGiorni = 0;

        // Calcola mese precedente
        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMese + "/" + sAnno, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) + "/" + sMese + "/" + sAnno, false);

        Database.OpenConnection();
        
        string query = "SELECT SUM (hours) FROM hours WHERE Date >=" + sDataInizio + " AND  Date <=" + sDataFine + " AND HourType_Id = 1 AND persons_id=" + Persons_id;

        object result = Database.ExecuteScalar(query, this.Page);
        if (result != DBNull.Value)
            sGiorni = Convert.ToInt16(result) > 0 ? Convert.ToInt16(result) / 8 : 0;

        //Database.CloseConnection();

        return(sGiorni.ToString());

    }

    // Carica giorni in lista interna
    protected void CaricaOreMese(string sMese, string sAnno)
    {

        // per preparare la select
        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMese + "/" + sAnno, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) + "/" + sMese + "/" + sAnno, false);     

        Database.OpenConnection();

        // carica tutte le ore del mese per tutte le persone nella lista lCheckGiorni
        using (SqlDataReader rdr = Database.GetReader("SELECT persons_id, date, hours FROM HOURS WHERE Date>=" + sDataInizio + "AND  Date<=" + sDataFine + " AND HourType_Id = 1", this.Page))
        {

            while (rdr != null && rdr.Read())
            {

                CheckGiorni curr = new CheckGiorni();
                curr.persons_id = rdr["persons_id"].ToString();
                curr.giorno = Convert.ToDateTime(rdr["date"]).Day;
                curr.ore = Convert.ToInt16(rdr["hours"]);
                
                // carica lista
                lCheckGiorni.Add(curr);                        
            }
        }
    } // CaricaOreMese

    // Calcola i giorni mancanti nel mese
    protected int CalcolaGiorni(string sPersons_id, int iContractHours, string sMese, string sAnno)
    {

        // Calcolo giornate caricate
        // cicla sui giorni del mese selezionato		
        int iMissingDays = 0;

        for (int f = 1; f < System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)); f++)
        {

            int iHoursCounted = 0;

            // Data di riferimento in formato stringa			
            string sDate = f.ToString() + "/" + sMese + "/" + sAnno;

            //Salta sabato e domenica (i festivi sono di interesse per il controllo degli inserimenti nel TR)
            if ((DayOfWeek)(Convert.ToDateTime(sDate)).DayOfWeek != DayOfWeek.Saturday && (DayOfWeek)(Convert.ToDateTime(sDate)).DayOfWeek != DayOfWeek.Sunday) 
            {
                // loop sulla lista per tutte le ore di persona / giorno
                foreach ( CheckGiorni curr in lCheckGiorni.Where(curr => curr.persons_id== sPersons_id && curr.giorno == f ) )
                {
                    // Loop sulle ore
                    iHoursCounted = iHoursCounted + curr.ore;
                } // foreach
            
                if (iHoursCounted < iContractHours)
                        iMissingDays++;
            } // if
        } // for

        return (iMissingDays);
    }

    // richiesta da export in excel
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Verifies that the control is rendered */
    }

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {

        Response.ClearContent();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "TRexport.xls"));
        Response.ContentType = "application/ms-excel";
        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);

        CostruiciGriglia();
        
        GV_ListaOre.RenderControl(htw);
        Response.Write(sw.ToString());
        Response.End();

    }
}