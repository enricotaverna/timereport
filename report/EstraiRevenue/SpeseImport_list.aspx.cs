using System;
using System.Data;
using System.Configuration;
using System.IO;
using ExcelDataReader;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class SFimport_select : System.Web.UI.Page
{
    static int TrProjectIdIndex;
    static int OpportunityIdIndex;
    static int OpportunityNameIndex;
    static int EngagementTypeIndex;
    static int AmountIndex;
    static int ExpectedMarginIndex;
    static int ExpectedFulfillmentDateIndex;

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("REPORT", "PROJECT_ALL"))
            Auth.CheckPermission("REPORT", "PROJECT_FORCED");

        CostruisciTabella();

    }

    protected void CostruisciTabella() {

        DataTable dtResults = (DataTable)Session["dtResult"];

        TableHeaderRow1.TableSection = TableRowSection.TableHeader;

        foreach ( DataRow dr in dtResults.Rows )
        {
            TableRow row = new TableRow();
            TableCell cell;

            cell = new TableCell();
            // imposta a false se il processing status è un errore
            cell.Text = dr[0].ToString().Substring(0, 1) == "E" ? cell.Text = "0" : cell.Text = "";
            cell.ID = "check";
  
            row.Cells.Add(cell); // checkbox per selezionare

            for (int i = 0; i < dtResults.Columns.Count; i++) {

                cell = new TableCell();                
                cell.Text = dr[i].ToString();

                row.Cells.Add(cell);    
            }
             TBImport.Rows.Add(row);

        }


    }

}