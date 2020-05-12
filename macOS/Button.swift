import AppKit

final class Button: Control {
    private(set) weak var label: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 6
        
        let label = Label(title, .medium(14))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 4).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 16).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
}
