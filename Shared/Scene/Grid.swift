import Brain
import SpriteKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private weak var player: Player!
    private weak var wheel: Wheel!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private var rotation = CGFloat()
    private let brain: Brain
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        brain = .init(.init(radius: radius))
        super.init()
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        let player = Player(color: .white)
        let wheel = Wheel()
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 50), to: player)]
        camera.addChild(wheel)
        camera.addChild(hud)
        camera.addChild(minimap)
        
        addChild(camera)
        addChild(borders)
        addChild(player.line)
        addChild(player)
        self.camera = camera
        self.hud = hud
        self.player = player
        self.wheel = wheel
        self.minimap = minimap
    }
    
    override func didMove(to: SKView) {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let player = contact.bodyB.node as? Player else { return }
        player.explode()
        if player === self.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
    
    override func align() {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    override func startRotating() {
        rotation = player.zRotation
    }
    
    override func rotate(_ radians: CGFloat) {
        player.zRotation = rotation + radians
        wheel.zRotation = -player.zRotation
    }
    
    override func move() {
        player.move()
        minimap.clear()
        minimap.show(player.position, color: player.color)
    }
    
    override func recede() {
        player.recede()
    }
}
