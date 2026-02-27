# 🏗️ epubTTS - Build & Run Guide

## Quick Start (3 Minuten)

```bash
cd /Users/ulrich.frank/Dev/private/epubTTS

# 1. Build
swift build

# 2. Tests
swift test

# 3. Öffne in Xcode (Optional)
open .
```

---

## Detaillierte Anleitung

### Prerequisites
- macOS 12 oder später
- Swift 5.9+ (kommt mit Xcode 15+)
- Xcode 15+ (optional, nur für GUI)

### 1️⃣ Projekt Klonen

```bash
# Von GitHub
git clone https://github.com/UlrichFrank/epubTTS.git
cd epubTTS

# ODER lokal bereits vorhanden
cd /Users/ulrich.frank/Dev/private/epubTTS
```

### 2️⃣ Build

**Debug Build (schnell, mit Debug Info)**
```bash
swift build
```

**Release Build (optimiert)**
```bash
swift build -c release
```

**Spezifisches Target**
```bash
# Nur Core Library
swift build --product epubTTSCore

# Nur App
swift build --product epubTTS
```

**Verbose Output**
```bash
swift build -v
```

### 3️⃣ Tests Ausführen

**Alle Tests**
```bash
swift test
```

**Mit Verbose Output**
```bash
swift test -v
```

**Spezifisches Test Target**
```bash
swift test --filter Phase2Tests
```

**Mit Code Coverage**
```bash
swift test --enable-code-coverage
```

### 4️⃣ In Xcode Öffnen

```bash
open .
```

Xcode öffnet sich und zeigt das Swift Package an:
- Kann die Struktur erforschen
- Code bearbeiten
- Debuggen mit Breakpoints
- Simulator starten (wenn nötig)

---

## Build Artefakte

Nach `swift build` sind die Binaries hier:
```
.build/debug/          # Debug builds
.build/release/        # Release builds
```

Test Results:
```
.build/debug/epubTTSPackageTests.xctest/
```

---

## Häufige Befehle

| Befehl | Was es macht |
|--------|-------------|
| `swift build` | Build Debug |
| `swift build -c release` | Build Release |
| `swift test` | Alle Tests ausführen |
| `swift test -v` | Tests mit Details |
| `swift package resolve` | Dependencies auflösen |
| `swift package update` | Dependencies updaten |
| `open .` | In Xcode öffnen |
| `rm -rf .build` | Build Cache löschen |

---

## Troubleshooting

### Build fehlgeschlagen?

**Cache löschen und neu bauen:**
```bash
rm -rf .build
swift build
```

**Swift Version überprüfen:**
```bash
swift --version
```

**Sollte 5.9+ sein. Update mit:**
```bash
xcode-select --install  # oder Xcode updaten
```

### Tests fehlgeschlagen?

**Nur Phase 2 Tests ausführen:**
```bash
swift test --filter Phase2Tests
```

**Mit Debug Output:**
```bash
swift test -v
```

### ⚠️ Wichtig: `swift test` vs `xcodebuild test`

**✅ RICHTIG für Swift Packages:**
```bash
swift test
```

**❌ FALSCH für Swift Packages:**
```bash
# Wird fehlschlagen mit: "Scheme epubTTS is not configured for test action"
xcodebuild test -scheme epubTTS
```

**Warum?** Swift Packages haben keine Xcode Schemes. Nutze immer `swift test` für dieses Projekt.

---

## Projekt Struktur

```
epubTTS/
├── Package.swift                 # Swift Package Manifest
├── Sources/
│   ├── Core/                     # Core Library (epubTTSCore)
│   │   ├── AudioPlayerError.swift
│   │   ├── AudioStatus.swift
│   │   ├── EPubFile.swift
│   │   ├── EPubChapter.swift
│   │   ├── EPubMetadata.swift
│   │   ├── FileService.swift
│   │   ├── EPubService.swift
│   │   └── Logger.swift
│   └── App/
│       └── Main.swift            # App Entry (epubTTSApp)
├── Tests/
│   └── epubTTSTests/
│       └── Phase2Tests.swift     # Unit Tests (11 tests)
├── docs/
│   ├── DESIGN.md
│   ├── REQUIREMENTS.md
│   ├── IMPLEMENTATION.md
│   └── ...
└── .github/
    └── copilot-instructions.md
```

---

## Phase Übersicht

### Phase 1 ✅ (Abgeschlossen)
- Swift Package Setup
- Core Models & Services
- Basic Error Handling

### Phase 2 ✅ (Abgeschlossen)
- Unit Tests (11 tests, alle bestanden)
- Model Testing
- Error Handling Tests

### Phase 3 ⏳ (Next)
- Integration Tests
- Service Integration
- Async/Await Tests

### Phase 4 ⏳ (Future)
- End-to-End Tests
- Multi-Chapter Navigation
- Error Recovery

### Phase 5 ⏳ (Future)
- UI Implementation (SwiftUI)
- AudioPlayerView
- File Import

---

## Entwickler Tipps

### Code Formatting
Swift verwendet standard formatting. Xcode formatiert automatisch.

### Debugging
1. Öffne in Xcode: `open .`
2. Setze Breakpoints
3. Führe aus: Cmd+R
4. Debug-Konsole zeigt Logs

### Neue Features Hinzufügen
1. Implementiere in Sources/Core/
2. Schreibe Tests in Tests/epubTTSTests/
3. Laufe: `swift test`
4. Commit: `git add . && git commit -m "..."`
5. Push: `git push`

---

## Repository Links

- **Code**: https://github.com/UlrichFrank/epubTTS
- **Issues**: https://github.com/UlrichFrank/epubTTS/issues
- **Documentation**: `/docs` Folder

---

**Viel Spaß beim Entwickeln! 🚀**
