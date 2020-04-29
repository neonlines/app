import AppKit

final class Settings: NSView {
    private var active = true
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        
        let scroll = Scroll()
        addSubview(scroll)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        addSubview(done)
        
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    @objc private func done() {
        guard active else { return }
        active = false
        window?.show(Menu())
    }
}
