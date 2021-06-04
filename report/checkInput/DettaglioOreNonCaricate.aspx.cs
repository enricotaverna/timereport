using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class report_checkInput_DettaglioOreNonCaricate : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    // struttura della lista
    public class ClRecordLista
    {
        public string  data;
        public Int16 OreMancanti;
    }

protected void Page_Load(object sender, EventArgs e)
    {
        Int16 iContractHours = 8;

        // recupera variabili di sessione
        string sMese = Request.QueryString["mese"].ToString();
        string sAnno = Request.QueryString["anno"].ToString();
        string sPersons_id = Request.QueryString["persons_id"];

        Auth.CheckPermission("ADMIN", "CUTOFF");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Definisce tabella interna e lista
        DataTable dt = new DataTable();
        List<ClRecordLista> ListaReport = new List<ClRecordLista> { };

        // Legge record
        DataTable dtPerson = Database.GetData("SELECT Persons.Name, Company.Name as CName, Persons.ContractHours, Persons.Mail FROM Persons INNER JOIN Company ON Persons.Company_id = Company.Company_id WHERE Persons_id = " + sPersons_id, this.Page);

        if (dtPerson.Rows.Count > 0) // record trovato  
                {
                DataRow rdr = dtPerson.Rows[0];

	            iContractHours = Convert.ToInt16(rdr["ContractHours"]);	
                lblMail.Text = rdr["mail"].ToString();
                lblMail.NavigateUrl = "mailto:" + rdr["mail"].ToString();
                lblNome.Text = rdr["Name"].ToString();
                lblOre.Text = rdr["ContractHours"].ToString();
                lblSocieta.Text = rdr["CName"].ToString();     
                }
                
        // cicla sui giorni del mese
        object result = new object();
        for (int f = 1; f <= System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) ; f++) 
        {

            string currData = f.ToString() + "/" + sMese + "/" + sAnno;

            // esegue check se lavorativo
            if ((DayOfWeek)(Convert.ToDateTime(currData)).DayOfWeek != DayOfWeek.Saturday && (DayOfWeek)(Convert.ToDateTime(currData)).DayOfWeek != DayOfWeek.Sunday) 
                {            

                    // somma ore della giorata
                    result = Database.ExecuteScalar("SELECT SUM (hours) FROM hours WHERE Date =" + ASPcompatility.FormatDateDb( currData, false) + " AND HourType_Id = 1 AND persons_id=" +sPersons_id, this.Page);

                    // se inferiore orario lavorativo aggiunge item
                    if (result == DBNull.Value || Convert.ToInt16(result) < iContractHours) 
                    {
                        ClRecordLista curr = new ClRecordLista();
                        curr.data = f.ToString() + "/" + sMese + "/" + sAnno;
                        curr.OreMancanti = result == DBNull.Value ? (short)iContractHours : (short)(iContractHours - Convert.ToInt16(result));
                        ListaReport.Add(curr);
                    }
                }
        }

        // Carica Tabella ed effettua Bind con GridView
        CaricaTabella(ListaReport);
    }

protected void CaricaTabella(List<ClRecordLista> ListaReport) 
    { 

        // Definisce tabella interna e lista
        DataTable dt = new DataTable();

         //  Colonne del report
        dt.Columns.Add("Data");
        dt.Columns.Add("Ore Mancanti");

        // Carica tabella
        foreach ( ClRecordLista curr in ListaReport)
        {
            DataRow dr = dt.NewRow();
            dr["Data"] = curr.data;
            dr["Ore Mancanti"] = curr.OreMancanti;
            dt.Rows.Add(dr);
        }

        // Bind della tabella all griglia
        GVDettaglioOre.DataSource = dt;
        GVDettaglioOre.DataBind();

    }

}
