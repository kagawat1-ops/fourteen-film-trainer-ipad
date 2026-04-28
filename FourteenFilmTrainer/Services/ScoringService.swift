import Foundation

struct PlacedImageState {
    let imageId: String
    let placedSlotId: String
    let currentRotation: Int
}

enum ScoringService {
    /// Score a practice session.
    /// - Parameters:
    ///   - placements: dictionary of slotId → PlacedImageState
    ///   - images: the full list of images for this session (used to find unplaced images)
    ///   - activeSlotIds: the slots active for the current mode
    static func score(
        placements: [String: PlacedImageState],
        images: [RadiographImage],
        activeSlotIds: [String]
    ) -> [SlotResult] {
        activeSlotIds.map { slotId in
            guard let placed = placements[slotId],
                  let image = images.first(where: { $0.id == placed.imageId }) else {
                // Slot is empty → wrong on both counts
                return SlotResult(
                    slotId: slotId,
                    slotName: slot(for: slotId)?.displayName ?? slotId,
                    imageId: "",
                    positionCorrect: false,
                    rotationCorrect: false
                )
            }
            let positionCorrect = image.correctSlotId == slotId
            // Images are registered in the correct orientation (correctRotation is always 0).
            // The app randomises initial rotation at session start; 0° is the correct answer.
            let rotationCorrect = placed.currentRotation == 0
            return SlotResult(
                slotId: slotId,
                slotName: slot(for: slotId)?.displayName ?? slotId,
                imageId: image.id,
                positionCorrect: positionCorrect,
                rotationCorrect: rotationCorrect
            )
        }
    }
}
