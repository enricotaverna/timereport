<%@      Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="defaultAspx" %>
 
<!DOCTYPE html>

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script>

    <html xmlns="http://www.w3.org/1999/xhtml">

    <body>

        <div id="MainWindow">

        <div id="FormWrap">

        <form id="form_login" runat="server" Class="StandardForm" >

           <div class="formtitle">Timereport Login</div>  

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="username" runat="server" Text="Nome utente:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" ID="TBusername" runat="server" Text="etaverna" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="static" runat="server" ControlToValidate="TBusername" ErrorMessage="Inserire la userid"></asp:RequiredFieldValidator>

            </div>

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" Text="oeaqiffr" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="static" runat="server" ControlToValidate="TBpassword" ErrorMessage="Inserire password"></asp:RequiredFieldValidator>
            </div>

            <asp:Label runat="server" ID="LblErrorMessage" Text="" ></asp:Label>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
                    <span class="testoPiccolo">Aeonvis Spa, <%= DateTime.Now.Year  %></span>
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Login" CssClass="orangebutton" />         
        </div>  

    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

</body>
</html>
