using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class m_gestione_AuthPermission_AuthPermission : Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("CONFIG", "AUTHORIZATION");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (DDLUserLevel.SelectedValue.Length == 0)
            LBPermissions.Visible = false;
        else
            LBPermissions.Visible = true;

        // Imposta select per selezione progetti legati all'utente
        Set_defaults();
    }

    protected void Set_defaults()
    {

        // imposta selezione progetti in base all'utente
            DSUserLevel.SelectCommand = "SELECT UserLevel_ID, Name from AuthUserLevel ORDER BY UserLevel_ID";

    }

    protected void DDLUserLevel_SelectedIndexChanged(object sender, EventArgs e)
    {
       // Popola la lista valori
        Load_ListBox();
    }

    public void Load_ListBox()
    {

        LBPermissions.Items.Clear();

        // Legge autorizzazioni
        DataTable dt = Database.GetData("SELECT a.AuthActivity_id, a.descrizione as DescActivity, b.descrizione as DescTask FROM AuthActivity as a INNER JOIN AuthTask as b ON a.AuthTask = b.AuthTask ORDER BY b.TaskSortKey, a.descrizione", this.Page);

        foreach (DataRow rs in dt.Rows)
        {
            ListItem listitem = new ListItem(rs["DescActivity"].ToString(), rs["AuthActivity_id"].ToString());
            listitem.Attributes["optgroup"] = rs["DescTask"].ToString();
            
            // verifica se selezionare il record
               if (Database.RecordEsiste("SELECT * FROM AuthPermission WHERE AuthActivity_id=" + listitem.Value + " AND UserLevel_id=" + DDLUserLevel.SelectedValue + "", this.Page) )
                   listitem.Selected = true;

            LBPermissions.Items.Add(listitem);    
        }
    } 

    // Aggiorna valori in tabella AuthPermission
    protected void InsertButton_Click(object sender, EventArgs e)
    {

        // cancella precedenti assegnazioni
        Database.ExecuteScalar("DELETE FROM AuthPermission WHERE UserLevel_id = " + DDLUserLevel.SelectedValue, this);

        // loop sugli elementi selezionati
        foreach (ListItem item in LBPermissions.Items)
        {
            if (item.Selected)
            {
                // update
                Database.ExecuteScalar("INSERT INTO AuthPermission (UserLevel_id, AuthActivity_id) " +
                                       "VALUES ( '" + DDLUserLevel.SelectedValue + "' , '" + item.Value + "')", this);
            }
        }
        
        // emette messaggio di conferma salvataggio
        string message = "Salvataggio effettuato";
        ClientScript.RegisterStartupScript(this.GetType(), "Popup", "ShowPopup('" + message + "');", true);

    }

    protected void UpdateCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/menu.aspx");
    }

}

