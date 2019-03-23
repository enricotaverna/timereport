using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

//  1. Imposta query

public partial class m_CostRateAnno_lookup_list : System.Web.UI.Page
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

        // Se manager cancella bottone crea
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
            btn_crea.Visible = false;
  
   }

    // Imposta dinamicamente query selezione
    protected void ImpostaQuery()
    {

        string sWhere = "";
        string strQueryOrdering = " ORDER BY NomePersona ";

        //// Si imposta valore della selezione se DDL impostata "OR" si verifica il valore di default della DDL
        sWhere = " WHERE ( PersonsCostRate.Persons_id = @Persons_id OR @Persons_id = '0' ) AND " +
       //                " ( Persons.Active = @DDLFlattivo OR @DDLFlattivo = 99 ) AND " +
                       " anno = @anno ";

        DSElenco.SelectCommand = "SELECT DISTINCT PersonsCostRate_id, PersonsCostRate.Persons_id, Persons.name as NomePersona, Anno, PersonsCostRate.CostRate, Comment " +
                                         " FROM PersonsCostRate " +
                                         " INNER JOIN Persons ON Persons.persons_id = PersonsCostRate.persons_id "  +
                                  sWhere + strQueryOrdering;

    } 

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
     {

         // popola DDL Anno
         DDLAnno_DataBinding();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLPersona"] != null)
             DDLPersona.SelectedValue = Session["DDLPersona"].ToString();

         // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLFlattivo"] != null)
             DDLFlattivo.SelectedValue = Session["DDLFlattivo"].ToString();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DDLanno"] != null)
        {
            DDLAnnoModale.SelectedValue = Session["DDLanno"].ToString();
            DDLAnno.SelectedValue = Session["DDLanno"].ToString();
        }
        else
        {
            DDLAnnoModale.SelectedValue = DateTime.Now.Year.ToString();
            DDLAnno.SelectedValue = DateTime.Now.Year.ToString();

        }

    }
    
    // Lancia form di dettaglio
    protected void GVElenco_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        Response.Redirect("CostRateAnno_lookup_form.aspx?PersonsCostRate_id=" + GVElenco.SelectedValue);
    }
    
    // se manager nasconde icona cancellazione
    protected void GVElenco_DataBound(object sender, EventArgs e)
    {
        if (!Auth.ReturnPermission("MASTERDATA", "COSTRATE"))
        {
            GVElenco.Columns[5].Visible = false;
        }
    }
 
    // al cambio di DDL salva il valore 
    protected void DDLPersona_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLPersona"] = ddl.SelectedValue;
    }

    // al cambio di DDL salva il valore 
    protected void DDLFlattivo_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLFlattivo"] = ddl.SelectedValue;
    }

    // al cambio di DDL salva il valore 
    protected void DDLAnno_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLAnno"] = ddl.SelectedValue;
    }

    // popola DDL Anno
    protected void DDLAnno_DataBinding()
    {
        // Popola dropdown Anno
        for (int i = DateTime.Now.Year + 1; i > (DateTime.Now.Year - 5); i--)
        {
            DDLAnno.Items.Add(new ListItem(i.ToString(), i.ToString()));
            DDLAnnoModale.Items.Add(new ListItem(i.ToString(), i.ToString()));
        }
        
    }

}