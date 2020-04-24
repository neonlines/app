import GameplayKit

private let size = CGFloat(32)
private let maxSpeed = CGFloat(500)
private let maxPoints = 500

final class Player: GKEntity {
    let node = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: size, height: size))
    let line = SKShapeNode()
    private var timer = TimeInterval()
    private var velocity = CGVector(dx: 0, dy: maxSpeed)
    private var rotateOrigin = CGFloat()
    private var radians = CGFloat()
    private var active = true
    
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
    override init() {
        super.init()
        node.entity = self
        node.color = .white
        node.colorBlendFactor = 1
        node.physicsBody = .init(circleOfRadius: size / 2)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.collisionBitMask = .none
        node.physicsBody!.contactTestBitMask = .all
        node.physicsBody!.categoryBitMask = .player
        
        line.entity = self
        line.lineWidth = size / 2
        line.lineCap = .round
        line.strokeColor = .init(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        linePoints.reserveCapacity(maxPoints)
    }
    
    func move() {
        linePoints.append(node.position)
        linePoints = linePoints.suffix(maxPoints)
        node.physicsBody!.velocity = velocity
    }
    
    func recede() {
        if linePoints.count > 0 {
            linePoints.removeFirst()
        }
    }
    
    func startRotating() {
        rotateOrigin = radians
    }
    
    func rotate(_ radians: CGFloat) {
        self.radians = rotateOrigin + radians
        let dx = sin(self.radians)
        let dy = cos(self.radians)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        velocity = .init(dx: dx * speedX, dy: dy * speedY)
        node.zRotation = self.radians
    }
    
    func explode() {
        node.physicsBody = nil
        
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
        emitter.position = node.position
        node.scene!.addChild(emitter)
        node.alpha = 0
    }
}
