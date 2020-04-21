import GameplayKit

extension GKComponent {
    final class Sprite: GKComponent {
        let sprite: SKSpriteNode

        required init?(coder: NSCoder) { nil }
        init(_ name: String, size: CGFloat) {
            sprite = .init(texture: .init(imageNamed: name), size: .init(width: size, height: size))
            super.init()
        }
    }
    
    final class Body: GKComponent {
        let body: SKPhysicsBody
        
        required init?(coder: NSCoder) { nil }
        init(radius: CGFloat) {
            body = .init(circleOfRadius: radius)
            super.init()
            body.affectedByGravity = false
        }
        
        override func didAddToEntity() {
            entity!.component(ofType: Sprite.self)!.sprite.physicsBody = body
        }
    }
    
    final class Speed: GKComponent {
        var velocity = CGVector(dx: 0, dy: 100)
        private var timer = TimeInterval()
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.02
                entity!.component(ofType: Body.self)!.body.velocity = velocity
                entity!.component(ofType: Draw.self)!.draw()
            }
        }
    }
    
    final class Draw: GKComponent {
        private var last: CGPoint?
        
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
                entity!.component(ofType: Sprite.self)!.sprite.alpha -= 0.005
            }
        }
    }
    
    final class Wheel: GKComponent {
        var origin = CGFloat()
        var radians = CGFloat()
        
        func start() {
            origin = radians
        }
        
        func rotate(_ radians: CGFloat) {
            self.radians = origin + radians
            entity!.component(ofType: Speed.self)!.velocity = .init(dx: sin(self.radians) * 300, dy: cos(self.radians) * 300)
            entity!.component(ofType: Sprite.self)!.sprite.zRotation = self.radians
        }
    }
}
