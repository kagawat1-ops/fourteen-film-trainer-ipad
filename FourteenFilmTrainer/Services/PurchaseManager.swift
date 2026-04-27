import StoreKit
import Combine

// MARK: - Product ID constant (change here when submitting to App Store Connect)
enum ProductID {
    static let fullUnlock = "jp.example.fourteenfilm.fullunlock"
}

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var isUnlocked: Bool = false
    @Published private(set) var product: Product? = nil
    @Published var purchaseError: String? = nil

    private var updateListenerTask: Task<Void, Never>? = nil
    private let unlockedKey = "isFullyUnlocked"

    init() {
        // Persist unlock state across launches
        isUnlocked = UserDefaults.standard.bool(forKey: unlockedKey)
        updateListenerTask = listenForTransactions()
        Task { await loadProduct() }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load product from StoreKit
    func loadProduct() async {
        do {
            let products = try await Product.products(for: [ProductID.fullUnlock])
            product = products.first
        } catch {
            purchaseError = "商品情報の取得に失敗しました。"
        }
    }

    // MARK: - Purchase
    func purchase() async {
        guard let product else {
            purchaseError = "商品情報が読み込めていません。しばらく待ってから再試行してください。"
            return
        }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await unlock()
                await transaction.finish()
            case .userCancelled:
                break
            case .pending:
                purchaseError = "購入が承認待ちです。"
            @unknown default:
                break
            }
        } catch {
            purchaseError = "購入処理中にエラーが発生しました: \(error.localizedDescription)"
        }
    }

    // MARK: - Restore
    func restore() async {
        do {
            try await AppStore.sync()
            await checkCurrentEntitlements()
        } catch {
            purchaseError = "復元に失敗しました: \(error.localizedDescription)"
        }
    }

    // MARK: - Entitlement check
    func checkCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == ProductID.fullUnlock,
               transaction.revocationDate == nil {
                await unlock()
                return
            }
        }
    }

    // MARK: - Helpers
    private func unlock() async {
        isUnlocked = true
        UserDefaults.standard.set(true, forKey: unlockedKey)
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let value): return value
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case .verified(let transaction) = result,
                   transaction.productID == ProductID.fullUnlock,
                   transaction.revocationDate == nil {
                    await self.unlock()
                    await transaction.finish()
                }
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
