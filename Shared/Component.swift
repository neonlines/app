import GameplayKit

extension GKComponent {
    final class Sprite: GKComponent {
        let sprite: SKSpriteNode

        required init?(coder: NSCoder) { nil }
        init(_ name: String, size: CGFloat) {
            sprite = .init(texture: .init(imageNamed: name), size: .init(width: size, height: size))
            super.init()
        }
        
        fileprivate func move(_ delta: CGPoint) {
            sprite.position = .init(x: sprite.position.x + delta.x, y: sprite.position.y + delta.y)
        }
    }
    
    final class Speed: GKComponent {
        private var timer = TimeInterval()
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.02
                entity!.component(ofType: Sprite.self)!.move(.init(x: 0, y: 10))
                entity!.component(ofType: Draw.self)!.draw()
            }
        }
    }
    
    final class Draw: GKComponent {
        fileprivate func draw() {
            (entity!.component(ofType: Sprite.self)!.sprite.scene as! SKScene.Play).path(entity!.component(ofType: Sprite.self)!.sprite.position)
        }
    }
    
    final class Fade: GKComponent {
        private var timer = TimeInterval()
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.02
                guard entity!.component(ofType: Sprite.self)!.sprite.alpha > 0 else {
                    (entity!.component(ofType: Sprite.self)!.sprite.scene as! SKScene.Play).remove(entity as! GKEntity.Path)
                    return
                }
                entity!.component(ofType: Sprite.self)!.sprite.alpha -= 0.01
            }
        }
    }
    
    final class Wheel: GKComponent {
        func rotate(_ radians: CGFloat) {
            entity!.component(ofType: Sprite.self)!.sprite.zRotation -= radians
        }
    }
}
