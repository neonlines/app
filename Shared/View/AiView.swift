import SpriteKit

final class AiView: View {
    private(set) weak var defeated: Defeated!
    
    private var counter = 0 {
        didSet {
            defeated.counter(counter)
        }
    }
    
    required init?(coder: NSCoder) { nil }
    override init(radius: CGFloat) {
        super.init(radius: radius)
        let defeated = Defeated()
        scene!.camera!.addChild(defeated)
        self.defeated = defeated
        
        startPlayer(certainPosition([]), rotation: randomRotation)
    }
    
    override func align() {
        super.align()
        defeated.align()
    }
    
    override func update(_ delta: TimeInterval) {
        super.update(delta)
        switch state {
        case .play:
            if times.foes.timeout(delta) {
                foes()
            }
            if times.spawn.timeout(delta) {
                spawn()
            }
        default: break
        }
    }
    
    override func explode(_ player: Player) {
        guard let colour = self.player?.line.skin.colour else { return }
        
        counter += 1
        let label = SKLabelNode(text: "+")
        label.bold(35)
        label.fontColor = colour
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = player.position
        label.alpha = 0
        label.zPosition = 4
        
        scene!.addChild(label)
        label.run(.sequence([.fadeIn(withDuration: 2), .fadeOut(withDuration: 3), .run {
            label.removeFromParent()
        }]))
    }
    
    override func gameOver() {
        gameOver(counter)
    }
    
    private func foes() {
        guard let player = self.player else { return }
        players.filter { $0.physicsBody != nil }.filter { $0 !== player }.forEach { foe in
            foe.zRotation = brain.orient(foe.position, current: foe.zRotation, player: player.position)
        }
    }
    
    private func spawn() {
        guard players.filter({ $0.physicsBody != nil }).count < 5, let position = brain.position(players.flatMap({ $0.line.points }), retry: 10) else { return }
        let skin: Skin.Id
        switch Int.random(in: 0 ... 4) {
        case 1: skin = .foe1
        case 2: skin = .foe2
        case 3: skin = .foe3
        case 4: skin = .foe4
        default: skin = .foe0
        }
        _ = spawn(position, rotation: randomRotation, skin: skin)
    }
}
