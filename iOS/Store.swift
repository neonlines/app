import UIKit
import StoreKit

final class Store: UINavigationController, SKRequestDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
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
        super.init(rootViewController: UIViewController())
        viewControllers.first!.view.backgroundColor = .systemBackground
        viewControllers.first!.navigationItem.leftBarButtonItem = .init(title: .key("Restore.purchases"), style: .plain, target: self, action: #selector(restore))
        viewControllers.first!.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let scroll = Scroll()
        viewControllers.first!.view.addSubview(scroll)
        self.scroll = scroll

        scroll.topAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        scroll.height.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
        
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
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = .key("Loading")
        scroll.add(label)
        
        label.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: scroll.top, constant: 20).isActive = true
    }
    
    private func error(_ string: String) {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = string
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
                balam.update(profile)
                break
            case .purchased:
                profile.purchases.insert(transaction.payment.productIdentifier)
                balam.update(profile)
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
    
    private func header(title: String) -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.isUserInteractionEnabled = false
        scroll.add(header)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = title
        label.textColor = .secondaryLabel
        header.addSubview(label)
        
        header.leftAnchor.constraint(equalTo: scroll.left, constant: 16).isActive = true
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
        presentingViewController?.dismiss(animated: true)
    }
}

private class Item: UIView {
    private(set) weak var purchase: Button?
    private(set) weak var image: UIImageView!
    private(set) weak var subtitle: UILabel!
    let product: SKProduct
    
    required init?(coder: NSCoder) { nil }
    init(product: SKProduct) {
        self.product = product
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        addSubview(image)
        self.image = image
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.font = .preferredFont(forTextStyle: .headline)
        title.text = .key(product.productIdentifier)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textColor = .secondaryLabel
        subtitle.font = .preferredFont(forTextStyle: .footnote)
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        self.subtitle = subtitle
        
        if profile.purchases.contains(product.productIdentifier) {
            let purchased = UIImageView(image: UIImage(named: "purchased")!)
            purchased.translatesAutoresizingMaskIntoConstraints = false
            purchased.contentMode = .scaleAspectFit
            purchased.clipsToBounds = true
            addSubview(purchased)
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -5).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -5).isActive = true
            
            purchased.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            purchased.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            purchased.widthAnchor.constraint(equalToConstant: 30).isActive = true
            purchased.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyISOCode
            formatter.locale = product.priceLocale
            let price = UILabel()
            price.translatesAutoresizingMaskIntoConstraints = false
            price.font = .preferredFont(forTextStyle: .caption1)
            price.text = formatter.string(from: product.price)
            addSubview(price)
            
            let purchase = Button(.key("Purchase"))
            purchase.base.backgroundColor = .indigoLight
            purchase.label.textColor = .black
            addSubview(purchase)
            self.purchase = purchase
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -2).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -2).isActive = true
            
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -2).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -2).isActive = true
            
            price.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            price.topAnchor.constraint(equalTo: image.topAnchor, constant: -10).isActive = true
            
            purchase.topAnchor.constraint(equalTo: price.bottomAnchor).isActive = true
            purchase.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        }
        
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        title.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
    }
}

private final class PremiumItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = UIImage(named: "game_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if profile.purchases.contains(product.productIdentifier) {
            subtitle.text = .key("Purchase.premium.got")
        } else {
            subtitle.text = .key("Purchase.premium." + product.productIdentifier.components(separatedBy: ".").last!)
        }
        
        heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

private final class SkinItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = UIImage(named: "skin_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if profile.purchases.contains(product.productIdentifier) {
            subtitle.text = .key("Purchase.skin.got")
        } else {
            subtitle.text = .key("Purchase.skin.subtitle")
        }
        
        heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
