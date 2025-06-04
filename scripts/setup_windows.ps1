# setup_windows.ps1 - Setup Script für Kleinanzeigen Scraper auf Windows
# 
# Verwendung: 
# 1. PowerShell als Administrator öffnen
# 2. Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# 3. .\scripts\setup_windows.ps1
#
# Dieses Script installiert automatisch alle Abhängigkeiten und richtet
# den Kleinanzeigen Scraper mit WhatsApp-Benachrichtigungen ein.

param(
    [switch]$SkipChocolatey,
    [switch]$SkipPython,
    [string]$InstallPath = "$env:USERPROFILE\kleinanzeigen-scraper"
)

# Globale Variablen
$ErrorActionPreference = "Continue"  # Geändert von "Stop" für bessere Fehlerbehandlung
$ProgressPreference = "SilentlyContinue"

# Funktionen
function Write-Header {
    Write-Host ""
    Write-Host "██╗  ██╗██╗     ███████╗██╗███╗   ██╗ █████╗ ███╗   ██╗███████╗███████╗██╗ ██████╗ ███████╗███╗   ██╗" -ForegroundColor Cyan
    Write-Host "██║ ██╔╝██║     ██╔════╝██║████╗  ██║██╔══██╗████╗  ██║╚══███╔╝██╔════╝██║██╔════╝ ██╔════╝████╗  ██║" -ForegroundColor Cyan
    Write-Host "█████╔╝ ██║     █████╗  ██║██╔██╗ ██║███████║██╔██╗ ██║  ███╔╝ █████╗  ██║██║  ███╗█████╗  ██╔██╗ ██║" -ForegroundColor Cyan
    Write-Host "██╔═██╗ ██║     ██╔══╝  ██║██║╚██╗██║██╔══██║██║╚██╗██║ ███╔╝  ██╔══╝  ██║██║   ██║██╔══╝  ██║╚██╗██║" -ForegroundColor Cyan
    Write-Host "██║  ██╗███████╗███████╗██║██║ ╚████║██║  ██║██║ ╚████║███████╗███████╗██║╚██████╔╝███████╗██║ ╚████║" -ForegroundColor Cyan
    Write-Host "╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "                    🔍 SCRAPER SETUP - WINDOWS VERSION 🪟" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param([string]$Message)
    Write-Host "[STEP] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Install-Chocolatey {
    if ($SkipChocolatey) {
        Write-Warning "Chocolatey-Installation übersprungen"
        return $true
    }

    Write-Step "Prüfe Chocolatey Installation..."
    
    if (Test-Command "choco") {
        Write-Success "Chocolatey ist bereits installiert"
        choco --version
        return $true
    }
    else {
        Write-Step "Installiere Chocolatey..."
        
        if (-not (Test-Administrator)) {
            Write-Warning "Chocolatey-Installation benötigt Administratorrechte"
            Write-Warning "Führen Sie das Script als Administrator aus oder verwenden Sie -SkipChocolatey"
            return $false
        }
        
        try {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            
            # PATH aktualisieren
            $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH", "User")
            
            if (Test-Command "choco") {
                Write-Success "Chocolatey erfolgreich installiert"
                return $true
            }
            else {
                Write-Error "Chocolatey-Installation fehlgeschlagen"
                return $false
            }
        }
        catch {
            Write-Error "Fehler bei Chocolatey-Installation: $($_.Exception.Message)"
            return $false
        }
    }
}

function Install-Python {
    if ($SkipPython) {
        Write-Warning "Python-Installation übersprungen"
        return $true
    }

    Write-Step "Prüfe Python Installation..."
    
    if (Test-Command "python") {
        try {
            $pythonVersion = python --version 2>&1
            if ($pythonVersion -match "Python 3\.([7-9]|1[0-9])") {
                Write-Success "Python ist verfügbar: $pythonVersion"
                return $true
            }
            else {
                Write-Warning "Python-Version ist zu alt: $pythonVersion"
            }
        }
        catch {
            Write-Warning "Fehler beim Prüfen der Python-Version"
        }
    }
    
    Write-Step "Installiere Python 3.11..."
    
    if (Test-Command "choco") {
        try {
            choco install python311 -y
            Write-Success "Python über Chocolatey installiert"
        }
        catch {
            Write-Warning "Chocolatey-Installation fehlgeschlagen, versuche direkten Download..."
            Install-PythonDirect
        }
    }
    else {
        Install-PythonDirect
    }
    
    # PATH aktualisieren
    $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [Environment]::GetEnvironmentVariable("PATH", "User")
    
    # Python-Pfad hinzufügen falls nötig
    $pythonPaths = @(
        "$env:USERPROFILE\AppData\Local\Programs\Python\Python311",
        "$env:USERPROFILE\AppData\Local\Programs\Python\Python311\Scripts"
    )
    
    foreach ($path in $pythonPaths) {
        if (Test-Path $path) {
            if ($env:PATH -notlike "*$path*") {
                $env:PATH += ";$path"
                [Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
            }
        }
    }
    
    # Testen
    if (Test-Command "python") {
        $version = python --version 2>&1
        Write-Success "Python erfolgreich installiert: $version"
        return $true
    }
    else {
        Write-Error "Python-Installation fehlgeschlagen"
        return $false
    }
}

function Install-PythonDirect {
    Write-Step "Lade Python direkt herunter..."
    
    $pythonUrl = "https://www.python.org/ftp/python/3.11.8/python-3.11.8-amd64.exe"
    $pythonInstaller = "$env:TEMP\python-installer.exe"
    
    try {
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller
        Write-Step "Installiere Python..."
        Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet", "InstallAllUsers=0", "PrependPath=1" -Wait
        Remove-Item $pythonInstaller -ErrorAction SilentlyContinue
        Write-Success "Python direkt installiert"
    }
    catch {
        Write-Error "Direkter Python-Download fehlgeschlagen: $($_.Exception.Message)"
    }
}

function Setup-VirtualEnvironment {
    Write-Step "Erstelle Python Virtual Environment..."
    
    try {
        python -m venv venv
        
        # Virtual Environment aktivieren
        & ".\venv\Scripts\Activate.ps1"
        
        # Upgrade pip
        python -m pip install --upgrade pip
        
        Write-Success "Virtual Environment erstellt und aktiviert"
        return $true
    }
    catch {
        Write-Error "Fehler beim Erstellen des Virtual Environment: $($_.Exception.Message)"
        return $false
    }
}

function Install-PythonDependencies {
    Write-Step "Installiere Python-Basis-Abhängigkeiten..."
    
    try {
        # Installiere nur core dependencies für den Test
        python -m pip install requests beautifulsoup4 lxml
        Write-Success "Basis-Abhängigkeiten installiert"
        return $true
    }
    catch {
        Write-Warning "Einige Abhängigkeiten konnten nicht installiert werden: $($_.Exception.Message)"
        Write-Warning "Diese werden beim ersten Start nachinstalliert"
        return $true
    }
}

function Create-LauncherScript {
    Write-Step "Erstelle Launcher-Script..."
    
    $scriptContent = @"
@echo off
cd /d "%~dp0"
echo 🔍 Starte Kleinanzeigen Scraper...

if not exist "venv\Scripts\activate.bat" (
    echo ❌ Virtual Environment nicht gefunden
    pause
    exit /b 1
)

call venv\Scripts\activate.bat
echo ✅ Virtual Environment aktiviert

REM Installiere alle Abhängigkeiten falls requirements.txt existiert
if exist "requirements.txt" (
    echo 📦 Installiere alle Abhängigkeiten...
    python -m pip install -r requirements.txt
)

if not exist "gui_starter.py" (
    echo ⚠️ GUI-Script nicht gefunden
    pause
    exit /b 1
)

echo 🚀 Starte GUI...
python gui_starter.py

pause
"@

    try {
        Set-Content -Path "launch_scraper.bat" -Value $scriptContent -Encoding UTF8
        Write-Success "Launcher-Script erstellt: launch_scraper.bat"
        return $true
    }
    catch {
        Write-Error "Fehler beim Erstellen des Launcher-Scripts: $($_.Exception.Message)"
        return $false
    }
}

function Create-DesktopShortcut {
    Write-Step "Erstelle Desktop-Verknüpfung..."
    
    try {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\Kleinanzeigen Scraper.lnk")
        $Shortcut.TargetPath = "$PWD\launch_scraper.bat"
        $Shortcut.WorkingDirectory = $PWD
        $Shortcut.Description = "Kleinanzeigen Scraper mit WhatsApp-Benachrichtigungen"
        $Shortcut.Save()
        
        Write-Success "Desktop-Verknüpfung erstellt: Kleinanzeigen Scraper.lnk"
        return $true
    }
    catch {
        Write-Error "Fehler beim Erstellen der Desktop-Verknüpfung: $($_.Exception.Message)"
        return $false
    }
}

function Test-Installation {
    Write-Step "Führe System-Tests durch..."
    
    try {
        # Python-Test mit detaillierter Ausgabe
        Write-Step "Teste Python-Module..."
        
        $result = python -c @"
import sys
success = True
try:
    import requests
    print('✅ requests verfügbar')
except ImportError as e:
    print('❌ requests fehlt:', e)
    success = False

try:
    from bs4 import BeautifulSoup
    print('✅ beautifulsoup4 verfügbar')
except ImportError as e:
    print('❌ beautifulsoup4 fehlt:', e)
    success = False

try:
    import tkinter
    print('✅ tkinter verfügbar')
except ImportError as e:
    print('❌ tkinter fehlt:', e)
    success = False

if success:
    print('✅ Alle wichtigen Module verfügbar')
else:
    print('⚠️ Einige Module fehlen - werden beim ersten Start installiert')
"@ 2>&1
        
        Write-Host $result
        
        # GUI-Test
        $guiResult = python -c "import tkinter; root = tkinter.Tk(); root.destroy(); print('✅ GUI verfügbar')" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Success "GUI-Test erfolgreich"
        }
        else {
            Write-Warning "GUI-Test fehlgeschlagen (möglicherweise läuft Windows ohne GUI): $guiResult"
        }
        
        return $true
    }
    catch {
        Write-Warning "Fehler beim Testen: $($_.Exception.Message)"
        return $true  # Nicht kritisch, fortfahren
    }
}

function Show-CompletionInfo {
    Write-Step "Setup abgeschlossen! 🎉"
    
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    🎉 SETUP ERFOLGREICH! 🎉                  ║" -ForegroundColor Green
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "📍 Projektverzeichnis: $PWD"
    Write-Host ""
    Write-Host "🚀 NÄCHSTE SCHRITTE:"
    Write-Host ""
    Write-Host "1. 🖥️ GUI starten:"
    Write-Host "   .\launch_scraper.bat"
    Write-Host "   oder doppelklick auf 'Kleinanzeigen Scraper.lnk'"
    Write-Host ""
    Write-Host "2. 🔧 Manuell alle Abhängigkeiten installieren:"
    Write-Host "   .\venv\Scripts\Activate.ps1"
    Write-Host "   python -m pip install -r requirements.txt"
    Write-Host ""
    Write-Host "3. 📱 WhatsApp konfigurieren (optional):"
    Write-Host "   python src\whatsapp_setup_guide.py"
    Write-Host ""
    Write-Host "4. 🔔 Ersten Alarm erstellen:"
    Write-Host "   - GUI öffnen"
    Write-Host "   - Demo ausprobieren"
    Write-Host "   - Für WhatsApp-Alarme alle Module installieren"
    Write-Host ""
    Write-Host "💡 HINWEIS:" -ForegroundColor Yellow
    Write-Host "   Das Setup installiert nur die Basis-Module für den Test."
    Write-Host "   Beim ersten Start der GUI werden alle weiteren Abhängigkeiten"
    Write-Host "   automatisch installiert."
    Write-Host ""
    Write-Host "⚠️  WICHTIG: Verwenden Sie den Scraper verantwortungsbewusst!" -ForegroundColor Yellow
    Write-Host "   - Halten Sie Intervalle moderat (>5 Minuten)"
    Write-Host "   - Respektieren Sie robots.txt"
    Write-Host "   - Nutzen Sie Daten nur für private Zwecke"
}

# Hauptfunktion
function Main {
    # Header anzeigen
    Write-Header
    
    Write-Host "Dieses Script installiert automatisch:"
    Write-Host "✅ Chocolatey (falls nicht vorhanden)"
    Write-Host "✅ Python 3.11+"
    Write-Host "✅ Virtual Environment"
    Write-Host "✅ Basis Python-Pakete"
    Write-Host "✅ Kleinanzeigen Scraper"
    Write-Host "✅ Grafische Benutzeroberfläche"
    Write-Host ""
    Write-Host "💡 Weitere Abhängigkeiten werden beim ersten Start installiert"
    Write-Host ""
    
    $continue = Read-Host "Möchten Sie fortfahren? (y/N)"
    if ($continue -notmatch '^[Yy]$') {
        Write-Error "Setup abgebrochen"
        exit 1
    }
    
    Write-Host ""
    Write-Step "Starte Installation..."
    
    try {
        # Installationsschritte
        if (-not (Install-Chocolatey)) {
            Write-Warning "Chocolatey-Installation fehlgeschlagen, fahre trotzdem fort..."
        }
        
        if (-not (Install-Python)) {
            Write-Error "Python-Installation fehlgeschlagen"
            exit 1
        }
        
        if (-not (Setup-VirtualEnvironment)) {
            Write-Error "Virtual Environment Setup fehlgeschlagen"
            exit 1
        }
        
        if (-not (Install-PythonDependencies)) {
            Write-Warning "Einige Abhängigkeiten konnten nicht installiert werden, fahre trotzdem fort..."
        }
        
        Create-LauncherScript
        Create-DesktopShortcut
        
        # Tests und Abschluss
        Test-Installation
        Show-CompletionInfo
    }
    catch {
        Write-Error "Unerwarteter Fehler: $($_.Exception.Message)"
        exit 1
    }
}

# Script starten
Main