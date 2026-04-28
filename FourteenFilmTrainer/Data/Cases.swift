import Foundation

// MARK: - All practice cases
// Add new cases here. Image files go in Assets.xcassets
// using the naming convention <caseId>/<nn> (e.g. "case-001/01").
//
// Register images in the CORRECT orientation.
// correctRotation is always 0 — the app randomises initial display rotation at session start.
let allCases: [CaseData] = [
    CaseData(
        id: "case-001",
        title: "症例1",
        images: [
            RadiographImage(id: "case-001-01", imageName: "case-001/01",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryRightMolar,    correctRotation: 0),
            RadiographImage(id: "case-001-02", imageName: "case-001/02",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryRightPremolar, correctRotation: 0),
            RadiographImage(id: "case-001-03", imageName: "case-001/03",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryRightCanine,   correctRotation: 0),
            RadiographImage(id: "case-001-04", imageName: "case-001/04",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryAnterior,      correctRotation: 0),
            RadiographImage(id: "case-001-05", imageName: "case-001/05",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryLeftCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-06", imageName: "case-001/06",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryLeftPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-07", imageName: "case-001/07",
                            caseId: "case-001", correctSlotId: SlotID.maxillaryLeftMolar,     correctRotation: 0),
            RadiographImage(id: "case-001-08", imageName: "case-001/08",
                            caseId: "case-001", correctSlotId: SlotID.mandibularRightMolar,    correctRotation: 0),
            RadiographImage(id: "case-001-09", imageName: "case-001/09",
                            caseId: "case-001", correctSlotId: SlotID.mandibularRightPremolar, correctRotation: 0),
            RadiographImage(id: "case-001-10", imageName: "case-001/10",
                            caseId: "case-001", correctSlotId: SlotID.mandibularRightCanine,   correctRotation: 0),
            RadiographImage(id: "case-001-11", imageName: "case-001/11",
                            caseId: "case-001", correctSlotId: SlotID.mandibularAnterior,      correctRotation: 0),
            RadiographImage(id: "case-001-12", imageName: "case-001/12",
                            caseId: "case-001", correctSlotId: SlotID.mandibularLeftCanine,    correctRotation: 0),
            RadiographImage(id: "case-001-13", imageName: "case-001/13",
                            caseId: "case-001", correctSlotId: SlotID.mandibularLeftPremolar,  correctRotation: 0),
            RadiographImage(id: "case-001-14", imageName: "case-001/14",
                            caseId: "case-001", correctSlotId: SlotID.mandibularLeftMolar,     correctRotation: 0),
        ]
    ),
    CaseData(id: "case-002", title: "症例2",  images: makeImages(caseId: "case-002")),
    CaseData(id: "case-003", title: "症例3",  images: makeImages(caseId: "case-003")),
    CaseData(id: "case-004", title: "症例4",  images: makeImages(caseId: "case-004")),
    CaseData(id: "case-005", title: "症例5",  images: makeImages(caseId: "case-005")),
    CaseData(id: "case-006", title: "症例6",  images: makeImages(caseId: "case-006")),
    CaseData(id: "case-007", title: "症例7",  images: makeImages(caseId: "case-007")),
    CaseData(id: "case-008", title: "症例8",  images: makeImages(caseId: "case-008")),
    CaseData(id: "case-009", title: "症例9",  images: makeImages(caseId: "case-009")),
    CaseData(id: "case-010", title: "症例10", images: makeImages(caseId: "case-010")),
]

// Generate 14 images in canonical slot order for a case.
// Images must be registered in the correct orientation; correctRotation is always 0.
// To add a new case, call makeImages(caseId: "case-011") and add images to Assets.xcassets.
private func makeImages(caseId: String) -> [RadiographImage] {
    SlotID.all.enumerated().map { (index, slotId) in
        let imgNum = String(format: "%02d", index + 1)
        return RadiographImage(
            id: "\(caseId)-\(imgNum)",
            imageName: "\(caseId)/\(imgNum)",
            caseId: caseId,
            correctSlotId: slotId,
            correctRotation: 0
        )
    }
}
