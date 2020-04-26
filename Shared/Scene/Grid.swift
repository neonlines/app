import Brain
import SpriteKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private(set) weak var player: Player!
    private weak var wheel: Wheel!
    private var rotation = CGFloat()
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
        camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 50), to: player)]
        camera.addChild(wheel)
        addChild(camera)
        addChild(borders)
        addChild(player.line)
        addChild(player)
        self.camera = camera
        self.player = player
        self.wheel = wheel
    }
    
    override func didMove(to: SKView) {
        wheel.align()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let player = contact.bodyB.node as? Player else { return }
        player.explode()
        if player === self.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
    
    func startRotating() {
        rotation = player.zRotation
    }
    
    func rotate(_ radians: CGFloat) {
        player.zRotation = rotation + radians
        wheel.zRotation = -player.zRotation
    }
    
    override func align() {
        wheel.align()
    }
}
