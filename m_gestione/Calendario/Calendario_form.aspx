<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Calendario_form.aspx.cs"
    Inherits="Calendario_lookup_form" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Style -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css">
     
<!-- Jquery   -->
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.min.js"></script> 

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Dettagli Attività</title>
</head>

<body>

<div id="TopStripe"></div>  
 
<div id="MainWindow"> 

<div id="FormWrap" >

    <form id="FormHolidays" runat="server">

         <!-- *** TITOLO FORM ***  -->
         <div class="formtitle">Giorno Festivo</div> 

        <asp:FormView ID="FVForm" runat="server" DataKeyNames="CalendarHolidays_id" DataSourceID="DSCalendarHolidays"
            EnableModelValidation="True"  DefaultMode="Insert" class="StandardForm"
            OnItemUpdated="FVForm_ItemUpdated" OnModeChanging="ItemModeChanging_FVForm" width="100%" OnItemInserted="FVForm_ItemInserted">

            <EditItemTemplate> <!-- USATO SIA IN INSERT CHE UPDATE -->

            <!-- *** SEDE ***  -->
	            <div class="input">                        
	                <div class="inputtext">Sede:</div>  
                    <label class="dropdown" style="width:265px" >
                                <asp:DropDownList ID="DDLSede" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'  
                                data-parsley-errors-container="#valMsg" required=""  >

                                </asp:DropDownList>                    
                    </label>
                </div>

            <!-- *** DATE ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Festivo:" ></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBCalDay" runat="server"  style="width:140px" Text='<%# Bind("CalDay" ,"{0:d}") %>'  autocomplete="off"
                                     data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/"  required="" />
                </div>
                     
                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                    <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CssClass="orangebutton" CommandName="Insert"  Text="<%$ appSettings: SAVE_TXT %>"/>
                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel"  Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate=""/>             
                </div>  

            </EditItemTemplate> 

            <ItemTemplate>

            <!-- *** SEDE ***  -->
	            <div class="input">                        
	                <div class="inputtext">Sede:</div>  
                    <label class="dropdown" style="width:265px" >
                                <asp:DropDownList ID="DDLSede" runat="server" AppendDataBoundItems="True"
                                DataSourceID="DSSede" DataTextField="CalName" DataValueField="Calendar_id" SelectedValue='<%# Bind("Calendar_id") %>'  
                                data-parsley-errors-container="#valMsg" required="" >
                                </asp:DropDownList>                    
                    </label>
                </div>

            <!-- *** DATE ***  -->
                <div class="input nobottomborder">
                        <asp:Label ID="Label5" CssClass="inputtext" runat="server" Text="Festivo:" ></asp:Label>
                        <asp:TextBox CssClass="ASPInputcontent" ID="TBCalDay" runat="server"  style="width:140px" Text='<%# Bind("CalDay","{0:d}") %>' autocomplete="off"
                                     data-parsley-errors-container="#valMsg" data-parsley-pattern="/^([12]\d|0[1-9]|3[01])\D?(0[1-9]|1[0-2])\D?(\d{4})$/"  required="" />
                </div>
                     
                <!-- *** BOTTONI  ***  -->
                <div class="buttons">
                    <div id="valMsg"" class="parsely-single-error" style="display:inline-block;width:130px"></div>
                    <asp:Button ID="UpdateButton" runat="server" CausesValidation="True" CssClass="orangebutton" CommandName="Insert"  Text="<%$ appSettings: SAVE_TXT %>"/>
                    <asp:Button ID="UpdateCancelButton" runat="server" CssClass="greybutton" CausesValidation="False" CommandName="Cancel"  Text="<%$ appSettings: CANCEL_TXT %>" formnovalidate=""/>             
                </div>  

            </ItemTemplate>
                    
      </asp:FormView>
         
    </form>

   </div> <!-- END FormWrap -->

  </div> <!-- END MainWindow -->

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R">Utente: <%= Session["UserName"]  %></div>        
     </div>  
 
    <asp:SqlDataSource ID="DSCalendarHolidays" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
        InsertCommand="INSERT INTO [CalendarHolidays] ([Calendar_id], [CalYear], [CalDay]) VALUES (@Calendar_id, @CalYear, @CalDay)" 
        SelectCommand="SELECT * FROM [CalendarHolidays] WHERE CalendarHolidays_id = @CalendarHolidays_id" 
        UpdateCommand="UPDATE [CalendarHolidays] SET [Calendar_id] = @Calendar_id, [CalYear] = @CalYear, [CalDay] = @CalDay WHERE [CalendarHolidays_id] = @CalendarHolidays_id" 
        OnInserting="DSCalendarHolidays_Inserting"
        OnUpdating="DSCalendarHolidays_Inserting"
        >
        <SelectParameters>
            <asp:QueryStringParameter  Name="CalendarHolidays_id" QueryStringField="CalendarHolidays_id" />
        </SelectParameters>        
 
        <InsertParameters>
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="CalYear" Type="Int32" />
            <asp:Parameter Name="CalDay" Type="DateTime" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="Calendar_id" Type="Int32" />
            <asp:Parameter Name="CalYear" Type="Int32" />
            <asp:Parameter Name="CalDay" Type="DateTime" />
            <asp:Parameter Name="CalendarHolidays_id" Type="Int32" />
        </UpdateParameters>
    </asp:SqlDataSource>
 
    <asp:SqlDataSource ID="DSSede" runat="server" ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>"
        SelectCommand="SELECT Calendar_id, CalName FROM Calendar ORDER BY CalName">
    </asp:SqlDataSource>

 <script type="text/javascript">

        // *** Page Load ***  
        $(function () {

            $("#FVForm_TBCalDay").datepicker($.datepicker.regional['it']);

        });

        // *** Esclude i controlli nascosti *** 
        $('#FormHolidays').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], input[type=hidden], [disabled], :hidden"
        });

</script>

</body>

</html>
