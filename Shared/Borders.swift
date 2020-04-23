import GameplayKit

final class Borders: GKEntity {
    let node: SKShapeNode
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        let size = radius * 2
        node = .init(rectOf: .init(width: size, height: size))
        super.init()
        node.lineWidth = 32
        node.lineCap = .round
        node.lineJoin = .round
        node.strokeColor = .init(red: 0.35, green: 0.35, blue: 0.35, alpha: 1)
        node.physicsBody = .init(edgeLoopFrom: CGRect(x: -radius, y: -radius, width: size, height: size))
        node.physicsBody!.collisionBitMask = .none
        node.physicsBody!.contactTestBitMask = .player
        node.physicsBody!.categoryBitMask = .border
    }
}
