import GameplayKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private weak var player: Player!
    private var entities = Set<GKEntity>()
    
    override func didMove(to: SKView) {
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: 500)
        borders.node.physicsBody?.categoryBitMask = 0b0001
        borders.node.physicsBody?.contactTestBitMask = 0b1000
        entities.insert(borders)
        
        let player = Player()
        player.node.physicsBody?.categoryBitMask = 0b1000
        player.node.physicsBody?.collisionBitMask = 0
        player.line.physicsBody?.categoryBitMask = 0b0010
        player.line.physicsBody?.contactTestBitMask = 0b1000
        player.line.physicsBody?.collisionBitMask = 0
        entities.insert(player)
        self.player = player
        
        let wheel = Wheel()
        entities.insert(wheel)
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player.node, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 150), to: player.node)]
        camera.addChild(wheel.node)
        addChild(camera)
        addChild(borders.node)
        addChild(player.line)
        addChild(player.node)
        self.camera = camera
    }
    
    override func update(_ delta: TimeInterval) {
        entities.forEach { $0.update(deltaTime: delta) }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact)
        assert(contact.bodyA.node !== player.node)
        assert(contact.bodyB.node !== player.node)
    }
    
    func startRotation() {
        player.startRotating()
    }
    
    func rotate(_ radians: CGFloat) {
        player.rotate(radians)
    }
}
