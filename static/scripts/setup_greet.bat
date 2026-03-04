@echo off
:: This ensures the script runs from the directory it is located in
cd /d "%~dp0"

echo ==========================================
echo   DHRUV_VAULT: INITIALIZING SYSTEM
echo ==========================================

:: Force administrative check to avoid "Publisher" blocks
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Please Right-Click and 'Run as Administrator'
    pause
    exit /b
)

:: 1. Verify Python Installation
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Python not detected. Opening download page...
    start https://www.python.org/downloads/
    exit /b
)

:: 2. Create Virtual Environment
echo [+] Creating Isolated Environment...
python -m venv venv

:: 3. Install Requirements
echo [+] Installing Vocal Engine (pyttsx3)...
.\venv\Scripts\python.exe -m pip install pyttsx3 --quiet

:: 4. Create Desktop Shortcut via PowerShell (more reliable)
echo [+] Finalizing Desktop Integration...
set SCRIPT_PATH=%cd%\greet_system.py
powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut([System.IO.Path]::Combine([Environment]::GetFolderPath('Desktop'), 'Greet_Boss.lnk')); $s.TargetPath = '%cd%\venv\Scripts\pythonw.exe'; $s.Arguments = '%SCRIPT_PATH%'; $s.Save()"

echo.
echo ==========================================
echo   SUCCESS: Greet_Boss is ready on Desktop
echo ==========================================
pause