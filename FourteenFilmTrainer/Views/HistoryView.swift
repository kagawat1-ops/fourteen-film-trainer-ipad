import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyStore: HistoryStore
    @State private var showDeleteConfirm = false

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        Group {
            if historyStore.results.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock").font(.largeTitle).foregroundColor(.secondary)
                    Text("学習履歴はまだありません。").foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(historyStore.results) { result in
                        historyRow(result)
                    }
                    .onDelete { offsets in
                        historyStore.delete(at: offsets)
                    }
                }
            }
        }
        .navigationTitle("学習履歴")
        .toolbar {
            if !historyStore.results.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("全削除", role: .destructive) {
                        showDeleteConfirm = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .confirmationDialog("履歴をすべて削除しますか？", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("すべて削除", role: .destructive) { historyStore.deleteAll() }
        }
    }

    private func historyRow(_ result: PracticeResult) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(result.caseTitle).font(.headline)
                Text(result.mode.displayName)
                    .font(.caption)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
                Spacer()
                Text(Self.dateFormatter.string(from: result.date))
                    .font(.caption).foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(result.fullyCorrectCount)/\(result.totalCount)", systemImage: "checkmark.circle")
                Label(String(format: "%.0f%%", result.accuracy * 100), systemImage: "percent")
                Label(TimeFormatter.format(seconds: result.elapsedSeconds), systemImage: "timer")
            }
            .font(.caption).foregroundColor(.secondary)

            if !result.wrongSlotIds.isEmpty {
                let names = result.wrongSlotIds.compactMap { slot(for: $0)?.displayName }.joined(separator: "、")
                Text("間違い: \(names)")
                    .font(.caption2).foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
