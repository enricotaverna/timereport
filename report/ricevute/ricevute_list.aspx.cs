using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.IO;
using System.Text;
using System.Web.UI.HtmlControls; 

public partial class report_ricevute_ricevute_list : System.Web.UI.Page
{

    // crea lista di oggetti per la stampa delle ricevute a fondo pagina
    class IndexFileObj {
        public string index {get; set; }
        public string expenses_id {get; set; }
        public string filename {get; set; }
        public string preview { get; set; }
        public string shortFileName { get; set; }
    }

    List<IndexFileObj> IndexFile = new List<IndexFileObj>();
    protected void Page_Load(object sender, EventArgs e)
    {

        // autority check in funzione del tipo chiamata della pagina
        if (Request.QueryString["mode"] == "admin")
            Auth.CheckPermission("REPORT", "TICKET_ALL");
        else
            Auth.CheckPermission("REPORT", "TICKET_USER");

        // pulisce lista
        IndexFile.Clear();

        // Valorizza nome consulente e mese
        DateTime Dtmese = new DateTime(2014, Convert.ToInt16(Request.QueryString["mese"]), 1);
        LBIntestazione.Text = Dtmese.ToString("MMMM") + " " + Request.QueryString["anno"].ToString();
        
        // calcola primo e ultimo giorno del mese  
        string mese = Request.QueryString["mese"].ToString();
        string anno = Request.QueryString["anno"].ToString();

        string datada = "01/" + mese + "/" + anno;
        string dataa = ASPcompatility.LastDay(Convert.ToInt16(mese), Convert.ToInt16(anno)) + "/" + mese + "/" + anno;

        // valorizza parametri SQLdatasource      
        SQLDSricevute.SelectParameters["datada"].DefaultValue = datada;
        SQLDSricevute.SelectParameters["dataa"].DefaultValue = dataa;

        // se mode = admin seleziona le persone in base al parametro, altrimenti forza con la variabile di sessioni
        if (Request.QueryString["mode"] == "admin") 
            {       
            SQLDSricevute.SelectParameters["persons_id"].DefaultValue = Request.QueryString["persona"].ToString(); // persone da DDL
            SQLDSricevute.SelectParameters["societa"].DefaultValue = Request.QueryString["societa"].ToString(); // società da DDL
            SQLDSricevute.SelectParameters["tipospesa"].DefaultValue = Request.QueryString["tipospesa"].ToString(); // tipospesa da DDL
            }
        else         // se mode != admin forza con la variabile di sessione
            SQLDSricevute.SelectParameters["persons_id"].DefaultValue = Session["persons_id"].ToString(); // persona da variabile di sessione

        // carico array con i nomi dei file caricati sul mese in analisi
        Carica_Lista(mese, anno, Request.QueryString["mode"]);

        // Stampa la tabella con le immagini (se ce ne sono)
        if (IndexFile.Count > 0)

            Stampa_Ricevute();
  }

    // Stampa la tabella con le immagini
    protected void Stampa_Ricevute()
    {

        // loop per stampare immagini
        //string stWebPath = ConfigurationSettings.AppSettings["PATH_RICEVUTE"] + lDataSpesa.Substring(0, 4) + "/" + lDataSpesa.Substring(4, 2) + "/" + Session["UserName"].ToString().Trim() + "/";
        string stFile = "";
        HtmlTableRow row = new HtmlTableRow(); // aggiunge riga  

        // ciclo su tutte le immagini corrispondenti a quella spesa, lista oggetti è costruita in modo da essere
        // sempre multipla di 3
        foreach (IndexFileObj ogg in IndexFile)
        {

            stFile = ogg.filename;
            
            // crea la cella
            HtmlTableCell cell1 = new HtmlTableCell();

            // alla prima cella crea la riga
            if (Convert.ToInt16(ogg.index) % 3 == 1)
                row = new HtmlTableRow(); // aggiunge riga   

            // invece di ogg.index
            cell1.InnerHtml = ogg.filename != "" ? " <A name=" + ogg.shortFileName  + ">" + ogg.shortFileName + "<A><br/><a href='" + ogg.filename + "' download='" + Path.GetFileName(ogg.filename) + "' ><img height=300 src='" + ogg.preview + "' />" : "";
            cell1.Width = "300px";
            cell1.Align = "center";

            row.Cells.Add(cell1);
 
            // ogni tre celle aggiunge una riga
            if ( Convert.ToInt16(ogg.index) % 3 == 0 ) {
                TitoloTabellaRicevute.Attributes.Add("style", "display:visible");
                TabellaRicevute.Rows.Add(row);    }
       
        } //  next 

    }

    // popola la lista che contiene nomi file e expensed_id associati ai file delle ricevute
    // se mode = "admin" carica tutte le ricevute del mese
    protected void Carica_Lista(string mese, string anno, string mode)
    {

        // recupera tutte le ricevute associate a questa spesa
        string[] filePaths = null;        

        try
        {
            string TargetLocation = "";

            if (mode == "admin")
                {       
                if (Request.QueryString["persona"] == "")
                    // costruisci il pach di ricerca: public + anno + mese 
                    TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + anno + "\\" + mese + "\\";            
                else
                    // costruisci il pach di ricerca: public + anno + mese + nome persona 
                    TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + anno + "\\" + mese + "\\" + Request.QueryString["username"].ToString().Trim() + "\\";
                }
            
            if (mode != "admin")
                // costruisci il pach di ricerca: public + anno + mese + nome persona 
                TargetLocation = Server.MapPath(ConfigurationSettings.AppSettings["PATH_RICEVUTE"]) + anno + "\\" + mese + "\\" + Session["UserName"].ToString().Trim() + "\\";            
            
            // carica immagini, se solo mese è ricorsivo sulle subdirectories
            filePaths = Directory
                                .GetFiles(TargetLocation, "*.*", SearchOption.AllDirectories)
                                .Where(file => file.ToLower().EndsWith("jpg") || file.ToLower().EndsWith("tiff") || file.ToLower().EndsWith("pdf") || file.ToLower().EndsWith("png") || file.ToLower().EndsWith("jpeg") || file.ToLower().EndsWith("gif") || file.ToLower().EndsWith("bmp"))
                                .ToArray();
        }
        catch (Exception exp)
        {
            //non fa niente ma evita il dump
        }

        // Se non esistono immagini la cella rimane vuota
        if (filePaths == null || filePaths.Length == 0)
            return;

        string stWebPath = "";
        string stFile = "";

        for (int i = 0; i < filePaths.Length; i++)
        {

            // Estrae il nome della persona da file
            string strNomePersona = Path.GetDirectoryName(filePaths[i]).Substring(Path.GetDirectoryName(filePaths[i]).LastIndexOf("\\")+1);
            stWebPath = ConfigurationSettings.AppSettings["PATH_RICEVUTE"] + anno + "/" + mese + "/" + strNomePersona.Trim() + "/";
            stFile = stWebPath + Path.GetFileName(filePaths[i]);

            var start = filePaths[i].IndexOf("fid-") + 4;
            var stExpenses_id = filePaths[i].Substring(start, filePaths[i].LastIndexOf("-") - start);

            // aggiunti elemento con contatore, nome file e id spesa da usare nella stampa dei riferimenti alle ricevute
            IndexFile.Add(new IndexFileObj() { index = (i+1).ToString(), 
                                               filename = stFile,
                                               preview = filePaths[i].EndsWith("pdf") ? "/timereport/images/icons/other/pdf.png" : stFile ,
                                               expenses_id = stExpenses_id,
                                               shortFileName = filePaths[i].Substring(start-4, 29)
            }
                         );
        } //  next 

        // aggiunge oggetti vuoti fino ad arrivare ad un multiplo di 3 per poi stampare una tabella con le immagini affiancate
        int resto = filePaths.Length % 3;
        resto = resto == 0 ? 0 : 3 - resto;

        for (int i = filePaths.Length; i < filePaths.Length+resto; i++)
            IndexFile.Add(new IndexFileObj() { index = (i+1).ToString(), 
                                               filename = "" ,
                                               preview = "",
                                               expenses_id = ""
            }); 
    }   

    // popola la cella con i riferimenti alle ricevute
    protected void GVricevute_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        // salta l'intestazione
        if (e.Row.RowType != DataControlRowType.DataRow)
        {
            return;
        }

        // stampa i primi 30 car
        if (e.Row.Cells[11].Text.Length > 55)
            e.Row.Cells[11].Text = e.Row.Cells[11].Text.Substring(1, 55);

        // estrae dalla cella mese e anno
        //string mese = e.Row.Cells[1].Text.Substring(3, 2);
        //string anno = e.Row.Cells[1].Text.Substring(6, 4);
            
        // ci sono immagini, stampo i riferimenti nella cella
        e.Row.Cells[12].Text = "";

        // ciclo su tutte le immagini corrispondenti a quella spesa
        foreach (IndexFileObj ogg in IndexFile)   
        {
            // se l'id spesa è lo stesso stampa il riferimento (uno o +)
            if (ogg.expenses_id ==  e.Row.Cells[0].Text)
                //e.Row.Cells[12].Text = e.Row.Cells[12].Text + "<A href=#" + ogg.shortFileName + "> link </A><br/>";
                e.Row.Cells[12].Text = e.Row.Cells[12].Text + "<A href='" +  ogg.filename + "'><img width=12px height=12px src=/timereport/images/icons/other/glyphicons-28-search.png></A>" + "&nbsp;<A href = '" + ogg.filename + "' download = '" + Path.GetFileName(ogg.filename) + "' ><img width=12px height=12px src=/timereport/images/icons/glyphicons/glyphicons-182-download-alt.png></A><br/> ";
        } //  next 

    }
    
}