import GameplayKit

extension GKComponent {
    final class Sprite: GKComponent {
        let sprite: SKSpriteNode

        required init?(coder: NSCoder) { nil }
        init(_ name: String, size: CGFloat) {
            sprite = .init(texture: .init(imageNamed: name), size: .init(width: size, height: size))
            super.init()
        }
        
        override func didAddToEntity() {
            guard let colour = entity!.component(ofType: Colour.self)?.primary else { return }
            sprite.color = colour
            sprite.colorBlendFactor = 1
        }
    }
    
    final class Colour: GKComponent {
        let primary: SKColor
        let secondary: SKColor
        
        required init?(coder: NSCoder) { nil }
        init(_ primary: SKColor, secondary: SKColor) {
            self.primary = primary
            self.secondary = secondary
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
        var velocity = CGVector(dx: 0, dy: 500)
        private var timer = TimeInterval()
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.03
                entity!.component(ofType: Body.self)!.body.velocity = velocity
            }
        }
    }
    
    final class Path: GKComponent {
        let sprite = SKShapeNode()
        private var points = [CGPoint]()
        private var timer = TimeInterval()
        
        override func didAddToEntity() {
            sprite.lineWidth = 16
            sprite.lineCap = .round
            sprite.strokeColor = entity!.component(ofType: Colour.self)!.secondary
        }
        
        override func update(deltaTime: TimeInterval) {
            timer -= deltaTime
            if timer <= 0 {
                timer = 0.02
                points.append(entity!.component(ofType: Sprite.self)!.sprite.position)
                if points.count > 500 {
                    points = points.suffix(500)
                }
                let path = CGMutablePath()
                path.addLines(between: points)
                sprite.path = path
            }
        }
    }
    
    final class Wheel: GKComponent {
        var origin = CGFloat()
        var radians = CGFloat()
        let maxSpeed = CGFloat(500)
        
        func start() {
            origin = radians
        }
        
        func rotate(_ radians: CGFloat) {
            self.radians = origin + radians
            let dx = sin(self.radians)
            let dy = cos(self.radians)
            let speedY = (1 - abs(dx)) * maxSpeed
            let speedX = maxSpeed - speedY
            entity!.component(ofType: Speed.self)!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
            entity!.component(ofType: Sprite.self)!.sprite.zRotation = self.radians
        }
    }
}
