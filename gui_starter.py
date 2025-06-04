#!/usr/bin/env python3
"""
GUI Starter für Kleinanzeigen Scraper
====================================

Starter-Script für die grafische Benutzeroberfläche des Kleinanzeigen Scrapers.

Verwendung:
    python gui_starter.py

Features:
- Automatische Abhängigkeitsprüfung
- Demo-Modus falls Module fehlen
- Benutzerfreundliche Fehlermeldungen
- Cross-Platform Support
"""

import sys
import tkinter as tk
from tkinter import messagebox
import importlib.util
import subprocess

def check_dependencies():
    """Prüft ob alle Abhängigkeiten verfügbar sind"""
    missing_deps = []
    
    # Prüfe tkinter
    try:
        import tkinter
        import tkinter.ttk
    except ImportError:
        missing_deps.append("tkinter")
    
    # Prüfe requests
    try:
        import requests
    except ImportError:
        missing_deps.append("requests")
    
    # Prüfe beautifulsoup4
    try:
        from bs4 import BeautifulSoup
    except ImportError:
        missing_deps.append("beautifulsoup4")
    
    return missing_deps

def install_dependencies():
    """Versucht fehlende Abhängigkeiten zu installieren"""
    missing = check_dependencies()
    
    if missing:
        print("Fehlende Abhängigkeiten gefunden:")
        for dep in missing:
            print(f"  - {dep}")
        
        if 'tkinter' not in missing:  # Nur wenn GUI verfügbar ist
            root = tk.Tk()
            root.withdraw()  # Verstecke Hauptfenster
            
            install = messagebox.askyesno(
                "Abhängigkeiten installieren",
                f"Fehlende Pakete gefunden:\n{', '.join(missing)}\n\nMöchten Sie diese jetzt installieren?"
            )
            
            root.destroy()
            
            if install:
                for dep in missing:
                    if dep == 'tkinter':
                        messagebox.showwarning(
                            "tkinter Installation",
                            "tkinter muss über den Paketmanager Ihres Systems installiert werden.\n\n"
                            "Windows: tkinter ist normalerweise in Python enthalten\n"
                            "macOS: brew install python-tk\n"
                            "Linux: sudo apt-get install python3-tk"
                        )
                        continue
                    
                    try:
                        print(f"Installiere {dep}...")
                        subprocess.check_call([sys.executable, "-m", "pip", "install", dep])
                        print(f"✓ {dep} erfolgreich installiert")
                    except subprocess.CalledProcessError:
                        print(f"✗ Fehler beim Installieren von {dep}")
        
        return len([d for d in missing if d != 'tkinter']) == 0
    
    return True

def show_demo_info():
    """Zeigt Demo-Informationen an"""
    root = tk.Tk()
    root.title("Kleinanzeigen Scraper - Demo")
    root.geometry("600x400")
    root.configure(bg='#f0f0f0')
    
    # Zentrieren
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    main_frame = tk.Frame(root, bg='#f0f0f0', padx=20, pady=20)
    main_frame.pack(fill=tk.BOTH, expand=True)
    
    # Titel
    title_label = tk.Label(
        main_frame, 
        text="🔍 Kleinanzeigen Scraper", 
        font=('Arial', 20, 'bold'),
        bg='#f0f0f0',
        fg='#2c3e50'
    )
    title_label.pack(pady=(0, 10))
    
    subtitle_label = tk.Label(
        main_frame,
        text="Demo-Version",
        font=('Arial', 12),
        bg='#f0f0f0',
        fg='#7f8c8d'
    )
    subtitle_label.pack(pady=(0, 20))
    
    # Info-Text
    info_text = """
🚀 Willkommen zum Kleinanzeigen Scraper!

Diese Demo-Version zeigt die Grundfunktionalität der GUI.

Für die vollständige Funktionalität benötigen Sie:
✅ Die kompletten Scraper-Module
✅ Eine aktive Internetverbindung  
✅ Alle Python-Abhängigkeiten

Features der Vollversion:
🔍 Echtes Web-Scraping von Kleinanzeigen
📱 WhatsApp-Benachrichtigungen für neue Anzeigen
🎯 Erweiterte Filter-Optionen
💾 Export in verschiedene Formate
📊 Detaillierte Marktanalyse
⚙️ IT-spezifische Funktionen

Installation:
pip install -r requirements.txt
    """
    
    text_widget = tk.Text(
        main_frame, 
        wrap=tk.WORD, 
        width=70, 
        height=18,
        font=('Consolas', 10),
        bg='white',
        relief=tk.FLAT,
        padx=10,
        pady=10
    )
    text_widget.insert(tk.END, info_text)
    text_widget.config(state=tk.DISABLED)
    text_widget.pack(pady=(0, 20), fill=tk.BOTH, expand=True)
    
    # Buttons
    button_frame = tk.Frame(main_frame, bg='#f0f0f0')
    button_frame.pack(pady=10)
    
    def start_demo():
        root.destroy()
        start_gui_demo()
    
    def open_github():
        import webbrowser
        webbrowser.open('https://github.com/p3p3ee/kleinanzeigen-scraper')
    
    demo_button = tk.Button(
        button_frame,
        text="🚀 Demo starten",
        command=start_demo,
        bg='#3498db',
        fg='white',
        font=('Arial', 10, 'bold'),
        padx=20,
        relief=tk.FLAT
    )
    demo_button.pack(side=tk.LEFT, padx=(0, 10))
    
    github_button = tk.Button(
        button_frame,
        text="📋 GitHub öffnen",
        command=open_github,
        bg='#2c3e50',
        fg='white',
        font=('Arial', 10),
        padx=20,
        relief=tk.FLAT
    )
    github_button.pack(side=tk.LEFT, padx=(0, 10))
    
    quit_button = tk.Button(
        button_frame,
        text="❌ Beenden",
        command=root.destroy,
        bg='#e74c3c',
        fg='white',
        font=('Arial', 10),
        padx=20,
        relief=tk.FLAT
    )
    quit_button.pack(side=tk.LEFT)
    
    root.mainloop()

def start_gui_demo():
    """Startet die GUI im Demo-Modus"""
    try:
        # Versuche die echte GUI zu importieren
        sys.path.insert(0, 'src')
        from scraper_gui import main
        main()
    except ImportError as e:
        print(f"GUI-Module nicht gefunden: {e}")
        print("Starte eingebettete Demo-GUI...")
        start_embedded_demo()

def start_embedded_demo():
    """Startet eingebettete Demo-GUI falls Hauptmodule fehlen"""
    import tkinter as tk
    from tkinter import ttk, messagebox
    
    root = tk.Tk()
    root.title("Kleinanzeigen Scraper - Eingebettete Demo")
    root.geometry("800x600")
    
    main_frame = ttk.Frame(root, padding="20")
    main_frame.pack(fill=tk.BOTH, expand=True)
    
    # Titel
    ttk.Label(
        main_frame, 
        text="🔍 Kleinanzeigen Scraper - Demo", 
        font=('Arial', 16, 'bold')
    ).pack(pady=(0, 20))
    
    # Demo-Bereich
    demo_frame = ttk.LabelFrame(main_frame, text="Demo-Funktionen", padding="10")
    demo_frame.pack(fill=tk.BOTH, expand=True, pady=(0, 20))
    
    # Demo-Buttons
    def demo_scraping():
        messagebox.showinfo(
            "Demo Scraping",
            "🔍 Demo-Scraping gestartet!\n\n"
            "In der Vollversion würde hier echtes Web-Scraping stattfinden:\n"
            "✅ Kleinanzeigen durchsuchen\n"
            "✅ Neue Anzeigen finden\n"
            "✅ WhatsApp-Benachrichtigungen senden\n\n"
            "Installieren Sie die Vollversion für echte Funktionalität!"
        )
    
    def demo_whatsapp():
        messagebox.showinfo(
            "WhatsApp Demo",
            "📱 WhatsApp-Integration Demo!\n\n"
            "Unterstützte APIs:\n"
            "• Twilio (Professionell)\n"
            "• WHAPI.cloud (Einfach)\n"
            "• UltraMsg (Günstig)\n"
            "• Manual Mode (Kostenlos)\n\n"
            "Konfiguration erfolgt über die GUI-Einstellungen."
        )
    
    def demo_export():
        messagebox.showinfo(
            "Export Demo",
            "💾 Export-Funktionen:\n\n"
            "Unterstützte Formate:\n"
            "• JSON (Strukturierte Daten)\n"
            "• CSV (Excel-kompatibel)\n"
            "• TXT (Lesbare Berichte)\n\n"
            "Mit Marktanalyse und Statistiken!"
        )
    
    ttk.Button(demo_frame, text="🔍 Demo Scraping", command=demo_scraping).pack(pady=5, fill=tk.X)
    ttk.Button(demo_frame, text="📱 WhatsApp Demo", command=demo_whatsapp).pack(pady=5, fill=tk.X)
    ttk.Button(demo_frame, text="💾 Export Demo", command=demo_export).pack(pady=5, fill=tk.X)
    
    # Status
    status_frame = ttk.Frame(main_frame)
    status_frame.pack(fill=tk.X)
    
    ttk.Label(status_frame, text="Status: Demo-Modus aktiv").pack(side=tk.LEFT)
    ttk.Button(status_frame, text="Beenden", command=root.destroy).pack(side=tk.RIGHT)
    
    root.mainloop()

def main():
    """Hauptfunktion"""
    print("🔍 Kleinanzeigen Scraper - GUI Starter")
    print("=" * 50)
    
    # Prüfe Python-Version
    if sys.version_info < (3, 7):
        print("❌ Python 3.7 oder höher erforderlich!")
        print(f"   Aktuelle Version: {sys.version}")
        return 1
    
    # Prüfe Abhängigkeiten
    print("🔍 Prüfe Abhängigkeiten...")
    if not install_dependencies():
        print("❌ Nicht alle Abhängigkeiten konnten installiert werden.")
        print("💡 Installieren Sie diese manuell:")
        print("   pip install -r requirements.txt")
        
        # Zeige trotzdem Demo-Info wenn tkinter verfügbar
        try:
            import tkinter
            show_demo_info()
        except ImportError:
            print("❌ tkinter nicht verfügbar - kann Demo nicht starten")
        
        return 1
    
    print("✅ Alle Abhängigkeiten verfügbar")
    print("🚀 Starte GUI...")
    
    try:
        start_gui_demo()
    except Exception as e:
        print(f"❌ Fehler beim Starten der GUI: {e}")
        
        try:
            import tkinter
            messagebox.showerror(
                "Startup-Fehler",
                f"Fehler beim Starten der GUI:\n{str(e)}\n\n"
                "Versuchen Sie:\n"
                "1. pip install -r requirements.txt\n"
                "2. Python-Version prüfen (>=3.7)\n"
                "3. Repository neu klonen"
            )
        except ImportError:
            pass
        
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())