<%@ Page Language="VB" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<script runat="server">

    '// We iterate through the Form collection and assign the names and values
    '// to ASP.NET session variables! We have another Session Variable, "DestPage"
    '// that tells us where to go after taking care of our business...

    '// inizilizza alcune variabili si sessione


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim i As Integer

        For i = 0 To Request.Form.Count - 1

            Session(Request.Form.GetKey(i)) = Server.UrlDecode(Request.Form(i).ToString)

        Next

        ' inizializza alcune variabili        
        Session("NoActive") = 1
        Session("NoPersActive") = 1

        ' carica variabile di sessione con spese forzate
        ' Carica spese e progetti possibili
        Dim ProgettiForzati As System.Data.DataRowCollection
        Dim SpeseForzate As System.Data.DataRowCollection

        If Session("ForcedAccount") Then
            '** A.1 Carica progetti possibili
            'Right join: includes all the forced projects plus the ones with the flag always_available on							
            ProgettiForzati = ASPcompatility.GetRows("SELECT Projects.Projects_Id, Projects.ProjectCode, Projects.Name,  Projects.Always_available FROM ForcedAccounts RIGHT JOIN Projects ON ForcedAccounts.Projects_id = Projects.Projects_Id WHERE ( ( ForcedAccounts.Persons_id=" & Session("Persons_id") & " OR Projects.Always_available = 1 ) AND Projects.active = 1 )  ORDER BY Projects.ProjectCode")

            '** A.2 Carica spese possibili				

            If Session("ExpensesProfile_id") > 0 Then
                '** A.2.1 Prima verifica se il cliente ha un profilo di spesa	
                SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesProf RIGHT JOIN ExpenseType ON ForcedExpensesProf.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesProf.ExpensesProfile_id=" & Session("ExpensesProfile_id") & " ) ) ORDER BY ExpenseType.ExpenseCode")
            Else
                '** A.2.2 Poi cerca spese specifiche per persona			
                SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType.ExpenseType_Id, ExpenseType.ExpenseCode, ExpenseType.Name FROM ForcedExpensesPers RIGHT JOIN ExpenseType ON ForcedExpensesPers.ExpenseType_Id = ExpenseType.ExpenseType_Id WHERE ( ( ForcedExpensesPers.Persons_id=" & Session("Persons_id") & " ) ) ORDER BY ExpenseType.ExpenseCode")

                '** A.2.2.1 Siamo alla fine, non ha trovato spese forzate sulla persona, a questo punto
                'carica tutto
                If SpeseForzate Is Nothing Then
                    SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType_Id, ExpenseCode, Name FROM ExpenseType WHERE active = 1 ORDER BY ExpenseCode")
                End If
            End If
        Else
            '** B.1 tutti i progetti attivi		
            ProgettiForzati = ASPcompatility.GetRows("SELECT Projects_Id, ProjectCode, Name  FROM Projects WHERE active = 1 ORDER BY ProjectCode")
            '** B.2 tutte le spese attive 							
            SpeseForzate = ASPcompatility.GetRows("SELECT ExpenseType_Id, ExpenseCode, Name  FROM ExpenseType WHERE active=1")
        End If

        Session("ProgettiForzati") = ProgettiForzati
        Session("SpeseForzate") = SpeseForzate

        ' *** Carica datatable con giorni di ferie        
        Dim strSql As String = "SELECT Holiday_date FROM Holiday"
        MyConstants.DTHoliday.Clear()

        Using cnn As New SqlConnection(ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString)
            cnn.Open()
            Using dad As New SqlDataAdapter(strSql, cnn)
                dad.Fill(MyConstants.DTHoliday)
            End Using
            cnn.Close()
        End Using
        MyConstants.DTHoliday.PrimaryKey = New DataColumn() {MyConstants.DTHoliday.Columns("Holiday_date")}
        ' *** Carica datatable con giorni di ferie (FINE)             

        ' *** carica autorizzazioni ***
        Auth.LoadPermission(Session("persons_id"))

        ' *** salva cookie per lingua
        Dim myCookie As HttpCookie = New HttpCookie("lingua")
        myCookie.Value = Session("lingua").ToString()
        myCookie.Expires = DateTime.Now.AddYears(100)
        Response.Cookies.Add(myCookie)

        Response.Redirect("/timereport/menu.aspx")

    End Sub
</script>