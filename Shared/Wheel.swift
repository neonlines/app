import GameplayKit

final class Wheel: GKEntity {
    let sprite = SKSpriteNode(texture: .init(imageNamed: "wheel"), size: .init(width: 240, height: 240))
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        sprite.position.y = -150
    }
}
