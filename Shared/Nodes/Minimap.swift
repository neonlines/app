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
        fillColor = .init(white: 0.7, alpha: 0.2)
        lineWidth = 0
        zPosition = 12
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / 2) - 30, y: (scene!.frame.height / -2) + 40)
    }
    
    func clear() {
        children.forEach { $0.removeFromParent() }
    }
    
    func show(_ point: CGPoint, color: SKColor) {
        let node = SKShapeNode(circleOfRadius: 4)
        node.fillColor = color
        node.lineWidth = 1
        node.strokeColor = .init(white: 0.7, alpha: 1)
        node.zPosition = 13
        node.position = .init(x: point.x * ratio, y: point.y * ratio)
        addChild(node)
    }
}
