<%@ Application Language="C#" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Threading" %>

<script runat="server">

    void Application_Start(object sender, EventArgs e)
    {
        // Code that runs on application startup
        WebControl.DisabledCssClass = "";
    }

    void Application_End(object sender, EventArgs e)
    {
        //  Code that runs on application shutdown

    }

    protected void Application_BeginRequest(Object sender, EventArgs e)
    {
        //  Fired when an application request is received.
        if (Utilities.GetCookie("lingua") == "en")
            Thread.CurrentThread.CurrentUICulture  = new CultureInfo("en");
        else
            Thread.CurrentThread.CurrentUICulture  = new CultureInfo("it");

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
    }

    void Session_End(object sender, EventArgs e)
    {
        // Code that runs when a session ends. 
        // Note: The Session_End event is raised only when the sessionstate mode
        // is set to InProc in the Web.config file. If session mode is set to StateServer 
        // or SQLServer, the event is not raised.
    }

</script>
