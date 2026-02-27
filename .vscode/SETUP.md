# VS Code Setup für epubTTS

Empfohlene VS Code Extensions für Swift/iOS-Entwicklung:

## Installation

1. **Swift Language Support** (apple-swift-lang.swift-lang)
   ```bash
   code --install-extension apple-swift-lang.swift-lang
   ```
   - Native Swift Language Server Protocol (LSP) Integration
   - Code completion, navigation, refactoring

2. **Swift Format** (vknabel.vscode-swift-format)
   ```bash
   code --install-extension vknabel.vscode-swift-format
   ```
   - Automatische Code-Formatierung nach Swift-Standards
   - Format-on-Save konfiguriert in .vscode/settings.json

3. **CodeLLDB Debugger** (vadimcn.vscode-lldb)
   ```bash
   code --install-extension vadimcn.vscode-lldb
   ```
   - LLDB Debugger für Swift/iOS
   - Breakpoints, watch expressions, stack traces

## Konfiguration

Die Datei `.vscode/settings.json` enthält:
- SourceKit-LSP Server Pfad (Xcode-Integration)
- Swift-Formatting on Save
- Code-Ruler bei 100 und 120 Zeichen

## Verwendung

Nach Installation der Extensions:

1. **Code Completion**: Während des Tippen funktioniert automatisch (LSP)
2. **Formatting**: Speichern (Cmd+S) formatiert den Code automatisch
3. **Debugging**: Im Xcode Debugger verwenden (nicht VS Code)

## Hinweis

Für vollständiges iOS-Debugging wird **Xcode** empfohlen:
```bash
open epubTTS.xcworkspace
```

VS Code dient hauptsächlich zur Code-Bearbeitung mit LSP-Integration.
