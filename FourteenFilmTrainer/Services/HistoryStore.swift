import Foundation

final class HistoryStore: ObservableObject {
    @Published private(set) var results: [PracticeResult] = []

    private let storageKey = "practice_history_v1"

    init() { load() }

    func save(_ result: PracticeResult) {
        results.insert(result, at: 0)
        persist()
    }

    func deleteAll() {
        results = []
        persist()
    }

    func delete(at offsets: IndexSet) {
        results.remove(atOffsets: offsets)
        persist()
    }

    // MARK: - Weak-spot analysis

    /// Returns slotIds ordered by mistake frequency (most mistakes first).
    func weakSlotIds() -> [String] {
        var counts: [String: Int] = [:]
        for result in results {
            for slotId in result.wrongSlotIds {
                counts[slotId, default: 0] += 1
            }
        }
        return counts.sorted { $0.value > $1.value }.map(\.key)
    }

    /// Best accuracy for a given caseId.
    func bestAccuracy(for caseId: String) -> Double? {
        results.filter { $0.caseId == caseId }.map(\.accuracy).max()
    }

    /// Latest result for a given caseId.
    func latestResult(for caseId: String) -> PracticeResult? {
        results.first { $0.caseId == caseId }
    }

    // MARK: - Persistence
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([PracticeResult].self, from: data) else { return }
        results = decoded
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(results) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
