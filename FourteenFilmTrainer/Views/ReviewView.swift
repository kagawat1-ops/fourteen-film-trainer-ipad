import SwiftUI

struct ReviewView: View {
    @EnvironmentObject var historyStore: HistoryStore
    @EnvironmentObject var purchaseManager: PurchaseManager

    private var weakSlotIds: [String] { historyStore.weakSlotIds() }

    // Cases that contain at least one of the weak slot IDs, sorted by weakness count
    private var prioritisedCases: [CaseData] {
        let weakSet = Set(weakSlotIds.prefix(5))
        if weakSet.isEmpty { return allCases.shuffled() }
        return allCases.sorted { a, b in
            let aScore = a.images.filter { weakSet.contains($0.correctSlotId) }.count
            let bScore = b.images.filter { weakSet.contains($0.correctSlotId) }.count
            return aScore > bScore
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if weakSlotIds.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "star.fill").font(.largeTitle).foregroundColor(.yellow)
                        Text("苦手部位のデータがありません。\nまず練習して採点してください。")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    // Weak slot ranking
                    VStack(alignment: .leading, spacing: 8) {
                        Text("苦手部位ランキング").font(.headline)
                        ForEach(Array(weakSlotIds.prefix(7).enumerated()), id: \.offset) { (i, slotId) in
                            HStack(spacing: 12) {
                                Text("\(i + 1)").font(.headline)
                                    .foregroundColor(.white)
                                    .frame(width: 28, height: 28)
                                    .background(rankColor(i))
                                    .clipShape(Circle())
                                Text(slot(for: slotId)?.displayName ?? slotId)
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color(white: 0.97))
                    .cornerRadius(12)

                    Text("おすすめ症例（苦手部位を含む順）").font(.headline)

                    ForEach(prioritisedCases) { caseData in
                        NavigationLink {
                            PracticeView(caseData: caseData, mode: .review)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(caseData.title).font(.subheadline).bold()
                                    let overlap = Set(caseData.images.map(\.correctSlotId))
                                        .intersection(Set(weakSlotIds.prefix(5)))
                                    if !overlap.isEmpty {
                                        let names = overlap.compactMap { slot(for: $0)?.displayName }.joined(separator: "、")
                                        Text("苦手部位含む: \(names)")
                                            .font(.caption).foregroundColor(.orange)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(white: 0.97))
                            .cornerRadius(10)
                        }
                        .foregroundColor(.primary)
                    }
                }

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("苦手部位復習")
    }

    private func rankColor(_ index: Int) -> Color {
        switch index {
        case 0: return .red
        case 1: return .orange
        case 2: return .yellow
        default: return .gray.opacity(0.5)
        }
    }
}
