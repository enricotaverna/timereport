using System;
using System.Data;
using System.Configuration;

public partial class report_Rdl_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            string sSQL = Session["SQL"].ToString();
  
            DataTable dtData = Database.GetData(sSQL, null);
            RVReport.LocalReport.DataSources.Clear();
            RVReport.LocalReport.DataSources.Add(new Microsoft.Reporting.WebForms.ReportDataSource("DataSetReport", dtData));
            RVReport.LocalReport.ReportPath = Server.MapPath(Session["ReportPath"].ToString()); 
        }

    }
}