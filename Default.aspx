<%@      Language="C#" AutoEventWireup="true" CodeFile="default.aspx.cs" Inherits="defaultAspx" %>
 
<!DOCTYPE html>

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

    <html xmlns="http://www.w3.org/1999/xhtml">

    <body>

        <div id="MainWindow">

        <div id="FormWrap" Class="StandardForm">

        <form id="form_login" runat="server"  >

           <div class="formtitle">Timereport Login</div>  

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="username" runat="server" Text="Nome utente:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" ID="TBusername" runat="server"  />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" Display="static" runat="server" ControlToValidate="TBusername" ErrorMessage="Inserire la userid"></asp:RequiredFieldValidator>

            </div>

            <!-- *** TEXT_BOX ***  -->
            <div class="input nobottomborder">
                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Password:"></asp:Label>
                <asp:TextBox CssClass="ASPInputcontent" ID="TBpassword" runat="server" TextMode="Password" /> <%-- --%>
                <asp:Label runat="server" ID="LblErrorMessage" Text="" style="color:red"></asp:Label>                
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" Display="static" runat="server" ControlToValidate="TBpassword" ErrorMessage="Inserire password"></asp:RequiredFieldValidator>
            </div>

            

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
