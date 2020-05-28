import UIKit

final class Settings: UINavigationController {
    private weak var scroll: Scroll!
    private let itemSize = CGFloat(120)
    private let itemSpacing = CGFloat(50)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(rootViewController: UIViewController())
        viewControllers.first!.view.backgroundColor = .systemBackground
        viewControllers.first!.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(done))
        viewControllers.first!.navigationItem.title = .key("Settings")
        navigationBar.tintColor = .indigoDark
        
        let scroll = Scroll()
        viewControllers.first!.view.addSubview(scroll)
        self.scroll = scroll
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = .bold(14)
        subtitle.text = .key("Choose.your.skin")
        subtitle.textColor = .init(white: 0.7, alpha: 1)
        scroll.add(subtitle)
        
        scroll.topAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: viewControllers.first!.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        scroll.height.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: scroll.top, constant: 10).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: scroll.centerX).isActive = true
        
        Skin.Id.allCases.forEach { id in
            let item = Item(id: id)
            item.target = self
            scroll.add(item)
            
            
            
            
            
            if game.active(id) {
                item.action = #selector(change)
            } else {
                item.action = #selector(store)
                item.purchaseable()
                
                let subtitle = Label(.key("In.app"), .regular(12))
                subtitle.textColor = .init(white: 0.2, alpha: 1)
                scroll.add(subtitle)
                
                subtitle.centerXAnchor.constraint(equalTo: item.centerXAnchor).isActive = true
                subtitle.topAnchor.constraint(equalTo: item.bottomAnchor, constant: 5).isActive = true
            }

            item.selected = id == game.profile.skin
            item.widthAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.top = item.topAnchor.constraint(equalTo: scroll.top)
            item.left = item.leftAnchor.constraint(equalTo: scroll.left)
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.views.last!.bottomAnchor, constant: itemSpacing).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    private func refresh() {
        scroll.views.forEach { $0.removeFromSuperview() }
        let ratio = (viewControllers.first!.view.frame.width + 10) / (itemSize + 10)
        let empty = Int(ratio) > Skin.Id.allCases.count ? ceil(CGFloat(.init(ratio) - Skin.Id.allCases.count)) : 0
        let left = (ratio.truncatingRemainder(dividingBy: 1) + empty) * (itemSize / 2)
        var point = CGPoint(x: left, y: 40)
        Skin.Id.allCases.forEach { id in
            if point.x > viewControllers.first!.view.frame.width - itemSize {
                point = .init(x: left, y: point.y + itemSize + 10)
            }
            
            let item = Item(id: id)
            item.selected = id == game.profile.skin
            item.target = self
            scroll.add(item)
            
            if id == .basic || game.profile.purchases.contains(where: { $0.hasSuffix(id.rawValue) }) {
                item.action = #selector(change)
            } else {
                item.action = #selector(store)
                item.purchaseable()
            }
    
            item.widthAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.topAnchor.constraint(equalTo: scroll.top, constant: point.y).isActive = true
            item.leftAnchor.constraint(equalTo: scroll.left, constant: point.x).isActive = true
            point.x += itemSize + 10
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.views.last!.bottomAnchor, constant: 40).isActive = true
    }
    
    @objc private func change(_ item: Item) {
        guard !item.selected else { return }
        game.profile.skin = item.id
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == game.profile.skin
        }
    }
    
    @objc private func done() {
        super.dismiss(animated: true)
    }
    
    @objc private func store() {
        present(Store(), animated: true)
    }
    
    override func dismiss(animated: Bool, completion: (() -> Void)?) {
        super.dismiss(animated: animated, completion: completion)
        refresh()
    }
}

private final class Item: Control {
    let id: Skin.Id
    private weak var image: UIImageView!
    private weak var border: UIView!
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        clipsToBounds = true
        layer.cornerRadius = 32
        
        let skin = Skin.make(id: id)
        
        let border = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.layer.cornerRadius = 20
        border.backgroundColor = skin.colour
        addSubview(border)
        self.border = border
        
        let image = UIImageView(image: UIImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        addSubview(image)
        self.image = image
        
        border.widthAnchor.constraint(equalToConstant: 40).isActive = true
        border.heightAnchor.constraint(equalToConstant: 40).isActive = true
        border.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 30).isActive = true
        image.heightAnchor.constraint(equalToConstant: 30).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    var selected = false {
        didSet {
            border.alpha = selected ? 1 : 0
            image.alpha = selected ? 1 : 0.5
            layer.borderWidth = selected ? 5 : 2
//            layer.borderColor = selected ? .indigo : UIColor.separator.cgColor
        }
    }
    
    func purchaseable() {
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        addSubview(base)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .key("New.skin")
        title.font = .preferredFont(forTextStyle: .headline)
        title.textColor = .black
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = .key("Purchase.on.store")
        subtitle.font = .preferredFont(forTextStyle: .footnote)
        subtitle.textColor = .black
        subtitle.textAlignment = .center
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        
        base.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        base.topAnchor.constraint(equalTo: title.topAnchor, constant: -10).isActive = true
        
        title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        subtitle.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 10).isActive = true
        subtitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
