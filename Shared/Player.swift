import GameplayKit

private let size = CGFloat(32)
private let maxSpeed = CGFloat(500)
private let maxPoints = 500

final class Player: GKEntity {
    let node = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: size, height: size))
    let line = SKShapeNode()
    private var timer = TimeInterval()
    private var velocity = CGVector(dx: 0, dy: maxSpeed)
    private var linePoints = [CGPoint]()
    private var rotateOrigin = CGFloat()
    private var radians = CGFloat()
    private var active = true
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        node.color = .white
        node.colorBlendFactor = 1
        node.physicsBody = .init(circleOfRadius: size / 2)
        node.physicsBody!.affectedByGravity = false
        
        line.lineWidth = size / 2
        line.lineCap = .round
        line.strokeColor = .init(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        linePoints.reserveCapacity(maxPoints)
    }

    override func update(deltaTime: TimeInterval) {
        timer -= deltaTime
        if timer <= 0 {
            timer = 0.02
            if active {
                linePoints.append(node.position)
                linePoints = linePoints.suffix(maxPoints)
                node.physicsBody!.velocity = velocity
            } else if !linePoints.isEmpty {
                linePoints.removeFirst()
            }
            let path = CGMutablePath()
            path.addLines(between: linePoints)
            line.path = path
            line.physicsBody = .init(edgeChainFrom: path)
            line.physicsBody?.collisionBitMask = 0
        }
    }
    
    func startRotating() {
        rotateOrigin = radians
    }
    
    func rotate(_ radians: CGFloat) {
        guard active else { return }
        self.radians = rotateOrigin + radians
        let dx = sin(self.radians)
        let dy = cos(self.radians)
        let speedY = (1 - abs(dx)) * maxSpeed
        let speedX = maxSpeed - speedY
        velocity = .init(dx: dx * speedX, dy: dy * speedY)
        node.zRotation = self.radians
    }
    
    func explode() {
        guard active else { return }
        active = false
        
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
        node.scene!.addChild(emitter)
    }
}
