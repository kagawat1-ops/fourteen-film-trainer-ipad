import SwiftUI

@main
struct FourteenFilmTrainerApp: App {
    @StateObject private var purchaseManager = PurchaseManager()
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(purchaseManager)
                .environmentObject(historyStore)
                .task {
                    await purchaseManager.checkCurrentEntitlements()
                }
        }
    }
}
