import SwiftUI
import SwiftData

struct NotesView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [SortDescriptor<Note>(\.modifiedAt, order: .reverse)]) private var notes: [Note]
    @State private var search = ""
    @State private var editing: Note?

    private var filtered: [Note] {
        search.isEmpty ? notes : notes.filter {
            $0.title.localizedCaseInsensitiveContains(search) || $0.body.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if filtered.isEmpty {
                    ContentUnavailableView("No notes yet", systemImage: "note.text", description: Text("Create a note to keep ideas available offline."))
                } else {
                    ForEach(filtered) { note in
                        Button { editing = note } label: {
                            HStack {
                                Image(systemName: note.isPinned ? "pin.fill" : "note.text").foregroundStyle(Color.otBlue)
                                VStack(alignment: .leading) {
                                    Text(note.title.isEmpty ? "Untitled" : note.title).font(.headline)
                                    Text(note.body.isEmpty ? "No additional text" : note.body).lineLimit(1).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if note.isFavorite { Image(systemName: "star.fill").foregroundStyle(.yellow) }
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) { context.delete(note) } label: { Label("Delete", systemImage: "trash") }
                        }
                    }
                    .onDelete { offsets in offsets.map { filtered[$0] }.forEach(context.delete) }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.otInk)
            .navigationTitle("Notes")
            .searchable(text: $search, prompt: "Search notes")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button { editing = Note(); context.insert(editing!) } label: { Image(systemName: "plus") }
                        .accessibilityLabel("New note")
                }
            }
            .sheet(item: $editing) { NoteEditor(note: $0) }
        }
    }
}

struct NoteEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var note: Note

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $note.title)
                TextEditor(text: $note.body).frame(minHeight: 220)
                Toggle("Favorite", isOn: $note.isFavorite)
                Toggle("Pinned", isOn: $note.isPinned)
                Text("Created \(note.createdAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .navigationTitle("Edit note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Done") { note.modifiedAt = .now; dismiss() }.bold() }
            }
        }
    }
}
