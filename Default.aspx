<%@ Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="defaultAspx" %>


<!--

** DOCUMENTAZIONE ***

per disattivare richiesta assenza
    1) parametro LEAVE_ON su web.config
    2) commento su menu_array.js delle voci di menu
    3) reset workflowtype a 0 per tutti i projects


-->
 
<!DOCTYPE html>

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- CSS override -->
<style>

    .auto-style1 {
        width: 187px;
        height: 189px;
    }

</style>

    <html xmlns="http://www.w3.org/1999/xhtml">
    
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>Timereport</title>

    <body>

        <div id="MainWindow">

        <div id="FormWrap" Class="StandardForm">

        <form id="form_login" runat="server"  >

           <div class="formtitle"  >
               <img alt="TR icon" style="width:22px;height:22px;vertical-align: middle" src="/timereport/favicon.ico" /> &nbsp;Timereport  </div>

            <!-- *** Tipo Login ***  -->
            <div class="input nobottomborder">

                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Login type:" ></asp:Label>

                <label class="dropdown" >
                    <asp:DropDownList ID="DDLTipoLogin" runat="server" style="width:220px">
                        <asp:ListItem Enabled="true" Text="Local Login" Value="LL"></asp:ListItem>
                        <asp:ListItem Text="Microsoft 365 Login" Value="AD"></asp:ListItem>
                    </asp:DropDownList>
                </label>

            </div>

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="LBusername" runat="server" Text="User name:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" style="width:210px" ID="TBusername" runat="server" data-parsley-required-message="insert user name" data-parsley-required="true" data-parsley-errors-container="#LblErrorMessage"/>
            </div>

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="LBpassword" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" style="width:210px" ID="TBpassword" runat="server"  data-parsley-required-message="insert password" data-parsley-required="true" data-parsley-errors-container="#LblErrorMessage" TextMode="Password" /> <%-- --%>
            </div>
           
        <!-- *** BOTTONI ***  -->
        <div class="buttons">
                    <%-- <span class="testoPiccolo">Aeonvis Spa, <%= DateTime.Now.Year  %></span>--%>
                    <asp:Label  CssClass="inputtext" ID="LblErrorMessage" runat="server" style="color:red;display:inline-block;width:280px; line-height:normal"></asp:Label>
<%--                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Login" CssClass="orangebutton" />         --%>
            
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" CssClass="orangebutton" style="text-align: center">
                        <asp:Image ID="imgFolder" runat="server" ImageUrl="/timereport/images/icons/16x16/enter.png" style="left:-10px;position:relative;vertical-align:middle" />
                        Login
                        </asp:LinkButton>



        </div>  

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

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
