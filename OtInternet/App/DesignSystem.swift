import SwiftUI

extension Color {
    static let otInk = Color(red: 0.02, green: 0.05, blue: 0.11)
    static let otPanel = Color(red: 0.04, green: 0.10, blue: 0.19)
    static let otBlue = Color(red: 0.18, green: 0.56, blue: 1.0)
    static let otMint = Color(red: 0.22, green: 0.84, blue: 0.74)
}

struct GlassCard<Content: View>: View {
    var content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        content()
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(.white.opacity(0.09)))
    }
}

struct SectionTitle: View {
    let title: String
    let action: String?
    var body: some View {
        HStack {
            Text(title).font(.title3.bold())
            Spacer()
            if let action { Text(action).font(.subheadline).foregroundStyle(.secondary) }
        }
    }
}

struct IconBadge: View {
    let symbol: String
    let color: Color
    var body: some View {
        Image(systemName: symbol)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 42, height: 42)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 13, style: .continuous))
    }
}
