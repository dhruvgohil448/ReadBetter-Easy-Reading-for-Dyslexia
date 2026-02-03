import SwiftUI

// MARK: - Liquid Glass Effect Modifier (optional opacity so background shows through)
struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    var strokeColor: Color = .white.opacity(0.3)
    var strokeWidth: CGFloat = 1.5
    var shadowRadius: CGFloat = 10
    var material: Material = .ultraThinMaterial
    var glassOpacity: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(material)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(strokeColor, lineWidth: strokeWidth)
                    )
                    .opacity(glassOpacity)
                    .shadow(color: .black.opacity(0.06), radius: shadowRadius, y: 2)
            )
    }
}

extension View {
    func liquidGlass(
        cornerRadius: CGFloat = 20,
        strokeColor: Color = .white.opacity(0.3),
        strokeWidth: CGFloat = 1.5,
        shadowRadius: CGFloat = 10,
        material: Material = .ultraThinMaterial,
        glassOpacity: CGFloat = 1.0
    ) -> some View {
        modifier(LiquidGlassModifier(
            cornerRadius: cornerRadius,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
            shadowRadius: shadowRadius,
            material: material,
            glassOpacity: glassOpacity
        ))
    }
}

// MARK: - Bouncy, kid-friendly button style
struct KidButtonStyle: ButtonStyle {
    var scaleAmount: CGFloat = 0.96
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleAmount : 1.0)
            .onChange(of: configuration.isPressed) { _, isPressed in
                guard isPressed else { return }
                Haptics.playTap()
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Custom theme-based loader (no default spinner)
struct KidLoaderView: View {
    let theme: AppTheme
    var message: String = "Getting ready..."
    
    @State private var phase: Double = 0
    @State private var bounce: CGFloat = 0
    @State private var rotation: Double = 0
    
    private var accentColor: Color {
        theme.primaryColor
    }
    
    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme)
            ThemeAmbientView(theme: theme, isInteractive: false)
                .opacity(0.6)
            
            VStack(spacing: 28) {
                // Cute character + orbiting elements
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 80, height: 80)
                        .scaleEffect(1.1 + sin(phase) * 0.08)
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(accentColor)
                            .frame(width: 8, height: 8)
                            .offset(y: -28)
                            .rotationEffect(.degrees(rotation + Double(i) * 120))
                    }
                    Image(systemName: theme.loaderIconName)
                        .font(.readBetter(size: 36, weight: .medium))
                        .foregroundStyle(accentColor)
                        .scaleEffect(1 + bounce * 0.08)
                }
                .frame(height: 100)
                
                Text(message)
                    .font(.readBetter(size: 18, weight: .semibold))
                    .foregroundColor(theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                // Mini progress dots
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(accentColor)
                            .frame(width: 6, height: 6)
                            .scaleEffect(0.8 + sin(phase + Double(i) * 2.1) * 0.2)
                    }
                }
            }
            .padding(28)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { bounce = 1 }
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) { rotation = 360 }
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { phase = .pi * 2 }
        }
    }
}

// MARK: - Primary button for navigation (chevron indicates navigation). Uses theme label colors for contrast.
struct KidPrimaryButton: View {
    let title: String
    let subtitle: String?
    let iconName: String
    let color: Color
    var labelColor: Color?
    let action: () -> Void

    @Environment(\.horizontalSizeClass) private var sizeClass
    @ObservedObject private var theme = ThemeManager.shared

    private var isIPad: Bool { sizeClass == .regular }

    init(
        title: String,
        subtitle: String? = nil,
        iconName: String,
        color: Color,
        labelColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.color = color
        self.labelColor = labelColor
        self.action = action
    }

    private var resolvedLabelColor: Color {
        labelColor ?? theme.currentTheme.primaryButtonLabelColor
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppLayout.spacing16) {
                Image(systemName: iconName)
                    .font(.readBetter(size: isIPad ? 24 : 20, weight: .semibold))
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.readBetter(size: AppFontSize.bodyLarge, weight: .semibold))
                    if let sub = subtitle {
                        Text(sub)
                            .font(.readBetter(size: AppFontSize.caption))
                            .opacity(0.9)
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.readBetter(size: AppFontSize.body, weight: .semibold))
            }
            .foregroundColor(resolvedLabelColor)
            .padding(.horizontal, AppLayout.spacing16)
            .padding(.vertical, AppLayout.spacing16)
            .background(RoundedRectangle(cornerRadius: AppLayout.cornerRadiusCard).fill(color))
        }
        .buttonStyle(KidButtonStyle())
    }
}

// MARK: - Soft card, minimal
struct KidCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = 16
    var useBounce: Bool = true
    var useGlass: Bool = true
    
    init(padding: CGFloat = 16, useBounce: Bool = true, useGlass: Bool = true, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.useBounce = useBounce
        self.useGlass = useGlass
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .liquidGlass(cornerRadius: 14, shadowRadius: 6, material: useGlass ? .regularMaterial : .ultraThinMaterial)
    }
}

// MARK: - Screen transition modifier for smooth, playful transitions
struct KidTransitionModifier: ViewModifier {
    let edge: Edge
    
    func body(content: Content) -> some View {
        content
            .transition(.asymmetric(
                insertion: .move(edge: edge).combined(with: .opacity),
                removal: .move(edge: edge == .trailing ? .leading : .trailing).combined(with: .opacity)
            ))
    }
}

extension View {
    func kidTransition(edge: Edge = .trailing) -> some View {
        modifier(KidTransitionModifier(edge: edge))
    }
}
