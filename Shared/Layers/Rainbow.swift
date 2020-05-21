import QuartzCore

final class Rainbow: CALayer {
    private weak var gradient: CAGradientLayer!
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    
    override init() {
        super.init()
        let gradient = CAGradientLayer()
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.locations = [0, 0.5, 1]
        gradient.colors = [CGColor(red: 1, green: 0, blue: 0, alpha: 1),
                           CGColor(red: 0.101, green: 0.388, blue: 0.662, alpha: 1),
                           CGColor(red: 0.4, green: 0.643, blue: 0.843, alpha: 1)]

        gradient.frame = .init(x: 1, y: 1, width: 90, height: 0)
        gradient.maskedCorners = .init(arrayLiteral: .layerMinXMaxYCorner, .layerMinXMinYCorner)
        gradient.cornerRadius = 5
        addSublayer(gradient)
        self.gradient = gradient
    }
    
    override func layoutSublayers() {
        gradient.frame.size.height = frame.size.height - 2
    }
}
