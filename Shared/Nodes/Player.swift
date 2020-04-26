import SpriteKit

final class Player: SKSpriteNode {
    let line = SKShapeNode()
    private var active = true
    private let maxSpeed = CGFloat(500)
    private let maxPoints = 500
    
    private var linePoints = [CGPoint]() {
        didSet {
            let node = CGMutablePath()
            node.addLines(between: linePoints)
            line.path = node
            
            let points = linePoints.dropLast(6)
            guard !points.isEmpty else { return }
            let body = CGMutablePath()
            body.addLines(between: .init(points))
            line.physicsBody = .init(edgeChainFrom: body)
            line.physicsBody!.collisionBitMask = .none
            line.physicsBody!.contactTestBitMask = .none
            line.physicsBody!.categoryBitMask = .line
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(texture: .init(imageNamed: "node"), color: .white, size: .init(width: 32, height: 32))
        colorBlendFactor = 1
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .all
        physicsBody!.categoryBitMask = .player
        
        line.lineWidth = 16
        line.lineCap = .round
        line.strokeColor = .init(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        linePoints.reserveCapacity(maxPoints)
    }
    
    func move() {
        let dx = sin(zRotation)
        let dy = cos(zRotation)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        physicsBody!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
        
        linePoints.append(position)
        linePoints = linePoints.suffix(maxPoints)
    }
    
    func recede() {
        if linePoints.count > 0 {
            linePoints.removeFirst()
        }
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
