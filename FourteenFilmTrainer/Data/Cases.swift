import Foundation

// MARK: - All practice cases
// Add new cases here. Image files go in Assets.xcassets or
// a Cases/<caseId>/ folder bundled in the app target.
let allCases: [CaseData] = [
    CaseData(
        id: "case-001",
        title: "症例1",
        images: [
            RadiographImage(id: "case-001-01", imageName: "case-001/01",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightMolar,    correctRotation: 0),
            RadiographImage(id: "case-001-02", imageName: "case-001/02",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightPremolar, correctRotation: 0),
            RadiographImage(id: "case-001-03", imageName: "case-001/03",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryRightCanine,   correctRotation: 0),
            RadiographImage(id: "case-001-04", imageName: "case-001/04",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryAnterior,      correctRotation: 0),
            RadiographImage(id: "case-001-05", imageName: "case-001/05",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-06", imageName: "case-001/06",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-07", imageName: "case-001/07",
                            caseId: "case-001",
                            correctSlotId: SlotID.maxillaryLeftMolar,     correctRotation: 0),
            RadiographImage(id: "case-001-08", imageName: "case-001/08",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightMolar,    correctRotation: 0),
            RadiographImage(id: "case-001-09", imageName: "case-001/09",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightPremolar, correctRotation: 0),
            RadiographImage(id: "case-001-10", imageName: "case-001/10",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularRightCanine,   correctRotation: 0),
            RadiographImage(id: "case-001-11", imageName: "case-001/11",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularAnterior,      correctRotation: 0),
            RadiographImage(id: "case-001-12", imageName: "case-001/12",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-13", imageName: "case-001/13",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-14", imageName: "case-001/14",
                            caseId: "case-001",
                            correctSlotId: SlotID.mandibularLeftMolar,     correctRotation: 0),
        ]
    ),
    CaseData(
        id: "case-002",
        title: "症例2",
        images: makeImages(caseId: "case-002", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-003",
        title: "症例3",
        images: makeImages(caseId: "case-003", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-004",
        title: "症例4",
        images: makeImages(caseId: "case-004", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-005",
        title: "症例5",
        images: makeImages(caseId: "case-005", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-006",
        title: "症例6",
        images: makeImages(caseId: "case-006", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-007",
        title: "症例7",
        images: makeImages(caseId: "case-007", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-008",
        title: "症例8",
        images: makeImages(caseId: "case-008", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-009",
        title: "症例9",
        images: makeImages(caseId: "case-009", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
    CaseData(
        id: "case-010",
        title: "症例10",
        images: makeImages(caseId: "case-010", rotations: [0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ),
]

// Helper: generate 14 images in canonical slot order for a case.
// `rotations` must contain 14 values corresponding to the 14 slots.
private func makeImages(caseId: String, rotations: [Int]) -> [RadiographImage] {
    let slots = SlotID.all
    let padded = caseId.split(separator: "-").last.flatMap { Int($0) } ?? 0
    return slots.enumerated().map { (index, slotId) in
        let imgNum = String(format: "%02d", index + 1)
        return RadiographImage(
            id: "\(caseId)-\(imgNum)",
            imageName: "\(caseId)/\(imgNum)",
            caseId: caseId,
            correctSlotId: slotId,
            correctRotation: index < rotations.count ? rotations[index] : 0
        )
    }
}
