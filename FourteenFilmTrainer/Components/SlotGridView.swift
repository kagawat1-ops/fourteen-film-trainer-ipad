import SwiftUI

struct SlotGridView: View {
    let activeSlots: [Slot]
    @Binding var placements: [String: String]      // slotId → imageId
    @Binding var rotations: [String: Int]           // imageId → rotation
    @Binding var draggingImageId: String?
    let allImages: [RadiographImage]
    let slotSize: CGFloat
    let onRotateLeft: (String) -> Void
    let onRotateRight: (String) -> Void

    // Layout: upper row then lower row
    private var upperSlots: [Slot] { activeSlots.filter(\.isMaxillary) }
    private var lowerSlots: [Slot] { activeSlots.filter { !$0.isMaxillary } }

    var body: some View {
        VStack(spacing: 16) {
            // Upper arch
            if !upperSlots.isEmpty {
                Text("上顎").font(.caption).foregroundColor(.secondary)
                HStack(spacing: 8) {
                    ForEach(upperSlots) { slot in
                        slotView(slot)
                    }
                }
            }
            // Lower arch
            if !lowerSlots.isEmpty {
                Text("下顎").font(.caption).foregroundColor(.secondary)
                HStack(spacing: 8) {
                    ForEach(lowerSlots) { slot in
                        slotView(slot)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func slotView(_ slot: Slot) -> some View {
        let placedImageId = placements[slot.id]
        let placedImage = placedImageId.flatMap { id in allImages.first { $0.id == id } }
        let rotation = placedImageId.flatMap { rotations[$0] } ?? 0

        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(white: 0.97))
                )
                .frame(width: slotSize, height: slotSize * 0.85)

            if let img = placedImage {
                VStack(spacing: 2) {
                    RadiographImageView(
                        image: img,
                        rotation: rotation,
                        size: slotSize - 8,
                        showControls: false,
                        onRotateLeft: {},
                        onRotateRight: {}
                    )
                    HStack(spacing: 4) {
                        Button { onRotateLeft(img.id) } label: {
                            Image(systemName: "rotate.left").font(.caption2)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.bordered)
                        Text("\(rotation)°").font(.caption2).frame(width: 28)
                        Button { onRotateRight(img.id) } label: {
                            Image(systemName: "rotate.right").font(.caption2)
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            } else {
                VStack(spacing: 4) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(.blue.opacity(0.5))
                    Text(slot.displayName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
            }
        }
        .frame(width: slotSize, height: slotSize)
        .onDrop(of: [.text], isTargeted: nil) { providers in
            guard let provider = providers.first else { return false }
            _ = provider.loadObject(ofClass: String.self) { value, _ in
                guard let imageId = value else { return }
                DispatchQueue.main.async {
                    // Remove from old slot if any
                    for (sid, iid) in placements where iid == imageId {
                        placements.removeValue(forKey: sid)
                    }
                    // If another image is already in target slot, swap back to tray
                    // (keep in placements with no slot = not placed; we handle by removing)
                    if let existing = placements[slot.id] {
                        placements.removeValue(forKey: slot.id)
                        _ = existing // returned to tray automatically (not in placements)
                    }
                    placements[slot.id] = imageId
                    draggingImageId = nil
                }
            }
            return true
        }
        // Tap placed image to remove it back to tray
        .onTapGesture {
            if let imgId = placements[slot.id] {
                placements.removeValue(forKey: slot.id)
                _ = imgId
            }
        }
    }
}
