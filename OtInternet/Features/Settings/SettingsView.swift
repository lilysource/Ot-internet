import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: OfflineStore
    var body: some View {
        Form {
            Section { Label("Guest User", systemImage: "person.crop.circle"); Text("No account required").font(.caption).foregroundStyle(.secondary) }
            Section("Preferences") {
                Toggle("Dark Mode", isOn: Binding(get: { store.darkMode }, set: store.toggleDarkMode))
                Picker("Language / ភាសា", selection: Binding(get: { store.language }, set: store.setLanguage)) {
                    ForEach(AppLanguage.allCases) { language in Text(language.title).tag(language) }
                }
            }
            Section("Offline content") { Label("Downloaded maps", systemImage: "map"); Label("Storage", systemImage: "internaldrive"); Label("Game settings", systemImage: "gamecontroller") }
            Section("Privacy") { Label("Notifications", systemImage: "bell"); Label("Privacy", systemImage: "hand.raised") }
            Section("About") { Label("Ot Internet", systemImage: "wifi.slash"); HStack { Text("Version"); Spacer(); Text("1.0.0").foregroundStyle(.secondary) } }
        }.navigationTitle(store.language == .khmer ? "ការកំណត់" : "Settings")
    }
}
