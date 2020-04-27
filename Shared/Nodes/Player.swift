import SpriteKit

final class Player: SKSpriteNode {
    let line: Line
    private weak var emitter: SKEmitterNode?
    private let maxSpeed = CGFloat(300)
    
    required init?(coder: NSCoder) { nil }
    init(line: Line) {
        self.line = line
        super.init(texture: .init(imageNamed: "node"), color: .clear, size: .init(width: 32, height: 32))
        zPosition = 2
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .all
        physicsBody!.categoryBitMask = .player
    }
    
    func move() {
        guard physicsBody != nil else {
            line.recede()
            return
        }
        let dx = sin(zRotation)
        let dy = cos(zRotation)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        physicsBody!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
        line.append(position)
    }
    
    func explode() {
        guard physicsBody != nil else { return }
        physicsBody = nil
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = .init(image: NSImage(named: "particle")!)
        emitter.particleSize = .init(width: 8, height: 8)
        emitter.particleBirthRate = 100
        emitter.emissionAngleRange = .pi * 2
        emitter.particleRotationRange = .pi * 2
        emitter.particleColor = line.strokeColor
        emitter.particleSpeed = 50
        emitter.particleLifetime = 10
        emitter.numParticlesToEmit = 50
        emitter.particleAlphaSpeed = -0.5
        emitter.particleRotationSpeed = 0.5
        emitter.position = position
        emitter.zPosition = 3
        scene!.addChild(emitter)
        self.emitter = emitter
        alpha = 0
    }
    
    func remove() {
        emitter?.removeFromParent()
        line.removeFromParent()
        removeFromParent()
    }
}
