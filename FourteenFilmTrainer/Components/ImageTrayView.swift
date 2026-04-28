import SwiftUI

struct ImageTrayView: View {
    let images: [RadiographImage]
    @Binding var rotations: [String: Int]
    @Binding var draggingImageId: String?
    @Binding var selectedImageId: String?     // tap-to-place selection
    let onRotateLeft: (String) -> Void
    let onRotateRight: (String) -> Void
    let cardWidth: CGFloat                    // caller decides width

    // 4:3 aspect ratio height
    private func cardHeight(_ w: CGFloat) -> CGFloat { w * 0.75 }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("未整理フィルム")
                    .font(.subheadline).bold()
                Text("未整理フィルムをドラッグするか、タップして選択してから配置枠をタップしてください。")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .padding(.bottom, 6)

            Divider()

            if images.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2).foregroundColor(.green)
                    Text("すべて配置済みです")
                        .font(.caption).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                // Determine columns: if card fits 2 per row use 2, else 1
                let columns = columnsCount
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: columns),
                        spacing: 10
                    ) {
                        ForEach(images) { img in
                            imageCard(img)
                        }
                    }
                    .padding(10)
                }
            }
        }
        .background(Color(white: 0.96))
    }

    // Use 2 columns only when card width allows at least 2 cards side-by-side legibly
    private var columnsCount: Int {
        // cardWidth is the tray panel width; each card needs ~80pt minimum
        cardWidth >= 180 ? 2 : 1
    }

    @ViewBuilder
    private func imageCard(_ img: RadiographImage) -> some View {
        let rotation = rotations[img.id] ?? 0
        let isSelected = selectedImageId == img.id
        let isDragging = draggingImageId == img.id

        VStack(spacing: 4) {
            // Image area
            ZStack(alignment: .topTrailing) {
                RadiographImageView(
                    image: img,
                    rotation: rotation,
                    size: effectiveCardWidth,
                    showControls: false,
                    onRotateLeft: {},
                    onRotateRight: {}
                )
                .frame(width: effectiveCardWidth, height: cardHeight(effectiveCardWidth))
                .opacity(isDragging ? 0.3 : 1.0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .background(Color.white.clipShape(Circle()))
                        .padding(4)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(6)

            // Rotation controls
            HStack(spacing: 4) {
                Button { onRotateLeft(img.id) } label: {
                    Image(systemName: "rotate.left")
                        .font(.caption)
                        .frame(width: 26, height: 26)
                }
                .buttonStyle(.bordered)

                Text("\(rotation)°")
                    .font(.caption2)
                    .monospacedDigit()
                    .frame(width: 32)

                Button { onRotateRight(img.id) } label: {
                    Image(systemName: "rotate.right")
                        .font(.caption)
                        .frame(width: 26, height: 26)
                }
                .buttonStyle(.bordered)
            }
        }
        .contentShape(Rectangle())
        // Tap to select / deselect
        .onTapGesture {
            if selectedImageId == img.id {
                selectedImageId = nil
            } else {
                selectedImageId = img.id
            }
        }
        // Drag to place
        .onDrag {
            draggingImageId = img.id
            selectedImageId = nil
            return NSItemProvider(object: img.id as NSString)
        }
    }

    // Actual image width inside a card (subtract padding)
    private var effectiveCardWidth: CGFloat {
        let cols = CGFloat(columnsCount)
        let spacing = (cols - 1) * 8
        let padding = 20.0
        return (cardWidth - spacing - padding) / cols
    }
}
