import AppKit
import StoreKit

final class Store: NSView, SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private weak var request: SKProductsRequest?
    private weak var scroll: Scroll!
    
    private var products = [SKProduct]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.refresh()
            }
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let restore = Button(.key("Restore.purchases"))
        restore.target = self
        restore.action = #selector(self.restore)
        restore.layer!.borderColor = NSColor.labelColor.cgColor
        restore.layer!.borderWidth = 1
        addSubview(restore)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.layer!.backgroundColor = .indigo
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
                profile.purchases.insert(transaction.payment.productIdentifier)
                break
            case .purchased:
                profile.purchases.insert(transaction.payment.productIdentifier)
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
        
        let game = header(title: .key("Premium"))
        game.topAnchor.constraint(equalTo: scroll.top).isActive = true
        var top = game.bottomAnchor
        
        products.filter { $0.productIdentifier.contains(".premium.") }.forEach {
            top = item(PremiumItem(product: $0), top: top)
        }
        
        let skins = header(title: .key("Skins"))
        skins.topAnchor.constraint(equalTo: top).isActive = true
        top = skins.bottomAnchor
        
        products.filter { $0.productIdentifier.contains(".skin.") }.sorted { $0.productIdentifier < $1.productIdentifier }.forEach {
            top = item(SkinItem(product: $0), top: top)
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
    }
    
    private func item(_ item: Item, top: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        let separator = Separator()
        scroll.add(separator)
        
        item.purchase?.target = self
        item.purchase?.action = #selector(purchase)
        scroll.add(item)
        
        separator.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        separator.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.topAnchor.constraint(equalTo: top).isActive = true
        
        item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        item.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        return item.bottomAnchor
    }
    
    private func header(title: String) -> NSView {
        let header = NSView()
        header.translatesAutoresizingMaskIntoConstraints = false
        scroll.add(header)
        
        let label = Label(title, .bold(16))
        label.textColor = .tertiaryLabelColor
        header.addSubview(label)
        
        header.leftAnchor.constraint(equalTo: scroll.left, constant: 30).isActive = true
        header.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        label.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        return header
    }
    
    @objc private func purchase(_ button: Button) {
        loading()
        SKPaymentQueue.default().add(.init(product: (button.superview as! Item).product))
    }
    
    @objc private func restore() {
        loading()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    @objc private func done() {
        window!.show(Options())
    }
}

private class Item: NSView {
    private(set) weak var purchase: Button?
    private(set) weak var image: NSImageView!
    private(set) weak var subtitle: Label!
    let product: SKProduct
    
    required init?(coder: NSCoder) { nil }
    init(product: SKProduct) {
        self.product = product
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = NSImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        self.image = image
        
        let title = Label(.key(product.productIdentifier), .bold(16))
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = Label("", .regular(14))
        subtitle.textColor = .secondaryLabelColor
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        self.subtitle = subtitle
        
        if profile.purchases.contains(product.productIdentifier) {
            let purchased = NSImageView(image: NSImage(named: "purchased")!)
            purchased.translatesAutoresizingMaskIntoConstraints = false
            purchased.imageScaling = .scaleNone
            addSubview(purchased)
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -10).isActive = true
            
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -10).isActive = true
            
            purchased.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            purchased.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            purchased.widthAnchor.constraint(equalToConstant: 30).isActive = true
            purchased.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyISOCode
            formatter.locale = product.priceLocale
            let price = Label(formatter.string(from: product.price) ?? "", .medium(14))
            addSubview(price)
            
            let purchase = Button(.key("Purchase"))
            purchase.layer!.backgroundColor = .indigo
            purchase.label.textColor = .black
            addSubview(purchase)
            self.purchase = purchase
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -10).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -10).isActive = true
            
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -10).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -10).isActive = true
            
            price.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            price.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
            
            purchase.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 5).isActive = true
            purchase.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        }
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
    }
}

private final class PremiumItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = NSImage(named: "game_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if profile.purchases.contains(product.productIdentifier) {
            subtitle.stringValue = .key("Purchase.premium.got")
        } else {
            subtitle.stringValue = .key("Purchase.premium." + product.productIdentifier.components(separatedBy: ".").last!)
        }
        
        heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 88).isActive = true
        image.heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
}

private final class SkinItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = NSImage(named: "skin_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if profile.purchases.contains(product.productIdentifier) {
            subtitle.stringValue = .key("Purchase.skin.got")
        } else {
            subtitle.stringValue = .key("Purchase.skin.subtitle")
        }
        
        heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
}
