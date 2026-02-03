import SwiftUI

// MARK: - Jungle / Forest decorative frame (storybook-style border)
// Inspired by lush foliage, vines, and playful explorers. Clear center for content.

struct JungleFrameView: View {
    var opacity: Double = 1.0
    @State private var sway: Double = 0
    @State private var rustle: Double = 0
    
    private let forestGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    private let teal = Color(red: 0.2, green: 0.55, blue: 0.45)
    private let lime = Color(red: 0.5, green: 0.75, blue: 0.4)
    private let olive = Color(red: 0.45, green: 0.55, blue: 0.35)
    private let vineBrown = Color(red: 0.45, green: 0.35, blue: 0.25)
    
    var body: some View {
        ZStack {
                // Top-left: monkey on vine
                VStack {
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VineShape()
                                .stroke(vineBrown, lineWidth: 5)
                                .frame(width: 80, height: 100)
                                .offset(x: 8, y: -10)
                                .rotationEffect(.degrees(-15))
                            
                            Image(systemName: "leaf.fill")
                                .font(.readBetter(size: 28))
                                .foregroundStyle(forestGreen)
                                .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
                                .offset(x: 4, y: 20)
                                .rotationEffect(.degrees(-8))
                        }
                        .frame(width: 100, height: 120)
                        Spacer()
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 12)
                
                // Top border – leaves & vines
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        LeafCluster(colors: [forestGreen, teal, lime], sway: sway, rustle: rustle, phaseOffset: 0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        LeafCluster(colors: [olive, lime], sway: sway, rustle: rustle, phaseOffset: 0.4)
                            .frame(width: 60, alignment: .center)
                        LeafCluster(colors: [teal, forestGreen, olive], sway: sway, rustle: rustle, phaseOffset: 0.8)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(height: 56)
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .padding(.top, 8)
                
                // Top-right: butterfly
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "leaf.circle.fill")
                            .font(.readBetter(size: 22))
                            .foregroundStyle(teal.opacity(0.9))
                            .offset(x: sin(sway * .pi * 2) * 4, y: cos(sway * .pi * 2) * 3)
                    }
                    .padding(.trailing, 28)
                    .padding(.top, 36)
                    Spacer()
                }
                
                // Bottom border – explorers peeking + foliage
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ExplorerPeek(iconName: "hand.wave.fill", hat: false)
                        ExplorerPeek(iconName: "hand.raised.fill", hat: false)
                        ExplorerPeek(iconName: "person.fill", hat: true)
                        ExplorerPeek(iconName: "map.fill", hat: false)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    
                    HStack(spacing: 0) {
                        BottomLeafCluster(colors: [forestGreen, lime, olive], flowers: true, sway: sway, rustle: rustle, phaseOffset: 0.2)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 8)
                
                // Left border – vines & leaves
                HStack {
                    SideLeafStrip(colors: [teal, forestGreen, olive], sway: sway, rustle: rustle, phaseOffset: 0)
                        .frame(width: 40)
                    Spacer()
                }
                .padding(.leading, 8)
                
                // Right border
                HStack {
                    Spacer()
                    SideLeafStrip(colors: [forestGreen, lime, teal], sway: sway, rustle: rustle, phaseOffset: 0.5)
                        .frame(width: 40)
                }
                .padding(.trailing, 8)
        }
        .opacity(opacity)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true)) { sway = 1 }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) { rustle = 1 }
        }
    }
}

// MARK: - Leaf cluster (top)
private struct LeafCluster: View {
    let colors: [Color]
    let sway: Double
    var rustle: Double = 0
    var phaseOffset: Double = 0
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(colors.enumerated()), id: \.offset) { i, c in
                let s = sway + phaseOffset + Double(i) * 0.35
                let r = rustle + Double(i) * 0.5
                LeafShape()
                    .fill(c.opacity(0.85))
                    .frame(width: 24 + CGFloat(i) * 4, height: 14 + CGFloat(i) * 2)
                    .rotationEffect(.degrees(Double(i) * 12 - 6 + sin(s * .pi * 2) * 10 + sin(r * .pi * 2) * 6))
                    .offset(y: sin(s * .pi * 2) * 4)
                    .offset(x: sin(r * .pi * 2 + Double(i) * 0.7) * 3)
            }
        }
    }
}

// MARK: - Bottom leaf cluster with flowers
private struct BottomLeafCluster: View {
    let colors: [Color]
    let flowers: Bool
    let sway: Double
    var rustle: Double = 0
    var phaseOffset: Double = 0
    
    private let pink = Color(red: 1.0, green: 0.75, blue: 0.8)
    private let coral = Color(red: 1.0, green: 0.6, blue: 0.65)
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<6, id: \.self) { i in
                if i == 2 || i == 4, flowers {
                    Circle().fill(i == 2 ? pink : coral).frame(width: 9, height: 9)
                }
                let s = sway + phaseOffset + Double(i) * 0.3
                let r = rustle + Double(i) * 0.4
                LeafShape()
                    .fill(colors[i % colors.count].opacity(0.9))
                    .frame(width: 24 + CGFloat(i % 3) * 4, height: 14)
                    .rotationEffect(.degrees(Double(i) * -6 + 3 + sin(s * .pi * 2) * 8 + sin(r * .pi * 2) * 4))
                    .offset(y: sin(s * .pi * 2) * 4)
                    .offset(x: sin(r * .pi * 2 + Double(i) * 0.6) * 2)
            }
            if flowers {
                Circle().fill(pink).frame(width: 10, height: 10)
            }
        }
    }
}

// MARK: - Side vertical leaf strip
private struct SideLeafStrip: View {
    let colors: [Color]
    let sway: Double
    var rustle: Double = 0
    var phaseOffset: Double = 0
    
    var body: some View {
        VStack(spacing: 6) {
            ForEach(0..<8, id: \.self) { i in
                let s = sway + phaseOffset + Double(i) * 0.4
                let r = rustle + Double(i) * 0.35
                LeafShape()
                    .fill(colors[i % colors.count].opacity(0.75))
                    .frame(width: 18, height: 10)
                    .rotationEffect(.degrees(Double(i % 2) * 20 - 10 + sin(s * .pi * 2) * 12 + sin(r * .pi * 2) * 5))
                    .offset(x: sin(s * .pi * 2) * 5)
                    .offset(y: sin(r * .pi * 2 + Double(i) * 0.5) * 2)
            }
        }
    }
}

// MARK: - Explorer peek (bottom)
private struct ExplorerPeek: View {
    let iconName: String
    let hat: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.45, green: 0.62, blue: 0.48))
                .frame(height: 24)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.35, green: 0.5, blue: 0.35), lineWidth: 1)
                )
            Image(systemName: iconName)
                .font(.readBetter(size: hat ? 14 : 12))
                .foregroundStyle(.white.opacity(0.95))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Simple vine path
private struct VineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.2, y: 0))
        p.addQuadCurve(to: CGPoint(x: w * 0.8, y: h * 0.5), control: CGPoint(x: 0, y: h * 0.3))
        p.addQuadCurve(to: CGPoint(x: w * 0.3, y: h), control: CGPoint(x: w, y: h * 0.75))
        return p
    }
}

// MARK: - Organic leaf shape
private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w * 0.5, y: 0))
        p.addCurve(
            to: CGPoint(x: w, y: h * 0.5),
            control1: CGPoint(x: w * 0.9, y: 0),
            control2: CGPoint(x: w, y: h * 0.3)
        )
        p.addCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control1: CGPoint(x: w * 0.85, y: h * 0.85),
            control2: CGPoint(x: w * 0.6, y: h)
        )
        p.addCurve(
            to: CGPoint(x: 0, y: h * 0.5),
            control1: CGPoint(x: w * 0.4, y: h),
            control2: CGPoint(x: 0, y: h * 0.85)
        )
        p.addCurve(
            to: CGPoint(x: w * 0.5, y: 0),
            control1: CGPoint(x: 0, y: h * 0.15),
            control2: CGPoint(x: w * 0.1, y: 0)
        )
        return p
    }
}

// MARK: - Container: gradient background + jungle frame + content
struct JungleFrameContainer<Content: View>: View {
    var content: Content
    var frameOpacity: Double = 0.95
    
    init(frameOpacity: Double = 0.95, @ViewBuilder content: () -> Content) {
        self.frameOpacity = frameOpacity
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.88, green: 0.96, blue: 0.9),
                    Color(red: 0.94, green: 0.98, blue: 0.94)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            JungleFrameView(opacity: frameOpacity)
            
            content
                .padding(.top, 52)
                .padding(.bottom, 100)
                .padding(.horizontal, 32)
        }
    }
}
