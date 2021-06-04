using System;
using System.Data;
using System.Configuration;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        if (!IsPostBack)
        {
            string sSQL1 = "Select * from v_PersonCostRate order by DataDa desc, PersonName";
            string sSQL2 = "Select * from v_ProjectCostRate order by PersonName, ProjectCode";

            DataTable dtData1 = Database.GetData(sSQL1, null);
            DataTable dtData2 = Database.GetData(sSQL2, null);

            RVReport.LocalReport.DataSources.Clear();
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("PersonCostRate", dtData1));
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("ProjectCostRate", dtData2));

            RVReport.LocalReport.ReportPath = Server.MapPath("/timereport/report/rdlc/CostRateReport.rdlc"); 
        }

    }
}