import SwiftUI
#if canImport(CoreMotion)
import CoreMotion
#endif

/// Device tilt (roll, pitch) for parallax backgrounds. Safe for Swift Playgrounds / Student Challenge; no-op when motion unavailable.
@MainActor
final class DeviceMotionManager: ObservableObject {
    static let shared = DeviceMotionManager()
    
    @Published private(set) var roll: Double = 0
    @Published private(set) var pitch: Double = 0
    @Published private(set) var isActive = false
    
    #if canImport(CoreMotion)
    private let motionManager = CMMotionManager()
    private let parallaxFactor: Double = 55
    #endif
    
    private init() {}
    
    func start() {
        #if canImport(CoreMotion)
        guard motionManager.isDeviceMotionAvailable else { return }
        if motionManager.isDeviceMotionActive { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self = self, let motion = motion else { return }
            let att = motion.attitude
            self.roll = att.roll
            self.pitch = att.pitch
        }
        isActive = true
        #endif
    }
    
    func stop() {
        #if canImport(CoreMotion)
        motionManager.stopDeviceMotionUpdates()
        roll = 0
        pitch = 0
        isActive = false
        #endif
    }
    
    /// Parallax offset from device tilt (points). Multiplier: 1 = front layer, 0.4 = mid, 0.2 = back.
    func parallaxOffset(multiplier: CGFloat = 1.0) -> CGSize {
        #if canImport(CoreMotion)
        let x = roll * parallaxFactor * Double(multiplier)
        let y = pitch * parallaxFactor * Double(multiplier)
        return CGSize(width: x, height: y)
        #else
        return .zero
        #endif
    }
    
    /// Subtle rotation from roll (degrees).
    func parallaxRotation(multiplier: CGFloat = 1.0) -> Angle {
        #if canImport(CoreMotion)
        let deg = roll * (180 / .pi) * 0.4 * Double(multiplier)
        return .degrees(deg)
        #else
        return .degrees(0)
        #endif
    }
}
