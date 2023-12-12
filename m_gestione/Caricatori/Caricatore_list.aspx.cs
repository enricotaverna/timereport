using System;
using System.Data;
using System.Configuration;
using System.IO;
using ExcelDataReader;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Collections.Generic;

public partial class SFimport_select : System.Web.UI.Page
{
    static int TrProjectIdIndex;
    static int OpportunityIdIndex;
    static int OpportunityNameIndex;
    static int EngagementTypeIndex;
    static int AmountIndex;
    static int ExpectedMarginIndex;
    static int ExpectedFulfillmentDateIndex;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        Auth.CheckPermission("ADMIN", "MASSCHANGE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

    }
 
}