import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import CoreText

// MARK: - OpenDyslexic Bold (dyslexia-friendly) for all app text
// Add opendyslexic.bold.otf to App/Resources or App/Resources/Fonts. Default: dyslexia font ON.

enum ReadBetterFont {
    /// UserDefaults key for the dyslexia toggle (top-left). true = OpenDyslexic Bold (default), false = normal system font.
    static let useDylexciaKey = "useDylexciaFont"

    /// OpenDyslexic Bold – used for all text (welcome, buttons, labels, etc.) when dyslexia font is ON.
    /// opendyslexic.bold.otf registers as OpenDyslexic-Bold (or OpenDyslexicBold).
    static let fontNameBold = "OpenDyslexic-Bold"
    static let fontNameBoldAlt = "OpenDyslexicBold"

    private static nonisolated(unsafe) var didRegister = false

    /// Whether the user has dyslexia font on (toggle). Default true = OpenDyslexic Bold on first launch.
    static var useDylexcia: Bool {
        get {
            (UserDefaults.standard.object(forKey: useDylexciaKey) as? Bool) ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: useDylexciaKey)
        }
    }

    /// Call once at app launch (e.g. from MyApp.init()). Registers OpenDyslexic from the app bundle.
    static func register() {
        guard !didRegister else { return }
        didRegister = true
        // opendyslexic.bold.otf for all text; optional opendyslexic.regular.otf
        let names = ["opendyslexic.bold", "OpenDyslexic-Bold", "OpenDyslexicBold", "opendyslexic.regular", "OpenDyslexic-Regular", "OpenDyslexic"]
        let ext = ["otf", "ttf"]
        var urls: [URL] = []
        for name in names {
            for e in ext {
                if let url = Bundle.main.url(forResource: name, withExtension: e) {
                    urls.append(url)
                }
                if let url = Bundle.main.url(forResource: name, withExtension: e, subdirectory: "Fonts") {
                    urls.append(url)
                }
            }
        }
        let unique = Array(Set(urls))
        if unique.isEmpty { return }
        CTFontManagerRegisterFontURLs(unique as CFArray, .process, true) { _, _ in true }
    }

    /// Returns true if OpenDyslexic Bold is available (after registration).
    static var isAvailable: Bool {
        #if canImport(UIKit)
        return UIFont(name: fontNameBold, size: 17) != nil || UIFont(name: fontNameBoldAlt, size: 17) != nil
        #else
        return false
        #endif
    }

    static let fontNameRegular = "OpenDyslexic-Regular"
    static let fontNameRegularAlt = "OpenDyslexicRegular"

    /// Font name for bold: OpenDyslexic Bold (opendyslexic.bold.otf).
    static func resolvedBoldName(size: CGFloat) -> String? {
        #if canImport(UIKit)
        if UIFont(name: fontNameBold, size: size) != nil { return fontNameBold }
        if UIFont(name: fontNameBoldAlt, size: size) != nil { return fontNameBoldAlt }
        return nil
        #else
        return nil
        #endif
    }

    /// Font name for regular: OpenDyslexic Regular (opendyslexic.regular.otf).
    static func resolvedRegularName(size: CGFloat) -> String? {
        #if canImport(UIKit)
        if UIFont(name: fontNameRegular, size: size) != nil { return fontNameRegular }
        if UIFont(name: fontNameRegularAlt, size: size) != nil { return fontNameRegularAlt }
        return nil
        #else
        return nil
        #endif
    }
}

extension Font {
    /// App-wide font: OpenDyslexic Bold or Regular when ON; system font when OFF.
    /// OpenDyslexic supports only .regular and .bold - other weights map to these.
    static func readBetter(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        guard ReadBetterFont.useDylexcia else {
            return .system(size: size, weight: weight, design: .default)
        }
        #if canImport(UIKit)
        let useBold = [.semibold, .bold, .black].contains(weight)
        if useBold, let n = ReadBetterFont.resolvedBoldName(size: size) {
            return .custom(n, size: size)
        }
        if let n = ReadBetterFont.resolvedRegularName(size: size) {
            return .custom(n, size: size)
        }
        if let n = ReadBetterFont.resolvedBoldName(size: size) {
            return .custom(n, size: size)
        }
        #endif
        return .system(size: size, weight: weight, design: .default)
    }
}
