import Foundation
import Combine

@MainActor
final class OfflineStore: ObservableObject {
    @Published var savedPlaces: [SavedPlace] = []
    @Published var files: [OfflineFile] = []
    @Published var best2048: Int = 0
    @Published var darkMode = true
    @Published var language: AppLanguage = .english

    private let defaults = UserDefaults.standard
    private let placesKey = "savedPlaces"

    init() {
        best2048 = defaults.integer(forKey: "best2048")
        darkMode = defaults.object(forKey: "darkMode") as? Bool ?? true
        language = AppLanguage(rawValue: defaults.string(forKey: "language") ?? "en") ?? .english
        if let data = defaults.data(forKey: placesKey) {
            savedPlaces = (try? JSONDecoder().decode([SavedPlace].self, from: data)) ?? []
        }
    }

    func saveBestScore(_ score: Int) {
        guard score > best2048 else { return }
        best2048 = score
        defaults.set(score, forKey: "best2048")
    }

    func toggleDarkMode(_ value: Bool) {
        darkMode = value
        defaults.set(value, forKey: "darkMode")
    }

    func setLanguage(_ value: AppLanguage) {
        language = value
        defaults.set(value.rawValue, forKey: "language")
    }

    func addPlace(_ place: SavedPlace) {
        savedPlaces.append(place)
        persistPlaces()
    }

    func removePlace(_ place: SavedPlace) {
        savedPlaces.removeAll { $0.id == place.id }
        persistPlaces()
    }

    private func persistPlaces() {
        defaults.set(try? JSONEncoder().encode(savedPlaces), forKey: placesKey)
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case khmer = "km"

    var id: String { rawValue }
    var title: String { self == .english ? "English" : "ខ្មែរ" }
}
