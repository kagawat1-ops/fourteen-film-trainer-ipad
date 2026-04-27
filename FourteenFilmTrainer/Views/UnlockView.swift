import SwiftUI
import StoreKit

struct UnlockView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var isRestoring = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Icon
                    Image(systemName: "lock.open.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.orange)
                        .padding(.top, 32)

                    // Title
                    Text("全機能を解除する")
                        .font(.largeTitle).bold()

                    // Description
                    VStack(spacing: 12) {
                        Text("無料版では、片顎7枚モードを体験できます。\n全顎14枚法、全症例、学習履歴、復習機能を利用するには、全機能解除が必要です。")
                            .font(.body)
                            .multilineTextAlignment(.center)

                        Text("全機能解除は1,980円の買い切り型です。")
                            .font(.subheadline).bold()
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal)

                    // Feature list
                    VStack(alignment: .leading, spacing: 10) {
                        featureRow("全顎14枚モード")
                        featureRow("全10症例")
                        featureRow("ランダム出題")
                        featureRow("症例番号選択")
                        featureRow("下顎7枚モード")
                        featureRow("学習履歴")
                        featureRow("苦手部位復習")
                        featureRow("部位判別ヒント（採点後）")
                    }
                    .padding()
                    .background(Color(white: 0.97))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Price from StoreKit
                    if let product = purchaseManager.product {
                        Text("価格: \(product.displayPrice)")
                            .font(.title3).bold()
                    }

                    // Purchase button
                    Button {
                        Task {
                            isPurchasing = true
                            await purchaseManager.purchase()
                            isPurchasing = false
                            if purchaseManager.isUnlocked { dismiss() }
                        }
                    } label: {
                        Group {
                            if isPurchasing {
                                ProgressView().tint(.white)
                            } else {
                                Text("全機能を解除する")
                                    .font(.title3).bold()
                            }
                        }
                        .frame(maxWidth: 320)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(isPurchasing || isRestoring)

                    // Restore button
                    Button {
                        Task {
                            isRestoring = true
                            await purchaseManager.restore()
                            isRestoring = false
                            if purchaseManager.isUnlocked { dismiss() }
                        }
                    } label: {
                        Group {
                            if isRestoring {
                                ProgressView()
                            } else {
                                Text("購入を復元する")
                                    .font(.body)
                                    .underline()
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    .disabled(isPurchasing || isRestoring)

                    // Error message
                    if let err = purchaseManager.purchaseError {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    // Notes
                    VStack(spacing: 4) {
                        Text("• サブスクリプションではありません。")
                        Text("• 1回の購入でiPhone・iPad両方で利用できます。")
                        Text("• 購入後は課金なしで将来のアップデートも利用できます。")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .task {
            await purchaseManager.loadProduct()
        }
    }

    private func featureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
            Text(text).font(.subheadline)
            Spacer()
        }
    }
}
