import GameplayKit

extension GKComponent {
    final class Sprite: GKComponent {
        let sprite = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: 32, height: 32))
        
        func move(_ position: CGPoint) {
            sprite.run(.move(to: position, duration: 0.2), withKey: "move")
        }
    }
}
