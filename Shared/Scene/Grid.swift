import Brain
import GameplayKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private(set) weak var player: Player!
    private weak var wheel: Wheel!
    private let brain: Brain
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        brain = .init(.init(radius: radius))
        super.init()
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        let player = Player()
        let wheel = Wheel()
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player.node, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 150), to: player.node)]
        camera.addChild(wheel)
        addChild(camera)
        addChild(borders)
        addChild(player.line)
        addChild(player.node)
        self.camera = camera
        self.player = player
        self.wheel = wheel
    }
    
    override func didMove(to: SKView) {
        wheel.align()
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
        wheel.rotate(radians)
    }
    
    override func align() {
        wheel.align()
    }
}
