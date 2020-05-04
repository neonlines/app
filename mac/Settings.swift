import AppKit

final class Settings: NSView {
    private var active = true
    private weak var scroll: Scroll!
    
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
        addSubview(done)
        
        let title = Label(.key("Choose.your.skin"), .regular(16))
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
        separator.bottomAnchor.constraint(equalTo: done.topAnchor, constant: -10).isActive = true
        
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        title.topAnchor.constraint(equalTo: scroll.top, constant: 50).isActive = true
        title.leftAnchor.constraint(equalTo: scroll.left, constant: 20).isActive = true
        
        Skin.Id.allCases.forEach {
            let item = Item(id: $0)
            item.target = self
            item.action = #selector(change)
            item.selected = $0 == profile.skin
            scroll.add(item)
    
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
        guard let size = NSApp.keyWindow?.frame.size else { return }
        var point = CGPoint(x: 20, y: 100)
        scroll.views.compactMap { $0 as? Item }.forEach {
            if point.x > size.width - 100 {
                point = .init(x: 20, y: point.y + 220)
            }
            $0.left.constant = point.x
            $0.top.constant = point.y
            point.x += 120
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
        window!.show(Menu())
    }
    
    @objc private func change(_ item: Item) {
        guard !item.selected else { return }
        profile.skin = item.id
        balam.update(profile)
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == profile.skin
        }
    }
}

private final class Item: Control {
    let id: Skin.Id
    weak var top: NSLayoutConstraint! { didSet { top.isActive = true } }
    weak var left: NSLayoutConstraint! { didSet { left.isActive = true } }
    private weak var image: NSImageView!
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 12
        layer!.borderWidth = 2
        
        let skin = Skin.make(id: id)
        
        let image = NSImageView(image: NSImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        self.image = image
        
        widthAnchor.constraint(equalToConstant: 100).isActive = true
        heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 64).isActive = true
        image.heightAnchor.constraint(equalToConstant: 64).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
    }
    
    var selected = false {
        didSet {
            layer!.borderColor = selected ? NSColor.indigoLight.cgColor : NSColor.separatorColor.cgColor
            image.alphaValue = selected ? 1 : 0.5
        }
    }
}
