﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class m_gestione_Approval_list : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
    {

        if (!Auth.ReturnPermission("WORKFLOW", "TOTALE"))    //	Accedono solo manager o Admind
            Auth.CheckPermission("WORKFLOW", "MANAGER");

 
    }
}