﻿using Microsoft.Owin.Security.Cookies;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class logoff : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        HttpContext.Current.GetOwinContext()
           .Authentication
           .SignOut(CookieAuthenticationDefaults.AuthenticationType);
        Response.Redirect("/timereport/mobile/login.aspx");

    }
}