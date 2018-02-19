using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

public partial class m_utilita_ScheduleStoredProcedure : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        // controlla il nome della stored procedure prima di eseguirla
        if (Request["SP"] != null && (Request["SP"].ToString() == "LogSessionNumber")  && !IsPostBack)
            Database.ExecuteSQL("exec " + Request["SP"].ToString(), null);

    }

    protected void Exec_Click(object sender, EventArgs e)
    {
        // lancio da form
        if (TBStoredProcedure.Text  != "" && (TBStoredProcedure.Text == "LogSessionNumber"))
            Database.ExecuteSQL("exec " + TBStoredProcedure.Text, null);
    }
}