import SpriteKit

class AiView: View {
    override func update(_ delta: TimeInterval) {
        super.update(delta)
        if times.foes.timeout(delta) {
            foes()
        }
        if times.spawn.timeout(delta) {
            spawn()
        }
    }
    
    private func foes() {
        guard let player = wheel?.player else { return }
        players.filter { $0.physicsBody != nil }.filter { $0 !== player }.forEach { foe in
            foe.zRotation = brain.orient(foe.position, current: foe.zRotation, player: player.position)
        }
    }
    
    private func spawn() {
        guard players.filter({ $0.physicsBody != nil }).count < 5, let position = brain.position(players.flatMap({ $0.line.points })) else { return }
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
}
