import SwiftUI

struct OfflineMiniGameView: View {
    let name: String
    var body: some View {
        switch name {
        case "Tic-Tac-Toe": TicTacToeView()
        case "Solitaire": SolitaireView()
        case "Chess": ChessView()
        case "Minesweeper": MinesweeperView()
        case "Sudoku": MiniSudokuView()
        case "Memory Match": MemoryMatchView()
        case "Snake": SnakeView()
        case "Block Puzzle": BlockPuzzleView()
        case "Word Puzzle": WordPuzzleView()
        default: Text("Game unavailable")
        }
    }
}

struct MemoryMatchView: View {
    @State private var cards = Array((0..<8).flatMap { [$0, $0] }.shuffled())
    @State private var revealed: [Int] = []
    @State private var matched: Set<Int> = []
    @State private var moves = 0
    var body: some View { NavigationStack { VStack(spacing: 18) { Text("Find every pair · Moves \(moves)").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) { ForEach(cards.indices, id: \.self) { index in Button { flip(index) } label: { Text(revealed.contains(index) || matched.contains(index) ? symbols[cards[index]] : "?").font(.title.bold()).foregroundStyle(revealed.contains(index) || matched.contains(index) ? .white : .otBlue).frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit).background(revealed.contains(index) || matched.contains(index) ? Color.otBlue : Color.otPanel, in: RoundedRectangle(cornerRadius: 14)).animation(.spring(), value: revealed) } } }; Button("New game") { reset() }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Memory Match") } }
    private let symbols = ["circle.fill", "star.fill", "heart.fill", "bolt.fill", "leaf.fill", "moon.fill", "sun.max.fill", "flame.fill"]
    private func flip(_ index: Int) { guard !matched.contains(index), !revealed.contains(index), revealed.count < 2 else { return }; withAnimation { revealed.append(index) }; if revealed.count == 2 { moves += 1; let a = revealed[0], b = revealed[1]; if cards[a] == cards[b] { matched.formUnion([a, b]); revealed = [] } else { DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) { withAnimation { revealed = [] } } } } }
    private func reset() { cards = Array((0..<8).flatMap { [$0, $0] }.shuffled()); revealed = []; matched = []; moves = 0 }
}

struct MinesweeperView: View {
    @State private var mines: Set<Int> = []; @State private var revealed: Set<Int> = []; @State private var lost = false
    var body: some View { NavigationStack { VStack(spacing: 18) { Text(lost ? "Boom! Start again" : "Reveal safe squares, avoid the mines").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 6) { ForEach(0..<25, id: \.self) { index in Button { reveal(index) } label: { Text(revealed.contains(index) ? (mines.contains(index) ? "💥" : "•") : "").frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit).background(revealed.contains(index) ? (mines.contains(index) ? Color.red : Color.otBlue.opacity(0.45)) : Color.otPanel, in: RoundedRectangle(cornerRadius: 8)) } } }; Button("New board") { reset() }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Minesweeper").onAppear { reset() } } }
    private func reset() { mines = Set((0..<25).shuffled().prefix(5)); revealed = []; lost = false }
    private func reveal(_ index: Int) { guard !lost else { return }; withAnimation { revealed.insert(index); if mines.contains(index) { lost = true; revealed.formUnion(mines) } } }
}

struct MiniSudokuView: View {
    @State private var values = [0, 2, 3, 0, 3, 0, 0, 2, 0, 0, 2, 3, 2, 3, 0, 0]
    private let solution = [1, 2, 3, 4, 3, 4, 1, 2, 2, 1, 4, 3, 4, 3, 2, 1]
    var body: some View { NavigationStack { VStack(spacing: 18) { Text("Complete the 4 × 4 grid").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 6) { ForEach(0..<16, id: \.self) { index in Button { guard [0, 3, 5, 6, 8, 9, 11, 14, 15].contains(index) else { return }; values[index] = values[index] % 4 + 1 } label: { Text(values[index] == 0 ? "" : "\(values[index])").font(.title2.bold()).frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit).background(values[index] == 0 ? Color.otPanel : Color.otBlue.opacity(0.3), in: RoundedRectangle(cornerRadius: 8)) } } }; if values == solution { Text("Solved!").font(.title2.bold()).foregroundStyle(.green) }; Button("New puzzle") { values = [0, 2, 3, 0, 3, 0, 0, 2, 0, 0, 2, 3, 2, 3, 0, 0] }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Sudoku") } }
}

struct WordPuzzleView: View {
    @State private var letters = Array("SWIFT").shuffled(); @State private var answer = ""; @State private var solved = false
    var body: some View { NavigationStack { VStack(spacing: 24) { Text("Unscramble the word").foregroundStyle(.secondary); Text(answer.isEmpty ? "_ _ _ _ _" : answer).font(.largeTitle.bold().monospaced()); HStack { ForEach(Array(letters.enumerated()), id: \.offset) { item in Button(String(item.element)) { answer.append(item.element); letters.remove(at: item.offset); if answer == "SWIFT" { solved = true } }.font(.title2.bold()).frame(width: 52, height: 52).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12)) } }; if solved { Text("Correct!").font(.title2.bold()).foregroundStyle(.green) }; Button("New word") { letters = Array("SWIFT").shuffled(); answer = ""; solved = false }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Word Puzzle") } }
}

struct BlockPuzzleView: View {
    @State private var cells = Array(repeating: false, count: 25); @State private var score = 0
    var body: some View { NavigationStack { VStack(spacing: 18) { Text("Score \(score) · Fill a row to clear it").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 5) { ForEach(0..<25, id: \.self) { index in Button { cells[index].toggle(); clearRows() } label: { RoundedRectangle(cornerRadius: 6).fill(cells[index] ? Color.otBlue : Color.otPanel).aspectRatio(1, contentMode: .fit) } } }; Button("Reset puzzle") { cells = Array(repeating: false, count: 25); score = 0 }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Block Puzzle") } }
    private func clearRows() { for row in 0..<5 where (0..<5).allSatisfy({ cells[row * 5 + $0] }) { for column in 0..<5 { cells[row * 5 + column] = false }; score += 10 } }
}

struct ChessView: View {
    @State private var board = Array(repeating: "", count: 64); @State private var selected: Int?; @State private var turn = "♙"
    var body: some View { NavigationStack { VStack(spacing: 16) { Text("Local pass-and-play · \(turn == "♙" ? "White" : "Black") turn").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 8), spacing: 0) { ForEach(0..<64, id: \.self) { index in Button { tap(index) } label: { Text(board[index]).font(.title2).frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit).background((index / 8 + index) % 2 == 0 ? Color.white.opacity(0.85) : Color.otBlue.opacity(0.6)) } } }; Button("New game") { reset() }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Chess").onAppear { reset() } } }
    private func reset() { board = Array(repeating: "", count: 64); let white = ["♜","♞","♝","♛","♚","♝","♞","♜"]; let pawns = Array(repeating: "♟", count: 8); let black = ["♖","♘","♗","♕","♔","♗","♘","♖"]; for i in 0..<8 { board[i] = white[i]; board[8+i] = "♟"; board[48+i] = "♙"; board[56+i] = black[i] }; selected = nil; turn = "♙" }
    private func tap(_ index: Int) { if let selected { board[index] = board[selected]; board[selected] = ""; self.selected = nil; turn = turn == "♙" ? "♟" : "♙" } else if !board[index].isEmpty { selected = index } }
}

struct SolitaireView: View {
    @State private var deck = Array(1...13).shuffled(); @State private var pile: [Int] = []
    var body: some View { NavigationStack { VStack(spacing: 22) { Text("Draw cards and build your pile").foregroundStyle(.secondary); HStack { Text(pile.last.map(String.init) ?? "-").font(.system(size: 48, weight: .bold, design: .rounded)).frame(width: 110, height: 150).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16)); Text("Cards left: \(deck.count)").foregroundStyle(.secondary) }; Button("Draw card") { if let card = deck.popLast() { withAnimation(.spring()) { pile.append(card) } } }.buttonStyle(.borderedProminent); Button("New deal") { deck = Array(1...13).shuffled(); pile = [] }.buttonStyle(.bordered); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Solitaire") } }
}

struct SnakeView: View {
    @State private var snake = [12, 11, 10]; @State private var food = 4; @State private var direction = 1; @State private var timer = Timer.publish(every: 0.45, on: .main, in: .common).autoconnect(); @State private var gameOver = false
    var body: some View { NavigationStack { VStack(spacing: 18) { Text(gameOver ? "Game over" : "Eat the red square").foregroundStyle(.secondary); LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 5), spacing: 3) { ForEach(0..<25, id: \.self) { index in Rectangle().fill(index == food ? .red : snake.contains(index) ? .otBlue : .otPanel).aspectRatio(1, contentMode: .fit) } }.onReceive(timer) { _ in tick() }; HStack { Button("←") { direction = -1 }; Button("↑") { direction = -5 }; Button("↓") { direction = 5 }; Button("→") { direction = 1 } }.buttonStyle(.bordered); Button("Restart") { snake = [12, 11, 10]; food = 4; direction = 1; gameOver = false }.buttonStyle(.borderedProminent); Spacer() }.padding().background(Color.otInk.ignoresSafeArea()).navigationTitle("Snake") } }
    private func tick() { guard !gameOver, let head = snake.first else { return }; let next = head + direction; guard next >= 0, next < 25, !(direction == 1 && head % 5 == 4), !(direction == -1 && head % 5 == 0), !snake.contains(next) else { gameOver = true; return }; snake.insert(next, at: 0); if next == food { food = (0..<25).filter { !snake.contains($0) }.randomElement() ?? 4 } else { snake.removeLast() } }
}
