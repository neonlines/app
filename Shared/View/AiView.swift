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
        default: break
        }
    }
    
    override func explode(_ player: Player) {
        counter += 1
    }
    
    override func gameOver() {
        gameOver(counter)
    }
    
    private func foes() {
        guard let player = self.player else { return }
        let foes = players.filter { $0.physicsBody != nil }.filter { $0 !== player }
        foes.forEach { foe in
            foe.zRotation = brain.orient(foe.position, current: foe.zRotation, player: player.position)
        }
        guard foes.count < 4, let position = brain.position(players.flatMap({ $0.points })) else { return }
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
