import SpriteKit

class Scene: SKScene {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init(size: .zero)
        anchorPoint = .init(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        backgroundColor = .windowBackgroundColor
    }
    
    func align() { }
    func startRotating() { }
    func rotate(_ radians: CGFloat) { }
    func move() { }
}
