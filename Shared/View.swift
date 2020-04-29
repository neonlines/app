import Brain
import SpriteKit

final class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    private var times = Times()
    private var drag: CGFloat?
    private var rotation = CGFloat()
    private weak var wheel: Wheel!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private weak var pointers: SKNode!
    private var players = Set<Player>()
    private let brain = Brain(borders: .init(radius: 5000), wheel: .init(delta: .pi / 90, speed: 300))
    override var mouseDownCanMoveWindow: Bool { true }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .windowBackgroundColor
        scene.physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: 5000)
        let player = Player(line: .init(color: .init(white: 0.85, alpha: 1)))
        let wheel = Wheel(player: player)
        let hud = Hud()
        let minimap = Minimap(radius: 5000)
        let pointers = SKNode()
        
        player.position = brain.position([])
        wheel.zRotation = .random(in: 0 ..< .pi * 2)
        pointers.zRotation = -wheel.zRotation
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 50), to: player)]
        camera.addChild(wheel)
        camera.addChild(hud)
        camera.addChild(minimap)
        camera.addChild(pointers)
        
        scene.addChild(camera)
        scene.addChild(borders)
        scene.addChild(player.line)
        scene.addChild(player)
        scene.camera = camera
        self.hud = hud
        self.wheel = wheel
        self.minimap = minimap
        self.pointers = pointers
        
        players.insert(player)
        
        presentScene(scene, transition: .crossFade(withDuration: 1.5))
        align()
        addFoe(.red)
        addFoe(.blue)
    }
    
    override func viewDidEndLiveResize() {
        align()
    }
    
    override func mouseDown(with: NSEvent) {
        let point = convert(with)
        if point.valid {
            drag = point.radians
            rotation = wheel.zRotation
        } else {
            drag = nil
        }
    }
    
    override func mouseDragged(with: NSEvent) {
        let point = convert(with)
        if point.valid {
            NSCursor.pointingHand.set()
            if let drag = self.drag {
                wheel.zRotation = rotation - (point.radians - drag)
                pointers.zRotation = -wheel.zRotation
            }
        } else {
            drag = nil
        }
    }
    
    override func mouseUp(with: NSEvent) {
        drag = nil
        NSCursor.arrow.set()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyB.node.flatMap { $0 as? Player }.map(explode)
        contact.bodyA.node.flatMap { $0 as? Player }.map(explode)
    }
    
    func update(_ time: TimeInterval, for: SKScene) {
        if times.last > 0 {
            let delta = time - times.last
            if times.move.timeout(delta) {
                move()
            }
            if times.foes.timeout(delta) {
                foes()
            }
        }
        times.last = time
    }
    
    func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    private func align() {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    private func move() {
        minimap.clear()
        pointers.children.forEach { $0.removeFromParent() }
        players.forEach {
            $0.move()
            guard $0.physicsBody != nil else { return }
            minimap.show($0.position, color: $0.line.strokeColor)
            
            guard !scene!.camera!.containedNodeSet().contains($0) else { return }
            var position = CGPoint(x: $0.position.x - wheel.player.position.x, y: $0.position.y - wheel.player.position.y)
            position.x = min(max(position.x, -100), 100)
            position.y = min(max(position.y, -100), 100)
            let pointer = Pointer(color: $0.line.strokeColor, position: position)
            pointers.addChild(pointer)
        }
    }
    
    private func foes() {
        players.forEach { player in
            guard player !== wheel.player else { return }
            player.zRotation = brain.orient(player.position, current: player.zRotation, players: players.filter { player !== $0 }.filter { $0.physicsBody != nil }.map(\.position))
        }
    }
    
    private func addFoe(_ color: SKColor) {
        let foe = Player(line: .init(color: color))
        foe.position = brain.position(players.filter { $0.physicsBody != nil }.flatMap { [$0.position] + $0.line.points })
        foe.color = foe.line.strokeColor
        foe.colorBlendFactor = 1
        foe.zRotation = .random(in: 0 ..< .pi * 2)
        scene!.addChild(foe.line)
        scene!.addChild(foe)
        players.insert(foe)
    }
    
    private func explode(_ player: Player) {
        player.explode()
        if player === wheel.player {
//            (view as! View).state.enter(GameOver.self)
        } else {
            addFoe(.green)
        }
    }
    
    private func convert(_ event: NSEvent) -> CGPoint {
        {
            .init(x: $0.x - frame.midX, y: $0.y - 60)
        } (convert(event.locationInWindow, from: nil))
    }
}

private extension CGPoint {
    var valid: Bool {
        let distance = pow(x, 2) + pow(y, 2)
        return distance > 900 && distance < 19_600
    }
    
    var radians: CGFloat {
        atan2(x, y)
    }
}

private struct Times {
    struct Item {
        private var current: TimeInterval
        private let max: TimeInterval
        
        init(_ max: TimeInterval) {
            self.max = max
            current = max
        }
        
        mutating func timeout(_ with: TimeInterval) -> Bool {
            current -= with
            guard current <= 0 else { return false }
            current = max
            return true
        }
    }
    
    var last = TimeInterval()
    var move = Item(0.02)
    var foes = Item(0.2)
}
