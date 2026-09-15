import SwiftUI

struct Game2048View: View {
    @EnvironmentObject private var store: OfflineStore
    @Environment(\.dismiss) private var dismiss
    @State private var game = Game2048Engine()
    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                HStack { ScorePill(title: "SCORE", value: game.score); ScorePill(title: "BEST", value: max(store.best2048, game.score)); Spacer(); Button { game.undo() } label: { Image(systemName: "arrow.uturn.backward") }.buttonStyle(.bordered).accessibilityLabel("Undo") }
                GeometryReader { proxy in
                    let size = min(proxy.size.width, proxy.size.height)
                    VStack(spacing: 7) { ForEach(0..<4, id: \.self) { row in HStack(spacing: 7) { ForEach(0..<4, id: \.self) { column in TileView(value: game.tiles[row][column]).frame(width: (size - 21) / 4, height: (size - 21) / 4) } } } }
                        .padding(10).background(Color.otPanel, in: RoundedRectangle(cornerRadius: 16))
                        .frame(width: size, height: size).frame(maxWidth: .infinity)
                        .gesture(DragGesture(minimumDistance: 20).onEnded { value in
                            let horizontal = abs(value.translation.width) > abs(value.translation.height)
                            let direction: Game2048Engine.Direction = horizontal ? (value.translation.width > 0 ? .right : .left) : (value.translation.height > 0 ? .down : .up)
                            withAnimation(.easeOut(duration: 0.18)) { _ = game.move(direction); store.saveBestScore(game.score) }
                        })
                }.aspectRatio(1, contentMode: .fit)
                HStack { Button("New game") { withAnimation { game.restart() } }.buttonStyle(.borderedProminent); Button("Restart", role: .destructive) { withAnimation { game.restart() } }.buttonStyle(.bordered) }
                Text("Swipe to move tiles").font(.footnote).foregroundStyle(.secondary)
                Spacer()
            }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("2048").toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .alert("Game over", isPresented: .constant(game.isGameOver)) { Button("New game") { game.restart() } } message: { Text("No more moves. Your score was \(game.score).") }
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
            }
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
