import AppKit

final class Button: Control {
    private(set) weak var label: Label!
    
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        let gradient = CAGradientLayer()
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 0, y: 0)
        gradient.locations = [0.9, 0.5]
        gradient.colors = [CGColor.indigo, CGColor(red: 0.101, green: 0.388, blue: 0.662, alpha: 1)]
        gradient.frame = .init(x: 1, y: 1, width: 3, height: 0)
        gradient.cornerRadius = 8
        gradient.borderColor = CGColor(red: 0.101, green: 0.388, blue: 0.662, alpha: 1)
        gradient.borderWidth = 1
        self.layer = gradient
        wantsLayer = true
        
        let label = Label(title, .bold(14))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(label)
        self.label = label
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 9).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 16).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
}
