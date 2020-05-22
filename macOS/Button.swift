import AppKit

final class Button: Control {
    private weak var label: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        let label = Label(title, .bold(14))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
    }
    
    func indigo() {
        large()
        layer!.backgroundColor = .init(red: 0.101, green: 0.388, blue: 0.662, alpha: 1)
    }
    
    func red() {
        large()
        layer!.backgroundColor = .init(red: 0.9, green: 0, blue: 0, alpha: 1)
    }
    
    func minimal() {
        label.textColor = .init(white: 0.5, alpha: 1)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 9).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 9).isActive = true
    }
    
    private func large() {
        wantsLayer = true
        layer!.cornerRadius = 10
        label.textColor = .white
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
