import AppKit

final class Settings: NSView {
    private weak var scroll: Scroll!
    private var active = true
    private let itemSize = CGFloat(220)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        
        let scroll = Scroll()
        addSubview(scroll)
        self.scroll = scroll
        
        let separator = Separator()
        addSubview(separator)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.layer!.backgroundColor = .indigoLight
        addSubview(done)
        
        let title = Label(.key("Choose.your.skin"), .bold(16))
        scroll.add(title)
        
        scroll.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        scroll.height.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
        
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.bottomAnchor.constraint(equalTo: done.topAnchor, constant: -15).isActive = true
        
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        
        title.topAnchor.constraint(equalTo: scroll.top, constant: 80).isActive = true
        title.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        
        Skin.Id.allCases.forEach { id in
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
            item.top = item.topAnchor.constraint(equalTo: scroll.top)
            item.left = item.leftAnchor.constraint(equalTo: scroll.left)
        }
        
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.views.last!.bottomAnchor, constant: 30).isActive = true
        arrange()
    }
    
    override func viewDidEndLiveResize() {
        arrange()
    }
    
    private func arrange() {
        guard let width = NSApp.keyWindow?.frame.size.width else { return }
        let left = ((width + 20) / (itemSize + 20)).truncatingRemainder(dividingBy: 1) * (itemSize / 2)
        var point = CGPoint(x: left, y: 150)
        scroll.views.compactMap { $0 as? Item }.forEach {
            if point.x > width - itemSize {
                point = .init(x: left, y: point.y + itemSize + 20)
            }
            $0.left.constant = point.x
            $0.top.constant = point.y
            point.x += itemSize + 20
        }
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.5
            $0.allowsImplicitAnimation = true
            scroll.contentView.layoutSubtreeIfNeeded()
        }
    }
    
    @objc private func done() {
        guard active else { return }
        active = false
        window!.show(Options())
    }
    
    @objc private func change(_ item: Item) {
        guard active, !item.selected else { return }
        profile.skin = item.id
        balam.update(profile)
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == profile.skin
        }
    }
    
    @objc private func store() {
        guard active else { return }
        active = false
        window!.show(Store())
    }
}

private final class Item: Control {
    let id: Skin.Id
    weak var top: NSLayoutConstraint! { didSet { top.isActive = true } }
    weak var left: NSLayoutConstraint! { didSet { left.isActive = true } }
    private weak var image: NSImageView!
    private weak var border: NSView!
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 32
        layer!.borderWidth = 5
        
        let skin = Skin.make(id: id)
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.cornerRadius = 45
        border.layer!.backgroundColor = skin.colour.cgColor
        addSubview(border)
        self.border = border
        
        let image = NSImageView(image: NSImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
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
            border.alphaValue = selected ? 1 : 0
            image.alphaValue = selected ? 1 : 0.5
            layer!.borderColor = selected ? .indigoLight : NSColor.separatorColor.cgColor
        }
    }
    
    func purchaseable() {
        let base = NSView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.wantsLayer = true
        base.layer!.backgroundColor = .indigoLight
        addSubview(base)
        
        let title = Label(.key("New.skin"), .medium(16))
        title.textColor = .black
        title.alignment = .center
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = Label(.key("Purchase.on.store"), .regular(12))
        subtitle.textColor = .black
        subtitle.alignment = .center
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
