
@echo off
setlocal enableextensions enabledelayedexpansion

REM 1) Trova o installa Python
set PYTHON_EXE=
for %%I in (python.exe) do set PYTHON_EXE=%%~$PATH:I

if "%PYTHON_EXE%"=="" (
  echo Python non trovato. Provo ad installare con winget...
  winget --version >nul 2>&1
  if not errorlevel 1 (
    winget install -e --id Python.Python.3 --silent --accept-source-agreements --accept-package-agreements
  ) else (
    echo winget non disponibile. Scarico l'installer da python.org...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$u='https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe';" ^
      "$o='$env:TEMP\\pyinst.exe';" ^
      "(New-Object Net.WebClient).DownloadFile($u,$o);" ^
      "Start-Process -FilePath $o -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1 Include_test=0' -Wait"
  )
)

REM Aggiorna variabile con eventuale nuovo path
set PYTHON_EXE=
for %%I in (python.exe) do set PYTHON_EXE=%%~$PATH:I
if "%PYTHON_EXE%"=="" (
  if exist "%ProgramFiles%\\Python312\\python.exe" set PYTHON_EXE="%ProgramFiles%\\Python312\\python.exe"
)
if "%PYTHON_EXE%"=="" (
  echo Impossibile trovare Python dopo l'installazione.
  pause
  exit /b 1
)

REM 2) Crea venv se manca
if not exist .venv (
  %PYTHON_EXE% -m venv .venv
)
call .venv\Scripts\activate

REM 3) Installa dipendenze e avvia
python -m pip install --upgrade pip
pip install -r requirements.txt

set /p PLCIP=Inserisci l'IP del PLC: 
if "!PLCIP!"=="" (
  echo IP non valido.
  pause
  exit /b 2
)

python main.py --ip !PLCIP!
pause
