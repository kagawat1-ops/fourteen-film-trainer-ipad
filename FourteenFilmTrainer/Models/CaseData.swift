import Foundation

struct CaseData: Identifiable, Codable {
    let id: String              // e.g. "case-001"
    let title: String           // e.g. "症例1"
    let images: [RadiographImage]
}
