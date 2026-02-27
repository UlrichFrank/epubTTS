# epubTTS - Project Constitution

## Role
Act as a Senior Software Architect

## Project Overview
We are building an iOS app that enables users to listen to epub files being read aloud. The app should provide a user-friendly interface and various features such as bookmarks and adjustment of reading speed. ePub files should be easy to upload (e.g., via iCloud or through iOS sharing functionality).
Text should be displayed both with and without audio playback. During playback, the read text should be highlighted and the current position should be automatically saved so users can resume listening from the same point later.   

## Tech-Stack
- **Language**: Swift
- **UI Framework**: SwiftUI

## Architecture
- **Audio Processing**: AVFoundation
- **App Architecture**: MVVM (Model-View-ViewModel)
- **ePub Processing**: Readium Swift Toolkit

## Coding Standards
- Clean Code principles
- SOLID principles
- Test-Driven Development (TDD)
- Create a Minimum Viable Product (MVP) with each development step

## Security Rules
- ✅ No API keys in code
- ✅ Use `.env` for sensitive data

## Documentation
- Clear README.md with:
  - Installation instructions
  - Usage guide
- All documents, specs, design documents, and implementation plans must be stored in a docs directory as markdown files

## Development Conventions
Before generating code, **the following steps must be completed in this order**:

1. **Requirements Document**
   - With individually traceable requirements

2. **Design Document**
   - With traceability to the requirements

3. **Implementation Plan**
   - Successive steps for implementing requirements
   - Structured to be checkable

4. **Documentation**
   - All steps must be documented and verifiable

5. **Consistency**
   - All development documents must be consistent with each other and with the codebase
