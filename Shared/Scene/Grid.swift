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
        brain = .init(borders: .init(radius: radius), wheel: .init(delta: .pi / 10, speed: 300))
        super.init()
        physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        let player = Player(line: .init(grid: self, color: .init(white: 0.85, alpha: 1)))
        let wheel = Wheel(player: player)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        let pointers = SKNode()
        
        player.position = brain.position([])
        wheel.zRotation = -.pi
        wheel.zRotation = .random(in: 0 ..< .pi * 2)
        
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
            $0.move()
            guard $0.physicsBody != nil else { return }
            minimap.show($0.position, color: $0.line.strokeColor)
            
            guard !camera!.containedNodeSet().contains($0) else { return }
            var position = CGPoint(x: $0.position.x - wheel.player.position.x, y: $0.position.y - wheel.player.position.y)
            position.x = min(max(position.x, -100), 100)
            position.y = min(max(position.y, -100), 100)
            let pointer = Pointer(color: $0.line.strokeColor, position: position)
            pointers.addChild(pointer)
        }
    }
    
    override func foes() {
        players.forEach { player in
            guard player !== wheel.player else { return }
            player.zRotation = brain.orient(player.position, current: player.zRotation, players: players.filter { player !== $0 }.map(\.position))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyB.node.flatMap { $0 as? Player }.map(explode)
        contact.bodyA.node.flatMap { $0 as? Player }.map(explode)
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
    
    private func explode(_ player: Player) {
        player.explode()
        if player === wheel.player {
            (view as! View).state.enter(GameOver.self)
        }
    }
}
