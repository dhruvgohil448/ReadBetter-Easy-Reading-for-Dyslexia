# Git & Xcode Setup – ReadBetter

## 1. Git repo status

- The project **already has a git repo** (initial commit exists).
- A **`.gitignore`** is in place so `.build/`, Xcode user data, and other generated files are not committed.

## 2. Connect to GitHub (or another remote) and push

### Option A: Create a new repo on GitHub

1. Go to [github.com](https://github.com) → **New repository**.
2. Name it (e.g. `ReadBetter`). Do **not** add a README, .gitignore, or license (you already have a repo).
3. Copy the repo URL (e.g. `https://github.com/YOUR_USERNAME/ReadBetter.git` or `git@github.com:YOUR_USERNAME/ReadBetter.git`).

### Add remote and push (run in Terminal)

```bash
cd /Users/dhruvgohil/Developer/ReadBetter.swiftpm

# Add your remote (replace with your actual URL)
git remote add origin https://github.com/YOUR_USERNAME/ReadBetter.git

# Stage and commit the .gitignore and any other new/changed files
git add .
git status   # check what will be committed
git commit -m "Add .gitignore and project info"

# Push (first time: set upstream for main)
git push -u origin main
```

If your default branch is `master` instead of `main`:

```bash
git push -u origin master
```

### Option B: You already have a repo URL

```bash
cd /Users/dhruvgohil/Developer/ReadBetter.swiftpm
git remote add origin YOUR_REPO_URL
git add .
git commit -m "Add .gitignore and project info"
git push -u origin main
```

## 3. Use Xcode for commits and pushes

1. **Open the project in Xcode**  
   - File → Open → select the **`ReadBetter.swiftpm`** folder (the one that contains `Package.swift`).  
   - Or double-click `ReadBetter.swiftpm` in Finder.

2. **Enable Source Control (if needed)**  
   - Xcode → Settings (or Preferences) → **Source Control** → ensure “Enable Source Control” is on.

3. **Commit and push from Xcode**  
   - **Source Control** menu → **Commit…** (or **⌃⌘C**) to stage, write a message, and commit.  
   - **Source Control** → **Push…** to push to the remote.  
   - Or use the **Source Control** navigator (branch icon in the left sidebar) to see changes and commit/push from there.

4. **First push from Xcode**  
   - If you just added `origin` in Terminal, the first time you push from Xcode it may ask for the remote; choose `origin` and `main` (or `master`).  
   - You may be prompted to sign in to GitHub (or your Git host) if you haven’t already.

After this, you can do all commits and pushes from Xcode.
