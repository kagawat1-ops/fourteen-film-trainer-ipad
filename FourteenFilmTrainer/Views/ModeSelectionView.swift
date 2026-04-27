import SwiftUI

struct ModeSelectionView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @State private var showUnlock = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("モードを選択")
                    .font(.title2).bold()
                    .padding(.top, 20)

                ForEach(PracticeMode.allCases, id: \.self) { mode in
                    modeButton(mode)
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("モード選択")
        .sheet(isPresented: $showUnlock) {
            UnlockView()
        }
    }

    @ViewBuilder
    private func modeButton(_ mode: PracticeMode) -> some View {
        let locked = mode.requiresPurchase && !purchaseManager.isUnlocked
        if locked {
            Button { showUnlock = true } label: {
                modeLabel(mode, locked: true)
            }
        } else {
            NavigationLink {
                CaseSelectionView(mode: mode)
            } label: {
                modeLabel(mode, locked: false)
            }
        }
    }

    private func modeLabel(_ mode: PracticeMode, locked: Bool) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(mode.displayName)
                    .font(.title3).bold()
                    .foregroundColor(locked ? .secondary : .primary)
                Text(modeDescription(mode))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if locked {
                Image(systemName: "lock.fill")
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(white: 0.97))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(locked ? Color.gray.opacity(0.3) : Color.blue.opacity(0.3), lineWidth: 1)
        )
    }

    private func modeDescription(_ mode: PracticeMode) -> String {
        switch mode {
        case .maxillary7:  return "上顎7枚の配列を練習します（無料）"
        case .mandibular7: return "下顎7枚の配列を練習します"
        case .fullArch14:  return "上下14枚すべての配列を練習します"
        case .random:      return "全症例からランダムに出題します"
        case .review:      return "苦手な部位を集中的に練習します"
        }
    }
}
