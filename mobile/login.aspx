<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="Microsoft.Owin.Security" %>
<%@ Import Namespace="Microsoft.Owin.Security.OpenIdConnect" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<script runat="server">

        // true se autenticato , false se no
        // in Msg il messaggio da restiruire al client, PersonsId restituisce il codice dell'utente
        Boolean CheckLogin(ref string ErrMsg, ref int iPersonsId)
        {

            DataTable dt = Database.GetData("SELECT Persons_Id, active, ForcedAccount, Name, UserId, userlevel_ID FROM Persons WHERE [userId]='" + TBusername.Text + "' AND [password]='" + TBpassword.Text + "'", this.Page);

            if (dt == null || dt.Rows.Count == 0)
            {
                ErrMsg = "User o password non riconosciuti";
                return (false); // utente non trovato 
            }
            else
            {

                if (!Convert.ToBoolean(dt.Rows[0]["ForcedAccount"]))
                {
                    ErrMsg = "Utente non valido, mancano limitazioni su progetti";
                    return (false); // Utente non valido, mancano limitazioni su progetti
                }

                // verifica che sia attivo
                if (!Convert.ToBoolean(dt.Rows[0]["active"]))
                {
                    ErrMsg = "Utente non attivo";
                    return (false); // Utente non attivo
                }

                // AUTENTICATO: SAVA COOCKIE
                if (RbCookie.Checked)
                    // Salva Cookie
                    Utilities.SetCookie("MobileUserName", dt.Rows[0]["UserId"].ToString());
                else
                {
                    // Pulisci Cookie
                    Utilities.SetCookie("MobileUserName", "");
                }

                // codice utente da tornare
                iPersonsId = Convert.ToInt32(dt.Rows[0]["Persons_Id"].ToString());

                // utente autenticato
                return (true);
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            string ErrMsg = "";
            int iPersonsId = 0;

            if (!IsPostBack)
            {
                //  Default userid
                if (Utilities.GetCookie("MobileUserName") != null)
                    TBusername.Text = Server.HtmlEncode(Utilities.GetCookie("MobileUserName"));

                // recupera default
                string AuthType = Utilities.GetCookie("AuthType");

                if (AuthType == "" || AuthType == "AD")
                    DDLTipoLogin.SelectedValue = "AD";
                else
                {
                    DDLTipoLogin.SelectedValue = AuthType;
                }

                // reset messaggio errore
                ErrorMsg.Text = "";
                ErrorMessage.Visible = false;
            }


            // in caso di postback o quando arriva da redirect 302 da Azure AD                 
            if (IsPostBack || Request.IsAuthenticated)
            {

                Utilities.SetCookie("authType", DDLTipoLogin.SelectedValue); // salva tipo autenticazione didefault

                // **** Login AD ****
                if (DDLTipoLogin.SelectedValue == "AD")
                {
                    if (Request.IsAuthenticated)
                    {
                        DataRow dr = Database.GetRow("SELECT Persons_Id FROM persons WHERE active = 1 and mail = " + ASPcompatility.FormatStringDb(System.Security.Claims.ClaimsPrincipal.Current.FindFirst("preferred_username").Value), this.Page);                      
                        TRSession CurrentSession = new TRSession(Convert.ToInt32(dr["Persons_Id"]));
                        Session["CurrentSession"] = CurrentSession;
                        Response.Redirect("/timereport/mobile/mobile-menu.aspx");
                    }
                    else
                    {
                        AzureADLogin();
                        return;
                    }
                }

                // **** Login Locale ****
                if (DDLTipoLogin.SelectedValue == "LL")
                {
                    // Verifica password se positiva passa al menù principale
                    ErrMsg = "";

                    if (CheckLogin(ref ErrMsg, ref iPersonsId))
                    {
                        TRSession CurrentSession = new TRSession(iPersonsId);
                        Session["CurrentSession"] = CurrentSession;
                        Response.Redirect("/timereport/mobile/mobile-menu.aspx");
                    }
                    else
                    {
                        // display messaggio di errore
                        ErrorMsg.Text = ErrMsg;
                        ErrorMessage.Visible = true;
                    }
                }

            }
        }

        // Azure Login
        protected void AzureADLogin()
        {

            if (!Request.IsAuthenticated)
            {
                HttpContext.Current.GetOwinContext().Authentication.Challenge(
                    new AuthenticationProperties { RedirectUri = ConfigurationManager.AppSettings["redirectUriMobile"] },
                    OpenIdConnectAuthenticationDefaults.AuthenticationType);

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

</head>

<body>
    <div data-role="page">
        <div data-role="header" data-position="fixed">
            <h1>Timereport Login</h1>
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

                <!-- *** Tipo Login ***  -->
                <div class="input nobottomborder">
                    <asp:DropDownList ID="DDLTipoLogin" runat="server" CssClass="ASPInputcontent">
                        <asp:ListItem Enabled="true" Text="Local Login" Value="LL"></asp:ListItem>
                        <asp:ListItem Text="Microsoft 365 Login" Value="AD"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <br />
                <asp:TextBox ID="TBusername" runat="server" placeholder="userid"></asp:TextBox>
                <br />
                <asp:TextBox runat="server" type="password" name="password" ID="TBpassword" value="" placeholder="Password" />
                <br />
                <asp:CheckBox ID="RbCookie" Text="Ricorda la user" runat="server" Checked="True"
                    data-inline="true" />
                <br />
                <asp:Button ID="Button1" type="submit" runat="server" data-role="button" data-inline="true"
                    data-theme="b" Text="Login" />
                &nbsp;<br />
                <br />

            </form>

            <div data-role="footer" style="position: absolute; width: 100%; bottom: 0; left: 0;">
                <h4>Aeonvis @ <%=DateTime.Now.Year.ToString()   %> - mTimeReport &nbsp;
                <img src="/timereport/images/mobile/beta_icon2.png" /></h4>
            </div>
            <!-- /footer -->
        </div>
        <!-- /page -->

        <script type="text/javascript">

            $(function () {

                // Hide/Show user and password
                SetUserPwdFields();

                // se Azure AD nasconde la user e la password dei form
                $("#DDLTipoLogin").on('change', '', function (e) {
                    SetUserPwdFields();
                    //$("#LblErrorMessage").text(""); // reset errore
                });

            });

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

            function SetUserPwdFields() {
                var optionSelected = $("#DDLTipoLogin").find("option:selected");

                if (optionSelected.val() == "AD") {
                    $("#TBusername").hide();
                    $("#TBpassword").hide();
                    $(".ui-checkbox").hide();
                } else {
                    $("#TBusername").show();
                    $("#TBpassword").show();
                    $(".ui-checkbox").show();
                }
            }

        </script>
</body>

</html>
