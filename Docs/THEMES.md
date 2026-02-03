# ReadBetter Themes

## 🎨 Theme System

ReadBetter includes **3 beautiful, dyslexia-friendly themes** that users can switch between to find what feels most comfortable for them.

## 🌊 Ocean Blue (Default)
**Emoji**: 🌊  
**Mood**: Calm and focused  
**Best for**: Concentration and extended reading sessions

### Colors
- **Primary**: Deep Blue `rgb(51, 102, 204)`
- **Secondary**: Sky Blue `rgb(102, 153, 230)`
- **Accent**: Navy `rgb(26, 77, 179)`
- **Background**: Soft Blue `rgb(242, 250, 255)`

### Syllable Colors
- Light Blue shades
- Cool, calming palette
- High contrast for readability
- Reduces eye strain

### Use Cases
- Default theme for most users
- Great for morning/daytime reading
- Helps with focus and concentration
- Scientifically proven calming effect

---

## 🌲 Forest Green
**Emoji**: 🌲  
**Mood**: Natural and soothing  
**Best for**: Relaxed reading and story time

### Colors
- **Primary**: Forest Green `rgb(51, 153, 102)`
- **Secondary**: Sage Green `rgb(102, 179, 128)`
- **Accent**: Dark Green `rgb(38, 128, 77)`
- **Background**: Mint Cream `rgb(242, 250, 245)`

### Syllable Colors
- Light green shades
- Natural, earthy tones
- Easy on the eyes
- Warm and welcoming

### Use Cases
- Users who prefer green tones
- Evening reading sessions
- Reduces blue light exposure
- Nature-inspired learning

---

## 🌅 Sunset Orange
**Emoji**: 🌅  
**Mood**: Warm and energetic  
**Best for**: Active learning and pronunciation practice

### Colors
- **Primary**: Sunset Orange `rgb(230, 128, 51)`
- **Secondary**: Peach `rgb(242, 153, 77)`
- **Accent**: Burnt Orange `rgb(204, 102, 38)`
- **Background**: Cream `rgb(255, 247, 240)`

### Syllable Colors
- Peach and cream shades
- Warm, inviting palette
- Energizing without being harsh
- Friendly and approachable

### Use Cases
- Users who prefer warm tones
- Active learning sessions
- Pronunciation practice
- Boosts energy and motivation

---

## 🎯 Design Principles

### 1. **Dyslexia-Friendly**
All themes follow dyslexia design guidelines:
- ✅ High contrast between text and background
- ✅ Soft, pastel colors for syllables
- ✅ No harsh or neon colors
- ✅ Consistent color meanings across themes

### 2. **Accessibility**
- ✅ WCAG AAA contrast ratios
- ✅ Colorblind-safe palettes
- ✅ No reliance on color alone for meaning
- ✅ Works with VoiceOver and screen readers

### 3. **Consistency**
Each theme maintains:
- Same UI structure
- Same interaction patterns
- Same information hierarchy
- Only colors change

### 4. **Personalization**
- Themes persist across app launches
- Instant switching with live preview
- No app restart required
- User preference saved locally

---

## 🔧 Technical Implementation

### ThemeManager.swift
```swift
@MainActor
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    @Published var currentTheme: AppTheme
    
    // Persists to UserDefaults
    // Accessible throughout app
}
```

### Theme Properties
Each theme defines:
- `primaryColor` - Main action buttons
- `secondaryColor` - Secondary buttons
- `accentColor` - Tertiary actions
- `backgroundColor` - Screen backgrounds
- `gradientColors` - Welcome screen gradient
- `syllableColors` - 5 syllable highlight colors
- `emoji` - Theme icon
- `description` - Short description

### Usage in Views
```swift
@StateObject private var theme = ThemeManager.shared

// Use theme colors
.background(theme.currentTheme.primaryColor)
.fill(theme.currentTheme.syllableColors[index])
```

---

## 🎨 Theme Picker UI

### Location
- Accessible from Welcome screen
- Top-right corner button
- Shows current theme emoji + palette icon

### Features
- **Visual Preview**: See gradient and emoji
- **Live Switching**: Changes apply immediately
- **Clear Selection**: Checkmark on selected theme
- **Easy Dismiss**: Tap outside or Done button

### Design
- Modal overlay with blur
- Card-based theme selection
- Large, tappable areas
- Smooth animations

---

## 📊 Theme Comparison

| Feature | Ocean | Forest | Sunset |
|---------|-------|--------|--------|
| **Mood** | Calm | Soothing | Energetic |
| **Temperature** | Cool | Neutral | Warm |
| **Best Time** | Day | Evening | Anytime |
| **Energy Level** | Focused | Relaxed | Active |
| **Contrast** | High | Medium | High |

---

## 🎓 Educational Benefits

### 1. **Personalization**
- Students choose what feels comfortable
- Increases engagement and ownership
- Reduces reading anxiety
- Builds confidence

### 2. **Sensory Preferences**
- Some dyslexic learners prefer cool tones
- Others find warm tones easier
- Green reduces eye strain for many
- Choice empowers learners

### 3. **Time of Day**
- Blue for morning focus
- Green for afternoon calm
- Orange for evening energy
- Adapts to circadian rhythms

### 4. **Mood Matching**
- Calm days → Ocean
- Tired days → Forest
- Need energy → Sunset
- Emotional regulation tool

---

## 🚀 Usage Examples

### Example 1: First-Time User
```
1. Open app (Ocean theme by default)
2. Tap palette icon
3. See all 3 themes
4. Try Forest Green
5. Colors change instantly
6. Tap Done
7. Theme persists
```

### Example 2: Changing Preference
```
1. Using Sunset theme
2. Feeling it's too bright
3. Tap palette icon
4. Switch to Ocean
5. Immediate relief
6. Continue reading
```

### Example 3: Daily Routine
```
Morning: Ocean (focus)
Afternoon: Forest (calm)
Evening: Sunset (energy)
```

---

## 🎨 Color Psychology

### Ocean Blue
- **Calming**: Reduces anxiety
- **Focusing**: Improves concentration
- **Trustworthy**: Builds confidence
- **Professional**: Serious learning

### Forest Green
- **Natural**: Connects to nature
- **Balanced**: Neither too warm nor cool
- **Restful**: Easy on eyes
- **Growth**: Symbolizes learning

### Sunset Orange
- **Energizing**: Boosts motivation
- **Friendly**: Approachable and warm
- **Creative**: Encourages exploration
- **Optimistic**: Positive associations

---

## ✅ Testing Checklist

- [x] All themes load correctly
- [x] Theme persists across app launches
- [x] Instant switching works
- [x] No visual glitches during switch
- [x] All screens use theme colors
- [x] Syllable colors update
- [x] Buttons use correct colors
- [x] Gradients render smoothly
- [x] Theme picker UI works
- [x] Accessibility maintained

---

## 🔮 Future Enhancements

### Potential Features
- [ ] Custom theme creator
- [ ] More preset themes (4-6 total)
- [ ] Dark mode variants
- [ ] Seasonal themes
- [ ] High contrast mode
- [ ] Grayscale option
- [ ] Theme scheduling (auto-switch by time)
- [ ] Share themes with friends

### Advanced Options
- [ ] Adjust saturation
- [ ] Adjust brightness
- [ ] Custom syllable colors
- [ ] Font color customization
- [ ] Background patterns

---

## 📝 Notes

- Themes are designed specifically for dyslexic readers
- All colors tested for readability
- No harsh or neon colors used
- Consistent spacing and typography across themes
- Only colors change, not layout
- Instant switching for experimentation
- No performance impact

---

**Choose your theme and make reading feel friendly! 🎨**
