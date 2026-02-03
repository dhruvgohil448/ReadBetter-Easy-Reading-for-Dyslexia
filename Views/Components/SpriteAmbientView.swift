import SwiftUI
import SpriteKit

#if canImport(UIKit)
import UIKit
#endif

// MARK: - SpriteKit-based ambient particles (fireflies, bubbles, sparkles) per theme
struct SpriteAmbientView: View {
    let theme: AppTheme
    var opacity: Double = 0.9

    var body: some View {
        SpriteKitViewRepresentable(theme: theme)
            .opacity(opacity)
            .allowsHitTesting(false)
    }
}

#if canImport(UIKit)
private struct SpriteKitViewRepresentable: UIViewRepresentable {
    let theme: AppTheme

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        view.backgroundColor = .clear
        view.ignoresSiblingOrder = true
        view.preferredFramesPerSecond = 60
        let size = view.bounds.size
        let safeSize = (size.width > 0 && size.height > 0) ? size : fallbackSceneSize
        let scene = AmbientParticleScene(size: safeSize, theme: theme)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        view.presentScene(scene)
        return view
    }

    private var fallbackSceneSize: CGSize {
        #if canImport(UIKit)
        return UIScreen.main.bounds.size
        #else
        return CGSize(width: 375, height: 667)
        #endif
    }

    func updateUIView(_ view: SKView, context: Context) {
        let size = view.bounds.size
        let safeSize = (size.width > 0 && size.height > 0) ? size : fallbackSceneSize
        if let scene = view.scene as? AmbientParticleScene, scene.theme != theme {
            let newScene = AmbientParticleScene(size: safeSize, theme: theme)
            newScene.scaleMode = .resizeFill
            newScene.backgroundColor = .clear
            view.presentScene(newScene)
        } else if view.scene == nil {
            let scene = AmbientParticleScene(size: safeSize, theme: theme)
            scene.scaleMode = .resizeFill
            scene.backgroundColor = .clear
            view.presentScene(scene)
        }
    }
}

private final class AmbientParticleScene: SKScene {
    let theme: AppTheme

    init(size: CGSize, theme: AppTheme) {
        self.theme = theme
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) { nil }

    override func didMove(to view: SKView) {
        removeAllChildren()
        guard size.width > 0, size.height > 0 else { return }
        switch theme {
        case .forest:
            addForestParticles()
        case .ocean:
            addOceanParticles()
        case .sunset:
            addSunsetParticles()
        }
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if size != oldSize, size.width > 0, size.height > 0 {
            removeAllChildren()
            switch theme {
            case .forest: addForestParticles()
            case .ocean: addOceanParticles()
            case .sunset: addSunsetParticles()
            }
        }
    }

    private func addForestParticles() {
        guard let tex = makeCircleTexture(diameter: 8, color: .yellow) else { return }
        let emitter = SKEmitterNode()
        emitter.particleTexture = tex
        emitter.particleBirthRate = 4
        emitter.particleLifetime = 8
        emitter.particleLifetimeRange = 2
        emitter.particlePositionRange = CGVector(dx: size.width + 80, dy: size.height + 80)
        emitter.particlePosition = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        emitter.particleAlpha = 0.4
        emitter.particleAlphaRange = 0.3
        emitter.particleAlphaSpeed = 0.1
        emitter.particleScale = 0.4
        emitter.particleScaleRange = 0.3
        emitter.particleSpeed = 12
        emitter.particleSpeedRange = 8
        emitter.emissionAngleRange = .pi * 2
        emitter.particleBlendMode = .add
        emitter.zPosition = -1
        addChild(emitter)
    }

    private func addOceanParticles() {
        guard let tex = makeCircleTexture(diameter: 12, color: .white) else { return }
        let emitter = SKEmitterNode()
        emitter.particleTexture = tex
        emitter.particleBirthRate = 6
        emitter.particleLifetime = 10
        emitter.particleLifetimeRange = 3
        emitter.particlePositionRange = CGVector(dx: size.width + 60, dy: 0)
        emitter.particlePosition = CGPoint(x: size.width * 0.5, y: -20)
        emitter.particleAlpha = 0.35
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = 0.02
        emitter.particleScale = 0.25
        emitter.particleScaleRange = 0.2
        emitter.particleSpeed = 25
        emitter.particleSpeedRange = 10
        emitter.emissionAngle = .pi * 0.5
        emitter.emissionAngleRange = .pi * 0.3
        emitter.xAcceleration = CGFloat.random(in: -5...5)
        emitter.particleBlendMode = .alpha
        emitter.zPosition = -1
        addChild(emitter)
    }

    private func addSunsetParticles() {
        guard let tex = makeCircleTexture(diameter: 6, color: UIColor(red: 1, green: 0.85, blue: 0.4, alpha: 1)) else { return }
        let emitter = SKEmitterNode()
        emitter.particleTexture = tex
        emitter.particleBirthRate = 8
        emitter.particleLifetime = 6
        emitter.particleLifetimeRange = 2
        emitter.particlePositionRange = CGVector(dx: size.width + 100, dy: size.height + 100)
        emitter.particlePosition = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        emitter.particleAlpha = 0.35
        emitter.particleAlphaRange = 0.25
        emitter.particleAlphaSpeed = 0.05
        emitter.particleScale = 0.3
        emitter.particleScaleRange = 0.2
        emitter.particleSpeed = 6
        emitter.particleSpeedRange = 10
        emitter.emissionAngleRange = .pi * 2
        emitter.particleBlendMode = .add
        emitter.zPosition = -1
        addChild(emitter)
    }

    private func makeCircleTexture(diameter: CGFloat, color: UIColor) -> SKTexture? {
        let size = CGSize(width: diameter, height: diameter)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: CGRect(origin: .zero, size: size))
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return SKTexture(image: img)
    }
}
#endif
