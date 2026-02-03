import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

enum Haptics {
    /// Play a lightweight impact when the user taps an interactive element.
    @MainActor static func playTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .soft) {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
        #endif
    }
}
