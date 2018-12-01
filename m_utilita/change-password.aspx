<%@ Page Language="C#" AutoEventWireup="true" CodeFile="change-password.aspx.cs" Inherits="Templates_TemplateForm"   %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title> <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /> </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap" class="standardform" >

    <form id="FVMain" runat="server" >

        <div class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:titolo%>" /> </div> 

        <!-- *** OLD PWD ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" style="width:160px" runat="server" Text="Vecchia Password" meta:resourcekey="Label1Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBOldPwd" runat="server" MaxLength="10" 
                data-parsley-errors-container="#valMsg"  data-parsley-required="true" data-parsley-username="" data-parsley-trigger-after-failure="focusout"
                meta:resourcekey="TBOldPwdResource1" />
        </div>

        <!-- *** NEW PWD1 ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" style="width:160px"  runat="server" Text="Nuova Password" meta:resourcekey="Label2Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd1" runat="server" minlength="3" MaxLength="10" 
                         data-parsley-errors-container="#valMsg"  data-parsley-required="true" meta:resourcekey="TBNewPwd1Resource1" />
        </div>

        <!-- *** NEW PWD2 ***  -->
        <div class="input nobottomborder">
            <asp:Label CssClass="inputtext" style="width:160px"  runat="server" Text="Conferma Password" meta:resourcekey="Label3Resource1"></asp:Label>
            <asp:TextBox CssClass="ASPInputcontent" ID="TBNewPwd2" runat="server" minlength="3" MaxLength="10" 
                         data-parsley-errors-container="#valMsg"  data-parsley-equalto="#TBNewPwd1" data-parsley-required="true" 
                         meta:resourcekey="TBNewPwd2Resource1" />
        </div>

       <div class="input nobottomborder">
                <asp:Literal runat="server" Text="<%$ Resources:testohelp%>" />
         </div>

        <!-- *** BOTTONI ***  -->
        <div class="buttons">
            <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
            <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" OnClick="InsertButton_Click" meta:resourcekey="InsertButtonResource1"       /> 
            <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" OnClick="UpdateCancelButton_Click" meta:resourcekey="UpdateCancelButtonResource1"  formnovalidate  />                    
        </div>
       
    </form>
    
    </div> <%-- END FormWrap  --%> 
    
    </div> <%-- END MainWindow --%> 

    <!-- Per output messaggio conferma salvataggio -->
    <div id="dialog" style="display: none"></div>

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa    <%= DateTime.Now.Year %></div> 
        <div  id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>    
    </div> 

    <script type="text/javascript">

        // Lingua
        window.Parsley.setLocale('<%=Session["lingua"]%>');

        // *** Validazione che richiama un servizio, bisogna mettere il tag data-parsley-username sull'elemento del form *** //
         window.Parsley.addValidator('username', function (value, requirement) {
                    var response = false;
                    var dataAjax = "{ sPassword: '" + value +"' , " + " sUserName: '<%=Session["persons_id"]%>' }"

                    $.ajax({
                        url: "/timereport/webservices/WStimereport.asmx/CheckPassword",
                        data: dataAjax,
                        contentType: "application/json; charset=utf-8",
                        dataType: 'json',
                        type: 'post',
                        async: false,
                        success: function(data) {
                            if (data.d == "false")
                                response = false;
                            else
                                response = true;
                        },
                        error: function (xhr, ajaxOptions, thrownError) {
                            alert(xhr.status);
                            alert(thrownError);
                        }
                    });
                    return response;
         }, 32)
                .addMessage('en', 'username', 'Password not valid')
                .addMessage('it', 'username', 'Password non valida');

        $('#FVMain').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

        </script>

</body>

</html>


 

