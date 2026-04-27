# 14枚法配列トレーニング
**Intraoral Radiograph Mounting Trainer / FMX Mounting Trainer**

Version 1.0.0

---

## 1. アプリの目的

口内法エックス線写真14枚法における画像の配列と方向を練習するための教育用iOSアプリです。

**本アプリは教育用教材です。**  
診断、治療方針の決定、患者管理、臨床判断を目的としたものではありません。

> This app is intended for dental education and training only.  
> It is not intended for diagnosis, treatment planning, patient management, or clinical decision-making.

---

## 2. 禁止している機能

本アプリには以下の機能を意図的に実装していません。

- 診断支援・疾患名の推定
- 病変検出・歯周炎の重症度判定
- 治療方針の提案
- 患者画像のアップロード
- AI画像診断・外部APIへの画像送信
- ユーザー個人情報の収集
- サブスクリプション課金
- ログイン機能・サーバー保存

---

## 3. 実行方法

### 必要環境

- Xcode 15以上
- iOS / iPadOS 16.0以上
- Swift 5.9以上

### 手順

```
1. FourteenFilmTrainer.xcodeproj をXcodeで開く
2. Signing & Capabilities でチームを設定する
3. シミュレーターまたは実機を選択してビルド・実行
```

---

## 4. 画像フォルダ構成

画像は `Assets.xcassets` 内に以下の命名規則で配置してください。

```
Assets.xcassets/
  case-001/
    01.png   (または .jpg)
    02.png
    ...
    14.png
  case-002/
    01.png
    ...
    14.png
  ...
  case-010/
    01.png
    ...
    14.png
```

Xcodeでは `Assets.xcassets` を右クリック → "New Folder" で `case-001` フォルダを作成し、  
その中に画像をドラッグ＆ドロップして追加します。  
各画像セットのName（識別子）は `case-001/01` のように設定してください。

**画像ファイルが存在しない場合、アプリはプレースホルダー（「画像1」など）を表示します。**  
プレースホルダーが表示されている状態でも、配置・採点の練習は可能です。

---

## 5. 症例データの追加方法

`FourteenFilmTrainer/Data/Cases.swift` を編集します。

```swift
CaseData(
    id: "case-011",       // 一意のID（ハイフン区切り）
    title: "症例11",
    images: makeImages(caseId: "case-011", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
),
```

`makeImages` は14枚のスロット順（上顎右大臼歯→…→下顎左大臼歯）に従って自動生成します。  
正解回転角が0以外のものは個別に `RadiographImage` を定義してください（下記参照）。

---

## 6. 正解データの設定方法

各画像の正解は `correctSlotId` と `correctRotation` で決まります。  
`imageName` の番号順と `correctSlotId` の対応は一致しなくてかまいません。

```swift
RadiographImage(
    id: "case-001-01",
    imageName: "case-001/01",
    caseId: "case-001",
    correctSlotId: "maxillary-right-molar",
    correctRotation: 90          // 0, 90, 180, 270 のいずれか
)
```

---

## 7. correctSlotId 一覧

| correctSlotId | 日本語名 |
|---|---|
| `maxillary-right-molar` | 上顎右側大臼歯部 |
| `maxillary-right-premolar` | 上顎右側小臼歯部 |
| `maxillary-right-canine` | 上顎右側犬歯部 |
| `maxillary-anterior` | 上顎前歯部 |
| `maxillary-left-canine` | 上顎左側犬歯部 |
| `maxillary-left-premolar` | 上顎左側小臼歯部 |
| `maxillary-left-molar` | 上顎左側大臼歯部 |
| `mandibular-right-molar` | 下顎右側大臼歯部 |
| `mandibular-right-premolar` | 下顎右側小臼歯部 |
| `mandibular-right-canine` | 下顎右側犬歯部 |
| `mandibular-anterior` | 下顎前歯部 |
| `mandibular-left-canine` | 下顎左側犬歯部 |
| `mandibular-left-premolar` | 下顎左側小臼歯部 |
| `mandibular-left-molar` | 下顎左側大臼歯部 |

---

## 8. correctRotation の指定方法

画像が正しい向きで表示されるときの回転角度を `0`, `90`, `180`, `270` で指定します。

- `0`   … 回転なし（縦向き・通常）
- `90`  … 右90度回転が正解
- `180` … 180度回転（上下反転）が正解
- `270` … 左90度（または右270度）回転が正解

採点時に「ユーザーが設定した回転角度 == correctRotation」であれば向き正解と判定されます。

---

## 9. StoreKit 2のテスト方法

1. Xcodeで `FourteenFilmTrainer/Resources/StoreKitConfig.storekit` を開く
2. スキームの Launch Action に StoreKit Configuration として指定されていることを確認する  
   （`FourteenFilmTrainer.xcscheme` に設定済み）
3. シミュレーターで実行し、「全機能を解除する」をタップ
4. テスト購入ダイアログが表示されれば設定完了

購入をリセットするには：  
Xcode → Debug → StoreKit → Manage Transactions... → 全トランザクションを削除

---

## 10. 全機能解除の商品ID

```
jp.example.fourteenfilm.fullunlock
```

App Store Connect で商品を登録する際は、上記IDと一致させてください。  
変更する場合は `FourteenFilmTrainer/Services/PurchaseManager.swift` の以下の箇所を編集します。

```swift
enum ProductID {
    static let fullUnlock = "jp.example.fourteenfilm.fullunlock"
}
```

課金タイプ：**Non-Consumable（非消耗型）**  
価格：1,980円（国内）/ $19.99 USD（海外）

---

## 11. 学習履歴の保存方式

- 保存先：端末内の `UserDefaults`（キー: `practice_history_v1`）
- 形式：`[PracticeResult]` をJSONエンコードして保存
- 外部サーバー・クラウドへの送信は一切行いません
- 個人情報は収集しません
- 履歴は「学習履歴」画面から手動削除できます

---

## 12. バージョン番号ルール

| 変更内容 | バージョン例 |
|---|---|
| 初回リリース（10症例） | 1.0.0 |
| 症例追加（→12症例） | 1.1.0 |
| 誤字修正・軽微な修正 | 1.0.1 |
| 18枚法・20枚法など大幅追加 | 2.0.0 |

バージョン名だけを変更する更新は避けてください。  
毎年更新する場合は、症例追加・表示改善・誤字修正・iPadOS対応など実質的な変更を行ってください。

---

## 13. ファイル構成

```
FourteenFilmTrainer/
├── FourteenFilmTrainerApp.swift   # アプリエントリポイント
├── Models/
│   ├── Slot.swift                 # 配置枠モデル
│   ├── RadiographImage.swift      # 画像データモデル
│   ├── CaseData.swift             # 症例データモデル
│   └── PracticeResult.swift       # 採点結果モデル・PracticeMode
├── Data/
│   ├── Slots.swift                # 14スロット定義・SlotID定数
│   ├── Cases.swift                # 10症例データ
│   └── SampleHints.swift          # 部位判別ヒント文
├── Views/
│   ├── HomeView.swift
│   ├── ModeSelectionView.swift
│   ├── CaseSelectionView.swift
│   ├── PracticeView.swift
│   ├── ResultView.swift
│   ├── HistoryView.swift
│   ├── ReviewView.swift
│   ├── HowToUseView.swift
│   └── UnlockView.swift
├── Components/
│   ├── SlotGridView.swift
│   ├── RadiographImageView.swift
│   ├── ImageTrayView.swift
│   ├── RotationControlsView.swift
│   ├── ResultSummaryView.swift
│   └── LockBadgeView.swift
├── Services/
│   ├── ScoringService.swift
│   ├── HistoryStore.swift
│   └── PurchaseManager.swift
├── Utilities/
│   ├── ShuffleUtility.swift
│   └── TimeFormatter.swift
└── Resources/
    ├── Assets.xcassets/           # 画像・アイコン
    └── StoreKitConfig.storekit    # StoreKitテスト設定
```
