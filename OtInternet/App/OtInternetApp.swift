import SwiftUI
import SwiftData

@main
struct OtInternetApp: App {
    @StateObject private var store = OfflineStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(store.darkMode ? .dark : .light)
        }
        .modelContainer(for: [Note.self])
    }
}
