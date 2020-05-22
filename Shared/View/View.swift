import Brain
import SpriteKit

class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    var times = Times()
    var players = Set<Player>()
    var state = State.start
    let brain: Brain
    
    private(set) var seconds = 0 {
        didSet {
            hud.counter(seconds)
        }
    }
    
    final var randomRotation: CGFloat { .random(in: 0 ..< .pi * 2) }
    private(set) weak var wheel: Wheel!
    private(set) weak var pointers: SKNode!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private var drag: CGFloat?
    private var rotation = CGFloat()
    private let soundCrash = SKAction.playSoundFileNamed("crash", waitForCompletion: false)
    private let soundSpawn = SKAction.playSoundFileNamed("spawn", waitForCompletion: false)
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        game.profile.lastGame = .init()
        brain = .init(borders: .init(radius: radius), wheel: .init(delta: .pi / 30))
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .white
        scene.physicsWorld.contactDelegate = self
        
        let wheel = Wheel()
        let borders = Borders(radius: radius)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        let pointers = SKNode()
        pointers.position.y = 100
        
        let camera = SKCameraNode()
        camera.setScale(5)
        camera.addChild(hud)
        camera.addChild(minimap)
        camera.addChild(pointers)
        camera.addChild(wheel)
        
        scene.addChild(camera)
        scene.addChild(borders)
        scene.camera = camera
        
        self.hud = hud
        self.wheel = wheel
        self.minimap = minimap
        self.pointers = pointers
        presentScene(scene)
        
        let track: String
        switch Int.random(in: 0 ... 3) {
        case 1: track = "fatal1"
        case 2: track = "fatal2"
        case 3: track = "fatal3"
        default: track = "fatal0"
        }
        let sound = SKAudioNode(fileNamed: track)
        sound.isPositional = false
        scene.addChild(sound)
    }
    
    final func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node.map(crash)
        contact.bodyB.node.map(crash)
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        update(times.delta(time))
    }
    
    final func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    final func startPlayer(_ position: CGPoint, rotation: CGFloat) {
        let player = spawn(position, rotation: rotation, skin: game.profile.skin)
        wheel.player = player
        wheel.zRotation = rotation
        pointers.zRotation = -rotation
        scene!.camera!.zRotation = rotation - (.pi / 2)
        scene!.camera!.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 100), to: player)]

        scene!.camera!.run(.sequence([.scale(to: 1, duration: 2), .run { [weak self] in
            guard let self = self else { return }
            player.run(self.soundSpawn)
            self.state = .play
        }]))
    }
    
    final func spawn(_ position: CGPoint, rotation: CGFloat, skin: Skin.Id) -> Player {
        let player = Player(line: .init(skin: skin))
        player.position = position
        player.zRotation = randomRotation
        scene!.addChild(player.line)
        scene!.addChild(player)
        players.insert(player)
        return player
    }
    
    final func certainPosition(_ positions: [CGPoint]) -> CGPoint {
        brain.position(positions, retry: 100_000)!
    }
    
    func align() {
        wheel.align()
        hud.align()
        minimap.align()
    }
    
    func update(_ delta: TimeInterval) {
        if times.radar.timeout(delta) {
            radar()
        }
        
        switch state {
        case .play, .died, .victory:
            if times.move.timeout(delta) {
                move()
            }
            if times.lines.timeout(delta) {
                lines()
            }
        default: break
        }
        
        switch state {
        case .play:
            if times.seconds.timeout(delta) {
                seconds += 1
            }
        default: break
        }
    }
    
    func gameOver() {
        
    }
    
    func beginMove(_ radians: CGFloat) {
        drag = radians
        rotation = wheel.zRotation
        wheel.on = true
    }
    
    func update(radians: CGFloat) {
        guard let drag = self.drag else {
            self.drag = nil
            self.wheel.on = false
            return
        }
        wheel.zRotation = rotation - (radians - drag)
        pointers.zRotation = -wheel.zRotation
    }
    
    func stop() {
        drag = nil
        wheel.on = false
    }
    
    func explode(_ player: Player) {

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
    
    private func radar() {
        guard let player = wheel.player else { return }
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
    
    private func crash(_ node: SKNode) {
        (node as? Player).map {
            $0.explode()
            guard state == .play else { return }
            
            if $0 === wheel.player {
                state = .died
                $0.run(soundCrash)
                let label = SKLabelNode(text: .key("Game.over"))
                label.bold(30)
                label.alpha = 0
                label.fontColor = .black
                scene!.camera!.addChild(label)
                scene!.camera!.run(.scale(to: 10, duration: 6))
                wheel.alpha = 0
                pointers.alpha = 0
                
                label.run(.fadeIn(withDuration: 3)) { [weak self] in
                    self?.scene!.run(.fadeOut(withDuration: 2)) {
                        self?.gameOver()
                    }
                }
            } else {
                if scene!.camera!.containedNodeSet().contains($0) {
                    $0.run(soundCrash)
                }
                explode($0)
            }
        }
    }
}
