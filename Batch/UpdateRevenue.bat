@echo off
REM =============================================
REM Aggiornamento automatico Revenue e ProjectEconomics
REM 1. REV3_HoursCostAndRevenueUpdate (calcola CostAmount, RevenueAmount)
REM 2. SPcontrolloProgetti (salva in ProjectEconomics)
REM =============================================

REM Configurazione
set SERVER=95.110.230.190
set DATABASE=MSSql12155
set USERNAME=MSSql12155
set PASSWORD=50a715f9
set LOGDIR=D:\TimereportJobs\Logs
set LOGFILE=%LOGDIR%\UpdateRevenue.log

REM Crea directory log se non esiste
if not exist "%LOGDIR%" mkdir "%LOGDIR%"

REM ? SOVRASCRIVE il log (usa > invece di >>)
echo ========================================== > %LOGFILE%
echo [%date% %time%] INIZIO AGGIORNAMENTO >> %LOGFILE%
echo ========================================== >> %LOGFILE%

REM STEP 1: Aggiorna Hours (ultimi 7 giorni)
echo [%date% %time%] Step 1/2: Aggiornamento Hours... >> %LOGFILE%
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -Q "DECLARE @fromDate DATE = DATEADD(day, -7, GETDATE()); EXEC [MSSql12155].[REV3_HoursCostAndRevenueUpdate] @fromDate = @fromDate, @Project_id = NULL, @Person_id = NULL, @overwrite = 1" >> %LOGFILE% 2>&1
if errorlevel 1 goto error

REM STEP 2: Salva in ProjectEconomics
echo [%date% %time%] Step 2/2: Salvataggio ProjectEconomics... >> %LOGFILE%
sqlcmd -S %SERVER% -d %DATABASE% -U %USERNAME% -P %PASSWORD% -Q "EXEC [MSSql12155].[SPcontrolloProgetti]" >> %LOGFILE% 2>&1
if errorlevel 1 goto error

REM Successo	
echo [%date% %time%] COMPLETATO CON SUCCESSO >> %LOGFILE%
echo ========================================== >> %LOGFILE%
exit /b 0

:error
echo [%date% %time%] ERRORE - Elaborazione fallita >> %LOGFILE%
echo ========================================== >> %LOGFILE%
exit /b 1