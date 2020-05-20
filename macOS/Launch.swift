import AppKit

final class Launch: NSView {
    private weak var press: Label!
    private var show = true
    override var canBecomeKeyView: Bool { true }
    override var acceptsFirstResponder: Bool { true }
    
    required init?(coder: NSCoder) { nil }    
    init() {
        super.init(frame: .zero)
        wantsLayer = true
        let press = Label(.key("Press.to.start"), .bold(14))
        press.alphaValue = 0
        addSubview(press)
        self.press = press
        
        press.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        press.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        animate()
    }
    
    private func animate() {
        NSAnimationContext.runAnimationGroup({
            $0.duration = 1
            $0.allowsImplicitAnimation = true
            press.alphaValue = 1
        }) { [weak self] in
            NSAnimationContext.runAnimationGroup({
                $0.duration = 2
                $0.allowsImplicitAnimation = true
                self?.press.alphaValue = 0
            }) { [weak self] in
                self?.animate()
            }
        }
    }
    
    override func mouseUp(with: NSEvent) {
        launch()
    }
    
    override func keyUp(with: NSEvent) {
        launch()
    }
    
    private func launch() {
        guard show else { return }
        show = false
        window!.show(Options())
    }
}
