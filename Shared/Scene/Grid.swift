import Brain
import SpriteKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private weak var wheel: Wheel!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private var players = Set<Player>()
    private var rotation = CGFloat()
    private let brain: Brain
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        brain = .init(.init(radius: radius))
        super.init()
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        let player = Player(line: .init(grid: self, color: .init(white: 0.85, alpha: 1)))
        let wheel = Wheel(player: player)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        
//        player.position = brain.position([])
//        player.zRotation = .pi
        
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
        self.wheel = wheel
        self.minimap = minimap
        
        players.insert(player)
    }
    
    override func didMove(to: SKView) {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let player = contact.bodyB.node as? Player else { return }
        player.explode()
        if player === wheel.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
    
    override func align() {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    override func startRotating() {
        rotation = wheel.zRotation
    }
    
    override func rotate(_ radians: CGFloat) {
        wheel.zRotation = rotation - radians
    }
    
    override func move() {
        minimap.clear()
        players.forEach {
            $0.move()
            minimap.show($0.position, color: $0.color)
        }
    }
    
    func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
}
