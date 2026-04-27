import Foundation

struct RadiographImage: Identifiable, Codable {
    let id: String            // e.g. "case-001-01"
    let imageName: String     // e.g. "01.jpg"
    let caseId: String        // e.g. "case-001"
    let correctSlotId: String // e.g. "maxillary-right-molar"
    let correctRotation: Int  // 0, 90, 180, or 270
}
