# Build time optimization

If the package takes too long to build, try these:

## Xcode settings (biggest impact)

1. **Build Active Architecture Only**  
   - **Debug:** set to **Yes** (builds only the current device/simulator arch).  
   - **Release:** can stay **No** for distribution.

2. **Compilation mode**  
   - **Debug:** **Incremental** (default) so only changed files recompile.  
   - **Release:** **Whole Module** for best runtime performance.

3. **Indexing**  
   - Closing unused projects and clearing Derived Data (`~/Library/Developer/Xcode/DerivedData`) can speed up subsequent builds.

## Code structure

- **ChallengesView.swift** (~1174 lines) is the largest file. Splitting it so each of the 6 challenge views (`TapSoundsChallengeView`, `BuildWordChallengeView`, etc.) lives in its own file under `Views/Challenges/` will improve **incremental** build time: changing one challenge only recompiles that file.
- **ThemeAmbientView.swift** (~555 lines) and **StoryReaderView.swift** (~605 lines) are also large; splitting theme-specific ambient views or reader sections into separate files can help.

## Clean build

- For a one-off clean build: **Product → Clean Build Folder** (⇧⌘K), then build again.  
- If the package was edited outside Xcode, close and reopen the package so the source list is refreshed.
