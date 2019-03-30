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

                // refresh dei valori (esclude a priori quelli non trovati in precedenza)
                if (IsPostBack && dr[0].ToString().Substring(0, 2) != "E9")
                    FillTRData(dr, dr["trprojectsid"].ToString());

                cell = new TableCell();                
                cell.Text = dr[i].ToString();

                row.Cells.Add(cell);    
            }
            TBSFImport.Rows.Add(row);

        }


    }

    protected DataRow FillTRData(DataRow drCheck, string sProjects_id)
    {

        DataRow drTR;
        double price;

        drTR = Database.GetRow("SELECT A.Projects_id, A.ProjectCode, A.ProjectType_Id, B.Descrizione as ProjectTypeDesc, A.RevenueBudget, A.DataFine, A.MargineProposta, A.active " +
                           "FROM Projects AS A " +
                           "INNER JOIN TipoContratto as B ON b.TipoContratto_id = A.TipoContratto_id " +
                           "WHERE A.projects_id = " + ASPcompatility.FormatStringDb(sProjects_id), null);

        // aggiunge riga con errore
        if (drTR == null)
        {
            drCheck["ProcessingStatus"] = "E900";
            drCheck["ProcessingMessage"] = "Codice progetto non trovato";
            return drCheck;
        }

        // Carica dati TR
        drCheck["TREngagementType"] = drTR["ProjectTypeDesc"].ToString().Replace("&", "");

        if (drTR["RevenueBudget"].ToString() != "")
        {
            Double.TryParse(drTR["RevenueBudget"].ToString(), out price);
            drCheck["TRAmount"] = price.ToString("N0");
        }

        if (drTR["MargineProposta"].ToString() != "")
            drCheck["TRExpectedMargin"] = Convert.ToDouble(drTR["MargineProposta"]) * 100;
        else
            drCheck["TRExpectedMargin"] = 0;

        if (drTR["DataFine"].ToString() != "")
            drCheck["TRExpectedFulfillmentDate"] = drTR["DataFine"].ToString().Substring(0, 10);
        else
            drCheck["TRExpectedFulfillmentDate"] = "";

        if (drTR["active"].ToString() == "False")
        {
            drCheck["ProcessingStatus"] = "E910";
            drCheck["ProcessingMessage"] = "Progetto TR Chiuso";
        }

        // controlla i dati
        if (drCheck["ProcessingStatus"].ToString().Substring(0,1) != "E")
            if (drCheck["TREngagementType"].ToString() == drCheck["SFEngagementType"].ToString() &&
             drCheck["TRAmount"].ToString() == drCheck["SFAmount"].ToString() &&
             drCheck["TRExpectedMargin"].ToString() == drCheck["SFExpectedMargin"].ToString() &&
             drCheck["TRExpectedFulfillmentDate"].ToString() == drCheck["SFExpectedFulfillmentDate"].ToString())
            {
                drCheck["ProcessingStatus"] = "B000";
                drCheck["ProcessingMessage"] = "Valori coincidono";
            }
            else
            {
                drCheck["ProcessingStatus"] = "A000";
                drCheck["ProcessingMessage"] = "Alcuni valori non coincidono";
            }

        return drCheck;
    }
}