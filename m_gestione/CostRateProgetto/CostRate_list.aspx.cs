using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_CostRate_lookup_list : System.Web.UI.Page
{

   protected void Page_Load(object sender, EventArgs e)
    {

        //	Deve avere almeno il reporting economics per visualizzare
        //  Se ha Masterdata Costrate può anche modificar
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
            Auth.CheckPermission("REPORT", "ECONOMICS");

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();
   }

    // Imposta query selezione
    protected void ImpostaQuery()
    {

        string sWhere = "";
        string strQueryOrdering = " ORDER BY Projects.ProjectCode ";

        // Si imposta valore della selezione se DDL impostata "OR" si verifica il valore di default della DDL
        sWhere = " WHERE ( ProjectCostRate.Persons_id = @Persons_id OR @Persons_id = '0' ) AND " +
                        "( ProjectCostRate.Projects_id = @Projects_id OR @Projects_id = '0' ) AND " +
                        "( b.Persons_Id = @Manager_id OR @Manager_id  = '0' ) AND " +
                        " Projects.active = 1";

        // se manager limita i progetti visibili
        sWhere = !Auth.ReturnPermission("REPORT", "PROJECT_ALL") ? sWhere + " AND ClientManager_id=" + Session["Persons_id"] : sWhere;

        DSForcedAccounts.SelectCommand = "SELECT ProjectCostRate_id, ProjectCostRate.Projects_id, Projects.ProjectCode, Projects.ProjectCode + '  ' + Projects.Name AS NomeProgetto, Persons.Name AS NomePersona, BillRate, b.name AS NomeManager FROM ProjectCostRate " +
                                   " INNER JOIN Projects ON ProjectCostRate.Projects_id = Projects.Projects_Id " +
                                   " INNER JOIN Persons ON ProjectCostRate.Persons_id = Persons.Persons_Id " +
                                   " INNER JOIN Persons as b ON b.Persons_Id = Projects.ClientManager_id " + 
                                   sWhere + strQueryOrdering;

        // Se Manager posso visualizzare solo i miei progetti
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL")) 
            DSProgetti.SelectCommand = "SELECT Projects_Id, ProjectCode + N'  ' + Name AS NomeProgetto, ClientManager_id, Active FROM Projects WHERE Projects.Active = 1 AND ClientManager_id = @clientmanager ORDER BY NomeProgetto";
        else
            DSProgetti.SelectCommand = "SELECT Projects_Id, ProjectCode + N'  ' + Name AS NomeProgetto, ClientManager_id, Active FROM Projects WHERE Projects.Active = 1 ORDER BY NomeProgetto";       
    } 

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
     {

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (!Page.IsPostBack && Session["DDLPersons"] != null)
             DDLPersons.SelectedValue = Session["DDLPersons"].ToString();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (!Page.IsPostBack && Session["DDLProgetto"] != null)
             DDLProgetto.SelectedValue = Session["DDLProgetto"].ToString();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (!Page.IsPostBack && Session["DDLManager"] != null)
             DDLManager.SelectedValue = Session["DDLManager"].ToString();         
      }

    protected void GV_ForcedAccounts_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        Response.Redirect("CostRate_lookup_form.aspx?ProjectCostRate_id=" + GV_ForcedAccounts.SelectedValue);
    }

    // al cambio di DDL salva il valore 
    protected void DDLPersons_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        ListBox ddl = (ListBox)sender;
        Session["DDLPersons"] = ddl.SelectedValue;
    }

    // al cambio di DDL salva il valore 
    protected void DDLProgetto_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        ListBox ddl = (ListBox)sender;
        Session["DDLProgetto"] = ddl.SelectedValue;
    }
    
    // controlli di integrità e quindi cancellazione del record "Progetto"
    protected void GV_ForcedAccounts_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        ValidationClass c = new ValidationClass();
        Page lPage = this.Page;

        if (e.CommandName == "cancella")
        {
            // Retrieve the row index stored in the 
            // CommandArgument property.
            int index = Convert.ToInt32(e.CommandArgument);

            // Retrieve the row that contains the button 
            // from the Rows collection.
            GridViewRow row = GV_ForcedAccounts.Rows[index];

            // controlli passati, cancella il record
            Database.ExecuteSQL("DELETE FROM ProjectCostRate WHERE ProjectCostRate_id=" + row.Cells[0].Text, lPage);

            // forza refresh
            GV_ForcedAccounts.DataBind();
        }
    }
    
    // se manager nasconde icona cancellazione
    protected void GV_ForcedAccounts_DataBound(object sender, EventArgs e)
    {

        //  *** COMMENTATO: non possibile cancellare il record in questo form, si usa il force account form  
        //if (Convert.ToInt16(Session["userLevel"]) == MyConstants.AUTH_MANAGER)
        //{
        //    GV_ForcedAccounts.Columns[6].Visible = false;
        //}
    }

    // Forza il valore della DDL se è un manager
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
        {
            DDLManager.ClearSelection();
            DDLManager.Items.FindByValue(Session["Persons_id"].ToString()).Selected = true;
            DDLManager.Enabled = false;
        }
    }

    // al cambio di DDL salva il valore 
    protected void DDLManager_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        ListBox ddl = (ListBox)sender;
        Session["DDLManager"] = ddl.SelectedValue;
    }
    
}