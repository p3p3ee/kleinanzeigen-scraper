#!/bin/bash
# setup_mac.sh - Setup Script für Kleinanzeigen Scraper auf macOS
# 
# Verwendung: bash setup_mac.sh
# 
# Dieses Script installiert automatisch alle Abhängigkeiten und richtet
# den Kleinanzeigen Scraper mit WhatsApp-Benachrichtigungen ein.

set -e  # Exit bei Fehlern

# Farben für Output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funktionen
print_header() {
    echo -e "${CYAN}"
    echo "██╗  ██╗██╗     ███████╗██╗███╗   ██╗ █████╗ ███╗   ██╗███████╗███████╗██╗ ██████╗ ███████╗███╗   ██╗"
    echo "██║ ██╔╝██║     ██╔════╝██║████╗  ██║██╔══██╗████╗  ██║╚══███╔╝██╔════╝██║██╔════╝ ██╔════╝████╗  ██║"
    echo "█████╔╝ ██║     █████╗  ██║██╔██╗ ██║███████║██╔██╗ ██║  ███╔╝ █████╗  ██║██║  ███╗█████╗  ██╔██╗ ██║"
    echo "██╔═██╗ ██║     ██╔══╝  ██║██║╚██╗██║██╔══██║██║╚██╗██║ ███╔╝  ██╔══╝  ██║██║   ██║██╔══╝  ██║╚██╗██║"
    echo "██║  ██╗███████╗███████╗██║██║ ╚████║██║  ██║██║ ╚████║███████╗███████╗██║╚██████╔╝███████╗██║ ╚████║"
    echo "╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝"
    echo
    echo "                    🔍 SCRAPER SETUP - macOS VERSION 🍎"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

install_homebrew() {
    print_step "Prüfe Homebrew Installation..."
    
    if check_command brew; then
        print_success "Homebrew ist bereits installiert"
        brew --version
    else
        print_step "Installiere Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Homebrew zum PATH hinzufügen
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        print_success "Homebrew erfolgreich installiert"
    fi
}

install_python() {
    print_step "Prüfe Python Installation..."
    
    if check_command python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        MAJOR_VERSION=$(echo $PYTHON_VERSION | cut -d'.' -f1)
        MINOR_VERSION=$(echo $PYTHON_VERSION | cut -d'.' -f2)
        
        if [[ $MAJOR_VERSION -eq 3 && $MINOR_VERSION -ge 7 ]]; then
            print_success "Python $PYTHON_VERSION ist verfügbar"
        else
            print_warning "Python $PYTHON_VERSION ist zu alt (benötigt 3.7+)"
            install_python_via_brew
        fi
    else
        print_step "Python nicht gefunden. Installiere über Homebrew..."
        install_python_via_brew
    fi
}

install_python_via_brew() {
    brew install python@3.11
    print_success "Python 3.11 installiert"
}

setup_virtual_environment() {
    print_step "Erstelle Python Virtual Environment..."
    
    python3 -m venv venv
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    print_success "Virtual Environment erstellt und aktiviert"
}

install_python_dependencies() {
    print_step "Installiere Python-Abhängigkeiten..."
    
    pip install -r requirements.txt
    
    print_success "Python-Abhängigkeiten installiert"
}

create_launcher_script() {
    print_step "Erstelle Launcher-Script..."
    
    cat > launch_scraper.sh << 'EOF'
#!/bin/bash
# Launcher Script für Kleinanzeigen Scraper

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Starte Kleinanzeigen Scraper..."

# Ins Projektverzeichnis wechseln
cd "$SCRIPT_DIR" || {
    echo "❌ Projektverzeichnis nicht gefunden: $SCRIPT_DIR"
    exit 1
}

# Virtual Environment aktivieren
if [[ -f "venv/bin/activate" ]]; then
    source venv/bin/activate
    echo "✅ Virtual Environment aktiviert"
else
    echo "❌ Virtual Environment nicht gefunden"
    exit 1
fi

# GUI starten
if [[ -f "gui_starter.py" ]]; then
    echo "🚀 Starte GUI..."
    python gui_starter.py
else
    echo "⚠️ GUI-Script nicht gefunden"
    exit 1
fi
EOF

    chmod +x launch_scraper.sh
    
    print_success "Launcher-Script erstellt: ./launch_scraper.sh"
}

create_desktop_shortcut() {
    print_step "Erstelle Desktop-Verknüpfung..."
    
    DESKTOP_DIR="$HOME/Desktop"
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    APP_NAME="Kleinanzeigen Scraper"
    
    cat > "$DESKTOP_DIR/$APP_NAME.command" << EOF
#!/bin/bash
cd "$SCRIPT_DIR"
source venv/bin/activate
python gui_starter.py
EOF

    chmod +x "$DESKTOP_DIR/$APP_NAME.command"
    
    print_success "Desktop-Verknüpfung erstellt: $APP_NAME.command"
}

run_tests() {
    print_step "Führe System-Tests durch..."
    
    # Python-Test
    if python3 -c "import requests, tkinter; print('✅ Module verfügbar')" 2>/dev/null; then
        print_success "Python-Module-Test erfolgreich"
    else
        print_error "Python-Module-Test fehlgeschlagen"
        return 1
    fi
    
    # GUI-Test
    if python3 -c "import tkinter; root = tkinter.Tk(); root.destroy(); print('✅ GUI verfügbar')" 2>/dev/null; then
        print_success "GUI-Test erfolgreich"
    else
        print_error "GUI-Test fehlgeschlagen"
    fi
    
    return 0
}

show_completion_info() {
    print_step "Setup abgeschlossen! 🎉"
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    🎉 SETUP ERFOLGREICH! 🎉                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    echo "📍 Projektverzeichnis: $SCRIPT_DIR"
    echo ""
    echo "🚀 NÄCHSTE SCHRITTE:"
    echo ""
    echo "1. 🖥️ GUI starten:"
    echo "   ./launch_scraper.sh"
    echo "   oder doppelklick auf 'Kleinanzeigen Scraper.command'"
    echo ""
    echo "2. 📱 WhatsApp konfigurieren (optional):"
    echo "   source venv/bin/activate"
    echo "   python src/whatsapp_setup_guide.py"
    echo ""
    echo "3. 🔔 Ersten Alarm erstellen:"
    echo "   - GUI öffnen"
    echo "   - 'WhatsApp Alarme' klicken"
    echo "   - Neuen Alarm konfigurieren"
    echo ""
    echo -e "${YELLOW}⚠️  WICHTIG: Verwenden Sie den Scraper verantwortungsbewusst!${NC}"
    echo "   - Halten Sie Intervalle moderat (>5 Minuten)"
    echo "   - Respektieren Sie robots.txt"
    echo "   - Nutzen Sie Daten nur für private Zwecke"
}

# Hauptfunktion
main() {
    # Header anzeigen
    print_header
    
    echo "Dieses Script installiert automatisch:"
    echo "✅ Homebrew (falls nicht vorhanden)"
    echo "✅ Python 3.11+"
    echo "✅ Alle benötigten Python-Pakete"
    echo "✅ Kleinanzeigen Scraper"
    echo "✅ Grafische Benutzeroberfläche"
    echo ""
    
    read -p "Möchten Sie fortfahren? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup abgebrochen"
        exit 1
    fi
    
    echo ""
    print_step "Starte Installation..."
    
    # Installationsschritte
    install_homebrew
    install_python
    setup_virtual_environment
    install_python_dependencies
    create_launcher_script
    create_desktop_shortcut
    
    # Tests und Abschluss
    if run_tests; then
        show_completion_info
    else
        print_error "Setup-Tests fehlgeschlagen. Bitte überprüfen Sie die Installation."
        exit 1
    fi
}

# Script starten
main "$@"