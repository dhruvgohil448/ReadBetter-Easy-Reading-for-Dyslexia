# ReadBetter - Swift Student Challenge Submission

## 🎯 Project Overview

**ReadBetter** is an innovative, accessibility-first Swift Playground that helps dyslexic learners improve their reading skills through:
- **Dyslexia-friendly typography** with dynamic spacing
- **Pronunciation training** with speech recognition
- **Gamification** with points, streaks, and badges
- **Interactive stories** with tappable words
- **OCR scanning** to practice with real books

## ✨ Key Features

### 1. Dyslexia-Friendly Reading
- Increased letter spacing (kerning: 2.0)
- Rounded system font for better readability
- Syllable breakdown with color-coded highlights
- Tap-to-hear pronunciation for each syllable
- Success animations and haptic feedback

### 2. Pronunciation Training
- **Speech Recognition**: On-device speech-to-text
- **Phonetic Similarity**: 80% threshold for acceptance
- **3-Attempt System**: Visual progress indicators
- **Help Mode**: 
  - Slowed pronunciation playback
  - Syllable-by-syllable breakdown
  - Tap individual syllables to hear them
- **Instant Feedback**: Success/fail with haptics

### 3. Gamification System
- **Points**:
  - Short words (1-2 syllables): 10 points
  - Medium words (3 syllables): 15 points
  - Long words (4+ syllables): 20 points
  - First-try bonus: +5 points
- **Streaks**:
  - Session streak: Consecutive correct answers
  - Multiplier: Up to 2× (1 + streak × 0.05)
  - Visual indicator: 🔥 × N
  - Daily streak tracking
- **Badges**:
  - First Word (10+ points)
  - 5 in a Row (5 streak)
  - 10 Streak (10 streak)
  - 100 Points milestone
  - 500 Points milestone

### 4. Interactive Stories
- **Story Library**:
  - "The Little Rabbit" (3 sentences)
  - "The Butterfly Garden" (3 sentences)
- **Tappable Words**: Practice difficult words inline
- **Animated Scenes**: Emoji-based lightweight animations
- **Progressive Learning**: Words trigger pronunciation practice

### 5. OCR Text Scanning
- **Live Camera Scanning**: Capture words from books
- **VisionKit Integration**: DataScannerViewController
- **Tap-to-Capture**: Select any word to practice
- **Seamless Flow**: Scanned words go directly to reading view

## 🏗️ Technical Architecture

### Codebase structure

```
ReadBetter.swiftpm/
├── App/                    # Entry point & navigation
│   ├── MyApp.swift
│   └── ContentView.swift
├── Views/                  # Screens
│   ├── WelcomeView.swift
│   ├── WordInputView.swift
│   ├── ReadingView.swift
│   ├── StoryReaderView.swift
│   ├── ProgressView.swift
│   ├── PronunciationView.swift
│   ├── ScanTextView.swift
│   ├── ChallengesView.swift
│   ├── ThemePickerView.swift
│   └── Components/         # Reusable UI
│       ├── KidUIComponents.swift
│       ├── JungleFrameView.swift
│       └── ThemeAmbientView.swift
├── Managers/               # Services & state
│   ├── AudioManager.swift
│   ├── ThemeManager.swift
│   ├── AvatarManager.swift
│   ├── ScoringManager.swift
│   └── PronunciationChecker.swift
├── Models/
│   └── StoryModels.swift
├── Engine/
│   └── SyllableEngine.swift
├── Docs/                   # Additional documentation
└── Package.swift
```

### Core Components

#### 1. SyllableEngine.swift (`Engine/`)
- Static methods for syllable splitting
- Hardcoded dictionary for demo words
- Fallback algorithm for custom words
- Returns: `[String]` array of syllables

#### 2. AudioManager.swift
- AVSpeechSynthesizer for text-to-speech
- Configurable rate (0.4 for clarity)
- Audio session management
- Offline pronunciation

#### 3. PronunciationChecker.swift
- SFSpeechRecognizer for on-device recognition
- Levenshtein distance algorithm
- Phonetic similarity scoring
- Real-time recording feedback

#### 4. ScoringManager.swift
- UserDefaults persistence
- Points calculation with multipliers
- Session and daily streak tracking
- Badge system with JSON encoding

### Views

#### 1. WelcomeView.swift
- Friendly introduction
- "Start Reading" call-to-action
- Soft blue gradient background

#### 2. WordInputView.swift
- Mode selection (Stories/Practice)
- Word cards with long-press for pronunciation
- Custom word input
- OCR scan button
- Visual hierarchy with icons

#### 3. ReadingView.swift
- Dyslexia-friendly word display
- Tap-to-split syllables
- Color-coded syllable highlights
- Success animations

#### 4. PronunciationView.swift
- Recording interface with mic button
- 3-attempt visual indicators
- Points and streak display
- Help overlay with syllable practice
- Success/fail animations

#### 5. StoryReaderView.swift
- Flow layout for natural text
- Tappable word highlighting
- Animated scene cards
- Story library browser

#### 6. ScanTextView.swift
- DataScannerViewController wrapper
- Live text recognition
- Tap-to-capture interaction

### Data Models

#### Story.swift
```swift
struct Story {
    let id: String
    let title: String
    let sentences: [Sentence]
    let animations: [String: String]
}

struct Sentence {
    let id: String
    let text: String
    let tappableWords: [String]
}
```

## 📱 User Experience Flow

### Flow 1: Basic Reading
1. Launch → Welcome Screen
2. Tap "Start Reading"
3. Select word card
4. View dyslexia-friendly display
5. Tap word → See syllables
6. Tap syllables → Hear pronunciation
7. Success animation

### Flow 2: Pronunciation Practice
1. From Word Input → Long-press word card
2. OR tap "Practice" mode
3. Tap mic to record
4. Get instant feedback
5. If incorrect → "Help me pronounce"
6. Practice syllables individually
7. Retry (up to 3 attempts)
8. Earn points and streak

### Flow 3: Story Reading
1. Tap "Stories" button
2. Browse story library
3. Select story
4. Read sentences with animations
5. Double-tap difficult words
6. Practice pronunciation
7. Earn micro-points

### Flow 4: Book Scanning
1. Tap "Scan Text from Book"
2. Point camera at text
3. Tap word to capture
4. Automatic transition to reading view
5. Practice as normal

## 🎨 Design Principles

### Accessibility-First
- ✅ VoiceOver labels on all interactive elements
- ✅ Dynamic Type support
- ✅ High contrast color choices
- ✅ Haptic feedback for confirmation
- ✅ No rapid flashing animations
- ✅ Minimal animation mode option

### Dyslexia-Friendly
- ✅ Increased letter spacing
- ✅ Rounded, friendly fonts
- ✅ Left-aligned text
- ✅ Short, clear sentences
- ✅ Visual diagrams (syllable breakdown)
- ✅ Audio support
- ✅ No italics or underlines
- ✅ Pastel color palette

### Engaging & Encouraging
- 🎉 Positive reinforcement ("Perfect!", "You did it!")
- 🔥 Visual streak indicators
- ⭐ Points and badges
- 🎨 Smooth animations
- 🎵 Audio feedback
- 📖 Story-based learning

## 📊 Technical Specifications

### Frameworks Used
- **SwiftUI**: Modern declarative UI
- **Speech**: On-device speech recognition
- **AVFoundation**: Audio playback and recording
- **VisionKit**: OCR text scanning

### Performance
- **File Size**: < 25 MB (Swift Playground requirement)
- **Offline**: 100% offline functionality
- **On-Device**: All processing local (privacy-first)
- **Optimized**: Lightweight emoji animations
- **Responsive**: Smooth 60fps animations

### Permissions Required
- 📷 Camera: OCR scanning (capture words from books)
- 🎤 Microphone: Pronunciation recording
- 🗣️ Speech Recognition: Pronunciation checking

## 🏆 Why Judges Will Love It

### 1. Inclusivity & Impact
- Addresses real pain point for dyslexic learners
- Helps millions of children worldwide
- Reduces stigma through gamification
- Empowers independent learning

### 2. Technical Excellence
- Combines Speech Recognition + OCR
- Clean architecture with separation of concerns
- Proper state management
- Offline-first design

### 3. Innovation
- **Multi-modal approach**: Visual + Audio + Gamification
- **Gamification** makes learning fun
- Dyslexia research–based design

### 4. User Experience
- Intuitive navigation
- Encouraging tone
- Beautiful animations
- Accessibility-first
- Professional polish

### 5. Educational Value
- Based on dyslexia research
- Progressive difficulty
- Immediate feedback
- Personalized learning pace
- Story-based context

## 📈 Demo Metrics

### Example Session
- **Word**: "butterfly" (3 syllables)
- **First try**: Correct ✅
- **Points earned**: 20 (15 base + 5 bonus)
- **Streak**: 5 🔥
- **Multiplied**: 20 × 1.25 = **25 points**
- **Badge unlocked**: "5 in a Row" 🏆

### Learning Progression
1. Start: Mispronounced "butterfly"
2. Help mode: Learned "but-ter-fly"
3. Retry 1: Still incorrect
4. Retry 2: Correct! ✅
5. Badge earned: First Word ⭐
6. Next word: Faster recognition
7. Streak building: More points 📈

## 🎓 What I Learned

### Technical Skills
- Speech recognition implementation
- Complex state management in SwiftUI
- Audio session handling
- OCR integration with VisionKit
- Algorithm design (Levenshtein distance)

### Design Skills
- Accessibility-first design
- Typography for dyslexia
- Color theory for readability
- Animation timing and easing
- User flow optimization
- Gamification mechanics

### Soft Skills
- Empathy for users with learning differences
- Research on dyslexia best practices
- Balancing features vs. simplicity
- Iterative design process
- User-centric thinking

## 🚀 Future Enhancements

### Potential Features
- [ ] More stories with varying difficulty
- [ ] Custom word lists from teachers
- [ ] Progress tracking dashboard
- [ ] Multiplayer challenges
- [ ] Parent/teacher portal
- [ ] Multiple language support
- [ ] Advanced phonics lessons
- [ ] Reading comprehension quizzes

## 📝 Submission Checklist

- ✅ Swift Playground format
- ✅ < 25 MB file size
- ✅ Fully offline
- ✅ No external dependencies
- ✅ Accessibility features
- ✅ Original code
- ✅ Commented and clean
- ✅ Runs on iPad
- ✅ iOS 16.0+
- ✅ Engaging demo flow

## 🎯 Target Audience

### Primary
- Children aged 7-12 with dyslexia
- Early literacy learners
- Students needing reading support

### Secondary
- Teachers for classroom use
- Parents for home practice
- Special education programs
- Reading intervention specialists

## 💡 Core Innovation

**ReadBetter combines artificial intelligence (speech recognition), OCR, and gamification to create a unique, multi-sensory learning experience that makes reading accessible and fun for dyslexic learners.**

---

## 📞 Contact & Attribution

**Project**: ReadBetter - Dyslexia Helper
**Framework**: Swift Playgrounds
**Target**: Swift Student Challenge 2025
**Platform**: iPad (iOS 16.0+)
**Category**: Accessibility & Education

---

*"Reading should feel friendly. Let's make words easier together."*
