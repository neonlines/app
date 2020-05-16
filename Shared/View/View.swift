import Brain
import SpriteKit

class View: SKView, SKSceneDelegate, SKPhysicsContactDelegate {
    var times = Times()
    var players = Set<Player>()
    let brain: Brain
    private(set) weak var wheel: Wheel?
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
        
        scene.addChild(camera)
        scene.addChild(borders)
        scene.camera = camera
        self.hud = hud
        
        self.minimap = minimap
        self.pointers = pointers
        presentScene(scene)
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.start()
        }
    }
    
    final func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node.map(explode)
        contact.bodyB.node.map(explode)
    }
    
    func start() {
        let player = Player(line: .init(skin: profile.skin))
        let wheel = Wheel(player: player)
        player.position = brain.position([])!
        wheel.zRotation = .random(in: 0 ..< .pi * 2)
        pointers.zRotation = -wheel.zRotation
        
        scene!.camera!.run(.scale(to: 1, duration: 5))
        scene!.camera!.addChild(wheel)
        scene!.addChild(player.line)
        scene!.addChild(player)
        
        self.wheel = wheel
        players.insert(player)
        wheel.align()
        
        player.run(soundSpawn)
        scene!.camera!.run(.sequence([
            .group([.rotate(toAngle: -player.zRotation, duration: 3),
                    .move(to: player.position, duration: 1)]), .run { [weak self, weak player] in
            guard let camera = self?.scene?.camera, let player = player else { return }
            camera.constraints = [.orient(to: player, offset: .init(constantValue: .pi / -2)),
                                  .distance(.init(upperLimit: 100), to: player)]
        }]))
    }
    
    final func update(_ time: TimeInterval, for: SKScene) {
        update(times.delta(time))
    }
    
    final func remove(_ line: Line) {
        players.remove(at: players.firstIndex { $0.line === line }!).remove()
    }
    
    final func align() {
        wheel?.align()
        hud.align()
        minimap.align()
    }
    
    func update(_ delta: TimeInterval) {
        if times.move.timeout(delta) {
            move()
        }
        if times.lines.timeout(delta) {
            lines()
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
    
    open func gameOver(_ score: Int) {
        finish(score)
    }
    
    func beginMove(radians: CGFloat) {
        guard let wheel = self.wheel else {
            drag = nil
            return
        }
        drag = radians
        rotation = wheel.zRotation
        wheel.on = true
    }
    
    func update(radians: CGFloat) {
        guard let wheel = self.wheel, let drag = self.drag else {
            self.drag = nil
            self.wheel?.on = false
            return
        }
        wheel.zRotation = rotation - (radians - drag)
        pointers.zRotation = -wheel.zRotation
    }
    
    func stop() {
        drag = nil
        wheel?.on = false
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
                label.bold(20)
                label.alpha = 0
                label.fontColor = .text
                scene!.camera!.addChild(label)
                scene!.camera!.run(.scale(to: 10, duration: 6))
                
                label.run(.fadeIn(withDuration: 3)) { [weak self] in
                    self?.scene!.run(.fadeOut(withDuration: 2)) {
                        guard let score = self?.score else { return }
                        self?.gameOver(score)
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
                label.bold(18)
                label.fontColor = .black
                label.verticalAlignmentMode = .center
                label.horizontalAlignmentMode = .center
                base.addChild(label)
                base.run(.sequence([.fadeIn(withDuration: 3), .wait(forDuration: 2), .fadeOut(withDuration: 1)]))
            }
        }
    }
}
