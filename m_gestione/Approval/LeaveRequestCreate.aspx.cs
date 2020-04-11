using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_LeaveRequestCreate : System.Web.UI.Page
{
    public string lProject_id;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            Bind_DDLprogetto();
            Bind_DDLNotifica();
        }

    }

    protected void Bind_DDLprogetto()
    {

        DataTable dtProgettiForzati = (DataTable)Session["dtProgettiForzati"];

        DDLProject.Items.Clear();
        DDLProject.Items.Add(new ListItem("-- selezionare una causale --", ""));

        // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
        foreach (DataRow drRow in dtProgettiForzati.Rows)
        {

            if (drRow["WorkflowType"].ToString().Length > 0)
            { // progetti con WF attivo
                ListItem liItem = new ListItem(drRow["DescProgetto"].ToString(), drRow["Projects_Id"].ToString());
                liItem.Attributes.Add("data-ActivityOn", drRow["ActivityOn"].ToString());
                liItem.Attributes.Add("data-desc-obbligatorio", drRow["TestoObbligatorio"].ToString());
                liItem.Attributes.Add("data-WorkflowType", drRow["WorkflowType"].ToString());

                if (drRow["TestoObbligatorio"].ToString() == "True")
                    liItem.Attributes.Add("data-desc-message", drRow["MessaggioDiErrore"].ToString());
                else
                    liItem.Attributes.Add("data-desc-message", "");

                DDLProject.Items.Add(liItem);
            }
        }

        DDLProject.DataTextField = "DescProgetto";
        DDLProject.DataValueField = "Projects_Id";
        DDLProject.DataBind();

        if (lProject_id != "")
            DDLProject.SelectedValue = lProject_id;

    }

    protected void Bind_DDLNotifica()
    {

        DataTable dtApprovalManagerList = (DataTable)Session["dtApprovalManagerList"];
        ListBox lbNotifica = LBNotifica; // ()FVore.FindControl("LBNotifica");

        lbNotifica.Items.Clear();
        //lbNotifica.Items.Add(new ListItem(GetLocalResourceObject("DDLnotifica.testo").ToString(), ""));

        // aggiunge gli item con l'attributo per il controllo sull'obligatorietà dei commenti
        foreach (DataRow drRow in dtApprovalManagerList.Rows)
        {
            ListItem liItem = new ListItem(drRow["Name"].ToString(), drRow["mail"].ToString());
            lbNotifica.Items.Add(liItem);
        }
    }
    
}