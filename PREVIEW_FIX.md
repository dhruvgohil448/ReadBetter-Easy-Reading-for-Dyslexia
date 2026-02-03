# Fixing Xcode Preview Issues

If you're seeing "Select a scheme that builds a target..." error or previews aren't showing, try these steps:

## Quick Fixes (in order):

### 1. **Select the Correct Scheme**
- In Xcode, click the scheme selector (next to the stop button)
- Select **"ReadBetter"** scheme
- Make sure it's set to build for **"iPhone 17"** or any iOS Simulator

### 2. **Clean Build Folder**
- Press `Cmd + Shift + K` (or Product → Clean Build Folder)
- Then build again: `Cmd + B`

### 3. **Build the Project First**
- Previews require the project to build successfully
- Press `Cmd + B` to build
- Wait for "Build Succeeded" before trying previews

### 4. **Restart Xcode Preview**
- Close the preview canvas (click the X or press `Cmd + Option + Return`)
- Reopen it (`Cmd + Option + Return` or Editor → Canvas)

### 5. **Check File is Part of Target**
- Select the Swift file in Project Navigator
- Open File Inspector (right panel, first tab)
- Under "Target Membership", ensure **"ReadBetter"** is checked

### 6. **Reset Package Dependencies** (if needed)
- File → Packages → Reset Package Caches
- File → Packages → Resolve Package Versions

## Files with Preview Support Added:
- ✅ `WelcomeView.swift`
- ✅ `WordInputView.swift`
- ✅ `ReadingView.swift`
- ✅ `ProgressView.swift`

## If Previews Still Don't Work:

1. **Try running the app** instead of preview:
   - Select iPhone simulator
   - Press `Cmd + R` to run
   - This verifies everything builds correctly

2. **Check Xcode Version**:
   - Swift Playgrounds projects require Xcode 15+
   - Update Xcode if needed

3. **Verify Package.swift**:
   - The `Package.swift` is auto-generated - don't edit it manually
   - It should have `path: "."` which includes all subdirectories

4. **File Location**:
   - All Swift files are in subdirectories (App/, Views/, Managers/, etc.)
   - SPM should discover them automatically
   - If not, try moving a file to root temporarily to test

## Alternative: Use Live Preview in Simulator
If canvas preview doesn't work, you can always:
1. Run the app (`Cmd + R`)
2. Navigate to the screen you want to see
3. Use this for development instead of previews
