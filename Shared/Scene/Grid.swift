import GameplayKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private weak var player: Player!
    private var entities = Set<GKEntity>()
    
    override func didMove(to: SKView) {
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: 500)
        entities.insert(borders)
        
        let player = Player()
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
        let player = contact.bodyB.node!.entity as! Player
        guard contact.bodyA.node?.entity != player else { return }
        player.explode()
    }
    
    func startRotation() {
        player.startRotating()
    }
    
    func rotate(_ radians: CGFloat) {
        player.rotate(radians)
    }
}
