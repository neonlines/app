import UIKit
import StoreKit

final class Store: UINavigationController, StoreDelegate {
    private weak var scroll: Scroll!
    private weak var refreshable: Refreshable?
    private let store = StoreMaster()
    
    required init?(coder: NSCoder) { nil }
    init(refreshable: Refreshable?) {
        super.init(rootViewController: UIViewController())
        viewControllers.first!.view.backgroundColor = .systemBackground
        viewControllers.first!.navigationItem.leftBarButtonItem = .init(title: .key("Restore.purchases"), style: .plain, target: self, action: #selector(restore))
        viewControllers.first!.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationBar.tintColor = .indigoDark
        self.refreshable = refreshable
        
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
        store.delegate = self
        store.load()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshable?.refresh()
    }
    
    func error(_ string: String) {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .medium(14)
        label.text = string
        label.textColor = .init(white: 0.6, alpha: 1)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        scroll.add(label)
        
        label.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: scroll.top, constant: 30).isActive = true
        label.rightAnchor.constraint(lessThanOrEqualTo: scroll.right, constant: -30).isActive = true
    }
    
    func refresh() {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let headerPremium = UILabel()
        headerPremium.translatesAutoresizingMaskIntoConstraints = false
        headerPremium.font = .bold(14)
        headerPremium.text = .key("Premium")
        headerPremium.textColor = .init(white: 0.7, alpha: 1)
        scroll.add(headerPremium)
        
        headerPremium.centerXAnchor.constraint(equalTo: scroll.centerX).isActive = true
        headerPremium.topAnchor.constraint(equalTo: scroll.top, constant: 30).isActive = true
        var top = headerPremium.bottomAnchor
        
        store.products.filter { $0.productIdentifier.contains(".premium.") }.forEach {
            top = item(PremiumItem(product: $0), top: top)
        }
        
        let headerSkins = UILabel()
        headerSkins.translatesAutoresizingMaskIntoConstraints = false
        headerSkins.text = .key("Skins")
        headerSkins.font = .bold(14)
        headerSkins.textColor = .init(white: 0.7, alpha: 1)
        scroll.add(headerSkins)
        
        headerSkins.centerXAnchor.constraint(equalTo: scroll.centerX).isActive = true
        headerSkins.topAnchor.constraint(equalTo: top, constant: 50).isActive = true
        top = headerSkins.bottomAnchor
        
        store.products.filter { $0.productIdentifier.contains(".skin.") }.sorted { $0.productIdentifier < $1.productIdentifier }.forEach {
            if top != headerSkins.bottomAnchor {
                let separator = Separator()
                scroll.add(separator)
                
                separator.leftAnchor.constraint(equalTo: scroll.left, constant: 80).isActive = true
                separator.rightAnchor.constraint(equalTo: scroll.right, constant: -80).isActive = true
                separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                separator.topAnchor.constraint(equalTo: top).isActive = true
                top = separator.bottomAnchor
            }
            
            top = item(SkinItem(product: $0), top: top)
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
    }
    
    private func loading() {
        scroll.views.forEach { $0.removeFromSuperview() }
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .bold(20)
        label.textColor = .init(white: 0.75, alpha: 1)
        label.text = .key("Loading")
        scroll.add(label)
        
        label.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: scroll.top, constant: 30).isActive = true
    }
    
    private func item(_ item: Item, top: NSLayoutYAxisAnchor) -> NSLayoutYAxisAnchor {
        item.purchase?.target = self
        item.purchase?.action = #selector(purchase)
        scroll.add(item)
        
        item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
        item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
        item.topAnchor.constraint(equalTo: top).isActive = true
        return item.bottomAnchor
    }
    
    @objc private func purchase(_ button: Button) {
        loading()
        store.purchase((button.superview as! Item).product)
    }
    
    @objc private func restore() {
        loading()
        store.restore()
    }
    
    @objc private func done() {
        dismiss(animated: true)
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
        title.font = .bold(16)
        title.text = .key(product.productIdentifier)
        title.textColor = .black
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.numberOfLines = 0
        subtitle.textColor = .init(white: 0.5, alpha: 1)
        subtitle.font = .regular(13)
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        self.subtitle = subtitle
        
        if game.profile.purchases.contains(product.productIdentifier) {
            let purchased = UIImageView(image: UIImage(named: "purchased")!)
            purchased.translatesAutoresizingMaskIntoConstraints = false
            purchased.contentMode = .scaleAspectFit
            purchased.clipsToBounds = true
            addSubview(purchased)
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -20).isActive = true
            
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchased.leftAnchor, constant: -20).isActive = true
            
            purchased.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            purchased.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
            purchased.widthAnchor.constraint(equalToConstant: 30).isActive = true
            purchased.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyISOCode
            formatter.locale = product.priceLocale
            
            let price = UILabel()
            price.translatesAutoresizingMaskIntoConstraints = false
            price.font = .regular(12)
            price.textColor = .indigoDark
            price.text = formatter.string(from: product.price)
            addSubview(price)
            
            let purchase = Button(.key("Purchase"))
            purchase.clean()
            addSubview(purchase)
            self.purchase = purchase
            
            title.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -20).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -20).isActive = true
            
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: purchase.leftAnchor, constant: -20).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: price.leftAnchor, constant: -20).isActive = true
            
            price.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            price.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
            
            purchase.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 5).isActive = true
            purchase.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        }
        
        bottomAnchor.constraint(greaterThanOrEqualTo: subtitle.bottomAnchor, constant: 20).isActive = true
        bottomAnchor.constraint(greaterThanOrEqualTo: image.bottomAnchor, constant: 30).isActive = true
        let height = heightAnchor.constraint(equalToConstant: 1)
        height.priority = .defaultLow
        height.isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        image.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        title.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 10).isActive = true
        title.topAnchor.constraint(equalTo: image.topAnchor, constant: 5).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2).isActive = true
        subtitle.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
    }
}

private final class PremiumItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = UIImage(named: "game_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if game.profile.purchases.contains(product.productIdentifier) {
            subtitle.text = .key("Purchase.premium.got")
        } else {
            subtitle.text = .key("Purchase.premium." + product.productIdentifier.components(separatedBy: ".").last!)
        }
    }
}

private final class SkinItem: Item {
    required init?(coder: NSCoder) { nil }
    override init(product: SKProduct) {
        super.init(product: product)
        image.image = UIImage(named: "skin_" + product.productIdentifier.components(separatedBy: ".").last!)!
        
        if game.profile.purchases.contains(product.productIdentifier) {
            subtitle.text = .key("Purchase.skin.got")
        } else {
            subtitle.text = .key("Purchase.skin.subtitle")
        }
    }
}
