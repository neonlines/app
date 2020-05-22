import StoreKit

final class StoreMaster: NSObject, SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    weak var delegate: StoreDelegate?
    
    private(set) var products = [SKProduct]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.refresh()
            }
        }
    }
    
    private weak var request: SKProductsRequest?
    
    func load() {
        SKPaymentQueue.default().add(self)

        let request = SKProductsRequest(productIdentifiers: .init(["neon.lines.premium.unlimited"] + Skin.Id.allCases.map {
            "neon.lines.skin." + $0.rawValue
        }))
        request.delegate = self
        self.request = request
        request.start()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func productsRequest(_: SKProductsRequest, didReceive: SKProductsResponse) { products = didReceive.products }
    func paymentQueue(_: SKPaymentQueue, updatedTransactions: [SKPaymentTransaction]) { update(updatedTransactions) }
    func paymentQueue(_: SKPaymentQueue, removedTransactions: [SKPaymentTransaction]) { update(removedTransactions) }
    func paymentQueueRestoreCompletedTransactionsFinished(_: SKPaymentQueue) { DispatchQueue.main.async { [weak self] in self?.delegate?.refresh() } }
    func request(_: SKRequest, didFailWithError: Error) { DispatchQueue.main.async { [weak self] in self?.delegate?.error(didFailWithError.localizedDescription) } }
    func paymentQueue(_: SKPaymentQueue, restoreCompletedTransactionsFailedWithError: Error) { DispatchQueue.main.async { [weak self] in self?.delegate?.error(restoreCompletedTransactionsFailedWithError.localizedDescription) } }
    
    private func update(_ transactions: [SKPaymentTransaction]) {
        guard !transactions.contains(where: { $0.transactionState == .purchasing }) else { return }
        transactions.forEach {
            switch $0.transactionState {
            case .failed:
                SKPaymentQueue.default().finishTransaction($0)
            case .restored, .purchased:
                game.profile.purchases.insert($0.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction($0)
            default: break
            }
        }
        if !products.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.refresh()
            }
        }
    }
    
    func purchase(_ product: SKProduct) {
        SKPaymentQueue.default().add(.init(product: product))
    }
    
    @objc func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
