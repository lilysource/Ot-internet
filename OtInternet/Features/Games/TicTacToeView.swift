import SwiftUI

struct TicTacToeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: OfflineStore
    @State private var board = Array(repeating: "", count: 9)
    @State private var current = "X"
    @State private var winner: String?
    @State private var xWins = 0
    @State private var oWins = 0
    private let winningLines = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

    var body: some View {
        NavigationStack {
            VStack(spacing: 22) {
                HStack {
                    PlayerScore(symbol: "X", score: xWins, active: current == "X" && winner == nil, color: .otBlue)
                    Spacer()
                    Text(winner == nil ? (current == "X" ? "X's turn" : "O's turn") : (winner == "Draw" ? "Draw" : "\(winner!) wins"))
                        .font(.headline)
                    Spacer()
                    PlayerScore(symbol: "O", score: oWins, active: current == "O" && winner == nil, color: .orange)
                }
                Text(store.language == .khmer ? "បញ្ជូនទូរស័ព្ទឱ្យមិត្តរបស់អ្នក ហើយលេងជាមួយគ្នា" : "Pass the phone to a friend and play locally")
                    .font(.footnote).foregroundStyle(.secondary).multilineTextAlignment(.center)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(0..<9, id: \.self) { index in
                        Button { play(index) } label: {
                            Text(board[index])
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .foregroundStyle(board[index] == "X" ? Color.otBlue : Color.orange)
                                .frame(maxWidth: .infinity).aspectRatio(1, contentMode: .fit)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.1)))
                        }
                        .disabled(!board[index].isEmpty || winner != nil)
                        .accessibilityLabel("Cell \(index + 1) \(board[index].isEmpty ? "empty" : board[index])")
                        .scaleEffect(board[index].isEmpty ? 1 : 1.04)
                        .animation(.spring(response: 0.25, dampingFraction: 0.65), value: board[index])
                    }
                }
                HStack(spacing: 12) {
                    Button("New round") { resetRound() }.buttonStyle(.borderedProminent)
                    Button("Done") { dismiss() }.buttonStyle(.bordered)
                }
                Text(store.language == .khmer ? "ឈ្នះដោយដាក់សញ្ញា ៣ ជួរ" : "Make a line of three to win")
                    .font(.caption).foregroundStyle(.secondary)
                Spacer()
            }
            .padding().background(Color.otInk.ignoresSafeArea())
            .navigationTitle("Tic-Tac-Toe")
        }
    }

    private func play(_ index: Int) {
        guard board[index].isEmpty, winner == nil else { return }
        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
            board[index] = current
            if winningLines.contains(where: { line in line.allSatisfy { board[$0] == current } }) {
                winner = current
                if current == "X" { xWins += 1 } else { oWins += 1 }
            } else if !board.contains("") {
                winner = "Draw"
            } else {
                current = current == "X" ? "O" : "X"
            }
        }
    }

    private func resetRound() {
        withAnimation(.easeOut(duration: 0.2)) {
            board = Array(repeating: "", count: 9)
            current = "X"
            winner = nil
        }
    }
}

struct PlayerScore: View {
    let symbol: String
    let score: Int
    let active: Bool
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(symbol).font(.title2.bold()).foregroundStyle(color)
            Text("\(score)").font(.headline.monospacedDigit())
        }
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background(active ? color.opacity(0.18) : .clear, in: RoundedRectangle(cornerRadius: 14))
    }
}
