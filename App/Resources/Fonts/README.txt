OpenDyslexic Bold font for ReadBetter
====================================

All app text (welcome, buttons, labels, etc.) uses OpenDyslexic Bold when
dyslexia font is ON. The top-left button switches to normal system font.

1. Add the font file here (or in App/Resources):
   - opendyslexic.bold.otf  (required – used for all text)

2. Optional: opendyslexic.regular.otf (not used for UI; bold is used everywhere).

3. The app registers these at launch. If no font file is present, the app
   falls back to the system font. Default on first open: dyslexia font ON.
