using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class mobile_menu : System.Web.UI.Page
{
    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

        Utilities.CheckAutMobile(CurrentSession.UserLevel, MyConstants.AUTH_EXTERNAL);
        
        
              
        
    }

}