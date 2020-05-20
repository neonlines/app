import QuartzCore

final class Rainbow: CALayer {
    private weak var gradient: CAGradientLayer!
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        let gradient = CAGradientLayer()
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.locations = [0, 0.5, 1]
        gradient.colors = [CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5),
                           CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5),
                           CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)]
        gradient.frame = .init(x: 80, y: 1, width: 60, height: 0)
        addSublayer(gradient)
        self.gradient = gradient
    }
    
    override func layoutSublayers() {
        gradient.frame.size.height = frame.size.height - 2
    }
}
