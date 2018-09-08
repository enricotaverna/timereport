using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.ComponentModel;
using System.IO;
using System.Data.OleDb;

public partial class report_Straordinarit_list : System.Web.UI.Page
{

    protected void Page_Init(object sender, EventArgs e)
    {

        // Carica la griglia dei risultati 
        if (!IsPostBack) 
        {
            Page_setup();
            CostruiciGriglia();
        }
    }

    protected void Page_setup()
    {
        // Valorizza indirizzo pagina chiamante
        btn_back.OnClientClick = "window.location='" + Request.UrlReferrer.ToString() +"'; return(false);";
    }

    // Costruisce la griglia
    protected void  CostruiciGriglia()
    {
        string sWhere = "";
        string sSelect = "";

        string sMese = Request.QueryString["mese"].ToString();
        string sAnno = Request.QueryString["anno"].ToString();

        string sDataInizio = ASPcompatility.FormatDateDb("1/" + sMese + "/" + sAnno, false);
        string sDataFine = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(Convert.ToInt16(sAnno), Convert.ToInt16(sMese)) + "/" + sMese + "/" + sAnno, false);

        // Inizializza tabella DATAGRID -> campi DEVONO corrispondere a quelli della dataGrid
        DataTable dt = new DataTable();
        dt.Columns.Add("Nome");
        dt.Columns.Add("Società");
        dt.Columns.Add("Data");
        dt.Columns.Add("Ore caricate");
        dt.Columns.Add("Ore Contratto");
        dt.Columns.Add("Straordinario");

        // Seleziona le persone tenendo conto della società immessa come filtro
        if (DL_societa.SelectedValue != "all")
            sWhere = "c.company_id = " + DL_societa.SelectedValue.ToString() + " AND ";

        sSelect = "select b.Name as Nome, c.Name as Societa, a.Date as data, sum(a.Hours) as ore, b.ContractHours as OreContratto, sum(a.Hours) - b.ContractHours as straordinario from Hours as a " +
                  " left join Persons as b on b.Persons_id = a.Persons_id " +
                  " left join Company as c on c.Company_id = b.Company_id " +
                  " left join Projects as d on d.Projects_id = a.Projects_id " +
                  " where " + sWhere + " a.date >= " + sDataInizio + " and a.date <= " + sDataFine + " GROUP BY a.date, b.Name, c.name, b.ContractHours ORDER BY b.Name, a.date";

        // Esegue Select e popola DataTable  
        DataTable dtHours = Database.GetData(sSelect, this.Page);

        foreach (DataRow rdr in dtHours.Rows)
        {

            if (rdr["Nome"] == DBNull.Value)
                continue;

            DataRow dr = dt.NewRow();
            dr["Nome"] = rdr["Nome"];
            dr["Società"] = rdr["Societa"];
            dr["Data"] = ((DateTime)rdr["Data"]).ToString("d");
            dr["Ore caricate"] = Convert.ToDecimal(rdr["ore"]).ToString("0.00");
            dr["Ore Contratto"] = Convert.ToDecimal(rdr["OreContratto"]).ToString("0.00");
            dr["Straordinario"] = Convert.ToDecimal(rdr["straordinario"]).ToString("0.00");

            dt.Rows.Add(dr);
        }

        // sort
        dt.DefaultView.Sort = "Nome";
        dt.DefaultView.ToTable();

        // Caricamento DataGrid
        GV_ListaOre.DataSource = dt;
        GV_ListaOre.DataBind();
 
    }

    // richiesta da export in excel
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Verifies that the control is rendered */
    }

    // Esporta tabella in excel
    protected void BtnExport_Click(object sender, System.EventArgs e)
    {
        Response.ClearContent();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "TRexport.xls"));
        Response.ContentType = "application/ms-excel";
        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);

        GV_ListaOre.AllowPaging = false;
        CostruiciGriglia();        
        
        GV_ListaOre.RenderControl(htw);
        Response.Write(sw.ToString());
        Response.End();
    }

    // Setup Pager 
    protected void GV_ListaOre_DataBound(object sender, EventArgs e)
    {
        GridViewRow pagerRow = GV_ListaOre.BottomPagerRow;
        
        // nessun dato
        if (pagerRow == null)
        {
            lbMessage.Text = "Nessun dato selezionato";
            BtnExport.Visible = false; // nasconde bottone export
            return;
        }
        else
            lbMessage.Text = "";

        DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");
        Label pageLabel = (Label)pagerRow.Cells[0].FindControl("CurrentPageLabel");

        if (pageList != null)
        {
            for (int i = 0; i < GV_ListaOre.PageCount; i++)
            {
                int pageNumber = i + 1;
                ListItem item = new ListItem(pageNumber.ToString());
                if (i == GV_ListaOre.PageIndex)
                {
                    item.Selected = true;
                }
                pageList.Items.Add(item);
            }
        }
        if (pageLabel != null)
        {
            int currentPage = GV_ListaOre.PageIndex + 1;
            pageLabel.Text = " Page " + currentPage.ToString() +
            " of " + GV_ListaOre.PageCount.ToString() + " ";
        }        
    }

    // Chiamato da DropDownList del pager
    protected void Paging_SelectedIndexChanged(object sender, EventArgs e)
    {
            GridViewRow pagerRow = GV_ListaOre.BottomPagerRow;
            DropDownList pageList = (DropDownList)pagerRow.Cells[0].FindControl("PageDropDownList");
            GV_ListaOre.PageIndex = pageList.SelectedIndex;

            CostruiciGriglia();
            GV_ListaOre.DataBind();
    }

    // Chiamato da bottone avanti del pager
    protected void btnNext_Click(object sender, EventArgs e)
    {
        if (GV_ListaOre.PageIndex < (GV_ListaOre.PageCount-1) )
        {
            GV_ListaOre.PageIndex++;
            CostruiciGriglia();
            GV_ListaOre.DataBind();
        }
    }

    // Chiamato da bottone indietro del pager
    protected void btnPrevious_Click(object sender, EventArgs e)
    {
        if (GV_ListaOre.PageIndex > 0)
        {
            GV_ListaOre.PageIndex--;
            CostruiciGriglia();
            GV_ListaOre.DataBind();
        }
    }
}