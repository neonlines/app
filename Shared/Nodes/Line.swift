import SpriteKit

final class Line: SKShapeNode {
    private(set) var points = [CGPoint]() {
        didSet {
            path = {
                $0.addLines(between: self.points)
                return $0
            } (CGMutablePath())

//            let points = self.points.dropLast(6)
//            guard !points.isEmpty else { return }
//            physicsBody = .init(edgeChainFrom: {
//                $0.addLines(between: .init(points))
//                return $0
//            } (CGMutablePath()))
//            physicsBody!.collisionBitMask = .none
//            physicsBody!.contactTestBitMask = .player
//            physicsBody!.categoryBitMask = .line
        }
    }
    
    private weak var emitter: SKEmitterNode?
    
    let skin: Skin
    
    required init?(coder: NSCoder) { nil }
    init(skin: Skin.Id) {
        self.skin = .make(id: skin)
        super.init()
        lineWidth = 32
        lineCap = .round
        zPosition = 1
        strokeColor = self.skin.colour
        points.reserveCapacity(500)
    }
    
    func append(_ position: CGPoint) {
        points = (points + [position]).suffix(500)
    }
    
    func recede() {
        guard !points.isEmpty else {
            (scene!.view as! View).remove(self)
            return
        }
        if points.count < 250 {
            emit()
        }
        points.removeFirst(points.count >= 15 ? 15 : points.count)
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
        emitter.run(.wait(forDuration: 7)) {
            emitter.removeFromParent()
        }
        self.emitter = emitter
    }
}
