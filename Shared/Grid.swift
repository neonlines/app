import GameplayKit

final class Grid: Scene {
    private weak var player: Player!
    private var entities = Set<GKEntity>()
    
    override func didMove(to: SKView) {
        let player = Player()
        entities.insert(player)
        self.player = player
        
        let borders = SKNode()
        borders.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -1000, y: -1000, width: 2000, height: 2000))
        addChild(borders)
        
        let wheel = Wheel()
        entities.insert(wheel)
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player.sprite, offset: .init(constantValue: .pi / -2)),
                              .distance(.init(upperLimit: 150), to: player.sprite)]
        camera.addChild(wheel.sprite)
        addChild(camera)
        addChild(player.line)
        addChild(player.sprite)
        self.camera = camera
    }
    
    override func update(_ delta: TimeInterval) {
        entities.forEach { $0.update(deltaTime: delta) }
    }
    
    func startRotation() {
        player.startRotating()
    }
    
    func rotate(_ radians: CGFloat) {
        player.rotate(radians)
    }
}
