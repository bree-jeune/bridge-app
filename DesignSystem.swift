//
//  DesignSystem.swift
//  BridgeApp
//
//  Created by Bree Jeune on 1/6/26.
//

import SwiftUI

// MARK: - Colors
extension Color {
    // Premium Dark / Vibrant Theme
    static let bridgeBlue = Color(hex: "007AFF") ?? .blue
    static let bridgePurple = Color(hex: "5856D6") ?? .purple
    static let bridgePink = Color(hex: "FF2D55") ?? .pink
    static let bridgeBackground = Color(uiColor: .systemGroupedBackground) // Adaptive System Background
    
    // Gradients
    static var premiumGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [bridgeBlue, bridgePurple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var accentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [bridgePurple, bridgePink]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - View Modifiers

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground)) // Adaptive Card Background
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct NeoButton: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func glassCard() -> some View {
        self.modifier(GlassCard())
    }
    
    func neoButton(color: Color = .blue) -> some View {
        self.modifier(NeoButton(color: color))
    }
    
    func premiumTitle() -> some View {
        self.font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(.primary)
    }
    
    func sectionHeader() -> some View {
        self.font(.system(size: 14, weight: .bold, design: .default))
            .textCase(.uppercase)
            .foregroundColor(.secondary)
            .padding(.leading, 4)
            .padding(.bottom, 2)
    }
}
