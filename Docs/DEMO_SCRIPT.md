# ReadBetter - Demo Script for Judges (3 minutes)

## Opening (30 seconds)

**[Launch app]**

"Hi! I'm excited to show you **ReadBetter** - a Swift Playground that helps dyslexic learners improve their reading through pronunciation training, gamification, and AR spatial learning."

**[Welcome screen appears with Diya the reading buddy]**

"Meet Diya, our friendly reading buddy who guides learners through their journey. ReadBetter offers three modes: Word Practice, Story Reader, and Progress tracking."

---

## Demo 1: Word Practice with Pronunciation Training (90 seconds)

**[Tap "Word Practice"]**

"Let's start with Word Practice. Here we have dyslexia-friendly word cards with increased spacing and rounded fonts."

**[Long-press on "butterfly"]**

"I can long-press any word to go directly to pronunciation practice."

**[Pronunciation screen appears]**

"Notice the syllable breakdown: but-ter-fly. I have 3 attempts to pronounce it correctly."

**[Tap microphone - intentionally mispronounce: "butter-flee"]**

"Oops! I said 'butter-flee' instead of 'butterfly'. The app uses on-device speech recognition to check my pronunciation."

**[Diya shows encouragement: "So close! Try again - you've got this! 💪"]**

"Diya encourages me to try again. Let me tap 'Help me pronounce'."

**[Tap help button]**

"The help overlay shows each syllable. I can tap individual syllables to hear them."

**[Tap "but" - hear it]**
**[Tap "ter" - hear it]**
**[Tap "fly" - hear it]**

"Or hear the full word slowed down."

**[Tap "Hear full word"]**

"Now let me try again."

**[Tap mic - pronounce correctly: "butterfly"]**

**[Success animation! "+20 points" appears, Diya celebrates]**

"Perfect! I earned 20 points (15 base + 5 first-try bonus), and my streak is building! 🔥"

---

## Demo 2: Story Reader (60 seconds)

**[Go back, tap "Story Reader" from welcome]**

"Now let's try Story Reader - our Read Along-inspired feature."

**[Select "The Little Rabbit"]**

"Here's an interactive story with tappable words and animated scenes."

**[Story appears with first sentence and rabbit animation]**

"The little rabbit hopped across the blue meadow."

**[Double-tap "hopped"]**

"If I double-tap a difficult word, it takes me directly to pronunciation practice for that word."

**[Pronunciation screen for "hopped" appears]**

"I can practice it right here in context, then return to the story."

**[Go back to story]**

"The animations respond to reading progress - when I read correctly, the rabbit hops!"

**[Scene animates]**

"Each correctly read sentence awards micro-points and advances the story."

---

## Demo 3: AR Mode & Progress (30 seconds)

**[Navigate to a word, tap "AR Mode"]**

"ReadBetter also features AR spatial learning. Words appear as 3D floating syllables in your space."

**[AR view shows 3D syllables]**

"This helps with spatial memory - learners can walk around and interact with syllables in 3D."

**[Go back, navigate to "My Progress"]**

"Finally, the Progress screen shows total points, session and daily streaks, earned badges, and statistics."

**[Progress screen displays]**

"Everything persists across sessions using UserDefaults."

---

## Closing (10 seconds)

"ReadBetter combines:
- ✅ On-device speech recognition
- ✅ Dyslexia-friendly design
- ✅ Gamification with points and streaks
- ✅ AR spatial learning
- ✅ Interactive stories
- ✅ 100% offline, under 25MB

All designed to make reading feel friendly and accessible. Thank you!"

---

## Key Points to Emphasize

1. **Accessibility-First**: Dyslexia-friendly typography, VoiceOver support, high contrast
2. **Multi-Modal Learning**: Visual + Audio + Spatial (AR)
3. **Gamification**: Points, streaks, badges keep learners motivated
4. **On-Device**: Privacy-first, fully offline
5. **Technical Excellence**: Speech recognition, AR, OCR, clean architecture
6. **User Experience**: Encouraging tone, smooth animations, reading buddy companion

---

## Backup Talking Points

### If asked about technical implementation:
- "Speech recognition uses Apple's Speech framework with Levenshtein distance for phonetic similarity"
- "AR uses RealityKit for 3D text generation and spatial placement"
- "Scoring system uses session and daily streaks with multipliers up to 2×"
- "All state management in SwiftUI with proper @StateObject and @Published patterns"

### If asked about accessibility:
- "Every interactive element has VoiceOver labels"
- "Supports Dynamic Type for text scaling"
- "Haptic feedback for success/fail confirmation"
- "High contrast colors following dyslexia design guidelines"
- "Optional minimal animations mode"

### If asked about educational value:
- "Based on research: dyslexic learners benefit from multi-sensory approaches"
- "Syllable breakdown helps with phonemic awareness"
- "Immediate feedback accelerates learning"
- "Gamification reduces stigma and increases engagement"
- "AR spatial memory reinforcement is novel in reading apps"

---

## Demo Flow Diagram

```
Welcome (Diya)
    ↓
Word Practice
    ↓
Select "butterfly"
    ↓
Mispronounce → Encouragement
    ↓
Help Overlay → Syllable Practice
    ↓
Correct → Success + Points
    ↓
Story Reader
    ↓
"The Little Rabbit"
    ↓
Double-tap "hopped"
    ↓
Practice in context
    ↓
AR Mode (optional)
    ↓
Progress Screen
    ↓
Thank you!
```

---

## Timing Breakdown

- **Opening**: 30s
- **Word Practice Demo**: 90s
- **Story Reader Demo**: 60s
- **AR & Progress**: 30s
- **Closing**: 10s
- **Total**: 3 minutes 20 seconds (allows 20s buffer for questions)
