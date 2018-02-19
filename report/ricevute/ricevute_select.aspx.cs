using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Globalization;

public partial class report_ricevute_select : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT", "TICKET_ALL");

        // Popola Drop Down con lista progetti
        if (!IsPostBack) {
            // Popola dropdown con i valori          
            Bind_DDLMesi();
            Bind_DDLAnni();
            // Popola persone leggendo se ci sono giustificativi per il mese
            Bind_DDLPersone();
            // recupera valori controlli
            RipristinaControlli();
        }

    }

    // Lancia Pagina con GridView per visualizzazione report
    protected void sottometti_Click(object sender , System.EventArgs e ) {        
        Button bt = (Button) sender;

        if (bt.CommandName == "report") 
            {
                // salva valori controlli 
                SalvaControlli();

                Response.Redirect("ricevute_list.aspx?anno=" + DDLAnni.SelectedValue + "&mese=" + DDLMesi.SelectedValue + "&societa=" + DDLSocieta.SelectedValue + "&tipospesa=" + DDLTipoSpesa.SelectedValue +
                                  "&persona=" + DDLPersone.SelectedValue + "&username=" + DDLPersone.SelectedItem + "&mode=admin");
            }
        }
    
    // salva valori dei controlli
    protected void SalvaControlli()
    {
        Session["DDLPersone"] = DDLPersone.SelectedIndex;
        Session["DDLAnni"] = DDLAnni.SelectedIndex;
        Session["DDLMesi"] = DDLMesi.SelectedIndex;

    }

    // salva valori dei controlli
    protected void RipristinaControlli()
    {
        if (Session["DDLPersone"] != null) DDLPersone.SelectedIndex = (int)Session["DDLPersone"] - 1;
        if (Session["DDLAnni"] != null) DDLAnni.SelectedIndex = (int)Session["DDLAnni"];
        if (Session["DDLMesi"] != null) DDLMesi.SelectedIndex = (int)Session["DDLMesi"];
        
    }

    // Popola controllo Mesi
    protected void Bind_DDLMesi()
    {

        DDLMesi.Items.Clear();

        for (int i = 1; i <= 12; i++ )    
            {   
                string monthName = new DateTime(2016, i, 1).ToString("MMMM", CultureInfo.CreateSpecificCulture("it") );
                DDLMesi.Items.Add(new ListItem(monthName, i.ToString("00")));
            }

        // default
        if (Session["DDLMesi"] == null) DDLMesi.SelectedValue = DateTime.Now.Month.ToString();
    }

    // Popola controllo Anni
    public void Bind_DDLAnni()
    {
        DDLAnni.Items.Clear();

        for (int i = MyConstants.First_year; i <= MyConstants.Last_year; i++)
            DDLAnni.Items.Add(new ListItem(i.ToString(), i.ToString()));

        // default
        if (Session["DDLAnni"] == null) DDLAnni.SelectedValue = MyConstants.Last_year.ToString();
    }


    // Popola controllo Persone solo con i nomi con giustificavo salvato
    protected void Bind_DDLPersone()
    {
        DDLPersone.Items.Clear();
        Database.OpenConnection();

        using (SqlDataReader rdr = Database.GetReader("SELECT Persons.Persons_id, Persons.Name from Persons ORDER BY  Persons.Name DESC", this.Page))
        {
            if (rdr != null)
            {
                 while (rdr.Read())
                 {

                     try
                     {

                         // se esiste la directory popola l'item della DDL
                         string TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + DDLAnni.SelectedValue.ToString() + "\\" + DDLMesi.SelectedValue.ToString() + "\\" + rdr["name"].ToString().Trim() + "\\";

                         if (Directory.Exists(TargetLocation))
                             DDLPersone.Items.Insert(0, new ListItem(rdr["name"].ToString(), rdr["Persons_id"].ToString()));
                     }
                     catch (Exception exp)
                     {
                         //non fa niente ma evita il dump
                     }

                }
            }

        }

        Database.CloseConnection();

        // nessuna seleazione
        DDLPersone.Items.Insert(0, new ListItem("--- Tutte le persone ---", "")); 

    }

    // CAMBIO MESE IN DDL
    protected void DDLMesi_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Popola persone leggendo se ci sono giustificativi per il mese
        Bind_DDLPersone();

    }

    // CAMBIO ANNO IN DDL
    protected void DDLAnni_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Popola persone leggendo se ci sono giustificativi per il mese
        Bind_DDLPersone();

    }

}