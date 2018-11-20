<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

    public Boolean ForcedAccount;
    public int PersonsId;

    // true se autenticato , false se no
    // in Msg il messaggio da restiruire al client 
    // in PersonsId restituisce il codice dell'utente
    Boolean CheckLogin(ref string ErrMsg)
    {

        DataTable dt = Database.GetData("SELECT Persons_Id, active, ForcedAccount, Name, UserId, userlevel_ID FROM Persons WHERE [userId]='" + userid.Text  + "' AND [password]='" + password.Text + "'", this.Page);

        if (dt == null || dt.Rows.Count == 0)
        {
            ErrMsg = "User o password non riconosciuti";
            return (false); // utente non trovato 
        }
        else
        {

               if (!Convert.ToBoolean(dt.Rows[0]["ForcedAccount"]) )
                {
                    ErrMsg = "Utente non valido, mancano limitazioni su progetti";
                    return(false); // Utente non valido, mancano limitazioni su progetti
                }

                // verifica che sia attivo
                if (!Convert.ToBoolean(dt.Rows[0]["active"]) )
                {
                    ErrMsg = "Utente non attivo";
                    return(false); // Utente non attivo
                }

                // AUTENTICATO: SAVA COOCKIE
                if (RbCookie.Checked)
                {
                    // Salva Cookie
                    HttpCookie myCookie = new HttpCookie("userName");
                    myCookie.Value = Request["userid"];
                    myCookie.Expires = DateTime.Now.AddYears(100);
                    Response.Cookies.Add(myCookie);
                }
                else
                {
                    // Pulisci Cookie
                    HttpCookie myCookie = new HttpCookie("userName");
                    myCookie.Value = "";
                    myCookie.Expires = DateTime.Now.AddYears(100);
                    Response.Cookies.Add(myCookie);
                }

                // utente autenticato
                Session["UserId"] = dt.Rows[0]["UserId"];
                Session["UserName"] = dt.Rows[0]["Name"];
                Session["persons_id"] = dt.Rows[0]["Persons_Id"];
                Session["userLevel"] = dt.Rows[0]["userlevel_ID"];

                return(true);
            }
    }

    protected void Page_Load(object sender, EventArgs e) {

        string ErrMsg = "";

        if (!IsPostBack)
        {
            //  Default userid
            if (Request.Cookies["userName"] != null)
            {
                HttpCookie aCookie = Request.Cookies["userName"];
                userid.Text = Server.HtmlEncode(aCookie.Value);
            }

            // reset messaggio errore
            ErrorMsg.Text = "";
            ErrorMessage.Visible = false;
        }
        else // POSTBACK                  
        {
            // Verifica password se positiva passa al menù principale
            ErrMsg = "";

            if ( CheckLogin(ref ErrMsg) )
                Response.Redirect("menu.aspx");
            else
            {
                // display messaggio di errore
                ErrorMsg.Text = ErrMsg;
                ErrorMessage.Visible = true;
            }
        }

    }

</script>

<html xmlns="http://www.w3.org/1999/xhtml">

    <head id="Login" runat="server">
    <title>Login</title>

    <meta name="viewport" content="initial-scale=1">
<%--    <meta name="apple-mobile-web-app-capable" content="yes" />--%>
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <!-- style sheets -->
    <link rel="stylesheet" href="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.css" />
    <link href="/timereport/include/TimereportMobilev2.css" rel="stylesheet" />
    <!-- jquery mobile -->
    <script src="/timereport/include/jquery/1.7.1/jquery-1.7.1.min.js"></script>
    <script src="/timereport/include/javascript/customscript.js"></script>
    <script src="/timereport/include/jquery/1.7.1/jquery.mobile-1.1.1.min.js"></script>
    <!-- jquery mobile FINE -->
    <script>
    <!-- elimina barra -->   
    var iWebkit; if (!iWebkit) { iWebkit = window.onload = function () { function fullscreen() { var a = document.getElementsByTagName("a"); for (var i = 0; i < a.length; i++) { if (a[i].className.match("noeffect")) { } else { a[i].onclick = function () { window.location = this.getAttribute("href"); return false } } } } function hideURLbar() { window.scrollTo(0, 0.9) } iWebkit.init = function () { fullscreen(); hideURLbar() }; iWebkit.init() } }
     </script>
    <script type="text/javascript">
        if (navigator.cookieEnabled) {
            // cookie attivi
        }
        else
            // cookie non attivi
            $(document).ready(function () {
                $('#CookieMessage').show(); /*mostra messagggio*/

                // elimina form
                $(document).ready(function () {
                    $('#form1').remove();
                });
            });

    </script>
</head>

<body>
    <div data-role="page" >
        <div data-role="header" data-position="fixed">
            <h1>
                Timereport Login</h1>
        </div>
        <!-- /header -->        
        <br />
        <div>

            <div id="CookieMessage" class='ui-body ui-body-e'>L'applicazione Timereport richiede l'attivazione dei <b>cookies</b> (Impostazioni->Safari)</div>
            <br />

            <%--ERROR MESSAGE--%>
            <div class='ui-body ui-body-e' id="ErrorMessage" runat="server">
                <asp:Label ID="ErrorMsg" runat="server" Text=""></asp:Label>
            </div>


        <form id="form1" runat="server">
            <asp:TextBox ID="userid" runat="server" placeholder="Username"></asp:TextBox>
            <br />
            <asp:TextBox runat="server" type="password" name="password" id="password" value="" placeholder="Password" />
            <br />
            <asp:CheckBox ID="RbCookie" Text="Ricorda la user" runat="server" Checked="True"
                data-inline="true" />
            <br />
            <asp:Button ID="Button1" type="submit" runat="server" data-role="button" data-inline="true"
                data-theme="b" Text="Login" />
            &nbsp;<br />
            <br /> 
 
        </form>

        <div data-role="footer" style="position:absolute; width:100%;bottom: 0; left:0;">
            <h4>
                Aeonvis @ <%=DateTime.Now.Year.ToString()   %> - mTimeReport &nbsp;
                <img src="/timereport/images/mobile/beta_icon2.png" /></h4>
        </div>
        <!-- /footer -->
    </div>
    <!-- /page -->
</body>

</html>
