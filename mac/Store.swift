import AppKit
import StoreKit

final class Store: NSView, SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private weak var request: SKProductsRequest?
    private weak var scroll: Scroll!
    private let formatter = NumberFormatter()
    
    private var products = [SKProduct]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.refresh()
            }
        }
    }
    
    private let list: Set<String>
    
    required init?(coder: NSCoder) { nil }
    init() {
        list = .init()
        super.init(frame: .zero)
        formatter.numberStyle = .currencyISOCode
        
        let restore = Button(.key("Restore.purchases"))
        restore.target = self
        restore.action = #selector(self.done)
        addSubview(restore)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.layer!.backgroundColor = .indigoLight
        addSubview(done)
        
        let separator = Separator()
        addSubview(separator)
        
        let scroll = Scroll()
        addSubview(scroll)
        self.scroll = scroll
        
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        restore.rightAnchor.constraint(equalTo: done.leftAnchor, constant: -20).isActive = true
        restore.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -13).isActive = true
        
        done.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        done.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -13).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
        scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
        
        loading()
        
        SKPaymentQueue.default().add(self)

        let request = SKProductsRequest(productIdentifiers: list)
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
    func paymentQueueRestoreCompletedTransactionsFinished(_: SKPaymentQueue) { DispatchQueue.main.async { [weak self] in self?.refresh() } }
    func request(_: SKRequest, didFailWithError: Error) { DispatchQueue.main.async { [weak self] in self?.error(didFailWithError.localizedDescription) } }
    func paymentQueue(_: SKPaymentQueue, restoreCompletedTransactionsFailedWithError: Error) { DispatchQueue.main.async { [weak self] in self?.error(restoreCompletedTransactionsFailedWithError.localizedDescription) } }
    
    private func loading() {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let label = Label(.key("Loading"), .bold(12))
        scroll.add(label)
        
        label.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: scroll.top, constant: 20).isActive = true
    }
    
    private func error(_ string: String) {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let label = Label(string, .regular(14))
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        scroll.add(label)
        
        label.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: scroll.top, constant: 20).isActive = true
        label.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -20).isActive = true
    }
    
    private func update(_ transactions: [SKPaymentTransaction]) {
        guard !transactions.contains(where: { $0.transactionState == .purchasing }) else { return }
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
//                app.session.purchase(map.first { $0.1 == transaction.payment.productIdentifier }!.key)
                break
            case .purchased:
//                app.session.purchase(map.first { $0.1 == transaction.payment.productIdentifier }!.key)
                SKPaymentQueue.default().finishTransaction(transaction)
            default: break
            }
        }
        if !products.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.refresh()
            }
        }
    }
    
    private func refresh() {
        scroll.views.forEach { $0.removeFromSuperview() }
    }
    
    @objc private func done() {
        window!.show(Menu())
    }
}

private final class Item: NSView {
    private(set) weak var image: NSImageView!
    private(set) weak var title: Label!
    private(set) weak var subtitle: Label!
    private(set) weak var purchased: Label!
    private(set) weak var price: Label!
    private(set) weak var purchase: Button!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        self.image = image
        
        let title = Label("", .bold(20))
        title.textColor = .headerTextColor
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        self.title = title
        
        let subtitle = Label("", .regular(14))
        subtitle.textColor = .secondaryLabelColor
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        self.subtitle = subtitle
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
    }
}
