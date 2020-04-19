import GameplayKit

final class Sprite: GKComponent {
    let sprite = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: 32, height: 32))
}
