# ReadBetter - Build & Deployment Guide

## ✅ iOS 17.0+ Requirement

ReadBetter now requires **iOS 17.0 or later** to take advantage of the latest WWDC 2024 SwiftUI features.

### Package Configuration
```swift
// Package.swift
platforms: [
    .iOS("17.0")  // Updated from 16.0
]
```

## 🎨 WWDC Features Implemented

All modern SwiftUI features are now properly configured for iOS 17.0+:

### 1. SF Symbols Animations
- ✅ `.symbolEffect(.bounce)` - Mic, stars, theme picker
- ✅ `.symbolEffect(.pulse)` - Chevrons, navigation
- ✅ `.symbolEffect(.wiggle)` - Book icon (iOS 18.0+, gracefully degrades)
- ✅ `.symbolEffect(.variableColor)` - Chart icon

### 2. Phase Animator
- ✅ Diya breathing animation
- ✅ Smooth continuous cycles

### 3. Keyframe Animations
- ✅ Success celebration with rotation and scale
- ✅ Multiple animation tracks

### 4. Content Transitions
- ✅ `.contentTransition(.numericText())` - Points counting
- ✅ `.contentTransition(.interpolate)` - Text morphing

### 5. Visual Effects
- ✅ `.ultraThinMaterial` - Frosted glass
- ✅ Gradient foreground styles

### 6. Scroll Transitions
- ✅ `.scrollTransition` - Fade and scale on scroll

### 7. Sensory Feedback
- ✅ `.sensoryFeedback(.impact)` - Haptic feedback

## 🚀 How to Build & Run

### Option 1: Swift Playgrounds (Recommended)
1. Open `ReadBetter.swiftpm` in **Swift Playgrounds** on iPad or Mac
2. Tap **Run** button
3. App launches with all features enabled

### Option 2: Xcode
1. Open `ReadBetter.swiftpm` in **Xcode 15.0+**
2. Select target device (iOS 17.0+ required)
3. Click **Run** (⌘R)

### Option 3: TestFlight (For Judges)
1. Export from Xcode
2. Upload to App Store Connect
3. Distribute via TestFlight
4. Install on iOS 17.0+ device

## 📱 Device Requirements

### Minimum Requirements
- **iOS Version**: 17.0 or later
- **Devices**: iPhone 12 or newer, iPad (9th gen) or newer
- **Storage**: ~25 MB
- **Permissions**: Microphone, Speech Recognition

### Recommended
- **iOS Version**: 17.4 or later
- **Devices**: iPhone 14 or newer, iPad Pro
- **For best experience**: Quiet environment, good microphone

## ✅ Pre-Flight Checklist

Before running the app:

### 1. Verify iOS Version
```
Settings → General → About → Software Version
Should show: 17.0 or higher
```

### 2. Grant Permissions
```
Settings → ReadBetter
- Microphone: ON
- Speech Recognition: ON
```

### 3. Check Storage
```
Settings → General → iPhone Storage
Ensure at least 50 MB free
```

## 🧪 Testing Features

### Test 1: WWDC Animations
1. Launch app
2. Observe:
   - ✅ Diya breathing (phase animator)
   - ✅ Bouncing palette icon
   - ✅ Pulsing chevrons
   - ✅ Wiggling book icon

### Test 2: Pronunciation Checking
1. Tap "Word Practice"
2. Select "butterfly"
3. Tap microphone
4. Say "butterfly"
5. Verify:
   - ✅ Match percentage shows
   - ✅ Feedback message appears
   - ✅ Points awarded if ≥80%

### Test 3: Themes
1. Tap palette icon
2. Select different theme
3. Verify:
   - ✅ Colors change instantly
   - ✅ Gradient updates
   - ✅ Syllables use theme colors

### Test 4: Story Reading
1. Tap "Story Reader"
2. Select story
3. Tap blue word
4. Verify:
   - ✅ Overlay appears
   - ✅ Word plays
   - ✅ Syllables tappable

## 🐛 Troubleshooting

### Issue: "Requires iOS 17.0"
**Solution**: Update device to iOS 17.0 or later

### Issue: Animations not showing
**Check**:
1. iOS version is 17.0+
2. Reduce Motion is OFF (Settings → Accessibility)
3. Low Power Mode is OFF

### Issue: Pronunciation not working
**Check**:
1. Microphone permission granted
2. Speech Recognition permission granted
3. Not in silent mode
4. Microphone not blocked

### Issue: Wiggle animation not working
**Note**: `.wiggle` requires iOS 18.0+
**Solution**: Gracefully degrades to static on iOS 17.x

## 📊 Build Configurations

### Debug (Development)
```swift
// Optimized for debugging
- Faster builds
- Console logging enabled
- Debug symbols included
```

### Release (Production)
```swift
// Optimized for performance
- Smaller binary size
- Logging disabled
- Full optimizations
```

## 🎯 Deployment Targets

### Swift Student Challenge
- **Platform**: Swift Playgrounds
- **Format**: `.swiftpm` package
- **Size Limit**: 25 MB ✅ (Currently ~15 MB)
- **iOS Version**: 17.0+

### App Store (Future)
- **Minimum iOS**: 17.0
- **Categories**: Education, Kids
- **Age Rating**: 4+
- **Privacy**: No data collection

## 📝 Version History

### v1.0 (Current)
- ✅ iOS 17.0+ requirement
- ✅ WWDC 2024 features
- ✅ 3 themes
- ✅ Pronunciation checking
- ✅ Story reading
- ✅ Progress tracking
- ✅ AR mode
- ✅ Full accessibility

## 🔐 Privacy & Permissions

### Required Permissions
1. **Microphone** (`NSMicrophoneUsageDescription`)
   - Purpose: Record pronunciation for checking
   - When: Only when user taps mic button
   
2. **Speech Recognition** (`NSSpeechRecognitionUsageDescription`)
   - Purpose: Convert speech to text for comparison
   - When: Only during pronunciation practice
   - Processing: 100% on-device

### Optional Permissions
3. **Camera** (`NSCameraUsageDescription`)
   - Purpose: AR mode and text scanning
   - When: Only when user enables AR/scan
   - Optional: App works without it

## 📦 File Structure

```
ReadBetter.swiftpm/
├── Package.swift              ✅ iOS 17.0 configured
├── ContentView.swift          ✅ Main navigation
├── WelcomeView.swift          ✅ WWDC animations
├── PronunciationView.swift    ✅ Keyframes, symbols
├── ProgressView.swift         ✅ Scroll transitions
├── ThemeManager.swift         ✅ Theme system
├── PronunciationChecker.swift ✅ Speech recognition
├── ScoringManager.swift       ✅ Points & streaks
├── AvatarManager.swift        ✅ Reading buddy
├── StoryModels.swift          ✅ Data structures
└── [Other supporting files]
```

## ✅ Final Checklist

Before submission:
- [x] iOS 17.0 minimum version set
- [x] All WWDC features working
- [x] Pronunciation checking functional
- [x] Themes switching correctly
- [x] Story reading working
- [x] Progress tracking persisting
- [x] AR mode functional
- [x] All permissions declared
- [x] No crashes or errors
- [x] File size under 25 MB
- [x] Accessibility complete
- [x] Documentation complete

## 🎓 For Judges

### Quick Start
1. Open in Swift Playgrounds
2. Tap Run
3. Follow demo script (see DEMO_SCRIPT.md)
4. Test pronunciation with "butterfly"
5. Try different themes
6. Check progress view

### Key Features to Evaluate
1. **Innovation**: AR + Speech Recognition + Gamification
2. **Design**: WWDC 2024 animations, dyslexia-friendly
3. **Accessibility**: VoiceOver, haptics, high contrast
4. **Technical**: Clean code, modern SwiftUI
5. **Impact**: Helps dyslexic learners read

---

**ReadBetter is ready for iOS 17.0+ devices!** 🚀✨

Build with Swift Playgrounds or Xcode 15.0+
