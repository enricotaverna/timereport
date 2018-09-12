Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Web.Configuration
Imports System.Web
Imports System.Collections
Imports System.Web.UI.WebControls
Imports System.Collections.Generic
Imports System.IO
Imports System.Windows.Forms
Imports System.Globalization
Imports System.Threading

Public Class ValidationClass

    Public Function CheckExistence(ByVal sKey As String, ByVal sValkey As String, ByVal sTable As String) As Boolean

        '   verifica che il codice cliente non sia già stato creato
        Dim connStr As String
        Dim query As String
        Dim conn As SqlConnection
        Dim Adapter As SqlDataAdapter
        Dim ds As DataSet

        CheckExistence = False

        connStr = ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString
        conn = New SqlConnection(connStr)

        query = "SELECT * FROM " & sTable & " WHERE " & sKey & "='" & sValkey & "'"

        Adapter = New SqlDataAdapter(query, conn)

        ds = New DataSet()
        Adapter.Fill(ds)

        If ds.Tables(0).Rows.Count = 0 Then
            CheckExistence = False
        Else
            CheckExistence = True
        End If
    End Function

    Public Sub SetErrorOnField(ByVal bArgs As Boolean, ByVal objForm As FormView, ByVal sFieldName As String)

        'Dim TBcontrol As TextBox = objForm.FindControl(sFieldName)
        Dim GenericControl As System.Web.UI.Control = objForm.FindControl(sFieldName)

        If bArgs <> True Then ' Errore

            Select Case (GenericControl.GetType.ToString())

                Case "System.Web.UI.WebControls.TextBox"
                    Dim TB As System.Web.UI.WebControls.TextBox = GenericControl
                    TB.Style("background-Color") = "#FFFFD5"
                    TB.Style("border-Color") = "#FF5353"

                Case "System.Web.UI.WebControls.DropDownList"
                    Dim DDL As DropDownList = GenericControl
                    DDL.Style("background-Color") = "#FFFFD5"
                    DDL.Style("border-Color") = "#FF5353"

            End Select

        Else ' spegne errore

            Select Case (GenericControl.GetType.ToString())

                Case "System.Web.UI.WebControls.TextBox"
                    Dim TB As System.Web.UI.WebControls.TextBox = GenericControl
                    TB.Style("background-Color") = "#FFF"
                    TB.Style("border-Color") = "#C7C7C7"

                Case "System.Web.UI.WebControls.DropDownList"
                    Dim DDL As DropDownList = GenericControl
                    DDL.Style("background-Color") = "#FFF"
                    DDL.Style("border-Color") = "#C7C7C7"

            End Select

        End If

    End Sub

End Class

Public Class Auth

    Public Shared Sub LoadPermission(persons_id As String)

        ' Carica le permissione dell'utente in una tabella e la memorizza in una variabile di sessione
        Dim AuthPermission As DataRowCollection

        AuthPermission = ASPcompatility.GetRows(" SELECT c.AuthTask, c.AuthActivity from Persons as a " +
                                                " INNER JOIN AuthPermission as b ON b.UserLevel_id = a.UserLevel_id " +
                                                " INNER JOIN AuthActivity as c ON c.AuthActivity_id = b.AuthActivity_id " +
                                                " WHERE a.persons_id = '" & persons_id & "'")

        HttpContext.Current.Session("AuthPermission") = AuthPermission

    End Sub

    ' Verifica permission caricate rispetto all'attività chiesta 
    Public Shared Function CheckPermission(Task As String, Actvity As String) As Boolean

        Dim aAuthPermission As System.Data.DataRowCollection
        Dim f As Integer

        ' sessione scaduta
        If HttpContext.Current.Session("persons_id") Is Nothing Then
            HttpContext.Current.Response.Redirect("/timereport/default.aspx")
        End If

        ' carica da memoria
        aAuthPermission = HttpContext.Current.Session("AuthPermission")

        ' Se vuota carica permission
        If aAuthPermission Is Nothing Then
            ' Messaggio di errore
            HttpContext.Current.Response.Redirect("/timereport/menu.aspx?msgtype=E&msgno=" & System.Configuration.ConfigurationManager.AppSettings("MSGNO_AUTHORIZATION_FAILED"))
        End If

        For f = 0 To (aAuthPermission.Count - 1)
            If (aAuthPermission.Item(f).Item(0).ToString.Trim = Task.Trim And
                aAuthPermission.Item(f).Item(1).ToString.Trim = Actvity.Trim) Then
                Return True
            End If
        Next

        ' Messaggio di errore
        HttpContext.Current.Response.Redirect("/timereport/menu.aspx?msgtype=E&msgno=" & System.Configuration.ConfigurationManager.AppSettings("MSGNO_AUTHORIZATION_FAILED"))

        Return False

    End Function

    ' Verifica permission caricate rispetto all'attività chiesta 
    Public Shared Function ReturnPermission(Task As String, Actvity As String) As Boolean

        Dim aAuthPermission As System.Data.DataRowCollection
        Dim f As Integer

        ' carica da memoria
        aAuthPermission = HttpContext.Current.Session("AuthPermission")

        ' Se vuota carica permission
        If aAuthPermission Is Nothing Then
        End If

        For f = 0 To (aAuthPermission.Count - 1)
            If (aAuthPermission.Item(f).Item(0).ToString.Trim = Task.Trim And
                aAuthPermission.Item(f).Item(1).ToString.Trim = Actvity.Trim) Then
                Return True
            End If
        Next

        Return False

    End Function

End Class


Public Class Utilities

    Public Shared Sub CheckAut(ByVal PageLevel As Integer)

        '          sessione scaduta
        If HttpContext.Current.Session("userLevel") Is Nothing Then
            HttpContext.Current.Response.Redirect("/timereport/default.aspx")
        End If

        '          Mancato auth
        If Int32.Parse(HttpContext.Current.Session("userLevel")) < PageLevel Then

            HttpContext.Current.Response.Redirect("/timereport/menu.aspx?msgtype=E&msgno=" & System.Configuration.ConfigurationManager.AppSettings("MSGNO_AUTHORIZATION_FAILED"))

        End If

    End Sub

    Public Shared Sub CheckAutMobile(ByVal PageLevel As Integer)

        '          sessione scaduta
        If HttpContext.Current.Session("userLevel") Is Nothing Then
            HttpContext.Current.Response.Redirect("/timereport/mobile/login.aspx")
        End If

        '          Mancato auth
        If Int32.Parse(HttpContext.Current.Session("userLevel")) < PageLevel Then
            HttpContext.Current.Response.Redirect("/timereport/mobile/login.aspx")
        End If

    End Sub

    Public Shared Sub CreateMessageAlert(ByRef aspxPage As System.Web.UI.Page,
                         ByVal strMessage As String, ByVal strKey As String)

        Dim strScript As String = "<script language=JavaScript>alert('" _
                                            & strMessage & "')</script>"

        If (Not aspxPage.IsStartupScriptRegistered(strKey)) Then
            aspxPage.RegisterStartupScript(strKey, strScript)
        End If

    End Sub

    Public Shared Sub EsportaDataSetExcel(ds As DataSet)

        '/* prende dataset ed espora in excel */

        Dim GridExp As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()

        GridExp.DataSource = ds.Tables("export").DefaultView
        GridExp.DataBind()

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=Export.xls")
        HttpContext.Current.Response.Charset = ""

        '// If you want the option to open the Excel file without saving then
        '// comment out the line below
        HttpContext.Current.Response.ContentType = "application/vnd.xls"
        '//create a string writer
        Dim stringWrite As System.IO.StringWriter = New StringWriter()

        '//create an htmltextwriter which uses the stringwriter
        Dim htmlWrite As System.Web.UI.Html32TextWriter = New Html32TextWriter(stringWrite)

        GridExp.RenderControl(htmlWrite)

        HttpContext.Current.Response.Write(stringWrite.ToString())

        HttpContext.Current.Response.End()

    End Sub

    Public Shared Sub ExportXls(ByVal sQuery As String)

        '   verifica che il codice cliente non sia già stato creato
        Dim conn As SqlConnection
        Dim Adapter As SqlDataAdapter
        Dim ds As DataSet = New DataSet
        Dim GridExp As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid

        conn = New SqlConnection(ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString)

        Adapter = New SqlDataAdapter(sQuery, conn)
        Adapter.Fill(ds, "export")

        GridExp.DataSource = ds.Tables("export").DefaultView
        GridExp.DataBind()

        HttpContext.Current.Response.Clear()
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=Export.xls")
        HttpContext.Current.Response.Charset = ""

        '  // If you want the option to open the Excel file without saving then
        '  // comment out the line below
        '  // Response.Cache.SetCacheability(HttpCacheability.NoCache);
        HttpContext.Current.Response.ContentType = "application/vnd.xls"
        'create a string writer
        Dim stringWrite As New System.IO.StringWriter
        'create an htmltextwriter which uses the stringwriter
        Dim htmlWrite As New System.Web.UI.HtmlTextWriter(stringWrite)

        GridExp.RenderControl(htmlWrite)

        HttpContext.Current.Response.Write(stringWrite.ToString)
        HttpContext.Current.Response.End()

    End Sub

    Public Shared Function CheckboxListSelections(ByVal list As System.Web.UI.WebControls.CheckBoxList) As String

        Dim values As ArrayList = New ArrayList
        Dim counter As Integer
        CheckboxListSelections = ""

        counter = 0
        While counter < list.Items.Count

            If list.Items(counter).Selected Then
                CheckboxListSelections = CheckboxListSelections & IIf(CheckboxListSelections = "", ASPcompatility.FormatStringDb(list.Items(counter).Value), ", " & ASPcompatility.FormatStringDb(list.Items(counter).Value))
            End If

            counter = counter + 1

        End While

    End Function

    Public Shared Function ListSelections(ByVal list As System.Web.UI.WebControls.ListBox, Optional all As Boolean = False) As String

        ' restituisce elementi all'interno di una lista

        Dim values As ArrayList = New ArrayList
        Dim counter As Integer
        ListSelections = ""

        counter = 0
        While counter < list.Items.Count

            If (list.Items(counter).Selected Or all) Then
                ListSelections = ListSelections & IIf(ListSelections = "", ASPcompatility.FormatStringDb(list.Items(counter).Value), ", " & ASPcompatility.FormatStringDb(list.Items(counter).Value))
            End If

            counter = counter + 1

        End While

    End Function

    Public Shared Function ListDDL(ByVal DDLList As System.Web.UI.WebControls.DropDownList, Optional all As Boolean = False) As String

        ' restituisce elementi <> 0 all'interno di una lista

        Dim values As ArrayList = New ArrayList
        Dim counter As Integer
        Dim sDDLval As String
        ListDDL = ""

        counter = 0
        While counter < DDLList.Items.Count

            sDDLval = DDLList.Items(counter).Value

            If ((DDLList.Items(counter).Selected Or all) And sDDLval <> "0" And sDDLval <> "") Then
                ListDDL = ListDDL & IIf(ListDDL = "", sDDLval, "," & sDDLval)
            End If

            counter = counter + 1

        End While

    End Function

    Public Shared Function GetCutoffDate(strPeriod As String, strMonth As String, strYear As String, strType As String) As String

        ' calc the cutoff date based on the input parameter
        If strPeriod = "1" Then
            If strType = "end" Then
                GetCutoffDate = CDate("15/" & strMonth & "/" & strYear)
            Else
                GetCutoffDate = CDate("1/" & strMonth & "/" & strYear)
            End If
        Else
            If strType = "end" Then
                GetCutoffDate = CDate(DateSerial(strYear, strMonth + 1, 0))
            Else
                GetCutoffDate = CDate("16" & "/" & strMonth & "/" & strYear)
            End If
        End If

        Return GetCutoffDate

    End Function

End Class

Public Class CommonFunction

    ' Classe per definire paramentri di output della procedura CalcolaPercOre
    Public Class CalcolaPercOutput
        Public dOreLavorative As Double
        Public dOreCaricate As Double
        Public sPerc As String
    End Class

    Public Shared Function GetAuthor(ByVal Persons_id As Integer, ByVal ldate As Date) As String

        Dim connStr As String
        connStr = ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString

        Dim conn As SqlConnection
        conn = New SqlConnection(connStr)

        Dim cmd As SqlCommand = New SqlCommand("SELECT Name from Persons where Persons_id = " & Persons_id, conn)

        conn.Open()

        Dim dr As SqlDataReader = cmd.ExecuteReader()
        dr.Read()

        If dr.HasRows Then
            GetAuthor = dr("Name") & " " & String.Format("{0:d/M/yyyy HH:mm}", ldate)
        Else
            Return ""
        End If

    End Function

    Public Shared Function CalcolaPercOre(Persons_id As Integer, iMese As Integer, iAnno As Integer) As CalcolaPercOutput

        Dim ret = New CalcolaPercOutput
        Dim sFromDate As String = ASPcompatility.FormatDateDb("1/" & iMese.ToString & "/" & iAnno.ToString)
        Dim sToDate As String = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(iAnno, iMese) & "/" & iMese.ToString & "/" & iAnno.ToString)

        Dim objCon = New SqlConnection()
        objCon.ConnectionString = ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString.ToString()
        objCon.Open()

        Dim objCommand = New SqlCommand
        objCommand.Connection = objCon
        objCommand.CommandText = "SELECT SUM(hours) as somma FROM Hours WHERE Persons_id = " & Persons_id & " AND Date >= " & sFromDate & " AND Date <= " & sToDate

        ' ** Calcola Ore caricate per il mese
        Dim oRes As Object = objCommand.ExecuteScalar()
        Dim iContaOre As Double = IIf(IsDBNull(oRes), 0, oRes)

        Dim iOreLavorative As Integer = 0
        Dim f As Integer
        Dim sDate As String

        For f = 1 To System.DateTime.DaysInMonth(iAnno, iMese)
            sDate = f & "/" & iMese & "/" & iAnno.ToString
            If Weekday(CDate(sDate)) <> 1 And Weekday(CDate(sDate)) <> 7 Then
                iOreLavorative = iOreLavorative + 1
            End If
        Next

        iOreLavorative = iOreLavorative * 8

        ret.dOreLavorative = iOreLavorative
        ret.dOreCaricate = iContaOre
        If iOreLavorative <> 0 Then
            ret.sPerc = ((iContaOre / iOreLavorative) * 100).ToString("N0")
        Else
            ret.sPerc = "0"
        End If

        objCon.Close()

        Return ret

    End Function

    Public Shared Function NumeroGiorniLavorativi(startdate As Date, enddate As Date) As Integer

        Dim days = (enddate - startdate).Days + 1

        Return workDaysInFullWeeks(days) + workDaysInPartialWeek(startdate.DayOfWeek, days)

    End Function

    Public Shared Function workDaysInFullWeeks(totalDays As Integer) As Integer

        Return (totalDays / 7) * 5

    End Function

    Public Shared Function workDaysInPartialWeek(firstDay As DayOfWeek, totalDays As Integer) As Integer

        Dim remainingDays = totalDays Mod 7
        Dim daysToSaturday = DayOfWeek.Saturday - firstDay

        If remainingDays <= daysToSaturday Then
            Return remainingDays
        End If

        '* daysToSaturday are the days before the weekend,
        '* the rest of the expression computes the days remaining after we
        '* ignore Saturday and Sunday
        '*/
        '// Range ends in a Saturday or in a Sunday
        If remainingDays <= daysToSaturday + 2 Then
            Return daysToSaturday
            '// Range ends after a Sunday
        Else
            Return (remainingDays - 2)
        End If
    End Function

    Public Shared Sub CreaFestiviAutomatici(Persons_id As Int16)
        ' Richiamata con o senza identificativo della persona
        ' Crea i festivi automatici a partire dalla data corrente leggendo la tabella Holiday
        ' Se Persons_id = 0 o null vengono creati per tutte le persone attive
        Dim SQLString As String

        If Persons_id <> 0 And Persons_id <> Nothing Then
            SQLString = "SELECT Persons_id from Persons where Persons_id = " & Persons_id.ToString()
        Else
            SQLString = "SELECT Persons_id from Persons where active = 1 "
        End If

        ' 1' step: cancella tutti i festivi automatici (solo quelli dal giorno attuale in avanti !!!)
        Dim dtPersons As DataTable = Database.GetData(SQLString, Nothing)

        For Each rdr In dtPersons.Rows
            ' cancella i record creati automaticamente con data >= data attuale
            SQLString = "DELETE FROM hours WHERE FestivoAutomatico = 1 AND Persons_id = " & rdr("Persons_id") & " AND Date >= " &
                        ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy"))
            Database.ExecuteSQL(SQLString, Nothing)
        Next

        ' 2' step: crea i carichi automatici

        ' Join tra persone attive e date giorni festivi >= data odierna
        If Persons_id <> 0 And Persons_id <> Nothing Then
            SQLString = "SELECT Persons_id, holiday_date from Persons, Holiday where persons.Persons_id = " & Persons_id.ToString() &
                        " AND Holiday.holiday_date >= " & ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy"))
        Else
            SQLString = "SELECT Persons_id, holiday_date from Persons, Holiday where persons.active = 1 AND Holiday.holiday_date >= " & ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"))
        End If

        dtPersons.Clear()
        dtPersons = Database.GetData(SQLString, Nothing)

        For Each rdr In dtPersons.Rows
            ' cancella i record creati automaticamente con data >= data attuale
            ' cancella i record creati automaticamente con data >= data attuale
            Database.ExecuteSQL("INSERT INTO hours (date, projects_id, persons_id, hours, hourType_id, CancelFlag, TransferFlag, Activity_id, AccountingDate, comment, createdBy, creationDate, FestivoAutomatico) VALUES(" +
                                             ASPcompatility.FormatDateDb(rdr("holiday_date"), False) & " , " &
                                             ASPcompatility.FormatStringDb(ConfigurationManager.AppSettings("FESTIVI_PROJECT")) & " , " &
                                             ASPcompatility.FormatStringDb(rdr("Persons_id").ToString()) & " , " &
                                             ASPcompatility.FormatNumberDB("8") & " , " &
                                             ASPcompatility.FormatStringDb("1") + " , " +
                                             " '0'  , " &
                                             " null  , " &
                                             " null  , " &
                                             " null , " &
                                             " null  , " &
                                             ASPcompatility.FormatStringDb(HttpContext.Current.Session("UserId").ToString()) & " , " &
                                             ASPcompatility.FormatDateDb(DateTime.Now.ToString("dd/MM/yyyy HH.mm.ss"), True) &
                                             "'1'" &
                                             " )", Nothing)
        Next

    End Sub

    Public Shared Function GetCulture() As CultureInfo

        ' PROVATA IN SOSTITUZIONE DI GLOBAL.ASAX    

        GetCulture = New CultureInfo("it")

        Try
            ' recupera lingua da cookie, le sessioni non sono valorizzate qui
            Dim cCookie As HttpCookie = HttpContext.Current.Request.Cookies.Get("lingua")

            If Not cCookie Is Nothing And cCookie.Value = "en" Then
                GetCulture = New CultureInfo("en")
            End If

        Catch

        End Try

        Return GetCulture

    End Function

End Class

Public Class CheckChiusura

    ' Classe per definire paramentri di output delle procedure di check Anomalie TR
    Public Class CheckAnomalia

        Public Tipo As String
        Public Data As Date
        Public Descrizione As String
        Public ExpenseCode As String
        Public ProjectCode As String
        Public Amount As Double
        Public UnitOfMeasure As String

    End Class

    Public Shared Function CheckTicket(sMese As String, ByVal sAnno As String, ByVal persons_id As String, ByRef ListaAnomalie As List(Of CheckAnomalia)) As Int16
        ' Funzione ritorna
        ' 0 = nessun problema
        ' 1 = warning
        ' 2 = errore
        ' La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia

        Dim f As Integer
        Dim sDate As String
        Dim drRow As DataRow()

        CheckTicket = 0
        ListaAnomalie.Clear()

        Dim dFirst As String = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, "0") + "/" + sAnno)
        Dim dLast As String = ASPcompatility.FormatDateDb(Date.DaysInMonth(sAnno, sMese).ToString + "/" + sMese + "/" + sAnno)

        ' carica ticket caricati nel mese
        Dim dtTicket As DataTable = Database.GetData("Select FORMAT(date,'dd/MM/yyyy') as date from Expenses where persons_id=" + persons_id + " AND TipoBonus_id<>'0' AND date >= " + dFirst + " AND date <= " + dLast, Nothing)

        ' cicla sui giorni del mese
        For f = 1 To System.DateTime.DaysInMonth(sAnno, sMese)
            sDate = f & "/" & sMese.PadLeft(2, "0") & "/" & sAnno

            ' giorno lavorativo

            If Weekday(CDate(sDate)) <> 1 And Weekday(CDate(sDate)) <> 7 Then

                ' controlla che non sia festivo
                If Not MyConstants.DTHoliday.Rows.Contains(sDate) Then

                    ' controlla che sia caricato un ticket
                    drRow = Nothing
                    drRow = dtTicket.Select("date = '" + sDate + "'")

                    If drRow.Count = 0 Then

                        ' Alza anomalia e carica lista
                        CheckTicket = 1

                        Dim a As CheckAnomalia = New CheckAnomalia()
                        a.Data = sDate
                        a.Tipo = "M"
                        a.Descrizione = "Ticket o rimborso assente"

                        ListaAnomalie.Add(a)

                    End If

                End If

            End If

        Next

    End Function

    Public Shared Function CheckSpese(sMese As String, ByVal sAnno As String, ByVal persons_id As String, ByRef ListaAnomalie As List(Of CheckAnomalia)) As Int16
        ' Funzione ritorna
        ' 0 = nessun problema
        ' 1 = warning
        ' 2 = errore
        ' La lista di oggetti contiene le anomalie secondo la struttura della class CheckAnomalia        

        ListaAnomalie.Clear()

        Dim dFirst As String = ASPcompatility.FormatDateDb("01/" + sMese.PadLeft(2, "0") + "/" + sAnno)
        Dim dLast As String = ASPcompatility.FormatDateDb(Date.DaysInMonth(sAnno, sMese).ToString + "/" + sMese + "/" + sAnno)

        ' carica spese nel mese della persona per il controllo
        Dim dtProgettiMese As DataTable = Database.GetData("Select FORMAT(date,'dd/MM/yyyy') as date, Projects_id from Hours WHERE Persons_id=" + persons_id + " AND date >= " + dFirst + " AND date <= " + dLast, Nothing)

        ' seleziona tutte le spese del mese, considera le spese standard e i rimborsi trasferta
        Dim dt As DataTable = Database.GetData("SELECT a.Projects_id, Amount, date, b.ProjectCode, c.ExpenseCode, c.UnitOfMeasure FROM Expenses As a " +
                                               " JOIN Projects As b On b.Projects_id  = a.Projects_id " +
                                               " JOIN ExpenseType As c On c.ExpenseType_id  = a.ExpenseType_Id " +
                                               " WHERE ( a.TipoBonus_Id = 0 Or a.TipoBonus_Id = 1 ) And Persons_id=" + persons_id + " And Date >= " + dFirst + " And Date <= " + dLast + " ORDER BY date", Nothing)

        ' se non ci sono stati carichi esce con errore
        If dtProgettiMese.Rows.Count = 0 Then
            Return (1)
        End If

        Dim rs As DataRow
        Dim drRows As DataRow()
        Dim sdata As String

        If (dt IsNot Nothing) And dt.Rows.Count > 0 Then

            ' cicla sulla spese del mese
            For Each rs In dt.Rows

                sdata = String.Format("{0:dd/MM/yyyy}", rs("date"))

                ' verifica se esistono ore caricate per lo stesso progetto

                drRows = Nothing
                drRows = dtProgettiMese.Select("date = '" + sdata + "' AND Projects_id = " + rs("Projects_id").ToString)

                If drRows.Count = 0 Then
                    Dim a As CheckAnomalia = New CheckAnomalia()
                    a.Data = rs("date")
                    a.Tipo = "M"
                    a.Descrizione = "Spesa caricata su commessa non presente nel giorno"
                    a.ExpenseCode = rs("ExpenseCode")
                    a.ProjectCode = rs("ProjectCode")
                    a.UnitOfMeasure = rs("UnitOfMeasure")
                    a.Amount = rs("Amount")

                    ListaAnomalie.Add(a)
                End If
            Next

        End If

        If ListaAnomalie.Count > 0 Then
            CheckSpese = 1
        Else
            CheckSpese = 0
        End If

    End Function

End Class

Public Class Database

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function ExecuteScalar(ByVal cmdText As String, ByVal mypage As Page) As Object

        Dim connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString
        Using connection As New SqlConnection(connectionString)

            Dim dtRecord As New DataTable()
            Using cmd As SqlCommand = New SqlCommand(cmdText, connection)

                Try

                    connection.Open() ' Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    ExecuteScalar = cmd.ExecuteScalar()

                Catch ex As Exception
                    If Not (mypage Is Nothing) Then
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteScalar: " & ex.Message & "');", True)
                    End If
                    ExecuteScalar = 0
                End Try

            End Using

        End Using

    End Function

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function ExecuteSQL(ByVal cmdText As String, ByVal mypage As Page) As Int16

        Dim connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString
        Using connection As New SqlConnection(connectionString)

            Dim dtRecord As New DataTable()
            Using cmd As SqlCommand = New SqlCommand(cmdText, connection)

                Try

                    connection.Open() ' Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    ExecuteSQL = cmd.ExecuteNonQuery()

                Catch ex As Exception
                    If Not (mypage Is Nothing) Then
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE ExecuteSQL: " & ex.Message & "');", True)
                    End If
                    ExecuteSQL = 0
                End Try

            End Using

        End Using

    End Function

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function RecordEsiste(ByVal cmdText As String) As Boolean
        Return RecordEsiste(cmdText, Nothing)
    End Function

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function RecordEsiste(ByVal cmdText As String, ByVal mypage As Page) As Boolean
        ' 02-09-2018 FUNZIONE MIGRATA
        Dim result As Boolean = False

        Dim connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString
        Using connection As New SqlConnection(connectionString)

            Dim dtRecord As New DataTable()
            Using da As New SqlDataAdapter(cmdText, connection)

                Try

                    connection.Open() ' Not necessarily needed In this Case because DataAdapter.Fill does it otherwise 
                    da.Fill(dtRecord)

                    If dtRecord.Rows.Count = 1 Then
                        result = True
                    Else
                        result = False
                    End If

                Catch ex As Exception
                    If Not (mypage Is Nothing) Then
                        mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE RecordEsiste: " & ex.Message & "');", True)
                    End If
                    result = False
                End Try

            End Using

        End Using

        Return result

    End Function

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function GetData(ByVal cmdText As String, ByVal mypage As Page) As DataTable

        Dim dt As New DataTable()

        Using lCon As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString)
            Using cmd As SqlCommand = lCon.CreateCommand()

                lCon.Open()
                Using sda = New SqlDataAdapter(cmd)

                    Try
                        cmd.CommandText = cmdText
                        cmd.CommandType = CommandType.Text
                        sda.Fill(dt)

                    Catch ex As Exception

                        If Not (mypage Is Nothing) Then
                            mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE GetData: " & ex.Message & "');", True)
                        End If

                    End Try

                End Using
            End Using
        End Using

        Return dt
    End Function

    ' 02-09-2018 FUNZIONE MIGRATA
    Public Shared Function GetRow(ByVal cmdText As String, ByVal mypage As Page) As DataRow

        Dim dtTable As DataTable = Database.GetData(cmdText, mypage)
        GetRow = dtTable.Rows(0)

    End Function

End Class

Public Class ASPcompatility

    Public Shared Function FormatNumberDB(ByVal InputNumber As Double) As String

        FormatNumberDB = "'" & InputNumber.ToString().Replace(",", ".") & "'"

    End Function

    Public Shared Function FormatStringDb(ByVal InputString As String) As String

        FormatStringDb = "'" & InputString & "'"

    End Function

    Public Shared Sub SelectMonths(ByRef DDL As System.Web.UI.WebControls.DropDownList, Optional ByVal sLingua As String = "it")
        Dim i As Integer
        Dim lItem As ListItem
        Dim CurrCulture As CultureInfo = CultureInfo.CreateSpecificCulture(sLingua)
        Dim mfi As DateTimeFormatInfo = CurrCulture.DateTimeFormat

        ' elenco dei mesi con default il corrente
        For i = 1 To 12

            lItem = New ListItem(mfi.MonthNames(i - 1), i.ToString())
            DDL.Items.Add(lItem)

            If Month(Now()) = i Then
                DDL.SelectedIndex = i - 1
            End If
        Next

    End Sub

    Public Shared Sub SelectYears(ByRef DDL As System.Web.UI.WebControls.DropDownList)
        Dim i As Integer
        Dim lItem As ListItem

        For i = MyConstants.First_year To MyConstants.Last_year

            ' elenco di anni con default quello corrente
            lItem = New ListItem(i.ToString(), i.ToString())
            DDL.Items.Add(lItem)

            If Year(Now()) = i Then
                DDL.SelectedIndex = i - MyConstants.First_year
            End If
        Next
    End Sub

    Public Shared Function LastDay(ByVal Month As Integer, ByVal Year As Integer) As String

        Dim dData As DateTime = "1/" & Month & "/" & Year
        LastDay = dData.AddMonths(1).AddDays(-1)

    End Function

    Public Shared Function DaysInMonth(ByVal Month As Integer, ByVal Year As Integer) As Integer

        Dim dData As DateTime = "1/" & Month & "/" & Year
        Dim LastDay As String = dData.AddMonths(1).AddDays(-1)

        DaysInMonth = Val(LastDay.Substring(0, 2))

    End Function

    Public Shared Function FirstDay(ByVal Month As Integer, ByVal Year As Integer) As String

        FirstDay = "01" & "/" & IIf(Month > 9, Month, "0" & Month) & "/" & Year

    End Function

    Public Shared Function FormatDateDb(ByVal sDateToConvert As String, Optional ByVal timestamp As Boolean = False) As String

        Dim aDay As Integer
        Dim aMonth As Integer
        Dim aYear As Integer

        Dim DateToConvert As Date

        If timestamp Then
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy HH.mm.ss", System.Globalization.CultureInfo.InvariantCulture)
        Else
            DateToConvert = DateTime.ParseExact(sDateToConvert, "d/M/yyyy", System.Globalization.CultureInfo.InvariantCulture)
        End If

        aDay = Microsoft.VisualBasic.DateAndTime.Day(DateToConvert)
        aMonth = Month(DateToConvert)
        aYear = Year(DateToConvert)

        Dim server As String = ConfigurationSettings.AppSettings("FORMATODATA")

        Select Case server

            Case "US"
                FormatDateDb = "'" & aMonth & "-" & aDay & "-" & aYear

            Case "IT"
                FormatDateDb = "'" & aDay & "-" & aMonth & "-" & aYear

        End Select

        ' se richiamato con parametro opzionale timestamp aggiunge ore:min:sec
        If timestamp Then
            FormatDateDb = FormatDateDb & " " & Hour(DateToConvert) & ":" & Minute(DateToConvert) & ":" & Second(DateToConvert) & "'"
        Else
            FormatDateDb = FormatDateDb & "'"
        End If

    End Function

    Public Shared Function GetRows(ByVal sSQLstring As String) As System.Data.DataRowCollection

        Dim ds As DataSet

        Dim connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString
        Using connection As New SqlConnection(connectionString)

            Using Adapter As New SqlDataAdapter(sSQLstring, connection)

                Try

                    ds = New DataSet()
                    Adapter.Fill(ds)

                    If ds.Tables(0).Rows.Count = 0 Then
                        GetRows = Nothing
                    Else
                        GetRows = ds.Tables(0).Rows
                    End If

                Catch ex As Exception
                    GetRows = Nothing
                    'If Not (mypage Is Nothing) Then
                    '    mypage.ClientScript.RegisterStartupScript(mypage.GetType(), "MessageBox", "alert('ERRORE: " & ex.Message & "');", True)
                    'End If

                End Try

            End Using

        End Using

    End Function

End Class