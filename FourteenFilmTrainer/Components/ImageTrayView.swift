import SwiftUI

struct ImageTrayView: View {
    let images: [RadiographImage]
    @Binding var rotations: [String: Int]
    @Binding var draggingImageId: String?
    let onRotateLeft: (String) -> Void
    let onRotateRight: (String) -> Void
    let imageSize: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 12) {
                ForEach(images) { img in
                    VStack(spacing: 4) {
                        RadiographImageView(
                            image: img,
                            rotation: rotations[img.id] ?? 0,
                            size: imageSize,
                            showControls: true,
                            onRotateLeft: { onRotateLeft(img.id) },
                            onRotateRight: { onRotateRight(img.id) }
                        )
                        .opacity(draggingImageId == img.id ? 0.4 : 1.0)
                        .onDrag {
                            draggingImageId = img.id
                            return NSItemProvider(object: img.id as NSString)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color(white: 0.96))
        .cornerRadius(10)
    }
}
