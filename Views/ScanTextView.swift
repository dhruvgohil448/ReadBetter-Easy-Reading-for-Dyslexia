import SwiftUI
import VisionKit
import Vision

#if canImport(UIKit)
struct ScanTextView: UIViewControllerRepresentable {
    var onTextRecognized: (String) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        do {
            try scanner.startScanning()
        } catch {
            print("ScanTextView: Failed to start scanning: \(error)")
            // Scanner will still be shown but won't work - user can dismiss
        }
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: ScanTextView
        
        init(_ parent: ScanTextView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            if case .text(let text) = item {
                // Clean up text: take the first word or the whole phrase?
                // For this app, let's take the first valid word or the whole thing if it's short.
                let cleaned = text.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
                parent.onTextRecognized(cleaned)
            }
        }
    }
}
#endif
