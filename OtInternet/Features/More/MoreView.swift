import SwiftUI
import UniformTypeIdentifiers

struct MoreView: View {
    var body: some View { NavigationStack { List { Section("Offline tools") { NavigationLink { ToolsView() } label: { Label("Useful Tools", systemImage: "wrench.and.screwdriver.fill") }; NavigationLink { FilesView() } label: { Label("Files", systemImage: "folder.fill") } }; Section("App") { NavigationLink { SettingsView() } label: { Label("Settings", systemImage: "gearshape.fill") }; Label("Guest User", systemImage: "person.crop.circle") } }.scrollContentBackground(.hidden).background(Color.otInk).navigationTitle("More") } }
}

struct ToolsView: View { var body: some View { List { ToolRow(title: "Calculator", symbol: "plus.forwardslash.minus", detail: "Quick arithmetic") { CalculatorView() }; ToolRow(title: "Stopwatch", symbol: "stopwatch.fill", detail: "Track elapsed time") { StopwatchView() }; ToolRow(title: "Password generator", symbol: "key.fill", detail: "Generate a strong local password") { PasswordView() }; ToolRow(title: "Compass", symbol: "safari.fill", detail: "Use the device compass") { Text("Compass uses the device sensors and works offline.").padding() } }.navigationTitle("Tools") } }
struct ToolRow<Destination: View>: View { let title: String; let symbol: String; let detail: String; let destination: () -> Destination; var body: some View { NavigationLink { destination() } label: { Label { VStack(alignment: .leading) { Text(title); Text(detail).font(.caption).foregroundStyle(.secondary) } } icon: { Image(systemName: symbol).foregroundStyle(.otBlue) } } } }
struct CalculatorView: View { @State private var value = ""; var body: some View { VStack { Text(value.isEmpty ? "0" : value).font(.largeTitle.monospacedDigit()).frame(maxWidth: .infinity, alignment: .trailing).padding(); ForEach([["7","8","9","÷"],["4","5","6","×"],["1","2","3","-"],["0","C","=","+"]], id: \.self) { row in HStack { ForEach(row, id: \.self) { key in Button(key) { if key == "C" { value = "" } else if key == "=" { value = evaluate(value) } else { value.append(key) } }.frame(maxWidth: .infinity, minHeight: 58).background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14)) } } }; Spacer() }.padding().navigationTitle("Calculator") }
private func evaluate(_ expression: String) -> String {
    let operators = CharacterSet(charactersIn: "+-×÷")
    guard let index = expression.unicodeScalars.firstIndex(where: { operators.contains($0) }) else { return expression }
    let operatorIndex = expression.index(expression.startIndex, offsetBy: expression.unicodeScalars.distance(from: expression.unicodeScalars.startIndex, to: index))
    let left = String(expression[..<operatorIndex])
    let right = String(expression[expression.index(after: operatorIndex)...])
    guard let lhs = Double(left), let rhs = Double(right), !right.isEmpty else { return expression }
    let symbol = expression[operatorIndex]
    let result = symbol == "+" ? lhs + rhs : symbol == "-" ? lhs - rhs : symbol == "×" ? lhs * rhs : lhs / rhs
    return String(result)
}
}
struct StopwatchView: View { @State private var start: Date?; @State private var elapsed = 0.0; var body: some View { VStack(spacing: 24) { Text(elapsed.formatted(.number.precision(.fractionLength(1)))).font(.system(size: 52, design: .rounded).monospacedDigit()); Button(start == nil ? "Start" : "Stop") { if start == nil { start = .now } else { elapsed += Date().timeIntervalSince(start!); start = nil } }.buttonStyle(.borderedProminent); Button("Reset", role: .destructive) { start = nil; elapsed = 0 } }.padding().navigationTitle("Stopwatch") } }
struct PasswordView: View { @State private var password = ""; var body: some View { VStack(spacing: 20) { Text(password.isEmpty ? "Tap generate" : password).font(.title3.monospaced()).textSelection(.enabled); Button("Generate") { password = String((0..<18).map { _ in "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#$%".randomElement()! }) }.buttonStyle(.borderedProminent) }.padding().navigationTitle("Password generator") } }
struct FilesView: View { @State private var showingImporter = false; @State private var files: [String] = []; var body: some View { List { if files.isEmpty { ContentUnavailableView("No local files", systemImage: "folder", description: Text("Import documents to keep them available offline.")) } else { ForEach(files, id: \.self) { Label($0, systemImage: "doc") } } }.navigationTitle("Files").toolbar { Button { showingImporter = true } label: { Image(systemName: "plus") } }.fileImporter(isPresented: $showingImporter, allowedContentTypes: [.item], allowsMultipleSelection: true) { result in if case .success(let urls) = result { files.append(contentsOf: urls.map(\.lastPathComponent)) } } } }
