import UIKit

final class Settings: UIViewController {
    private weak var scroll: Scroll!
    private let itemSize = CGFloat(220)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: navigationController?.presentingViewController, action: #selector(dismiss))
        navigationItem.title = .key("Choose.your.skin")
        
        let scroll = Scroll()
        view.addSubview(scroll)
        self.scroll = scroll
        
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        scroll.height.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
        
        let width = view.frame.width
        let left = (width / (itemSize + 20)).truncatingRemainder(dividingBy: 1) * (itemSize / 2)
        var point = CGPoint(x: left, y: 150)
        Skin.Id.allCases.forEach { id in
            if point.x > width - itemSize {
                point = .init(x: left, y: point.y + itemSize + 20)
            }
            
            let item = Item(id: id)
            item.selected = id == profile.skin
            item.target = self
            scroll.add(item)
            
            if id == .basic || profile.purchases.contains(where: { $0.hasSuffix(id.rawValue) }) {
                item.action = #selector(change)
            } else {
                item.action = #selector(store)
                item.purchaseable()
            }
    
            item.widthAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.topAnchor.constraint(equalTo: scroll.top, constant: point.y).isActive = true
            item.leftAnchor.constraint(equalTo: scroll.left, constant: point.x).isActive = true
            point.x += itemSize + 20
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.views.last!.bottomAnchor, constant: 30).isActive = true
    }
    
    @objc private func change(_ item: Item) {
        guard !item.selected else { return }
        profile.skin = item.id
        balam.update(profile)
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == profile.skin
        }
    }
    
    @objc private func store() {

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
        layer.cornerRadius = 32
        layer.borderWidth = 5
        
        let skin = Skin.make(id: id)
        
        let border = UIView()
        border.isUserInteractionEnabled = false
        border.translatesAutoresizingMaskIntoConstraints = false
        border.layer.cornerRadius = 45
        border.backgroundColor = skin.colour
        addSubview(border)
        self.border = border
        
        let image = UIImageView(image: UIImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        addSubview(image)
        self.image = image
        
        border.widthAnchor.constraint(equalToConstant: 90).isActive = true
        border.heightAnchor.constraint(equalToConstant: 90).isActive = true
        border.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        border.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 70).isActive = true
        image.heightAnchor.constraint(equalToConstant: 70).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    var selected = false {
        didSet {
            border.alpha = selected ? 1 : 0
            image.alpha = selected ? 1 : 0.5
            layer.borderColor = selected ? .indigoLight : UIColor.separator.cgColor
        }
    }
    
    func purchaseable() {
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .indigoLight
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
        subtitle.font = .preferredFont(forTextStyle: .caption1)
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
