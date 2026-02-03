import SwiftUI

struct ContentView: View {
    enum ChallengeType: String, CaseIterable {
        case tapSounds = "Tap the Sounds"
        case buildWord = "Build the Word"
        case slowRead = "Slow Read Mode"
        case findMatch = "Find Matching Sound"
        case readGlow = "Read & Glow"
        case dailyTiny = "Daily Tiny Challenge"
    }
    
    /// Navigation routes (native push/pop + interactive back swipe).
    enum Route: Hashable {
        case input
        case reading(String)
        case pronunciation(String)
        case storyLibrary
        case storyReading(String) // Story ID
        case progress
        case challenges
        case challenge(ChallengeType, String) // type + word
    }
    
    private enum Sheet: Identifiable {
        case scanning
        
        var id: String {
            switch self {
            case .scanning: return "scanning"
            }
        }
    }
    
    @State private var isReady: Bool = true
    @State private var path: [Route] = []
    @State private var sheet: Sheet?
    @StateObject private var theme = ThemeManager.shared
    /// Observe font preference so toggling Dylexcia on Welcome refreshes the whole app.
    @AppStorage(ReadBetterFont.useDylexciaKey) private var useDylexciaFont = true
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                WelcomeView(
                    onStart: { push(.input) },
                    onStories: { push(.storyLibrary) },
                    onProgress: { push(.progress) }
                )
                .id(useDylexciaFont)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .input:
                        WordInputView(
                            onWordSelected: { push(.reading($0)) },
                            onScanRequested: { sheet = .scanning },
                            onPronunciationMode: { push(.pronunciation($0)) },
                            onStoriesRequested: { push(.storyLibrary) },
                            onChallengesRequested: { push(.challenges) },
                            onBack: { popToRoot() }
                        )

                    case .reading(let word):
                        ReadingView(
                            word: word,
                            onBack: { pop() }
                        )

                    case .pronunciation(let word):
                        PronunciationView(word: word, onBack: { pop() })

                    case .storyLibrary:
                        StoryLibraryView(
                            onStorySelected: { push(.storyReading($0.id)) },
                            onBack: { pop() }
                        )

                    case .storyReading(let storyId):
                        if let story = StoryLibrary.stories.first(where: { $0.id == storyId }) {
                            StoryReaderView(
                                story: story,
                                onBack: { pop() },
                                onWordSelected: { push(.pronunciation($0)) }
                            )
                        } else {
                            Text("Story not found")
                        }

                    case .progress:
                        ProgressView(onBack: { popToRoot() })

                    case .challenges:
                        ChallengesSelectionView(
                            onChallengeSelected: { type, word in
                                push(.challenge(type, word))
                            },
                            onBack: { pop() }
                        )

                    case .challenge(let type, let word):
                        ChallengeView(
                            challengeType: type,
                            word: word,
                            onBack: { pop() }
                        )
                    }
                }
            }
            .preferredColorScheme(.light)
            .fullScreenCover(item: $sheet) { sheet in
                switch sheet {
                case .scanning:
                    #if canImport(UIKit)
                    ZStack(alignment: .topTrailing) {
                        ScanTextView { scannedText in
                            self.sheet = nil
                            DispatchQueue.main.async {
                                let cleaned = scannedText.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !cleaned.isEmpty else { return }
                                push(.reading(cleaned))
                            }
                        }
                        .ignoresSafeArea()

                        VStack {
                            HStack {
                                Spacer()
                                Button(action: { self.sheet = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.readBetter(size: 28))
                                        .symbolRenderingMode(.hierarchical)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(AppLayout.spacing16)
                            }
                            Spacer()
                        }

                        VStack {
                            Spacer()
                            Text("Tap a word to capture it")
                                .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(AppLayout.spacing16)
                                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard))
                                .padding(.horizontal, AppLayout.horizontalPadding(isIPad: false))
                                .padding(.bottom, AppLayout.spacing48)
                        }
                    }
                    #else
                    Text("Scanning not supported")
                    #endif
                }
            }
            
            if !isReady {
                KidLoaderView(theme: theme.currentTheme, message: "Getting ready...")
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            // App shows welcome immediately (isReady = true by default).
        }
    }
    
    private func push(_ route: Route) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            path.append(route)
        }
    }
    
    private func pop() {
        guard !path.isEmpty else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            _ = path.popLast()
        }
    }
    
    private func popToRoot() {
        guard !path.isEmpty else { return }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            path.removeAll()
        }
    }
}
