import Brain
import SpriteKit

class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    var times = Times()
    var players = Set<Player>()
    var state = State.start
    let brain: Brain
    private(set) weak var player: Player?
    
    private(set) var seconds = 0 {
        didSet {
            hud.counter(seconds)
        }
    }
    
    final var randomRotation: CGFloat { .random(in: 0 ..< .pi * 2) }
    private(set) weak var wheel: Wheel!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private var drag: CGFloat?
    private let soundCrash = SKAction.playSoundFileNamed("crash", waitForCompletion: false)
    private let soundSpawn = SKAction.playSoundFileNamed("spawn", waitForCompletion: false)
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        game.profile.lastGame = .init()
        brain = .init(borders: .init(radius: radius), wheel: .init(delta: .pi / 30))
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        showsNodeCount = true
        showsDrawCount = true
        showsFPS = true
        
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .init(white: 0.95, alpha: 1)
        scene.physicsWorld.contactDelegate = self
        scene.physicsWorld.gravity = .zero
        
        let wheel = Wheel()
        let borders = Borders(radius: radius)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        let pointers = SKNode()
        pointers.position.y = 100
        
        let camera = SKCameraNode()
        camera.setScale(3)
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
        contact.bodyA.node.map {
            crash($0, other: contact.bodyB.node)
        }
        contact.bodyB.node.map {
            crash($0, other: contact.bodyA.node)
        }
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        update(times.delta(time))
    }
    
    final func remove(_ player: Player) {
        players.remove(player)
    }
    
    final func startPlayer(_ position: CGPoint, rotation: CGFloat) {
        let player = spawn(position, rotation: rotation, skin: game.profile.skin)
        self.player = player
        wheel.zRotation = -rotation
        scene!.camera!.constraints = [.distance(.init(upperLimit: 0), to: player.sprite)]

        scene!.camera!.run(.sequence([.scale(to: 1, duration: 2), .run { [weak self] in
            guard let self = self else { return }
            player.run(self.soundSpawn)
            self.state = .play
        }]))
    }
    
    final func spawn(_ position: CGPoint, rotation: CGFloat, skin: Skin.Id) -> Player {
        let player = Player(skin: .make(id: skin))
        player.position = position
        player.zRotation = rotation
        scene!.addChild(player)
        player.prepare()
        players.insert(player)
        return player
    }
    
    final func certainPosition(_ positions: [CGPoint]) -> CGPoint {
        brain.position(positions, retry: 100_000)!
    }
    
    final func beginMove(_ radians: CGFloat) {
        drag = wheel.zRotation + radians
        wheel.on = true
    }
    
    final func update(radians: CGFloat) {
        guard let drag = self.drag else {
            self.drag = nil
            self.wheel.on = false
            return
        }
        wheel.zRotation = drag - radians
    }
    
    final func stop() {
        drag = nil
        wheel.on = false
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
            if times.follow.timeout(delta) {
                follow()
            }
            if times.move.timeout(delta) {
                move()
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
    
    func explode(_ player: Player) {

    }
    
    func rotated() {
        
    }
    
    private func follow() {
        players.forEach {
            $0.follow()
        }
    }
    
    private func move() {
        if state == .play && player?.zRotation != -wheel.zRotation {
            player?.zRotation = -wheel.zRotation
            rotated()
        }
        
        players.forEach {
            $0.move()
        }
    }
    
    private func radar() {
        minimap.clear()
        players.filter { $0.physicsBody != nil }.forEach {
            minimap.show($0.position, color: $0.skin.colour, me: $0 === player)
        }
    }
    
    private func crash(_ node: SKNode, other: SKNode?) {
        guard let player = node as? Player, !player.mine(other) else { return }
        player.explode()
        guard state == .play else { return }
        
        if player === self.player {
            state = .died
            player.run(soundCrash)
            let label = SKLabelNode(text: .key("Game.over"))
            label.bold(50)
            label.alpha = 0
            label.fontColor = .init(white: 0, alpha: 0.5)
            label.zPosition = 30
            scene!.camera!.addChild(label)
            scene!.camera!.position = player.position
            scene!.camera!.constraints = nil
            scene!.camera!.run(.scale(to: 5, duration: 10))
            wheel.alpha = 0
            
            label.run(.fadeIn(withDuration: 4)) { [weak self] in
                self?.scene!.run(.fadeOut(withDuration: 3)) {
                    self?.gameOver()
                }
            }
        } else {
            if scene!.camera!.containedNodeSet().contains(player) {
                player.run(soundCrash)
            }
            explode(player)
        }
    }
}
