import Foundation
import SwiftData

@Model
final class Note {
    var id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var modifiedAt: Date
    var isFavorite: Bool
    var isPinned: Bool
    var folder: String

    init(title: String = "", body: String = "", folder: String = "General") {
        id = UUID()
        self.title = title
        self.body = body
        createdAt = .now
        modifiedAt = .now
        isFavorite = false
        isPinned = false
        self.folder = folder
    }
}

struct SavedPlace: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var detail: String
    var latitude: Double
    var longitude: Double
    var isFavorite: Bool = false
}

struct OfflineFile: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let size: String
    let kind: String
}
