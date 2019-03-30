using System;
using System.Data;
using System.Configuration;
using Microsoft.Reporting.WebForms;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string sSQL = "";
        string sSQL2 = "";
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

            DataTable dtData2;

            if (Session["SQL2"] != null)
            {
                sSQL2 = Session["SQL2"].ToString();
                dtData2 = Database.GetData(sSQL2, null);  // se il report ha un secondo dataset
                RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSetReport2", dtData2));
            }

            // se un report revenue setta la versione 
            if (sPath.Substring(0, 3) == "REV")
            {
                ReportParameter[] parameters = new ReportParameter[1];
                parameters[0] = new ReportParameter("RevenueVersion", Session["RevenueVersion"].ToString());
                RVReport.LocalReport.SetParameters(parameters);
            }
        }

    }
}