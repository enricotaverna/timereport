<%@ Page Language="VB" culture="auto" meta:resourcekey="PageResource1"  %>

<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Threading" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">

    Protected Sub btnUpload_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If FileUpload1.HasFile Then
            Dim FileName As String = Path.GetFileName(FileUpload1.PostedFile.FileName)
            Dim Extension As String = Path.GetExtension(FileUpload1.PostedFile.FileName)
            Dim FolderPath As String = ConfigurationManager.AppSettings("FolderPath")

            Dim FilePath As String = Server.MapPath(FolderPath + FileName)
            FileUpload1.SaveAs(FilePath)
            Import_Data(FilePath, Extension, True)
        End If
    End Sub

    Private Sub Import_Data(ByVal FilePath As String, ByVal Extension As String, ByVal isHDR As String)

        Dim i, f As Integer
        Dim idProgetto As Integer
        Dim idSpesa As Integer

        ' record layout
        ' Risorsa (0); Data (1);Progetto (2); Tipo Spesa (3);Valore (4);Pagato (5);Storno (6); Note (7)

        '       Const RISORSA = 0 ' codice esistente
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

        ' ****** IMPORT da EXCEL in DATASET ******************
        Dim conStr As String = ""
        Select Case Extension
            Case ".xls"
                'Excel 97-03
                conStr = ConfigurationManager.ConnectionStrings("Excel03ConString") _
                           .ConnectionString
                Exit Select
            Case ".xlsx"
                'Excel 07
                conStr = ConfigurationManager.ConnectionStrings("Excel07ConString") _
                              .ConnectionString
                Exit Select
            Case Else
                messaggio.Text = GetLocalResourceObject("msgErrore").ToString
                Return
        End Select

        conStr = String.Format(conStr, FilePath, isHDR)

        Dim connExcel As New OleDbConnection(conStr)
        Dim cmdExcel As New OleDbCommand()
        Dim oda As New OleDbDataAdapter()
        Dim dt As New DataTable()

        cmdExcel.Connection = connExcel

        'Get the name of First Sheet
        connExcel.Open()
        Dim dtExcelSchema As DataTable
        dtExcelSchema = connExcel.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, Nothing)
        Dim SheetName As String = dtExcelSchema.Rows(0)("TABLE_NAME").ToString()
        connExcel.Close()

        'Read Data from First Sheet
        connExcel.Open()
        cmdExcel.CommandText = "SELECT * From [" & SheetName & "]"
        oda.SelectCommand = cmdExcel
        oda.Fill(dt)
        connExcel.Close()

        ' ****************** FINE IMPORT da EXCEL in DATASET ******************

        Dim dr As DataRow
        Dim iTipoBonus_id As Integer
        Dim aDateBonus As New ArrayList ' usato per verificare doppi bonus su stesso giorno

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
                                "Row " & i & GetLocalResourceObject("msg1").ToString ' data non valida
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
            If dr(DATA) <= Convert.ToDateTime(Session("CutOffDate")) Then
                messaggio.Text = messaggio.Text & Chr(13) &
                                "Row " & i & GetLocalResourceObject("msg7").ToString ' ": data del file antecedente al cut-off"
                Continue For
            End If

            ' tipo spesa aperta per persona
            Dim aSpeseForzate As DataTable
            aSpeseForzate = Session("dtSpeseForzate")

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
            Dim drExpenseType As DataRow = Database.GetRow("Select TipoBonus_id from ExpenseType where ExpenseType_id=" + idSpesa.ToString, Me.Page)
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
                If Database.RecordEsiste("Select Expenses_Id from Expenses INNER JOIN ExpenseType ON ExpenseType.ExpenseType_id = Expenses.ExpenseType_id where ( persons_id = " & Session("persons_id") _
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
                If iTipoBonus_id = ConfigurationManager.AppSettings("TIPO_BONUS_TRAVEL") And _
                   dr(NOTA).ToString.Trim = "" Then
                    messaggio.Text = messaggio.Text & Chr(13) & "Row " & i & GetLocalResourceObject("msg12").ToString & dr(TIPOSPESA).ToString.Trim & " - " & dr(DATA).ToString.Substring(1, 10) ' ": specificare luogo in caso di rimborso trasferta "
                    Continue For
                End If

            End If ' if iTipoBonus_id > 0

            ' Fine                                      

            Dim aProgettiForzati As DataTable
            If idProgetto = 0 Then ' non precedentemente impostato in caso di ticket restaurant
                aProgettiForzati = Session("dtProgettiForzati")

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

                    Adapter = New SqlDataAdapter("Select * from Expenses", conn)

                    Dim cb As SqlCommandBuilder = New SqlCommandBuilder(Adapter)
                    Adapter.UpdateCommand = cb.GetUpdateCommand()

                    dsExpenses = New DataSet()
                    Adapter.Fill(dsExpenses)

                    Dim newrow As DataRow = dsExpenses.Tables(0).NewRow()

                    newrow("persons_id") = Session("persons_id")
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
                    newrow("CreatedBy") = Session("persons_id")
                    newrow("CreationDate") = DateTime.Now()
                    newrow("TipoBonus_id") = iTipoBonus_id

                    ' recupera oggetto sessione
                    Dim CurrentSession As TRSession = Session("CurrentSession") ' recupera oggetto con variabili di sessione
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

    Sub Page_Load(ByVal Source As Object, ByVal E As EventArgs)

        Auth.CheckPermission("DATI", "UPLOAD")

        messaggio.Text = ""
        recordOK.Text = ""

    End Sub

    Protected Sub Menu1_MenuItemClick(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.MenuEventArgs)

    End Sub

    Protected Sub BTconferma_Click(ByVal sender As Object, ByVal e As System.EventArgs)

    End Sub

    Protected Overrides Sub InitializeCulture()
        ' Imposta la lingua della pagina
        Thread.CurrentThread.CurrentUICulture = CommonFunction.GetCulture()
    End Sub

</script>

<html>
<head id="Head1" runat="server">
    <title>Upload Spese</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <link href="/timereport/include/newstyle.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style1
        {
            width: 18px;
        }
    </style>
</head>
<script language="JavaScript" src="/timereport/include/menu/menu_array.js" id="IncludeMenu" NoExpenses=<%= Session("NoExpenses")%>  lingua='<%= Session("lingua")%>' userlevel='<%= Session("userLevel")%>' type="text/javascript"></script>
<script language="JavaScript" src="/timereport/include/menu/mmenu.js" type="text/javascript">    function UploadFile_onclick() {

    }

    function strFile_onclick() {

    }

</script>
<body>
    <div id="TopStripe"></div>

    <div id="MainWindow">

    <div id="PanelWrap">

        <form id="fileUpload" runat="Server" enctype="multipart/form-data">

        <table class="RoundedBox" width="80%">
            <tr>
                <th>
                    <div class=formtitle style="WIDTH:auto"> <asp:Literal runat="server" Text="<%$ Resources:titolo%>" /></div>
                </th>
            </tr>
            <tr>
                <td>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td>
                    File:
<%--                    <input id="strFile" type="file" runat="Server" onclick="return strFile_onclick()"
                        class=" " size="48" />--%>
                    
                    <asp:FileUpload ID="FileUpload1" runat="server" meta:resourcekey="FileUpload1Resource1" />

                    <asp:Button type="submit" id="UploadFile" Text="Upload File" runat="server" OnClick="btnUpload_Click" meta:resourcekey="UploadFileResource1" />&nbsp;&nbsp;
                    <asp:CheckBox ID="simulazione" runat="server" Text=" Esecuzione di prova" Checked="True" meta:resourcekey="simulazioneResource1" />
                    <br />
                    <br />
                    <asp:Literal runat="server" Text="<%$ Resources:logcscarti%>" />  
                    <br />
                    <asp:TextBox ID="messaggio" runat="server" BackColor="#E2E2E2" Rows="5" TextMode="MultiLine"
                        Columns="80" meta:resourcekey="messaggioResource1"></asp:TextBox>
                    <br />
                    <br />
                    <asp:Literal runat="server" Text="<%$ Resources:logcaricamento%>" />  
                    <br />
                    <asp:TextBox ID="recordOK" runat="server" BackColor="#E2E2E2" Rows="5" TextMode="MultiLine"
                        Columns="80" meta:resourcekey="recordOKResource1"></asp:TextBox>
                    <br />
                    &nbsp;<br />
                </td>
            </tr>
        </table>

        <br />

        <%--*** Istruzioni ***--%>
        <table class="RoundedBox" width="80%">
            <tr>
                <td style="font-weight: bold" class="style1">
                    <asp:Image ID="domanda" runat="server" Height="16px" ImageUrl="/timereport/images/icons/16x16/S_N_QUES.gif" meta:resourcekey="domandaResource1" />
                </td>
                <td style="font-weight: bold">
                     <asp:Literal runat="server" Text="<%$ Resources:istruzioni%>" />
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    1
                </td>
                <td>
                     <asp:Literal runat="server" Text="<%$ Resources:istr_riga1%>" />  <%--Scarica il--%>
                    <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank" NavigateUrl="/timereport/m_utilita/templateSpese.xls" meta:resourcekey="HyperLink1Resource1">template excel</asp:HyperLink>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    2
                </td>
                <td>
                    <asp:Literal runat="server" Text="<%$ Resources:istr_riga2%>" /> <%--Compila il foglio excel con spese e progetti (NON serve salvare in CSV)--%>
                </td>
            </tr>
            <tr>
                <td style="text-align: center">
                    3
                </td>
                <td>
                    <asp:Literal runat="server" Text="<%$ Resources:istr_riga3%>" /> <%--Prima del caricamento effettivo puoi usare la modalità di simulazione per verificare la correttezza dei dati --%>
                </td>
            </tr>
        </table>

        </form>
    
    </div> <!-- END PanelWrap -->

    </div>    <%--*** MainWindow ***--%>
   
    <!-- **** FOOTER **** -->
    <div id="WindowFooter">
        <div>
        </div>
        <div id="WindowFooter-L">
            Aeonvis Spa
            <%= Year(now())  %></div>
        <div id="WindowFooter-C">
            cutoff:
            <%=session("CutoffDate")%>
        </div>
        <div id="WindowFooter-R">
            <asp:Literal runat="server" Text="<%$ Resources:timereport, Utente%>" />
            <%= Session("UserName")  %></div>
    </div>
</body>
</html>
