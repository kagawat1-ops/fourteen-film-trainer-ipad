import Foundation

enum ShuffleUtility {
    /// Returns images shuffled, preserving all correctSlotId / correctRotation data.
    static func shuffled(_ images: [RadiographImage]) -> [RadiographImage] {
        images.shuffled()
    }

    /// Pick a random case from the provided list.
    static func randomCase(from cases: [CaseData]) -> CaseData? {
        cases.randomElement()
    }
}
