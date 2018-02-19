using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Template_lookup_list : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {

        //	Almeno manager
        Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();

        // Se manager cancella bottone crea
        if (Convert.ToInt16(Session["userLevel"]) == MyConstants.AUTH_MANAGER)
            btn_crea.Visible = false;

   
   }

    // Imposta query selezione
    protected void ImpostaQuery()
    {

        string sWhere = "";
        string strQueryOrdering = " ORDER BY Projects.ProjectCode ";

        //// Si imposta valore della selezione se DDL impostata "OR" si verifica il valore di default della DDL
        sWhere = " WHERE ( Projects.ClientManager_id = @Persons_id OR @Persons_id = '0' ) AND " +
                       " ( Projects.ProjectCode LIKE '%' + (@TB_Codice) + '%' ) AND " +
                       " ( Projects.Active = @DDLFlattivo OR @DDLFlattivo = '99' ) AND " +
                       " ( Projects.CodiceCliente = @CodiceCliente or @CodiceCliente = '0' )";

        // se manager limita i progetti visibili
        sWhere = Convert.ToInt16(Session["userLevel"]) == MyConstants.AUTH_MANAGER ? sWhere + " AND Projects.ClientManager_id=" + Session["Persons_id"] : sWhere;

        DSElenco.SelectCommand = "SELECT Projects.Projects_Id, Projects.ProjectCode, Projects.Name AS ProjectName, Projects.ProjectType_Id, Projects.Active, Projects.ClientManager_id, Persons.Name AS ManagerName, ProjectType.Name AS ProjectType, Customers.Nome1, Projects.RevenueBudget, Projects.SpeseBudget, Projects.MargineTarget " +
                                         " FROM Projects " +
                                         " LEFT OUTER JOIN Persons ON Projects.ClientManager_id = Persons.Persons_id " +
                                         " LEFT OUTER JOIN ProjectType ON Projects.ProjectType_Id = ProjectType.ProjectType_Id LEFT OUTER JOIN Customers ON Projects.CodiceCliente = Customers.CodiceCliente" + sWhere + strQueryOrdering;             
    } 

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
     {

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLManager"] != null)
             DDLManager.SelectedValue = Session["DDLManager"].ToString();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLCliente"] != null)
             DDLCliente.SelectedValue = Session["DDLCliente"].ToString();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLFlattivo"] != null)
             DDLFlattivo.SelectedValue = Session["DDLFlattivo"].ToString();

         if (Session["TB_Codice"] != null)
             TB_Codice.Text = Session["TB_Codice"].ToString(); 
      }
    
    // Lancia form di dettaglio
    protected void GVElenco_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        Response.Redirect("Projects_lookup_form.aspx?Projects_id=" + GVElenco.SelectedValue);
    }

    // controlli di integrità e quindi cancellazione del record "Progetto"
    protected void GVElenco_RowCommand(object sender, GridViewCommandEventArgs e)
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
            GridViewRow row = GVElenco.Rows[index];

            // controlli passati, cancella il record
            Database.ExecuteSQL("DELETE FROM Projects WHERE Projects_id=" + row.Cells[0].Text, lPage);

            // forza refresh
            GVElenco.DataBind();
        }
    }
    
    // se manager nasconde icona cancellazione
    protected void GVElenco_DataBound(object sender, EventArgs e)
    {
        if (Convert.ToInt16(Session["userLevel"]) == MyConstants.AUTH_MANAGER)
        {
            GVElenco.Columns[10].Visible = false;
        }
    }

    // Forza il valore della DDL se è un manager
    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        if (Convert.ToInt16(Session["userLevel"]) == MyConstants.AUTH_MANAGER)
        {

            DDLManager.ClearSelection();
            DDLManager.Items.FindByValue(Session["Persons_id"].ToString()).Selected = true;
            DDLManager.Enabled = false;
        }
    }

    // al cambio di DDL salva il valore 
    protected void DDLManager_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLManager"] = ddl.SelectedValue;
    }

    protected void DL_flattivo_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLFlattivo"] = ddl.SelectedValue;
    }

    // al cambio di TB salva il valore
    protected void TB_Codice_TextChanged(object sender, EventArgs e)
    {
        TextBox tb = (TextBox)sender;
        Session["TB_Codice"] = tb.Text;
    }

    // al cambio di DDL salva il valore 
    protected void DDLCliente_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLCliente"] = ddl.SelectedValue;
    }
    
}