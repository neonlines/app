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

        let list = Skin.Id.allCases.map {
            "neon.lines.skin." + $0.rawValue
        }
        
        let request = SKProductsRequest(productIdentifiers: .init(list))
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
        
        let skins = header(title: .key("Skins"))
        skins.topAnchor.constraint(equalTo: scroll.top).isActive = true
        var top = skins.bottomAnchor
        
        products.filter { $0.productIdentifier.contains(".skin.") }.sorted { $0.productIdentifier < $1.productIdentifier }.forEach {
            let item = SkinItem(product: $0)
            item.purchase?.target = self
            item.purchase?.action = #selector(purchase)
            scroll.add(item)
            
            if top != scroll.top {
                let separator = self.separator()
                separator.topAnchor.constraint(equalTo: top).isActive = true
                top = separator.bottomAnchor
            }
            
            item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
            item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
            item.topAnchor.constraint(equalTo: top).isActive = true
            top = item.bottomAnchor
        }
        if top != scroll.top {
            scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
        }
    }
    
    private func header(title: String) -> NSView {
        let header = NSView()
        header.translatesAutoresizingMaskIntoConstraints = false
        scroll.add(header)
        
        let label = Label(title, .bold(14))
        label.textColor = .secondaryLabelColor
        header.addSubview(label)
        
        header.leftAnchor.constraint(equalTo: scroll.left, constant: 30).isActive = true
        header.rightAnchor.constraint(equalTo: label.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        label.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12).isActive = true
        return header
    }
    
    private func separator() -> Separator {
        let separator = Separator()
        scroll.add(separator)
        
        separator.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        separator.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
    
    @objc private func purchase(_ button: Button) {
        loading()
        SKPaymentQueue.default().add(.init(product: (button.superview as! Item).product))
    }
    
    @objc private func done() {
        window!.show(Menu())
    }
}

private class Item: NSView {
    weak var purchase: Button?
    let product: SKProduct
    
    required init?(coder: NSCoder) { nil }
    init(product: SKProduct) {
        self.product = product
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
}

private final class SkinItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        
        let image = NSImageView(image: NSImage(named: "skin_" + product.productIdentifier.components(separatedBy: ".").last!)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        
        let title = Label(.key("Purchase.skin.description"), .regular(14))
        title.textColor = .secondaryLabelColor
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        if profile.purchases.contains(product.productIdentifier) {
            let purchased = NSImageView(image: NSImage(named: "purchased")!)
            purchased.translatesAutoresizingMaskIntoConstraints = false
            purchased.imageScaling = .scaleNone
            addSubview(purchased)
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -10).isActive = true
            
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
            purchase.layer!.backgroundColor = .indigoLight
            purchase.label.textColor = .black
            addSubview(purchase)
            self.purchase = purchase
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -10).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -10).isActive = true
            
            price.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
            price.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
            
            purchase.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 5).isActive = true
            purchase.rightAnchor.constraint(equalTo: rightAnchor, constant: -40).isActive = true
        }
        
        heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
