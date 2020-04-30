import Brain
import SpriteKit

final class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    private weak var wheel: Wheel?
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private weak var pointers: SKNode!
    private var drag: CGFloat?
    private var rotation = CGFloat()
    private var times = Times()
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
        presentScene(scene)
        
        players.insert(player)
        addFoe(.red)
        addFoe(.blue)
    }
    
    override func viewDidMoveToWindow() {
        align()
    }
    
    override func viewDidEndLiveResize() {
        align()
    }
    
    override func mouseDown(with: NSEvent) {
        guard let wheel = self.wheel, let radians = with.radians else {
            drag = nil
            return
        }
        drag = radians
        rotation = wheel.zRotation
    }
    
    override func mouseDragged(with: NSEvent) {
        guard let wheel = self.wheel, let radians = with.radians, let drag = self.drag else {
            self.drag = nil
            return
        }
        NSCursor.pointingHand.set()
        wheel.zRotation = rotation - (radians - drag)
        pointers.zRotation = -wheel.zRotation
    }
    
    override func mouseUp(with: NSEvent) {
        drag = nil
        NSCursor.arrow.set()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node.map(explode)
        contact.bodyB.node.map(explode)
    }
    
    func update(_ time: TimeInterval, for: SKScene) {
        let delta = times.delta(time)
        if times.move.timeout(delta) {
            move()
        }
        if times.foes.timeout(delta) {
            foes()
        }
        if times.spawn.timeout(delta) {
            if Int.random(in: 0 ... 20) == 0 {
                addFoe(.green)
            }
        }
    }
    
    func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    private func align() {
        wheel?.align()
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
            
            guard !scene!.camera!.containedNodeSet().contains($0), let player = wheel?.player else { return }
            var position = CGPoint(x: $0.position.x - player.position.x, y: $0.position.y - player.position.y)
            position.x = min(max(position.x, -100), 100)
            position.y = min(max(position.y, -100), 100)
            let pointer = Pointer(color: $0.line.strokeColor, position: position)
            pointers.addChild(pointer)
        }
    }
    
    private func foes() {
        guard let player = wheel?.player else { return }
        players.filter { $0 !== player }.forEach { foe in
            foe.zRotation = brain.orient(foe.position, current: foe.zRotation, players: [player.position])
        }
    }
    
    private func addFoe(_ color: SKColor) {
        let foe = Player(line: .init(color: color))
        foe.position = brain.position(players.filter { $0.physicsBody != nil }.flatMap { $0.line.points })
        foe.color = foe.line.strokeColor
        foe.colorBlendFactor = 1
        foe.zRotation = .random(in: 0 ..< .pi * 2)
        scene!.addChild(foe.line)
        scene!.addChild(foe)
        players.insert(foe)
    }
    
    private func explode(_ node: SKNode) {
        (node as? Player).map {
            $0.explode()
            if $0 === wheel?.player {
                wheel = nil
                let label = SKLabelNode(text: .key("Game.over"))
                label.fontSize = 30
                label.fontName = "bold"
                label.alpha = 0
                scene!.camera!.addChild(label)
                
                label.run(.sequence([.fadeIn(withDuration: 3)])) { [weak self] in
                    self?.scene!.run(.fadeOut(withDuration: 3)) {
                        self?.window?.show(Launch())
                    }
                }
            }
        }
    }
}

private extension NSEvent {
    var radians: CGFloat? {
        {
            let point = CGPoint(x: $0.x - window!.contentView!.frame.midX, y: $0.y - 60)
            guard point.valid else { return nil }
            return point.radians
        } (window!.contentView!.convert(locationInWindow, from: nil))
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
    
    var move = Item(0.02)
    var foes = Item(0.04)
    var spawn = Item(0.5)
    private var last = TimeInterval()
    
    mutating func delta(_ time: TimeInterval) -> TimeInterval {
        guard last > 0 else {
            last = time
            return 0
        }
        let delta = time - last
        last = time
        return delta
    }
}
