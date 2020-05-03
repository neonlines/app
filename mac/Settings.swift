import AppKit

final class Settings: NSView {
    private var active = true
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        
        let scroll = Scroll()
        addSubview(scroll)
        
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
    }
    
    @objc private func done() {
        guard active else { return }
        active = false
        window!.show(Menu())
    }
}

private final class Item: Control {
    let id: Skin.Id
    
    required init?(coder: NSCoder) { nil }
    init(id: Skin.Id) {
        self.id = id
        super.init()
        let skin = Skin.make(id: id)
        
        let image = NSImageView(image: NSImage(named: skin.texture)!)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.imageScaling = .scaleNone
        addSubview(image)
        
        image.widthAnchor.constraint(equalToConstant: 32).isActive = true
        image.heightAnchor.constraint(equalToConstant: 32).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
