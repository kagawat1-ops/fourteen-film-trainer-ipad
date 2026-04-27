import SwiftUI

struct HowToUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                section(title: "基本的な使い方") {
                    steps([
                        "モード選択でモードを選びます。",
                        "症例を選択します。",
                        "画像トレイから画像をドラッグして配置枠に置きます。",
                        "配置枠に置いた画像をタップすると、トレイに戻せます。",
                        "回転ボタン（↺↻）で画像を90度ずつ回転させます。",
                        "「採点する」ボタンで採点します。",
                        "「リセット」ボタンで最初からやり直せます。",
                    ])
                }

                section(title: "配置のルール") {
                    steps([
                        "各枠に1枚ずつ画像を配置してください。",
                        "すでに別の画像がある枠に置くと入れ替わります。",
                        "採点時に未配置の枠は不正解になります。",
                    ])
                }

                section(title: "採点について") {
                    steps([
                        "位置（どの枠に置いたか）と向き（回転角度）の両方を採点します。",
                        "上顎7枚モードは7枚満点、全顎14枚モードは14枚満点で採点します。",
                        "不正解の部位には部位判別ヒントが表示されます。",
                    ])
                }

                section(title: "無料版と有料版") {
                    steps([
                        "無料版では上顎7枚モード（症例1）を体験できます。",
                        "全機能解除（1,980円、買い切り）で全モード・全症例・学習履歴が利用できます。",
                        "1回の購入でiPhoneとiPadの両方で利用できます。",
                    ])
                }

                section(title: "iPhone・iPadでの表示") {
                    steps([
                        "iPadでは横向きレイアウトで全顎14枚モードを快適に使えます。",
                        "iPhoneでは縦向き時に上顎・下顎7枚モードを推奨します。",
                        "iPhoneで全顎14枚モードを使う場合は横向きを推奨します。",
                    ])
                }

                // Disclaimer
                VStack(alignment: .leading, spacing: 6) {
                    Text("【重要】教育用・非診断用")
                        .font(.subheadline).bold()
                    Text("本アプリは、口内法エックス線写真14枚法の配列と方向を練習するための教育用教材です。診断、治療方針の決定、患者管理、臨床判断を目的としたものではありません。")
                        .font(.caption).foregroundColor(.secondary)
                    Text("This app is intended for dental education and training only. It is not intended for diagnosis, treatment planning, patient management, or clinical decision-making.")
                        .font(.caption2).foregroundColor(.secondary)
                        .padding(.top, 2)
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("使い方")
    }

    private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .background(Color(white: 0.97))
        .cornerRadius(12)
    }

    private func steps(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(items.enumerated()), id: \.offset) { (i, text) in
                HStack(alignment: .top, spacing: 8) {
                    Text("\(i + 1).").font(.caption).foregroundColor(.secondary).frame(width: 20)
                    Text(text).font(.subheadline)
                }
            }
        }
    }
}
