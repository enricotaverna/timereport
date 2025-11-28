using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Canoni_montly_fee_lookup_list : System.Web.UI.Page
{
    public string strMessage;
    string strQueryOrdering = " ORDER BY Projects.ProjectCode,Monthly_Fee.Year ";

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "WBS");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();

    }

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DDLManager"] != null)
            DDLManager.SelectedValue = Session["DDLManager"].ToString();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_flattivo_val_att"] != null)
            DL_flattivo.SelectedValue = Session["DL_flattivo_val_att"].ToString();

        // Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["TB_CanoneCode"] != null)
            TB_Codice.Text = Session["TB_CanoneCode"].ToString();

        // Resetta valore textbox per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DL_progetto"] != null)
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();

        if (!IsPostBack && Session["GridCanoniPageNumber"] != null)
        {
            // Imposta indice di aginazione
            GridView1.PageIndex = Convert.ToInt32(Session["GridCanoniPageNumber"].ToString());
        }
    }

    // Imposta query selezione
    protected void ImpostaQuery()
    {
        string sWhere = "";

        // limita ai suoi progetti in caso di manager
        //if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        //  sWhere = "WHERE Projects.clientmanager_id = " + CurrentSession.Persons_id;    

        sWhere = " WHERE ( Projects.ClientManager_id = @Persons_id OR @Persons_id = '0') " +
                 " AND ( Monthly_Fee.Active = @DL_flattivo OR @DL_flattivo = '99' ) " +
                 " AND ( Projects.Projects_id = (@DL_progetto) OR @DL_progetto = '0' ) AND Monthly_Fee.Monthly_Fee_Code LIKE '%' + (@TB_Codice) + '%' ";

        //sWhere = " WHERE ( Projects.ClientManager_id = @Persons_id OR @Persons_id = '0') AND ( Monthly_Fee.Active = @DL_flattivo OR @DL_flattivo = '99' )   ";

        DSCanoni.SelectCommand = "SELECT [Monthly_Fee_id],[Monthly_Fee_Code],Projects.ProjectCode + '  ' + Projects.Name AS NomeProgetto,[Year], " +
                                 "[Month],[Revenue],[Cost],[Days],[Day_Revenue],[Day_Cost], Monthly_Fee.Active, "+
                                 "Monthly_Fee.Projects_id as Projects_Id, c.name as NomeManager "+
                                 "FROM Monthly_Fee "+
                                 "INNER JOIN Projects ON Monthly_Fee.Projects_id = Projects.Projects_Id "+
                                 "INNER JOIN Persons as c ON c.persons_id = Projects.ClientManager_id " + sWhere + strQueryOrdering;

    }

    // invia all form attività, progetto e fase. progetto e fase verranno utiizzati per inizializzare
    //  la fropdonwlist che essendo a cascata non riesce ad utilizzare le normali logiche di binding
    protected void GridView1_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        var Monthly_Fee_id = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[0];
        var ProjectsId = GridView1.DataKeys[GridView1.SelectedRow.RowIndex].Values[1];

        Response.Redirect("montly_fee_lookup_form.aspx?Monthly_Fee_id=" + Monthly_Fee_id + "&Projects_Id=" + ProjectsId);
    }

    protected void DL_progetto_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_progetto"] = DL_progetto.SelectedValue;
    }

    protected void DL_flattivo_SelectedIndexChanged(Object sender, System.EventArgs e)
    {
        Session["DL_flattivo_val_att"] = DL_flattivo.SelectedValue;
    }

    protected void TB_Codice_TextChanged(Object sender, System.EventArgs e)
    {
        Session["TB_CanoneCode"] = TB_Codice.Text;
    }

    protected void DL_progetto_DataBound(Object sender, System.EventArgs e)
    {
        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (!IsPostBack && Session["DL_progetto"] != null)
            DL_progetto.SelectedValue = Session["DL_progetto"].ToString();
    }

    protected void DSprogetti_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        // visualizza solo progetti del manager
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {
            e.Command.Parameters["@managerid"].Value = CurrentSession.Persons_id;
            e.Command.Parameters["@selAll"].Value = 0;
        }
        else
        { // admin
            e.Command.Parameters["@managerid"].Value = "";
            e.Command.Parameters["@selAll"].Value = 1;
        }

    }

    protected void GridView1_PageIndexChanging(Object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        Session["GridCanoniPageNumber"] = e.NewPageIndex;
    }

    // al cambio di DDL salva il valore 
    protected void DDLManager_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLManager"] = ddl.SelectedValue;
    }

    // Forza il valore della DDL se è un manager
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        if (!Auth.ReturnPermission("MASTERDATA", "PROJECT_ALL"))
        {

            DDLManager.ClearSelection();
            DDLManager.Items.FindByValue(CurrentSession.Persons_id.ToString()).Selected = true;
            DDLManager.Enabled = false;
        }
    }

}