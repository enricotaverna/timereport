<%

' ASP Report Maker 1.0 - web site configuration
' Common constants

Const EW_DATE_SEPARATOR = "/"
Const EW_NULL_LABEL = "(Null)"
Const EW_EMPTY_LABEL = "(Empty)"

' Database Configuration
Const EW_DBMSNAME = "Microsoft SQL Server"
Const EW_DB_START_QUOTE = "["
Const EW_DB_END_QUOTE = "]"
Const EW_CURSOR_LOCATION = 3
'Dim EW_CONNECTION_STRING = "Provider=SQLOLEDB;Persist Security Info=False;Data Source=62.149.153.12;Initial Catalog=MSSql12155;User Id=MSSql12155;Password=50a715f9"
Dim EW_CONNECTION_STRING = "Provider=SQLOLEDB;Persist Security Info=False;Data Source=95.110.230.190;Initial Catalog=MSSql12155;User Id=MSSql12155;Password=50a715f9"

' Project Level Configuration
Const EW_PROJECT_NAME = "timereport" ' Project Name
Const EW_PROJECT_VAR = "timereport" ' Project Var

' Session names
Dim EW_SESSION_STATUS: EW_SESSION_STATUS = EW_PROJECT_VAR & "_status" ' Login Status
Dim EW_SESSION_USERNAME:  EW_SESSION_USERNAME = EW_SESSION_STATUS & "_UserName" ' User Name
Dim EW_SESSION_USERID: EW_SESSION_USERID = EW_SESSION_STATUS & "_UserID" ' User ID
Dim EW_SESSION_USERLEVEL: EW_SESSION_USERLEVEL = EW_SESSION_STATUS & "_UserLevel" ' User Level
Dim EW_SESSION_PARENT_USERID: EW_SESSION_PARENT_USERID = EW_SESSION_STATUS & "_ParentUserID" ' Parent User ID
Dim EW_SESSION_SYSTEM_ADMIN: EW_SESSION_SYSTEM_ADMIN = EW_PROJECT_VAR & "_SysAdmin" ' System Admin
Dim EW_SESSION_MESSAGE: EW_SESSION_MESSAGE = EW_PROJECT_VAR & "_Message" ' System Message

' Hard code admin
Const EW_ADMIN_USERNAME = ""
Const EW_ADMIN_PASSWORD = ""

' User admin
Const EW_USERNAME_FIELD = ""
Const EW_PASSWORD_FIELD = ""
Const EW_USERID_FIELD = ""
Const EW_PARENT_USERID_FIELD = ""
Const EW_USERLEVEL_ARRAY_FIELD = ""
Dim EW_LOGIN_SELECT_SQL
EW_LOGIN_SELECT_SQL = ""

' salva stringa che compone la clausola where
If request.querystring("whereclause") <> "" then
    session("whereclause") = request.querystring("whereclause")
End If

%>
