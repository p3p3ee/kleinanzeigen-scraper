"""
Kleinanzeigen Scraper Package
============================

Ein intelligenter Scraper für Dienstleistungsanzeigen mit WhatsApp-Benachrichtigungen.

Hauptmodule:
- scraper_gui: Grafische Benutzeroberfläche
- kleinanzeigen_scraper: Core Scraping-Funktionalität
- whatsapp_notification: WhatsApp-Benachrichtigungssystem

Verwendung:
    from src.kleinanzeigen_scraper import KleinanzeigenScraper
    from src.scraper_gui import ScraperGUI

Oder direkt über GUI starten:
    python gui_starter.py

Version: 1.0.0
Author: p3p3ee
License: MIT
"""

__version__ = "1.0.0"
__author__ = "p3p3ee"
__license__ = "MIT"
__description__ = "Intelligenter Scraper für Dienstleistungsanzeigen mit WhatsApp-Benachrichtigungen"

# Verfügbare Module
__all__ = [
    "scraper_gui",
    "kleinanzeigen_scraper",
]