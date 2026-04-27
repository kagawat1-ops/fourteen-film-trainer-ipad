import SwiftUI

struct ResultView: View {
    let result: PracticeResult
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Summary
                    ResultSummaryView(result: result)
                        .padding()
                        .background(Color(white: 0.97))
                        .cornerRadius(12)

                    // Hints for wrong slots
                    let wrongSlots = result.slotResults.filter { !$0.fullyCorrect }
                    if !wrongSlots.isEmpty {
                        Text("部位判別ヒント")
                            .font(.headline)
                            .padding(.top, 8)

                        ForEach(wrongSlots, id: \.slotId) { sr in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                    Text(sr.slotName)
                                        .font(.subheadline).bold()
                                    Spacer()
                                    Text(errorLabel(sr))
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                        .padding(.horizontal, 8).padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.1))
                                        .cornerRadius(6)
                                }
                                Text(hint(for: sr.slotId))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(Color(white: 0.97))
                            .cornerRadius(10)
                        }
                    }

                    // Educational notice
                    Text("本アプリは教育用教材です。診断・治療方針の決定・患者管理・臨床判断を目的としたものではありません。")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                }
                .padding()
            }
            .navigationTitle("採点結果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("閉じる") { onDismiss() }
                }
            }
        }
    }

    private func errorLabel(_ sr: SlotResult) -> String {
        switch (sr.positionCorrect, sr.rotationCorrect) {
        case (false, false): return "位置・向き両方違い"
        case (false, true):  return "位置が違います"
        case (true, false):  return "向きが違います"
        default: return ""
        }
    }
}
