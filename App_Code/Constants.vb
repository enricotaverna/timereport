Imports Microsoft.VisualBasic

Public Class MyConstants

    Dim time As DateTime = DateTime.Now

    Public Shared Last_year As Integer = Now.Year
    Public Shared First_year As Integer = Last_year - 4

    ' ------ Auth level --------
    Public Shared AUTH_ADMIN As Integer = 5 ' aggiornamenti massivi
    Public Shared AUTH_MANAGER As Integer = 4 ' Manager
    Public Shared AUTH_TEAMLEADER As Integer = 3 ' vede solo sè stesso
    Public Shared AUTH_EXTERNAL As Integer = 1 ' vede solo sè stesso
    Public Shared AUTH_EMPLOYEE As Integer = 2 ' vede solo sè stesso

    Public Shared aDaysName() As String = {"Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"}

    Public Shared DTHoliday As New System.Data.DataTable

End Class
