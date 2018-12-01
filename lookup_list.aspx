<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Globalization" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />

<!-- Jquery   -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="/timereport/include/jquery/jquery-1.9.0.min.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<SCRIPT language=JavaScript src= "/timereport/include/menu/mmenu.js" type=text/javascript></SCRIPT>

<script runat="server">

    string strKeyName;      // name of the key field od the table
    bool bolRecordFound;
    DataTable aRecord;
    int intCounter = 0;

    protected void Page_Load(object sender, EventArgs e)
    {

        //	Authorization level 3 needed for this function
        Auth.CheckPermission("CONFIG", "TABLE");

        if (Request["cancel_from_list"] == "Cancel")
            Response.Redirect("/timereport/menu.aspx");

        //--- Initialize values
        if (Request["init"] == "true")
        {
            Session["TableName"] = "";   // name of the checktable
            Session["FieldNumber"] = ""; // number of fields to be dispalyed on the list
            Session["SortField"] = "";   // Field by which the list is sorted
            Session["CheckTable"] = "";  // if used name of the cross reference table (e.g. for author<->book)
        }

        if (Request["TableName"] != null)
            Session["TableName"] = Request["TableName"].ToString();

        if (Request["CheckTable"] != null)
            Session["CheckTable"] = Request["CheckTable"].ToString();

        if (Request["SortField"] != null)
            Session["SortField"] = Request["SortField"].ToString();

        if (Request["FieldNumber"] != null)
            Session["FieldNumber"] = Request["FieldNumber"].ToString();

        //    Get the records
        if (Session["SortField"] == null)
            aRecord = Database.GetData("SELECT * FROM " + Session["TableName"], this.Page);
        else
            aRecord = Database.GetData("SELECT * FROM " + Session["TableName"] + " ORDER BY " + Session["SortField"], this.Page);

        if (aRecord.Rows.Count > 0) {
            bolRecordFound = true;
            strKeyName = aRecord.Columns[0].ColumnName;
        }

        //--- delete record
        if (Request["action"] == "delete")
        {
            Database.ExecuteSQL("DELETE FROM " + Session["TableName"] + " where " + strKeyName + " = '" + Request["Id"] + "'", this.Page);
            Response.Redirect("lookup_list.aspx?TableName=" + Session["TableName"]);
        }

    }


    protected void DeleteIcon(string intIndex)
    {

        if (Session["CheckTable"] == null || Session["CheckTable"] == "")
        {
            Response.Write("<a href=lookup_list.aspx?action=delete&id=" + intIndex + "><img src=images/icons/16x16/trash.gif width=16 height=16 border=0></a>");
            return;
        }
        else
        {

            if (Database.RecordEsiste("SELECT TOP 1 " + strKeyName + " FROM " + Session["CheckTable"].ToString() + " WHERE " + strKeyName + "='" + intIndex + "'"))
                Response.Write("<img src=images/transparent.gif width=16 height=16 border=0>");
            else
                Response.Write("<a href=lookup_list.aspx?action=delete&id=" + intIndex + "><img src=images/icons/16x16/trash.gif width=16 height=16 border=0></a>");
        }
    }

    // ----------------------------------------------------------------------------
    public string GetDescription(string FieldName, string FieldValue)
    // ----------------------------------------------------------------------------
    {
        string  strLookUpTable;
        DataRow drResult;
        string sResult = "";

        //  Strip uot the name of the lookup table
        strLookUpTable = FieldName.Substring(0, ((FieldName.ToUpper().IndexOf("_ID") + 1) - 1));

        drResult = Database.GetRow("SELECT * FROM " + strLookUpTable +" WHERE " + FieldName + " = " + FieldValue, this.Page);
        sResult = drResult[1].ToString();

        return(sResult);

    }


</script>

<html>

<head>

	<title>Gestione Parametri</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
  
</head>


<body>

	<div id="TopStripe"></div>
	
	<div id="MainWindow">

	<div id="FormWrap" class="StandardForm"> 
	
<form name="form1" runat="server" method="post" action="lookup_detail.aspx" >

		<!-- *** TITOLO FORM ***  --> 
		<div class="formtitle">Edit Tabella</div> 

		<table class="TabellaLista">
<%
	if (bolRecordFound) // ' at least one record exists	
	{

        intCounter = 0;
		while (intCounter <= aRecord.Rows.Count-1)
		{

			if ((intCounter % 2) == 0)
				Response.Write("<tr class=GV_row>");
			else
				Response.Write("<tr class=GV_row_alt>");

			for (int i = 1; i <= Convert.ToInt32(Session["FieldNumber"].ToString()); i++)
			{
				Response.Write("<td>");

				// if the record is a counter get the description from the associated lookup table
				if (aRecord.Columns[i].ColumnName.IndexOf("_id") > 0)
					Response.Write(GetDescription( aRecord.Columns[i].ColumnName, aRecord.Rows[intCounter][i].ToString() ));
				else
					Response.Write(aRecord.Rows[intCounter][i]);

				Response.Write("</td>");
			}
%>      
	  <td nowrap width="10%"> <div align="center"><a href="lookup_detail.aspx?action=update&Id=<%=aRecord.Rows[intCounter][0]%>"> 
		  <img src="images/icons/16x16/modifica.gif" width="16" height="16" border="0"></a>&nbsp;&nbsp; 
<% 
			DeleteIcon( aRecord.Rows[intCounter][0].ToString() );

			Response.Write("</div></td></tr>");

			intCounter++;
		}

	} // if NOT objRS.EOF Then ' at least one record exists

%>
  </table>
				<div class="buttons">
                    <asp:button type="submit" runat="server" name="insert" Text="Crea" class="orangebutton" />
					<asp:button PostBackUrl="/timereport/menu.aspx"  name="cancel_from_list" runat="server" type="submit" class="greybutton" Text="Annulla"/>
				</div>
</form>


	</div>  <!-- END FormWrap-->

	</div> <!-- END MainWindow -->

	<!-- **** FOOTER **** -->  
	<div id="WindowFooter">
		<div></div>
		<div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
		<div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
		<div id="WindowFooter-R"><asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" /> <%= Session["UserName"]  %></div>
	</div>


</body>

</html>

