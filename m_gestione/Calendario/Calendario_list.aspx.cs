using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_Calendario_lookup_list : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("CONFIG", "TABLE");

        // Inizializza elementi form
        if (!Page.IsPostBack)
            InizializzaForm();

        // Imposta query selezione
        ImpostaQuery();
 
   }

    // Imposta dinamicamente query selezione
    protected void ImpostaQuery()
    {

        string sWhere = "";
        string strQueryOrdering = " ORDER BY CalCode, CalDay";

        // Si imposta valore della selezione se DDL impostata "OR" si verifica il valore di default della DDL
        sWhere = " WHERE ( a.Calendar_id = @Calendar_id ) AND " +
                 " CalYear = @CalYear ";

        DSElenco.SelectCommand = "SELECT CalendarHolidays_id, CalYear, CalDay, CalCode " +
                                 " FROM CalendarHolidays AS a " +
                                 " INNER JOIN Calendar AS b ON b.Calendar_id = a.Calendar_id " +
                                 sWhere + strQueryOrdering;

    } 

    // Imposta i valori degli elementi del form da variabili di sessione
    protected void InizializzaForm()
     {

         // popola DDL Anno
         DDLAnno_DataBinding();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
        if (Session["DDLSede"] != null)
            DDLSede.SelectedValue = Session["DDLSede"].ToString();

        // Resetta indice di selezione sulle dropdwonlist per non perderlo a seguito passaggio a pagina di dettaglio
         if (Session["DDLanno"] != null)
             DDLAnno.SelectedValue = Session["DDLanno"].ToString();
      }
    
    // Lancia form di dettaglio
    protected void GVElenco_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        Response.Redirect("Calendario_lookup_form.aspx?CalendarHolidays_id=" + GVElenco.SelectedValue);
    }
    
    // al cambio di DDL salva il valore 
    protected void DDLSede_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLSede"] = ddl.SelectedValue;
    }

    // al cambio di DDL salva il valore 
    protected void DDLAnno_SelectedIndexChanged(object sender, System.EventArgs e)
    {
        DropDownList ddl = (DropDownList)sender;
        Session["DDLAnno"] = ddl.SelectedIndex;
    }

    // popola DDL Anno
    protected void DDLAnno_DataBinding()
    {

        DropDownList DDLAnno = (DropDownList)form1.FindControl("DDLAnno");

        // Popola dropdown Anno
        for (int i = DateTime.Now.Year + 1; i > (DateTime.Now.Year - 5); i--)
            DDLAnno.Items.Add(new ListItem(i.ToString(), i.ToString()));

        // imposta di default anno corrente
        if (Session["DDLAnno"] != null)
            DDLAnno.Items[Convert.ToInt16(Session["DDLAnno"])].Selected = true;
        else
            DDLAnno.Items[1].Selected = true;

    }

}