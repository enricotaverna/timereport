using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Cv_list : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {

        Auth.ReturnPermission("REPORT", "CURRICULA");
            
 
    }
}