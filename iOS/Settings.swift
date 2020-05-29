import UIKit

final class Settings: UINavigationController, Refreshable {
    private weak var scroll: Scroll!
    private let itemSize = CGFloat(120)
    private let itemSpacing = CGFloat(20)
    
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
        
        subtitle.topAnchor.constraint(equalTo: scroll.top, constant: 30).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: scroll.centerX).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func refresh() {
        scroll.views.compactMap { $0 as? Item }.forEach { $0.removeFromSuperview() }
        
        let width = viewControllers.first!.view.frame.width
        let ratio = (width - itemSpacing) / (itemSize + itemSpacing)
        let empty = Int(ratio) > Skin.Id.allCases.count ? ceil(CGFloat(.init(ratio) - Skin.Id.allCases.count)) : 0
        let left = ((ratio.truncatingRemainder(dividingBy: 1) + empty) * ((itemSize + itemSpacing) / 2)) + itemSpacing
        var point = CGPoint(x: left, y: 70)
        
        Skin.Id.allCases.forEach { id in
            let item = Item(id: id)
            item.target = self
            scroll.add(item)
            
            if game.active(id) {
                item.action = #selector(change)
            } else {
                item.action = #selector(store)
                item.purchaseable()
                
                let subtitle = UILabel()
                subtitle.translatesAutoresizingMaskIntoConstraints = false
                subtitle.font = .regular(12)
                subtitle.textColor = .init(white: 0.2, alpha: 1)
                scroll.add(subtitle)
                
                subtitle.centerXAnchor.constraint(equalTo: item.centerXAnchor).isActive = true
                subtitle.topAnchor.constraint(equalTo: item.bottomAnchor, constant: 5).isActive = true
            }
            
            if point.x > width - itemSize {
                point = .init(x: left, y: point.y + itemSize + itemSpacing)
            }

            item.selected = id == game.profile.skin
            item.widthAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.heightAnchor.constraint(equalToConstant: itemSize).isActive = true
            item.leftAnchor.constraint(equalTo: scroll.left, constant: point.x).isActive = true
            item.topAnchor.constraint(equalTo: scroll.top, constant: point.y).isActive = true
            
            point.x += itemSize + itemSpacing
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.views.last!.bottomAnchor, constant: itemSpacing).isActive = true
    }
    
    @objc private func done() {
        dismiss(animated: true)
    }
    
    @objc private func change(_ item: Item) {
        guard !item.selected else { return }
        game.profile.skin = item.id
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == game.profile.skin
        }
    }
    
    @objc private func store() {
        present(Store(refreshable: self), animated: true)
    }
}

private final class Item: Control {
    let id: Skin.Id
    private weak var name: UIView!
    private weak var shape: CAShapeLayer!
    private weak var imageX: NSLayoutConstraint!
    private weak var imageY: NSLayoutConstraint!
    private var greyed = CGColor(genericGrayGamma2_2Gray: 0.9, alpha: 1)
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        clipsToBounds = true
        layer.cornerRadius = 20
        layer.borderWidth = 1
        
        let skin = Skin.make(id: id)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 40
        shape.strokeColor = skin.colour.cgColor
        shape.lineCap = .round
        shape.path = {
            $0.move(to: .init(x: 90, y: 30))
            $0.addLine(to: .init(x: 0, y: 120))
            return $0
        } (CGMutablePath())
        shape.strokeEnd = 0
        layer.addSublayer(shape)
        self.shape = shape
        
        let image = UIImageView(image: UIImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        addSubview(image)
        
        let name = UIView()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.isUserInteractionEnabled = false
        name.backgroundColor = .black
        addSubview(name)
        self.name = name
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = .key("neon.lines.skin." + id.rawValue)
        label.font = .medium(12)
        label.textColor = .white
        name.addSubview(label)
        
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageX = image.centerXAnchor.constraint(equalTo: centerXAnchor)
        imageY = image.centerYAnchor.constraint(equalTo: centerYAnchor)
        imageX.isActive = true
        imageY.isActive = true
        
        name.heightAnchor.constraint(equalToConstant: 32).isActive = true
        name.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        name.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        name.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: name.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: name.centerYAnchor).isActive = true
    }
    
    var selected = false {
        didSet {
            name.isHidden = !selected
            layer.borderColor = selected ? .init(genericGrayGamma2_2Gray: 0, alpha: 1) : greyed
            
            if selected {
                imageX.constant = 30
                imageY.constant = -30
                UIView.animate(withDuration: 0.6, animations: { [weak self] in
                    self?.layoutIfNeeded()
                }) { [weak self] _ in
                    UIView.animate(withDuration: 0.3) {
                        self?.shape.strokeEnd = 1
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.shape.strokeEnd = 0
                }) { [weak self] _ in
                    self?.imageX.constant = 0
                    self?.imageY.constant = 0
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.shape.strokeEnd = 0
                        self?.layoutIfNeeded()
                    }) { [weak self] _ in
                        self?.shape.strokeEnd = 0
                    }
                }
            }
        }
    }
    
    func purchaseable() {
        greyed = .indigoDark
        
        let base = UIView()
        base.isUserInteractionEnabled = false
        base.translatesAutoresizingMaskIntoConstraints = false
        base.backgroundColor = .indigoDark
        addSubview(base)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = .key("Visit.store")
        title.font = .bold(12)
        title.textColor = .white
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        base.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        base.topAnchor.constraint(equalTo: title.topAnchor, constant: -9).isActive = true
        
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
