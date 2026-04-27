import SwiftUI

struct LockBadgeView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
            VStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("全機能解除が必要")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
}
