#!/usr/bin/env python3
"""
Kleinanzeigen Scraper - Beispiele
=================================

Dieses Script zeigt verschiedene Verwendungsbeispiele des Kleinanzeigen Scrapers.

Verwendung:
    python examples/basic_usage.py
"""

import sys
import os

# Füge src Verzeichnis zum Python-Pfad hinzu
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

try:
    from kleinanzeigen_scraper import KleinanzeigenScraper
except ImportError:
    print("❌ Scraper-Module nicht gefunden!")
    print("💡 Stellen Sie sicher, dass Sie im korrekten Verzeichnis sind")
    sys.exit(1)

def beispiel_einfache_suche():
    """Beispiel für eine einfache Suche"""
    print("🔍 BEISPIEL 1: Einfache Suche")
    print("=" * 40)
    
    scraper = KleinanzeigenScraper()
    
    # Suche nach Handwerkern in Berlin
    anzeigen = scraper.demo_extrahiere_anzeigen("Handwerker", "Berlin", max_seiten=2)
    
    print(f"Gefunden: {len(anzeigen)} Anzeigen")
    
    for i, anzeige in enumerate(anzeigen, 1):
        print(f"\n{i}. {anzeige.titel}")
        print(f"   💰 {anzeige.preis}")
        print(f"   📍 {anzeige.ort}")
        print(f"   🏷️ {anzeige.kategorie}")

def beispiel_filter_anwendung():
    """Beispiel für die Anwendung von Filtern"""
    print("\n🎯 BEISPIEL 2: Filter anwenden")
    print("=" * 40)
    
    scraper = KleinanzeigenScraper()
    
    # Suche nach verschiedenen Dienstleistungen
    alle_anzeigen = []
    suchbegriffe = ["Handwerker", "Webentwicklung", "Reinigung"]
    
    for begriff in suchbegriffe:
        anzeigen = scraper.demo_extrahiere_anzeigen(begriff, max_seiten=1)
        alle_anzeigen.extend(anzeigen)
    
    print(f"Gesamt gefunden: {len(alle_anzeigen)} Anzeigen")
    
    # Filter nach Kategorie
    print("\n🏷️ Filter nach Kategorien:")
    for kategorie in ['handwerk', 'it', 'reinigung']:
        gefilterte = scraper.filtere_nach_kategorie(alle_anzeigen, kategorie)
        print(f"  {kategorie}: {len(gefilterte)} Anzeigen")
    
    # Filter nach Ort
    print("\n📍 Filter nach Orten:")
    for ort in ['Berlin', 'München', 'Hamburg']:
        gefilterte = scraper.filtere_nach_ort(alle_anzeigen, ort)
        print(f"  {ort}: {len(gefilterte)} Anzeigen")

def beispiel_preis_filter():
    """Beispiel für Preisfilter"""
    print("\n💰 BEISPIEL 3: Preisfilter")
    print("=" * 40)
    
    scraper = KleinanzeigenScraper()
    
    # Generiere Test-Anzeigen
    anzeigen = scraper.demo_extrahiere_anzeigen("Dienstleistung", max_seiten=2)
    
    print(f"Alle Anzeigen: {len(anzeigen)}")
    
    # Filter nach Preisspannen
    preisspannen = [
        (None, 30),      # Bis 30€
        (30, 60),        # 30-60€
        (60, None),      # Ab 60€
    ]
    
    for min_preis, max_preis in preisspannen:
        gefilterte = scraper.filtere_nach_preisspanne(anzeigen, min_preis, max_preis)
        
        if min_preis is None:
            bereich = f"bis {max_preis}€"
        elif max_preis is None:
            bereich = f"ab {min_preis}€"
        else:
            bereich = f"{min_preis}-{max_preis}€"
        
        print(f"  {bereich}: {len(gefilterte)} Anzeigen")

def beispiel_export_simulation():
    """Beispiel für Export-Simulation"""
    print("\n💾 BEISPIEL 4: Export-Simulation")
    print("=" * 40)
    
    scraper = KleinanzeigenScraper()
    anzeigen = scraper.demo_extrahiere_anzeigen("IT Service", "München", max_seiten=1)
    
    print(f"Anzeigen für Export: {len(anzeigen)}")
    
    # Simuliere verschiedene Export-Formate
    print("\n📋 Export-Formate:")
    
    # JSON-ähnliche Struktur
    print("JSON-Format:")
    for anzeige in anzeigen[:2]:  # Nur erste 2 für Demo
        print(f"  {{")
        print(f"    'titel': '{anzeige.titel}',")
        print(f"    'preis': '{anzeige.preis}',")
        print(f"    'ort': '{anzeige.ort}',")
        print(f"    'kategorie': '{anzeige.kategorie}'")
        print(f"  }}")
    
    # CSV-ähnliche Struktur
    print("\nCSV-Format:")
    print("Titel,Preis,Ort,Kategorie")
    for anzeige in anzeigen[:2]:
        print(f'"{anzeige.titel}","{anzeige.preis}","{anzeige.ort}","{anzeige.kategorie}"')

def beispiel_kategorien_analyse():
    """Beispiel für Kategorien-Analyse"""
    print("\n📊 BEISPIEL 5: Kategorien-Analyse")
    print("=" * 40)
    
    scraper = KleinanzeigenScraper()
    
    # Zeige verfügbare Kategorien
    print("Verfügbare Kategorien:")
    for kategorie, keywords in scraper.kategorien.items():
        print(f"  📂 {kategorie}: {', '.join(keywords[:3])}...")
    
    # Simuliere Marktanalyse
    print(f"\nMarktanalyse-Simulation:")
    kategorien_count = {}
    
    # Generiere Daten für verschiedene Kategorien
    for kategorie in ['handwerk', 'it', 'reinigung', 'garten']:
        anzeigen = scraper.demo_extrahiere_anzeigen(kategorie, max_seiten=1)
        kategorien_count[kategorie] = len(anzeigen)
    
    # Sortiere nach Anzahl
    sortierte_kategorien = sorted(kategorien_count.items(), key=lambda x: x[1], reverse=True)
    
    print("Anzeigen-Verteilung:")
    for kategorie, anzahl in sortierte_kategorien:
        balken = "█" * (anzahl * 2)  # Einfache Balkenvisualisierung
        print(f"  {kategorie:12} | {balken} ({anzahl})")

def main():
    """Führt alle Beispiele aus"""
    print("🚀 Kleinanzeigen Scraper - Beispiele")
    print("=" * 50)
    print("Hinweis: Dies sind Demo-Beispiele mit generierten Daten.")
    print("In der Vollversion werden echte Kleinanzeigen gescrapt.")
    print("=" * 50)
    
    try:
        beispiel_einfache_suche()
        beispiel_filter_anwendung()
        beispiel_preis_filter()
        beispiel_export_simulation()
        beispiel_kategorien_analyse()
        
        print("\n✅ Alle Beispiele erfolgreich ausgeführt!")
        print("\n💡 Nächste Schritte:")
        print("  1. Installieren Sie die Vollversion: pip install -r requirements.txt")
        print("  2. Starten Sie die GUI: python gui_starter.py")
        print("  3. Konfigurieren Sie WhatsApp-Benachrichtigungen")
        print("  4. Erstellen Sie Ihren ersten Alarm")
        
    except Exception as e:
        print(f"\n❌ Fehler beim Ausführen der Beispiele: {e}")
        print("💡 Stellen Sie sicher, dass alle Module korrekt installiert sind")

if __name__ == "__main__":
    main()