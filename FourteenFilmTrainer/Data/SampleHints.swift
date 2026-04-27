import Foundation

// Placement hints for each slot.
// Keep these to 1-3 sentences about morphological features only.
// Do NOT include disease names, pathology, severity, or treatment guidance.
let slotHints: [String: String] = [
    SlotID.maxillaryRightMolar:
        "上顎大臼歯部では上顎洞底の陰影が近接して見えます。複根歯の根が複数本確認でき、歯冠幅が広い点が特徴です。画像上方が根尖側となる向きを確認してください。",

    SlotID.maxillaryRightPremolar:
        "上顎小臼歯部は上顎洞底が近接して見えることがあります。歯冠・歯根が大臼歯より小さく、犬歯の単根とは異なり2根になることもあります。",

    SlotID.maxillaryRightCanine:
        "上顎犬歯部は単根で歯根が長い特徴があります。隣接する前歯部や小臼歯部との位置関係、歯列弓の彎曲方向で左右を判断してください。",

    SlotID.maxillaryAnterior:
        "上顎前歯部では切歯孔（鼻口蓋管）の陰影が中央付近に見えることがあります。複数の前歯が映り、歯冠が広い側が切端側です。",

    SlotID.maxillaryLeftCanine:
        "上顎犬歯部は単根で歯根が長い特徴があります。歯列弓の彎曲方向と隣接歯との位置関係で左右を区別してください。",

    SlotID.maxillaryLeftPremolar:
        "上顎小臼歯部は上顎洞底が近接して見えることがあります。大臼歯部より歯冠・歯根が小さく、犬歯部との境界付近に位置します。",

    SlotID.maxillaryLeftMolar:
        "上顎大臼歯部では上顎洞底が近接して見えます。複数の根と幅広い歯冠が特徴です。歯列弓の彎曲方向で左右を確認してください。",

    SlotID.mandibularRightMolar:
        "下顎大臼歯部では上顎洞は見られません。外斜線や下顎管の走行が判断の手がかりになります。複根歯がみられ、歯冠は上方に位置します。",

    SlotID.mandibularRightPremolar:
        "下顎小臼歯部はオトガイ孔が近接して見えることがあります。大臼歯より歯冠・歯根が小さく、犬歯との位置関係に注意してください。",

    SlotID.mandibularRightCanine:
        "下顎犬歯部は単根で比較的細長い形態です。隣接歯との位置関係と歯列弓の彎曲方向で左右を確認してください。",

    SlotID.mandibularAnterior:
        "下顎前歯部では複数の細い前歯が映ります。上顎前歯部より歯冠が小さく、歯根も短い傾向があります。",

    SlotID.mandibularLeftCanine:
        "下顎犬歯部は単根です。歯列弓の彎曲方向と隣接歯との位置関係で左右を判断してください。",

    SlotID.mandibularLeftPremolar:
        "下顎小臼歯部はオトガイ孔が近接して見えることがあります。大臼歯部より歯冠が小さく、前歯部側との位置関係を確認してください。",

    SlotID.mandibularLeftMolar:
        "下顎大臼歯部では上顎洞は見られません。下顎管や外斜線が判断の手がかりになります。歯列弓の彎曲方向で左右を確認してください。",
]

func hint(for slotId: String) -> String {
    slotHints[slotId] ?? "この部位の画像は、隣接部位との位置関係と歯の形態を確認して配置してください。"
}
