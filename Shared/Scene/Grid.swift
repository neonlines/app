import Brain
import SpriteKit

final class Grid: Scene, SKPhysicsContactDelegate {
    private weak var wheel: Wheel!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private weak var pointers: SKNode!
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
        let pointers = SKNode()
        
        player.position = brain.position([])
//        wheel.zRotation = .random(in: 0 ..< .pi * 2)
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 50), to: player)]
        camera.addChild(wheel)
        camera.addChild(hud)
        camera.addChild(minimap)
        camera.addChild(pointers)
        
        addChild(camera)
        addChild(borders)
        addChild(player.line)
        addChild(player)
        self.camera = camera
        self.hud = hud
        self.wheel = wheel
        self.minimap = minimap
        self.pointers = pointers
        
        players.insert(player)
        
        addFoe(.red)
        addFoe(.blue)
    }
    
    override func didMove(to: SKView) {
        wheel.align()
        hud.align()
        minimap.align()
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
        pointers.zRotation = -wheel.zRotation
    }
    
    override func move() {
        minimap.clear()
        pointers.children.forEach { $0.removeFromParent() }
        players.forEach {
            minimap.show($0.position, color: $0.line.strokeColor)
            guard !camera!.containedNodeSet().contains($0) else {
                $0.move()
            return }
            var position = CGPoint(x: $0.position.x - wheel.player.position.x, y: $0.position.y - wheel.player.position.y)
            position.x = min(max(position.x, -100), 100)
            position.y = min(max(position.y, -100), 100)
            let pointer = Pointer(color: $0.line.strokeColor, position: position)
            pointers.addChild(pointer)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let player = contact.bodyB.node as? Player else { return }
        player.explode()
        if player === wheel.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
    
    func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    private func addFoe(_ color: SKColor) {
        let foe = Player(line: .init(grid: self, color: color))
        foe.position = brain.position([])
        foe.color = foe.line.strokeColor
        foe.colorBlendFactor = 1
        addChild(foe.line)
        addChild(foe)
        players.insert(foe)
    }
}
