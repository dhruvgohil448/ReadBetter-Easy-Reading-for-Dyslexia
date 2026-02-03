# Testing Guide for ReadBetter

## 🧪 Complete Feature Testing Checklist

### 1. **Pronunciation Checking** 🎤

#### Test Setup
1. Open app → Word Practice → Select "butterfly"
2. Tap microphone button
3. Speak the word clearly

#### Expected Behavior
✅ **Correct Pronunciation**:
- Microphone icon pulses while recording
- "Stop" button appears
- After speaking, shows: "You said: [word]"
- Shows match percentage (e.g., "Match: 95%")
- If ≥80% match → Success overlay appears
- Points awarded and displayed
- Diya celebrates with message
- Haptic feedback (success vibration)

✅ **Incorrect Pronunciation**:
- Shows: "You said: [what you said]"
- Shows match percentage (e.g., "Match: 45%")
- Feedback message: "Not quite. Listen and try again!"
- Diya shows encouragement
- Attempt indicator updates (circle turns red)
- Haptic feedback (error vibration)

✅ **Close Match (60-79%)**:
- Shows: "Close! 65% match. Try again!"
- Encouraging feedback
- Can retry

#### Debug Output
Check Xcode console for:
```
=== Pronunciation Check ===
Target: butterfly
Recognized: butterfly
Similarity: 95%
Is Correct: true
========================
```

#### Common Test Words
- **Easy**: "school" (1 syllable)
- **Medium**: "butterfly" (3 syllables)
- **Hard**: "momentum" (3 syllables)

---

### 2. **Theme Switching** 🎨

#### Test Steps
1. Tap palette icon (top-right on Welcome screen)
2. Theme picker appears
3. Tap "Forest Green"
4. Observe instant color change

#### Expected Behavior
✅ All buttons change color immediately
✅ Gradient background updates
✅ Syllable colors change in reading view
✅ Theme persists after app restart
✅ Checkmark shows on selected theme

#### Test All Themes
- 🌊 Ocean Blue (default)
- 🌲 Forest Green
- 🌅 Sunset Orange

---

### 3. **Story Reading** 📖

#### Test Steps
1. Welcome → Story Reader
2. Select "The Little Rabbit"
3. Tap blue highlighted word (e.g., "hopped")

#### Expected Behavior
✅ **Word Tap**:
- Overlay appears immediately
- Word is spoken aloud
- Syllables shown (e.g., "hop-ped")
- Can tap syllables to hear them
- "Hear Word" button plays full word
- "Practice" button goes to pronunciation mode

✅ **Read Aloud**:
- Tap "Read Aloud" button
- Button turns red, says "Stop"
- Sentences read one by one
- Green border follows current sentence
- Can stop anytime

---

### 4. **Points & Streaks** ⭐

#### Test Steps
1. Practice word successfully
2. Check points awarded
3. Practice another word
4. Check streak counter

#### Expected Behavior
✅ **Points Calculation**:
- Short word (1-2 syllables): 10 points
- Medium word (3 syllables): 15 points
- Long word (4+ syllables): 20 points
- First-try bonus: +5 points
- Streak multiplier: up to 2×

✅ **Streak Display**:
- 🔥 icon appears after first success
- Number increments with each success
- Resets on failure
- Persists in session

✅ **Progress View**:
- Shows total points
- Shows session streak
- Shows daily streak
- Shows earned badges

---

### 5. **SF Symbols Animations** ✨

#### Visual Checks
✅ **Welcome Screen**:
- Diya breathing (gentle scale)
- Palette icon bounces on tap
- Mic icon bounces continuously
- Book icon wiggles
- Chart icon has variable color
- All chevrons pulse

✅ **Pronunciation View**:
- Mic pulses when recording
- Circle breathes behind mic
- Star bounces in success overlay
- Points count up smoothly

✅ **Progress View**:
- Star bounces continuously
- Numbers count smoothly
- Cards fade/scale on scroll

---

### 6. **Haptic Feedback** 📳

#### Test on Physical Device
✅ Tap mic button → Impact feedback
✅ Correct pronunciation → Success feedback
✅ Wrong pronunciation → Error feedback
✅ Word split → Light impact

---

### 7. **Accessibility** ♿

#### VoiceOver Testing
1. Enable VoiceOver (Settings → Accessibility)
2. Navigate through app
3. Check all elements are labeled

✅ All buttons have labels
✅ All images have descriptions
✅ Syllables have hints
✅ Animations don't block content

#### Reduce Motion
1. Enable Reduce Motion (Settings → Accessibility)
2. Check animations simplify

✅ Symbol effects become static
✅ Keyframes become fades
✅ Transitions become instant
✅ Content remains accessible

---

### 8. **Edge Cases** 🔍

#### Pronunciation Edge Cases
✅ **Silent/No Speech**:
- Should timeout gracefully
- Show "No speech detected"

✅ **Background Noise**:
- Should still attempt recognition
- May show low similarity score

✅ **Multiple Words**:
- If you say "the butterfly" for "butterfly"
- Should still match (contains check)

✅ **Mispronunciation**:
- Say "butter-flee" for "butterfly"
- Should show ~60-70% match
- Offer help overlay

#### UI Edge Cases
✅ **Long Words**:
- Test with "computer", "dinosaur"
- Should wrap properly
- Syllables should fit

✅ **Quick Taps**:
- Rapidly tap buttons
- Should not crash
- Should handle gracefully

✅ **Rotation**:
- Rotate device
- Layout should adapt

---

## 🐛 Known Issues & Fixes

### Issue 1: Speech Recognition Not Working
**Symptoms**: Mic button does nothing, no recording
**Fix**: 
1. Check microphone permission in Settings
2. Check speech recognition permission
3. Restart app

**Code Check**:
```swift
// In Package.swift, verify:
.microphone(purposeString: "...")
.speechRecognition(purposeString: "...")
```

### Issue 2: Low Match Scores
**Symptoms**: Correct pronunciation shows <80%
**Possible Causes**:
- Background noise
- Unclear pronunciation
- Microphone quality

**Fix**:
- Speak clearly and slowly
- Reduce background noise
- Try in quiet environment

### Issue 3: Animations Not Showing
**Symptoms**: No symbol effects, static UI
**Fix**:
- Check iOS version (requires 17.0+)
- Check Reduce Motion setting
- Restart app

---

## 📊 Test Results Template

### Pronunciation Testing
| Word | Pronunciation | Match % | Result | Notes |
|------|--------------|---------|--------|-------|
| butterfly | "butterfly" | 100% | ✅ Pass | Perfect |
| butterfly | "butter-fly" | 95% | ✅ Pass | Slight pause |
| butterfly | "butter-flee" | 65% | ❌ Fail | Wrong sound |
| school | "school" | 100% | ✅ Pass | Perfect |

### Theme Testing
| Theme | Colors Update | Persist | Visual | Result |
|-------|--------------|---------|--------|--------|
| Ocean | ✅ | ✅ | ✅ | Pass |
| Forest | ✅ | ✅ | ✅ | Pass |
| Sunset | ✅ | ✅ | ✅ | Pass |

### Animation Testing
| Feature | Visible | Smooth | Accessible | Result |
|---------|---------|--------|------------|--------|
| Diya breathing | ✅ | ✅ | ✅ | Pass |
| Symbol bounce | ✅ | ✅ | ✅ | Pass |
| Keyframe success | ✅ | ✅ | ✅ | Pass |
| Scroll transitions | ✅ | ✅ | ✅ | Pass |

---

## 🚀 Performance Testing

### Metrics to Check
✅ **Frame Rate**: Should be 60fps
✅ **Memory**: Should stay under 100MB
✅ **Battery**: No excessive drain
✅ **Launch Time**: Under 2 seconds

### Tools
- Xcode Instruments
- Debug Navigator
- Energy Impact gauge

---

## ✅ Final Checklist

Before submitting:
- [ ] All pronunciation tests pass
- [ ] All themes work correctly
- [ ] All animations smooth
- [ ] All buttons functional
- [ ] Points calculate correctly
- [ ] Streaks persist
- [ ] Stories read aloud
- [ ] Word help works
- [ ] VoiceOver compatible
- [ ] Reduce Motion works
- [ ] No crashes
- [ ] No memory leaks
- [ ] Permissions requested
- [ ] Privacy descriptions added

---

## 📝 Bug Report Template

```
**Bug**: [Brief description]
**Steps to Reproduce**:
1. 
2. 
3. 

**Expected**: [What should happen]
**Actual**: [What actually happens]
**Device**: [iPhone/iPad model]
**iOS Version**: [e.g., 17.0]
**Frequency**: [Always/Sometimes/Rare]
**Console Output**: [Any error messages]
```

---

**Test thoroughly and make reading feel friendly!** 🧪✨
