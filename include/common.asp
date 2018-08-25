<%

'        PROCEDURES
'        MakeConn(Conn, database)                        creates a connection
'        MakeRs_add(Rs,Conn,sql)                                creates a recordset for inserting and modifying record
'        MakeRs_view(Rs,Conn,sql)                        creates a recordset for viewing record
'        DestroyDestroy(Name)                                destroy an object

'        FUNCTIONS
'        FormatStringDB(InputString)                                Format a string for DB query

Dim objConn, objRS, objCmd

' ---- Application Constant -----
		Const PATH_DATABASE = "/mdb-database/"
		Const PATH_OUTPUT_FILES = "/public/timereport/"
		
		Const PROVIDER = "SQLOLEDB"
'		Const DATASOURCE =  "CASA-PC\SQLEXPRESS"  
'        Const DATASOURCE =  "STAN\SQLEXPRESS" 
'		Const DATASOURCE =  "62.149.153.12"
		Const DATASOURCE =  "95.110.230.190"
		Const DATABASE = "MSSql12155_test" 
		Const USER = "MSSql12155"
		Const PWD = "50a715f9"

'		MSSQL
		Const CTRUE = 1 
		Const CFALSE = 0

'		Access		
'		Const CTRUE = "true" 
'		Const CFALSE = "false"
		
'---- DataTypeEnum Values ----
        Const adLongVarWChar = 203
        Const adSchemaForeignKeys = 27

'        usato nell'estrazione di ore/spese in excel
        Const NON_AEONVIS = "999"

'Convert '' and 0 to null in date fields?
        Const adEmpty = 0
        Const adTinyInt = 16
        Const adSmallInt = 2
        Const adInteger = 3
        Const adBigInt = 20
        Const adUnsignedTinyInt = 17
        Const adUnsignedSmallInt = 18
        Const adUnsignedInt = 19
        Const adUnsignedBigInt = 21
        Const adSingle = 4
        Const adDouble = 5
        Const adCurrency = 6
        Const adDecimal = 14
        Const adNumeric = 131
        Const adBoolean = 11
        Const adError = 10
        Const adUserDefined = 132
        Const adVariant = 12
        Const adIDispatch = 9
        Const adIUnknown = 13
        Const adGUID = 72
        Const adDate = 7
        Const adDBDate = 133
        Const adDBTime = 134
        Const adDBTimeStamp = 135
        Const adBSTR = 8
        Const adChar = 129
        Const adVarChar = 200
        Const adLongVarChar = 201
        Const adWChar = 130
        Const adVarWChar = 202

        Const adBinary = 128
        Const adVarBinary = 204
        Const adLongVarBinary = 205
        Const adChapter = 136
        Const adFileTime = 64
        Const adPropVariant = 138
        Const adVarNumeric = 139
        Const adArray = &H2000

' ADO constants
'---- CursorTypeEnum Values ----
Const adOpenForwardOnly = 0
Const adOpenStatic = 3

'---- LockTypeEnum Values ----
Const adLockReadOnly = 1
Const adLockPessimistic = 2

'---- CommandTypeEnum Values ----
Const adCmdUnknown = &H0008
Const adCmdText = &H0001
Const adCmdTable = &H0002
Const adCmdStoredProc = &H0004
Const adParamInput = &H0001

' ---- Error Messages ----
Const MSGNO_OPTION_NOT_FOUND = "100"
Const MSGNO_UPDATE_DONE = "200"
Const MSGNO_AUTHORIZATION_FAILED = "300"
Const  MSGNO_PASSWORD_CHANGED="400"

' ------ Auth level --------
Const AUTH_ADMIN = 5 ' aggiornamenti massivi
Const AUTH_MANAGER = 4 ' Manager
Const AUTH_TEAMLEADER = 3 ' vede solo sè stesso
Const AUTH_EXTERNAL = 1 ' vede solo sè stesso
Const AUTH_EMPLOYEE = 2 ' vede solo sè stesso

' ---- Dates ----
Dim LAST_YEAR  
LAST_YEAR = Year(Now)
Dim FIRST_YEAR  
FIRST_YEAR = LAST_YEAR - 4
        
' ---- query ExpensesReport ----
Const ER_NAME = 0
Const ER_CREDITCARDPAYED = 1
Const ER_EXPENSECODE= 2
Const ER_DATE= 3
Const ER_EXPENSENAME= 4
Const ER_AMOUNT= 5
Const ER_CONVERSIONRATE = 6

' ---- bottoni ----
Const   CREATE_TXT = "crea"  
Const   CANCEL_TXT = "annulla"  
Const   SAVE_TXT = "salva"  
Const   EXPORT_TXT = "esporta"  
Const   EXEC_TXT = "esegui"  
Const   RESET_TXT = "reset"  

Dim  aDaysInMonth
aDaysInMonth =  Array(31,28,31,30,31,30,31,31,30,31,30,31)

'--------------------------------------------------------------------------
Function LastDay(Month, Year)
'--------------------------------------------------------------------------
        LastDay = aDaysInMonth(Month - 1) & "/" & Month & "/" & Year

End Function

'--------------------------------------------------------------------------
Function FirstDay(Month, Year)
'--------------------------------------------------------------------------

        FirstDay = "01" & "/" & IIf(Month>9, Month, "0" & Month) & "/" & Year

End Function

'--------------------------------------------------------------------------
Sub MakeConn(Conn, database)
'--------------------------------------------------------------------------
        dim  connectionstring

          on error resume next

 		Set Conn = Server.CreateObject("ADODB.Connection")											 
		connectionstring   = "Provider=" & PROVIDER & ";Data Source=" & DATASOURCE & _
		                                     ";Initial Catalog=" & DATABASE & _
											 ";uid=" & USER & _
											 ";pwd="  & PWD 
        
		
		Conn.Open connectionstring
 											 
          if err.number <> 0 then
                  response.write ("Routine: MakeConn<BR>")
                  response.write (err.description & "<BR>")
 	              response.write ("Errore in apertura del database: " & database)
                  response.end
          end if

          on error goto 0

End Sub


Sub debug(stringa)
        response.write("<br>DEBUG: -->" & stringa & "<--- len: " & Len(stringa))
End Sub

'--------------------------------------------------------------------------
Sub MakeRs_add(Rs,Conn,sql)
'--------------------------------------------------------------------------
          on error resume next
        Set Rs = Server.CreateObject("ADODB.Recordset")
          Rs.Open sql, Conn, adOpenForwardOnly, adLockPessimistic

          if err.number <> 0 then
                  response.write ("Routine: MakeRs_add<BR>")
                  response.write (err.description & "<BR>")
                  response.write (err.number & "<BR>")
                  response.write (sql)
                  response.end
          end if

          on error goto 0

End Sub

'--------------------------------------------------------------------------
Sub PrepareQuery(objConn, sQueryName)
'--------------------------------------------------------------------------
' prepara il lancio di una stored procedure in access
' gli eventuali parametri vengono settati dopo aver chiamato questa funzione
'--------------------------------------------------------------------------
        Set objCmd = Server.CreateObject ("ADODB.Command")
        objCmd.ActiveConnection = objConn
        objCmd.CommandText = sQueryName'
        objCmd.CommandType = adCmdStoredProc
        objCmd.Prepared = True
End Sub

'--------------------------------------------------------------------------
Sub CaricaParametroQuery(campo, sValore)
'--------------------------------------------------------------------------

        If sValore <> "" then
                        objCmd(campo) =   cint( sValore )
        Else
                        objCmd(campo) =   null
        End if
End Sub

'--------------------------------------------------------------------------
Function IIf( expr, val1, val2)
'--------------------------------------------------------------------------
        If expr = true Then
                 IIf = val1
        Else
                 IIf = val2
        End if

End Function

'--------------------------------------------------------------------------
Sub MakeRs_view(Rs,Conn,sql)
'--------------------------------------------------------------------------
        on error resume next

        SET Rs = Server.CreateObject("ADODB.Recordset")
          Rs.Open sql, Conn, adOpenForwardOnly, adLockReadOnly

            if err.number <> 0 then
                    response.write ("Routine: MakeRs_view<BR>")
                  response.write (err.description & "<BR>")
                  response.write (sql)
                  response.end
          end if

          on error goto 0
End Sub

Sub Destroy(Name)
  Name.Close
  Set Name = Nothing
End Sub

'--------------------------------------------------------------------------
Function FormatStringDb(InputString)
'--------------------------------------------------------------------------

'        Prepara una stringa per essere salvata su un database
'        Aggiunge caratteri escape e apici per delimitare la stringa
        FormatStringDb= Replace(InputString,"""","")
        FormatStringDb = Replace(FormatStringDb,"'","''")

'        se la stringa è vuota aggiunge uno spazio per evitare
'        errore in update
        if len(FormatStringDb) = 0 then
                        FormatStringDb = " "
        end if

        FormatStringDb = "'" & FormatStringDb & "'"

end function

'--------------------------------------------------------------------------
Function FormatDateDb(DateToConvert)
'--------------------------------------------------------------------------

    Dim aDay
    Dim aMonth
    Dim aYear

    aDay = Day(DateToConvert)
    aMonth = Month(DateToConvert)
    aYear = Year(DateToConvert)

'     Access
'    FormatDateDb = "#" & aMonth & "-" & aDay & "-" & aYear & "#"

IF DATASOURCE =  "62.149.153.12" then
'	 MSSQL
         FormatDateDb = "'" & aMonth & "-" & aDay & "-" & aYear & "'"
else
'	 MSSQL EXPRESS
         FormatDateDb = "'" & aDay & "-" & aMonth & "-" & aYear & "'"
End if

End Function

'----------------------------------------------------------------------------
Function GetDescription( FieldName, FieldValue )
'----------------------------------------------------------------------------

        Dim strLookUpTable
        Dim objConn1, objRs1

        ' Strip uot the name of the lookup table
        strLookUpTable = left(FieldName, instr(Ucase(FieldName), "_ID") - 1)

        'open connection to load the values
        call MakeConn(objConn1, DATABASE)

        ' fetch the record
        call MakeRs_add(objRs1,objConn1,"SELECT * FROM " & strLookUpTable &  " WHERE " & FieldName & "=" & FieldValue )

        ' give the description back
         GetDescription = objRs1(1)

        ' exception, if project gives back back code and description
        if ucase(FieldName) = "PROJECTS_ID" then
                        GetDescription = objRs1(1) & " : " & objRs1(2)
        End if

End Function

'----------------------------------------------------------------------------
Function CutoffDate( strPeriod, strMonth, strYear, strType )
'----------------------------------------------------------------------------
'        strType can be "begin" or "end"
'        begin:        the date returned is set and the first day of the period
'        end:        the date returned is set and the last day of the period
        Dim  aDaysInMonth
        aDaysInMonth =  Array(31,28,31,30,31,30,31,31,30,31,30,31)

        ' calc the cutoff date based on the input parameter
        if strPeriod = "1" Then
                If strType = "end" Then
                        CutoffDate = CDate( "15/" & strMonth & "/" & strYear)
                Else
                        CutoffDate = CDate( "1/" & strMonth & "/" & strYear)
                End If
        else
                If strType = "end" Then 
                        CutoffDate = CDate( aDaysInMonth( strMonth - 1 ) & "/" & strMonth & "/" & strYear)
                Else
                        CutoffDate = CDate( "16" & "/" & strMonth & "/" & strYear)
                End If
        End if

End Function

' ------------------------------------------------------
Sub SelectMonths()
        Dim i
        ' elenco dei mesi con default il corrente
        For i = 1 to 12
                if month(now()) = i then
                        response.write("<option value=" & i & " selected >" & MonthName(i) & "</option>")
                else
                         response.write("<option value=" & i & ">" & MonthName(i) & "</option>")
                end if
        Next
End Sub

' ------------------------------------------------------
Sub SelectYears()
        Dim i
        For i = FIRST_YEAR to LAST_YEAR
        ' elenco di anni con default quello corrente
                if year(now()) = i then
                        response.write("<option value=" & i & " selected >" & i & "</option>")
                else
                        response.write("<option value=" & i & ">" & i & "</option>")
                end if
        Next
End Sub

%>


