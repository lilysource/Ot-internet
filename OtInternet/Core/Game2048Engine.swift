import Foundation

public struct Game2048Engine: Sendable {
    public private(set) var tiles: [[Int]]
    public private(set) var score: Int
    public private(set) var isGameOver: Bool
    private var previousState: (tiles: [[Int]], score: Int)?

    public init(seed: Int? = nil) {
        tiles = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        isGameOver = false
        _ = seed
        addRandomTile()
        addRandomTile()
    }

    public mutating func move(_ direction: Direction) -> Bool {
        guard !isGameOver else { return false }
        let original = tiles
        let originalScore = score
        var changed = false
        for index in 0..<4 {
            var line = readLine(index: index, direction: direction)
            let compacted = line.filter { $0 != 0 }
            var merged: [Int] = []
            var cursor = 0
            while cursor < compacted.count {
                if cursor + 1 < compacted.count && compacted[cursor] == compacted[cursor + 1] {
                    let value = compacted[cursor] * 2
                    merged.append(value)
                    score += value
                    cursor += 2
                } else {
                    merged.append(compacted[cursor])
                    cursor += 1
                }
            }
            merged.append(contentsOf: repeatElement(0, count: 4 - merged.count))
            if merged != line { changed = true }
            writeLine(merged, index: index, direction: direction)
        }
        guard changed else { return false }
        previousState = (original, originalScore)
        addRandomTile()
        isGameOver = !canMove
        return true
    }

    public mutating func undo() {
        guard let previousState else { return }
        tiles = previousState.tiles
        score = previousState.score
        self.previousState = nil
        isGameOver = false
    }

    public mutating func restart() {
        tiles = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        isGameOver = false
        previousState = nil
        addRandomTile()
        addRandomTile()
    }

    public enum Direction: Sendable { case up, down, left, right }

    public static func == (lhs: Game2048Engine, rhs: Game2048Engine) -> Bool {
        lhs.tiles == rhs.tiles && lhs.score == rhs.score && lhs.isGameOver == rhs.isGameOver
    }

    private var canMove: Bool {
        if tiles.joined().contains(0) { return true }
        for row in 0..<4 {
            for column in 0..<4 {
                if row < 3 && tiles[row][column] == tiles[row + 1][column] { return true }
                if column < 3 && tiles[row][column] == tiles[row][column + 1] { return true }
            }
        }
        return false
    }

    private mutating func addRandomTile() {
        let empty = tiles.indices.flatMap { row in tiles[row].indices.compactMap { column in tiles[row][column] == 0 ? (row, column) : nil } }
        guard let position = empty.randomElement() else { return }
        tiles[position.0][position.1] = Int.random(in: 0..<10) == 0 ? 4 : 2
    }

    private func readLine(index: Int, direction: Direction) -> [Int] {
        switch direction {
        case .left: return tiles[index]
        case .right: return tiles[index].reversed()
        case .up: return (0..<4).map { tiles[$0][index] }
        case .down: return (0..<4).map { tiles[3 - $0][index] }
        }
    }

    private mutating func writeLine(_ line: [Int], index: Int, direction: Direction) {
        switch direction {
        case .left: tiles[index] = line
        case .right: tiles[index] = line.reversed()
        case .up: for row in 0..<4 { tiles[row][index] = line[row] }
        case .down: for row in 0..<4 { tiles[3 - row][index] = line[row] }
        }
    }
}
