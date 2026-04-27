import SwiftUI

struct ResultSummaryView: View {
    let result: PracticeResult

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Score overview
            HStack(spacing: 24) {
                scoreItem(label: "位置正解", value: "\(result.positionCorrectCount) / \(result.totalCount)")
                scoreItem(label: "向き正解", value: "\(result.rotationCorrectCount) / \(result.totalCount)")
                scoreItem(label: "完全正解", value: "\(result.fullyCorrectCount) / \(result.totalCount)")
            }

            HStack(spacing: 24) {
                scoreItem(label: "正答率", value: String(format: "%.0f%%", result.accuracy * 100))
                scoreItem(label: "所要時間", value: TimeFormatter.format(seconds: result.elapsedSeconds))
            }

            Divider()

            // Per-slot results
            ForEach(result.slotResults, id: \.slotId) { sr in
                HStack(spacing: 10) {
                    Image(systemName: sr.fullyCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(sr.fullyCorrect ? .green : .red)
                        .font(.title3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(sr.slotName)
                            .font(.subheadline)
                        if !sr.fullyCorrect {
                            Text(errorMessage(sr))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 2)
            }
        }
    }

    private func scoreItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title2).bold()
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }

    private func errorMessage(_ sr: SlotResult) -> String {
        switch (sr.positionCorrect, sr.rotationCorrect) {
        case (false, false): return "位置と向きの両方が違います"
        case (false, true):  return "位置が違います"
        case (true, false):  return "向きが違います"
        default: return ""
        }
    }
}
