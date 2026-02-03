import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// App-wide background that matches the selected theme. Static images only; no device-tilt parallax.
struct ThemeBackgroundView: View {
    let theme: AppTheme

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                backgroundLayer(size: proxy.size)

                // Gentle vignette so UI stays readable on all wallpapers.
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.10),
                        Color.clear,
                        Color.black.opacity(0.10)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }

    #if canImport(UIKit)
    private func themedBackgroundUIImage(for theme: AppTheme) -> UIImage? {
        let baseName: String? = {
            switch theme {
            case .forest: return "forest_theme_background"
            case .ocean: return "ocean_theme_background"
            case .sunset: return "sunset_theme_background"
            }
        }()

        guard let baseName else { return nil }

        if let img = UIImage(named: baseName) {
            return img
        }
        if let url = Bundle.main.url(forResource: baseName, withExtension: "png"),
           let img = UIImage(contentsOfFile: url.path) {
            return img
        }
        return nil
    }
    #endif

    @ViewBuilder
    private func backgroundLayer(size: CGSize) -> some View {
        switch theme {
        case .forest, .ocean, .sunset:
            #if canImport(UIKit)
            if let image = themedBackgroundUIImage(for: theme) {
                // Blurred fill (static)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
                    .blur(radius: 20)
                    .opacity(0.6)
                // Sharp layer (static, no parallax)
                Image(uiImage: image)
                    .interpolation(.high)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                gradientBackground
            }
            #else
            gradientBackground
            #endif
        }
    }

    private var gradientBackground: some View {
        LinearGradient(
            colors: theme.gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
