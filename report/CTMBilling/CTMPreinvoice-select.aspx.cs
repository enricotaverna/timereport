using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;

public partial class report_ricevute_select : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("REPORT", "ECONOMICS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // default data
        if (!IsPostBack)
        {
            DateTime currentDate = DateTime.Now;
            DateTime firstDayOfMonth = new DateTime(currentDate.Year, currentDate.Month, 1).AddMonths(-1);
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            TBDataDa.Text = firstDayOfMonth.ToString("dd/MM/yyyy");
            TBDataA.Text = lastDayOfMonth.ToString("dd/MM/yyyy");

            //TBDataDa.Text = "01/11/2022";
            //TBDataA.Text = "30/11/2022";

            init_controlli("full");
        }

        // Popola Drop Down con lista progetti
        if (IsPostBack && Page.Request.Form["btnReport"] == null)
        { // Postback non triggerato da pulsante report

            // triggerato da cambio data
            if (TBDataA.Text != (string)Session["PrefatturaDataA"] | TBDataDa.Text != (string)Session["PrefatturaDataDa"])
                init_controlli("full");
            else
                init_controlli("partial");
        }

    }

    // Lancia Pagina con GridView per visualizzazione report
    protected void init_controlli(string mode)
    {
        if (mode == "full")
        {
            Session["PrefatturaDataA"] = TBDataA.Text;
            Session["PrefatturaDataDa"] = TBDataDa.Text;
            // Popola dropdown con i valori          
            Bind_DDLCliente(TBDataDa.Text, TBDataA.Text);
            Bind_LBProgetti(TBDataDa.Text, TBDataA.Text);
            // recupera valori controlli
            RipristinaControlli();
        }
        else
        {
            Bind_LBProgetti(TBDataDa.Text, TBDataA.Text);
        }
    }

    // Lancia Pagina con GridView per visualizzazione report
    protected void sottometti_Click(object sender, System.EventArgs e)
    {
        Button bt = (Button)sender;

        if (bt.CommandName == "report")
        {
            // salva valori controlli 
            SalvaControlli();

        }
    }

    // salva valori dei controlli
    protected void SalvaControlli()
    {

        foreach (Control control in FVForm.Controls)
        {
            if (control is DropDownList)
            {
                DropDownList ddl = (DropDownList)control;
                // fai qualcosa con il controllo DropDownList (ad esempio, leggi o modifica il valore selezionato)
                if (ddl.SelectedIndex != 0)
                    Session[ddl.ID] = ddl.SelectedIndex;
            }

        }
    }
    // salva valori dei controlli
    protected void RipristinaControlli()
    {

        foreach (Control control in FVForm.Controls)
        {
            if (control is DropDownList)
            {
                DropDownList ddl = (DropDownList)control;
                // fai qualcosa con il controllo DropDownList (ad esempio, leggi o modifica il valore selezionato)
                if (Session[ddl.ID] != null)
                    ddl.SelectedIndex = (int)Session[ddl.ID];
            }

        }
    }


    // Popola controllo in base ai carichi ore da data a data
    protected void Bind_DDLCliente(string DataDa, string DataA)
    {
        DDLCliente.Items.Clear();
        DDLCliente.Visible = true;

        DataTable dtCliente = Database.GetData("SELECT DISTINCT B.CodiceCliente AS CodiceCliente , C.Nome1 as NomeCliente FROM Hours " +
                                               "INNER JOIN Projects as B ON B.projects_id = hours.projects_id " +
                                               "INNER JOIN Customers as C ON C.CodiceCliente = B.CodiceCliente " +
                                               "WHERE CTMPreinvoiceNum is null AND date >= " + ASPcompatility.FormatDateDb(DataDa) + 
                                               " AND date <= " + ASPcompatility.FormatDateDb(DataA) +
                                               " AND B.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' " +
                                               " ORDER BY NomeCliente DESC", this.Page);

        foreach (DataRow dtRow in dtCliente.Rows)
        {
            DDLCliente.Items.Insert(0, new ListItem(dtRow["NomeCliente"].ToString(), dtRow["CodiceCliente"].ToString()));
        }

    }

    // Popola controllo in base ai carichi ore da data a data
    protected void Bind_LBProgetti(string DataDa, string DataA)
    {
        LBProgetti.Items.Clear();
        LBProgetti.Visible = true;

        DataTable dtProgetti = Database.GetData("SELECT DISTINCT hours.projects_id, B.ProjectCode + ' ' + SUBSTRING(B.Name, 1, 20) as projectName FROM Hours " +
                                               "INNER JOIN Projects as B ON B.projects_id = hours.projects_id " +
                                               "WHERE CTMPreinvoiceNum is null AND B.CodiceCliente=" + ASPcompatility.FormatStringDb(DDLCliente.SelectedValue) + 
                                               " AND date >= " + ASPcompatility.FormatDateDb(DataDa) + 
                                               " AND date <= " + ASPcompatility.FormatDateDb(DataA) +
                                               " AND B.TipoContratto_id = '" + ConfigurationManager.AppSettings["CONTRATTO_TM"] + "' " +
                                               " ORDER BY projectName DESC", this.Page);

        foreach (DataRow dtRow in dtProgetti.Rows)
        {
            LBProgetti.Items.Insert(0, new ListItem(dtRow["projectName"].ToString(), dtRow["projects_id"].ToString()));
        }

        //LBProgetti.Items.Insert(0, new ListItem("--- Tutti progetti ---", ""));

    }

    protected void report_Click(object sender, EventArgs e)
    {

        // salva variabili di sessioni
        Session["PreinvDocDate"] = TBDataA.Text;
        Session["PreinvDataA"] = TBDataA.Text;
        Session["PreinvDataDa"] = TBDataDa.Text;
        Session["PreinvCodiceCliente"] = DDLCliente.SelectedValue;
        Session["PreinvProjectsId"] = Utilities.ListSelections(LBProgetti);
        Session["PreinvWBS"] = CBWBS.Checked;

        // imposta il messaggio che verrò dato sulla pagina di menu
        Response.Redirect("/timereport/report/CTMBilling/CTMpreinvoice-form.aspx");
    }
}