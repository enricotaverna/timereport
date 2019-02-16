using System;
using System.Data;
using System.Configuration;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            string sSQL1 = "Select * from v_PersonCostRate order by Anno desc, PersonName";
            string sSQL2 = "Select * from v_ProjectCostRate by PersonName, ProjectCode";

            DataTable dtData1 = Database.GetData(sSQL1, null);
            DataTable dtData2 = Database.GetData(sSQL2, null);

            RVReport.LocalReport.DataSources.Clear();
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("PersonCostRate", dtData1));
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("ProjectCostRate", dtData2));

            RVReport.LocalReport.ReportPath = Server.MapPath("/timereport/report/rdlc/CostRateReport.rdlc"); 
        }

    }
}