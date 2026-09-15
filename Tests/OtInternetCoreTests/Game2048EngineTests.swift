import XCTest
@testable import OtInternetCore

final class Game2048EngineTests: XCTestCase {
    func testNewGameStartsWithTwoTiles() {
        let game = Game2048Engine(seed: 7)
        XCTAssertEqual(game.tiles.joined().filter { $0 != 0 }.count, 2)
    }

    func testMoveChangesBoardAndCanUndo() {
        var game = Game2048Engine(seed: 4)
        let before = game.tiles
        XCTAssertTrue(game.move(.left) || game.move(.right) || before != game.tiles)
        game.undo()
        XCTAssertEqual(game.tiles, before)
    }

    func testRestartClearsScore() {
        var game = Game2048Engine(seed: 3)
        _ = game.move(.left)
        game.restart()
        XCTAssertEqual(game.score, 0)
        XCTAssertEqual(game.tiles.joined().filter { $0 != 0 }.count, 2)
    }
}
