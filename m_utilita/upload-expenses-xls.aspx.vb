Imports System.Data.OleDb
Imports System.Data
Imports System.IO
Imports System.Data.SqlClient
Imports System.Threading

Partial Class m_utilita_upload_expenses_xls1
    Inherits System.Web.UI.Page

    ' recupera oggetto sessione
    Public CurrentSession As TRSession

    Sub Page_Load(ByVal Source As Object, ByVal E As EventArgs)

        Auth.CheckPermission("DATI", "UPLOAD")

        CurrentSession = Session("CurrentSession") ' recupera oggetto con variabili di sessione

        messaggio.Text = ""
        recordOK.Text = ""

    End Sub

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs)

        ' record layout
        ' Risorsa (0); Data (1);Progetto (2); Tipo Spesa (3);Valore (4);Pagato (5);Storno (6); Note (7)

        Dim DATA = 0 ' formato campo, data oltre cutt-off
        Dim PROGETTO = 1 ' codice ammesso
        Dim TIPOSPESA = 2 ' codice ammesso
        Dim VALORE = 3 ' valore numerico > 0
        Dim CCREDITO = 4 ' o X o blank
        Dim PAGATO = 5 ' o X o blank
        Dim STORNO = 6 ' o X o blank
        Dim FATTURA = 7 ' o X o blank
        Dim NOTA = 8

        Dim c = New ValidationClass
        Dim dt As New DataTable()

        ' ****************** FINE IMPORT da EXCEL in DATASET ******************

        Dim dr As DataRow
        Dim iTipoBonus_id As Integer
        Dim aDateBonus As New ArrayList ' usato per verificare doppi bonus su stesso giorno

        Dim i, f As Integer
        Dim idProgetto As Integer
        Dim idSpesa As Integer

        If Not FUFile.HasFile Then
            Return
        End If

        Dim ErrorMessage As String = ""
        dt = Utilities.ImportExcel(FUFile, ErrorMessage)

        If IsNothing(dt) Then
            Utilities.CreateMessageAlert(Me.Page, "Errore in caricamento file: " & ErrorMessage, "")
            Return
        End If

        If dt.Rows.Count = 0 Then
            Utilities.CreateMessageAlert(Me.Page, "Errore in caricamento file: " & ErrorMessage, "")
            Return
        End If

        For Each dr In dt.Rows

            ' indice
            i = dt.Rows.IndexOf(dr) + 1

            ' inizializza tipo bonus che verrà poi letto da DB
            iTipoBonus_id = 0
            idProgetto = 0
            idSpesa = 0

            ' Verifica formato data
            If Not IsDate(dr(DATA).ToString) Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "ThenRow " & i & GetLocalResourceObject("msg1").ToString ' data non valida
                Continue For
            End If

            ' importo non numerico 
            If Not IsNumeric(dr(VALORE).ToString) Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg2").ToString ' ": importo spesa deve essere un numero"
                Continue For
            End If

            ' importo numerico non negativo
            If Not IsNumeric(dr(VALORE).ToString) Or dr(VALORE).ToString <= 0 Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg3").ToString ' ": importo spesa non può essere negativo"
                Continue For
            End If

            ' valori flag                               
            If dr(CCREDITO).ToString.Trim <> "" And
               dr(CCREDITO).ToString <> "X" And dr(CCREDITO).ToString <> "x" Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg16").ToString ' ": valore flag 'Carta di Credito' non riconosciuto"
            Continue For
        End If

        ' valori flag                               
        If dr(PAGATO).ToString.Trim <> "" And
               dr(PAGATO).ToString <> "X" And dr(PAGATO).ToString <> "x" Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg4").ToString ' ": valore flag 'PAGATO con cc' non riconosciuto"
                Continue For
            End If

            ' valori flag                               
            If dr(STORNO).ToString <> "" And
               dr(STORNO).ToString <> "X" And dr(STORNO).ToString <> "x" Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg5").ToString ' ": valore flag 'STORNO' non riconosciuto"
                Continue For
            End If

            ' valori flag                               
            If dr(FATTURA).ToString.Trim <> "" And
               dr(FATTURA).ToString <> "X" And dr(FATTURA).ToString <> "x" Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg6").ToString ' ": valore flag 'FATTURA' non riconosciuto"
                Continue For
            End If

            ' data oltre cutoff
            If dr(DATA) <= CurrentSession.sCutoffDate Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg7").ToString ' ": data del file antecedente al cut-off"
                Continue For
            End If

            ' tipo spesa aperta per persona
            Dim aSpeseForzate As DataTable
            aSpeseForzate = CurrentSession.dtSpeseForzate

            For f = 0 To (aSpeseForzate.Rows.Count - 1)
                If aSpeseForzate.Rows.Item(f).Item(1).ToString.Trim = dr(TIPOSPESA).ToString.Trim Then
                    idSpesa = CInt(aSpeseForzate.Rows.Item(f).Item(0))
                    Exit For
                End If
            Next

            If idSpesa = 0 Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg8").ToString & dr(TIPOSPESA).ToString.Trim ' ": Codice spesa non ammesso, "
                Continue For
            End If

            ' 08/2014 Valorizza tipo Bonus se il tipo spesa è di tipo bonus
            Dim drExpenseType As DataRow = Database.GetRow("Select TipoBonus_id, AdditionalCharges from ExpenseType where ExpenseType_id=" + idSpesa.ToString, Me.Page)
            iTipoBonus_id = drExpenseType("TipoBonus_id")

            ' Se la spesa è un bonus la quantità deve essere uno
            If iTipoBonus_id > 0 And dr(VALORE) <> 1 Then
                messaggio.Text = messaggio.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg9").ToString & dr(TIPOSPESA).ToString.Trim ' ": Bonus/ticket con quantità diversa da 1 non ammesso "
                Continue For
            End If

            ' Se la spesa è il ticket restaurant il progetto viene impostato di default
            If idSpesa = ConfigurationManager.AppSettings("TICKET_REST_EXPENSE") Then
                idProgetto = ConfigurationManager.AppSettings("TICKET_REST_PROJECT")
            End If

            If iTipoBonus_id > 0 Then

                ' Se sullo stesso giorno esiste già una spesa "Bonus" da errore
                If Database.RecordEsiste("Select Expenses_Id from Expenses INNER JOIN ExpenseType ON ExpenseType.ExpenseType_id = Expenses.ExpenseType_id where ( persons_id = " & CurrentSession.Persons_id _
                                       & " AND Expenses.Date = " & ASPcompatility.FormatDateDb(dr(DATA)) & " And ExpenseType.TipoBonus_id > 0 )") Then
                    messaggio.Text = messaggio.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg10").ToString & dr(TIPOSPESA).ToString.Trim & " - " & dr(DATA).ToString.Substring(1, 10) ' ": Bonus/ticket già presente nel DB per lo stesso giorno "
                    Continue For
                End If

                ' esegue il check sulle righe non ancora caricate                    
                If aDateBonus.Contains(dr(DATA)) Then
                    messaggio.Text = messaggio.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg11").ToString & dr(TIPOSPESA).ToString.Trim & " - " & dr(DATA).ToString.Substring(1, 10) ' ": Bonus/ticket ripetuto nel file per lo stesso giorno "
                    Continue For
                Else
                    aDateBonus.Add(dr(DATA))
                End If

                ' se il tipo spesa è un rimborso travel verifica presenza del testo con il luogo di trasferta
                If iTipoBonus_id = ConfigurationManager.AppSettings("TIPO_BONUS_TRAVEL") And
                   dr(NOTA).ToString.Trim = "" Then
                    messaggio.Text = messaggio.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg12").ToString & dr(TIPOSPESA).ToString.Trim & " - " & dr(DATA).ToString.Substring(1, 10) ' ": specificare luogo in caso di rimborso trasferta "
                    Continue For
                End If

            End If ' if iTipoBonus_id > 0

            ' Fine                                      

            Dim aProgettiForzati As DataTable
            If idProgetto = 0 Then ' non precedentemente impostato in caso di ticket restaurant
                aProgettiForzati = CurrentSession.dtProgettiForzati

                For f = 0 To (aProgettiForzati.Rows.Count - 1)
                    If aProgettiForzati.Rows.Item(f).Item(1).ToString.Trim = dr(PROGETTO).ToString.Trim Then
                        idProgetto = CInt(aProgettiForzati.Rows.Item(f).Item(0))
                        Exit For
                    End If
                Next

                If idProgetto = 0 Then
                    messaggio.Text = messaggio.Text & Chr(13) &
                                    "Row " & i & GetLocalResourceObject("msg13").ToString & dr(PROGETTO).ToString.Trim ' ": Codice progetto non ammesso, " 
                    Continue For
                End If
            End If

            ' successo 
            If Not simulazione.Checked Then
                Dim conn As SqlConnection
                Dim Adapter As SqlDataAdapter
                Dim dsExpenses As New DataSet()

                Try

                    conn = New SqlConnection(ConfigurationManager.ConnectionStrings("MSSql12155ConnectionString").ConnectionString)

                    ' Top per non caricare l'intera tabella!
                    Adapter = New SqlDataAdapter("Select top 1 * from Expenses", conn)

                    Dim cb As SqlCommandBuilder = New SqlCommandBuilder(Adapter)
                    Adapter.UpdateCommand = cb.GetUpdateCommand()

                    dsExpenses = New DataSet()
                    Adapter.Fill(dsExpenses)

                    Dim newrow As DataRow = dsExpenses.Tables(0).NewRow()

                    newrow("persons_id") = CurrentSession.Persons_id
                    newrow("date") = dr(DATA).ToString
                    newrow("Projects_id") = idProgetto
                    newrow("ExpenseType_id") = idSpesa
                    newrow("Amount") = dr(VALORE)

                    ' se Spesa bonus i flag sono impostati per default a blank
                    If iTipoBonus_id = 0 Then
                        newrow("CreditCardPayed") = IIf(dr(PAGATO).ToString <> "", True, False)
                        newrow("CompanyPayed") = IIf(dr(PAGATO).ToString <> "", True, False)
                        newrow("CancelFlag") = IIf(dr(STORNO).ToString <> "", True, False)
                        newrow("InvoiceFlag") = IIf(dr(FATTURA).ToString <> "", True, False)
                    Else
                        newrow("CreditCardPayed") = False
                        newrow("CompanyPayed") = False
                        newrow("CancelFlag") = False
                        newrow("InvoiceFlag") = False
                    End If

                    newrow("Comment") = dr(NOTA)
                    newrow("CreatedBy") = CurrentSession.UserId
                    newrow("CreationDate") = DateTime.Now()
                    newrow("TipoBonus_id") = iTipoBonus_id
                    newrow("AdditionalCharges") = drExpenseType("AdditionalCharges")

                    Dim result = Utilities.GetManagerAndAccountId(idProgetto)

                    newrow("Company_id") = CurrentSession.Company_id
                    newrow("ClientManager_id") = result.Item1
                    newrow("AccountManager_id") = result.Item2

                    dsExpenses.Tables(0).Rows.Add(newrow)
                    Adapter.Update(dsExpenses)

                    recordOK.Text = recordOK.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg14").ToString & dr(PROGETTO) & " - " &
                                                               dr(TIPOSPESA) & " - " & dr(DATA) & " - " & dr(VALORE) ' " caricata: "
                Catch ex As Exception
                    recordOK.Text = recordOK.Text & Chr(13) & ex.Message
                End Try

            Else
                recordOK.Text = recordOK.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg15").ToString & dr(PROGETTO) & " - " &
                                                           dr(TIPOSPESA) & " - " & dr(DATA) & " - " & dr(VALORE) '" caricata (in simulazione): "
            End If

        Next 'For i = 1 To UBound(rows) -> righe file

    End Sub

    Protected Overrides Sub InitializeCulture()
        ' Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture()
    End Sub

End Class
