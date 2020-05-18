import SpriteKit

final class Player: SKSpriteNode {
    var id = -1
    let line: Line
    private let maxSpeed = CGFloat(300)
    
    required init?(coder: NSCoder) { nil }
    init(line: Line) {
        self.line = line
        super.init(texture: .init(imageNamed: line.skin.texture), color: .clear, size: .init(width: 16, height: 16))
        zPosition = 2
        physicsBody = .init(circleOfRadius: 14)
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
        warp.run(.sequence([.group([.fadeAlpha(to: 0.5, duration: 4), .scale(to: 0.2, duration: 4)])]))
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
        emitter.particleSize = .init(width: 8, height: 8)
        emitter.particleBirthRate = 50
        emitter.emissionAngleRange = .pi * 2
        emitter.particleRotationRange = .pi * 2
        emitter.particleColor = line.skin.colour
        emitter.particleColorBlendFactor = 1
        emitter.particleSpeed = 30
        emitter.particleLifetime = 15
        emitter.numParticlesToEmit = 50
        emitter.particleAlphaSpeed = -0.3
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
