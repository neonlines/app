import AppKit

final class Button: Control {
    private weak var label: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        let label = Label(title, .bold(12))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
    }
    
    func indigo() {
        large()
        layer!.backgroundColor = .indigoDark
    }
    
    func red() {
        large()
        layer!.backgroundColor = .init(red: 0.9, green: 0, blue: 0, alpha: 1)
    }
    
    func minimal() {
        label.textColor = .init(white: 0.5, alpha: 1)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    }
    
    func small() {
        wantsLayer = true
        layer!.cornerRadius = 6
        layer!.backgroundColor = .indigoDark
        label.textColor = .white
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 6).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 12).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }
    
    func clean() {
        wantsLayer = true
        layer!.cornerRadius = 6
        layer!.backgroundColor = .init(gray: 0.9, alpha: 1)
        label.textColor = .indigoDark
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 7).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 16).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    private func large() {
        wantsLayer = true
        layer!.cornerRadius = 10
        label.textColor = .white
        label.font = .bold(14)
        
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        widthAnchor.constraint(equalToConstant: 170).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
