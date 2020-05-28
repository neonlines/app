import AppKit

final class Settings: NSView {
    private weak var scroll: Scroll!
    private let itemSize = CGFloat(120)
    private let itemSpacing = CGFloat(50)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let done = Button(.key("Done"))
        done.small()
        done.target = self
        done.action = #selector(self.done)
        addSubview(done)
        
        let separator = Separator()
        addSubview(separator)
        
        let scroll = Scroll()
        addSubview(scroll)
        self.scroll = scroll
        
        let title = Label(.key("Settings"), .bold(12))
        title.textColor = .black
        addSubview(title)
        
        let subtitle = Label(.key("Choose.your.skin"), .bold(14))
        subtitle.textColor = .init(white: 0.7, alpha: 1)
        scroll.add(subtitle)
        
        title.centerYAnchor.constraint(equalTo: done.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 90).isActive = true
        
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        separator.topAnchor.constraint(equalTo: done.bottomAnchor, constant: 9).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        done.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        done.topAnchor.constraint(equalTo: topAnchor, constant: 9).isActive = true
        
        scroll.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        scroll.width.constraint(equalTo: scroll.widthAnchor).isActive = true
        scroll.height.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
        
        subtitle.topAnchor.constraint(equalTo: scroll.top, constant: 50).isActive = true
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
        arrange()
    }
    
    override func viewDidEndLiveResize() {
        arrange()
    }
    
    private func arrange() {
        guard let width = NSApp.keyWindow?.frame.size.width else { return }
        let ratio = (width - itemSpacing) / (itemSize + itemSpacing)
        let empty = Int(ratio) > Skin.Id.allCases.count ? ceil(CGFloat(.init(ratio) - Skin.Id.allCases.count)) : 0
        let left = ((ratio.truncatingRemainder(dividingBy: 1) + empty) * ((itemSize + itemSpacing) / 2)) + itemSpacing
        var point = CGPoint(x: left, y: 120)
        scroll.views.compactMap { $0 as? Item }.forEach {
            if point.x > width - itemSize {
                point = .init(x: left, y: point.y + itemSize + itemSpacing)
            }
            $0.left.constant = point.x
            $0.top.constant = point.y
            point.x += itemSize + itemSpacing
        }
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.5
            $0.allowsImplicitAnimation = true
            scroll.contentView.layoutSubtreeIfNeeded()
        }
    }
    
    @objc private func done() {
        window!.show(Options())
    }
    
    @objc private func change(_ item: Item) {
        guard !item.selected else { return }
        game.profile.skin = item.id
        scroll.views.compactMap { $0 as? Item }.forEach {
            $0.selected = $0.id == game.profile.skin
        }
    }
    
    @objc private func store() {
        window!.show(Store())
    }
}

private final class Item: Control {
    weak var top: NSLayoutConstraint! { didSet { top.isActive = true } }
    weak var left: NSLayoutConstraint! { didSet { left.isActive = true } }
    let id: Skin.Id
    private weak var name: NSView!
    private weak var shape: CAShapeLayer!
    private weak var imageX: NSLayoutConstraint!
    private weak var imageY: NSLayoutConstraint!
    private var greyed = CGColor(gray: 0.9, alpha: 1)
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 20
        layer!.borderWidth = 1
        
        let skin = Skin.make(id: id)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 40
        shape.strokeColor = skin.colour.cgColor
        shape.lineCap = .round
        shape.path = {
            $0.move(to: .init(x: 90, y: 90))
            $0.addLine(to: .zero)
            return $0
        } (CGMutablePath())
        shape.strokeEnd = 0
        layer!.addSublayer(shape)
        self.shape = shape
        
        let image = NSImageView(image: NSImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleProportionallyUpOrDown
        addSubview(image)
        
        let name = NSView()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.wantsLayer = true
        name.layer!.backgroundColor = .black
        addSubview(name)
        self.name = name
        
        let label = Label(.key("neon.lines.skin." + id.rawValue), .regular(12))
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
            layer!.borderColor = selected ? .black : greyed
            
            if selected {
                imageX.constant = 30
                imageY.constant = -30
                NSAnimationContext.runAnimationGroup( {
                    $0.duration = 0.6
                    $0.allowsImplicitAnimation = true
                    layoutSubtreeIfNeeded()
                }) { [weak self] in
                    NSAnimationContext.runAnimationGroup {
                        $0.duration = 0.3
                        self?.shape.strokeEnd = 1
                    }
                }
            } else {
                NSAnimationContext.runAnimationGroup( {
                    $0.duration = 0.2
                    shape.strokeEnd = 0
                }) { [weak self] in
                    self?.imageX.constant = 0
                    self?.imageY.constant = 0
                    NSAnimationContext.runAnimationGroup ({
                        $0.duration = 0.5
                        $0.allowsImplicitAnimation = true
                        self?.shape.strokeEnd = 0
                        self?.layoutSubtreeIfNeeded()
                    }) {
                        self?.shape.strokeEnd = 0
                    }
                }
            }
        }
    }
    
    func purchaseable() {
        greyed = .indigoDark
        
        let base = NSView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.wantsLayer = true
        base.layer!.backgroundColor = .indigoDark
        addSubview(base)
        
        let title = Label(.key("Visit.store"), .bold(12))
        title.textColor = .white
        addSubview(title)
        
        base.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        base.topAnchor.constraint(equalTo: title.topAnchor, constant: -9).isActive = true
        
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
