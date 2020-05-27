import SpriteKit

final class Player: SKNode {
    var id = -1
    private(set) weak var sprite: SKSpriteNode!
    let skin: Skin
    private weak var emitter: SKEmitterNode?
    private weak var line: Line!
    private weak var warp: SKShapeNode!
    private var chain = [Chain]()
    private let maxSpeed = CGFloat(500)
    private let length = 250
    
    private(set) var points = [CGPoint]() {
        didSet {
            line.path = {
                $0.addLines(between: points)
                return $0
            } (CGMutablePath())
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(skin: Skin) {
        self.skin = skin
        super.init()
        physicsBody = .init(circleOfRadius: 16)
        physicsBody!.affectedByGravity = false
        physicsBody!.collisionBitMask = .none
        physicsBody!.contactTestBitMask = .all
        physicsBody!.categoryBitMask = .player
        
        points.reserveCapacity(length)
        chain.reserveCapacity(length)
    }
    
    func prepare() {
        let sprite = SKSpriteNode(texture: .init(imageNamed: skin.texture))
        sprite.position = position
        sprite.zRotation = zRotation
        sprite.zPosition = 2
        scene!.addChild(sprite)
        self.sprite = sprite
        
        let warp = SKShapeNode(circleOfRadius: 60)
        warp.fillColor = skin.colour
        warp.lineWidth = 0
        warp.position = position
        scene!.addChild(warp)
        warp.run(.group([.fadeOut(withDuration: 2), .scale(to: 0.3, duration: 2)]))
        self.warp = warp
        
        let line = Line(color: skin.colour)
        scene!.addChild(line)
        self.line = line
    }
    
    func follow() {
        if physicsBody != nil {
            sprite.position = position
            sprite.zRotation = zRotation
            
            var points = self.points
            if points.count > length - 1 {
                points.removeFirst()
                chain.removeFirst().removeFromParent()
            }
            points.append(position)
            chain.append(.init(point: position))
            scene!.addChild(chain.last!)
            self.points = points
        } else {
            guard !points.isEmpty else {
                (scene!.view as! View).remove(self)
                line.removeFromParent()
                sprite.removeFromParent()
                chain.forEach { $0.removeFromParent() }
                removeFromParent()
                return
            }
            if points.count < length / 3 {
                emit()
            }
            let delta = points.count >= 5 ? 5 : points.count
            points.removeFirst(delta)
            chain.prefix(delta).forEach { $0.removeFromParent() }
            chain.removeFirst(delta)
        }
    }
    
    func move() {
        if physicsBody != nil {
            let dx = sin(zRotation)
            let dy = cos(zRotation)
            let speedY = (1 - abs(dx)) * maxSpeed
            let speedX = maxSpeed - speedY
            physicsBody!.velocity = .init(dx: dx * speedX, dy: dy * speedY)
            sprite.zRotation = zRotation
        }
    }
    
    func explode() {
        guard physicsBody != nil else { return }
        physicsBody = nil
        sprite.alpha = 0
        warp.position = position
        warp.alpha = 1
        warp.run(.sequence([.group([.fadeOut(withDuration: 2), .scale(to: 0.7, duration: 2)]), .removeFromParent()]))
    }
    
    func mine(_ node: SKNode?) -> Bool {
        node === chain.last
    }
    
    private func emit() {
        guard emitter == nil else { return }
        let emitter = SKEmitterNode()
        emitter.particleTexture = .init(imageNamed: "particle")
        emitter.particleSize = .init(width: 10, height: 10)
        emitter.particleBirthRate = 30
        emitter.emissionAngleRange = .pi * 2
        emitter.particleRotationRange = .pi * 2
        emitter.particleColor = skin.colour
        emitter.particleColorBlendFactor = 1
        emitter.particleSpeed = 25
        emitter.particleLifetime = 3
        emitter.numParticlesToEmit = 30
        emitter.particleAlphaSpeed = -0.1
        emitter.particleRotationSpeed = 0.5
        emitter.particlePosition = .zero
        emitter.particlePositionRange = .zero
        emitter.zPosition = 3
        emitter.position = points.last!
        scene!.addChild(emitter)
        emitter.run(.sequence([.wait(forDuration: 7), .removeFromParent()]))
        self.emitter = emitter
    }
}
