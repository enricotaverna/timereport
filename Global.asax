<%@ Application Language="C#" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        Application["OnlineVisitors"] = 0;
        WebControl.DisabledCssClass = "";
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    protected void Application_BeginRequest(Object sender, EventArgs e)
    {
        //  Fired when an application request is received.

        // *** Imposta lingua
   
        CultureInfo TRCultureInfo = new CultureInfo("it");

        try
        {
            // recupera lingua da cookie, le sessioni non sono valorizzate qui
            HttpCookie cCookie = HttpContext.Current.Request.Cookies.Get("lingua");

            if (cCookie != null && cCookie.Value == "en")
            {
                TRCultureInfo = new CultureInfo("en");
            }

        }
        catch
        {
            // resta it per dafault
        }

        Thread.CurrentThread.CurrentUICulture = TRCultureInfo;

    }

    void Application_AcquireRequestState(object sender, EventArgs e)
    {
        //  Fired when an application request is received.
    }

    void Application_Error(object sender, EventArgs e)
    {
        // Code that runs when an unhandled error occurs

    }

    void Session_Start(object sender, EventArgs e)
    {
        // Code that runs when a new session is started
        Application.Lock();
        Application["OnlineVisitors"] = (int)Application["OnlineVisitors"] + 1;
        Application.UnLock();
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
        Application.Lock();
        Application["OnlineVisitors"] = (int)Application["OnlineVisitors"] - 1;
        Application.UnLock();
    }

</script>
