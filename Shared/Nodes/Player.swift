import SpriteKit

final class Player: SKSpriteNode {
    let line = Line()
    private var active = true
    private let maxSpeed = CGFloat(500)
    
    required init?(coder: NSCoder) { nil }
    init(color: SKColor) {
        super.init(texture: .init(imageNamed: "node"), color: color, size: .init(width: 32, height: 32))
        colorBlendFactor = 1
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .all
        physicsBody!.categoryBitMask = .player
    }
    
    func move() {
        let dx = sin(zRotation)
        let dy = cos(zRotation)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        physicsBody!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
        line.append(position)
    }
    
    func recede() {
        line.recede()
    }
    
    func explode() {
        physicsBody = nil
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = .init(image: NSImage(named: "particle")!)
        emitter.particleSize = .init(width: 8, height: 8)
        emitter.particleBirthRate = 100
        emitter.emissionAngleRange = .pi * 2
        emitter.particleRotationRange = .pi * 2
        emitter.particleColor = .white
        emitter.particleSpeed = 50
        emitter.particleLifetime = 10
        emitter.numParticlesToEmit = 50
        emitter.particleAlphaSpeed = -0.5
        emitter.particleRotationSpeed = 0.5
        emitter.position = position
        scene!.addChild(emitter)
        alpha = 0
    }
}
