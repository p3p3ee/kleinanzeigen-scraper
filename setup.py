from setuptools import setup, find_packages
import os

# Read README for long description
with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

# Read requirements
def read_requirements():
    with open("requirements.txt", "r", encoding="utf-8") as fh:
        return [line.strip() for line in fh if line.strip() and not line.startswith("#")]

setup(
    name="kleinanzeigen-scraper",
    version="1.0.0",
    author="p3p3ee",
    author_email="patrick.schmidtsowik@gmail.com",
    description="🔍 Intelligenter Scraper für Dienstleistungsanzeigen mit WhatsApp-Benachrichtigungen",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/p3p3ee/kleinanzeigen-scraper",
    project_urls={
        "Bug Reports": "https://github.com/p3p3ee/kleinanzeigen-scraper/issues",
        "Source": "https://github.com/p3p3ee/kleinanzeigen-scraper",
        "Documentation": "https://github.com/p3p3ee/kleinanzeigen-scraper#readme",
    },
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: End Users/Desktop",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Internet :: WWW/HTTP :: Dynamic Content",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: Utilities",
        "Topic :: Communications",
        "Environment :: X11 Applications :: Qt",
        "Environment :: Win32 (MS Windows)",
        "Environment :: MacOS X",
    ],
    python_requires=">=3.7",
    install_requires=read_requirements(),
    extras_require={
        "dev": [
            "pytest>=6.0.0",
            "black>=21.0.0",
            "flake8>=3.9.0",
            "pytest-cov>=2.0.0",
        ],
        "whatsapp": [
            "twilio>=7.0.0",
        ],
        "analysis": [
            "pandas>=1.3.0",
            "matplotlib>=3.4.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "kleinanzeigen-scraper=gui_starter:main",
            "kleinanzeigen-gui=gui_starter:main",
        ],
    },
    include_package_data=True,
    package_data={
        "": ["*.md", "*.txt", "*.json", "*.yml", "*.yaml"],
    },
    keywords=[
        "scraping",
        "kleinanzeigen",
        "whatsapp",
        "automation",
        "gui",
        "notifications",
        "services",
        "marketplace",
        "alerts",
        "monitoring"
    ],
    zip_safe=False,
)