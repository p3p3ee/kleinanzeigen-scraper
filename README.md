# 🔍 Kleinanzeigen Scraper

<div align="center">

![Python](https://img.shields.io/badge/python-v3.7+-blue.svg)
![Platform](https://img.shields.io/badge/platform-windows%20%7C%20macos%20%7C%20linux-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)
![GitHub release](https://img.shields.io/github/release/p3p3ee/kleinanzeigen-scraper.svg)
![GitHub stars](https://img.shields.io/github/stars/p3p3ee/kleinanzeigen-scraper.svg)

**Ein intelligenter Scraper für Dienstleistungsanzeigen mit WhatsApp-Benachrichtigungen**

[Installation](#installation) • [Features](#features) • [Verwendung](#verwendung) • [Contributing](#contributing)

</div>

## 🚀 Features

### ✨ Hauptfunktionen
- 🔍 **Automatisches Scraping** von Kleinanzeigen-Dienstleistungen
- 🎯 **Intelligente Kategorisierung** (Handwerk, IT, Reinigung, etc.)
- 📱 **WhatsApp-Benachrichtigungen** für neue Anzeigen
- 🖥️ **Grafische Benutzeroberfläche** (GUI)
- 📊 **Marktanalyse** und Statistiken
- 💾 **Export** in JSON, CSV, TXT
- ⚙️ **Erweiterte Filter** (Preis, Ort, Kategorie, Technologie)

### 📱 WhatsApp-Integration
- 🆓 **Manual Mode** (Kostenlos)
- 💼 **Twilio API** (Professionell)
- ⚡ **WHAPI.cloud** (Einfach)
- 💰 **UltraMsg** (Günstig)

### 🎨 Benutzeroberfläche
- 🖱️ **Intuitive GUI** mit tkinter
- 🔄 **Live-Updates** während Scraping
- 📋 **Alarm-Management** für kontinuierliche Überwachung
- 🎛️ **Konfigurierbare Einstellungen**

## 🚀 Installation

### 📦 Schnellinstallation

#### Windows
```powershell
# PowerShell als Administrator öffnen
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\scripts\setup_windows.ps1
```

#### macOS
```bash
# Terminal öffnen
bash scripts/setup_mac.sh
```

#### Linux (Ubuntu/Debian)
```bash
# Terminal öffnen
bash scripts/setup_linux.sh
```

### 🔧 Manuelle Installation

1. **Repository klonen**
```bash
git clone https://github.com/p3p3ee/kleinanzeigen-scraper.git
cd kleinanzeigen-scraper
```

2. **Virtual Environment erstellen**
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# oder
venv\Scripts\activate     # Windows
```

3. **Abhängigkeiten installieren**
```bash
pip install -r requirements.txt
```

4. **Anwendung starten**
```bash
python scripts/gui_starter.py
```

## 🎯 Verwendung

### 🖥️ GUI starten
```bash
python scripts/gui_starter.py
```

### 📱 WhatsApp konfigurieren
```bash
python src/whatsapp_setup_guide.py
```

### 🔍 Beispiel-Suche
1. GUI öffnen
2. Suchbegriff eingeben (z.B. "Webentwicklung")
3. Filter setzen (Ort, Kategorie, Preis)
4. "Scraping starten" klicken
5. Ergebnisse exportieren oder analysieren

### 🔔 WhatsApp-Alarme
1. "WhatsApp Alarme" Button klicken
2. API konfigurieren (Twilio, WHAPI, etc.)
3. Neuen Alarm erstellen
4. Monitoring starten
5. Automatische Benachrichtigungen erhalten

## 🛡️ Verantwortungsvolle Nutzung

⚠️ **Wichtige Hinweise:**
- Halten Sie Scraping-Intervalle moderat (>5 Minuten)
- Respektieren Sie robots.txt der Websites
- Nutzen Sie Daten nur für private Zwecke
- Befolgen Sie die Nutzungsbedingungen der Plattformen
- Vermeiden Sie Spam bei WhatsApp-Nachrichten

## 🔧 Systemanforderungen

- **Python**: 3.7 oder höher
- **Betriebssystem**: Windows 10+, macOS 10.14+, Linux (Ubuntu 18.04+)
- **RAM**: Mindestens 512 MB
- **Festplatte**: 100 MB freier Speicher
- **Internet**: Aktive Verbindung erforderlich

## 🤝 Contributing

Beiträge sind willkommen! Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Details.

### 🐛 Bug Reports
Verwenden Sie die [Issue-Vorlagen](.github/ISSUE_TEMPLATE/) für Bug Reports.

### 💡 Feature Requests
Schlagen Sie neue Features über GitHub Issues vor.

## 📄 Lizenz

Dieses Projekt steht unter der [MIT License](LICENSE).

## 🙏 Danksagungen

- **BeautifulSoup** - HTML-Parsing
- **Requests** - HTTP-Bibliothek
- **tkinter** - GUI-Framework
- **Twilio** - WhatsApp Business API

## 📞 Support

- 💬 **Discussions**: [GitHub Discussions](https://github.com/p3p3ee/kleinanzeigen-scraper/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/p3p3ee/kleinanzeigen-scraper/issues)

---

<div align="center">

**Made with ❤️ by [p3p3ee](https://github.com/p3p3ee)**

[⬆ Back to top](#-kleinanzeigen-scraper)

</div>