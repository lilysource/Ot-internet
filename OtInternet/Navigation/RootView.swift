import SwiftUI

struct RootView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
            GamesView().tabItem { Label("Games", systemImage: "gamecontroller.fill") }.tag(1)
            MapsView().tabItem { Label("Maps", systemImage: "map.fill") }.tag(2)
            NotesView().tabItem { Label("Notes", systemImage: "note.text") }.tag(3)
            MoreView().tabItem { Label("More", systemImage: "ellipsis") }.tag(4)
        }
        .tint(.otBlue)
    }
}

struct HomeView: View {
    @EnvironmentObject private var store: OfflineStore
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Good to see you.").font(.title3).foregroundStyle(.secondary)
                        Text("Ot Internet").font(.system(size: 38, weight: .bold, design: .rounded))
                        Text("Your world, even without internet.").foregroundStyle(.secondary)
                    }
                    GlassCard {
                        HStack(spacing: 14) {
                            Image(systemName: "wifi.slash").font(.title2).foregroundStyle(.white).frame(width: 48, height: 48).background(.orange.gradient, in: Circle())
                            VStack(alignment: .leading, spacing: 4) {
                                Text("You're Offline").font(.headline)
                                Text("No internet connection detected. Ot Internet is ready to work offline.").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    SectionTitle(title: "Quick access", action: nil)
                    LazyVGrid(columns: columns, spacing: 12) {
                        QuickCard(title: "Offline Games", symbol: "gamecontroller.fill", color: .blue)
                        QuickCard(title: "Offline Maps", symbol: "map.fill", color: .green)
                        QuickCard(title: "Notes", symbol: "note.text", color: .orange)
                        QuickCard(title: "Files", symbol: "folder.fill", color: .indigo)
                        QuickCard(title: "Tools", symbol: "wrench.and.screwdriver.fill", color: .pink)
                        QuickCard(title: "Settings", symbol: "gearshape.fill", color: .gray)
                    }
                    SectionTitle(title: "Your offline space", action: nil)
                    GlassCard {
                        VStack(spacing: 15) {
                            MetricRow(symbol: "clock.arrow.circlepath", title: "Recently played", value: "2048")
                            MetricRow(symbol: "note.text", title: "Recently opened", value: "Your notes")
                            MetricRow(symbol: "internaldrive", title: "Storage used", value: "12.4 MB")
                        }
                    }
                }
                .padding()
            }
            .background(Color.otInk.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct QuickCard: View {
    let title: String; let symbol: String; let color: Color
    var body: some View { GlassCard { VStack(alignment: .leading, spacing: 14) { IconBadge(symbol: symbol, color: color); Text(title).font(.subheadline.bold()) } }.frame(maxWidth: .infinity, alignment: .leading) }
}

struct MetricRow: View {
    let symbol: String; let title: String; let value: String
    var body: some View { HStack { Image(systemName: symbol).foregroundStyle(.otBlue).frame(width: 28); Text(title); Spacer(); Text(value).foregroundStyle(.secondary).font(.subheadline) } }
}
