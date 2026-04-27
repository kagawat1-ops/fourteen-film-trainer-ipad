import SwiftUI

struct RadiographImageView: View {
    let image: RadiographImage
    let rotation: Int
    let size: CGFloat
    let showControls: Bool
    let onRotateLeft: () -> Void
    let onRotateRight: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            imageContent
                .frame(width: size, height: size * 0.75)
                .rotationEffect(.degrees(Double(rotation)))
                .clipped()
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

            if showControls {
                HStack(spacing: 6) {
                    Button { onRotateLeft() } label: {
                        Image(systemName: "rotate.left")
                            .font(.caption)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.bordered)

                    Text("\(rotation)°")
                        .font(.caption2)
                        .frame(width: 30)

                    Button { onRotateRight() } label: {
                        Image(systemName: "rotate.right")
                            .font(.caption)
                            .frame(width: 28, height: 28)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        if let uiImage = UIImage(named: image.imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            // Placeholder when image file is not bundled yet
            ZStack {
                Color(white: 0.85)
                VStack(spacing: 4) {
                    Image(systemName: "xray")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Text(placeholderLabel)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(4)
            }
        }
    }

    private var placeholderLabel: String {
        let parts = image.id.split(separator: "-")
        if let numStr = parts.last, let num = Int(numStr) {
            return "画像\(num)"
        }
        return "画像"
    }
}
