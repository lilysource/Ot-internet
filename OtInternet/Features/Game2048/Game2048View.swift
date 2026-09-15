import SwiftUI

struct Game2048View: View {
    @EnvironmentObject private var store: OfflineStore
    @Environment(\.dismiss) private var dismiss
    @State private var game = Game2048Engine()
    @State private var showingGuide = false
    private var khmer: Bool { store.language == .khmer }

    private func move(_ direction: Game2048Engine.Direction) {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
            _ = game.move(direction)
            store.saveBestScore(game.score)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                HStack { ScorePill(title: khmer ? "ពិន្ទុ" : "SCORE", value: game.score); ScorePill(title: khmer ? "ល្អបំផុត" : "BEST", value: max(store.best2048, game.score)); Spacer(); Button { withAnimation { game.undo() } } label: { Image(systemName: "arrow.uturn.backward") }.buttonStyle(.bordered).accessibilityLabel("Undo") }
                GeometryReader { proxy in
                    let size = min(proxy.size.width, proxy.size.height)
                    VStack(spacing: 7) { ForEach(0..<4, id: \.self) { row in HStack(spacing: 7) { ForEach(0..<4, id: \.self) { column in TileView(value: game.tiles[row][column]).frame(width: (size - 21) / 4, height: (size - 21) / 4) } } } }
                        .padding(10).background(Color.otPanel, in: RoundedRectangle(cornerRadius: 16))
                        .frame(width: size, height: size).frame(maxWidth: .infinity)
                        .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                            let horizontal = abs(value.translation.width) > abs(value.translation.height)
                            let direction: Game2048Engine.Direction = horizontal ? (value.translation.width > 0 ? .right : .left) : (value.translation.height > 0 ? .down : .up)
                            move(direction)
                        })
                }.aspectRatio(1, contentMode: .fit)
                VStack(spacing: 6) {
                    Button { move(.up) } label: { Image(systemName: "chevron.up") }.buttonStyle(.bordered).accessibilityLabel(khmer ? "ឡើង" : "Move up")
                    HStack(spacing: 28) {
                        Button { move(.left) } label: { Image(systemName: "chevron.left") }.buttonStyle(.bordered).accessibilityLabel(khmer ? "ឆ្វេង" : "Move left")
                        Button { move(.down) } label: { Image(systemName: "chevron.down") }.buttonStyle(.bordered).accessibilityLabel(khmer ? "ចុះ" : "Move down")
                        Button { move(.right) } label: { Image(systemName: "chevron.right") }.buttonStyle(.bordered).accessibilityLabel(khmer ? "ស្តាំ" : "Move right")
                    }
                }
                HStack { Button(khmer ? "ហ្គេមថ្មី" : "New game") { withAnimation { game.restart() } }.buttonStyle(.borderedProminent); Button(khmer ? "ចាប់ផ្តើមឡើងវិញ" : "Restart", role: .destructive) { withAnimation { game.restart() } }.buttonStyle(.bordered); Button { showingGuide = true } label: { Image(systemName: "questionmark.circle") }.buttonStyle(.bordered).accessibilityLabel("How to play") }
                Text(khmer ? "អូស ឬចុចប៊ូតុងព្រួញ ដើម្បីផ្លាស់ទី" : "Swipe or use the arrows to move").font(.footnote).foregroundStyle(.secondary)
                Spacer()
            }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("2048").toolbar { ToolbarItem(placement: .cancellationAction) { Button(khmer ? "បិទ" : "Done") { dismiss() } } }
            .sheet(isPresented: $showingGuide) { GameGuideView(khmer: khmer) }
            .alert(khmer ? "ចប់ហ្គេម" : "Game over", isPresented: .constant(game.isGameOver)) { Button(khmer ? "ហ្គេមថ្មី" : "New game") { game.restart() } } message: { Text(khmer ? "គ្មានចលនាទៀតទេ។ ពិន្ទុរបស់អ្នកគឺ \(game.score)។" : "No more moves. Your score was \(game.score).") }
        }
    }
}

struct GameGuideView: View {
    let khmer: Bool
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Label(khmer ? "គោលដៅហ្គេម" : "Goal", systemImage: "target").font(.title2.bold())
                Text(khmer ? "បញ្ចូលលេខដូចគ្នា ដើម្បីបង្កើតលេខធំៗ ហើយព្យាយាមឱ្យបាន 2048។" : "Merge matching numbers to make bigger tiles and reach 2048.")
                Label(khmer ? "គន្លឹះលេង" : "Simple strategy", systemImage: "lightbulb.fill").font(.title2.bold()).foregroundStyle(.yellow)
                Text(khmer ? "រក្សាលេខធំបំផុតនៅជ្រុងមួយ។ រៀបចំលេខតាមជួរ ហើយកុំផ្លាស់ទីដោយចៃដន្យ។" : "Keep your biggest tile in one corner. Build rows carefully and avoid random moves.")
                Label(khmer ? "ចាប់ផ្តើម" : "Easy controls", systemImage: "hand.draw").font(.title2.bold()).foregroundStyle(Color.otBlue)
                Text(khmer ? "អូសក្តារហ្គេម ឬចុចប៊ូតុងព្រួញ។ ហ្គេមនេះដំណើរការដោយគ្មានអ៊ីនធឺណិត។" : "Swipe the board or tap the arrow buttons. The game works fully offline.")
                Spacer()
            }.padding().navigationTitle(khmer ? "របៀបលេង" : "How to play")
        }
    }
}

struct ScorePill: View { let title: String; let value: Int; var body: some View { VStack { Text(title).font(.caption2).foregroundStyle(.secondary); Text("\(value)").font(.headline.monospacedDigit()) }.padding(.horizontal, 14).padding(.vertical, 8).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12)) } }
struct TileView: View {
    let value: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 9)
            .fill(tileColor)
            .overlay {
                Text(value == 0 ? "" : "\(value)")
                    .font(.title2.bold())
                    .foregroundStyle(value > 4 ? .white : .black.opacity(0.7))
                    .contentTransition(.numericText())
            }
            .id(value)
            .transition(.scale(scale: 0.82).combined(with: .opacity))
    }

    private var tileColor: Color {
        switch value {
        case 0: return .white.opacity(0.07)
        case 2: return .orange.opacity(0.8)
        case 4: return .yellow.opacity(0.85)
        case 8: return .orange
        case 16: return .red
        case 32: return .pink
        case 64: return .purple
        default: return .blue
        }
    }
}
