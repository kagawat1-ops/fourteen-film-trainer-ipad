import Foundation

enum PracticeMode: String, Codable, CaseIterable {
    case maxillary7 = "upper7"
    case mandibular7 = "lower7"
    case fullArch14 = "full14"
    case random = "random"
    case review = "review"

    var displayName: String {
        switch self {
        case .maxillary7:  return "上顎7枚モード"
        case .mandibular7: return "下顎7枚モード"
        case .fullArch14:  return "全顎14枚モード"
        case .random:      return "ランダム出題"
        case .review:      return "苦手部位復習"
        }
    }

    var requiresPurchase: Bool {
        switch self {
        case .maxillary7: return false
        default:          return true
        }
    }
}

struct SlotResult: Codable {
    let slotId: String
    let slotName: String
    let imageId: String
    let positionCorrect: Bool
    let rotationCorrect: Bool
    var fullyCorrect: Bool { positionCorrect && rotationCorrect }
}

struct PracticeResult: Identifiable, Codable {
    let id: UUID
    let date: Date
    let caseId: String
    let caseTitle: String
    let mode: PracticeMode
    let slotResults: [SlotResult]
    let elapsedSeconds: Int

    var totalCount: Int          { slotResults.count }
    var positionCorrectCount: Int { slotResults.filter(\.positionCorrect).count }
    var rotationCorrectCount: Int { slotResults.filter(\.rotationCorrect).count }
    var fullyCorrectCount: Int   { slotResults.filter(\.fullyCorrect).count }
    var accuracy: Double         { totalCount > 0 ? Double(fullyCorrectCount) / Double(totalCount) : 0 }

    var wrongSlotIds: [String]  { slotResults.filter { !$0.positionCorrect }.map(\.slotId) }
    var wrongRotationImageIds: [String] { slotResults.filter { !$0.rotationCorrect }.map(\.imageId) }
}
