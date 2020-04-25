import Brain
import GameplayKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private(set) weak var player: Player!
    private weak var wheel: Wheel!
    private var entities = Set<GKEntity>()
    private let brain: Brain
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        brain = .init(.init(radius: radius))
        super.init()
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        entities.insert(borders)
        
        let player = Player()
        entities.insert(player)
        self.player = player
        
        let wheel = Wheel()
        entities.insert(wheel)
        self.wheel = wheel
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player.node, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 150), to: player.node)]
        camera.addChild(wheel.node)
        addChild(camera)
        addChild(borders.node)
        addChild(player.line)
        addChild(player.node)
        self.camera = camera
    }
    
    override func didMove(to: SKView) {
        wheel.align()
    }
    
    override func update(_ delta: TimeInterval) {
        entities.forEach { $0.update(deltaTime: delta) }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let player = contact.bodyB.node?.entity as? Player else { return }
        player.explode()
        if player === self.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
    
    func startRotation() {
        player.startRotating()
    }
    
    func rotate(_ radians: CGFloat) {
        player.rotate(radians)
    }
    
    override func align() {
        wheel.align()
    }
}
