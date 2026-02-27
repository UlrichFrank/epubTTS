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
- Create multiple app releases as Minimum Viable Products (MVP) which each can be used as a standalone product, but which together form a more complete product. Each MVP should be fully functional and provide value to users, while also allowing for iterative development and improvement over time.

## Security Rules
- ✅ No API keys in code
- ✅ Use `.env` for sensitive data

## AI rules
- Destructive functions must be controlled and verified by a human
    
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
