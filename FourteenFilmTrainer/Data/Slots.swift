import Foundation

// MARK: - Slot IDs (constants for correctSlotId references)
enum SlotID {
    static let maxillaryRightMolar    = "maxillary-right-molar"
    static let maxillaryRightPremolar = "maxillary-right-premolar"
    static let maxillaryRightCanine   = "maxillary-right-canine"
    static let maxillaryAnterior      = "maxillary-anterior"
    static let maxillaryLeftCanine    = "maxillary-left-canine"
    static let maxillaryLeftPremolar  = "maxillary-left-premolar"
    static let maxillaryLeftMolar     = "maxillary-left-molar"

    static let mandibularRightMolar    = "mandibular-right-molar"
    static let mandibularRightPremolar = "mandibular-right-premolar"
    static let mandibularRightCanine   = "mandibular-right-canine"
    static let mandibularAnterior      = "mandibular-anterior"
    static let mandibularLeftCanine    = "mandibular-left-canine"
    static let mandibularLeftPremolar  = "mandibular-left-premolar"
    static let mandibularLeftMolar     = "mandibular-left-molar"

    static let allMaxillary: [String] = [
        maxillaryRightMolar, maxillaryRightPremolar, maxillaryRightCanine,
        maxillaryAnterior,
        maxillaryLeftCanine, maxillaryLeftPremolar, maxillaryLeftMolar
    ]

    static let allMandibular: [String] = [
        mandibularRightMolar, mandibularRightPremolar, mandibularRightCanine,
        mandibularAnterior,
        mandibularLeftCanine, mandibularLeftPremolar, mandibularLeftMolar
    ]

    static let all: [String] = allMaxillary + allMandibular
}

// MARK: - All 14 slots in display order
let allSlots: [Slot] = [
    Slot(id: SlotID.maxillaryRightMolar,    displayName: "上顎右側大臼歯部", isMaxillary: true,  sortOrder: 1),
    Slot(id: SlotID.maxillaryRightPremolar, displayName: "上顎右側小臼歯部", isMaxillary: true,  sortOrder: 2),
    Slot(id: SlotID.maxillaryRightCanine,   displayName: "上顎右側犬歯部",   isMaxillary: true,  sortOrder: 3),
    Slot(id: SlotID.maxillaryAnterior,      displayName: "上顎前歯部",       isMaxillary: true,  sortOrder: 4),
    Slot(id: SlotID.maxillaryLeftCanine,    displayName: "上顎左側犬歯部",   isMaxillary: true,  sortOrder: 5),
    Slot(id: SlotID.maxillaryLeftPremolar,  displayName: "上顎左側小臼歯部", isMaxillary: true,  sortOrder: 6),
    Slot(id: SlotID.maxillaryLeftMolar,     displayName: "上顎左側大臼歯部", isMaxillary: true,  sortOrder: 7),

    Slot(id: SlotID.mandibularRightMolar,    displayName: "下顎右側大臼歯部", isMaxillary: false, sortOrder: 8),
    Slot(id: SlotID.mandibularRightPremolar, displayName: "下顎右側小臼歯部", isMaxillary: false, sortOrder: 9),
    Slot(id: SlotID.mandibularRightCanine,   displayName: "下顎右側犬歯部",   isMaxillary: false, sortOrder: 10),
    Slot(id: SlotID.mandibularAnterior,      displayName: "下顎前歯部",       isMaxillary: false, sortOrder: 11),
    Slot(id: SlotID.mandibularLeftCanine,    displayName: "下顎左側犬歯部",   isMaxillary: false, sortOrder: 12),
    Slot(id: SlotID.mandibularLeftPremolar,  displayName: "下顎左側小臼歯部", isMaxillary: false, sortOrder: 13),
    Slot(id: SlotID.mandibularLeftMolar,     displayName: "下顎左側大臼歯部", isMaxillary: false, sortOrder: 14),
]

// MARK: - Helpers
func slot(for id: String) -> Slot? {
    allSlots.first { $0.id == id }
}

func slots(for mode: PracticeMode) -> [Slot] {
    switch mode {
    case .maxillary7:  return allSlots.filter(\.isMaxillary)
    case .mandibular7: return allSlots.filter { !$0.isMaxillary }
    case .fullArch14, .random, .review: return allSlots
    }
}
