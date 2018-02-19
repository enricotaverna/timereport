<%@ Page Language="C#" AutoEventWireup="true" CodeFile="input-ore.aspx.cs" Inherits="input_ore"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

 <!-- Stili -->
        <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
        
  <!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<link   rel="stylesheet" href="/timereport/include/jquery/jquery-ui.css" />
<script src="/timereport/mobile/js/jquery-1.6.4.js"></script>    
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script> 
<script src="/timereport/include/jquery/jquery-ui.js"></script>  
<script src="/timereport/include/javascript/timereport.js"></script>


  <script>
      $(function () {
          $("#FVore_TBAccountingDate").datepicker($.datepicker.regional['it']);
          $("#FVore_CancelFlagCheckBox").addClass("css-checkbox");

          $("#FVore_disCancelFlagCheckBox").addClass("css-checkbox");
          $("#FVore_disCancelFlagCheckBox").attr("disabled", true);

          /* nasconde DDL attività se non ci sono entries */
          var e = document.getElementById("FVore_DDLAttivita");
          var value = e.length;
          if (value < 2) {
              $('#FVore_DDLAttivita').hide();
              // nasconde anche DIV che include il DDL
              e.parentNode.className = "";
          } else {
              $('#FVore_DDLAttivita').show();
          }

          // gestione validation summary su validator custom (richiede timereport.js)//
          displayAlert();

      });
  </script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title><asp:Literal runat="server" Text="<%$ Resources:Titolo%>" /> </title>
</head>

<body>

    <div id="TopStripe"></div> 

    <div id="MainWindow">

    <div id="FormWrap">

    <form id="form1" runat="server">              

        <asp:FormView ID="FVore" runat="server" DataKeyNames="Hours_Id" 
            DataSourceID="DSore" align="center" DefaultMode="Edit" 
            oniteminserted="FVore_ItemInserted" onitemupdated="FVore_ItemUpdated"
            ondatabound="FVore_DataBound" CssClass="StandardForm" 
            onmodechanging="FVore_modechanging" meta:resourcekey="FVoreResource1" >
            
            <%--        EDIT--%>     
            <EditItemTemplate>

                            <div class="formtitle">
                                <asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                                <a href="AuditLog.aspx?RecordId=&amp;TableName=Hours&amp;TYPE=U&amp;key=&lt;Hours_Id=&gt;" >
                                <asp:image ID="Image1" runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="Image1Resource1" /></a>
                             </div> 
                        
                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource1"></asp:Label>
                                <asp:Label class="input2col"  ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource1"></asp:Label> 
                                <asp:Label ID="Label13" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="Label13Resource1"></asp:Label>
                            </div>
                    
                            <!-- *** DDL Progetto ***  -->
                             <div class="input nobottomborder">                                
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource1"></asp:Label>
                                <div class="InputcontentDDL">
                                    <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"  
                                    onselectedindexchanged="DDLProgetto_SelectedIndexChanged" 
                                    AutoPostBack="True" meta:resourcekey="DDLprogettoResource1">
                                    </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                    ControlToValidate="DDLprogetto" Display="None" 
                                    ErrorMessage="Specificare un codice progetto" InitialValue="0" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            
                             <!-- *** DDL Attività ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource1"></asp:Label>
                                <div class="InputcontentDDL">
                                <asp:DropDownList ID="DDLAttivita" runat="server" AutoPostBack="True"  AppendDataBoundItems="True" 
                                Visible="False" meta:resourcekey="DDLAttivitaResource1" >
                                <asp:ListItem meta:resourcekey="ListItemResource1">--seleziona attività--</asp:ListItem>
                                </asp:DropDownList>
                                </div>
                                <asp:CustomValidator ID="CustomValidator2" runat="server" 
                                OnServerValidate="ValidaAttivita" Display="None" 
                                ErrorMessage="Specificare un codice attività" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
                            </div>

                             <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource1"></asp:Label>
                                <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource1"  />
                                </span>
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server"  Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource1" />
                                <asp:Label AssociatedControlId="CancelFlagCheckBox" CssClass="css-label" ID="Label9"  runat="server" Text="Storno" meta:resourcekey="Label9Resource1" ></asp:Label>    
                            </div>

                            <asp:RegularExpressionValidator ID="RegularExpressionValidatorm1" runat="server" Display="None" 
                                    ControlToValidate="HoursTextBox" ErrorMessage="Numero ore deve essere un valore numerico positivo" 
                                    ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)" meta:resourcekey="RegularExpressionValidatorm1Resource1"></asp:RegularExpressionValidator>   

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="HoursTextBox" Display="None"  
                                ErrorMessage="Inserire numero ore" meta:resourcekey="RequiredFieldValidator4Resource1"></asp:RequiredFieldValidator>
 
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Nota" meta:resourcekey="Label1Resource1"></asp:Label>
                                <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea"
                                    Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource1" />
                            </div>
                            <asp:CustomValidator ID="CV_TBComment" runat="server" Display="None" ErrorMessage="Inserire una nota di commento" ControlToValidate="TBComment" OnServerValidate="CV_TBComment_ServerValidate" ValidateEmptyText="True" meta:resourcekey="CV_TBCommentResource1"  ></asp:CustomValidator>

                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource1"></asp:Label>
                                <asp:TextBox  CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' Columns="8" meta:resourcekey="TBAccountingDateResource1"  />                                                                
                                <asp:RangeValidator ID="RangeValidator4" runat="server" Display="None" 
                                    ErrorMessage="Inserire una data competenza valida" ControlToValidate="TBAccountingDate" 
                                    Type="Date" MaximumValue="31/12/9999" MinimumValue="1/1/2000" meta:resourcekey="RangeValidator4Resource1" ></asp:RangeValidator>
                            </div>

                            <!-- *** TB Competenza ***  -->
                            <div class="buttons">
                                <asp:Button ID="UpdateButton" runat="server" CommandName="Update" CssClass="orangebutton" Text="<%$ Resources:timereport, SAVE_TXT %>" meta:resourcekey="UpdateButtonResource1"   /> 
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource1"  />                    
                            </div>

            </EditItemTemplate> 

            <%--        INSERT--%> 
            <InsertItemTemplate>
                
                            <div class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:Titolo%>" /></div>  
                        
                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource2"></asp:Label>
                                <asp:Label class="input2col"  ID="LBdate" runat="server" Text='<%# Bind("Date") %>' meta:resourcekey="LBdateResource2"></asp:Label> 
                                <asp:Label ID="LBperson" runat="server" Text='<%# Bind("persons_id") %>' meta:resourcekey="LBpersonResource1"></asp:Label>
                            </div>
                    
                            <!-- *** DDL Progetto ***  -->
                             <div class="input nobottomborder">                                
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource2"></asp:Label>
                                <div class="InputcontentDDL">
                                    <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True"  
                                    onselectedindexchanged="DDLProgetto_SelectedIndexChanged" 
                                    AutoPostBack="True" meta:resourcekey="DDLprogettoResource2">
                                    </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="DDLprogetto" Display="None" 
                                    ErrorMessage="Specificare un codice progetto" InitialValue="0" meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            
                             <!-- *** DDL Attività ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label6" runat="server" Text="Attività" meta:resourcekey="Label6Resource2"></asp:Label>
                                <div class="InputcontentDDL">
                                <asp:DropDownList ID="DDLAttivita" runat="server" AutoPostBack="True"  AppendDataBoundItems="True" 
                                Visible="False" meta:resourcekey="DDLAttivitaResource2" >
                                <asp:ListItem meta:resourcekey="ListItemResource2">--seleziona attività--</asp:ListItem>
                                </asp:DropDownList>
                                </div>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" 
                                OnServerValidate="ValidaAttivita" Display="None" 
                                ErrorMessage="Specificare un codice attività" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                            </div>

                             <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource2"></asp:Label>
                                <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" meta:resourcekey="HoursTextBoxResource2"  />
                                </span>
                                <asp:CheckBox ID="CancelFlagCheckBox" runat="server"  Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="CancelFlagCheckBoxResource2" />
                                <asp:Label AssociatedControlId="CancelFlagCheckBox" CssClass="css-label" ID="Label5"  runat="server" Text="Storno" meta:resourcekey="Label5Resource1" ></asp:Label>                            
                            </div>
                            
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" Display="None" 
                                    ControlToValidate="HoursTextBox" ErrorMessage="Numero ore deve essere un valore numerico positivo" 
                                    ValidationExpression="(^\d*\,?\d*[1-9]+\d*$)|(^[1-9]+\d*\,\d*$)" meta:resourcekey="RegularExpressionValidator1Resource1"></asp:RegularExpressionValidator>                
                            
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="HoursTextBox" Display="None"  
                                ErrorMessage="Inserire numero ore" meta:resourcekey="RequiredFieldValidator3Resource1"></asp:RequiredFieldValidator>
 
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label1" runat="server" Text="Nota" meta:resourcekey="Label1Resource2"></asp:Label>
                                <asp:TextBox ID="TBComment" runat="server" Rows="5" CssClass="textarea"
                                    Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" meta:resourcekey="TBCommentResource2" />
                            </div>
                            <asp:CustomValidator ID="CV_TBComment" runat="server" Display="None" ErrorMessage="Inserire una nota di commento" ControlToValidate="TBComment" OnServerValidate="CV_TBComment_ServerValidate" ValidateEmptyText="True" meta:resourcekey="CV_TBCommentResource2"  ></asp:CustomValidator>

                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="LBAccountingDate" runat="server" Text="Competenza" meta:resourcekey="LBAccountingDateResource2"></asp:Label>
                                <asp:TextBox  CssClass="ASPInputcontent" ID="TBAccountingDate" runat="server" Text='<%# Bind("AccountingDate") %>' Columns="8" meta:resourcekey="TBAccountingDateResource2"  />                                                                
                                <asp:RangeValidator ID="RangeValidator2" runat="server" Display="None" 
                                    ErrorMessage="Inserire una data competenza valida" ControlToValidate="TBAccountingDate" 
                                    Type="Date" MaximumValue="31/12/9999" MinimumValue="1/1/2000" meta:resourcekey="RangeValidator2Resource1" ></asp:RangeValidator>
                            </div>

                            <!-- *** TB Competenza ***  -->
                            <div class="buttons">
                                <asp:Button ID="InsertButton" runat="server" CommandName="Insert" CssClass="orangebutton" Text="<%$ Resources:timereport,SAVE_TXT %>" meta:resourcekey="InsertButtonResource1"      /> 
                                <asp:Button ID="UpdateCancelButton" runat="server" CausesValidation="False" CssClass="greybutton" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource2"    />                    
                            </div>

            </InsertItemTemplate>

            <%--        DISPLAY--%> 
            <ItemTemplate>
                             <div class="formtitle"><asp:Literal runat="server" Text="<%$ Resources:Titolo%>" />
                             <a href="AuditLog.aspx?RecordId=&amp;TableName=Hours&amp;TYPE=U&amp;key=&lt;Hours_Id=&gt;" >
                             <asp:image runat="server" ImageUrl="/timereport/images/icons/16x16/cog.png" ToolTip="Vedi log modifiche" meta:resourcekey="ImageResource1" /></a>
                             </div> 

                            <!-- *** LB Data ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label11" runat="server" Text="Data" meta:resourcekey="Label11Resource3"></asp:Label>
                                <asp:Label class="input2col" ID="LBdate" runat="server" Text='<%# Bind("Date","{0:d}") %>' meta:resourcekey="LBdateResource3"></asp:Label> 
                                <asp:Label ID="LBperson" runat="server" Text='<%# Bind("name") %>' meta:resourcekey="LBpersonResource2"></asp:Label>
                            </div>

                            <!-- *** DDL Progetto ***  -->
                            <div class="input nobottomborder">                                
                                <asp:Label CssClass="inputtext" ID="Label7" runat="server" Text="Progetto" meta:resourcekey="Label7Resource3"></asp:Label>
                                <div class="InputcontentDDL">
                                <asp:DropDownList ID="DDLprogetto" runat="server" AppendDataBoundItems="True" 
                                AutoPostBack="True" Enabled="False" 
                                onselectedindexchanged="DDLProgetto_SelectedIndexChanged" meta:resourcekey="DDLprogettoResource3" >
                                </asp:DropDownList>
                                </div>
                            </div>

                             <!-- *** DDL Attività ***  -->
                            <div class="input">
                                <asp:Label CssClass="inputtext" ID="Label8" runat="server" Text="Attività" meta:resourcekey="Label8Resource1"></asp:Label>
                                <div class="InputcontentDDL">
                                    <asp:DropDownList ID="DDLAttivita" runat="server" AppendDataBoundItems="True" 
                                    AutoPostBack="True" CssClass="FormInputDisabled" Enabled="False" Width="240px" meta:resourcekey="DDLAttivitaResource3">
                                    <asp:ListItem meta:resourcekey="ListItemResource3">-- seleziona un valore --</asp:ListItem>
                                    </asp:DropDownList>
                                </div>      
                            </div>

                            <!-- *** TB Ore ***  -->
                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="Label4" runat="server" Text="Ore" meta:resourcekey="Label4Resource3"></asp:Label>
                                <span class="input2col">
                                <asp:TextBox CssClass="ASPInputcontent" ID="HoursTextBox" runat="server" Text='<%# Bind("Hours") %>' Columns="5" enabled="False" meta:resourcekey="HoursTextBoxResource3" />
                                </span>
                                <asp:CheckBox ID="disCancelFlagCheckBox" runat="server"  Checked='<%# Bind("CancelFlag") %>' meta:resourcekey="disCancelFlagCheckBoxResource1"  />
                                <asp:Label AssociatedControlId="disCancelFlagCheckBox" CssClass="css-label" ID="Label5"  runat="server" Text="Storno" meta:resourcekey="Label5Resource2" ></asp:Label>
                            </div>

                            <div class="input nobottomborder">
                                <asp:Label CssClass="inputtext" ID="CommentTextBox" runat="server" Text="Nota" meta:resourcekey="CommentTextBoxResource1"></asp:Label>
                                <asp:TextBox ID="TextBox2" runat="server" Rows="5" CssClass="textarea" Text='<%# Bind("Comment") %>' TextMode="MultiLine" Columns="30" Enabled="False" meta:resourcekey="TextBox2Resource1" />
                            </div>

                            <!-- *** TB Comment ***  -->
                            <div class="input nobottomborder">
                                <asp:Label ID="LBAccountingDate" runat="server" Text="Competenza" CssClass="inputtext" meta:resourcekey="LBAccountingDateResource3"></asp:Label>
                                <asp:Label ID="LBAccountingDateDisplay" runat="server" Text='<%# Bind("AccountingDate","{0:d}") %>' CssClass="ASPInputcontent" Columns="8" Width="100px" meta:resourcekey="LBAccountingDateDisplayResource1"></asp:Label>                          
                            </div>
                            
                            <!-- *** TB Competenza ***  -->
                            <div class="buttons">
                                <asp:Button ID="UpdateCancelButton" CssClass="greybutton" runat="server" CausesValidation="False" CommandName="Cancel" Text="<%$ Resources:timereport,CANCEL_TXT %>" meta:resourcekey="UpdateCancelButtonResource3" />  

                            </div>
                             
            </ItemTemplate>
      
        </asp:FormView>           
    
        <asp:SqlDataSource ID="DSprogetti" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Projects_Id, ProjectCode + ' ' + left(Name,20) AS iProgetto FROM Projects where active = 'true' and activityON = 'true' order by ProjectCode">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="DStipoore" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT HourType_Id, HourTypeCode + ' ' + Name AS iTipoOra FROM HourType">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="DSattivita" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
            SelectCommand="SELECT Activity_id, Name + ' ' + ActivityCode AS iAttivita FROM Activity WHERE active = 'true'">
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="DSore" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MSSql12155ConnectionString %>" 
                       
            SelectCommand="SELECT Hours.Hours_Id, Hours.Projects_Id, Hours.Persons_id, Hours.Date, Hours.Hours, Hours.HourType_Id, Hours.CancelFlag, Hours.Comment, Hours.TransferFlag, Hours.Activity_id, Persons.Name, CreatedBy, CreationDate, LastModifiedBy, LastModificationDate,AccountingDate FROM Hours INNER JOIN Persons ON Hours.Persons_id = Persons.Persons_id WHERE (Hours.Hours_Id = @hours_id)" 
            InsertCommand="INSERT INTO Hours(Projects_Id, Persons_id, Date, HourType_Id, Hours, CancelFlag, Comment, TransferFlag, Activity_id, CreatedBy, CreationDate, AccountingDate) VALUES (@Projects_id, @Persons_id, @Date, @HourType_id, @Hours, @CancelFlag, @Comment, @TransferFlag, @Activity_id, @CreatedBy, @CreationDate, @AccountingDate)" 
            UpdateCommand="UPDATE Hours SET Hours = @Hours, HourType_Id = @HourType_Id, CancelFlag = @CancelFlag, Comment = @Comment, TransferFlag = @TransferFlag, Activity_id = @Activity_id, Projects_Id = @Projects_Id, LastModifiedBy= @LastModifiedBy, LastModificationDate = @LastModificationDate, AccountingDate = @AccountingDate WHERE (Hours_Id = @Hours_id)" 
            oninserting="DSore_Insert_Update" onupdating="DSore_Insert_Update">
            
            <InsertParameters>
                <asp:Parameter Name="Projects_id" />
                <asp:Parameter Name="Persons_id" />
                <asp:Parameter Name="Date" />
                <asp:Parameter Name="HourType_id" DefaultValue="1" />
                <asp:Parameter Name="Hours" />
                <asp:Parameter Name="CancelFlag" />
                <asp:Parameter Name="Comment" />
                <asp:Parameter Name="TransferFlag" />
                <asp:Parameter Name="Activity_id" />
                <asp:Parameter Name="CreatedBy" />
                <asp:Parameter Name="CreationDate" />
                <asp:Parameter Name="AccountingDate" Type="DateTime" />
            </InsertParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="hours_id" QueryStringField="hours_id" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="Hours" />
                <asp:Parameter Name="HourType_Id" DefaultValue="1" />
                <asp:Parameter Name="CancelFlag" />
                <asp:Parameter Name="Comment" />
                <asp:Parameter Name="TransferFlag" />
                <asp:Parameter Name="Activity_id" />
                <asp:Parameter Name="Projects_Id" />
                <asp:Parameter Name="Hours_id" />
                <asp:Parameter Name="CreatedBy" />
                <asp:Parameter Name="CreationDate" />
                <asp:Parameter Name="LastModifiedBy" />
                <asp:Parameter Name="LastModificationDate" />
                <asp:Parameter Name="AccountingDate" Type="DateTime" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <%--        INSERT--%>

        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ShowMessageBox="True" ShowSummary="False" meta:resourcekey="ValidationSummary2Resource1"  />
   
    </form>

    </div> <%--        DISPLAY--%> 
    
    </div> 

    <!-- **** FOOTER **** -->  
    <div id="WindowFooter">       
        <div ></div>        
        <div  id="WindowFooter-L"> Aeonvis Spa <%= DateTime.Today.Year  %></div> 
        <div  id="WindowFooter-C">cutoff: <%= Session["CutoffDate"]%>  </div>              
        <div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>      
     </div>  

</body>

</html>
