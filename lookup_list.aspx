<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Globalization" %>

<!DOCTYPE html>

<!-- Javascript -->
<script src="/timereport/include/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/timereport/include/BTmenu/menukit.js"></script>
<script src="/timereport/include/javascript/timereport.js"></script>

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
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" rel="stylesheet" >
<link href="/timereport/include/newstyle20.css" rel="stylesheet" />

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="shortcut icon" type="image/x-icon" href="/timereport/apple-touch-icon.png" />
    <title>
        <asp:Literal runat="server" Text="Lista valori" /></title>
</head>

<script runat="server">

    string strKeyName;      // name of the key field od the table
    bool bolRecordFound;
    DataTable aRecord;
    int intCounter = 0;

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("CONFIG", "TABLE"); // amministrazione

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];

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

        if (aRecord.Rows.Count > 0)
        {
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

        if (Session["CheckTable"] == null || Session["CheckTable"].ToString() == "")
        {
            Response.Write("<a href=lookup_list.aspx?action=delete&id=" + intIndex + "><img src=images/icons/16x16/trash.gif width=16 height=16 border=0></a>");
            return;
        }
        else
        {

            if (!Database.RecordEsiste("SELECT TOP 1 " + strKeyName + " FROM " + Session["CheckTable"].ToString() + " WHERE " + strKeyName + "='" + intIndex + "'"))
                Response.Write("<a href=lookup_list.aspx?action=delete&id=" + intIndex + "><img src=images/icons/16x16/trash.gif width=16 height=16 border=0></a>");
            else
                Response.Write("<span style='width:16px;'>&nbsp;</span>");
        }
    }

    // ----------------------------------------------------------------------------
    public string GetDescription(string FieldName, string FieldValue)
    // ----------------------------------------------------------------------------
    {
        string strLookUpTable;
        DataRow drResult;
        string sResult = "";

        //  Strip uot the name of the lookup table
        strLookUpTable = FieldName.Substring(0, ((FieldName.ToUpper().IndexOf("_ID") + 1) - 1));

        drResult = Database.GetRow("SELECT * FROM " + strLookUpTable + " WHERE " + FieldName + " = " + FieldValue, this.Page);
        sResult = drResult[1].ToString();

        return (sResult);

    }

</script>

<body>

    <!-- *** APPLICTION MENU *** -->
    <div include-html="/timereport/include/BTmenu/BTmenuInclude<%= CurrentSession.UserLevel %>.html"></div>

    <!-- *** MAINWINDOW *** -->
    <div class="container MainWindowBackground">
        <form id="FVMain" runat="server" method="post" action="lookup_detail.aspx">

            <div class="row justify-content-center" >

                <div id="FormWrap" class="col-6 StandardForm">

                    <!-- *** TITOLO FORM ***  -->
                    <div class="formtitle">Edit Tabella</div>

                    <table  class="TabellaLista">
                        <%
                            if (bolRecordFound) // ' at least one record exists	
                            {

                                intCounter = 0;
                                while (intCounter <= aRecord.Rows.Count - 1)
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
                                            Response.Write(GetDescription(aRecord.Columns[i].ColumnName, aRecord.Rows[intCounter][i].ToString()));
                                        else
                                            Response.Write(aRecord.Rows[intCounter][i]);

                                        Response.Write("</td>");
                                    }
                        %>
                        <td nowrap width="10%" >
                            <div align="center">
                                <a href="lookup_detail.aspx?action=update&Id=<%=aRecord.Rows[intCounter][0]%>">
                                    <img src="images/icons/16x16/modifica.gif" width="16" height="16" border="0"></a>&nbsp;&nbsp; 
                                <% 
                                            DeleteIcon(aRecord.Rows[intCounter][0].ToString());

                                            Response.Write("</div></td></tr>");

                                            intCounter++;
                                        }

                                    } // if NOT objRS.EOF Then ' at least one record exists

                                %>
                    </table>
                    <div class="buttons">
                        <asp:Button type="submit" runat="server" name="insert" Text="Crea" class="orangebutton" />
                        <asp:Button PostBackUrl="/timereport/menu.aspx" name="cancel_from_list" runat="server" type="submit" class="greybutton" Text="Annulla" />
                    </div>

                </div>
                <!-- END FormWrap  -->
            </div>
            <!-- END Row  -->
        </form>
    </div>
    <!-- *** End container *** -->

    <!-- *** FOOTER *** -->
    <div class="container bg-light">
        <footer class="footer mt-auto py-3 bg-light">
            <div class="row">
                <div class="col-md-4" id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
                <div class="col-md-4" id="WindowFooter-C">cutoff: <%= CurrentSession.CutoffDate %></div>
                <div class="col-md-4" id="WindowFooter-R"><%= CurrentSession.UserName  %></div>
            </div>
        </footer>
    </div>

    <!-- *** JAVASCRIPT *** -->
    <script type="text/javascript">

        // include di snippet html per menu and background color mgt
        includeHTML();
        InitPage("<%=CurrentSession.BackgroundColor%>", "<%=CurrentSession.BackgroundImage%>");

    </script>

</body>

</html>

