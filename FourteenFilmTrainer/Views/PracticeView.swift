import SwiftUI

struct PracticeView: View {
    let caseData: CaseData
    let mode: PracticeMode

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var historyStore: HistoryStore
    @EnvironmentObject var purchaseManager: PurchaseManager

    // Active slots for this mode
    private var activeSlots: [Slot] { slots(for: mode) }

    // Images filtered for mode
    private var activeImages: [RadiographImage] {
        let slotIds = Set(activeSlots.map(\.id))
        return shuffledImages.filter { slotIds.contains($0.correctSlotId) }
    }

    @State private var shuffledImages: [RadiographImage] = []
    // slotId → imageId
    @State private var placements: [String: String] = [:]
    // imageId → current rotation
    @State private var rotations: [String: Int] = [:]
    @State private var draggingImageId: String? = nil
    @State private var elapsedSeconds = 0
    @State private var timerRunning = false
    @State private var showResult = false
    @State private var practiceResult: PracticeResult? = nil
    @State private var showLandscapeAlert = false

    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass

    private var isIPad: Bool { hSizeClass == .regular && vSizeClass == .regular }
    private var isPortraitPhone: Bool { hSizeClass == .compact && vSizeClass == .regular }

    var body: some View {
        Group {
            if mode == .fullArch14 && isPortraitPhone {
                portraitPhoneFullArchNotice
            } else {
                mainContent
            }
        }
        .navigationTitle("\(caseData.title) - \(mode.displayName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                timerView
            }
        }
        .onAppear {
            shuffledImages = ShuffleUtility.shuffled(caseData.images)
            rotations = [:]
            placements = [:]
            timerRunning = true
        }
        .onDisappear { timerRunning = false }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard timerRunning && !showResult else { return }
            elapsedSeconds += 1
        }
        .sheet(isPresented: $showResult) {
            if let result = practiceResult {
                ResultView(result: result, onDismiss: { showResult = false })
            }
        }
    }

    // MARK: - Main layout
    private var mainContent: some View {
        GeometryReader { geo in
            if geo.size.width > geo.size.height || isIPad {
                // Landscape / iPad: side-by-side
                HStack(spacing: 0) {
                    ScrollView {
                        SlotGridView(
                            activeSlots: activeSlots,
                            placements: $placements,
                            rotations: $rotations,
                            draggingImageId: $draggingImageId,
                            allImages: activeImages,
                            slotSize: slotSize(geo: geo, landscape: true),
                            onRotateLeft: rotateLeft,
                            onRotateRight: rotateRight
                        )
                        .padding()
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    VStack {
                        traySection(imageSize: trayImageSize(geo: geo, landscape: true))
                        actionButtons
                    }
                    .frame(width: min(geo.size.width * 0.32, 280))
                    .padding(.vertical, 8)
                }
            } else {
                // Portrait phone/iPad
                VStack(spacing: 0) {
                    ScrollView {
                        SlotGridView(
                            activeSlots: activeSlots,
                            placements: $placements,
                            rotations: $rotations,
                            draggingImageId: $draggingImageId,
                            allImages: activeImages,
                            slotSize: slotSize(geo: geo, landscape: false),
                            onRotateLeft: rotateLeft,
                            onRotateRight: rotateRight
                        )
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    }
                    .frame(maxHeight: geo.size.height * 0.6)

                    Divider()
                    traySection(imageSize: trayImageSize(geo: geo, landscape: false))
                    actionButtons
                }
            }
        }
    }

    // MARK: - Tray
    private func traySection(imageSize: CGFloat) -> some View {
        let unplacedImages = activeImages.filter { img in
            !placements.values.contains(img.id)
        }
        return VStack(alignment: .leading, spacing: 4) {
            Text("画像トレイ（\(unplacedImages.count)枚未配置）")
                .font(.caption).foregroundColor(.secondary)
                .padding(.horizontal, 12)
            if unplacedImages.isEmpty {
                Text("すべて配置済みです")
                    .font(.caption).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                ImageTrayView(
                    images: unplacedImages,
                    rotations: $rotations,
                    draggingImageId: $draggingImageId,
                    onRotateLeft: rotateLeft,
                    onRotateRight: rotateRight,
                    imageSize: imageSize
                )
                .frame(height: imageSize + 60)
            }
        }
    }

    // MARK: - Buttons
    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                placements = [:]
                rotations = [:]
                shuffledImages = ShuffleUtility.shuffled(caseData.images)
                elapsedSeconds = 0
                timerRunning = true
            } label: {
                Label("リセット", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(white: 0.93))
                    .cornerRadius(10)
            }

            Button {
                scoreAndShow()
            } label: {
                Label("採点する", systemImage: "checkmark.seal.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var timerView: some View {
        Label(TimeFormatter.format(seconds: elapsedSeconds), systemImage: "timer")
            .font(.headline)
            .monospacedDigit()
    }

    // MARK: - Portrait phone notice for full-arch
    private var portraitPhoneFullArchNotice: some View {
        VStack(spacing: 20) {
            Image(systemName: "rotate.right").font(.largeTitle)
            Text("全顎14枚モードは、iPadまたはiPhone横向きでの利用を推奨します。")
                .multilineTextAlignment(.center)
                .font(.body)
            Text("画面を横向きにするか、iPadをご使用ください。")
                .font(.caption).foregroundColor(.secondary)
        }
        .padding(40)
    }

    // MARK: - Scoring
    private func scoreAndShow() {
        timerRunning = false
        let placedStates: [String: PlacedImageState] = placements.reduce(into: [:]) { dict, kv in
            let (slotId, imageId) = kv
            dict[slotId] = PlacedImageState(
                imageId: imageId,
                placedSlotId: slotId,
                currentRotation: rotations[imageId] ?? 0
            )
        }
        let slotResults = ScoringService.score(
            placements: placedStates,
            images: activeImages,
            activeSlotIds: activeSlots.map(\.id)
        )
        let result = PracticeResult(
            id: UUID(),
            date: Date(),
            caseId: caseData.id,
            caseTitle: caseData.title,
            mode: mode,
            slotResults: slotResults,
            elapsedSeconds: elapsedSeconds
        )
        if purchaseManager.isUnlocked {
            historyStore.save(result)
        }
        practiceResult = result
        showResult = true
    }

    // MARK: - Rotation helpers
    private func rotateLeft(_ imageId: String) {
        rotations[imageId] = ((rotations[imageId] ?? 0) - 90 + 360) % 360
    }
    private func rotateRight(_ imageId: String) {
        rotations[imageId] = ((rotations[imageId] ?? 0) + 90) % 360
    }

    // MARK: - Size helpers
    private func slotSize(geo: GeometryProxy, landscape: Bool) -> CGFloat {
        if isIPad { return landscape ? 110 : 90 }
        return landscape ? 90 : 80
    }
    private func trayImageSize(geo: GeometryProxy, landscape: Bool) -> CGFloat {
        if isIPad { return 90 }
        return 70
    }
}
