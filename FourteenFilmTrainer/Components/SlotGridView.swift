import SwiftUI

struct SlotGridView: View {
    let activeSlots: [Slot]
    @Binding var placements: [String: String]      // slotId → imageId
    @Binding var rotations: [String: Int]           // imageId → rotation
    @Binding var draggingImageId: String?
    @Binding var selectedImageId: String?           // tap-to-place
    let allImages: [RadiographImage]
    let slotSize: CGFloat
    let onRotateLeft: (String) -> Void
    let onRotateRight: (String) -> Void

    private var upperSlots: [Slot] { activeSlots.filter(\.isMaxillary) }
    private var lowerSlots: [Slot] { activeSlots.filter { !$0.isMaxillary } }

    var body: some View {
        VStack(spacing: 16) {
            if !upperSlots.isEmpty {
                archRow(label: "上顎", slots: upperSlots)
            }
            if !lowerSlots.isEmpty {
                archRow(label: "下顎", slots: lowerSlots)
            }
        }
    }

    private func archRow(label: String, slots: [Slot]) -> some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(slots) { slot in
                        slotCell(slot)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }

    @ViewBuilder
    private func slotCell(_ slot: Slot) -> some View {
        let placedImageId = placements[slot.id]
        let placedImage = placedImageId.flatMap { id in allImages.first { $0.id == id } }
        let rotation = placedImageId.flatMap { rotations[$0] } ?? 0
        let isDropTarget = selectedImageId != nil  // highlight when something is selected

        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(isDropTarget && placedImage == nil ? Color.blue.opacity(0.06) : Color(white: 0.97))
            RoundedRectangle(cornerRadius: 8)
                .stroke(isDropTarget ? Color.blue.opacity(0.5) : Color.blue.opacity(0.25), lineWidth: isDropTarget ? 2 : 1.5)

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
                    HStack(spacing: 3) {
                        Button { onRotateLeft(img.id) } label: {
                            Image(systemName: "rotate.left").font(.caption2)
                                .frame(width: 22, height: 22)
                        }
                        .buttonStyle(.bordered)
                        Text("\(rotation)°").font(.caption2).frame(width: 26)
                        Button { onRotateRight(img.id) } label: {
                            Image(systemName: "rotate.right").font(.caption2)
                                .frame(width: 22, height: 22)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            } else {
                VStack(spacing: 4) {
                    Image(systemName: isDropTarget ? "arrow.down.circle" : "plus")
                        .font(.title3)
                        .foregroundColor(isDropTarget ? .blue : .blue.opacity(0.4))
                    Text(slot.displayName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
            }
        }
        .frame(width: slotSize, height: slotSize)
        // Drag-and-drop receive
        .onDrop(of: [.text], isTargeted: nil) { providers in
            guard let provider = providers.first else { return false }
            _ = provider.loadObject(ofClass: String.self) { value, _ in
                guard let imageId = value else { return }
                DispatchQueue.main.async {
                    placeImage(imageId, into: slot.id)
                    draggingImageId = nil
                }
            }
            return true
        }
        // Tap: if image selected → place it; if slot has image → return to tray
        .onTapGesture {
            if let selId = selectedImageId {
                placeImage(selId, into: slot.id)
                selectedImageId = nil
            } else if let imgId = placements[slot.id] {
                placements.removeValue(forKey: slot.id)
                _ = imgId
            }
        }
    }

    private func placeImage(_ imageId: String, into slotId: String) {
        // Remove the image from any slot it currently occupies
        for (sid, iid) in placements where iid == imageId {
            placements.removeValue(forKey: sid)
        }
        // If the target slot already has an image, it returns to tray (just remove)
        placements.removeValue(forKey: slotId)
        placements[slotId] = imageId
    }
}
