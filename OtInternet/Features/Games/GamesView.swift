import SwiftUI

struct GamesView: View {
    @State private var show2048 = false
    @State private var showTicTacToe = false
    @EnvironmentObject private var store: OfflineStore
    private let games = [
        ("2048", "Merge numbers and reach 2048", "square.grid.2x2.fill", Color.orange),
        ("Tic-Tac-Toe", "Classic local two-player", "xmark.octagon.fill", Color.blue),
        ("Solitaire", "A quiet card game", "suit.club.fill", Color.green),
        ("Chess", "Think ahead, offline", "checkerboard.rectangle", Color.purple),
        ("Minesweeper", "Clear the board carefully", "flag.fill", Color.red),
        ("Sudoku", "A daily logic challenge", "number.square.fill", Color.cyan),
        ("Memory Match", "Find every pair", "rectangle.on.rectangle.angled", Color.pink),
        ("Snake", "A timeless arcade classic", "hare.fill", Color.mint),
        ("Block Puzzle", "Stack and clear lines", "square.grid.3x3.fill", Color.indigo),
        ("Word Puzzle", "Make the best words", "textformat.abc", Color.yellow)
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(store.language == .khmer ? "លេងក្រៅបណ្តាញ។" : "Play offline.").font(.system(size: 36, weight: .bold, design: .rounded))
                    Text(store.language == .khmer ? "មិនត្រូវការទាញយក ឬអ៊ីនធឺណិតទេ។" : "No downloads. No connection. Just good games.").foregroundStyle(.secondary)
                    GlassCard { HStack { Image(systemName: "bolt.fill").foregroundStyle(.yellow); VStack(alignment: .leading) { Text("Recently played").font(.headline); Text("2048  ·  Best score saved locally").font(.caption).foregroundStyle(.secondary) }; Spacer(); Button("Play") { show2048 = true }.buttonStyle(.borderedProminent) } }
                    LazyVStack(spacing: 10) { ForEach(games, id: \.0) { game in GameRow(game: game) { if game.0 == "2048" { show2048 = true }; if game.0 == "Tic-Tac-Toe" { showTicTacToe = true } } } }
                }.padding()
            }.background(Color.otInk.ignoresSafeArea()).navigationTitle("Games")
                .sheet(isPresented: $show2048) { Game2048View() }
                .sheet(isPresented: $showTicTacToe) { TicTacToeView() }
        }
    }
}

struct GameRow: View {
    let game: (String, String, String, Color); let action: () -> Void
    var body: some View { GlassCard { HStack(spacing: 13) { IconBadge(symbol: game.2, color: game.3); VStack(alignment: .leading, spacing: 4) { Text(game.0).font(.headline); Text(game.1).font(.caption).foregroundStyle(.secondary); Text(game.0 == "Tic-Tac-Toe" ? "2 players · Same device" : game.0 == "2048" ? "Best score saved locally" : "Offline game") .font(.caption2).foregroundStyle(.secondary) }; Spacer(); if game.0 == "2048" || game.0 == "Tic-Tac-Toe" { Button("Play", action: action).buttonStyle(.bordered).tint(Color.otBlue) } else { Text("Soon").font(.caption).foregroundStyle(.secondary) } } } }
}
