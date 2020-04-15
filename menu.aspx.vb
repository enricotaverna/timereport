Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Data
Imports System.Net.Mail
Imports System.Globalization
Imports System.Threading


Partial Class menu
    Inherits System.Web.UI.Page

    Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs)

        Auth.CheckPermission("BASE", "MENU")

        If Page.IsPostBack = True Then
            CalcolaProgressivoOreTR(Page.Request.Params.Get("__EVENTTARGET"))
        Else
            CalcolaProgressivoOreTR("")
        End If

        If Session("TrainingCheckSecondCall") = Nothing Then
            Session("TrainingCheckSecondCall") = "false"
        Else
            Session("TrainingCheckSecondCall") = "true"
        End If

    End Sub

    Sub CalcolaProgressivoOreTR(ByVal sBottone As String)
        Dim message As String = ""

        '	print out info message	
        If Request("msgtype") = "I" Then
            Select Case Request("msgno")
                Case 200 : message = "Aggiornamento effettuato" ' 200 MSGNO_UPDATE_DONE
                Case 400 : message = "La password è stata modificata" '400 MSGNO_PASSWORD_CHANGED
            End Select
            'icona.ImageUrl = "images/icons/22x22/S_M_INFO.gif"

            ClientScript.RegisterStartupScript(Page.GetType(), "Popup", "ShowPopup('" + message + "');", True)
        End If

        If Request("msgtype") = "E" Then
            Select Case Request("msgno")
                Case 100 : message = "E100 : Impossibile trovare record di configurazione"
                Case 300 : message = "E300:  Funzione non autorizzata"
            End Select
            'icona.ImageUrl = "images/icons/22x22/S_M_ERRO.gif"

            'emette messaggio di conferma salvataggio
            ClientScript.RegisterStartupScript(Page.GetType(), "Popup", "ShowPopup('" + message + "');", True)
        End If

        ' START GESTIONE BOX CON DATI STATISTICI

        Dim iMese As Integer
        Dim iAnno As Integer

        ' recuper giorni lavorativi del mese 
        If Session("iMese") Is Nothing Then
            Session("iMese") = Month(Today)
            iMese = Month(Today)
        End If

        If Session("iAnno") Is Nothing Then
            Session("IAnno") = Year(Today)
            iAnno = Year(Today)
        End If

        iMese = Session("iMese")
        iAnno = Session("iAnno")

        If sBottone = "fw_button" Then
            If iMese = 12 Then
                iMese = 1
                iAnno = iAnno + 1
            Else
                iMese = iMese + 1
            End If
        End If

        If sBottone = "bk_button" Then
            If iMese = 1 Then
                iMese = 12
                iAnno = iAnno - 1
            Else
                iMese = iMese - 1
            End If
        End If

        Session("iMese") = iMese
        Session("iAnno") = iAnno

        ' chiama funzione per calcolare percentuale
        Dim lCalcolaPercOre As CommonFunction.CalcolaPercOutput = CommonFunction.CalcolaPercOre(Session("persons_id"), iMese, iAnno)

        lContaOre.Text = lCalcolaPercOre.dOreCaricate.ToString
        lOreLavorative.Text = lCalcolaPercOre.dOreLavorative.ToString
        lPerc.Text = lCalcolaPercOre.sPerc

        ' percentuale della barra grafica
        pbarIEesque.PercentComplete = IIf(((lCalcolaPercOre.dOreCaricate / lCalcolaPercOre.dOreLavorative) * 100) > 100, 100, ((lCalcolaPercOre.dOreCaricate / lCalcolaPercOre.dOreLavorative) * 100))

        ' ** Calcola Ore caricate per il mese FINE

        ' ** Calcola spese totali
        Dim sFromDate As String = ASPcompatility.FormatDateDb("1/" & iMese.ToString & "/" & iAnno.ToString)
        Dim sToDate As String = ASPcompatility.FormatDateDb(System.DateTime.DaysInMonth(iAnno, iMese) & "/" & iMese.ToString & "/" & iAnno.ToString)

        Dim objCon = New SqlConnection()
        objCon.ConnectionString = ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString.ToString()
        objCon.Open()

        Dim objCommand = New SqlCommand
        objCommand.Connection = objCon
        objCommand.CommandText = "SELECT Round(Sum(Expenses.Amount*ExpenseType.ConversionRate),2) AS TotalAmount " & _
        "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " & _
        "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " & _
        "WHERE Expenses.Date >=" & sFromDate & " And Expenses.Date <=" & sToDate & " AND " & _
        "Persons.Persons_id = " & Session("persons_id") & " AND Expenses.CreditCardPayed = 0 AND Expenses.CompanyPayed = 0 "

        Dim oRes As Object = objCommand.ExecuteScalar()

        ' ** Calcola spese caricate per il mese
        ' oRes = objCommand.ExecuteScalar() duplicato
        Dim iContaSpeseSenzaCC As Integer = IIf(IsDBNull(oRes), 0, oRes)

        lContaSpeseSenzaCC.Text = iContaSpeseSenzaCC.ToString("N2")

        ' ** Calcola spese totali
        objCommand.CommandText = "SELECT Round(Sum(Expenses.Amount*ExpenseType.ConversionRate),2) AS TotalAmount " & _
        "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " & _
        "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " & _
        "WHERE Expenses.Date >=" & sFromDate & " And Expenses.Date <=" & sToDate & " AND " & _
        "Persons.Persons_id = " & Session("persons_id") & " AND CreditCardPayed = 1"

        ' ** Calcola Ore caricate per il mese
        oRes = objCommand.ExecuteScalar()
        Dim iContaSpeseConCC As Double = IIf(IsDBNull(oRes), 0, oRes)

        lContaSpeseConCC.Text = iContaSpeseConCC.ToString("N2")

        ' ** Calcola chilometri totali
        objCommand.CommandText = "SELECT Round(Sum(Expenses.Amount),2) AS TotalAmount " & _
        "FROM   (Expenses INNER JOIN ExpenseType ON Expenses.ExpenseType_id = ExpenseType.ExpenseType_Id) " & _
        "INNER JOIN Persons ON Expenses.Persons_id = Persons.Persons_id " & _
        "WHERE Expenses.Date >=" & sFromDate & " And Expenses.Date <=" & sToDate & " AND " & _
        "ExpenseType.UnitOfMeasure = 'km' AND " & _
        "Persons.Persons_id = " & Session("persons_id")

        ' ** Calcola Ore caricate per il mese
        oRes = objCommand.ExecuteScalar()
        Dim iContaKm As Integer = IIf(IsDBNull(oRes), 0, oRes)

        lContaKm.Text = iContaKm.ToString("N0")

        ' ****
        Dim CurrCulture As CultureInfo = CultureInfo.CreateSpecificCulture(Session("lingua").ToString)
        Dim mfi As DateTimeFormatInfo = CurrCulture.DateTimeFormat
        lMese.Text = mfi.MonthNames(iMese - 1) & " " & iAnno.ToString

        objCon.Close()

    End Sub

    Protected Sub button_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        '     CalcolaProgressivoOreTR(sender.uniqueID)
    End Sub

    Protected Overrides Sub InitializeCulture()
        ' Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture()
    End Sub


End Class
