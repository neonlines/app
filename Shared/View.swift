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
    private let brain: Brain
    private let soundPlayer = SKAction.playSoundFileNamed("player", waitForCompletion: false)
    private let soundFoe = SKAction.playSoundFileNamed("foe", waitForCompletion: false)
    override var mouseDownCanMoveWindow: Bool { true }
    
    private var score = 0 {
        didSet {
            hud.counter(score)
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        brain = .init(borders: .init(radius: radius), wheel: .init(delta: .pi / 30))
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .windowBackgroundColor
        scene.physicsWorld.contactDelegate = self
        
        let borders = Borders(radius: radius)
        let player = Player(line: .init(skin: profile.skin))
        let wheel = Wheel(player: player)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        let pointers = SKNode()
        pointers.position.y = 100
        
        player.position = brain.position([])!
        wheel.zRotation = .random(in: 0 ..< .pi * 2)
        pointers.zRotation = -wheel.zRotation
        
        let camera = SKCameraNode()
        camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 100), to: player)]
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak scene] in
            let track: String
            switch Int.random(in: 0 ... 3) {
            case 1: track = "fatal1"
            case 2: track = "fatal2"
            case 3: track = "fatal3"
            default: track = "fatal0"
            }
            let sound = SKAudioNode(fileNamed: track)
            sound.isPositional = false
            scene?.addChild(sound)
        }
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
        wheel.on = true
        NSCursor.pointingHand.set()
    }
    
    override func mouseDragged(with: NSEvent) {
        guard let wheel = self.wheel, let radians = with.radians, let drag = self.drag else {
            self.drag = nil
            self.wheel?.on = false
            NSCursor.arrow.set()
            return
        }
        wheel.zRotation = rotation - (radians - drag)
        pointers.zRotation = -wheel.zRotation
    }
    
    override func mouseUp(with: NSEvent) {
        drag = nil
        wheel?.on = false
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
        if times.lines.timeout(delta) {
            lines()
        }
        if times.foes.timeout(delta) {
            foes()
        }
        if times.spawn.timeout(delta) {
            spawn()
        }
        if times.radar.timeout(delta) {
            radar()
        }
        if wheel != nil {
            if times.scoring.timeout(delta) {
                score += 1
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
        players.filter { $0.physicsBody != nil }.forEach {
            $0.move()
        }
    }
    
    private func lines() {
        players.forEach {
            $0.physicsBody == nil ? $0.line.recede() : $0.line.append($0.position)
        }
    }
    
    private func foes() {
        guard let player = wheel?.player else { return }
        players.filter { $0.physicsBody != nil }.filter { $0 !== player }.forEach { foe in
            foe.zRotation = brain.orient(foe.position, current: foe.zRotation, player: player.position)
        }
    }
    
    private func spawn() {
        guard players.filter({ $0.physicsBody != nil }).count < 6, let position = brain.position(players.flatMap({ $0.line.points })) else { return }
        let skin: Skin.Id
        switch Int.random(in: 0 ... 4) {
        case 1: skin = .foe1
        case 2: skin = .foe2
        case 3: skin = .foe3
        case 4: skin = .foe4
        default: skin = .foe0
        }
        let foe = Player(line: .init(skin: skin))
        foe.position = position
        foe.zRotation = .random(in: 0 ..< .pi * 2)
        scene!.addChild(foe.line)
        scene!.addChild(foe)
        players.insert(foe)
    }
    
    private func radar() {
        guard let player = wheel?.player else { return }
        minimap.clear()
        pointers.children.forEach { $0.removeFromParent() }
        players.filter { $0.physicsBody != nil }.forEach {
            minimap.show($0.position, color: $0.line.skin.colour)
            
            guard !scene!.camera!.containedNodeSet().contains($0) else { return }
            var position = CGPoint(x: $0.position.x - player.position.x, y: $0.position.y - player.position.y)
            let maxDelta = max(abs(position.x), abs(position.y)) / 100
            position.x = position.x / maxDelta
            position.y = position.y / maxDelta
            let pointer = Pointer(color: $0.line.skin.colour, position: position)
            pointers.addChild(pointer)
        }
    }
    
    private func explode(_ node: SKNode) {
        (node as? Player).map {
            $0.explode()
            if $0 === wheel?.player {
                $0.run(soundPlayer)
                wheel = nil
                let label = SKLabelNode(text: .key("Game.over"))
                label.fontSize = 20
                label.fontName = "bold"
                label.alpha = 0
                label.fontColor = .labelColor
                scene!.camera!.addChild(label)
                
                label.run(.fadeIn(withDuration: 3)) { [weak self] in
                    self?.scene!.run(.fadeOut(withDuration: 2)) {
                        guard let score = self?.score else { return }
                        self?.window!.show(Score(points: score))
                    }
                }
            } else if wheel != nil {
                if scene!.camera!.containedNodeSet().contains($0) {
                    $0.run(soundFoe)
                }
                
                score += 150
                let base = SKShapeNode(rect: .init(x: -30, y: -30, width: 60, height: 60), cornerRadius: 30)
                base.fillColor = wheel!.player.line.skin.colour
                base.lineWidth = 0
                base.alpha = 0
                base.zPosition = 4
                $0.addChild(base)
                
                let label = SKLabelNode(text: "150")
                label.fontSize = 18
                label.fontName = "bold"
                label.fontColor = .black
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .center
                base.addChild(label)
                base.run(.sequence([.fadeIn(withDuration: 3), .wait(forDuration: 2), .fadeOut(withDuration: 1)]))
            }
        }
    }
}

private extension NSEvent {
    var radians: CGFloat? {
        {
            let point = CGPoint(x: $0.x - window!.contentView!.frame.midX, y: $0.y - 140)
            guard point.valid else { return nil }
            return point.radians
        } (window!.contentView!.convert(locationInWindow, from: nil))
    }
}

private extension CGPoint {
    var valid: Bool {
        let distance = pow(x, 2) + pow(y, 2)
        return distance > 50 && distance < 19_600
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
    
    var move = Item(0.05)
    var lines = Item(0.02)
    var foes = Item(0.02)
    var spawn = Item(0.05)
    var radar = Item(0.5)
    var scoring = Item(1.5)
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
