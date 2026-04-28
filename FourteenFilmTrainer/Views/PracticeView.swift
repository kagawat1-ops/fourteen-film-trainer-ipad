import SwiftUI

struct PracticeView: View {
    let caseData: CaseData
    let mode: PracticeMode

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var historyStore: HistoryStore
    @EnvironmentObject var purchaseManager: PurchaseManager

    private var activeSlots: [Slot] { slots(for: mode) }

    private var activeImages: [RadiographImage] {
        let slotIds = Set(activeSlots.map(\.id))
        return shuffledImages.filter { slotIds.contains($0.correctSlotId) }
    }

    @State private var shuffledImages: [RadiographImage] = []
    @State private var placements: [String: String] = [:]       // slotId → imageId
    @State private var rotations: [String: Int] = [:]            // imageId → rotation
    @State private var draggingImageId: String? = nil
    @State private var selectedImageId: String? = nil            // tap-to-place
    @State private var elapsedSeconds = 0
    @State private var timerRunning = false
    @State private var showResult = false
    @State private var practiceResult: PracticeResult? = nil

    @Environment(\.horizontalSizeClass) private var hSizeClass
    @Environment(\.verticalSizeClass) private var vSizeClass

    private var isIPad: Bool { hSizeClass == .regular && vSizeClass == .regular }
    private var isPortraitPhone: Bool { hSizeClass == .compact && vSizeClass == .regular }

    // Unplaced images (shown in tray)
    private var trayImages: [RadiographImage] {
        activeImages.filter { !placements.values.contains($0.id) }
    }

    var body: some View {
        Group {
            if mode == .fullArch14 && isPortraitPhone {
                portraitPhoneNotice
            } else {
                GeometryReader { geo in
                    let landscape = geo.size.width > geo.size.height
                    if landscape || isIPad {
                        landscapeLayout(geo: geo)
                    } else {
                        portraitLayout(geo: geo)
                    }
                }
            }
        }
        .navigationTitle("\(caseData.title) ― \(mode.displayName)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                timerLabel
            }
        }
        .onAppear {
            shuffledImages = ShuffleUtility.shuffled(caseData.images)
            rotations = makeInitialRotations(for: caseData.images)
            placements = [:]
            elapsedSeconds = 0
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

    // MARK: - Landscape / iPad layout
    // Left: slot grid  |  Right: vertical tray + action buttons
    private func landscapeLayout(geo: GeometryProxy) -> some View {
        let rightPanelWidth: CGFloat = isIPad
            ? min(geo.size.width * 0.30, 260)
            : min(geo.size.width * 0.35, 220)
        let slotSz = slotSize(available: geo.size.width - rightPanelWidth)

        return HStack(spacing: 0) {
            // ── Left: slot grid ──
            ScrollView {
                SlotGridView(
                    activeSlots: activeSlots,
                    placements: $placements,
                    rotations: $rotations,
                    draggingImageId: $draggingImageId,
                    selectedImageId: $selectedImageId,
                    allImages: activeImages,
                    slotSize: slotSz,
                    onRotateLeft: rotateLeft,
                    onRotateRight: rotateRight
                )
                .padding()
            }
            .frame(maxWidth: .infinity)

            Divider()

            // ── Right: tray + buttons ──
            VStack(spacing: 0) {
                // Tray fills remaining height
                ImageTrayView(
                    images: trayImages,
                    rotations: $rotations,
                    draggingImageId: $draggingImageId,
                    selectedImageId: $selectedImageId,
                    onRotateLeft: rotateLeft,
                    onRotateRight: rotateRight,
                    cardWidth: rightPanelWidth
                )
                .frame(maxHeight: .infinity)

                Divider()

                // Action buttons pinned at bottom of right panel
                actionButtons
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
            }
            .frame(width: rightPanelWidth)
            .background(Color(white: 0.96))
        }
    }

    // MARK: - Portrait layout (iPhone portrait or iPad portrait)
    private func portraitLayout(geo: GeometryProxy) -> some View {
        let slotSz = slotSize(available: geo.size.width)
        let trayHeight = geo.size.height * 0.40

        return VStack(spacing: 0) {
            // Slot grid
            ScrollView {
                SlotGridView(
                    activeSlots: activeSlots,
                    placements: $placements,
                    rotations: $rotations,
                    draggingImageId: $draggingImageId,
                    selectedImageId: $selectedImageId,
                    allImages: activeImages,
                    slotSize: slotSz,
                    onRotateLeft: rotateLeft,
                    onRotateRight: rotateRight
                )
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }

            Divider()

            // Tray (vertical scroll, capped height)
            ImageTrayView(
                images: trayImages,
                rotations: $rotations,
                draggingImageId: $draggingImageId,
                selectedImageId: $selectedImageId,
                onRotateLeft: rotateLeft,
                onRotateRight: rotateRight,
                cardWidth: geo.size.width
            )
            .frame(height: trayHeight)

            Divider()

            // Action buttons
            actionButtons
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
        }
    }

    // MARK: - Subviews
    private var timerLabel: some View {
        Label(TimeFormatter.format(seconds: elapsedSeconds), systemImage: "timer")
            .font(.headline)
            .monospacedDigit()
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button {
                placements = [:]
                shuffledImages = ShuffleUtility.shuffled(caseData.images)
                rotations = makeInitialRotations(for: caseData.images)
                selectedImageId = nil
                elapsedSeconds = 0
                timerRunning = true
            } label: {
                Label("リセット", systemImage: "arrow.counterclockwise")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(white: 0.90))
                    .cornerRadius(10)
            }

            Button { scoreAndShow() } label: {
                Label("採点する", systemImage: "checkmark.seal.fill")
                    .font(.subheadline).bold()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private var portraitPhoneNotice: some View {
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
        selectedImageId = nil
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

    // MARK: - Initial rotation randomiser
    // Each image gets a random angle from [0, 90, 180, 270].
    // 0° is the registered (correct) orientation; students rotate back to 0 to score.
    private func makeInitialRotations(for images: [RadiographImage]) -> [String: Int] {
        let angles = [0, 90, 180, 270]
        return images.reduce(into: [:]) { dict, img in
            dict[img.id] = angles.randomElement() ?? 0
        }
    }

    // MARK: - Size helpers
    private func slotSize(available width: CGFloat) -> CGFloat {
        // For full-arch 14: fit 7 slots per row
        let count: CGFloat = 7
        let padding: CGFloat = 24
        let spacing: CGFloat = 8 * (count - 1)
        let calculated = (width - padding - spacing) / count
        let minimum: CGFloat = isIPad ? 90 : 72
        return max(calculated, minimum)
    }
}
