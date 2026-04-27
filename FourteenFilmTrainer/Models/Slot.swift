import Foundation

struct Slot: Identifiable, Codable, Equatable {
    let id: String          // e.g. "maxillary-right-molar"
    let displayName: String // e.g. "上顎右側大臼歯部"
    let isMaxillary: Bool   // true = upper arch
    let sortOrder: Int

    static func == (lhs: Slot, rhs: Slot) -> Bool {
        lhs.id == rhs.id
    }
}
