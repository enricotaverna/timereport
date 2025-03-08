<%@  Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="defaultAspx" %>

<!--

** DOCUMENTAZIONE ***

per disattivare richiesta assenza
    1) parametro LEAVE_ON su web.config
    2) commento su menu_array.js delle voci di menu
    3) reset workflowtype a 0 per tutti i projects

-->

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js?v=<%=MyConstants.JSS_VERSION %>"></script>

<!-- Jquery + parsley + datepicker  -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<!-- CSS-->
<link href="/timereport/include/jquery/jquery-ui.min.css" rel="stylesheet" />
<link href="/timereport/include/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
<link href="/timereport/include/BTmenu/menukit.css" rel="stylesheet" />
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet">
<link href="/timereport/include/newstyle.css?v=<%=MyConstants.CSS_VERSION %>" rel="stylesheet" />

<style>
    .ASPInputcontent {
        width: 230px;
    }
</style>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Timereport Login" />
    </title>
</head>

<body>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="form_login" runat="server">

            <div class="row justify-content-center">

                <div id="FormWrap" class="col-4 StandardForm mt-5">

                    <div class="formtitle">
                        <img alt="TR icon" style="width: 22px; height: 22px; vertical-align: middle" src="/timereport/favicon.ico" />
                        &nbsp;Timereport Login
                    </div>

                    <!-- *** Tipo Login ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Login type:"></asp:Label>
                             <asp:DropDownList ID="DDLTipoLogin" runat="server" CssClass="ASPInputcontent" >
                                <asp:ListItem Enabled="true" Text="Local Login" Value="LL"></asp:ListItem>
                                <asp:ListItem Text="Microsoft 365 Login" Value="AD"></asp:ListItem>
                            </asp:DropDownList>
                    </div>

                    <!-- *** TEXT_BOX ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="LBusername" runat="server" Text="User name:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBusername" runat="server" data-parsley-required-message="insert user name" data-parsley-required="true" data-parsley-errors-container="#LblErrorMessage" />
                    </div>

                    <!-- *** TEXT_BOX ***  -->
                    <div class="input nobottomborder">
                        <asp:Label CssClass="inputtext" ID="LBpassword" runat="server" Text="Password:"></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" data-parsley-required-message="insert password" data-parsley-required="true" data-parsley-errors-container="#LblErrorMessage" TextMode="Password" />
                        <%-- --%>
                    </div>

                    <br

                    <!-- *** BOTTONI ***  -->
                    <div class="buttons">
                        <%-- <span class="testoPiccolo">Aeonvis Spa, <%= DateTime.Now.Year  %></span>--%>
                        <asp:Label CssClass="inputtext" ID="LblErrorMessage" runat="server" Style="color: red; display: inline-block; width: 280px; line-height: normal"></asp:Label>
                        <%--                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Login" CssClass="orangebutton" />         --%>

                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" Style="text-align: center">
                            <asp:Image ID="imgFolder" runat="server" ImageUrl="/timereport/images/icons/16x16/enter.png" Style="left: -10px; position: relative; vertical-align: middle" />
                            Login
                        </asp:LinkButton>
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- *** End container *** -->

    <script type="text/javascript">

        $(function () {

            // *** Esclude i controlli nascosti *** 
            $('#form_login').parsley({
                excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
            });

            // Hide/Show user and password
            SetUserPwdFields();

            // se Azure AD nasconde la user e la password dei form
            $("#DDLTipoLogin").on('change', '', function (e) {
                SetUserPwdFields();
                $("#LblErrorMessage").text(""); // reset errore
            });

        });

        function SetUserPwdFields() {
            var optionSelected = $("#DDLTipoLogin").find("option:selected");

            if (optionSelected.val() == "AD") {
                $("#TBusername").hide();
                $("#TBpassword").hide();
                $("#LBusername").hide();
                $("#LBpassword").hide();
            } else {
                $("#TBusername").show();
                $("#TBpassword").show();
                $("#LBusername").show();
                $("#LBpassword").show();
            }
        }

    </script>

</body>
</html>
