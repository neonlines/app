import SpriteKit

final class Borders: SKShapeNode {
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        let size = radius * 2
        let padding = CGFloat(16)
        let diameter = padding * 2
        super.init()
        path = .init(rect: .init(x: -radius, y: -radius, width: size, height: size), transform: nil)
        lineWidth = diameter
        lineCap = .round
        lineJoin = .round
        strokeColor = .quaternaryLabelColor
        physicsBody = .init(edgeLoopFrom: CGRect(x: -radius + padding, y: -radius + padding, width: size - diameter, height: size - diameter))
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .none
        physicsBody!.categoryBitMask = .border
    }
}
