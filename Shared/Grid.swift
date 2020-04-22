import GameplayKit

final class Grid: Scene {
    private weak var player: Player!
    private var entities = Set<GKEntity>()
    
    override func didMove(to: SKView) {
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
    
    func startRotation() {
        player.startRotating()
    }
    
    func rotate(_ radians: CGFloat) {
        player.rotate(radians)
    }
}
