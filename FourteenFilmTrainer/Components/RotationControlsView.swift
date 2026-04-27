import SwiftUI

struct RotationControlsView: View {
    @Binding var rotation: Int

    var body: some View {
        HStack(spacing: 8) {
            Button {
                rotation = (rotation - 90 + 360) % 360
            } label: {
                Image(systemName: "rotate.left")
                    .font(.title3)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.bordered)

            Text("\(rotation)°")
                .font(.caption)
                .frame(width: 36)

            Button {
                rotation = (rotation + 90) % 360
            } label: {
                Image(systemName: "rotate.right")
                    .font(.title3)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.bordered)
        }
    }
}
