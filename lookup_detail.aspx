<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Globalization" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- Stili -->
<link href="/timereport/include/newstyle.css" rel="stylesheet" /> 
<link href="/timereport/include/standard/uploader/uploader.css" rel="stylesheet"  />

<!-- Menù  -->
<SCRIPT language=JavaScript src= "/timereport/include/menu/menu_array.js" id="IncludeMenu" Lingua=<%= Session["lingua"]%>  UserLevel=<%= Session["userLevel"]%> type =text/javascript></SCRIPT>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript"></script>

<!-- Jquery per date picker  -->
<link rel="stylesheet" href="/timereport/include/jquery/jquery-ui.min.css" />
<script src="include/jquery/jquery-1.9.0.min.js"></script> 
<script src="/timereport/include/parsley/parsley.min.js"></script>
<script src="/timereport/include/parsley/it.js"></script>
<script type="text/javascript" src="/timereport/include/jquery/jquery.ui.datepicker-it.js"></script>
<script src="/timereport/include/jquery/jquery-ui.min.js"></script>

<script runat="server">

    const int cName = 0;
    const int cLenght = 2;
    const int cIsIdentity = 17;
    const int cDataType = 24;
    const int cIsNullable = 13;

    public string strMode;
    //public DataRow drRecord;
    public DataRow fld;
    public DataTable dtRecord;
    DataTable dtSchema = null;
    string flagnbh;
    int iIndex;

    // ******************
    protected void Page_Load(object sender, EventArgs e)
    {

        if ( Session["TableName"].ToString().Substring(0,2) == "HR" )
                Auth.CheckPermission("TRAINING", "CREATE");  // Coordinatore Trainer
        else
                Auth.CheckPermission("CONFIG", "TABLE"); // amministrazione

        // recupera la struttura della tabella
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MSSql12155ConnectionString"].ConnectionString);
        using (con)
        {
            using (var schemaCommand = new SqlCommand("SELECT * FROM " + Session["TableName"], con))
            {
                con.Open();
                using (var reader = schemaCommand.ExecuteReader(CommandBehavior.SchemaOnly))
                    dtSchema = reader.GetSchemaTable();
            }
        }

        //     Pagina richiamata dalla lista: verifica con quale modalit&#65533; la pagina &#65533; stata chiamata 
        if (!IsPostBack)
            if (Request["action"] == "update")
            {
                // dtSchema.Rows[0][0].ToString() -> chiave della tabella
                dtRecord = Database.GetData("SELECT * FROM " + Session["TableName"] + " WHERE " + dtSchema.Rows[0][0].ToString() + " = '" + Request["id"].ToString() + "'", this.Page);
                Session[strMode] = strMode = "update";
            }
            else
                Session[strMode] = strMode = "insert";
        else
            strMode = Session[strMode].ToString();

    }

    // ****************
    string formattaValue(string sDataType, string sValue)
    {
        string sRet = "";

        switch (sDataType)
        {
            case "nvarchar":
            case "nchar":
                sRet = ASPcompatility.FormatStringDb(sValue);
                break;

            case "bit":
                if (sValue != null)
                    sRet = "'true'";
                else
                    sRet = "'false'";
                break;

            case "int":
            case "float":
            case "smallmoney":
                if ( sValue!= "")
                    sRet = ASPcompatility.FormatNumberDB(Convert.ToDouble(sValue));
                else
                    sRet = "''";
                break;

            case "smalldatetime":
            case "datetime":
                if (sValue != "")
                    sRet = ASPcompatility.FormatDateDb(sValue);
                else
                    sRet = "''";
                break;
        }

        return (sRet);
    }

    // ****************
    string strDefault(string strFieldType)
    {
        string sResult = "";

        if (strMode == "update")
        {

            if (strFieldType != "smalldatetime" && strFieldType != "datetime")
                sResult = dtRecord.Rows[0][iIndex].ToString().TrimEnd(' ');
            else
                sResult = dtRecord.Rows[0][iIndex].ToString().Substring(0, 10);
        }

        if (strMode == "insert")
            if (strFieldType != "bit")
                sResult = "";
            else
                sResult = "false";

        return (sResult);
    }

    // ****************
    string GetDescription(string FieldName, string FieldValue)
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

    // ****************
    protected void btCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("/timereport/lookup_list.aspx?tablename=" + Session["TableName"]);
    }

    // ****************
    protected void btSave_Click(object sender, EventArgs e)
    {

        string sSQL;

        switch (strMode)
        {
            case "update":

                sSQL = "UPDATE " + Session["TableName"] + " SET ";

                iIndex = 0;

                foreach (DataRow fld in dtSchema.Rows)
                {
                    if (iIndex > 0)
                    {
                        // nomecampo = valore,  
                        sSQL = sSQL + fld[cName].ToString() + " = " + formattaValue(fld[cDataType].ToString(), Request[fld[cName].ToString()]) + ", ";
                    }
                    iIndex++;
                }

                // toglie ultima virgola
                sSQL = sSQL.Substring(0, sSQL.Length - 2);
                string sFieldName = dtSchema.Rows[0][cName].ToString();
                sSQL = sSQL + " WHERE " + sFieldName + " = " + ASPcompatility.FormatStringDb(Request["id"].ToString()); // da campo hidden

                Database.ExecuteSQL(sSQL, this.Page);

                Response.Redirect("lookup_list.aspx?TableName=" + Session["TableName"]);

                break;

            case "insert":

                string sField = "( ";
                string sValue = "( ";

                iIndex = 0;
                foreach (DataRow fld in dtSchema.Rows)
                {
                    if (iIndex > 0)
                    {
                        sField = sField + fld[cName].ToString() + ", ";
                        sValue = sValue + formattaValue(fld[cDataType].ToString(), Request[fld[cName].ToString()]) + ", ";
                    }
                    iIndex++;
                }

                sField = sField.Substring(0, sField.Length - 2) + " )"; // toglie l'ultima virgola
                sValue = sValue.Substring(0, sValue.Length - 2) + " )";
                sSQL = "INSERT INTO " + Session["TableName"] + " " + sField + " VALUES " + sValue;

                Database.ExecuteSQL(sSQL, this.Page);

                Response.Redirect("lookup_list.aspx?TableName=" + Session["TableName"]);

                break;
        }

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

            <form id="formTab" runat="server" method="post" action="lookup_detail.aspx" >

                <!-- *** TITOLO FORM ***  -->
                <div class="formtitle">Edit Form</div>

                <% 
                    string sValue, flagnbh;
                    string sMandatory;
                    iIndex = 0;

                    foreach (DataRow fld in dtSchema.Rows)
                    {

                        // tipo campo, valore campo
                        sValue = strDefault(fld[cDataType].ToString());

                        if (iIndex > 0) // non è la chiave
                        {
                %>

                <!-- *** TEXT BOX ***  -->
                <div class="input nobottomborder">

                    <div class="inputtext"><%=fld[cName]%></div>

                    <% 

                                // Analizza il tipo di campo e genera il controllo corrispondente            	
                                switch (fld[cDataType].ToString()) // DataType
                                {
                                    //case "System.String":  // memo

                                    //    Response.Write("<div class=inputcontent><textarea class=Inputcontent cols=72 rows=5 name=" + fld[0].ToString() + ">" + sValue + "</textarea></div>");
                                    //    break;

                                    case "bit": //  booleano

                                        Response.Write("<input type=checkbox name=" + fld[cName]);

                                        // Changed sValue to rs(fld.name) which may cause incorrect display when
                                        if (sValue == "True")
                                            Response.Write(" checked></div>");
                                        else
                                            Response.Write("></div>");
                                        break;

                                    case "int":
                                    case "float":
                                    case "smallmoney":
                                        if (fld[cIsNullable].ToString() == "True")
                                            sMandatory = "";
                                        else
                                            sMandatory = " data-parsley-errors-container='#valMsg' data-parsley-required='true' ";


                                        if (fld[cName].ToString().IndexOf("_Id") > 0 || fld[cName].ToString().IndexOf("_id") > 0)
                                        {
                                            Response.Write("<label class=dropdown style=width:200px><select name=" + fld[cName].ToString() + sMandatory + " >");
                                            Response.Write("<option value='0'> nessun valore </option>");

                                            string strLookUpTable = fld[cName].ToString().Substring(0, fld[cName].ToString().Length - 3);

                                            if (strLookUpTable == "Course" || strLookUpTable == "CourseType" || strLookUpTable == "Product" || strLookUpTable == "CourseVendor")
                                                strLookUpTable = "HR_" + strLookUpTable;


                                            DataTable dtLookup = Database.GetData("SELECT * FROM " + strLookUpTable, this.Page);

                                            foreach (DataRow drRow in dtLookup.Rows)
                                            {

                                                if (strMode == "update" && dtRecord.Rows[0][iIndex].ToString() == drRow[0].ToString())
                                                    flagnbh = "selected";
                                                else
                                                    flagnbh = "";

                                                Response.Write("<option value=" + drRow[0].ToString() + " " + flagnbh + ">" + drRow[1].ToString() + "</option>");
                                            }
                                            Response.Write("</select></label> </div>");
                                        }
                                        else
                                            Response.Write("<div class=inputcontent><input size=70  type=text name=" + fld[cName] + " value=" + sValue + sMandatory + "></div> </div>");
                                        break;

                                    case "smalldatetime":
                                    case "datetime":
                                        if (fld[cIsNullable].ToString() == "True")
                                            sMandatory = "";
                                        else
                                            sMandatory = " data-parsley-errors-container='#valMsg' data-parsley-required='true' ";

                                        Response.Write("<div class='inputcontent' ><input class = 'datepicker' style='width:120px' type=text name=" + fld[cName].ToString() + " value='" + sValue + "' maxlength=10 " + sMandatory + "></div> </div>");
                                        break;

                                    case "nvarchar":
                                    case "nchar":
                                        if (fld[cIsNullable].ToString() == "True")
                                            sMandatory = "";
                                        else
                                            sMandatory = " data-parsley-errors-container='#valMsg' data-parsley-required='true' ";

                                        Response.Write("<div class=inputcontent><input size=" + fld[cLenght].ToString() + " type=text name=" + fld[cName].ToString() + " value='" + sValue + "' maxlength=" + fld[cLenght].ToString() +  sMandatory + "></div> </div>");
                                        break;
                                }

                            }
                            else // IsIdentity
                            {
                                if (strMode == "update")
                                    Response.Write("<input type=hidden name=id value=" + sValue + " />");
                            }

                            iIndex++;
                        }
                    %>

                    <div class="buttons" id="valMsg">
                        <asp:Button ID="btSave" runat='server' type='submit' name='save' Text='Salva' class='orangebutton' OnClick="btSave_Click" />
                        <asp:Button ID="btCancel" runat="server" type="submit" name="cancel" Text="Annulla" class="greybutton" OnClick="btCancel_Click" formnovalidate=""  />
                    </div>
            </form>

        </div>
        <!-- END FormWrap-->

    </div>
    <!-- END MainWindow -->

    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div></div>
        <div id="WindowFooter-L">Aeonvis Spa <%= DateTime.Now.Year %></div>
        <div id="WindowFooter-C">cutoff: <%=Session["CutoffDate"]%>  </div>
        <div id="WindowFooter-R">
            <asp:Literal runat="server" Text="<%$ Resources:timereport, Utente %>" />
            <%= Session["UserName"]  %></div>
    </div>

</body>

<script>
        
	$(function () {

		$(".datepicker").datepicker($.datepicker.regional['it']);

        $('#formTab').parsley({
            excluded: "input[type=button], input[type=submit], input[type=reset], [disabled]"
        });


	});

</script>


</html>

