import Brain
import SpriteKit

class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    var times = Times()
    var players = Set<Player>()
    let brain: Brain
    private(set) weak var wheel: Wheel!
    private(set) weak var others: Others!
    private(set) var state = State.start
    private weak var pointers: SKNode!
    private weak var hud: Hud!
    private weak var minimap: Minimap!
    private var drag: CGFloat?
    private var rotation = CGFloat()
    private let soundPlayer = SKAction.playSoundFileNamed("player", waitForCompletion: false)
    private let soundFoe = SKAction.playSoundFileNamed("foe", waitForCompletion: false)
    private let soundSpawn = SKAction.playSoundFileNamed("spawn", waitForCompletion: false)
    
    private var score = 0 {
        didSet {
            hud.counter(score)
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(radius: CGFloat) {
        profile.lastGame = .init()
        brain = .init(borders: .init(radius: radius), wheel: .init(delta: .pi / 30))
        super.init(frame: .zero)
        ignoresSiblingOrder = true
        
        let scene = SKScene()
        scene.delegate = self
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .background
        scene.physicsWorld.contactDelegate = self
        
        let wheel = Wheel()
        let borders = Borders(radius: radius)
        let hud = Hud()
        let minimap = Minimap(radius: radius)
        let others = Others()
        let pointers = SKNode()
        pointers.position.y = 100
        
        let camera = SKCameraNode()
        camera.setScale(5)
        camera.addChild(hud)
        camera.addChild(minimap)
        camera.addChild(others)
        camera.addChild(pointers)
        camera.addChild(wheel)
        
        scene.addChild(camera)
        scene.addChild(borders)
        scene.camera = camera
        
        self.hud = hud
        self.wheel = wheel
        self.minimap = minimap
        self.others = others
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
        
        gameReady()
    }
    
    final func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node.map(explode)
        contact.bodyB.node.map(explode)
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        update(times.delta(time))
    }
    
    final func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    final func align() {
        wheel.align()
        hud.align()
        minimap.align()
        others.align()
    }
    
    final func startPlayer(_ position: CGPoint, rotation: CGFloat) {
        let player = Player(line: .init(skin: profile.skin))
        player.position = position
        wheel.player = player
        wheel.zRotation = rotation
        pointers.zRotation = -rotation
        
        scene!.camera!.zRotation = rotation - (.pi / 2)
        scene!.camera!.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)), .distance(.init(upperLimit: 100), to: player)]
        scene!.addChild(player.line)
        scene!.addChild(player)

        scene!.camera!.run(.sequence([.scale(to: 1, duration: 2), .run { [weak self] in
            guard let self = self else { return }
            player.run(self.soundSpawn)
            self.state = .play
        }]))
        players.insert(player)
    }
    
    func gameReady() {
        
    }
    
    func update(_ delta: TimeInterval) {
        switch state {
        case .play, .died:
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
            if times.radar.timeout(delta) {
                radar()
            }
            if times.scoring.timeout(delta) {
                score += 1
            }
        default: break
        }
    }
    
    func gameOver(_ score: Int) {
        finish(score)
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
    
    private func explode(_ node: SKNode) {
        (node as? Player).map {
            $0.explode()
            if $0 === wheel.player {
                state = .died
                $0.run(soundPlayer)
                let label = SKLabelNode(text: .key("Game.over"))
                label.bold(30)
                label.alpha = 0
                label.fontColor = .text
                scene!.camera!.addChild(label)
                scene!.camera!.run(.scale(to: 10, duration: 6))
                wheel.alpha = 0
                pointers.alpha = 0
                
                label.run(.fadeIn(withDuration: 3)) { [weak self] in
                    self?.scene!.run(.fadeOut(withDuration: 2)) {
                        guard let score = self?.score else { return }
                        self?.gameOver(score)
                    }
                }
            } else {
                guard state == .play, let colour = wheel.player?.line.skin.colour else { return }
                if scene!.camera!.containedNodeSet().contains($0) {
                    $0.run(soundFoe)
                }
                
                score += 150
                let label = SKLabelNode(text: "150")
                label.bold(30)
                label.fontColor = colour
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .center
                label.position = $0.position
                label.alpha = 0
                label.zPosition = 4
                
                scene!.addChild(label)
                label.run(.sequence([.fadeIn(withDuration: 2), .fadeOut(withDuration: 3), .run {
                    label.removeFromParent()
                }]))
            }
        }
    }
}
