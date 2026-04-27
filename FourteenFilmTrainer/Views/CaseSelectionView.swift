import SwiftUI

struct CaseSelectionView: View {
    let mode: PracticeMode
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var historyStore: HistoryStore
    @State private var showUnlock = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text(mode.displayName)
                    .font(.title3).bold()
                    .padding(.top, 16)

                // Random mode
                if mode == .random {
                    NavigationLink {
                        let chosen = ShuffleUtility.randomCase(from: allCases) ?? allCases[0]
                        PracticeView(caseData: chosen, mode: mode)
                    } label: {
                        Label("ランダムで始める", systemImage: "shuffle")
                            .font(.title3).bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                // Case list
                ForEach(allCases) { caseData in
                    let locked = isCaseLocked(caseData)
                    if locked {
                        Button { showUnlock = true } label: {
                            caseRow(caseData, locked: true)
                        }
                    } else {
                        NavigationLink {
                            PracticeView(caseData: caseData, mode: mode)
                        } label: {
                            caseRow(caseData, locked: false)
                        }
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("症例選択")
        .sheet(isPresented: $showUnlock) { UnlockView() }
    }

    private func isCaseLocked(_ caseData: CaseData) -> Bool {
        guard !purchaseManager.isUnlocked else { return false }
        // Free: only case-001 upper-7 mode
        return caseData.id != "case-001"
    }

    private func caseRow(_ caseData: CaseData, locked: Bool) -> some View {
        let latest = historyStore.latestResult(for: caseData.id)
        let best = historyStore.bestAccuracy(for: caseData.id)
        return HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(caseData.title)
                        .font(.headline)
                        .foregroundColor(locked ? .secondary : .primary)
                    if latest != nil {
                        Text("実施済み").font(.caption2)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                if let latest {
                    HStack(spacing: 12) {
                        Text("最新: \(String(format: "%.0f%%", latest.accuracy * 100))")
                        if let b = best {
                            Text("最高: \(String(format: "%.0f%%", b * 100))")
                        }
                        Text(TimeFormatter.format(seconds: latest.elapsedSeconds))
                    }
                    .font(.caption).foregroundColor(.secondary)
                } else {
                    Text("未実施").font(.caption).foregroundColor(.secondary)
                }
            }
            Spacer()
            if locked {
                Image(systemName: "lock.fill").foregroundColor(.secondary)
            } else {
                Image(systemName: "chevron.right").foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(white: 0.97))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(locked ? Color.gray.opacity(0.2) : Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}
