import AppKit

final class Froob: NSView {
    private weak var timer: Label!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let title = Label(.key("You.have.a.limit"), .medium(14))
        title.alignment = .center
        title.textColor = .init(white: 0.4, alpha: 1)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = Label(.key("Your.next.game.is"), .medium(14))
        subtitle.alignment = .center
        subtitle.textColor = .indigoLight
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        
        let timer = Label("", NSFont(descriptor: NSFont.bold(30).fontDescriptor.addingAttributes([.featureSettings: [[NSFontDescriptor.FeatureKey.selectorIdentifier: kMonospacedNumbersSelector,
        .typeIdentifier: kNumberSpacingType]]]), size: 0)!)
        timer.textColor = .indigoDark
        addSubview(timer)
        self.timer = timer
        
        let option = Label(.key("Your.can.also"), .regular(14))
        option.alignment = .center
        option.textColor = .init(white: 0.3, alpha: 1)
        option.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(option)
        
        let store = Button(.key("Go.store"))
        store.target = self
        store.action = #selector(self.store)
        store.indigo()
        addSubview(store)
        
        let done = Button(.key("Cancel"))
        done.minimal()
        done.target = self
        done.action = #selector(self.done)
        addSubview(done)
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        subtitle.bottomAnchor.constraint(equalTo: timer.topAnchor, constant: -10).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitle.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        subtitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        timer.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        timer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        option.bottomAnchor.constraint(equalTo: store.topAnchor, constant: -50).isActive = true
        option.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        option.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        option.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        store.bottomAnchor.constraint(equalTo: done.topAnchor, constant: -20).isActive = true
        store.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        done.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40).isActive = true
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        update()
    }
    
    private func update() {
        guard let time = game.timer else {
            done()
            return
        }
        timer.stringValue = time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.update()
        }
    }
    
    @objc private func store() {
        window!.show(Store())
    }
    
    @objc private func done() {
        window!.show(Options())
    }
}
