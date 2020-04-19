import GameplayKit

extension GKComponent {
    final class Sprite: GKComponent {
        let sprite = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: 32, height: 32))
        
        fileprivate func move(delta: CGPoint) {
            sprite.position = .init(x: sprite.position.x + delta.x, y: sprite.position.y + delta.y)
            print(sprite.position.y)
        }
    }
    
    final class Speed: GKComponent {
        private var timer = TimeInterval()
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.02
                entity!.component(ofType: Sprite.self)!.move(delta: .init(x: 0, y: 10))
            }
        }
    }
}
