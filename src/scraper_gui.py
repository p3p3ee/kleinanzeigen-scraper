#!/usr/bin/env python3
"""
Kleinanzeigen Scraper GUI
=========================

Eine grafische Benutzeroberfläche für den Kleinanzeigen Scraper mit WhatsApp-Benachrichtigungen.

Verwendung:
    python src/scraper_gui.py

Features:
- Intuitive GUI mit tkinter
- Dual-Scraper Support (Allgemein + IT)
- WhatsApp-Benachrichtigungen
- Export-Funktionen
- Marktanalyse
"""

import tkinter as tk
from tkinter import ttk, messagebox, scrolledtext, filedialog
import threading
import json
import csv
from datetime import datetime
import webbrowser
import os

class ScraperGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Kleinanzeigen Scraper - Grafische Oberfläche")
        self.root.geometry("1200x800")
        self.root.configure(bg='#f0f0f0')
        
        self.aktuelle_ergebnisse = []
        self.scraping_aktiv = False
        
        self.setup_gui()
        
    def setup_gui(self):
        """Erstellt die gesamte GUI"""
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        
        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)
        main_frame.columnconfigure(1, weight=1)
        
        # Titel
        title_label = ttk.Label(main_frame, text="🔍 Kleinanzeigen Dienstleistungs-Scraper", 
                               font=('Arial', 16, 'bold'))
        title_label.grid(row=0, column=0, columnspan=3, pady=(0, 20))
        
        self.create_search_section(main_frame)
        self.create_control_section(main_frame)
        self.create_results_section(main_frame)
        self.create_status_section(main_frame)
        
    def create_search_section(self, parent):
        """Erstellt den Suchbereich"""
        search_frame = ttk.LabelFrame(parent, text="🔎 Suchparameter", padding="10")
        search_frame.grid(row=1, column=0, columnspan=3, sticky=(tk.W, tk.E), pady=(0, 10))
        search_frame.columnconfigure(1, weight=1)
        
        # Suchbegriff
        ttk.Label(search_frame, text="Suchbegriff:").grid(row=0, column=0, sticky=tk.W, padx=(0, 10))
        self.suchbegriff_var = tk.StringVar(value="Handwerker")
        ttk.Entry(search_frame, textvariable=self.suchbegriff_var, width=30).grid(row=0, column=1, sticky=(tk.W, tk.E))
        
        # Ort/PLZ
        ttk.Label(search_frame, text="Ort/PLZ:").grid(row=1, column=0, sticky=tk.W, padx=(0, 10), pady=(10, 0))
        self.ort_var = tk.StringVar()
        ttk.Entry(search_frame, textvariable=self.ort_var, width=30).grid(row=1, column=1, sticky=(tk.W, tk.E), pady=(10, 0))
        
    def create_control_section(self, parent):
        """Erstellt den Steuerungsbereich"""
        control_frame = ttk.Frame(parent)
        control_frame.grid(row=2, column=0, columnspan=3, pady=(0, 10))
        
        self.start_button = ttk.Button(control_frame, text="🚀 Demo starten", command=self.demo_scraping)
        self.start_button.pack(side=tk.LEFT, padx=(0, 10))
        
        self.export_button = ttk.Button(control_frame, text="💾 Demo Export", command=self.demo_export)
        self.export_button.pack(side=tk.LEFT, padx=(0, 10))
        
        self.clear_button = ttk.Button(control_frame, text="🗑 Löschen", command=self.clear_results)
        self.clear_button.pack(side=tk.LEFT)
        
    def create_results_section(self, parent):
        """Erstellt den Ergebnisbereich"""
        results_frame = ttk.LabelFrame(parent, text="📋 Ergebnisse", padding="10")
        results_frame.grid(row=3, column=0, columnspan=3, sticky=(tk.W, tk.E, tk.N, tk.S), pady=(0, 10))
        results_frame.columnconfigure(0, weight=1)
        results_frame.rowconfigure(0, weight=1)
        
        # Treeview für Ergebnisse
        columns = ('Titel', 'Preis', 'Ort', 'Kategorie')
        self.results_tree = ttk.Treeview(results_frame, columns=columns, show='headings', height=15)
        
        for col in columns:
            self.results_tree.heading(col, text=col)
            self.results_tree.column(col, width=200)
        
        # Scrollbar
        scrollbar = ttk.Scrollbar(results_frame, orient=tk.VERTICAL, command=self.results_tree.yview)
        self.results_tree.configure(yscrollcommand=scrollbar.set)
        
        self.results_tree.grid(row=0, column=0, sticky=(tk.W, tk.E, tk.N, tk.S))
        scrollbar.grid(row=0, column=1, sticky=(tk.N, tk.S))
        
    def create_status_section(self, parent):
        """Erstellt die Statusleiste"""
        status_frame = ttk.Frame(parent)
        status_frame.grid(row=4, column=0, columnspan=3, sticky=(tk.W, tk.E))
        status_frame.columnconfigure(0, weight=1)
        
        self.status_var = tk.StringVar(value="Bereit - Demo-Version")
        ttk.Label(status_frame, textvariable=self.status_var).grid(row=0, column=0, sticky=tk.W)
        
    def demo_scraping(self):
        """Demo-Scraping mit Beispieldaten"""
        # Demo-Daten erstellen
        demo_daten = [
            ("Webentwickler gesucht", "75 €/h", "Berlin", "IT"),
            ("Handwerker für Renovierung", "45 €/h", "München", "Handwerk"),
            ("Reinigungskraft", "15 €/h", "Hamburg", "Reinigung"),
            ("App-Entwicklung", "80 €/h", "Köln", "IT"),
            ("Gartenpflege", "25 €/h", "Frankfurt", "Garten")
        ]
        
        # Alte Ergebnisse löschen
        for item in self.results_tree.get_children():
            self.results_tree.delete(item)
        
        # Demo-Daten hinzufügen
        for data in demo_daten:
            self.results_tree.insert('', 'end', values=data)
        
        self.status_var.set(f"Demo abgeschlossen - {len(demo_daten)} Anzeigen gefunden")
        messagebox.showinfo("Demo", f"Demo-Scraping abgeschlossen!\n\nGefunden: {len(demo_daten)} Anzeigen\n\nFür echtes Scraping benötigen Sie:\n- Die vollständigen Scraper-Module\n- Internetverbindung\n- API-Konfiguration")
        
    def demo_export(self):
        """Demo-Export Funktion"""
        if not self.results_tree.get_children():
            messagebox.showwarning("Warnung", "Keine Daten zum Exportieren!\nStarten Sie zuerst das Demo-Scraping.")
            return
        
        filename = filedialog.asksaveasfilename(
            defaultextension=".csv",
            filetypes=[("CSV files", "*.csv"), ("JSON files", "*.json"), ("Text files", "*.txt")],
            title="Demo-Export speichern"
        )
        
        if filename:
            try:
                # Daten sammeln
                data = []
                for item in self.results_tree.get_children():
                    values = self.results_tree.item(item)['values']
                    data.append({
                        'titel': values[0],
                        'preis': values[1],
                        'ort': values[2],
                        'kategorie': values[3]
                    })
                
                # Export basierend auf Dateierweiterung
                if filename.endswith('.csv'):
                    with open(filename, 'w', newline='', encoding='utf-8') as f:
                        writer = csv.DictWriter(f, fieldnames=['titel', 'preis', 'ort', 'kategorie'])
                        writer.writeheader()
                        writer.writerows(data)
                elif filename.endswith('.json'):
                    with open(filename, 'w', encoding='utf-8') as f:
                        json.dump(data, f, ensure_ascii=False, indent=2)
                else:  # .txt
                    with open(filename, 'w', encoding='utf-8') as f:
                        f.write("Kleinanzeigen Demo-Export\n")
                        f.write("=" * 30 + "\n\n")
                        for i, item in enumerate(data, 1):
                            f.write(f"Anzeige {i}:\n")
                            f.write(f"  Titel: {item['titel']}\n")
                            f.write(f"  Preis: {item['preis']}\n")
                            f.write(f"  Ort: {item['ort']}\n")
                            f.write(f"  Kategorie: {item['kategorie']}\n\n")
                
                messagebox.showinfo("Export erfolgreich", f"Demo-Daten erfolgreich exportiert:\n{filename}")
                
            except Exception as e:
                messagebox.showerror("Export-Fehler", f"Fehler beim Export:\n{str(e)}")
    
    def clear_results(self):
        """Löscht alle Ergebnisse"""
        for item in self.results_tree.get_children():
            self.results_tree.delete(item)
        self.status_var.set("Ergebnisse gelöscht")

def main():
    """Hauptfunktion zum Starten der GUI"""
    root = tk.Tk()
    
    # Modernes Theme
    try:
        style = ttk.Style()
        if 'vista' in style.theme_names():
            style.theme_use('vista')
        elif 'clam' in style.theme_names():
            style.theme_use('clam')
    except:
        pass
    
    app = ScraperGUI(root)
    
    # Zentral positionieren
    root.update_idletasks()
    x = (root.winfo_screenwidth() // 2) - (root.winfo_width() // 2)
    y = (root.winfo_screenheight() // 2) - (root.winfo_height() // 2)
    root.geometry(f"+{x}+{y}")
    
    root.minsize(800, 600)
    
    # Info-Dialog beim Start
    messagebox.showinfo(
        "Kleinanzeigen Scraper - Demo", 
        "🔍 Willkommen zum Kleinanzeigen Scraper!\n\n"
        "Dies ist eine Demo-Version der GUI.\n\n"
        "Features der Vollversion:\n"
        "✅ Echtes Web-Scraping\n"
        "✅ WhatsApp-Benachrichtigungen\n"
        "✅ Erweiterte Filter\n"
        "✅ Marktanalyse\n"
        "✅ Kontinuierliche Überwachung\n\n"
        "Für die Vollversion installieren Sie:\n"
        "pip install -r requirements.txt"
    )
    
    root.mainloop()

if __name__ == "__main__":
    main()