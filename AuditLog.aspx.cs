using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AuditLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString["TableName"] == "Expenses" )
            CancelButton.PostBackUrl = "/timereport/input-spese.aspx?action=fetch&expenses_id=" + Request.QueryString["RecordId"];
        else
            CancelButton.PostBackUrl = "/timereport/input-ore.aspx?action=fetch&Hours_id=" + Request.QueryString["RecordId"];
    }
}