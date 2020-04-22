import GameplayKit

final class Wheel: GKEntity {
    let node = SKSpriteNode(texture: .init(imageNamed: "wheel"), size: .init(width: 240, height: 240))
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        node.position.y = -150
    }
}
