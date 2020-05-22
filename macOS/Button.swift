import AppKit

final class Button: Control {
    required init?(coder: NSCoder) { nil }
    init(_ title: String) {
        super.init()
        let label = Label(title, .medium(13))
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textColor = .black
        addSubview(label)
        
        bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 9).isActive = true
        rightAnchor.constraint(equalTo: label.rightAnchor, constant: 16).isActive = true
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    func indigo() {
        gradient(.indigo, bottom: .init(red: 0.101, green: 0.388, blue: 0.662, alpha: 1))
    }
    
    func minimal() {
        gradient(.init(gray: 0.96, alpha: 1), bottom: .init(gray: 0.9, alpha: 1))
    }
    
    private func gradient(_ top: CGColor, bottom: CGColor) {
        let gradient = CAGradientLayer()
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 0, y: 0)
        gradient.locations = [0.9, 0.5]
        gradient.colors = [top, bottom]
        gradient.frame = .init(x: 1, y: 1, width: 3, height: 0)
        gradient.cornerRadius = 8
        gradient.borderColor = bottom
        gradient.borderWidth = 1
        self.layer = gradient
        wantsLayer = true
    }
}
