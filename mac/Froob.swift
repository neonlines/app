import AppKit

final class Froob: NSView {
    private var active = true
    private weak var timer: Label!
    private let formatter = DateComponentsFormatter()
    private let expected = Calendar.current.date(byAdding: .hour, value: 12, to: profile.lastGame)!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        formatter.allowedUnits = [.hour, .minute, .second]
        
        let title = Label(.key("You.have.a.limit"), .medium(16))
        title.alignment = .center
        title.textColor = .headerColor
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        let subtitle = Label(.key("Your.next.game.is"), .regular(14))
        subtitle.alignment = .center
        subtitle.textColor = .secondaryLabelColor
        subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(subtitle)
        
        let timer = Label("", .bold(40))
        timer.textColor = .headerColor
        timer.alignment = .center
        addSubview(timer)
        self.timer = timer
        
        let option = Label(.key("Your.can.also"), .regular(14))
        option.alignment = .center
        option.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(option)
        
        let done = Button(.key("Done"))
        done.target = self
        done.action = #selector(self.done)
        done.label.textColor = .black
        done.layer!.backgroundColor = .indigoLight
        addSubview(done)
        
        let store = Button(.key("Go.store"))
        store.target = self
        store.action = #selector(self.store)
        store.label.textColor = .white
        store.layer!.backgroundColor = .indigoDark
        addSubview(store)
        
        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -5).isActive = true
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        subtitle.bottomAnchor.constraint(equalTo: timer.topAnchor, constant: -30).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitle.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        subtitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        timer.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true
        timer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        option.topAnchor.constraint(equalTo: timer.bottomAnchor, constant: 50).isActive = true
        option.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        option.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 40).isActive = true
        option.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -40).isActive = true
        
        done.topAnchor.constraint(equalTo: store.bottomAnchor, constant: 20).isActive = true
        done.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        store.topAnchor.constraint(equalTo: option.bottomAnchor, constant: 30).isActive = true
        store.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        update()
    }
    
    private func update() {
        let now = Date()
        if now > expected {
            done()
        } else {
            timer.stringValue = formatter.string(from: now, to: expected) ?? ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.update()
                
            }
        }
    }
    
    @objc private func store() {
        guard active else { return }
        active = false
        window!.show(Store())
    }
    
    @objc private func done() {
        guard active else { return }
        active = false
        window!.show(Options())
    }
}
