import GameplayKit

final class Borders: GKEntity {
    let node = SKNode()
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        super.init()
        node.physicsBody = .init(edgeLoopFrom: CGRect(x: -radius, y: -radius, width: radius + radius, height: radius + radius))
    }
}
