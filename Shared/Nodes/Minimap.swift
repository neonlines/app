import SpriteKit

final class Minimap: SKShapeNode {
    private let radius: CGFloat
    private let ratio: CGFloat
    private let size = CGFloat(70)
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        ratio = size / 2 / radius
        self.radius = radius
        super.init()
        path = .init(rect: .init(x: size / -2, y: size / -2, width: size, height: size), transform: nil)
        fillColor = .init(white: 1, alpha: 0.95)
        lineWidth = 1
        strokeColor = .init(white: 0.9, alpha: 1)
        zPosition = 12
    }
    
    func align() {
        position = .init(x: (scene!.frame.width / 2) - 45, y: (scene!.frame.height / 2) - 70)
    }
    
    func clear() {
        children.forEach { $0.removeFromParent() }
    }
    
    func show(_ point: CGPoint, color: SKColor, me: Bool) {
        let node = SKShapeNode(circleOfRadius: me ? 7 : 4)
        node.fillColor = color
        node.lineWidth = 1
        node.strokeColor = .init(white: me ? 0 : 0.4, alpha: 1)
        node.zPosition = me ? 13 : 14
        node.position = .init(x: point.x * ratio, y: point.y * ratio)
        addChild(node)
    }
}
