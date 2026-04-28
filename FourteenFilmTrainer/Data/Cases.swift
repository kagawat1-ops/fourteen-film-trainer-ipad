import Foundation

// MARK: - Helper
// Defined before allCases so the initialiser is clearly in scope.
// imageName uses the format "<caseId>-<nn>" which maps to an asset named
// e.g. "case-002-01" in Assets.xcassets.
fileprivate func makeImages(caseId: String) -> [RadiographImage] {
    SlotID.all.enumerated().map { index, slotId in
        let num = String(format: "%02d", index + 1)
        return RadiographImage(
            id:             "\(caseId)-\(num)",
            imageName:      "\(caseId)-\(num)",
            caseId:         caseId,
            correctSlotId:  slotId,
            correctRotation: 0
        )
    }
}

// MARK: - Case library
//
// HOW TO ADD A NEW CASE
// 1. Add a new CaseData(...) line inside the allCases array below.
//    Do NOT place CaseData(...) outside this array — that would be a
//    top-level expression and will cause a build error.
// 2. Add 14 image assets to Assets.xcassets named
//    "case-011-01" … "case-011-14" (adjust number as needed).
// 3. For cases where all images map to their default slot in order,
//    use makeImages(caseId:). For custom mappings, copy the case-001 block.
//
// correctRotation is always 0.
// Register images in the CORRECT orientation; the app randomises the
// initial display rotation (0 / 90 / 180 / 270) at session start.

let allCases: [CaseData] = [

    // ── 症例 1 ──────────────────────────────────────────────────────────────
    CaseData(
        id: "case-001",
        title: "症例1",
        images: [
            RadiographImage(id: "case-001-01", imageName: "case-001-01",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightMolar,     correctRotation: 0),
            RadiographImage(id: "case-001-02", imageName: "case-001-02",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-03", imageName: "case-001-03",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-04", imageName: "case-001-04",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryAnterior,       correctRotation: 0),
            RadiographImage(id: "case-001-05", imageName: "case-001-05",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftCanine,     correctRotation: 0),
            RadiographImage(id: "case-001-06", imageName: "case-001-06",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftPremolar,   correctRotation: 0),
            RadiographImage(id: "case-001-07", imageName: "case-001-07",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftMolar,      correctRotation: 0),
            RadiographImage(id: "case-001-08", imageName: "case-001-08",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightMolar,    correctRotation: 0),
            RadiographImage(id: "case-001-09", imageName: "case-001-09",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightPremolar, correctRotation: 0),
            RadiographImage(id: "case-001-10", imageName: "case-001-10",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightCanine,   correctRotation: 0),
            RadiographImage(id: "case-001-11", imageName: "case-001-11",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularAnterior,      correctRotation: 0),
            RadiographImage(id: "case-001-12", imageName: "case-001-12",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-13", imageName: "case-001-13",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-14", imageName: "case-001-14",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftMolar,     correctRotation: 0),
        ]
    ),

    // ── 症例 2–10（画像を追加したら makeImages が自動で14枚生成） ────────────
    CaseData(id: "case-002",  title: "症例2",  images: makeImages(caseId: "case-002")),
    CaseData(id: "case-003",  title: "症例3",  images: makeImages(caseId: "case-003")),
    CaseData(id: "case-004",  title: "症例4",  images: makeImages(caseId: "case-004")),
    CaseData(id: "case-005",  title: "症例5",  images: makeImages(caseId: "case-005")),
    CaseData(id: "case-006",  title: "症例6",  images: makeImages(caseId: "case-006")),
    CaseData(id: "case-007",  title: "症例7",  images: makeImages(caseId: "case-007")),
    CaseData(id: "case-008",  title: "症例8",  images: makeImages(caseId: "case-008")),
    CaseData(id: "case-009",  title: "症例9",  images: makeImages(caseId: "case-009")),
    CaseData(id: "case-010",  title: "症例10", images: makeImages(caseId: "case-010")),

    // ← 新しい症例はここに追加する（allCases の ] の前）

] // ← この閉じ括弧より後に CaseData(...) を置かないこと
