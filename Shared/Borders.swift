import GameplayKit

final class Borders: GKEntity {
    let node: SKShapeNode
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        let size = radius * 2
        let padding = CGFloat(16)
        let diameter = padding * 2
        node = .init(rectOf: .init(width: size, height: size))
        super.init()
        node.lineWidth = diameter
        node.lineCap = .round
        node.lineJoin = .round
        node.strokeColor = .init(red: 0.35, green: 0.35, blue: 0.35, alpha: 1)
        node.physicsBody = .init(edgeLoopFrom: CGRect(x: -radius + padding, y: -radius + padding, width: size - diameter, height: size - diameter))
        node.physicsBody!.collisionBitMask = .none
        node.physicsBody!.contactTestBitMask = .none
        node.physicsBody!.categoryBitMask = .border
    }
}
