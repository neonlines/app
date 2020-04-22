import GameplayKit

private let size = CGFloat(32)
private let maxSpeed = CGFloat(500)
private let maxPoints = 500

final class Player: GKEntity {
    let sprite = SKSpriteNode(texture: .init(imageNamed: "node"), size: .init(width: size, height: size))
    let line = SKShapeNode()
    private var timer = TimeInterval()
    private var velocity = CGVector(dx: 0, dy: maxSpeed)
    private var linePoints = [CGPoint]()
    private var rotateOrigin = CGFloat()
    private var radians = CGFloat()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        sprite.color = .white
        sprite.colorBlendFactor = 1
        sprite.physicsBody = .init(circleOfRadius: size / 2)
        sprite.physicsBody!.affectedByGravity = false
        
        line.lineWidth = size / 2
        line.lineCap = .round
        line.strokeColor = .init(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        
        linePoints.reserveCapacity(maxPoints)
    }

    override func update(deltaTime: TimeInterval) {
        timer -= deltaTime
        if timer <= 0 {
            timer = 0.02
            linePoints.append(sprite.position)
            if linePoints.count > maxPoints {
                linePoints = linePoints.suffix(maxPoints)
            }
            line.path = {
                $0.addLines(between: linePoints)
                return $0
            } (CGMutablePath())
            sprite.physicsBody!.velocity = velocity
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
        sprite.zRotation = self.radians
    }
}
