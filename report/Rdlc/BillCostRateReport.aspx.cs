using System;
using System.Data;
using System.Configuration;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        DataTable dtData;

        if (!IsPostBack)
        {
            RVReport.LocalReport.DataSources.Clear();

            // in base al parametro di lancio esegue il report di cost o bill rate
            if (Request.QueryString["ReportType"] == "CR")
            {
                string sSQL1 = "Select * from v_PersonCostRate order by DataDa desc, PersonName";
                dtData = Database.GetData(sSQL1, null);
                RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("PersonCostRate", dtData));
                RVReport.LocalReport.ReportPath = Server.MapPath("/timereport/report/rdlc/CostRateReport.rdlc");
            }
            else {
                string sSQL2 = "Select * from v_ProjectCostRate order by PersonName, ProjectCode";
                dtData = Database.GetData(sSQL2, null);
                RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("ProjectCostRate", dtData));
                RVReport.LocalReport.ReportPath = Server.MapPath("/timereport/report/rdlc/BillRateReport.rdlc");
            }

        }

    }
}