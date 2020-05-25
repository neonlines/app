import SpriteKit

final class Player: SKSpriteNode {
    var id = -1
    let line: Line
    private let maxSpeed = CGFloat(300)
    
    required init?(coder: NSCoder) { nil }
    init(line: Line) {
        self.line = line
        super.init(texture: .init(imageNamed: line.skin.texture), color: .clear, size: .init(width: 32, height: 32))
        zPosition = 2
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .all
        physicsBody!.categoryBitMask = .player
        
        let warp = SKShapeNode(rect: .init(x: -60, y: -60, width: 120, height: 120), cornerRadius: 60)
        warp.fillColor = line.skin.colour
        warp.lineWidth = 0
        warp.alpha = 0
        warp.zPosition = -1
        addChild(warp)
        warp.run(.sequence([.group([.fadeAlpha(to: 1, duration: 4), .scale(to: 0.1, duration: 4)])])) {
            warp.removeFromParent()
        }
    }
    
    func move() {
        let dx = sin(zRotation)
        let dy = cos(zRotation)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        physicsBody!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
    }
    
    func explode() {
        guard physicsBody != nil else { return }
        physicsBody = nil
        
        let emitter = SKEmitterNode()
        emitter.particleTexture = .init(imageNamed: "particle")
        emitter.particleSize = .init(width: 10, height: 10)
        emitter.particleBirthRate = 50
        emitter.emissionAngleRange = .pi * 2
        emitter.particleRotationRange = .pi * 2
        emitter.particleColor = line.skin.colour
        emitter.particleColorBlendFactor = 1
        emitter.particleSpeed = 60
        emitter.particleLifetime = 5
        emitter.numParticlesToEmit = 50
        emitter.particleAlphaSpeed = -0.2
        emitter.particleRotationSpeed = 0.5
        emitter.particlePosition = .zero
        emitter.particlePositionRange = .zero
        emitter.zPosition = 3
        addChild(emitter)
        texture = nil
        color = .clear
    }
    
    func remove() {
        line.removeFromParent()
        removeFromParent()
    }
}
