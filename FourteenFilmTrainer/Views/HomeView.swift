import SwiftUI

struct HomeView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @EnvironmentObject var historyStore: HistoryStore
    @State private var path = NavigationPath()
    @State private var showUnlock = false

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    VStack(spacing: 8) {
                        Text("14枚法配列トレーニング")
                            .font(.largeTitle).bold()
                            .multilineTextAlignment(.center)
                        Text("口内法エックス線写真14枚法の配列と方向を練習するアプリです。")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)

                    // Main buttons
                    VStack(spacing: 14) {
                        NavigationLink {
                            ModeSelectionView()
                        } label: {
                            Label("練習を始める", systemImage: "play.circle.fill")
                                .font(.title3).bold()
                                .frame(maxWidth: 360)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(14)
                        }

                        if purchaseManager.isUnlocked {
                            NavigationLink {
                                HistoryView()
                            } label: {
                                Label("学習履歴", systemImage: "clock.fill")
                                    .font(.title3)
                                    .frame(maxWidth: 360)
                                    .padding()
                                    .background(Color(white: 0.93))
                                    .foregroundColor(.primary)
                                    .cornerRadius(14)
                            }
                        } else {
                            Button {
                                showUnlock = true
                            } label: {
                                HStack {
                                    Image(systemName: "lock.fill")
                                    Text("学習履歴（全機能解除が必要）")
                                }
                                .font(.title3)
                                .frame(maxWidth: 360)
                                .padding()
                                .background(Color(white: 0.93))
                                .foregroundColor(.secondary)
                                .cornerRadius(14)
                            }
                        }

                        if !purchaseManager.isUnlocked {
                            Button {
                                showUnlock = true
                            } label: {
                                Label("全機能を解除する", systemImage: "lock.open.fill")
                                    .font(.title3)
                                    .frame(maxWidth: 360)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(14)
                            }
                        }

                        NavigationLink {
                            HowToUseView()
                        } label: {
                            Label("使い方", systemImage: "questionmark.circle")
                                .font(.title3)
                                .frame(maxWidth: 360)
                                .padding()
                                .background(Color(white: 0.93))
                                .foregroundColor(.primary)
                                .cornerRadius(14)
                        }
                    }

                    // Educational disclaimer
                    educationalNotice
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showUnlock) {
                UnlockView()
            }
        }
    }

    private var educationalNotice: some View {
        VStack(spacing: 6) {
            Text("教育用・非診断用")
                .font(.caption).bold()
                .foregroundColor(.secondary)
            Text("本アプリは、口内法エックス線写真14枚法の配列と方向を練習するための教育用教材です。診断、治療方針の決定、患者管理、臨床判断を目的としたものではありません。")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(white: 0.96))
        .cornerRadius(10)
    }
}
