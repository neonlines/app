import SpriteKit

final class Borders: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        let size = radius * 2
        super.init()
        path = .init(rect: .init(x: -radius, y: -radius, width: size, height: size), transform: nil)
        lineWidth = 2
        lineCap = .round
        lineJoin = .round
        strokeColor = .init(white: 0.85, alpha: 1)
        fillColor = .white
        physicsBody = .init(edgeLoopFrom: CGRect(x: -radius, y: -radius, width: size, height: size))
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .none
        physicsBody!.categoryBitMask = .border
    }
}
