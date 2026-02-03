# ReadBetter – Project Info

## What is ReadBetter?

**ReadBetter** is an accessibility-first iOS app (Swift Student Challenge submission) that helps dyslexic learners improve reading through:

- **Dyslexia-friendly typography** – dynamic spacing, OpenDyslexic-style fonts, syllable breakdown
- **Pronunciation training** – on-device speech recognition, 3-attempt flow, “Help me pronounce” with syllables
- **Gamification** – points, session/daily streaks, badges (First Word, 5 in a Row, 100/500 points)
- **Interactive stories** – tappable words, scene animations, micro-points
- **OCR scanning** – VisionKit camera scan to capture words from books and practice them

## Tech Stack

| Area        | Technology                          |
|------------|--------------------------------------|
| UI         | SwiftUI                              |
| Speech     | Speech (on-device), AVFoundation TTS |
| OCR        | VisionKit (DataScannerViewController)|
| Persistence| UserDefaults (points, streaks, badges)|
| Platform   | iOS 17+, iPhone & iPad               |

## Project Structure

- **App/** – Entry point (`MyApp`, `ContentView`), resources, fonts, assets
- **Views/** – Screens (Welcome, WordInput, Reading, Pronunciation, StoryReader, Progress, ScanText, ThemePicker, Challenges) and shared components
- **Managers/** – Audio, Theme, Avatar, Scoring, PronunciationChecker, DeviceMotion
- **Engine/** – SyllableEngine (syllable splitting)
- **Models/** – StoryModels
- **Docs/** – Build guide, features, themes, testing, status

## Opening in Xcode

1. **From Finder:** Double-click the folder `ReadBetter.swiftpm`, or  
2. **From Xcode:** File → Open → select `ReadBetter.swiftpm`  
3. Xcode will open it as a Swift Package. Use **Source Control** in the menu (or **⌃⌘C**) to commit and push.

## Bundle & Version

- **Bundle ID:** `com.ReadBetter.ReadBetter`
- **Display version:** 1.0 | **Bundle version:** 1
- **Capabilities:** Camera (OCR scanning), Microphone, Speech Recognition

For full feature list and architecture, see [README.md](README.md) and [Docs/FEATURES.md](Docs/FEATURES.md).
