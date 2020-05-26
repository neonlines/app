import SpriteKit

final class Chain: SKNode {
    required init?(coder: NSCoder) { nil }
    init(point: CGPoint) {
        super.init()
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .player
        physicsBody!.categoryBitMask = .line
        position = point
    }
}
