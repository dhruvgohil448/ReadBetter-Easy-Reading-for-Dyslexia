import SwiftUI

// MARK: - Theme ambient background with playful animations (SwiftUI + SpriteKit)
struct ThemeAmbientView: View {
    let theme: AppTheme
    var isInteractive: Bool = false

    @ObservedObject private var themeManager = ThemeManager.shared

    var body: some View {
        ZStack {
            if !themeManager.calmMode {
                switch theme {
                case .forest:
                    ForestAmbientView(isInteractive: isInteractive)
                case .ocean:
                    OceanAmbientView(isInteractive: isInteractive)
                case .sunset:
                    SunsetAmbientView(isInteractive: isInteractive)
                }
                SpriteAmbientView(theme: theme, opacity: 0.85)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Forest: magical dusk scene with animated bears, fireflies, mushrooms
struct ForestAmbientView: View {
    var isInteractive: Bool
    @State private var treeSway: Double = 0
    @State private var fireflyPhase: Double = 0
    
    var body: some View {
        ZStack {
            // A subtle haze so text stays readable on top
            forestMistyHaze
            
            // Glowing fireflies/orbs
            forestFireflies
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) { treeSway = .pi * 2 }
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) { fireflyPhase = .pi * 2 }
        }
    }
    
    private var forestMistyHaze: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.08),
                        Color.black.opacity(0.04),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
    }
    
    private var forestFireflies: some View {
        ForEach(0..<12, id: \.self) { i in
            let p = fireflyPhase + Double(i) * 0.5
            let baseX = CGFloat(i % 4) * 90 - 130
            let baseY = CGFloat(i / 4) * 140 - 80
            
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.yellow.opacity(0.9 + sin(p * 1.5) * 0.1),
                                Color.yellow.opacity(0.5),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 16
                        )
                    )
                    .frame(width: 32, height: 32)
                    .blur(radius: 5)
                
                // Core light
                Circle()
                    .fill(Color.yellow.opacity(0.95 + sin(p * 1.5) * 0.05))
                    .frame(width: 12, height: 12)
            }
            .offset(
                x: baseX + CGFloat(sin(p * 1.2) * 35),
                y: baseY + CGFloat(cos(p * 0.8) * 30)
            )
        }
    }
}

// MARK: - Ocean: underwater scene (light rays, seabed, corals, kelp, fish school, bubbles)
struct OceanAmbientView: View {
    var isInteractive: Bool
    @State private var bubbleY: CGFloat = 0
    @State private var rayPhase: Double = 0
    @State private var fishSchoolX: CGFloat = 0
    @State private var fishSchool2X: CGFloat = 0
    @State private var kelpSway: Double = 0
    @State private var jellyFloat: Double = 0
    @State private var turtleSwim: CGFloat = 0
    @State private var currentWave: Double = 0
    @State private var seabedShimmer: Double = 0
    @State private var coralPulse: Double = 0
    
    private let sand = Color(red: 0.95, green: 0.88, blue: 0.7)
    private let coralRed = Color(red: 0.95, green: 0.4, blue: 0.35)
    private let coralPink = Color(red: 1.0, green: 0.55, blue: 0.65)
    private let coralGreen = Color(red: 0.5, green: 0.85, blue: 0.5)
    private let kelpGreen = Color(red: 0.3, green: 0.6, blue: 0.45)
    private let waterBlue = Color(red: 0.4, green: 0.75, blue: 0.95)
    
    var body: some View {
        ZStack {
            oceanLightRays
            oceanBubbles
            oceanFishSchool
            oceanFishSchool2
            oceanKelp
            oceanCorals
            oceanSeabed
            oceanTurtle
            oceanJelly
            oceanCurrentLayer
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) { bubbleY = 600 }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) { rayPhase = .pi * 2 }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: true)) { fishSchoolX = 420 }
            withAnimation(.linear(duration: 24).repeatForever(autoreverses: true)) { fishSchool2X = 400 }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { kelpSway = .pi * 2 }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { jellyFloat = .pi * 2 }
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) { turtleSwim = 50 }
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) { currentWave = .pi * 2 }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) { seabedShimmer = .pi * 2 }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) { coralPulse = .pi * 2 }
        }
    }
    
    private var oceanLightRays: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                LightRayShape(phase: rayPhase + Double(i) * 0.4)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.12 + sin(rayPhase + Double(i)) * 0.04),
                                Color.white.opacity(0.02),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80 + CGFloat(i) * 20, height: 500)
                    .offset(x: CGFloat(i) * 90 - 180)
            }
        }
        .offset(y: -100)
    }
    
    private var oceanBubbles: some View {
        ForEach(0..<12, id: \.self) { i in
            let size = 8 + CGFloat(i % 4) * 5
            let speed = 0.25 + Double(i % 3) * 0.1
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.15)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .offset(
                    x: CGFloat(i) * 38 - 200 + CGFloat(sin(bubbleY * 0.015 + Double(i) * 1.2)) * 20,
                    y: -bubbleY * CGFloat(speed) - CGFloat(i) * 45
                )
        }
    }
    
    private var oceanFishSchool: some View {
        HStack(spacing: 12) {
            ForEach(0..<8, id: \.self) { i in
                Ellipse()
                    .fill(Color.white.opacity(0.25 - Double(i) * 0.02))
                    .frame(width: 14, height: 8)
                    .scaleEffect(x: -1, y: 1)
            }
        }
        .offset(x: -200 + fishSchoolX * 0.5, y: -180)
    }
    
    private var oceanFishSchool2: some View {
        HStack(spacing: 14) {
            ForEach(0..<5, id: \.self) { i in
                Ellipse()
                    .fill(Color.white.opacity(0.18 - Double(i) * 0.02))
                    .frame(width: 12, height: 6)
            }
        }
        .offset(x: 180 - fishSchool2X * 0.4, y: -80)
    }
    
    private var oceanKelp: some View {
        HStack(spacing: 50) {
            ForEach(0..<4, id: \.self) { i in
                KelpShape(sway: kelpSway + Double(i) * 0.5)
                    .stroke(kelpGreen.opacity(0.5), lineWidth: 6)
                    .frame(width: 24, height: 120)
                    .offset(x: CGFloat(i) * 100 - 150, y: 180)
            }
        }
    }
    
    private var oceanCorals: some View {
        HStack(alignment: .bottom, spacing: 30) {
            CoralBlobShape()
                .fill(coralRed.opacity(0.6))
                .frame(width: 50, height: 35)
                .scaleEffect(1 + sin(coralPulse) * 0.03)
                .offset(x: -120, y: 20)
            CoralBlobShape()
                .fill(coralGreen.opacity(0.55))
                .frame(width: 40, height: 28)
                .scaleEffect(1 + sin(coralPulse + 0.8) * 0.03)
                .offset(x: -60, y: 24)
            CoralBlobShape()
                .fill(coralPink.opacity(0.5))
                .frame(width: 55, height: 38)
                .scaleEffect(1 + sin(coralPulse + 1.6) * 0.03)
                .offset(x: 100, y: 18)
        }
        .offset(y: 160)
    }
    
    private var oceanSeabed: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [sand.opacity(0.4), sand.opacity(0.25)],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(height: 90)
                .overlay(
                    HStack(spacing: 24) {
                        ForEach(0..<5, id: \.self) { i in
                            Circle()
                                .fill(Color.white.opacity(0.35 + sin(seabedShimmer + Double(i)) * 0.08))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .offset(y: -22),
                    alignment: .top
                )
        }
    }
    
    private var oceanTurtle: some View {
        Ellipse()
            .fill(Color.white.opacity(0.2))
            .frame(width: 28, height: 18)
            .offset(x: 130 + turtleSwim, y: 100)
    }
    
    private var oceanJelly: some View {
        Circle()
            .fill(Color.white.opacity(0.2))
            .frame(width: 20, height: 20)
            .offset(
                x: -100 + CGFloat(cos(jellyFloat) * 25),
                y: -120 + CGFloat(sin(jellyFloat * 0.8) * 15)
            )
    }
    
    private var oceanCurrentLayer: some View {
        ZStack {
            WaveShape(phase: currentWave, amplitude: 6)
                .stroke(waterBlue.opacity(0.08), lineWidth: 2)
                .offset(y: 120)
            WaveShape(phase: currentWave * 0.7 + 1, amplitude: 4)
                .stroke(waterBlue.opacity(0.05), lineWidth: 1)
                .offset(y: 140)
        }
    }
}

private struct LightRayShape: Shape {
    var phase: Double
    var animatableData: Double { get { phase } set { phase = newValue } }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let sway = sin(phase) * 15
        p.move(to: CGPoint(x: w * 0.5 + sway, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.5 - sway * 0.5, y: h), control: CGPoint(x: w * 0.3, y: h * 0.5))
        p.addLine(to: CGPoint(x: w * 0.5 + sway * 0.5, y: h))
        p.addQuadCurve(to: CGPoint(x: w * 0.5 - sway, y: 0), control: CGPoint(x: w * 0.7, y: h * 0.5))
        p.closeSubpath()
        return p
    }
}

private struct KelpShape: Shape {
    var sway: Double
    var animatableData: Double { get { sway } set { sway = newValue } }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let s = CGFloat(sin(sway) * 8)
        p.move(to: CGPoint(x: w / 2, y: h))
        p.addQuadCurve(to: CGPoint(x: w / 2 + s, y: h * 0.5), control: CGPoint(x: w / 2 + s * 1.5, y: h * 0.75))
        p.addQuadCurve(to: CGPoint(x: w / 2 - s * 0.5, y: 0), control: CGPoint(x: w / 2 - s, y: h * 0.25))
        return p
    }
}

private struct CoralBlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.addRoundedRect(in: rect, cornerSize: CGSize(width: rect.width * 0.4, height: rect.height * 0.3))
        return p
    }
}

struct WaveShape: Shape {
    var phase: Double
    var amplitude: CGFloat
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let midY = rect.midY
        let w = rect.width
        let step: CGFloat = 4
        p.move(to: CGPoint(x: 0, y: midY))
        for x in stride(from: 0, through: w + step, by: step) {
            let y = midY + sin(phase + Double(x) * 0.02) * amplitude
            p.addLine(to: CGPoint(x: x, y: y))
        }
        return p
    }
}

// MARK: - Sunset: gradient sky, glowing sun with rays, drifting clouds, water reflection, birds, sparkles, flowers
struct SunsetAmbientView: View {
    var isInteractive: Bool
    @State private var sunGlow: Double = 0
    @State private var rayExpand: Double = 0
    @State private var cloudX: CGFloat = 0
    @State private var cloud2X: CGFloat = 0
    @State private var birdX: CGFloat = 0
    @State private var reflectionShimmer: Double = 0
    @State private var sparklePhase: Double = 0
    @State private var flowerBob: Double = 0
    
    private let gold = Color(red: 1.0, green: 0.85, blue: 0.4)
    private let coral = Color(red: 1.0, green: 0.55, blue: 0.45)
    private let deepPurple = Color(red: 0.5, green: 0.4, blue: 0.65)
    
    var body: some View {
        ZStack {
            sunsetSparkles
            sunsetSunWithRays
            sunsetClouds
            sunsetBirds
            sunsetReflection
            sunsetFlowers
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) { sunGlow = .pi * 2 }
            withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) { rayExpand = .pi * 2 }
            withAnimation(.linear(duration: 28).repeatForever(autoreverses: false)) { cloudX = 120 }
            withAnimation(.linear(duration: 35).repeatForever(autoreverses: false)) { cloud2X = 100 }
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) { birdX = 60 }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) { reflectionShimmer = .pi * 2 }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) { sparklePhase = .pi * 2 }
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) { flowerBob = .pi * 2 }
        }
    }
    
    private var sunsetSparkles: some View {
        ForEach(0..<12, id: \.self) { i in
            let p = sparklePhase + Double(i) * 0.5
            Circle()
                .fill(
                    RadialGradient(
                        colors: [gold.opacity(0.3), gold.opacity(0.05), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 6
                    )
                )
                .frame(width: 10, height: 10)
                .offset(
                    x: CGFloat(i % 4) * 100 - 150 + CGFloat(sin(p) * 30),
                    y: CGFloat(i / 4) * 180 - 150 + CGFloat(cos(p * 0.8) * 25)
                )
                .opacity(0.4 + sin(p * 1.2) * 0.2)
        }
    }
    
    private var sunsetSunWithRays: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                SunsetRayShape(expand: rayExpand)
                    .fill(
                        LinearGradient(
                            colors: [gold.opacity(0.08), gold.opacity(0.02), Color.clear],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 18, height: 80)
                    .rotationEffect(.degrees(Double(i) * 45))
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            gold.opacity(0.12),
                            coral.opacity(0.08),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(width: 120, height: 120)
                .scaleEffect(1 + sin(sunGlow) * 0.03)
            
        }
        .offset(x: 100, y: -180)
        .opacity(0.6)
    }
    
    private var sunsetClouds: some View {
        VStack {
            HStack(spacing: 50) {
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 60, height: 24)
                    .offset(x: cloudX)
                Capsule()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 48, height: 20)
                    .offset(x: cloudX * 0.6 + 60)
            }
            .offset(y: -280)
            HStack(spacing: 40) {
                Capsule()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 44, height: 18)
                    .offset(x: cloud2X * 0.8)
                Capsule()
                    .fill(Color.white.opacity(0.14))
                    .frame(width: 36, height: 14)
                    .offset(x: cloud2X * 0.5 - 40)
            }
            .offset(y: -240)
            Spacer()
        }
    }
    
    private var sunsetBirds: some View {
        HStack(spacing: 35) {
            Ellipse()
                .fill(Color.white.opacity(0.2))
                .frame(width: 16, height: 8)
                .offset(x: birdX)
            Ellipse()
                .fill(Color.white.opacity(0.16))
                .frame(width: 12, height: 6)
                .offset(x: birdX * 0.85 + 25)
                .scaleEffect(x: -1, y: 1)
        }
        .offset(y: -320)
    }
    
    private var sunsetReflection: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        colors: [
                            gold.opacity(0.15 + sin(reflectionShimmer) * 0.05),
                            coral.opacity(0.1),
                            deepPurple.opacity(0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 80)
        }
    }
    
    private var sunsetFlowers: some View {
        VStack {
            Spacer()
            HStack {
                Circle()
                    .fill(gold.opacity(0.2))
                    .frame(width: 16, height: 16)
                    .offset(x: -140, y: -60 + sin(flowerBob) * 6)
                Spacer()
                Circle()
                    .fill(gold.opacity(0.18))
                    .frame(width: 14, height: 14)
                    .offset(x: 130, y: -55 + cos(flowerBob * 1.1) * 5)
            }
        }
    }
}

private struct SunsetRayShape: Shape {
    var expand: Double
    var animatableData: Double { get { expand } set { expand = newValue } }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let e = CGFloat(0.5 + sin(expand) * 0.15)
        p.move(to: CGPoint(x: w * 0.5 - w * e * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5 + w * e * 0.5, y: 0))
        p.addLine(to: CGPoint(x: w * 0.5 + w * 0.3, y: h))
        p.addLine(to: CGPoint(x: w * 0.5 - w * 0.3, y: h))
        p.closeSubpath()
        return p
    }
}
