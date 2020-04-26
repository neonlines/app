import SpriteKit

final class Minimap: SKShapeNode {
    private let radius: CGFloat
    private let size = CGFloat(50)
    private let ratio: CGFloat
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        ratio = size / 2 / radius
        self.radius = radius
        super.init()
        path = .init(rect: .init(x: size / -2, y: size / -2, width: size, height: size), transform: nil)
        fillColor = NSApp.effectiveAppearance == NSAppearance(named: .darkAqua) ? .black : .white
        lineWidth = 0
        zPosition = 3
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / 2) - 30, y: (scene!.frame.height / -2) + 30)
    }
    
    func clear() {
        children.forEach { $0.removeFromParent() }
    }
    
    func show(_ point: CGPoint, color: SKColor) {
        let node = SKShapeNode(circleOfRadius: 3)
        node.fillColor = color
        node.lineWidth = 0
        node.position = .init(x: point.x * ratio, y: point.y * ratio)
        addChild(node)
    }
}
