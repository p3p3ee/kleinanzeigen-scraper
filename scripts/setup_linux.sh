#!/bin/bash
# setup_linux.sh - Setup Script für Kleinanzeigen Scraper auf Linux
# 
# Verwendung: bash setup_linux.sh
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
    echo "                    🔍 SCRAPER SETUP - LINUX VERSION 🐧"
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

detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo $ID
    elif [[ -f /etc/redhat-release ]]; then
        echo "rhel"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

install_system_dependencies() {
    print_step "Installiere System-Abhängigkeiten..."
    
    DISTRO=$(detect_distro)
    print_step "Erkannte Distribution: $DISTRO"
    
    case $DISTRO in
        ubuntu|debian)
            print_step "Aktualisiere Paketlisten..."
            sudo apt-get update
            
            print_step "Installiere erforderliche Pakete..."
            sudo apt-get install -y \
                python3 \
                python3-pip \
                python3-venv \
                python3-tk \
                python3-dev \
                build-essential \
                curl \
                wget \
                git \
                libxml2-dev \
                libxslt1-dev \
                zlib1g-dev \
                libjpeg-dev \
                libpng-dev
            ;;
        
        fedora|rhel|centos)
            print_step "Installiere erforderliche Pakete..."
            if check_command dnf; then
                sudo dnf install -y \
                    python3 \
                    python3-pip \
                    python3-tkinter \
                    python3-devel \
                    gcc \
                    gcc-c++ \
                    make \
                    curl \
                    wget \
                    git \
                    libxml2-devel \
                    libxslt-devel \
                    zlib-devel \
                    libjpeg-devel \
                    libpng-devel
            else
                sudo yum install -y \
                    python3 \
                    python3-pip \
                    tkinter \
                    python3-devel \
                    gcc \
                    gcc-c++ \
                    make \
                    curl \
                    wget \
                    git
            fi
            ;;
        
        arch|manjaro)
            print_step "Installiere erforderliche Pakete..."
            sudo pacman -Sy --noconfirm \
                python \
                python-pip \
                tk \
                base-devel \
                curl \
                wget \
                git \
                libxml2 \
                libxslt
            ;;
        
        opensuse*)
            print_step "Installiere erforderliche Pakete..."
            sudo zypper install -y \
                python3 \
                python3-pip \
                python3-tk \
                python3-devel \
                gcc \
                gcc-c++ \
                make \
                curl \
                wget \
                git \
                libxml2-devel \
                libxslt-devel
            ;;
        
        *)
            print_warning "Unbekannte Distribution: $DISTRO"
            print_warning "Bitte installieren Sie manuell: python3, python3-pip, python3-venv, python3-tk"
            ;;
    esac
    
    print_success "System-Abhängigkeiten installiert"
}

check_python() {
    print_step "Prüfe Python Installation..."
    
    if check_command python3; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
        MAJOR_VERSION=$(echo $PYTHON_VERSION | cut -d'.' -f1)
        MINOR_VERSION=$(echo $PYTHON_VERSION | cut -d'.' -f2)
        
        if [[ $MAJOR_VERSION -eq 3 && $MINOR_VERSION -ge 7 ]]; then
            print_success "Python $PYTHON_VERSION ist verfügbar"
            return 0
        else
            print_error "Python $PYTHON_VERSION ist zu alt (benötigt 3.7+)"
            return 1
        fi
    else
        print_error "Python3 nicht gefunden"
        return 1
    fi
}

setup_virtual_environment() {
    print_step "Erstelle Python Virtual Environment..."
    
    if ! python3 -m venv venv; then
        print_error "Fehler beim Erstellen des Virtual Environment"
        return 1
    fi
    
    source venv/bin/activate
    
    # Upgrade pip
    pip install --upgrade pip
    
    print_success "Virtual Environment erstellt und aktiviert"
    return 0
}

install_python_dependencies() {
    print_step "Installiere Python-Abhängigkeiten..."
    
    if ! pip install -r requirements.txt; then
        print_error "Fehler beim Installieren der Python-Abhängigkeiten"
        return 1
    fi
    
    print_success "Python-Abhängigkeiten installiert"
    return 0
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

create_desktop_entry() {
    print_step "Erstelle Desktop-Eintrag..."
    
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    DESKTOP_FILE="$HOME/.local/share/applications/kleinanzeigen-scraper.desktop"
    
    # Erstelle .local/share/applications falls nicht vorhanden
    mkdir -p "$HOME/.local/share/applications"
    
    cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=Kleinanzeigen Scraper
Comment=Intelligenter Scraper für Dienstleistungsanzeigen mit WhatsApp-Benachrichtigungen
Exec=$SCRIPT_DIR/launch_scraper.sh
Icon=applications-internet
Terminal=false
Type=Application
Categories=Network;Development;
StartupNotify=true
EOF

    chmod +x "$DESKTOP_FILE"
    
    # Desktop-Datei auch auf Desktop kopieren falls Desktop-Ordner existiert
    if [[ -d "$HOME/Desktop" ]]; then
        cp "$DESKTOP_FILE" "$HOME/Desktop/"
        chmod +x "$HOME/Desktop/kleinanzeigen-scraper.desktop"
        print_success "Desktop-Verknüpfung erstellt"
    fi
    
    print_success "Desktop-Eintrag erstellt"
}

configure_firewall() {
    print_step "Konfiguriere Firewall-Einstellungen..."
    
    # Prüfe ob UFW aktiv ist
    if check_command ufw && sudo ufw status | grep -q "Status: active"; then
        print_warning "UFW Firewall ist aktiv"
        echo "Der Scraper benötigt Internetzugang für:"
        echo "- Kleinanzeigen-Websites"
        echo "- WhatsApp-APIs"
        echo "- Python-Updates"
        
        read -p "Möchten Sie Python automatisch zur Firewall-Ausnahmeliste hinzufügen? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo ufw allow out 80
            sudo ufw allow out 443
            sudo ufw allow out 53
            print_success "Firewall-Regeln für HTTP/HTTPS hinzugefügt"
        fi
    else
        print_success "Keine aktive Firewall gefunden oder UFW nicht installiert"
    fi
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
    
    # GUI-Test (nur wenn DISPLAY gesetzt ist)
    if [[ -n "$DISPLAY" ]]; then
        if python3 -c "import tkinter; root = tkinter.Tk(); root.destroy(); print('✅ GUI verfügbar')" 2>/dev/null; then
            print_success "GUI-Test erfolgreich"
        else
            print_warning "GUI-Test fehlgeschlagen - möglicherweise läuft Linux ohne GUI"
        fi
    else
        print_warning "DISPLAY nicht gesetzt - GUI-Test übersprungen"
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
    echo "   oder klick auf Desktop-Symbol"
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
    echo "🛠️ KOMMANDOZEILEN-BEFEHLE:"
    echo "   # Virtual Environment aktivieren:"
    echo "   source venv/bin/activate"
    echo ""
    echo "   # Direkt GUI starten:"
    echo "   python gui_starter.py"
    echo ""
    echo "   # Beispiele ausführen:"
    echo "   python examples/basic_usage.py"
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
    echo "✅ System-Abhängigkeiten (Python, tkinter, etc.)"
    echo "✅ Python Virtual Environment"
    echo "✅ Alle benötigten Python-Pakete"
    echo "✅ Kleinanzeigen Scraper"
    echo "✅ Grafische Benutzeroberfläche"
    echo "✅ Desktop-Integration"
    echo ""
    
    # Prüfe ob als Root ausgeführt
    if [[ $EUID -eq 0 ]]; then
        print_error "Führen Sie dieses Script nicht als root aus!"
        print_error "Verwenden Sie einen normalen Benutzer (sudo wird automatisch verwendet wenn nötig)"
        exit 1
    fi
    
    read -p "Möchten Sie fortfahren? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Setup abgebrochen"
        exit 1
    fi
    
    echo ""
    print_step "Starte Installation..."
    
    # Installationsschritte
    install_system_dependencies
    
    if ! check_python; then
        print_error "Python-Installation fehlgeschlagen oder zu alt"
        exit 1
    fi
    
    if ! setup_virtual_environment; then
        exit 1
    fi
    
    if ! install_python_dependencies; then
        exit 1
    fi
    
    create_launcher_script
    create_desktop_entry
    configure_firewall
    
    # Tests und Abschluss
    if run_tests; then
        show_completion_info
    else
        print_error "Setup-Tests fehlgeschlagen. Installation möglicherweise unvollständig."
        exit 1
    fi
}

# Script starten
main "$@"