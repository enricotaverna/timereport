<%@ Page Language="VB" AutoEventWireup="false" CodeFile="messaggi_lookup_form.aspx.vb" validateRequest=false
    Inherits="m_gestione_messaggi_lookup_form" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session("userLevel")%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery   -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>   
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<script>

    $(document).ready(function () {
        //    attribuisce id alla DIV della gridview 
        $('#GridView1').closest('div').attr('id', 'PanelWrap');

        $("#SchedaMessaggio_DataATextBox").datepicker($.datepicker.regional['it']); // date picker
        $("#SchedaMessaggio_DataDaTextBox").datepicker($.datepicker.regional['it']); // date picker

    });

</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dettagli Messaggio</title>

    </head>

<body>

 <div id="TopStripe"></div>  
 
 <div id="MainWindow"> 

    <div id="FormWrap" >

    <form id="form1" runat="server"  class="StandardForm">
  
        <asp:FormView ID="SchedaMessaggio" runat="server" DataKeyNames="MessaggioID" DataSourceID="SqlDataSource1"
            EnableModelValidation="True"  DefaultMode="Insert">
           
            <EditItemTemplate>

            <div class="formtitle">Gestione messaggi Home Page</div> 

               <!-- *** TITOLO ***  -->  
               <div class="input nobottomborder">  
                     <div class="inputtext">Titolo: </div>  
                     <asp:TextBox  CssClass=ASPInputcontent ID="TitoloTextBox" runat="server" Columns="20" MaxLength="20" Text='<%# Bind("Titolo") %>' /> 
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TitoloTextBox" Display="none" ErrorMessage="Inserisci titolo messaggio"></asp:RequiredFieldValidator> 
               </div>    

            <!-- *** DATE PICKER ***  --> 
            <div class="input nobottomborder"> 
                <asp:Label ID="DataDaTextBox1" runat="server" Text="Valido da" CssClass="inputtext"></asp:Label> 
                <asp:TextBox ID="DataDaTextBox" runat="server" Text='<%# Bind("DataDa", "{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" />                           
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="DataDaTextBox" Display="none" ErrorMessage="Inserire una data inizio annuncio valida"></asp:RequiredFieldValidator> 
                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                        ControlToValidate="DataDaTextBox" Display="None" 
                        ErrorMessage="Inserire una data inizio annuncio valida" MaximumValue="31/12/9999" 
                        MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
            </div> 

            <!-- *** DATE PICKER ***  --> 
            <div class="input nobottomborder"> 
                <asp:Label ID="Label1" runat="server" Text="Valido fino" CssClass="inputtext"></asp:Label> 
                <asp:TextBox ID="DataATextBox" runat="server" Text='<%# Bind("DataA", "{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" />                            
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DataATextBox" Display="none" ErrorMessage="Inserire una data fine annuncio valida"></asp:RequiredFieldValidator> 
                 <asp:RangeValidator ID="RangeValidator2" runat="server" 
                        ControlToValidate="DataATextBox" Display="None" 
                        ErrorMessage="Inserire una data fine annuncio valida" MaximumValue="31/12/9999" 
                        MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
            </div> 

             <!-- *** MESSAGGIO ***  -->  
             <div class="input nobottomborder">  
                     <div class="inputtext">Messaggio</div>  
                      <asp:TextBox ID="MessaggioTextBox" runat="server" MaxLength="100" Text='<%# Bind("Messaggio") %>' Columns="30" TextMode="MultiLine" CssClass="textarea"  />
             </div>  

             <!-- *** BOTTONI  ***  --> 
               <div class="buttons">
               <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update"  CssClass="orangebutton"   Text="<%$ appSettings: SAVE_TXT %>" />
               <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" CssClass="greybutton"  Text="<%$ appSettings: CANCEL_TXT %>" />
            </div>  
        
            </EditItemTemplate>

            <InsertItemTemplate>

            <div class="formtitle">Gestione messaggi Home Page</div> 

               <!-- *** TITOLO ***  -->  
               <div class="input nobottomborder">  
                     <div class="inputtext">Titolo: </div>  
                     <asp:TextBox  CssClass=ASPInputcontent ID="TitoloTextBox" runat="server" Columns="20" MaxLength="20" Text='<%# Bind("Titolo") %>' /> 
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TitoloTextBox" Display="none" ErrorMessage="Inserisci titolo messaggio"></asp:RequiredFieldValidator> 
               </div>    

            <!-- *** DATE PICKER ***  --> 
            <div class="input nobottomborder"> 
                <asp:Label ID="DataDaTextBox1" runat="server" Text="Valido da" CssClass="inputtext"></asp:Label> 
                <asp:TextBox ID="DataDaTextBox" runat="server" Text='<%# Bind("DataDa", "{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" />                           
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="DataDaTextBox" Display="none" ErrorMessage="Inserire una data inizio annuncio valida"></asp:RequiredFieldValidator> 
               <asp:RangeValidator ID="RangeValidator2" runat="server" 
                        ControlToValidate="DataDaTextBox" Display="None" 
                        ErrorMessage="Inserire una data inizio annuncio valida" MaximumValue="31/12/9999" 
                        MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
            </div> 

            <!-- *** DATE PICKER ***  --> 
            <div class="input nobottomborder"> 
                <asp:Label ID="Label1" runat="server" Text="Valido fino" CssClass="inputtext"></asp:Label> 
                <asp:TextBox ID="DataATextBox" runat="server" Text='<%# Bind("DataA", "{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" />                            
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="DataATextBox" Display="none" ErrorMessage="Inserire una data fine annuncio valida"></asp:RequiredFieldValidator> 
                    <asp:RangeValidator ID="RangeValidator3" runat="server" 
                        ControlToValidate="DataATextBox" Display="None" 
                        ErrorMessage="Inserire una data fine annuncio valida" MaximumValue="31/12/9999" 
                        MinimumValue="01/01/2000" Type="Date" ></asp:RangeValidator>
            </div> 

             <!-- *** MESSAGGIO ***  -->  
             <div class="input nobottomborder">  
                     <div class="inputtext">Messaggio</div>  
                      <asp:TextBox ID="TextBox4" runat="server" MaxLength="100" Text='<%# Bind("Messaggio") %>' Columns="30" TextMode="MultiLine" CssClass="textarea"  />
             </div>  

             <!-- *** BOTTONI  ***  --> 
               <div class="buttons">
                <asp:Button ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="<%$ appSettings: SAVE_TXT %>"  CssClass="orangebutton" />
                <asp:Button ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ appSettings: CANCEL_TXT %>" CssClass="greybutton" />
            </div>  

            </InsertItemTemplate>
            
            <ItemTemplate>
            </ItemTemplate>

        </asp:FormView>

        <asp:ValidationSummary ID="VSValidator" runat="server" ShowMessageBox="True" ShowSummary="false"  />

    </form>    

    </div> <!-- END FormWrap -->

    </div> <!-- END MainWindow --> 
 
    <!-- **** FOOTER **** -->   
    <div id="WindowFooter">        
        <div ></div>         
        <div  id="WindowFooter-L"> Aeonvis Spa <%= Year(now())  %></div>  
        <div  id="WindowFooter-C">cutoff: <%=session("CutoffDate")%>  </div>               
        <div id="WindowFooter-R">Utente: <%= Session("UserName")  %></div>         
     </div> 

</body>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
            SelectCommand="SELECT * FROM [Messaggi] WHERE ([MessaggioID] = @MessaggioID)"
            DeleteCommand="DELETE FROM [Messaggi] WHERE [MessaggioID] = @original_MessaggioID"
            InsertCommand="INSERT INTO [Messaggi] ([DataDa], [DataA], [Titolo], [Messaggio]) VALUES (@DataDa, @DataA, @Titolo, @Messaggio)"
            OldValuesParameterFormatString="original_{0}" 
            UpdateCommand="UPDATE [Messaggi] SET [DataDa] = @DataDa, [DataA] = @DataA, [Titolo] = @Titolo, [Messaggio] = @Messaggio WHERE [MessaggioID] = @original_MessaggioID">
            <DeleteParameters>
                <asp:Parameter Name="original_MessaggioID" Type="Int32" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="DataDa" Type="DateTime" />
                <asp:Parameter Name="DataA" Type="DateTime" />
                <asp:Parameter Name="Titolo" Type="String" />
                <asp:Parameter Name="Messaggio" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="MessaggioID" QueryStringField="MessaggioID" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="DataDa" Type="DateTime" />
                <asp:Parameter Name="DataA" Type="DateTime" />
                <asp:Parameter Name="Titolo" Type="String" />
                <asp:Parameter Name="Messaggio" Type="String" />
                <asp:Parameter Name="original_MessaggioID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
</html>
