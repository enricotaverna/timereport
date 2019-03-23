using System;
using System.Data;
using System.Configuration;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sSQL = "";
        string sPath = "";

        string SReportType = Request["ReportName"] != null ? Request["ReportName"].ToString() : "";

        if (!IsPostBack)
        {

            // determina tipo report da parametro di lancio
            switch (SReportType)
            {
                case "HR_CourseCatalog":
                    sSQL = "SELECT * FROM V_COURSE";
                    sPath = "/timereport/report/Rdlc/HR_CourseCatalog.rdlc";
                    break;

                default:
                    sSQL = Session["SQL"].ToString();
                    sPath = Session["ReportPath"].ToString();
                    break;
            }

            DataTable dtData = Database.GetData(sSQL, null);
            RVReport.LocalReport.DataSources.Clear();
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSetReport", dtData));
            RVReport.LocalReport.ReportPath = Server.MapPath(sPath);
        }

    }
}